onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_ctrl_tb/DUT/LT24_Init_Done
add wave -noupdate /lcd_ctrl_tb/DUT/OP_SETCURSOR
add wave -noupdate /lcd_ctrl_tb/DUT/OP_DRAWCOLOUR
add wave -noupdate /lcd_ctrl_tb/DUT/RGB
add wave -noupdate /lcd_ctrl_tb/DUT/NUMPIX
add wave -noupdate /lcd_ctrl_tb/DUT/CLK
add wave -noupdate /lcd_ctrl_tb/DUT/RESET_L
add wave -noupdate /lcd_ctrl_tb/DUT/DONE_CURSOR
add wave -noupdate /lcd_ctrl_tb/DUT/DONE_COLOUR
add wave -noupdate /lcd_ctrl_tb/DUT/UC/EP
add wave -noupdate /lcd_ctrl_tb/DUT/UC/ES
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3850287 ps} 0}
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
WaveRestoreZoom {0 ps} {10500 ns}
