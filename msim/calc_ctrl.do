onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_calc_ctrl/s_clk_i   
add wave -noupdate -format Logic /tb_calc_ctrl/s_reset_i
add wave -noupdate -format Logic /tb_calc_ctrl/i_calc_ctrl/s_1khzen
add wave -noupdate -format Logic /tb_calc_ctrl/i_calc_ctrl/s_calc_state
add wave -noupdate -format Logic /tb_calc_ctrl/s_pbsync_i
add wave -noupdate -format Logic /tb_calc_ctrl/i_calc_ctrl/s_enable_state_switching
add wave -noupdate -format Logic /tb_calc_ctrl/s_swsync_i
add wave -noupdate -format Logic /tb_calc_ctrl/s_op1_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_op2_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_optype_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_start_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_dig0_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_dig1_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_dig2_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_dig3_o
add wave -noupdate -format Logic /tb_calc_ctrl/s_calc_led_o
add wave -noupdate -format Logic /tb_calc_ctrl/i_calc_ctrl/s_led_o
add wave -noupdate -format Logic /tb_calc_ctrl/i_calc_ctrl/s_err_countdown
add wave -noupdate -format Logic /tb_calc_ctrl/i_calc_ctrl/s_switch
TreeUpdate [SetDefaultTree]                  	
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
