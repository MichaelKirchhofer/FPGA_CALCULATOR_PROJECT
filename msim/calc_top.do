onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_calc_top/s_reset_i 	
add wave -noupdate -format Logic /tb_calc_top/s_clk_i
add wave -noupdate -format Logic /tb_calc_top/i_calc_top/i_calc_ctrl/s_calc_state 		
add wave -noupdate -format Logic /tb_calc_top/s_pb_i
add wave -noupdate -format Logic /tb_calc_top/i_calc_top/i_calc_ctrl/pbsync_i
add wave -noupdate -format Logic /tb_calc_top/s_sw_i
add wave -noupdate -format Logic /tb_calc_top/i_calc_top/i_calc_ctrl/swsync_i	
add wave -noupdate -format Logic /tb_calc_top/s_ss_o		
add wave -noupdate -format Logic /tb_calc_top/s_ss_sel_o	
add wave -noupdate -format Logic /tb_calc_top/s_led_o		
TreeUpdate [SetDefaultTree]                  	
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
