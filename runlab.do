# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.


vlog "./mux2_1.sv"
vlog "./mux2by1.sv"
vlog "./mux4by1.sv"
vlog "./mux8by1.sv"
vlog "./mux32by1.sv"
vlog "./regfile.sv"
vlog "./twoBy4decoder.sv"
vlog "./threeBy8decoder.sv"
vlog "./Fiveby32decoder.sv"
vlog "./D_FF.sv"
vlog "./D_FF_enabled.sv"
vlog "./register.sv"
vlog "./regmux2by1.sv"
vlog "./alu.sv"
vlog "./alustim.sv"
vlog "./aOrB.sv"
vlog "./aXorB.sv"
vlog "./aAndB.sv"
vlog "./addition.sv"
vlog "./subtraction.sv"
vlog "./resultB.sv"
vlog "./mux64_8by1.sv"
vlog "./zeroCase.sv"
vlog "./instructionDecoder.sv"
vlog "./CPU.sv"
vlog "./CPU_single.sv"
vlog "./math.sv"
vlog "./PC.sv"
vlog "./regfile.sv"
vlog "./datamem.sv"
vlog "./zeroExtend12.sv"
vlog "./instructmem.sv"
vlog "./updateInstructionandCheck.sv"
vlog "./updateAddress.sv"
vlog "./RtoAlu.sv"
vlog "./alutoMem.sv"
vlog "./MemtoWrite.sv"
vlog "./signExtend19.sv"
vlog "./signExtend26.sv"
vlog "./signExtend9.sv"
vlog "./CPU_pipelined.sv"
vlog "./updateDaAndDb.sv"
vlog "./update5bit.sv"
vlog "./update1bit.sv"
vlog "./normalForwardAa.sv"
vlog "./normalForwardAb.sv"
vlog "./forwardcbz.sv"
vlog "./forwardstur.sv"
# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPU_pipe_testbench
# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do CPU_pipe.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
