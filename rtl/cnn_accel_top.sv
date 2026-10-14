module cnn_accel_top #(
  parameter DW        = 16,
  parameter AW        = 32,
  parameter NPE       = 8,
  parameter P         = 9,
  parameter NCLUSTERS = 4,
  parameter CLUSTER_R = 2,
  parameter CLUSTER_C = 2
)(
  input  logic         clk,
  input  logic         rst_n,
  input  logic         start,
  input  logic [7:0]   cfg_switch [0:NCLUSTERS*2-1],
  output logic [AW-1:0] result   [0:NCLUSTERS*NPE-1]
);
  logic [DW-1:0]  noc_data  [0:NCLUSTERS-1][0:3];
  logic           noc_valid [0:NCLUSTERS-1][0:3];

  for (genvar cr = 0; cr < CLUSTER_R; cr++) begin : row_gen
    for (genvar cc = 0; cc < CLUSTER_C; cc++) begin : col_gen
      localparam int IDX = cr * CLUSTER_C + cc;

      cluster #(
        .DW(DW), .AW(AW), .NPE(NPE), .P(P)
      ) u_cluster (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (start),
        .noc_in        (noc_data[IDX]),
        .noc_in_valid  (noc_valid[IDX]),
        .noc_out       (noc_data[IDX]),
        .noc_out_valid (noc_valid[IDX]),
        .cfg_switch    ({cfg_switch[2*IDX], cfg_switch[2*IDX+1]})
      );

      for (genvar p = 0; p < NPE; p++) begin : res_gen
        assign result[IDX*NPE + p] = u_cluster.pe_result[p];
      end
    end
  end
endmodule
