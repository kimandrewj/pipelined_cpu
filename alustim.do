onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alustim/delay
add wave -noupdate /alustim/ALU_PASS_B
add wave -noupdate /alustim/ALU_ADD
add wave -noupdate /alustim/ALU_SUBTRACT
add wave -noupdate /alustim/ALU_AND
add wave -noupdate /alustim/ALU_OR
add wave -noupdate /alustim/ALU_XOR
add wave -noupdate -radix decimal /alustim/A
add wave -noupdate -radix decimal /alustim/B
add wave -noupdate /alustim/cntrl
add wave -noupdate -radix decimal /alustim/result
add wave -noupdate -radix binary /alustim/negative
add wave -noupdate -radix binary /alustim/zero
add wave -noupdate -radix binary /alustim/overflow
add wave -noupdate -radix binary /alustim/carry_out
add wave -noupdate -radix decimal /alustim/i
add wave -noupdate -radix decimal /alustim/test_val
add wave -noupdate -radix decimal -childformat {{{/alustim/dut/outputs[7]} -radix decimal} {{/alustim/dut/outputs[6]} -radix decimal} {{/alustim/dut/outputs[5]} -radix decimal} {{/alustim/dut/outputs[4]} -radix decimal} {{/alustim/dut/outputs[3]} -radix decimal} {{/alustim/dut/outputs[2]} -radix decimal} {{/alustim/dut/outputs[1]} -radix decimal} {{/alustim/dut/outputs[0]} -radix decimal}} -expand -subitemconfig {{/alustim/dut/outputs[7]} {-height 15 -radix decimal} {/alustim/dut/outputs[6]} {-height 15 -radix decimal} {/alustim/dut/outputs[5]} {-height 15 -radix decimal} {/alustim/dut/outputs[4]} {-height 15 -radix decimal} {/alustim/dut/outputs[3]} {-height 15 -radix decimal} {/alustim/dut/outputs[2]} {-height 15 -radix decimal} {/alustim/dut/outputs[1]} {-height 15 -radix decimal} {/alustim/dut/outputs[0]} {-height 15 -radix decimal}} /alustim/dut/outputs
add wave -noupdate /alustim/dut/outputMux/ins
add wave -noupdate /alustim/dut/outputMux/out
add wave -noupdate -expand /alustim/dut/zeroMux/ins
add wave -noupdate /alustim/dut/carryOutMux/ins
add wave -noupdate /alustim/dut/zeroMux/out
add wave -noupdate /alustim/dut/case011/carries
add wave -noupdate /alustim/dut/overflowA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50876289 ps} 0}
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
WaveRestoreZoom {0 ps} {735 us}
