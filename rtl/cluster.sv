module cluster #(
  parameter DW   = 16,
  parameter AW   = 32,
  parameter NPE  = 8,
  parameter P    = 9
)(
  input  logic                clk,
  input  logic                rst_n,
  input  logic                start,
  input  logic [DW-1:0]       noc_in  [0:3],
  input  logic                noc_in_valid [0:3],
  output logic [DW-1:0]       noc_out [0:3],
  output logic                noc_out_valid [0:3],
  input  logic [7:0]          cfg_switch [0:1]
);
  logic [DW-1:0]              bus_data;
  logic                       bus_valid;
  logic [NPE-1:0]             bus_req;
  logic [NPE-1:0]             bus_grant;
  logic [$clog2(NPE)-1:0]     bus_sel;

  logic [DW-1:0]              pe_out   [0:NPE-1];
  logic                       pe_out_valid [0:NPE-1];
  logic [DW-1:0]              pe_in    [0:NPE-1];
  logic                       pe_in_valid [0:NPE-1];
  logic [AW-1:0]              pe_result [0:NPE-1];
  logic                       pe_done [0:NPE-1];

  bus_arbiter #(.N(NPE)) u_arb (
    .clk   (clk),
    .rst_n (rst_n),
    .req   (bus_req),
    .grant (bus_grant),
    .sel   (bus_sel)
  );

  always_comb begin
    bus_data  = '0;
    bus_valid = 1'b0;
    for (int i = 0; i < NPE; i++) begin
      if (bus_grant[i]) begin
        bus_data  = pe_out[i];
        bus_valid = pe_out_valid[i];
      end
    end
  end

  genvar g;
  generate
    for (g = 0; g < NPE; g++) begin : pe_inst
      assign pe_in[g]       = bus_data;
      assign pe_in_valid[g] = bus_valid;

      conv_pe #(.DW(DW), .AW(AW), .P(P)) u_pe (
        .clk   (clk),
        .rst_n (rst_n),
        .start (start),
        .pix   ('0),
        .wgt   ('0),
        .y     (pe_result[g]),
        .done  (pe_done[g])
      );

      assign pe_out[g]       = pe_result[g][DW-1:0];
      assign pe_out_valid[g] = pe_done[g];
      assign bus_req[g]      = pe_done[g];
    end
  endgenerate

  always_comb begin
    for (int k = 0; k < 4; k++) begin
      noc_out[k]       = noc_in[k];
      noc_out_valid[k] = noc_in_valid[k];
    end
  end
endmodule
