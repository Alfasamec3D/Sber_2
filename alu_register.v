// File: alu_register.v
module alu_register #(
    parameter WIDTH = 8
)(
    input  wire             clk_i,
    input  wire             arstn_i,
    input  wire [WIDTH-1:0] first_i,
    input  wire [WIDTH-1:0] second_i,
    input  wire [2:0]       opcode_i,
    output reg  [WIDTH-1:0] result_o
);

    reg [WIDTH-1:0] alu_result;

    // Комбинационная логика АЛУ
    always @(*) begin
        case (opcode_i)
            3'b000: alu_result = ~(first_i | second_i);                  // Побитовое НЕ-ИЛИ
            3'b001: alu_result = first_i & second_i;                     // Побитовое И
            3'b010: alu_result = $signed(first_i) + $signed(second_i);   // Сложение (знаковое)
            3'b011: alu_result = first_i + second_i;                     // Сложение (без знака)
            3'b100: alu_result = ~second_i;                              // Побитовое НЕ для second_i
            3'b101: alu_result = ~(first_i ^ second_i);                  // Побитовое НЕ-Исключающее ИЛИ (XNOR)
            3'b110: alu_result = { {(WIDTH-1){1'b0}}, (second_i == first_i) }; // second_i == first_i (0 или 1)
            3'b111: alu_result = first_i >> second_i;                    // Логический сдвиг first_i вправо на second_i
            default: alu_result = {WIDTH{1'b0}};
        endcase
    end

    // Последовательностная логика (Регистр с асинхронным сбросом)
    always @(posedge clk_i or negedge arstn_i) begin
        if (!arstn_i) begin
            result_o <= {WIDTH{1'b0}};
        end else begin
            result_o <= alu_result;
        end
    end

endmodule