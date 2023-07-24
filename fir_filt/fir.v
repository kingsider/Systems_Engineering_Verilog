module fir(
    input clk,
    input signed [INPUT_WIDTH-1:0] input_data,
    input input_data_flag,

    output reg done_flag = 1,
    output reg signed [RESULT_WIDTH-1:0]result = 0
);

parameter NUM_OF_TAPS = 3;
parameter INPUT_WIDTH = 8;
parameter COEF_WIDTH = 8;

localparam MULTIPLIED_WIDTH = (INPUT_WIDTH+COEF_WIDTH);
localparam RESULT_WIDTH = (MULTIPLIED_WIDTH+NUM_OF_TAPS-1);

reg signed [INPUT_WIDTH-1:0] data[NUM_OF_TAPS-1:0];
reg signed [COEF_WIDTH-1:0] coefs[NUM_OF_TAPS-1:0];
reg signed [COEF_WIDTH-1:0] curr_coef = 0;
reg signed [INPUT_WIDTH-1:0] curr_data = 0;
wire signed [MULTIPLIED_WIDTH-1:0] mult = curr_data * curr_coef;
reg [$clog2(NUM_OF_TAPS):0] cnt = 0;



integer i;
initial 
begin
    for (i = 0; i < NUM_OF_TAPS; i = i + 1)
        begin
            data[i] = i + 1;
            coefs[i] = (i + 1) * 2;
        end
end


always @(posedge clk)
begin
    if (input_data_flag == 1)
        begin
            done_flag <= 0;
            for (i = NUM_OF_TAPS-1; i >= 0; i = i - 1)
            begin
                if(i != 0)
                    data[i] <= data[i - 1];
                else
                begin
                    data[i] <= input_data;
                end
            end
        end
end


always@(posedge clk)
	begin
        if(cnt != 0)
            cnt <= cnt + 1;
        else
		    cnt <= input_data_flag;
        
        curr_data <= cnt > 0 && cnt < NUM_OF_TAPS+1 ? data[cnt - 1] : curr_data;
        curr_coef <= cnt > 0 && cnt < NUM_OF_TAPS+1 ? coefs[cnt - 1] : curr_coef;

        if(cnt == NUM_OF_TAPS+1)
        begin
            cnt <= 0;        
			done_flag <= 1;
        end

        if(input_data_flag == 1)
            begin
                curr_data <= 0;
                curr_coef <= 0;
            end

	end


always@(posedge clk)
    begin
        if(input_data_flag == 1)
            result <= 0;
        else if (!done_flag)
            result <= result + mult;
    end

endmodule