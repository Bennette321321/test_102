module vga_controller (
    input wire clk,
    input wire rst,
    output reg [9:0] h_count,
    output reg [9:0] v_count,
    output reg h_sync,
    output reg v_sync,
    output reg display_enable
);

    parameter H_DISPLAY = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter V_DISPLAY = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
            display_enable <= 0;
        end else begin
            if (h_count < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH - 1))
                h_count <= h_count + 1;
            else begin
                h_count <= 0;
                if (v_count < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH - 1))
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
            end

            h_sync <= (h_count >= (H_DISPLAY + H_FRONT_PORCH)) && (h_count < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE));
            v_sync <= (v_count >= (V_DISPLAY + V_FRONT_PORCH)) && (v_count < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE));
            display_enable <= (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
        end
    end

endmodule