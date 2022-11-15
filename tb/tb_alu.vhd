-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: tb_io_ctrl.vhd
--
-- Date of Creation: 03.05.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 14.05.2022
--
-- Design Unit: IO Control Unit (Testbench)
--
-- Description: Testbench implementation for the io_ctrl entity / architecture
-- with input simulation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu is
end tb_alu;

architecture sim of tb_alu is
	
	component alu
		port (
		clk_i 		: 	in 	std_logic;
		reset_i 	: 	in 	std_logic;
		op1_i		:	in std_logic_vector (11 downto 0);
		op2_i		:	in std_logic_vector (11 downto 0);
		optype_i	:	in std_logic_vector (3 downto 0);
		start_i		:	in std_logic;
		finished_o	:	out std_logic;
		result_o	:	out std_logic_vector(15 downto 0);
		sign_o		:	out std_logic;
		overflow_o	:	out std_logic;
		error_o		:	out std_logic
		);
	end component alu;
	
	signal s_clk_i 		: std_logic;
	signal s_reset_i	: std_logic;
	signal s_finished_o	: std_logic := '0';
	signal s_result_o	: std_logic_vector(15 downto 0) := (others => '0');
	signal s_sign_o		: std_logic := '0';
	signal s_overflow_o	: std_logic := '0';
	signal s_error_o	: std_logic := '0';
	signal s_op1_i		: std_logic_vector (11 downto 0) := (others => '0');
	signal s_op2_i		: std_logic_vector (11 downto 0) := (others => '0');
	signal s_optype_i	: std_logic_vector (3 downto 0) := (others => '0');
	signal s_start_i	: std_logic := '0';
	
	procedure pr_test_alu ( signal s_op1_i		: out std_logic_vector (11 downto 0);
							signal s_op2_i		: out std_logic_vector (11 downto 0);						
							signal s_optype_i 	: out std_logic_vector (3 downto 0);
							signal s_start_i	: out std_logic) is
	begin
		
		wait for 1 ms;
		
		
		--multiplication
		s_op1_i <= "000000001111";
		s_op2_i <= "000000000111";
		s_optype_i <= "0010";
		s_start_i <= '1';
		wait for 1 ms;
		s_start_i <= '0';
		wait for 25 ms;
		
		-- substraction
		s_op1_i <= "000000000001";
		s_op2_i <= "000000000011";
		s_optype_i <= "0001";
		s_start_i <= '1';
		wait for 1 ms;
		s_start_i <= '0';
		wait for 5 ms;
		
		-- Logical And
		s_op1_i <= "000000001111";
		s_op2_i <= "000000000111";
		s_optype_i <= "1001";
		s_start_i <= '1';
		wait for 1 ms;
		s_start_i <= '0';
		wait for 5 ms;
		
		-- Shift Left
		s_op1_i <= "000000001111";
		s_op2_i <= "000000000111";
		s_optype_i <= "1100";
		s_start_i <= '1';
		wait for 1 ms;
		s_start_i <= '0';
		wait for 5 ms;
		
		s_op1_i <= "111111111111";
		s_op2_i <= "111111100011";
		s_optype_i <= "0010";
		s_start_i <= '1';
		wait for 1 ms;
		s_start_i <= '0';
		wait for 5 ms;
		
	end procedure pr_test_alu;
	
	begin
		
		i_alu : alu
		port map(
		clk_i 		=> s_clk_i,
		reset_i 	=> s_reset_i,
		op1_i 		=> s_op1_i,
		op2_i 		=> s_op2_i,
		optype_i	=> s_optype_i,
		start_i		=> s_start_i,
		finished_o 	=> s_finished_o,
		result_o 	=> s_result_o,
		sign_o 		=> s_sign_o,
		overflow_o 	=> s_overflow_o,
		error_o		=> s_error_o
		);
	
		--100Mhz clock
	    p_clock : process
		begin
			s_clk_i <= '0';
			wait for 5 ns;
			s_clk_i <= '1';
			wait for 5 ns;
		end process p_clock;
		
		p_reset : process	
		begin
			s_reset_i <= '1';
			wait for 10 ns;
			s_reset_i <= '0';
			wait;
		end process p_reset;
		
		p_alu_test_process : process
		
		begin
		
		pr_test_alu(s_op1_i,s_op2_i,s_optype_i,s_start_i);
		
		end process p_alu_test_process;

end sim;