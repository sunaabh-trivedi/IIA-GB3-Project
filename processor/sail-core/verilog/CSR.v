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



module csr_file (clk, write, wrAddr_CSR, wrVal_CSR, rdAddr_CSR, rdVal_CSR, wr_en, spram_wr_addr, start_pc);
	input clk;
	input write;
	input [11:0] wrAddr_CSR;
	input [31:0] wrVal_CSR;
	input [11:0] rdAddr_CSR;
	output reg[31:0] rdVal_CSR;
	output reg wr_en; //for instruction memory
	reg [31:0] csr_file [0:2**10-1];
	output reg [13:0]	spram_wr_addr; //for indexing csr_file to write to instruction memory
	output reg start_pc;
	reg [13:0] counter1;
	reg [13:0] counter2;

	parameter STATE_INIT = 2'b00;
	parameter STATE_CLEAR = 2'b01;
	parameter STATE_OPERATION = 2'b10; //was 10
	reg state;
	reg next_state;

	initial begin
		/*
		 *	read from "program.hex" and store the instructions in csr file
		 */
		$readmemh("verilog/program.hex",csr_file);
		state = STATE_INIT;
		counter1 = 0;
		counter2 = 0;
		start_pc = 1'b1; //means dont start pc yet
	end

    always @(posedge clk) begin
            state <= next_state;
    end

    always @(*) begin
        case (state)
            STATE_INIT: begin
                next_state = (counter1 < 11'b10000000000) ? STATE_INIT : STATE_CLEAR; //look into byte vs word addressing
            end //check if should be 1024 or 1023
			STATE_CLEAR: begin
				next_state = (counter2 < 11'b10000000000) ? STATE_CLEAR : STATE_OPERATION;
			end
            STATE_OPERATION: begin
                next_state = STATE_OPERATION;
            end
        endcase
    end

    always @(posedge clk) begin
		wr_en <= 1'b0;
        if (state == STATE_INIT) begin
			
            // Write the counter-th value in csr_file to rdVal_CSR
            rdVal_CSR <= csr_file[counter1[9:0]];
			spram_wr_addr <= (counter1 << 2);
			wr_en <= 1'b1; //write data to spram

            // Increment the counter
            if (counter1 < 11'b10000000000 ) begin //this may need to be 1023
                counter1 <= counter1 + 1;
			
			end 

		

		end else if (state == STATE_CLEAR)  begin

			csr_file[counter2[9:0]] <= 32'b0; 
            // Increment the counter
            if (counter2 < 11'b10000000000 ) begin //this may need to be 1023
                counter2 <= counter2 + 1;
			end

		

    	end else if (state == STATE_OPERATION) begin
			start_pc <= 1'b0;
            if (write) begin
                csr_file[wrAddr_CSR] <= wrVal_CSR;
            end
            rdVal_CSR <= csr_file[rdAddr_CSR];
        end
    end

endmodule
