transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jacob/Desktop/Conv/New/CNN/CNN4IC/Proyect_files {C:/Users/jacob/Desktop/Conv/New/CNN/CNN4IC/Proyect_files/CNN4IC.v}
vlog -vlog01compat -work work +incdir+C:/Users/jacob/Desktop/Conv/New/CNN/CNN4IC/Proyect_files/rtl {C:/Users/jacob/Desktop/Conv/New/CNN/CNN4IC/Proyect_files/rtl/SPI.v}

