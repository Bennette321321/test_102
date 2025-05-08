module imageProcessing (
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_data_in,
    input wire data_valid,
    input wire [9:0] h_count,
    input wire [9:0] v_count,
    output reg [7:0] pixel_data_out
);

    parameter IMG_WIDTH = 320;
    parameter IMG_HEIGHT = 240;

    reg [7:0] image_buffer [0:IMG_WIDTH * IMG_HEIGHT - 1];
    integer index;

    // Store data into buffer
    always @(posedge clk) begin
        if (data_valid) begin
            index = (v_count * IMG_WIDTH) + h_count;
            if (index < IMG_WIDTH * IMG_HEIGHT)
                image_buffer[index] <= pixel_data_in;
        end
    end

    // Output pixel data based on VGA coordinates
    always @(posedge clk) begin
        if (h_count < IMG_WIDTH && v_count < IMG_HEIGHT) begin
            index = (v_count * IMG_WIDTH) + h_count;
            pixel_data_out <= image_buffer[index];
        end else begin
            pixel_data_out <= 8'd0;
        end
    end

endmodule