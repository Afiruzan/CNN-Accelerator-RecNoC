`timescale 1ns/1ps

module tb_cnn_accel;
  parameter DW = 16, AW = 32;
  parameter CLK_PERIOD = 2.0;

  logic         clk, rst_n, start;
  logic [7:0]   cfg_switch [0:7];
  logic [AW-1:0] result [0:31];

  cnn_accel_top #(
    .DW(DW), .AW(AW), .NPE(8), .P(9), .NCLUSTERS(4)
  ) dut (
    .clk(clk), .rst_n(rst_n), .start(start),
    .cfg_switch(cfg_switch), .result(result)
  );

  initial clk = 0;
  always #(CLK_PERIOD/2) clk = ~clk;

  initial begin
    rst_n = 0;
    start = 0;
    for (int i = 0; i < 8; i++) cfg_switch[i] = 8'hE4;

    #100 rst_n = 1;
    #20;

    start = 1;
    #(CLK_PERIOD);
    start = 0;

    #(CLK_PERIOD * 50);

    $display("=== CNN Accelerator Test Results ===");
    for (int i = 0; i < 32; i++) begin
      if (result[i] !== 'x) begin
        $display("PE[%0d] result = %0d", i, result[i]);
      end
    end
    $display("=== Test Complete ===");
    $finish;
  end
endmodule
