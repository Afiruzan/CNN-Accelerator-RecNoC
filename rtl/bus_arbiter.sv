module bus_arbiter #(
  parameter N = 8
)(
  input  logic          clk,
  input  logic          rst_n,
  input  logic [N-1:0]  req,
  output logic [N-1:0]  grant,
  output logic [$clog2(N)-1:0] sel
);
  logic [$clog2(N)-1:0] ptr;
  logic found;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ptr <= '0;
    end else begin
      found = 0;
      for (int i = 0; i < N; i++) begin
        if (!found && req[(ptr + i) % N]) begin
          ptr <= (ptr + i + 1) % N;
          found = 1;
        end
      end
    end
  end

  always_comb begin
    grant = '0;
    sel = '0;
    for (int i = 0; i < N; i++) begin
      if (req[(ptr + i) % N]) begin
        grant[(ptr + i) % N] = 1'b1;
        sel = (ptr + i) % N;
        break;
      end
    end
  end
endmodule
