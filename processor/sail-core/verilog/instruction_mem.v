


/*
 *	RISC-V instruction memory
 */


module instruction_memory (
    input  wire [13:0] addr,
    input  wire        wr_en,
    input  wire [31:0] data_in,
    output wire [31:0] data_out,
    input  wire        clk
);

    wire [15:0] inst_out_0, inst_out_1;
/*
    reg [13:0] addr_reg;
    reg [31:0] data_in_reg;

    always @(posedge clk) begin
        // Synchronize addr and data_in inputs with the clock, to avoid hazards
        addr_reg <= addr;
        data_in_reg <= data_in;
    end
*/
    SB_SPRAM256KA inst_SPRAM0 (
        .ADDRESS(addr),
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
        .ADDRESS(addr),
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


	/*
	 *	According to the "iCE40 SPRAM Usage Guide" (TN1314 Version 1.0), page 5:
	 *
	 *		"SB_SPRAM256KA RAM does not support initialization through device configuration."
	 *
	 *	The only way to have an initializable memory is to use the Block RAM.
	 *	This uses Yosys's support for nonzero initial values:
	 *
	 *		https://github.com/YosysHQ/yosys/commit/0793f1b196df536975a044a4ce53025c81d00c7f
	 *
	 *	Rather than using this simulation construct (`initial`),
	 *	the design should instead use a reset signal going to
	 *	modules in the design.
	 */
