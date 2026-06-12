vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/top/RAM_test_vif/*
coverage save RAM_tb.ucdb -onexit
run -all
vcover report top.ucdb -details -annotate -all -output coverage_rpt_APB.txt
coverage report -detail -cvg -directive -comments -output fcover_report.txt {}