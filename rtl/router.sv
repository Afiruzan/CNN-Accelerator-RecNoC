module router #(
  parameter DW = 16,
  parameter NPE = 8
)(
  input  logic          clk,
  input  logic          rst_n,
  input  logic [DW-1:0] local_in_data,
  input  logic          local_in_valid,
  output logic [DW-1:0] local_out_data,
  output logic          local_out_valid,
  input  logic [DW-1:0] bus_in_data,
  input  logic          bus_in_valid,
  output logic [DW-1:0] bus_out_data,
  output logic          bus_out_valid,
  output logic          bus_req,
  input  logic          bus_grant,
  input  logic [DW-1:0] noc_in_data [0:3],
  input  logic          noc_in_valid [0:3],
  output logic [DW-1:0] noc_out_data [0:3],
  output logic          noc_out_valid [0:3],
  input  logic [DW-1:0] route_cfg
);
  logic [1:0] dest_sel;

  always_comb begin
    local_out_data = '0; local_out_valid = 1'b0;
    bus_out_data   = '0; bus_out_valid   = 1'b0;
    bus_req        = 1'b0;
    for (int i = 0; i < 4; i++) begin
      noc_out_data[i]  = '0;
      noc_out_valid[i] = 1'b0;
    end

    if (local_in_valid) begin
      if (route_cfg[1]) begin
        bus_out_data  = local_in_data;
        bus_out_valid = 1'b1;
        bus_req       = 1'b1;
      end else if (route_cfg[2]) begin
        dest_sel = route_cfg[3:2];
        noc_out_data[dest_sel]  = local_in_data;
        noc_out_valid[dest_sel] = 1'b1;
      end else begin
        local_out_data  = local_in_data;
        local_out_valid = 1'b1;
      end
    end

    if (bus_in_valid) begin
      if (route_cfg[0]) begin
        local_out_data  = bus_in_data;
        local_out_valid = 1'b1;
      end
    end

    for (int j = 0; j < 4; j++) begin
      if (noc_in_valid[j]) begin
        if (route_cfg[0]) begin
          local_out_data  = noc_in_data[j];
          local_out_valid = 1'b1;
        end else if (route_cfg[1]) begin
          bus_out_data  = noc_in_data[j];
          bus_out_valid = 1'b1;
          bus_req       = 1'b1;
        end
      end
    end
  end
endmodule
