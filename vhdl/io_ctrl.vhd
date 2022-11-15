-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: io_ctrl_.vhd
--
-- Date of Creation: 26.04.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 26.04.2022
--
-- Design Unit: IO Control Unit (Entity)
--
-- Description: The IO Control unit is part of the calculator project.
-- It manages the interface to the 7-segment displays,
-- the LEDs, the push buttons and the switches of the
-- Digilent Basys3 FPGA board.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl is

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
		ss_sel_o	:	out	std_logic_vector (3 downto 0); 	-- 7 segment selection output
		led_o		:	out std_logic_vector (15 downto 0)	-- 16 led display 
		);
 
end io_ctrl;
