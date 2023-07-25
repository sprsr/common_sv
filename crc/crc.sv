module CRC(
    input logic clk,
    input logic rst,
    input logic [7:0] data_in,
    input logic start,
    input logic valid_in,
    output logic valid_out,
    output logic [N-1:0] crc
);

    parameter N = 16; // Set the desired CRC width

    // CRC polynomial
    parameter logic [N-1:0] CRC_POLY = 'h8005; // For example, CRC-16 with polynomial x^16 + x^15 + x^2 + 1

    // Internal state enum to track the state of the CRC calculator
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALCULATE_CRC = 2'b01
    } State;

    State current_state;
    logic [N-1:0] crc_accumulator;
    logic [7:0] data_byte_counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            crc_accumulator <= 'h0;
            data_byte_counter <= 8'b0;
            valid_out <= 1'b0;
        end else begin
            case (current_state)
                IDLE:
                    if (start) begin
                        current_state <= CALCULATE_CRC;
                        crc_accumulator <= 'h0;
                        data_byte_counter <= 8'b0;
                    end
                CALCULATE_CRC:
                    if (valid_in) begin
                        data_byte_counter <= data_byte_counter + 1;
                        crc_accumulator <= crc_accumulator ^ data_in;
                    end
                    if (data_byte_counter == 8'dN) begin
                        current_state <= IDLE;
                        valid_out <= 1'b1;
                    end
            endcase
        end
    end

    always_comb begin
        crc = crc_accumulator;
    end

endmodule
