module Calculator(
  input logic [31:0] operand1,
  input logic [31:0] operand2,
  input logic [1:0] operator,
  output logic [31:0] result,
  output logic overflow
);

  always_comb begin
    case (operator)
      2'b00: result = operand1 + operand2; // Addition
      2'b01: result = operand1 - operand2; // Subtraction
      2'b10: result = operand1 * operand2; // Multiplication
      2'b11: begin
        if (operand2 == 0) begin
          result = 32'h0; // Division by zero
          overflow = 1'b1;
        end else begin
          result = operand1 / operand2; // Division
          overflow = 1'b0;
        end
      end
      default: result = 32'h0; // Invalid operator
    endcase
  end

endmodule
