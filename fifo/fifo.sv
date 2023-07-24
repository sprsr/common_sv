// A simple synchronous fifo
// Sam Presser
module fifo
#( 
  parameter WIDTH = 16,
  parameter SIZE  = 16
)
  (
    // Inputs - clock and reset
    input                           clk_core  ,
    input                           rst_core  ,
    // Operation Control
    input                           fifo_read ,
    input                           fifo_write,
    // Data Input
    input        [WIDTH-1:0]        data_input,
    // Data Output
    output logic [WIDTH-1:0]        data_output,
    // Empty and Full Indicators
    output logic                          empty,
    output logic                           full
  );

    // Internal Signals
    // FIFO Memory
    logic [WIDTH-1:0][0:SIZE-1:0]  fifo_memory;

    // Read and Write Address Locations
    logic [$clog2(SIZE)-1:0]         read_addr;
    logic [$clog2(SIZE)-1:0]        write_addr;

  // Assign Empty and Full Indicators.
  // If Write and Read Addresses are equal, memory is empty
  assign empty = (write_addr == read_addr);

  // If the Write Address is in memory location below read address
  // consider the FIFO full. Leaving the last memory location empty
  // intentionally.
  assign full  = ((write_addr + 1'b1) == read_addr);

  always_ff @ (posedge clk_core or posedge rst_core) begin

    // Reset the Read and Write Addresses, Empty and Full Indicators
    // and Clear Memory.
    if (rst_core) begin
      read_addr   <=    0;
      write_addr  <=    0;
      empty       <= 1'b1;
      full        <= 1'b0;
      foreach (fifo_memory[i]) begin
        fifo_memory[i] <= 0;
      end

    end else begin

    // If the FIFO is not full and a write operation is input
    // FIFO Memory at the Write Address location is set to data input,
    // and write address is incremented.
      if (!full & fifo_write) begin
        fifo_memory[write_addr] <= data_input;
        write_addr <= write_addr + 1;
      end

      // If the FIFO is not empty and a read operation is input
      // data_out is set to the memory in the read address, 
      // and read address is incremented.
      end else if (!empty & fifo_read) begin
        data_out <= fifo_memory[read_addr];
        read_addr <= read_addr + 1;
      end
    end
  end
endmodule
    
