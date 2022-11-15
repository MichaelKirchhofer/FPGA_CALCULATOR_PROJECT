-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: alu.vhd
--
-- Date of Creation: 03.05.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 03.05.2022
--
-- Design Unit: Artithmetic Logic Unit (Entity)
--
-- Description: The ALU handles the artithmetic operations of the calculator.
-- It uses the two input numbers and the operation command to execute the 
-- calculation according to the user inputs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity alu is

	port (
		clk_i 		: 	in 	std_logic; 						-- 100 MHz system clock
		reset_i 	: 	in 	std_logic; 						-- asynchronous reset
		
		op1_i		:	in std_logic_vector (11 downto 0);	-- ALU Operand 1
		op2_i		:	in std_logic_vector (11 downto 0);	-- ALU Operand 2
		optype_i	:	in std_logic_vector (3 downto 0);	-- ALU Operation
		start_i		:	in std_logic;						-- ALU  Operation start
		
		finished_o	:	out std_logic;						-- ALU finished Flag
		result_o	:	out std_logic_vector(15 downto 0);	-- ALU output result
		sign_o		:	out std_logic;						-- ALU signed Flag
		overflow_o	:	out std_logic;						-- ALU overflow Flag
		error_o		:	out std_logic						-- ALU error Flag	
		);
 
end alu;
