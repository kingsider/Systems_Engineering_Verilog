module axi_stream_mux #(
 parameter DATA_WIDTH = 8,
 parameter NUM_STREAMS = 2
) 
(
 input wire [NUM_STREAMS-1:0] select,
 input wire [DATA_WIDTH-1:0] stream_input_0,
 input wire [DATA_WIDTH-1:0] stream_input_1,
 output reg [DATA_WIDTH-1:0] stream_output
);

always @(\*) begin
 case (select)
 2'b00: stream_output = stream_input_0;
 2'b01: stream_output = stream_input_1;
 default: stream_output = 0;
 endcase
end

endmodule