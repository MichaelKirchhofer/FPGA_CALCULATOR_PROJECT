vsim -t ns -novopt -lib work work.tb_calc_ctrl
view *
do calc_ctrl.do
run 50 ms
