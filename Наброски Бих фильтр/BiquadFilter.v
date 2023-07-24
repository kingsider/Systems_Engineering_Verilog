`timescale 1ns/1ns
module BiquadFilter(
    input clk,
    input signed [7:0] x,
    output reg signed [7:0] y
);

    reg signed [15:0] yreg0, yreg1, yreg2;
    reg signed [15:0] xreg0, xreg1;
    parameter signed [7:0] a = 10;
    parameter signed [7:0] b = 5;

    always @(posedge clk) 
    begin
        xreg0 <= x;  // Записываем входные данные в xreg0
        yreg0 <= (a * yreg1) + (b * xreg1);  // Вычисляем yk+1
        y <= yreg0[7:0];  // Устанавливаем значение y на выход

        // Сохраняем значения для следующей итерации
        xreg1 <= xreg0;
        yreg2 <= yreg1;
        yreg1 <= yreg0;
    end
endmodule