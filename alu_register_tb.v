// File: alu_register_tb.v
`timescale 1ns/1ps

module alu_register_tb();

    localparam WIDTH = 8;

    reg             clk_i;
    reg             arstn_i;
    reg [WIDTH-1:0] first_i;
    reg [WIDTH-1:0] second_i;
    reg [2:0]       opcode_i;
    wire [WIDTH-1:0] result_o;

    // Инстанцирование модуля
    alu_register #(
        .WIDTH(WIDTH)
    ) dut (
        .clk_i(clk_i),
        .arstn_i(arstn_i),
        .first_i(first_i),
        .second_i(second_i),
        .opcode_i(opcode_i),
        .result_o(result_o)
    );

    // Генерация тактового сигнала
    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    initial begin
        $dumpvars; // Для генерации временных диаграмм

        // Инициализация и сброс
        first_i = 8'h00;
        second_i = 8'h00;
        opcode_i = 3'b000;
        arstn_i = 0; // Активный сброс
        #15;
        arstn_i = 1; // Снятие сброса
        #10;

        // 3'b000: Побитовое НЕ-ИЛИ (NOR) 
        first_i = 8'h0F; second_i = 8'hF0; opcode_i = 3'b000; #10;
        
        // 3'b001: Побитовое И (AND)
        first_i = 8'hFF; second_i = 8'hAA; opcode_i = 3'b001; #10;
        
        // 3'b010: Сложение (знаковое) (-2 + 5 = 3 -> 0xFE + 0x05 = 0x03)
        first_i = 8'hFE; second_i = 8'h05; opcode_i = 3'b010; #10;
        
        // 3'b011: Сложение (без знака) (200 + 50 = 250 -> 0xC8 + 0x32 = 0xFA)
        first_i = 8'hC8; second_i = 8'h32; opcode_i = 3'b011; #10;
        
        // 3'b100: Побитовое НЕ для second_i
        first_i = 8'h00; second_i = 8'hAA; opcode_i = 3'b100; #10;
        
        // 3'b101: Побитовое НЕ-Исключающее ИЛИ (XNOR)
        first_i = 8'hAA; second_i = 8'hAA; opcode_i = 3'b101; #10;
        
        // 3'b110: second_i == first_i (Истина)
        first_i = 8'h77; second_i = 8'h77; opcode_i = 3'b110; #10;
        
        // 3'b110: second_i == first_i (Ложь)
        first_i = 8'h77; second_i = 8'h88; opcode_i = 3'b110; #10;

        // 3'b111: Логический сдвиг first_i вправо на second_i (0xF0 >> 4 = 0x0F)
        first_i = 8'hF0; second_i = 8'h04; opcode_i = 3'b111; #10;

        #20;
        $finish;
    end
endmodule