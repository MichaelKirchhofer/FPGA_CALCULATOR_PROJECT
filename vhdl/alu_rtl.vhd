-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: alu_rtl.vhd
--
-- Date of Creation: 09.05.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 09.05.2022
--
-- Design Unit: Arithmetic Logic Unit (Architecture)
--
-- Description: The ALU handles the artihmetic operations and their 
-- calculation, as well as the indication handling for the calculator control
-- unit if the number is overflowing or negative
-------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of alu is

	-- clock countdown
	constant MAX_COUNT 	: integer := (50000-1);
	constant MAX_UNS_VAL: integer := (65535);
	
	signal s_finished	: std_logic;
	signal s_sign		: std_logic;
	signal s_overflow 	: std_logic;
	signal s_error 		: std_logic;
	signal s_1khzen 	: std_logic;
	signal s_op_performed	: std_logic := '0';
	
	signal s_op1 : unsigned (11 downto 0) := (others => '0');
	signal s_op2 : unsigned (11 downto 0) := (others => '0');
	signal s_result 	: std_logic_vector (15 downto 0);
	signal s_op_result  : unsigned (15 downto 0):=(others => '0');
	signal s_overflow_counter : unsigned (15 downto 0);
	
	signal s_mult_counter 	: integer;
	signal s_index			: integer;
	
	
	
	type t_calculation_state is (OP_WAITING,OP_RUNNING,OP_FINISHED);

	signal s_calc_state : t_calculation_state;
	
begin
	
	-----------------------------------------------------------------------------
	--
	-- ALU Operation process / fsm
	--
	-----------------------------------------------------------------------------
	
	p_alu_ctrl: process (s_1khzen, reset_i)
	
	begin 
	
		if reset_i = '1' then
		
			s_finished	<= '0';
			s_result 	<= (others => '0');
			s_sign		<= '0';	
			s_overflow 	<= '0';
		    s_error 	<= '0';
			s_index		<= 0;
			s_calc_state <= OP_WAITING;
			
			s_op1 <= (others => '0');
			s_op2 <= (others => '0');
			
		elsif s_1khzen'event and s_1khzen = '1' then
			
			case s_calc_state is
			
				when OP_WAITING =>
				-- Reset signals to zero
				s_finished 	<= '0';
				s_sign		<= '0';	
				s_overflow 	<= '0';
				s_error 	<= '0';
				
				-- Load operation parameters
				if start_i = '1' then
				
					s_op1 <= unsigned(op1_i);
					s_op2 <= unsigned(op2_i);
					s_mult_counter <= to_integer(unsigned(op2_i));
					s_index		<= 0;
					s_op_performed <= '0';
					s_calc_state <= OP_RUNNING;
					s_op_result <= (others => '0');
				
				end if;
				
				when OP_RUNNING =>
					
					if s_op_performed = '0' then
					
						case optype_i is
						
						-- Substraction
						when "0001" =>
							
							if s_op1 > s_op2 then
								s_op_result(11 downto 0) <= s_op1 - s_op2;
								s_sign <= '0';
								s_op_performed <= '1';
							elsif s_op1 = s_op2 then
								s_op_result <= (others => '0');
								s_sign <= '0';
								s_op_performed <= '1';
							else
								s_op_result(11 downto 0) <= s_op1 - s_op2;
								s_op_result <= not s_op_result;
								s_op_result <= s_op_result + 1;
								s_sign <= '1';
								s_op_performed <= '1';
							end if;	
							
							s_error <= '0';
							s_overflow <= '0';	
	
						-- Multiplication
						when "0010" =>
							
							if s_mult_counter > 0 then
							
								s_overflow_counter <= MAX_UNS_VAL - s_op_result;
								
								if s_overflow_counter < s_op1 then
									s_mult_counter <= 0;
									s_overflow <= '1';
									s_error <= '0';
									s_sign <= '0';
								else
									s_op_result <= s_op_result + s_op1;
									s_mult_counter <= s_mult_counter - 1;
									s_calc_state <= OP_RUNNING;
								end if;
							
							else
								s_op_performed <= '1';
							end if;
							
						-- Shift Left
						when "1100" =>
						
							s_op_result(11 downto 0) <= s_op1(10 downto 0) & s_op1 (11);
							s_error <= '0'; 
							s_overflow <= '0';
							s_sign <= '0';
							s_op_performed <= '1';
						
						-- Logical And
						when "1001" =>
						
							s_op_result(11 downto 0) <= unsigned((op1_i and op2_i));
							s_op_performed <= '1';
							
						when others =>
						
							s_error <= '1';
							s_op_performed <= '1';
							
						end case;
					else
					
						s_result <= std_logic_vector(s_op_result);
						s_calc_state <= OP_FINISHED;
						
					end if;
				when OP_FINISHED =>
				
					s_finished <= '1';
					s_calc_state <= OP_WAITING;
					
				when others =>
				
					s_finished <= '1';
					s_error <= '1';
					
				end case;
			
		end if;
	
	end process p_alu_ctrl;
	
	-----------------------------------------------------------------------------
	--
	-- Generate 1 kHz enable signal.
	--
	-----------------------------------------------------------------------------
	p_slowen: process (clk_i, reset_i)
	
	variable v_clk_edge_count : integer range 0 to MAX_COUNT-1 := 0;
	
	begin
		
		if reset_i = '1' then -- asynchronous reset (active high)
		
			s_1khzen <= '0';
			v_clk_edge_count := 0;
			
		elsif clk_i'event and clk_i = '1' then
			
			--Theoretically, 50000-1 clock ticks with 100Mhz Clock should equal a enable signal every 1ms 
			if v_clk_edge_count < MAX_COUNT-1 then
				v_clk_edge_count := v_clk_edge_count + 1;
				s_1khzen <= '0';
			else
				s_1khzen <= '1';
				v_clk_edge_count := 0;
			end if;
			
		end if;
	end process p_slowen;
	
	-- map pin to signal
	finished_o <= s_finished;
	result_o <= s_result;
	sign_o <= s_sign;
	overflow_o <= s_overflow;
	error_o	<= s_error;
	
end rtl;
