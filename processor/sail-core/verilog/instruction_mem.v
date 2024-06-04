/*
	Authored 2018-2019, Ryan Voo.

	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:

	*	Redistributions of source code must retain the above
		copyright notice, this list of conditions and the following
		disclaimer.

	*	Redistributions in binary form must reproduce the above
		copyright notice, this list of conditions and the following
		disclaimer in the documentation and/or other materials
		provided with the distribution.

	*	Neither the name of the author nor the names of its
		contributors may be used to endorse or promote products
		derived from this software without specific prior written
		permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/



/*
 *	RISC-V instruction memory
 */



module instruction_memory(addr, out, clk);
	input [31:0]		addr;
	output wire[31:0]		out;
    input clk;
	/*
	 *	Size the instruction memory.
	 *
	 *	(Bad practice: The constant should be a `define).
	 */
	reg [31:0]		instruction_memory[0:767];
	reg [31:0]		instruction_memory_extended[0:6];
	reg [31:0]		out_1;
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
	initial begin
		/*
		 *	read from "program.hex" and store the instructions in instruction memory
		 */
        

		$readmemh("verilog/competition-benchmark-2024-program_shorter.hex",instruction_memory);

		instruction_memory_extended[0] <=32'h04C78793;
		instruction_memory_extended[1] <=32'h01055513;
		instruction_memory_extended[2] <=32'h00F50533;
		instruction_memory_extended[3] <=32'h00054503;
		instruction_memory_extended[4] <=32'h01000713;
		instruction_memory_extended[5] <=32'h40A70533;
		instruction_memory_extended[6] <=32'h00008067;

		
	end

    always @(posedge clk) begin
		if ((addr>>2)<768) begin
	        out_1 <= instruction_memory[addr >> 2];
        end
    end

	assign out = ((addr>>2)<768)? out_1 : instruction_memory_extended[(addr>>2)-768];

/*
	SB_RAM1024x4NW RAM0(
		.RDATA(data_0),
		.RADDR(addr >> 2),
		.RCLK(~clk),
		.RCLKE(1'b1),
		.RE(1'b1),
		.WADDR(4'b0),
		.WCLK(clk),
		.WCLKE(1'b0),
		.WDATA(4'b0),
		.WE(1'b0)
	);
	SB_RAM1024x4NW RAM1(
		.RDATA(data_1),
		.RADDR(addr >> 2),
		.RCLK(~clk),
		.RCLKE(1'b1),
		.RE(1'b1),
		.WADDR(4'b0),
		.WCLK(clk),
		.WCLKE(1'b0),
		.WDATA(4'b0),
		.WE(1'b0)
	);
	SB_RAM1024x4NW RAM2(
		.RDATA(data_2),
		.RADDR(addr >> 2),
		.RCLK(~clk),
		.RCLKE(1'b1),
		.RE(1'b1),
		.WADDR(4'b0),
		.WCLK(clk),
		.WCLKE(1'b0),
		.WDATA(4'b0),
		.WE(1'b0)
	);
	SB_RAM1024x4NW RAM3(
		.RDATA(data_3),
		.RADDR(addr >> 2),
		.RCLK(~clk),
		.RCLKE(1'b1),
		.RE(1'b1),
		.WADDR(4'b0),
		.WCLK(clk),
		.WCLKE(1'b0),
		.WDATA(4'b0),
		.WE(1'b0)
	);

	assign out = {data_3, data_2, data_1, data_0}

	*/
endmodule
