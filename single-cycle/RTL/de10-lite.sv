module de10_lite(
    input logic CLK,
    input logic [1:0] KEY,
    input logic [9:0] SW,

    output logic [9:0]  LED,
    output logic [6:0]  HEX0,
    output logic [6:0]  HEX1,
    output logic [6:0]  HEX2,
    output logic [6:0]  HEX3,
    output logic [6:0]  HEX4,
    output logic [6:0]  HEX5    
);

    logic rst;
    logic enable;
    logic [31:0] pc_out;
    logic [31:0] instruction_out;
    logic [23:0] display_data;

    assign rst = ~KEY[0]; //KEY buttons active-low

    // debouncing

    logic key_meta;
    logic key_sync;
    logic key_stable;
    logic key_stable_d;

    logic [19:0] debounce_count;

    // synchronize the asynchronous pushbutton input
    always_ff @(posedge CLK or posedge rst) begin
        if (rst) begin
            key_meta <= 1'b1;
            key_sync <= 1'b1;
        end
        else begin
            key_meta <= KEY[1];
            key_sync <= key_meta;
        end
    end

    // require the synchronized button state to remain
    // unchanged for approximately 20 ms.
    always_ff @(posedge CLK or posedge rst) begin
        if (rst) begin
            key_stable    <= 1'b1;
            debounce_count <= 20'd0;
        end
        else begin
            if (key_sync == key_stable) begin
                debounce_count <= 20'd0;
            end
            else if (&debounce_count) begin
                key_stable     <= key_sync;
                debounce_count <= 20'd0;
            end
            else begin
                debounce_count <= debounce_count + 1'b1;
            end
        end
    end

    // generate one clock-cycle enable for each press
    // a press changes KEY[1] from 1 to 0.
    always_ff @(posedge CLK or posedge rst) begin
        if (rst) begin
            key_stable_d <= 1'b1;
            step_enable  <= 1'b0;
        end
        else begin
            key_stable_d <= key_stable;
            step_enable  <= key_stable_d & ~key_stable;
        end
    end

    cpu cpu_inst (
        .clk             (CLK),
        .rst             (rst),
        .enable          (step_enable),
        .pc_out          (pc_out),
        .instruction_out (instruction_out)
    );

    // LEDs' show PC in binary

    assign LED = pc_out[9:0];

    //SW0 switches between PC and instruction

    always_comb begin
        if (SW[0])
            display_data = instruction_out[23:0];
        else
            display_data = pc_out[23:0];
    end

    hex_decoder h0 (
        .value(display_data[3:0]),
        .segments(HEX0)
    );

    hex_decoder h1 (
        .value(display_data[7:4]),
        .segments(HEX1)
    );

    hex_decoder h2 (
        .value(display_data[11:8]),
        .segments(HEX2)
    );

    hex_decoder h3 (
        .value(display_data[15:12]),
        .segments(HEX3)
    );

    hex_decoder h4 (
        .value(display_data[19:16]),
        .segments(HEX4)
    );

    hex_decoder h5 (
        .value(display_data[23:20]),
        .segments(HEX5)
    );

endmodule


//seven seg hex decoder
//segments are active low

module hex_decoder (
    input  logic [3:0] value,
    output logic [6:0] segments
);

    always_comb begin
        case (value)
            4'h0: segments = 7'b1000000;
            4'h1: segments = 7'b1111001;
            4'h2: segments = 7'b0100100;
            4'h3: segments = 7'b0110000;
            4'h4: segments = 7'b0011001;
            4'h5: segments = 7'b0010010;
            4'h6: segments = 7'b0000010;
            4'h7: segments = 7'b1111000;
            4'h8: segments = 7'b0000000;
            4'h9: segments = 7'b0010000;
            4'hA: segments = 7'b0001000;
            4'hB: segments = 7'b0000011;
            4'hC: segments = 7'b1000110;
            4'hD: segments = 7'b0100001;
            4'hE: segments = 7'b0000110;
            4'hF: segments = 7'b0001110;
            default: segments = 7'b1111111;
        endcase
    end

endmodule
