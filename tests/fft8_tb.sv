`timescale 1ns/10ps

// Andrew Sweeney
// CPE 527 Lab 004
// Multiplier Test Bench

// verilator lint_off all


module fantastic_fft8_tb (
    fantasticfft_fft8_if fft8if
);

    // Reset delay and duration variables
    int startDelay_cc, startDuration_cc;
    localparam WIDTH_BITS = 8;

    // Operands and temporary result variable
    logic [WIDTH_BITS - 1 : 0] operand1, operand2, result;

    // clock cycle count
    int count_cc;

    // Packet class that contains random variables and constants
    Packet p;

    // number of bitwise additions performed coincides with the number of clock cycles elapsed in the ADD state.
    int numShifts;

    // Debug flag for development
    int DEBUG = 1;

    int idleCount = 0;

    // Black-Box States
    typedef enum bit [1:0] { IDLE, MULTIPLY, RESULT } blackbox_t;
    blackbox_t state, next;

    // String for debugging
    string stateString;
    
    initial begin
        // Create new packet for randomization information.
        p = new();
        
        // Initialize reset delay and duration for initial test run.
        startDelay_cc    = 0;
        startDuration_cc = 3;

        // Set operands to arbitrary values.
        operand1 = 'b10010101;
        operand2 = 'b01011101;

        // Blackbox state initializes at IDLE.
        state = IDLE;

        // Treat the dut initially with the most standard behavior, then test offnominal cases.
        repeat (3)
        begin
            // Initial application of start.
            // It is assumed that start serves both as a synchronous reset and to start the multiplication. 
            // There is a one-cycle delay after start is deasserted before the inputs are read in. Until start is
            // raised the first time, the outputs are entirely garbage, since there is no indicated reset for the 
            // component in the provided diagram, and start was allocated the role as reset.
            multif.multiplicand = operand1;
            multif.multiplier   = operand2;
            multif.start        = 1;

            @(posedge multif.clk);
            // 1 Delta step of delay to allow for setting of values.
            #1step

            state = IDLE;

            $display("Run statistics:\nStart Duration: %d\tOP1: %d\tOP2: %d\t", 
                startDuration_cc, operand1, operand2);
            $display("-----------------------------------------");

            // Initialize clock cycle for run
            count_cc = 0;

            // Repeat for the maximum number of clock cycles
            repeat (p.MAX_CC)
            begin
                // Wait to deassert start, once start is deasserted, the system is running
                case (state)
                    IDLE: begin
                        if (multif.start == 1) begin
                            if (startDuration_cc > 0) begin
                                startDuration_cc = startDuration_cc - 1;
                                next = IDLE;
                            end else begin
                                next = MULTIPLY;
                                multif.start = 0;
                            end
                        end else begin
                            idleCount = idleCount + 1;
                            next = IDLE;
                        end
                    end
                    MULTIPLY: begin
                        if (numShifts < 18) begin
                            numShifts = numShifts + 1;
                            next = MULTIPLY;
                        end else begin
                            next = RESULT;
                            numShifts = 0;
                        end
                    end
                    RESULT: begin
                        next = IDLE;
                    end
                endcase


                @(posedge multif.clk);
                #1step;
                count_cc = count_cc + 1;
                state = next;
                #2;

                case (state)
                    IDLE:     stateString = "IDLE";
                    MULTIPLY: stateString = "MULTIPLY"; 
                    RESULT:   stateString = "RESULT"; 
                endcase

                // Display current states of bits
                $display("Time_s: %f\tCC: %d\tState: %s\tStart: %d\tDone: %d\tProduct: %d\tMP: %d",
                    $time(), count_cc, stateString, multif.start, multif.done, multif.product, multif.mp);

                if (DEBUG != 1) begin
                    case (state)
                        IDLE: begin
                            // in the idle state, none of the outputs are valid, except done should be deasserted
                            assert (multif.done == 0) 
                            else   $fatal(1, "%s: Done flag should be 0.", stateString);
                        end
                        MULTIPLY: begin
                            // in the multiply state, the only indication of the active operation is the shifting and adding in the result. 
                            // done should continue to be deasserted
                            result = operand1 * operand2;                        
                            assert (multif.done == 0) 
                            else   $fatal(1, "%s: Done flag should be 0.", stateString);
                        end
                        RESULT: begin
                            assert (multif.done == 1) 
                            else   $fatal(1, "%s: Done flag should be 1.", stateString);

                            assert (multif.mp == result[7:0]) 
                            else   $fatal(1, "RESULT: Operand %d bus does not match expected %d.", multif.mp, result);
                        end
                    endcase
                end

                if (state == IDLE && idleCount > 3) begin
                    break;
                end
            end
            if (DEBUG == 1) begin
                $finish();
            end

            assert(p.randomize())
            else $fatal(1, "Packet::randomize failed.");
            startDelay_cc = p.startDelay_cc;
            startDuration_cc = p.startDuration_cc;

            operand1 = p.operand1;
            operand2 = p.operand2;
            idleCount = 0;

            numShifts = 0;
            state = IDLE;
            next = IDLE;

            multif.start = 1;
            @(posedge multif.clk);
        end
        $finish();
    end
endmodule
