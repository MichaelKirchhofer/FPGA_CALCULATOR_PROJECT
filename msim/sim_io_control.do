vsim -t ns -novopt -lib work work.tb_io_ctrl
view *
do io_ctrl.do
run 50 ms
