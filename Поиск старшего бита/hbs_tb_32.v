`timescale 1ns/1ns

 module high_bit_search_tb;
    localparam TB_INPUT_WIDTH = 32;

    reg tb_clk = 1;
    reg [TB_INPUT_WIDTH-1:0] input_data;

    reg [TB_INPUT_WIDTH-1:0] idx; 

    initial 
        forever #5 tb_clk=~tb_clk;

    integer tb_data[9:0];

    initial 
    begin
    tb_data[0] = 32'hDEADBEEF;
    tb_data[1] = 32'h00005403;
    tb_data[2] = 32'h005030BE;
    tb_data[3] = 32'h30400F15;
    tb_data[4] = 32'h141287CA;
    tb_data[5] = 32'h00000024;
    tb_data[6] = 32'h131323BA;
    tb_data[7] = 32'h7378BF76;
    tb_data[8] = 32'hFEFA14DE;
    tb_data[9] = 32'h15117643;
    input_data = 0; 
    for(idx = 0; idx < 10; idx = idx + 1)
    begin 
        input_data = tb_data[idx]; 
        #10; 
    end
    end

    initial
    begin
        $dumpfile("high_bit_search.vcd");
        $dumpvars(0, high_bit_search_tb);
    end

    high_bit_search #(.INPUT_WIDTH(TB_INPUT_WIDTH)) high_bit_search_instance (
    .clk(tb_clk),
    .input_data(input_data)
    );

endmodule 