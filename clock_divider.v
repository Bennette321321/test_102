module clock_divider (
    input wire clk_in,      // 100 MHz input clock
    input wire rst,
    output reg vga_clk,     // 25 MHz for VGA
    output reg sd_clk       // 25 MHz for SD card
);

    // Counter for VGA clock (divide by 4)
    reg [1:0] vga_counter;
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            vga_counter <= 2'b00;
            vga_clk <= 1'b0;
        end else begin
            vga_counter <= vga_counter + 1'b1;
            if (vga_counter == 2'b01)
                vga_clk <= 1'b1;
            else if (vga_counter == 2'b11)
                vga_clk <= 1'b0;
        end
    end

    // Counter for SD card clock (divide by 4)
    reg [1:0] sd_counter;
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            sd_counter <= 2'b00;
            sd_clk <= 1'b0;
        end else begin
            sd_counter <= sd_counter + 1'b1;
            if (sd_counter == 2'b01)
                sd_clk <= 1'b1;
            else if (sd_counter == 2'b11)
                sd_clk <= 1'b0;
        end
    end

endmodule 