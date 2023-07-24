`timescale 1ns/1ns

 module high_bit_search_tb;
    localparam TB_INPUT_WIDTH = 64;

    reg tb_clk = 1;
    reg [TB_INPUT_WIDTH-1:0] input_data;

    reg [TB_INPUT_WIDTH-1:0] idx; 

    initial 
        forever #5 tb_clk=~tb_clk;

    integer tb_data[9:0];

    initial 
    begin
    tb_data[0] = 64'hE12968038047B2AB;
    tb_data[1] = 64'h0000000000000597;
    tb_data[2] = 64'h8D39CF973BBC30DA;
    tb_data[3] = 64'h000000E279033CE5;
    tb_data[4] = 64'hA7302991F7626784;
    tb_data[5] = 64'h000FC21B081DAC32;
    tb_data[6] = 64'h87C8CE39F5398552;
    tb_data[7] = 64'h00000000000C496F;
    tb_data[8] = 64'h79AD83DD798A50C1;
    tb_data[9] = 64'hE4066723C9AFE72C;
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