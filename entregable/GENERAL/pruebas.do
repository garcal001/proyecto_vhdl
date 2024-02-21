onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /general_tb/DUT/UART_IN
add wave -noupdate -radix decimal /general_tb/DUT/UART_DONE
add wave -noupdate -radix decimal /general_tb/DUT/DONE_CURSOR
add wave -noupdate -radix decimal /general_tb/DUT/DONE_COLOUR
add wave -noupdate -radix decimal /general_tb/DUT/clk
add wave -noupdate -radix decimal /general_tb/DUT/RESET
add wave -noupdate -radix decimal /general_tb/DUT/INIT_DONE
add wave -noupdate -radix decimal /general_tb/DUT/OP_SETCURSOR
add wave -noupdate -radix decimal /general_tb/DUT/XCOL
add wave -noupdate -radix decimal /general_tb/DUT/YROW
add wave -noupdate -radix decimal /general_tb/DUT/OP_DRAWCOLOUR
add wave -noupdate -radix decimal /general_tb/DUT/RGB
add wave -noupdate -radix unsigned /general_tb/DUT/NUM_PIX
add wave -noupdate -radix decimal /general_tb/DUT/XCOL_DATA
add wave -noupdate -radix decimal /general_tb/DUT/YROW_DATA
add wave -noupdate -radix decimal /general_tb/DUT/YROW_OFF_DATA
add wave -noupdate -radix decimal /general_tb/DUT/TC_OFF
add wave -noupdate -radix decimal /general_tb/DUT/RESET_BOLA
add wave -noupdate -radix decimal /general_tb/DUT/DEC_OFF
add wave -noupdate -radix decimal /general_tb/DUT/REG_XCOL
add wave -noupdate -radix decimal /general_tb/DUT/REG_YROW
add wave -noupdate -radix decimal /general_tb/DUT/LD_POS
add wave -noupdate -radix decimal /general_tb/DUT/UC/DONE_CURSOR
add wave -noupdate -radix decimal /general_tb/DUT/UC/DONE_COLOUR
add wave -noupdate -radix decimal /general_tb/DUT/UC/TC_OFF
add wave -noupdate -radix decimal /general_tb/DUT/UC/EP
add wave -noupdate -radix decimal /general_tb/DUT/UC/ES
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {502174 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1050 ns}
