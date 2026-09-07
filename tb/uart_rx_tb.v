`timescale 1ns/1ps

module receiver_tb;

    reg clk;
    reg rx;
    reg enb;
    reg rst;

    wire [7:0] data_out;
    wire done;

    receiver uut (
        .clk(clk),
        .rx(rx),
        .enb(enb),
        .rst(rst),
        .data_out(data_out),
        .done(done)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rx  = 1;
        enb = 0;
        rst = 1;

        // Reset
        #20;
        rst = 0;

        // START bit
        #10;
        rx  = 0;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 0
        #10;
        rx  = 1;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 1
        #10;
        rx  = 0;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 2
        #10;
        rx  = 1;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 3
        #10;
        rx  = 0;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 4
        #10;
        rx  = 0;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 5
        #10;
        rx  = 1;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 6
        #10;
        rx  = 0;
        enb = 1;
        #10;
        enb = 0;

        // DATA bit 7
        #10;
        rx  = 1;
        enb = 1;
        #10;
        enb = 0;

        // STOP bit
        #10;
        rx  = 1;
        enb = 1;
        #10;
        enb = 0;

        #20;

        $display("RX TEST");
        $display("Received Data = %h", data_out);

        if (data_out == 8'hA5)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;

    end

endmodule