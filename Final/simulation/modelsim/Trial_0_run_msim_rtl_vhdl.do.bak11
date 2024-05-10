transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/Components.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/RISC_Pipeline.vhdl}

vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/RISC_tb.vhdl}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  RISC_tb

add wave *
view structure
view signals
run -all
