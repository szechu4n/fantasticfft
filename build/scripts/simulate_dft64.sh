# run from within top level directory (fantasticfft)

if [ ! -d "build/f_sim" ]; then
    echo "Creating f_sim directory..."
    mkdir build/f_sim
fi

vcs -sverilog -full64 -debug_all tests/dft64_tb_top.sv rtl/fixedpoint.sv rtl/fft8.sv rtl/complexmultiplier.sv rtl/sine_lut.sv rtl/dft64_if.sv rtl/dft64.sv tests/dft64_tb.sv -o build/f_sim/dft64.simv > build/f_sim/dft64_compilation.txt
./build/f_sim/dft64.simv > build/f_sim/dft64_simulation.txt