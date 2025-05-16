`timescale 1s/1ms

module digital_clock_tb;

    reg clk = 0;
    reg reset = 0;

    wire [6:0] sec_units_display;
    wire [6:0] sec_tens_display;
    wire [6:0] min_units_display;
    wire [6:0] min_tens_display;
    wire [6:0] hour_units_display;
    wire [6:0] hour_tens_display;

    digital_clock uut (
        .clk_1hz(clk),
        .reset(reset),
        .sec_units_display(sec_units_display),
        .sec_tens_display(sec_tens_display),
        .min_units_display(min_units_display),
        .min_tens_display(min_tens_display),
        .hour_units_display(hour_units_display),
        .hour_tens_display(hour_tens_display)
    );

    always #0.5 clk = ~clk; // 1Hz clock

    initial begin
        $dumpfile("clock.vcd");
        $dumpvars(0, digital_clock_tb);
        reset = 1;
        #2 reset = 0;

        #100;
        $finish;
    end

endmodule
