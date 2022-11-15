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

entity tb_io_ctrl is
end tb_io_ctrl;

architecture sim of tb_io_ctrl is
		
	component io_ctrl
	  port (
	  
		clk_i 		: 	in 	std_logic; 						-- 100 MHz system clock
		reset_i 	: 	in 	std_logic; 						-- asynchronous reset
		
		pb_i 		:	in 	std_logic_vector (3 downto 0); 	-- 4 Push Buttons states
		led_i		:	in 	std_logic_vector (15 downto 0);	-- 16 LED states
		dig0_i		:	in 	std_logic_vector (7 downto 0); 	-- 7 segment digit 0
		dig1_i		:	in 	std_logic_vector (7 downto 0); 	-- 7 segment digit 1
		dig2_i		:	in 	std_logic_vector (7 downto 0); 	-- 7 segment digit 2
		dig3_i		:	in 	std_logic_vector (7 downto 0); 	-- 7 segment digit 3
		sw_i		: 	in	std_logic_vector (15 downto 0); -- 16 input switches
			
		swsync_o	:	out std_logic_vector (15 downto 0);	-- 16 debounced switches state ?
		pbsync_o	:	out std_logic_vector (3 downto 0); 	-- 4 debounced push button states ?
		ss_o		:	out std_logic_vector (7 downto 0); 	-- out to 7 segment display
		ss_sel		:	out	std_logic_vector (3 downto 0); 	-- 7 segment selection output
		led_o		:	out std_logic_vector (15 downto 0)	-- 16 led display 
		);
		
	end component;
  
	-- Declare the signals used stimulating the design's inputs.
	signal s_clk_i			: std_logic;
	signal s_reset_i		: std_logic;
	signal s_pb_i			: std_logic_vector(3 downto 0) 		:= (others => '0');
	signal s_led_i			: std_logic_vector(15 downto 0)		:= (others => '0') ;     
	signal s_dig0_i			: std_logic_vector (7 downto 0) 	:= (others => '0');
	signal s_dig1_i			: std_logic_vector (7 downto 0) 	:= (others => '0');
	signal s_dig2_i			: std_logic_vector (7 downto 0) 	:= (others => '0');
	signal s_dig3_i			: std_logic_vector (7 downto 0) 	:= (others => '0');	
	signal s_sw_i			: std_logic_vector (15 downto 0)	:= (others => '0');	
	signal s_swsync_o		: std_logic_vector (15 downto 0)	:= (others => '0');	
	signal s_pbsync_o		: std_logic_vector (3 downto 0) 	:= (others => '0'); 	
	signal s_ss_o			: std_logic_vector (7 downto 0) 	:= (others => '0'); 	
	signal s_ss_sel			: std_logic_vector (3 downto 0) 	:= (others => '0'); 	
	signal s_led_o			: std_logic_vector (15 downto 0) 	:= (others => '0');	
	
	
	-- Operations to be performed: sub 0001, mult 0010 , logical and 1001, rotate left 1100
	-- sw_i 12-15 operation 0-11 digits
	-- pb_i BTNL,BTNC,BNTR,BTND
	procedure substraction (signal 	s_pb_i 	: out std_logic_vector (3 downto 0);
							signal	s_sw_i	: out std_logic_vector (15 downto 0)) is
	begin
		-- simulate input digit 1
		s_sw_i <= "0000000000001111";
		wait for 2 ms;
		s_sw_i <= "0000000000001011";
		wait for 2 ms;
		s_sw_i <= "0000000000001101";
		wait for 2 ms;
		s_sw_i <= "0000000000001111";
		wait for 10 ms;
		
		-- simulate button BTNL press
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
		
		-- simulate input digit 2
		s_sw_i <= "0000000100001001";
		wait for 2 ms;
		s_sw_i <= "0000000001111011";
		wait for 2 ms;
		s_sw_i <= "0000000001001101";
		wait for 2 ms;
		s_sw_i <= "0000000100001001";
		wait for 10 ms;
		
		-- simulate button BTNL press
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
		
		-- simulate operation input
		s_sw_i <= "0010000000000000";
		wait for 2 ms;
		s_sw_i <= "0111000000000000";
		wait for 2 ms;
		s_sw_i <= "1111000100100101";
		wait for 2 ms;
		s_sw_i <= "0001010000100001";
		wait for 10 ms;
		
		-- simulate button BTNL press --> start calculation
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
		
		-- simulate button BTNL press --> reset to digit input mode
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
	
	end procedure substraction;
	
	procedure multiplication (signal 	s_pb_i 	: out std_logic_vector (3 downto 0);
							  signal	s_sw_i	: out std_logic_vector (15 downto 0)) is
	begin
	
		-- simulate input digit 1
		s_sw_i <= "0000000000001111";
		wait for 2 ms;
		s_sw_i <= "0000000000001011";
		wait for 2 ms;
		s_sw_i <= "0000000000001101";
		wait for 2 ms;
		s_sw_i <= "0000000000001111";
		wait for 10 ms;
		
		-- simulate button BTNL press
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
		
		-- simulate input digit 2
		s_sw_i <= "0000000100001001";
		wait for 2 ms;         
		s_sw_i <= "0000000001111011";
		wait for 2 ms;         
		s_sw_i <= "0000000001001101";
		wait for 2 ms;         
		s_sw_i <= "0000000100001001";
		wait for 10 ms;
		
		-- simulate button BTNL press
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
		
		-- simulate operation input
		s_sw_i <= "0010000000000000";
		wait for 2 ms;
		s_sw_i <= "0111000000000000";
		wait for 2 ms;
		s_sw_i <= "1111000100001101";
		wait for 2 ms;
		s_sw_i <= "0010010000001001";
		wait for 10 ms;
		
		-- simulate button BTNL press --> start calculation
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
		
		-- simulate button BTNL press --> reset to digit input mode
		s_pb_i <= "1000";
		wait for 2 ms;
		s_pb_i <= "1011";
		wait for 2 ms;
		s_pb_i <= "1100";
		wait for 2 ms;
		s_pb_i <= "1000";
		wait for 10 ms;
	
	end procedure multiplication;
	
	begin

	  -- Instantiate the design for testing
	  i_io_ctrl : io_ctrl
	  port map              
		(
			clk_i      =>	s_clk_i,
			reset_i    =>   s_reset_i, 
			pb_i 	   =>   s_pb_i,
			led_i	   =>   s_led_i,
			dig0_i	   =>   s_dig0_i,
			dig1_i	   =>   s_dig1_i,
			dig2_i	   =>   s_dig2_i,
			dig3_i	   =>   s_dig3_i,
			sw_i	   =>   s_sw_i,
			swsync_o   =>   s_swsync_o,
			pbsync_o   =>   s_pbsync_o,
			ss_o	   =>   s_ss_o,
			ss_sel	   =>   s_ss_sel,	
			led_o	   =>   s_led_o
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
		
		
		p_io_test_process : process
		
		begin
			
			substraction(s_pb_i,s_sw_i);
			wait for 5 ms;
			multiplication(s_pb_i,s_sw_i);
			
		end process p_io_test_process;
		
end sim;