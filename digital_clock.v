// digital_clock.v
module digital_clock(
    input clk_1hz, 
    input reset,    
    output reg [6:0] sec_units_display,
    output reg [6:0] sec_tens_display,   
    output reg [6:0] min_units_display,  
    output reg [6:0] min_tens_display,   
    output reg [6:0] hour_units_display,
    output reg [6:0] hour_tens_display
);

    reg [3:0] sec_units = 0;
    reg [2:0] sec_tens = 0;
    reg [3:0] min_units = 0;
    reg [2:0] min_tens = 0;
    reg [3:0] hour_units = 0;
    reg [1:0] hour_tens = 0;

    wire sec_units_carry, sec_tens_carry, min_units_carry, min_tens_carry;
    wire hours_reset;

    assign sec_units_carry = (sec_units == 4'd9);
    assign sec_tens_carry = (sec_tens == 3'd5) && sec_units_carry;
    assign min_units_carry = (min_units == 4'd9) && sec_tens_carry;
    assign min_tens_carry = (min_tens == 3'd5) && min_units_carry;
    assign hours_reset = (hour_tens == 2'd2) && (hour_units == 4'd3) && min_tens_carry;

    always @(posedge clk_1hz or posedge reset) begin
        if (reset) begin
            sec_units <= 0;
            sec_tens <= 0;
            min_units <= 0;
            min_tens <= 0;
            hour_units <= 0;
            hour_tens <= 0;
        end else begin
            if (sec_units == 9)
                sec_units <= 0;
            else
                sec_units <= sec_units + 1;

            if (sec_units_carry) begin
                if (sec_tens == 5)
                    sec_tens <= 0;
                else
                    sec_tens <= sec_tens + 1;
            end

            if (sec_tens_carry) begin
                if (min_units == 9)
                    min_units <= 0;
                else
                    min_units <= min_units + 1;
            end

            if (min_units_carry) begin
                if (min_tens == 5)
                    min_tens <= 0;
                else
                    min_tens <= min_tens + 1;
            end

            if (min_tens_carry) begin
                if (hours_reset) begin
                    hour_units <= 0;
                    hour_tens <= 0;
                end else if ((hour_tens == 2 && hour_units == 3)) begin
                    hour_units <= 0;
                    hour_tens <= 0;
                end else if (hour_units == 9 || (hour_tens == 1 && hour_units == 9)) begin
                    hour_units <= 0;
                    hour_tens <= hour_tens + 1;
                end else begin
                    hour_units <= hour_units + 1;
                end
            end
        end
    end

    function [6:0] bcd_to_7seg(input [3:0] bcd);
        case (bcd)
            4'd0: bcd_to_7seg = 7'b1111110; 
            4'd1: bcd_to_7seg = 7'b0110000; 
            4'd2: bcd_to_7seg = 7'b1101101;
            4'd3: bcd_to_7seg = 7'b1111001;
            4'd4: bcd_to_7seg = 7'b0110011; 
            4'd5: bcd_to_7seg = 7'b1011011; 
            4'd6: bcd_to_7seg = 7'b1011111; 
            4'd7: bcd_to_7seg = 7'b1110000; 
            4'd8: bcd_to_7seg = 7'b1111111; 
            4'd9: bcd_to_7seg = 7'b1111011; 
            default: bcd_to_7seg = 7'b0000000;
        endcase
    endfunction

    always @(posedge clk_1hz or posedge reset) begin
        sec_units_display  = bcd_to_7seg(sec_units);
        sec_tens_display   = bcd_to_7seg({1'b0, sec_tens});
        min_units_display  = bcd_to_7seg(min_units);
        min_tens_display   = bcd_to_7seg({1'b0, min_tens});
        hour_units_display = bcd_to_7seg(hour_units);
        hour_tens_display  = bcd_to_7seg({2'b00, hour_tens});
    end
endmodule
