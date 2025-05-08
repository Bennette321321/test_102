module sd_card_reader (
    input wire clk,          // System clock
    input wire rst,          // Reset signal
    input wire miso,         // SD card MISO
    output reg mosi,         // SD card MOSI
    output reg sclk,         // SD card SCLK
    output reg cs,           // SD card CS
    output reg [7:0] data_out, // Data output
    output reg data_valid,   // Data valid signal
    input wire [31:0] block_addr // Block address to read
);

    // SD Card Commands
    localparam CMD0  = 8'h40;  // GO_IDLE_STATE
    localparam CMD1  = 8'h41;  // SEND_OP_COND
    localparam CMD8  = 8'h48;  // SEND_IF_COND
    localparam CMD16 = 8'h50;  // SET_BLOCKLEN
    localparam CMD17 = 8'h51;  // READ_SINGLE_BLOCK
    localparam CMD55 = 8'h77;  // APP_CMD
    localparam ACMD41 = 8'h69; // SD_SEND_OP_COND

    // States
    localparam IDLE        = 4'd0;
    localparam INIT        = 4'd1;
    localparam SEND_CMD0   = 4'd2;
    localparam WAIT_CMD0   = 4'd3;
    localparam SEND_CMD8   = 4'd4;
    localparam WAIT_CMD8   = 4'd5;
    localparam SEND_CMD55  = 4'd6;
    localparam WAIT_CMD55  = 4'd7;
    localparam SEND_ACMD41 = 4'd8;
    localparam WAIT_ACMD41 = 4'd9;
    localparam SEND_CMD16  = 4'd10;
    localparam WAIT_CMD16  = 4'd11;
    localparam SEND_CMD17  = 4'd12;
    localparam WAIT_CMD17  = 4'd13;
    localparam READ_DATA   = 4'd14;
    localparam WAIT_TOKEN  = 4'd15;

    reg [3:0] state;
    reg [7:0] cmd_buffer;
    reg [7:0] data_buffer;
    reg [5:0] bit_counter;
    reg [31:0] arg;
    reg [31:0] response;
    reg [7:0] crc;
    reg [15:0] byte_counter;
    reg [7:0] token;

    // Clock divider for SPI (divide system clock by 4)
    reg [1:0] clk_div;
    wire spi_clk;
    assign spi_clk = clk_div[1];

    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_div <= 2'b00;
        else
            clk_div <= clk_div + 1'b1;
    end

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cs <= 1'b1;
            mosi <= 1'b1;
            sclk <= 1'b0;
            data_out <= 8'd0;
            data_valid <= 1'b0;
            bit_counter <= 6'd0;
            cmd_buffer <= 8'd0;
            data_buffer <= 8'd0;
            arg <= 32'd0;
            response <= 32'd0;
            crc <= 8'd0;
            byte_counter <= 16'd0;
            token <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    cs <= 1'b1;
                    mosi <= 1'b1;
                    sclk <= 1'b0;
                    data_valid <= 1'b0;
                    byte_counter <= 16'd0;
                    state <= INIT;
                end

                INIT: begin
                    cs <= 1'b1;
                    mosi <= 1'b1;
                    sclk <= 1'b0;
                    bit_counter <= 6'd0;
                    cmd_buffer <= CMD0;
                    arg <= 32'h00000000;
                    crc <= 8'h95;
                    state <= SEND_CMD0;
                end

                SEND_CMD0: begin
                    cs <= 1'b0;
                    if (spi_clk) begin
                        if (bit_counter < 8) begin
                            mosi <= cmd_buffer[7];
                            cmd_buffer <= {cmd_buffer[6:0], 1'b0};
                            bit_counter <= bit_counter + 1'b1;
                        end else if (bit_counter < 40) begin
                            mosi <= arg[31];
                            arg <= {arg[30:0], 1'b0};
                            bit_counter <= bit_counter + 1'b1;
                        end else if (bit_counter < 48) begin
                            mosi <= crc[7];
                            crc <= {crc[6:0], 1'b0};
                            bit_counter <= bit_counter + 1'b1;
                        end else begin
                            state <= WAIT_CMD0;
                        end
                    end
                    sclk <= spi_clk;
                end

                WAIT_CMD0: begin
                    if (miso == 1'b0) begin
                        cmd_buffer <= CMD8;
                        arg <= 32'h000001AA;
                        crc <= 8'h87;
                        state <= SEND_CMD0;
                    end
                end

                WAIT_TOKEN: begin
                    if (spi_clk) begin
                        token <= {token[6:0], miso};
                        if (bit_counter == 7) begin
                            if (token == 8'hFE) begin
                                state <= READ_DATA;
                            end
                        end
                        bit_counter <= bit_counter + 1'b1;
                    end
                    sclk <= spi_clk;
                end

                READ_DATA: begin
                    if (spi_clk) begin
                        data_buffer <= {data_buffer[6:0], miso};
                        if (bit_counter == 7) begin
                            data_out <= {data_buffer[6:0], miso};
                            data_valid <= 1'b1;
                            byte_counter <= byte_counter + 1'b1;
                        end else begin
                            data_valid <= 1'b0;
                        end
                        bit_counter <= bit_counter + 1'b1;
                        if (byte_counter == 512) begin
                            state <= IDLE;
                        end
                    end
                    sclk <= spi_clk;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule 