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
 *	top.v
 *
 *	Top level entity, linking cpu with data and instruction memory.
 */

module top (led);
	output [7:0]	led;

	wire		clk_proc;
	wire		data_clk_stall;
	
	wire		clk;
	reg		ENCLKHF		= 1'b1;	// Plock enable
	reg		CLKHF_POWERUP	= 1'b1;	// Power up the HFOSC circuit


	/*
	 *	Use the iCE40's hard primitive for the clock source.
	 */
	SB_HFOSC #(.CLKHF_DIV("0b10")) OSCInst0 (
		.CLKHFEN(ENCLKHF),
		.CLKHFPU(CLKHF_POWERUP),
		.CLKHF(clk)
	);

	/*
	 *	Memory interface
	 */
	wire[13:0]	inst_in; //instruction address
	wire[31:0]	inst_out; //instruction contents
	wire[31:0]	data_out;
	wire[31:0]	data_addr;
	wire[31:0]	data_WrData;
	wire		data_memwrite;
	wire		data_memread;
	wire[3:0]	data_sign_mask;
	
	wire 		wr_en;
	wire[31:0] 	inst_data;
	wire[13:0]  csr_instaddr;
 	wire[13:0]  cpu_instaddr;

	cpu processor(
		.clk(clk_proc),
		.inst_mem_in(inst_in),
		.inst_mem_out(inst_out),
		.data_mem_out(data_out),
		.data_mem_addr(data_addr),
		.data_mem_WrData(data_WrData),
		.data_mem_memwrite(data_memwrite),
		.data_mem_memread(data_memread),
		.data_mem_sign_mask(data_sign_mask),
		.inst_data(inst_data),
		.wr_en(wr_en)
	);

	instruction_memory inst_mem (
		.addr(inst_in), //[13:0]
		.wr_en(wr_en), // read mode, to read instructions
		.data_in(inst_data), // [31:0]
		.data_out(inst_out), // [31:0]
		.clk(~clk_proc) //on negedge
	);

		


	data_mem data_mem_inst(
			.clk(clk),
			.addr(data_addr),
			.write_data(data_WrData),
			.memwrite(data_memwrite), 
			.memread(data_memread), 
			.read_data(data_out),
			.sign_mask(data_sign_mask),
			.led(led),
			.clk_stall(data_clk_stall)
		);



	assign clk_proc = (data_clk_stall) ? 1'b1 : clk;


endmodule
