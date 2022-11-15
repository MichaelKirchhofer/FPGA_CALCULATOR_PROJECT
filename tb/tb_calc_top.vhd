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
-- Design Unit: Calculator Control (Testbench)
--
-- Description: Testbench implementation for the top level entity / architecture
-- with input simulation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_calc_top is
end tb_calc_top;

architecture sim of tb_calc_top is
	
	
	component calc_top
		port (
		clk_i 		: 	in 	std_logic;
		reset_i 	: 	in 	std_logic;
		sw_i		:	in std_logic_vector (15 downto 0);
		pb_i		:	in std_logic_vector (3 downto 0);
		ss_o		:	out std_logic_vector (7 downto 0);
		ss_sel_o	:	out std_logic_vector (3 downto 0);
		led_o		:	out std_logic_vector (15 downto 0)
		);
	end component;	
	
	-- io_ctrl / calc top signals
	signal s_reset_i 	: std_logic;
	signal s_clk_i 		: std_logic;
	signal s_pb_i 		: std_logic_vector (3 downto 0)	:= (others => '0');
	signal s_sw_i		: std_logic_vector (15 downto 0):=(others => '0');
	signal s_ss_o		: std_logic_vector (7 downto 0)	:=(others => '0');	
	signal s_ss_sel_o	: std_logic_vector (3 downto 0)	:=(others => '0');
	signal s_led_o		: std_logic_vector (15 downto 0):=(others => '0');
	
	procedure substraction (signal 	s_sw_i 	: out std_logic_vector (15 downto 0);
							signal	s_pb_i	: out std_logic_vector (3 downto 0)) is
							
	begin
		
		-- simulate input digit 1
		s_sw_i <= "0000000000001111";
		wait for 5 ms;
		s_sw_i <= "0000000000001011";
		wait for 5 ms;
		s_sw_i <= "0000000000001101";
		wait for 5 ms;
		s_sw_i <= "0000000000001111";
		wait for 50 ms;
		
		-- simulate button BTNL press
		s_pb_i <= "1000";
		wait for 5 ms;
		s_pb_i <= "1011";
		wait for 5 ms;
		s_pb_i <= "1100";
		wait for 5 ms;
		s_pb_i <= "1000";
		wait for 50 ms;
		
		-- simulate input digit 2
		s_sw_i <= "0000000100001001";
		wait for 5 ms;
		s_sw_i <= "0000000001111011";
		wait for 5 ms;
		s_sw_i <= "0000000001001101";
		wait for 5 ms;
		s_sw_i <= "0000000100001001";
		wait for 50 ms;
		
		-- simulate button BTNL press
		s_pb_i <= "1000";
		wait for 5 ms;
		s_pb_i <= "1011";
		wait for 5 ms;
		s_pb_i <= "1100";
		wait for 5 ms;
		s_pb_i <= "1000";
		wait for 50 ms;
		
		-- simulate operation input
		s_sw_i <= "0010000000000000";
		wait for 5 ms;
		s_sw_i <= "0111000000000000";
		wait for 5 ms;
		s_sw_i <= "1111000100100101";
		wait for 5 ms;
		s_sw_i <= "0001010000100001";
		wait for 50 ms;
		
		-- simulate button BTNL press --> start calculation
		s_pb_i <= "1000";
		wait for 5 ms;
		s_pb_i <= "1011";
		wait for 5 ms;
		s_pb_i <= "1100";
		wait for 5 ms;
		s_pb_i <= "1000";
		wait for 50 ms;
		
		-- simulate button BTNL press --> reset to digit input mode
		s_pb_i <= "1000";
		wait for 5 ms;
		s_pb_i <= "1011";
		wait for 5 ms;
		s_pb_i <= "1100";
		wait for 5 ms;
		s_pb_i <= "1000";
		wait for 50 ms;
		
	end procedure substraction;
		
	begin
		
		i_calc_top : calc_top
	
		port map(
		clk_i 		=> s_clk_i,
		reset_i 	=> s_reset_i,
		sw_i 		=> s_sw_i,
		pb_i 		=> s_pb_i,	
		ss_o 		=> s_ss_o,
		ss_sel_o 	=> s_ss_sel_o,
		led_o 		=> s_led_o
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
		
		p_calc_test_process : process
		
		begin
		
		substraction(s_sw_i,s_pb_i);
		
		end process p_calc_test_process;

end sim;