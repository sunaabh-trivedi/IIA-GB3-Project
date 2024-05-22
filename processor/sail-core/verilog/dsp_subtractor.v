module DSPSubtractor(A, B, out, carry_out);

	input [31:0] A;
    input [31:0] B;
    output [31:0] out;
	output carry_out;

        SB_MAC16 i_sbmac16
        (
            .A(B[31 : 16]),
            .B(B[15 : 0]),
            .C(A[31 : 16]),
            .D(A[15 : 0]),
            .O(out),
            
 
            .AHOLD(1'b0),
            .BHOLD(1'b0),
            .CHOLD(1'b0),
            .DHOLD(1'b0),
            .OHOLDTOP(1'b0),
            .OHOLDBOT(1'b0),
            .OLOADTOP(1'b0),
            .OLOADBOT(1'b0),

            .CE(1'b1),
            .IRSTTOP(1'b0),
            .IRSTBOT(1'b0),
            .ORSTTOP(1'b0),
            .ORSTBOT(1'b0),

            .ADDSUBTOP(1'b1),
            .ADDSUBBOT(1'b1),
            .CO(carry_out),
            .CI(1'b0),
            .ACCUMCI(1'b0),
            .ACCUMCO(),
            .SIGNEXTIN(1'b0),
            .SIGNEXTOUT()
        );

    defparam i_sbmac16.B_SIGNED = 1'b0 ;
    defparam i_sbmac16.A_SIGNED = 1'b0 ;
    defparam i_sbmac16.MODE_8x8 = 1'b1 ;

    
    defparam i_sbmac16.TOPADDSUB_CARRYSELECT = 2'b10 ;
    defparam i_sbmac16.TOPADDSUB_UPPERINPUT = 1'b1 ;
    defparam i_sbmac16.TOPADDSUB_LOWERINPUT = 2'b00 ;
    defparam i_sbmac16.TOPOUTPUT_SELECT = 2'b00 ;

    defparam i_sbmac16.BOTADDSUB_CARRYSELECT = 2'b00 ;
    defparam i_sbmac16.BOTADDSUB_UPPERINPUT = 1'b1 ;
    defparam i_sbmac16.BOTADDSUB_LOWERINPUT = 2'b00 ;
    defparam i_sbmac16.BOTOUTPUT_SELECT = 2'b00 ; 

    defparam i_sbmac16.D_REG = 1'b0;
    defparam i_sbmac16.B_REG = 1'b0;
    defparam i_sbmac16.A_REG = 1'b0;
    defparam i_sbmac16.C_REG = 1'b0;
 
    defparam i_sbmac16.PIPELINE_16x16_MULT_REG2 = 1'b0 ;
    defparam i_sbmac16.PIPELINE_16x16_MULT_REG1 = 1'b0; 
    defparam i_sbmac16.BOT_8x8_MULT_REG = 1'b0;
    defparam i_sbmac16.TOP_8x8_MULT_REG = 1'b0;

     
endmodule