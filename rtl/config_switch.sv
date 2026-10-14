module config_switch #(
  parameter DW = 32
)(
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic [7:0]           cfg_reg,
  input  logic [DW-1:0]        in_data [0:3],
  input  logic [3:0]           in_valid,
  output logic [DW-1:0]        out_data [0:3],
  output logic [3:0]           out_valid
);
  always_comb begin
    for (int i = 0; i < 4; i++) begin
      case (cfg_reg[2*i+1 : 2*i])
        2'd0: begin out_data[i] = in_data[0]; out_valid[i] = in_valid[0]; end
        2'd1: begin out_data[i] = in_data[1]; out_valid[i] = in_valid[1]; end
        2'd2: begin out_data[i] = in_data[2]; out_valid[i] = in_valid[2]; end
        2'd3: begin out_data[i] = in_data[3]; out_valid[i] = in_valid[3]; end
      endcase
    end
  end
endmodule
