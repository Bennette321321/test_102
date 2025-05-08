module image_buffer (
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_data_in,
    input wire data_valid,
    input wire [3:0] image_index,
    input wire [9:0] h_count,
    input wire [9:0] v_count,
    output reg [11:0] rgb_out
);

    parameter IMG_WIDTH = 320;
    parameter IMG_HEIGHT = 240;
    parameter NUM_IMAGES = 16;
    parameter BYTES_PER_PIXEL = 3; // RGB888 format

    // Calculate buffer size
    localparam BUFFER_SIZE = IMG_WIDTH * IMG_HEIGHT * BYTES_PER_PIXEL;
    
    // BRAM for image storage
    (* ram_style = "block" *) reg [7:0] image_buffer [0:BUFFER_SIZE-1];
    
    // Write address calculation
    reg [31:0] write_addr;
    always @(posedge clk) begin
        if (data_valid) begin
            write_addr <= (image_index * BUFFER_SIZE) + 
                         (v_count * IMG_WIDTH * BYTES_PER_PIXEL) + 
                         (h_count * BYTES_PER_PIXEL);
        end
    end

    // Write data to BRAM
    always @(posedge clk) begin
        if (data_valid && write_addr < NUM_IMAGES * BUFFER_SIZE) begin
            image_buffer[write_addr] <= pixel_data_in;
        end
    end

    // Read address calculation
    wire [31:0] read_addr;
    assign read_addr = (image_index * BUFFER_SIZE) + 
                      (v_count * IMG_WIDTH * BYTES_PER_PIXEL) + 
                      (h_count * BYTES_PER_PIXEL);

    // Read data and convert to RGB
    always @(posedge clk) begin
        if (h_count < IMG_WIDTH && v_count < IMG_HEIGHT) begin
            // Convert RGB888 to RGB444
            rgb_out <= {
                image_buffer[read_addr][7:4],     // R
                image_buffer[read_addr+1][7:4],   // G
                image_buffer[read_addr+2][7:4]    // B
            };
        end else begin
            rgb_out <= 12'h000; // Black outside image area
        end
    end

endmodule 