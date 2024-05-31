

module instruction_memory (
    input  wire [13:0] addr,
    input  wire        wr_en,
    input  wire [31:0] data_in,
    output wire [31:0] data_out,
    input  wire      clk
);

    wire [15:0] inst_out_0, inst_out_1;

    SB_SPRAM256KA inst_SPRAM0 (
        .ADDRESS(addr>>2),
        .DATAIN(data_in[15:0]),
        .MASKWREN(4'b1111),
        .WREN(wr_en),
        .CHIPSELECT(1'b1),
        .CLOCK(clk),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(inst_out_0)
    );

    SB_SPRAM256KA inst_SPRAM1 (
        .ADDRESS(addr>>2),
        .DATAIN(data_in[31:16]),
        .MASKWREN(4'b1111),
        .WREN(wr_en),
        .CHIPSELECT(1'b1),
        .CLOCK(clk),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(inst_out_1)
    );

    assign data_out = {inst_out_1, inst_out_0}; // Using width cascading

endmodule
