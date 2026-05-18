vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/SPI_if_inst/*
coverage save top.ucdb -onexit
run -all
vcover report top.ucdb -details -annotate -all -output coverage_rpt.txt
coverage report -detail -cvg -directive -comments -output fcover_report.txt {}