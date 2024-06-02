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
 *	Description:
 *
 *		This module implements the control and status registers (CSRs).
 */



module csr_file (clk, rdAddr_CSR, rdVal_CSR);
	input clk;
	// input write;
	// input [11:0] wrAddr_CSR;
	// input [31:0] wrVal_CSR;
	input [11:0] rdAddr_CSR;
	output reg[31:0] rdVal_CSR;

	reg [31:0] csr_file [0:2**10-1];

	// Load the program into the CSR. The CSR is not used in the benchmarks, so can be repurposed this way to save logic cells.
	initial begin
	    rdVal_CSR = 32'b0;
		$readmemh("verilog/program.hex", csr_file);
	end

	always @(posedge clk) begin
		rdVal_CSR <= csr_file[rdAddr_CSR[9:0] >> 2]; // Divide by 4 as we want PC + 1 not PC + 4
	end



endmodule
