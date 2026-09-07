module transmitter (
    input        clk,
    input        wr_en,
    input        rst,
    input  [7:0] data_in,
    output reg   tx,
    output       busy
);

    // FSM states
    parameter idle_state  = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state  = 2'b10;
    parameter stop_state  = 2'b11;

    // Internal registers
    reg [7:0] data;
    reg [2:0] index;
    reg [1:0] state;

    // FSM
    always @(posedge clk) begin

        if (rst) begin
            tx    <= 1'b1;
            state <= idle_state;
            data  <= 8'b0;
            index <= 3'b000;
        end

        else begin

            case (state)

                idle_state: begin
                    tx <= 1'b1;

                    if (wr_en) begin
                        state <= start_state;
                        data  <= data_in;
                        index <= 3'b000;
                    end
                end

                start_state: begin
                    tx    <= 1'b0;
                    state <= data_state;
                end

                data_state: begin
                    tx <= data[index];

                    if (index == 3'b111) begin
                        state <= stop_state;
                    end

                    else begin
                        index <= index + 3'b001;
                    end
                end

                stop_state: begin
                    tx    <= 1'b1;
                    state <= idle_state;
                end

                default: begin
                    tx    <= 1'b1;
                    state <= idle_state;
                end

            endcase

        end

    end

    // Busy is HIGH when transmitter is not idle
    assign busy = (state != idle_state);

endmodule
