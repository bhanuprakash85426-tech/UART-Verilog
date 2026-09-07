module receiver (
    input        clk,
    input        rx,
    input        enb,
    input        rst,

    output reg [7:0] data_out,
    output reg       done
);

    // FSM states
    parameter idle_state  = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state  = 2'b10;
    parameter stop_state  = 2'b11;

    // Internal registers
    reg [1:0] state;
    reg [2:0] index;
    reg [7:0] data;

    // Receiver FSM
    always @(posedge clk) begin

        if (rst) begin
            state    <= idle_state;
            index    <= 3'b000;
            data     <= 8'b0;
            data_out <= 8'b0;
            done     <= 1'b0;
        end

        else begin

            done <= 1'b0;

            case (state)

                // IDLE
                idle_state: begin
                    if (rx == 1'b0) begin
                        state <= start_state;
                    end
                end

                // START
                start_state: begin
                    if (enb) begin
                        if (rx == 1'b0) begin
                            state <= data_state;
                            index <= 3'b000;
                        end
                        else begin
                            state <= idle_state;
                        end
                    end
                end

                // DATA
                data_state: begin
                    if (enb) begin

                        data[index] <= rx;

                        if (index == 3'b111) begin
                            state <= stop_state;
                        end
                        else begin
                            index <= index + 3'b001;
                        end

                    end
                end

                // STOP
                stop_state: begin
                    if (enb) begin

                        if (rx == 1'b1) begin
                            data_out <= data;
                            done     <= 1'b1;
                        end

                        state <= idle_state;

                    end
                end

                // DEFAULT
                default: begin
                    state <= idle_state;
                    index <= 3'b000;
                    data  <= 8'b0;
                end

            endcase

        end

    end

endmodule