-------------------------------------------------------------------------------
--
-- Author: Michael Kirchhofer
--
-- Filename: io_ctrl_rt1.vhd
--
-- Date of Creation: 26.04.2022
--
-- Version: V 1.0
--
-- Date of Latest Version: 26.04.2022
--
-- Design Unit: IO Control Unit (Architecture)
--
-- Description: The IO Control unit is part of the calculator project.
-- It manages the interface to the 7-segment displays,
-- the LEDs, the push buttons and the switches of the
-- Digilent Basys3 FPGA board.
--
-------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;

architecture rtl of io_ctrl is
 
	-- clock countdown
	constant MAX_COUNT : integer := (50000-1);
	
	-- 50 milliseconds timeframe for button debounce
	constant MIN_PRESS_DURATION : integer := (50); 
	
	signal s_1khzen : std_logic;					 -- enable signal every 1 ms
	signal s_swsync 	: std_logic_vector(15 downto 0); -- switch debounce state
	signal s_pbsync 	: std_logic_vector(3 downto 0);	 -- push button debounce state
	signal s_ss_sel_o : std_logic_vector(3 downto 0 ); -- 7 segment display select
	signal s_ss 	: std_logic_vector(7 downto 0 ); -- out to 7 segment display
	
	-- debouncer state variables
	signal s_prev_switch_state 	: std_logic_vector (15 downto 0);
	signal s_prev_btn_state		: std_logic_vector (3 downto 0);
	signal s_curr_switch_state 	: std_logic_vector (15 downto 0);
	signal s_curr_btn_state		: std_logic_vector (3 downto 0);
	
	begin -- rtl
	-----------------------------------------------------------------------------
	--
	-- Generate 1 kHz enable signal.
	--
	-----------------------------------------------------------------------------
	
	p_slowen: process (clk_i, reset_i)
	
	-- enable counter
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
		
	-----------------------------------------------------------------------------
	--
	-- Debounce buttons and switches
	--
	-- Checks if input button / switches input array stays the same for 75ms for 
	-- debouncing purposes
	-----------------------------------------------------------------------------
	
	p_debounce: process (s_1khzen, reset_i)
	
	-- debounce counter
	variable v_btn_db_count	: integer range 0 to MAX_COUNT-1 := 0;
	variable v_swt_db_count	: integer range 0 to MAX_COUNT-1 := 0; 

	begin
		
		if reset_i = '1' then -- asynchronous reset
		
		s_prev_btn_state 		<= (0 => '1', others => '0');
		s_prev_switch_state 	<= (0 => '1', others => '0');
		s_curr_btn_state 		<= (0 => '1', others => '0');
		s_curr_switch_state 	<= (0 => '1', others => '0');
		v_btn_db_count := 0;
		v_swt_db_count := 0;
		s_swsync <=  (others => '0');
		s_pbsync <=  (others => '0');
		
		elsif s_1khzen'event and s_1khzen = '1' then -- rising clock edge
			
			s_prev_btn_state <= s_curr_btn_state;
			s_curr_btn_state <= pb_i;
			
			s_prev_switch_state <= s_curr_switch_state;
			s_curr_switch_state <= sw_i; 
			
			-- debounce section for the push buttons (75 ms press time)
			if s_curr_btn_state = s_prev_btn_state then
				v_btn_db_count := v_btn_db_count + 1;
			else
				v_btn_db_count := 0;
			end if;
			
			if v_btn_db_count > MIN_PRESS_DURATION then
				s_pbsync <= s_curr_btn_state;
			else
				s_pbsync <= (others => '0');
			end if;	
			
			-- debounce section for the 16 switches (75 ms press time)
			if s_curr_switch_state = s_prev_switch_state then
				v_swt_db_count := v_swt_db_count + 1;
			else
				v_swt_db_count := 0;
			end if;
			
			if v_swt_db_count > MIN_PRESS_DURATION then
				s_swsync <= s_curr_switch_state;
			else
				s_swsync <= (others => '0');
			end if;	
			
		end if;
		
	end process p_debounce;
	
	-----------------------------------------------------------------------------
	--
	-- Display controller for the 7-segment display
	--
	-----------------------------------------------------------------------------
	p_display_ctrl: process (s_1khzen, reset_i)
	
		begin
		
		if reset_i = '1' then -- asynchronous reset (active high)
		
			s_ss_sel_o <= "1110"; -- LSB
			s_ss <= "11111101"; 	-- 0		
		elsif s_1khzen'event and s_1khzen = '1' then -- rising clock edge
		
			-- starting from the right
			case s_ss_sel_o is
			-- disp 1. digit
			when "1110" => 
			s_ss <= dig0_i; 
			s_ss_sel_o <= "1101";
			-- disp 2. digit
			when "1101" =>
			s_ss_sel_o <= "1011";
			s_ss <= dig1_i;
			-- disp 3. digit
			when "1011" =>
			s_ss_sel_o <= "0111";
			s_ss <= dig2_i;
			-- disp 4. digit
			when "0111" =>
			s_ss_sel_o <= "1110";
			s_ss <= dig3_i;
			-- default 1. digit
			when others =>	
			s_ss_sel_o <= "1110";
			
			end case;
			
		end if;
		
	end process p_display_ctrl;

	 -----------------------------------------------------------------------------
	 --
	 -- Handle the 16 LEDs
	 --
	 -----------------------------------------------------------------------------
	p_led_handler : process( s_1khzen, reset_i)
	
	begin
	
		if reset_i = '1' then -- asynchronous reset (active high)
		
			led_o <= (others => '0');
		
		elsif s_1khzen'event and s_1khzen = '1' then -- rising clock edge
		
			led_o <= led_i; -- simply connect the internal to the external signals
			
		end if;
		
	end process p_led_handler;	
	
	ss_o <= s_ss;
	ss_sel_o <= s_ss_sel_o;
	swsync_o <= s_swsync;
	pbsync_o <= s_pbsync;
	
end rtl;