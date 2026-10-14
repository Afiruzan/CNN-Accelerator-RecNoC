module mac_unit #(
  parameter DW = 16,
  parameter AW = 32
)(
  input  logic                clk,
  input  logic                rst_n,
  input  logic                clr,
  input  logic                en,
  input  logic signed [DW-1:0] a,
  input  logic signed [DW-1:0] b,
  output logic signed [AW-1:0] acc
);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)      acc <= '0;
    else if (clr)    acc <= '0;
    else if (en)     acc <= acc + (a * b);
  end
endmodule
