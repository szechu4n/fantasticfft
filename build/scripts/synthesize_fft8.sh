echo "Synthesizing fft8..."

if [ ! -d "build/constraints" ]; then
    echo "Creating constraints directory..."
    mkdir build/constraints
fi

if [ ! -d "build/reports" ]; then
    echo "Creating reports directory..."
    mkdir build/reports
fi

if [ ! -d "build/synthesis" ]; then
    echo "Creating synthesis output directory..."
    mkdir build/synthesis
fi

dc_shell -f build/scripts/synthesize_fft8.tcl
