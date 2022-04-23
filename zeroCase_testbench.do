onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /zeroCase_testbench/inputs
add wave -noupdate /zeroCase_testbench/out
add wave -noupdate /zeroCase_testbench/dut/a
add wave -noupdate /zeroCase_testbench/dut/b
add wave -noupdate /zeroCase_testbench/dut/notOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4478 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 102
configure wave -valuecolwidth 427
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
WaveRestoreZoom {0 ps} {32040 ps}
