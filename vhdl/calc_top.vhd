-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: calc_ctrl.vhd
--
-- Date of Creation: 11.05.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 1.05.2022
--
-- Design Unit: Top Level Calculator Control Unit (Entity)
--
-- Description: The top level calculator control unit handles the internal
-- wiring which connects the alu, io_ctrl and the calc_ctrl components.
-- Furthermore, it handles the inputs given by the FPGA board.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity calc_top is

	port (
		clk_i 		: 	in 	std_logic; 						-- 100 MHz system clock
		reset_i 	: 	in 	std_logic; 						-- asynchronous reset
		sw_i		:	in std_logic_vector (15 downto 0);	
		pb_i		:	in std_logic_vector (3 downto 0); 	
		ss_o		:	out std_logic_vector (7 downto 0);	
		ss_sel_o	:	out std_logic_vector (3 downto 0);	
		led_o		:	out std_logic_vector (15 downto 0)	
		);
 
end calc_top;