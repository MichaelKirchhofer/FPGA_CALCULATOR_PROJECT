-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: calc_ctrl.vhd
--
-- Date of Creation: 02.05.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 02.05.2022
--
-- Design Unit: Calculator Control Unit (Entity)
--
-- Description: The Calc_Ctrl handles the operands given by the IO control and
-- it provides the ALU with the to be computed instructions. Furthermore, it 
-- handles the output from the ALU and forwards its returns to the IO unit.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity calc_ctrl is

	port (
		clk_i 		: 	in 	std_logic; 						-- 100 MHz system clock
		reset_i 	: 	in 	std_logic; 						-- asynchronous reset

		swsync_i	:	in std_logic_vector (15 downto 0);	-- IO Control debounced switches state
		pbsync_i	:	in std_logic_vector (3 downto 0); 	-- IO Control debounced push button states
		
		finished_i	:	in std_logic;						-- ALU finished Flag
		result_i	:	in std_logic_vector(15 downto 0);	-- ALU output result
		sign_i		:	in std_logic;						-- ALU signed Flag
		overflow_i	:	in std_logic;						-- ALU overflow Flag
		error_i		:	in std_logic;						-- ALU error Flag
		
		op1_o		:	out std_logic_vector (11 downto 0);	-- ALU Operand 1
		op2_o		:	out std_logic_vector (11 downto 0);	-- ALU Operand 2
		optype_o	:	out std_logic_vector (3 downto 0);	-- ALU Operation
		start_o		:	out std_logic;						-- ALU  Operation start
		led_o		:	out std_logic_vector (15 downto 0);	-- IO Control LED information

		dig0_o		:	out 	std_logic_vector (7 downto 0); 	-- 7 segment digit 0
		dig1_o		:	out 	std_logic_vector (7 downto 0); 	-- 7 segment digit 1
		dig2_o		:	out 	std_logic_vector (7 downto 0); 	-- 7 segment digit 2
		dig3_o		:	out 	std_logic_vector (7 downto 0) 	-- 7 segment digit 3
		);
 
end calc_ctrl;
