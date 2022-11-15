-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: calc_ctrl_rt1.vhd
--
-- Date of Creation: 26.04.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 26.04.2022
--
-- Design Unit: Calculator Control Unit (Architecture)
--
-- Description: The Calc_Ctrl handles the operands given by the IO control and
-- it provides the ALU with the to be computed instructions. Furthermore, it 
-- handles the output from the ALU and forwards its returns to the IO unit.
-------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;

architecture rtl of calc_ctrl is

	-- Operations to be performed: sub, mult, logical and, rotate left
	
	constant MAX_COUNT : integer := (50000-1);
	
	-- Error state LED switch duration
	constant MAX_DISP_DURATION : integer := (10000);
	
	signal s_1khzen : std_logic;					 -- enable signal every 1 ms
	signal s_enable_state_switching : std_logic;
	
	signal s_optype_o : std_logic_vector (3 downto 0);
	signal s_op1 : std_logic_vector (11 downto 0);
	signal s_op2 : std_logic_vector (11 downto 0);
	signal s_led_o : std_logic_vector (15 downto 0);
	signal s_start_o : std_logic;
	signal s_dig0	: std_logic_vector (7 downto 0);
	signal s_dig1	: std_logic_vector (7 downto 0);
	signal s_dig2	: std_logic_vector (7 downto 0);
	signal s_dig3	: std_logic_vector (7 downto 0);
	
	signal s_err_countdown : integer range 0 to MAX_DISP_DURATION-1 := 0;
	signal s_switch : integer range 0  to 500;
	
	
	type t_calculation_state is (OP_1,OP_2,OP_CODE,OP_RUNNING,OP_ERROR);

	signal s_calc_state : t_calculation_state;
	
	begin
	
	-----------------------------------------------------------------------------
	--
	-- Calculator FSM process
	--
	-----------------------------------------------------------------------------
	
	p_calc_ctrl_process : process(s_1khzen,reset_i)
		
		function f_decode_bcd ( v_numb_i : in std_logic_vector(3 downto 0))
	
		return std_logic_vector is variable v_numb_o : std_logic_vector (7 downto 0);
	
		begin
			case v_numb_i is
			
				when "0000" => v_numb_o := "11000000"; -- 0
				when "0001" => v_numb_o := "11111001"; -- 1
				when "0010" => v_numb_o := "10100100"; -- 2
				when "0011" => v_numb_o := "10110000"; -- 3
				when "0100" => v_numb_o := "10011001"; -- 4
				when "0101" => v_numb_o := "10010010"; -- 5
				when "0110" => v_numb_o := "10000010"; -- 6
				when "0111" => v_numb_o := "11111000"; -- 7
				when "1000" => v_numb_o := "10000000"; -- 8
				when "1001" => v_numb_o := "10010000"; -- 9
				when "1010" => v_numb_o := "10001000"; -- a
				when "1011" => v_numb_o := "10000011"; -- b
				when "1100" => v_numb_o := "11000110"; -- c
				when "1101" => v_numb_o := "10100001"; -- d
				when "1110" => v_numb_o := "10000110"; -- e
				when "1111" => v_numb_o := "10001110"; -- f
				when others => v_numb_o := "11000000"; -- 0
			
			end case;
		return v_numb_o; 
		end function f_decode_bcd;
		
		
		
		begin
			
		if reset_i = '1' then

			s_calc_state <= OP_1;
			s_enable_state_switching <= '1';
			s_op1 <= (others => '0');
			s_op2 <= (others => '0');
			s_optype_o <= (others => '0');
			s_start_o <= '0';
			s_led_o <= (others => '0'); -- s_led_o are off
			
			-- leftmost digit = 1 / rest = 0
			s_dig0 <= "11000000";
            s_dig1 <= "11000000";
            s_dig2 <= "11000000";
            s_dig3 <= "11111001";
			s_switch <= 0;
			s_err_countdown <= 0;
				
		elsif s_1khzen'event and s_1khzen = '1' then
			
			-- Switch state at button press and if state switching is allowed 
			--(avoids infinite state switching if button is pressed continously)
			
			if pbsync_i(3) = '1' and s_enable_state_switching = '1' then
				
				s_enable_state_switching <= '0';
				
				case s_calc_state is
					when OP_1 => 
					s_calc_state <= OP_2;
					
					when OP_2 => 
					s_calc_state <= OP_CODE;
					
					when OP_CODE =>
						s_start_o <= '1';
						s_calc_state <= OP_RUNNING;
						
					when OP_RUNNING => 
					s_calc_state <=OP_1;
					
					when OP_ERROR => 
						null;
		
					when others => 
					s_calc_state <= OP_ERROR;
				end case;
				
			elsif pbsync_i(3) = '0' then
				s_enable_state_switching <= '1';
			end if;
			
			-- calculator fsm
			case s_calc_state is
			
				when OP_1 =>
					
					s_led_o <= (others => '0');
					s_dig2 <= f_decode_bcd(swsync_i(3 downto 0));
					s_dig1 <= f_decode_bcd(swsync_i(7 downto 4));
					s_dig0 <= f_decode_bcd(swsync_i(11 downto 8));
					s_dig3 <= "11111001"; -- indicate op 1
					
					s_op1 <= swsync_i(11 downto 0);
			
				when OP_2 =>
				
					s_led_o <= (others => '0');
					s_dig2 <= f_decode_bcd(swsync_i(3 downto 0));
					s_dig1 <= f_decode_bcd(swsync_i(7 downto 4));
					s_dig0 <= f_decode_bcd(swsync_i(11 downto 8));
					s_dig3 <= "10100100"; -- indicate op 2
					
					s_op2 <= swsync_i(11 downto 0);
					
				when OP_CODE =>	
					
					s_led_o <= (others => '0');
					s_optype_o <= swsync_i(15 downto 12);
					s_dig3 <= "10100011"; -- indicate o for op code
					
					case s_optype_o is
						when "0001" =>
							s_dig0 <= "10010010";-- S
							s_dig1 <= "11100011";-- u
							s_dig2 <= "10000011";-- b
						-- mult
						when "0010" =>
							s_dig0 <= "10110110";-- X
							s_dig1 <= "11111111";-- dark
							s_dig2 <= "11111111";-- dark
						when "1001" =>
							s_dig0 <= "10001000";-- A
							s_dig1 <= "10101011";-- n
							s_dig2 <= "10100001";-- d
						when "1100" =>
							s_dig0 <= "10101111";-- r
							s_dig1 <= "10100011";-- o
							s_dig2 <= "11000111";-- L
						-- Err when no/ wrong opcode
						when others => 
							s_dig0 <= "10000110";-- E
							s_dig1 <= "10101111";-- r
							s_dig2 <= "10101111";-- r
					end case;
				
				when OP_RUNNING =>
					
					s_start_o <= '0';
					
					if finished_i = '1' then
						
						if error_i = '0' then
						
							if overflow_i = '0' then
								
								if sign_i = '0' then
								
									s_dig2 <= f_decode_bcd (result_i(3 downto 0));
									s_dig1 <= f_decode_bcd (result_i(7 downto 4));
									s_dig0 <= f_decode_bcd (result_i(11 downto 8));
									s_dig3 <= f_decode_bcd (result_i(15 downto 12));
									s_led_o <= ((15) => '1' ,others => '0');
								elsif sign_i = '1' then
								
									s_dig2 <= f_decode_bcd (result_i(3 downto 0));
									s_dig1 <= f_decode_bcd (result_i(7 downto 4));
									s_dig0 <= f_decode_bcd (result_i(11 downto 8));
									s_dig3 <= "10111111"; -- minus
									s_led_o <= ((15) => '1' ,others => '0');
								
								end if;
							
							elsif overflow_i = '1' then
							
								s_dig0 <= "10100011";-- o
								s_dig1 <= "10100011";-- o
								s_dig2 <= "10100011";-- o
								s_dig3 <= "10100011";-- o
								s_led_o <= (others => '1');
							end if;
							
						elsif error_i = '1' then
							
							s_calc_state <= OP_ERROR;
						
						end if;
					
					end if;
					
				when OP_ERROR =>
					
					s_dig0 <= "10000110";-- E
					s_dig1 <= "10101111";-- r
					s_dig2 <= "10101111";-- r
					s_dig3 <= "11111111";-- blank
					s_switch <= 0;
					s_err_countdown <= 0;
					if s_err_countdown < MAX_DISP_DURATION-1 then
						
						if s_switch = 500 then
							s_led_o <= not s_led_o;
							s_err_countdown <= s_err_countdown + 1;
							s_switch <= 0;
							
						else 
							s_err_countdown <= s_err_countdown + 1;
							s_switch <= s_switch + 1;
						end if;
					else
						s_calc_state <= OP_1;
						s_err_countdown <= 0;
						s_switch <= 0;
					end if;
					
			end case;
			
		end if;
		
	end process p_calc_ctrl_process;
	
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
		
	-- match pin with process internal signals
	op1_o 	<= s_op1;
	op2_o 	<= s_op2;
	optype_o <= s_optype_o;
	start_o <= s_start_o;
	dig0_o <= s_dig0;
	dig1_o <= s_dig1;
	dig2_o <= s_dig2;
	dig3_o <= s_dig3;
	led_o <= s_led_o;
	
end rtl;