module TensorCore #(parameter DATA_WIDTH = 32) (
  input logic [DATA_WIDTH-1:0] matrix_A[8][8],   // 8x8 input matrix A
  input logic [DATA_WIDTH-1:0] matrix_B[8][8],   // 8x8 input matrix B
  output logic [DATA_WIDTH-1:0] result_matrix[8][8]  // 8x8 output matrix
);
  // Internal variables for matrix multiplication
  logic [DATA_WIDTH-1:0] temp_accum[8][8];
  logic [DATA_WIDTH-1:0] product[8][8];

  // Initialize temp_accum and product to zero
  initial begin
    for (int i = 0; i < 8; i++) begin
      for (int j = 0; j < 8; j++) begin
        temp_accum[i][j] = 0;
        product[i][j] = 0;
      end
    end
  end

  // Matrix multiplication using a basic Tensor Core algorithm
  always_comb begin
    for (int i = 0; i < 8; i++) begin
      for (int j = 0; j < 8; j++) begin
        for (int k = 0; k < 8; k++) begin
          // Multiply and accumulate
          temp_accum[i][j] += matrix_A[i][k] * matrix_B[k][j];
        end
        // Final result rounding and saturation (if required)
        product[i][j] = temp_accum[i][j] >> 8; // Right-shift by 8 bits for rounding
      end
    end
  end

  // Assign the result to the output
  assign result_matrix = product;

endmodule
