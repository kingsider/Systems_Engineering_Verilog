`timescale 1ns/1ns

 module high_bit_search 
 #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = $clog2(INPUT_WIDTH)
 )
 (
    input clk,
    input wire [INPUT_WIDTH-1:0] input_data,
    output wire output_valid_flag,
    output wire [OUTPUT_WIDTH-1:0] output_data
);

//parameter INPUT_WIDTH = 8;

//parameter OUTPUT_WIDTH = $clog2(INPUT_WIDTH);

localparam LEVELS = INPUT_WIDTH > 2 ? OUTPUT_WIDTH : 1;
localparam WIDTH_PADDED = 2**LEVELS;

reg [WIDTH_PADDED/2-1:0] valid_pair[LEVELS-1:0];
reg [WIDTH_PADDED/2-1:0] high_value[LEVELS-1:0];

integer i;
initial 
begin
    for (i = 0; i < LEVELS-1; i = i + 1)
        begin
            valid_pair[i] = 0;
            high_value[i] = 0;
        end
end

generate
    genvar curr_level, bit_num;

    for (bit_num = 0; bit_num < WIDTH_PADDED/2; bit_num = bit_num + 1)
    begin : loop_in
        always @(posedge clk )
        begin
            valid_pair[0][bit_num] <= |input_data[bit_num*2+1:bit_num*2];
            high_value[0][bit_num] <= input_data[bit_num*2+1];
        end
    end

    for (curr_level = 1; curr_level < LEVELS; curr_level = curr_level + 1) 
    begin : loop_levels
        for (bit_num = 0; bit_num < WIDTH_PADDED/(2*2**curr_level); bit_num = bit_num + 1) 
        begin : loop_compress
            always @(posedge clk ) 
            begin
                valid_pair[curr_level][bit_num] <= |valid_pair[curr_level-1][bit_num*2+1:bit_num*2];
                high_value[curr_level][(bit_num+1)*(curr_level+1)-1:bit_num*(curr_level+1)] <= valid_pair[curr_level-1][bit_num*2+1] ? 
                                               {1'b1, high_value[curr_level-1][(bit_num*2+2)*curr_level-1:(bit_num*2+1)*curr_level]} : 
                                               {1'b0, high_value[curr_level-1][(bit_num*2+1)*curr_level-1:(bit_num*2+0)*curr_level]};
            end
        end
    end
endgenerate

assign output_valid_flag = valid_pair[LEVELS-1];
assign output_data = high_value[LEVELS-1];

endmodule