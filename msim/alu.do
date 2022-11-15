onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_alu/s_clk_i
add wave -noupdate -format Logic /tb_alu/i_alu/s_1khzen
add wave -noupdate -format Logic /tb_alu/s_reset_i
add wave -noupdate -format Logic /tb_alu/i_alu/s_calc_state
add wave -noupdate -format Logic /tb_alu/s_start_i	
add wave -noupdate -format Logic /tb_alu/s_op1_i
add wave -noupdate -format Logic /tb_alu/s_op2_i
add wave -noupdate -format Logic /tb_alu/i_alu/s_op1
add wave -noupdate -format Logic /tb_alu/i_alu/s_op2
add wave -noupdate -format Logic /tb_alu/s_optype_i
add wave -noupdate -format Logic /tb_alu/s_result_o
add wave -noupdate -format Logic /tb_alu/i_alu/s_op_result
add wave -noupdate -format Logic /tb_alu/i_alu/s_mult_counter
add wave -noupdate -format Logic /tb_alu/s_finished_o
add wave -noupdate -format Logic /tb_alu/s_sign_o
add wave -noupdate -format Logic /tb_alu/s_overflow_o
add wave -noupdate -format Logic /tb_alu/s_error_o
TreeUpdate [SetDefaultTree]                  	
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
