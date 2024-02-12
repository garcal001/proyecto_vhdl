onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LT24_Init_Done
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/OP_SETCURSOR
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/OP_DRAWCOLOUR
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/RGB
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/NUMPIX
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/CLK
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/RESET_L
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/LCD_DATA
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/RXCOL
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/RYROW
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LD_CURSOR
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/RRGB
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LD_DRAW
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/DEC_PIX
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/ENDPIX
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/CNT
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LD_2C
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/INC_DAT
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/CL_DAT
add wave -noupdate -radix binary -childformat {{/lcd_ctrl_tb/DUT/QDAT(2) -radix decimal} {/lcd_ctrl_tb/DUT/QDAT(1) -radix decimal} {/lcd_ctrl_tb/DUT/QDAT(0) -radix decimal}} -subitemconfig {/lcd_ctrl_tb/DUT/QDAT(2) {-height 15 -radix decimal} /lcd_ctrl_tb/DUT/QDAT(1) {-height 15 -radix decimal} /lcd_ctrl_tb/DUT/QDAT(0) {-height 15 -radix decimal}} /lcd_ctrl_tb/DUT/QDAT
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/XCOL
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/YROW
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LCD_CS_N
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LCD_RS
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/LCD_WR_N
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/CL_LCD_DATA
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/QDAT_MUX_OUT
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D0
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D1
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D2
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D3
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D4
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D5
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/D6
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/RSDAT
add wave -noupdate -radix decimal /lcd_ctrl_tb/DUT/RSCOM
add wave -noupdate /lcd_ctrl_tb/DUT/UC/EP
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1817895 ps} 0}
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
WaveRestoreZoom {818651 ps} {2062177 ps}
