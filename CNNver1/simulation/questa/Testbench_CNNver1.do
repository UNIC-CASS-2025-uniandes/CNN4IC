# --- LIMPIEZA ---
quit -sim
if [file exists work] { vdel -all -lib work }
vlib work

# --- COMPILACIÓN ---
vlog ../../rtl/Register.v
vlog ../../rtl/STATEMACHINE_IMAGE_LOADER.v
vlog ../../rtl/spi_cnn_slave_8.v
vlog ../../CNNver1.v
vlog Testbench_CNNver1.vt

# --- INICIO DE SIMULACIÓN ---
vsim -voptargs="+acc" work.TB_SYSTEM

# --- CONFIGURACIÓN DE ONDAS ---
# SPI
add wave -divider "SPI INTERFACE"
add wave -color "Yellow"  /TB_SYSTEM/CNNver1_u0/CNNver1_SPICLOCK_50
add wave -color "Cyan"    /TB_SYSTEM/CNNver1_u0/CNNver1_SS_N
add wave -color "Orange"  /TB_SYSTEM/CNNver1_u0/CNNver1_MOSI

# FSM
add wave -divider "FSM & CONTROL"
add wave -radix decimal   /TB_SYSTEM/CNNver1_u0/spi_cnn_slave_8_u0/row
add wave -color "Pink"    /TB_SYSTEM/CNNver1_u0/spi_cnn_slave_8_u0/loader_image_sm/STATE_Register
add wave -color "Orange"    /TB_SYSTEM/CNNver1_u0/spi_cnn_slave_8_u0/bit_count
add wave -color "Red"     /TB_SYSTEM/CNNver1_u0/spi_cnn_slave_8_u0/o_load*

# Memoria Interna
add wave -divider "INTERNAL SPI MEMORY"
add wave -radix hexadecimal /TB_SYSTEM/CNNver1_u0/spi_cnn_slave_8_u0/image_mem

# Registros de Salida (Ruta corregida)
add wave -divider "FINAL OUTPUT REGISTERS"
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u0/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u1/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u2/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u3/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u4/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u5/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u6/Register_DataOutBUS
add wave -radix hexadecimal -group "REG_DATA" /TB_SYSTEM/CNNver1_u0/register_u7/Register_DataOutBUS

# --- EJECUCIÓN ---
configure wave -timelineunits ns
# Si hay algún error en las ondas, el script seguirá hasta el run
onerror {resume}
run -all
wave zoom full