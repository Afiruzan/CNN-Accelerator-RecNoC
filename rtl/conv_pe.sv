module conv_pe #(
  parameter DW = 16,
  parameter AW = 32,
  parameter P  = 9
)(
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic                    start,
  input  logic signed [DW-1:0]    pix [0:P-1],
  input  logic signed [DW-1:0]    wgt [0:P-1],
  output logic signed [AW-1:0]    y,
  output logic                    done
);
  logic signed [AW-1:0] acc [0:P-1];
  logic signed [AW-1:0] sum;
  logic                 busy;

  genvar i;
  generate
    for (i = 0; i < P; i++) begin : mac_array
      mac_unit #(.DW(DW), .AW(AW)) u_mac (
        .clk   (clk),
        .rst_n (rst_n),
        .clr   (start),
        .en    (busy),
        .a     (pix[i]),
        .b     (wgt[i]),
        .acc   (acc[i])
      );
    end
  endgenerate

  always_comb begin
    sum = '0;
    for (int j = 0; j < P; j++)
      sum = sum + acc[j];
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      busy <= 1'b0;
      done <= 1'b0;
      y    <= '0;
    end else if (start) begin
      busy <= 1'b1;
      done <= 1'b0;
    end else if (busy) begin
      y    <= (sum > 0) ? sum : '0;
      done <= 1'b1;
      busy <= 1'b0;
    end
  end
endmodule
