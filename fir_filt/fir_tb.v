module fir_tb;
    reg tb_clk = 1;
    reg [7:0] data;
    reg valid;

    localparam TB_NUM_OF_TAPS = 3;
    localparam TB_INPUT_WIDTH = 8;
    localparam TB_COEF_WIDTH = 8;

    initial
        forever #5 tb_clk=~tb_clk;

    integer i;
    integer tb_data[9:0];

    initial 
    begin
 tb_data[0] = 8'hDE;
 tb_data[1] = 8'hAD;
 tb_data[2] = 8'hBE;
 tb_data[3] = 8'hEF;
 tb_data[4] = 8'hCA;
 tb_data[5] = 8'hFE;
 tb_data[6] = 8'hBA;
 tb_data[7] = 8'hBA;
 tb_data[8] = 8'hDE;
 tb_data[9] = 8'hDA;
 valid = 0;
 data = 0;
        for(i = 0; i < 10; i = i + 1)
        begin
 data = tb_data[i];
 valid = 1;
            #10;
 valid = 0;
            #90;
        end
    end

    initial
    begin
        $dumpfile("fir_filter.vcd");
        $dumpvars(0, fir_tb);
    end

    fir #(
 .NUM_OF_TAPS(TB_NUM_OF_TAPS),
 .INPUT_WIDTH(TB_INPUT_WIDTH),
 .COEF_WIDTH(TB_COEF_WIDTH)
 ) filter_instance(
 .clk(tb_clk),
 .input_data(data),
 .input_data_flag(valid)
    );

endmodule