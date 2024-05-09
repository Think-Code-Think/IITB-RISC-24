transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/RISC_Pipeline.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/ALU2.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/instruction_memory.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/IFIDReg.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/Decoder.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/IDORReg.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/SE6.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/SE9.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/Register_File.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/OREXReg.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/mux_2_1.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/SHIFTER.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/mux_4_1.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/ALU.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/ALU3.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/EXMMReg.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/data_memory.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/MMWBReg.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/mux_4_1_3bit.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/Multiple_Reg.vhdl}
vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/mux_2_1_3bit.vhdl}

vcom -93 -work work {D:/IIT-B/E.E. DD/2nd Year/Spring Semester/EE 309/Project/Trial_0/RISC_tb.vhdl}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  RISC_tb

add wave *
view structure
view signals
run -all
