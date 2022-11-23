# run from within top level directory (fantasticfft)

if [ ! -d "build/f_sim" ]; then
    mkdir build/f_sim
fi

vcs -sverilog -full64 -debug_all tests/fft8_tb_top.sv rtl/fft8_if.sv rtl/fft8.sv tests/fft8_tb.sv build/f_sim/fft8.simv > build/f_sim/fft8_compilation.txt
./build/f_sim/fft8.simv > build/f_sim/fft8_simulation.txt