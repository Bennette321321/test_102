module UserInteraction (
    input wire clk,
    input wire rst,
    input wire btnc,         // Center button for image switching
    input wire btnu,         // Up button for blending control
    input wire btnd,         // Down button for blending control
    output reg [3:0] image_index,
    output reg [7:0] blend_factor
);

    reg btnc_prev, btnu_prev, btnd_prev;
    reg [15:0] debounce_counter;
    parameter DEBOUNCE_DELAY = 50000; // Adjust as needed

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            debounce_counter <= 16'd0;
            btnc_prev <= 1'b0;
            btnu_prev <= 1'b0;
            btnd_prev <= 1'b0;
            image_index <= 4'd0;
            blend_factor <= 8'd128; // Start with 50% blend
        end else begin
            // Image switching with center button
            if (btnc != btnc_prev) begin
                debounce_counter <= debounce_counter + 1;
                if (debounce_counter >= DEBOUNCE_DELAY) begin
                    debounce_counter <= 16'd0;
                    btnc_prev <= btnc;
                    if (btnc == 1'b1) begin
                        image_index <= image_index + 1;
                        if (image_index == 4'd15) begin
                            image_index <= 4'd0;
                        end
                    end
                end
            end

            // Blend factor control with up/down buttons
            if (btnu != btnu_prev) begin
                debounce_counter <= debounce_counter + 1;
                if (debounce_counter >= DEBOUNCE_DELAY) begin
                    debounce_counter <= 16'd0;
                    btnu_prev <= btnu;
                    if (btnu == 1'b1 && blend_factor < 8'd255) begin
                        blend_factor <= blend_factor + 8'd1;
                    end
                end
            end

            if (btnd != btnd_prev) begin
                debounce_counter <= debounce_counter + 1;
                if (debounce_counter >= DEBOUNCE_DELAY) begin
                    debounce_counter <= 16'd0;
                    btnd_prev <= btnd;
                    if (btnd == 1'b1 && blend_factor > 8'd0) begin
                        blend_factor <= blend_factor - 8'd1;
                    end
                end
            end

            if (btnc == btnc_prev && btnu == btnu_prev && btnd == btnd_prev) begin
                debounce_counter <= 16'd0;
            end
        end
    end

endmodule