vsim -t ns -novopt -lib work work.tb_alu
view *
do alu.do
run 50 ms
