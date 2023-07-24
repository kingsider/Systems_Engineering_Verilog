`timescale 1ns/1ns
module BiquadFilter_TB();

  // Declare inputs and outputs
  reg clk;
  reg signed [7:0] x;
  wire signed [7:0] y;

  // Instantiate the module being tested
  BiquadFilter dut(.clk(clk), .x(x), .y(y));

  // Set initial values for inputs
  initial begin
    clk = 0;
    x = 0;
  end

  // Generate clock signal
  always #10 clk <= ~clk;

  // Stimulate the module with test inputs and print the outputs
  initial 
  begin
    $dumpfile("biq_filter.vcd");   
    $dumpvars();   
    #20 x = 10;
    #20 x = -20;
    #20 x = 5;
    #20 x = 0;
    #20 x = 50;
    #20 $finish;
  end

  // Display output values
  always @(posedge clk) 
  begin
    $display("x = %d, y = %d", x, y);
  end

endmodule