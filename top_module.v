module top_module (
    input wire clk,          // System clock (100 MHz)
    input wire rst,          // Reset signal
    input wire btnc,         // Center button for image switching
    input wire btnu,         // Up button for blending control
    input wire btnd,         // Down button for blending control
    input wire miso,         // SD card MISO
    output wire mosi,        // SD card MOSI
    output wire sclk,        // SD card SCLK
    output wire cs,          // SD card CS
    output wire h_sync,      // VGA horizontal sync
    output wire v_sync,      // VGA vertical sync
    output wire [11:0] rgb   // VGA RGB output (12-bit color)
);

    // Internal signals
    wire [9:0] h_count;
    wire [9:0] v_count;
    wire display_enable;
    wire [7:0] sd_data_out;
    wire sd_data_valid;
    wire [3:0] image_index;
    wire [11:0] rgb_out;
    wire [7:0] blend_factor;
    wire [31:0] block_addr;
    wire vga_clk;
    wire sd_clk;

    // Clock divider
    clock_divider clk_div (
        .clk_in(clk),
        .rst(rst),
        .vga_clk(vga_clk),
        .sd_clk(sd_clk)
    );

    // Instantiate VGA Controller
    vga_controller vga_ctrl (
        .clk(vga_clk),
        .rst(rst),
        .h_count(h_count),
        .v_count(v_count),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .display_enable(display_enable)
    );


    sd_card_reader sd_reader (
        .clk(sd_clk),
        .rst(rst),
        .miso(miso),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .data_out(sd_data_out),
        .data_valid(sd_data_valid),
        .block_addr(block_addr)
    );

    // Instantiate User Interaction Module
    UserInteraction user_int (
        .clk(clk),
        .rst(rst),
        .btnc(btnc),
        .btnu(btnu),
        .btnd(btnd),
        .image_index(image_index),
        .blend_factor(blend_factor)
    );

    // Instantiate Image Buffer
    image_buffer img_buf (
        .clk(clk),
        .rst(rst),
        .pixel_data_in(sd_data_out),
        .data_valid(sd_data_valid),
        .image_index(image_index),
        .h_count(h_count),
        .v_count(v_count),
        .rgb_out(rgb_out)
    );

    // Image blending logic
    reg [11:0] blended_rgb;
    always @(posedge clk) begin
        if (display_enable) begin
            // Simple alpha blending between current and next image
            blended_rgb <= (rgb_out * blend_factor + 
                          rgb_out * (8'd255 - blend_factor)) >> 8;
        end else begin
            blended_rgb <= 12'h000;
        end
    end

    // Output assignment
    assign rgb = display_enable ? blended_rgb : 12'h000;

endmodule 