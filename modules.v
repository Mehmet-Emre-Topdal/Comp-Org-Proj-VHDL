`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2023 07:01:44 PM
// Design Name: 
// Module Name: CORG
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//PART 1
module Register #(parameter n = 8)(in, enable, select, clock, out);
    
    input wire[n-1:0] in;
    input wire[0:0] enable;
    input wire[1:0] select;
    input wire clock;
    reg[n-1:0] present;//stored value
    output wire[n-1:0] out;
       
    assign out = present;
          
       always @ (posedge clock && enable) begin
           
           if(select == 2'b00) begin
              present = 0; 
              
           end
             
           else if(select == 2'b01) begin 
               present = in;
              
           end
           
           else if(select == 2'b10) begin
           present = present - 1'b1;
              
           end
           
           else if(select == 2'b11) begin
               present = present + 1'b1;
           end
           
       end
    
endmodule


module part2a_IR(LH, enable, select, in, out, clock);
    input wire[7:0] in;
    input wire[0:0] enable;
    input wire[1:0] select;
    input wire clock;
    input wire LH;
    output wire[15:0] out;
    //reg[15:0] present;  
    //assign out = present;
    
    reg[15:0] IR_in;
   
    Register #(16)IR(IR_in, enable, select, clock, out); 
  
          always @ (*) begin

               
               if(select == 2'b01) begin 
                    if(LH == 0)begin 
                        IR_in = {out[15:8],in};                  
                    end
                                  
                                  
                    if(LH == 1)begin 
                        IR_in = {in,out[7:0]};              
                    end
                end
                              

              
               
           end  
    
endmodule

module part2b_RF(in, O1Sel, O2Sel, fun_sel, reg_sel,t_sel, clock, O1, O2);
    input wire[7:0] in;
    input wire[2:0] O1Sel;
    input wire[2:0] O2Sel;
    input wire[1:0] fun_sel;
    input wire[3:0] reg_sel;
    input wire[3:0] t_sel;
    input wire clock;
    output reg[7:0] O1;
    output reg[7:0] O2;
    
    //definitions about R Registers 
    wire[7:0] R1_out;
    wire[7:0] R2_out;
    wire[7:0] R3_out;
    wire[7:0] R4_out;
    
    Register #(8)R1(in, reg_sel[3:3], fun_sel, clock, R1_out);
    Register #(8)R2(in, reg_sel[2:2], fun_sel, clock, R2_out);
    Register #(8)R3(in, reg_sel[1:1], fun_sel, clock, R3_out);
    Register #(8)R4(in, reg_sel[0:0], fun_sel, clock, R4_out);

    //definitions about T Registers 
    wire[7:0] T1_out;
    wire[7:0] T2_out;
    wire[7:0] T3_out;
    wire[7:0] T4_out;
    
    Register #(8)T1(in, t_sel[3:3], fun_sel, clock, T1_out);
    Register #(8)T2(in, t_sel[2:2], fun_sel, clock, T2_out);
    Register #(8)T3(in, t_sel[1:1], fun_sel, clock, T3_out);
    Register #(8)T4(in, t_sel[0:0], fun_sel, clock, T4_out);
    
    always@(*) begin
    case(O1Sel)
        3'b000 : O1 = T1_out;
        3'b001 : O1 = T2_out;
        3'b010 : O1 = T3_out;
        3'b011 : O1 = T4_out;

        3'b100 : O1 = R1_out;
        3'b101 : O1 = R2_out;
        3'b110 : O1 = R3_out;
        3'b111 : O1 = R4_out;
    endcase 
    
    case(O2Sel)
        3'b000 : O2 = T1_out;
        3'b001 : O2 = T2_out;
        3'b010 : O2 = T3_out;
        3'b011 : O2 = T4_out;

        3'b100 : O2 = R1_out;
        3'b101 : O2 = R2_out;
        3'b110 : O2 = R3_out;
        3'b111 : O2 = R4_out;
    endcase
    end
    
endmodule

module part2c_ARF(in, O1Sel, O2Sel, fun_sel, reg_sel, clock, outA, outB);
    input wire[7:0] in;
    input wire[1:0] O1Sel;
    input wire[1:0] O2Sel;
    input wire[1:0] fun_sel;
    input wire[3:0] reg_sel;
    input wire clock;
    output reg[7:0] outA;
    output reg[7:0] outB;
    
    wire[7:0] PC_out;
    wire[7:0] AR_out;
    wire[7:0] SP_out;
    wire[7:0] PC_prev_out;
    
    Register #(8)PC(in, reg_sel[3:3], fun_sel, clock, PC_out);
    Register #(8)AR(in, reg_sel[2:2], fun_sel, clock, AR_out);
    Register #(8)SP(in, reg_sel[1:1], fun_sel, clock, SP_out);
    Register #(8)PC_Prev(in, reg_sel[0:0], fun_sel, clock, PC_prev_out);
    
    always@(*) begin
    case(O1Sel)
        2'b00 : outA = AR_out;
        2'b01 : outA = SP_out;
        2'b10 : outA = PC_prev_out;
        2'b11 : outA = PC_out;
    endcase 
    
    case(O2Sel)
        2'b00 : outB = AR_out;
        2'b01 : outB = SP_out;
        2'b10 : outB = PC_prev_out;
        2'b11 : outB = PC_out;
    endcase
    end
    
endmodule

module and_gate(
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] C
    );
    
    assign C = A&B;
    
endmodule

module or_gate_1bit(
    input wire  A,
    input wire  B,
    output wire C
    );
    
    assign C = A|B;
    
endmodule

module or_gate(
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] C
    );
    
    assign C = A|B;
    
endmodule

module not_gate(
    input wire [7:0] A,
    output wire [7:0] C
    );
    
    assign C = ~A;
    
endmodule

module xor_gate( 
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] C
    );
    
    assign C = A&~B | ~A&B;
    
endmodule

module xor_gate_1bit(
    input wire A,
    input wire B,
    output wire C
    );
    
    assign C = A&~B | ~A&B;
    
endmodule


module compare(input [7:0] num1, input [7:0] num2, output reg [7:0] result);
    
    always @(num1, num2)
    begin
        if(num1 > num2)
            result = num1;
        else
            result = 8'b00000000;
    end
    
endmodule

module nand_gate(
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] C
    );
    
    assign C = ~(A&B);
    
endmodule

module mux_2_1(i0,i1,sel,out);

    input wire[7:0] i0;
    input wire[7:0] i1;
    
    input wire sel;
    
    output reg[7:0] out;
    
    always@(i0 or i1 or sel) begin
    case (sel)
             1'b0 : out <= i0;  
             1'b1 : out <= i1;  
              
    endcase
    end
    
endmodule

module mux_4_1(i0,i1,i2,i3,sel,out);

    input wire[7:0] i0;
    input wire[7:0] i1;
    input wire[7:0] i2;
    input wire[7:0] i3;
    
    input wire[1:0] sel;
    
    output reg[7:0] out;
    
    always@(i0 or i1 or i2 or i3 or sel) begin
    case (sel)
             2'b00 : out <= i0;  
             2'b01 : out <= i1;  
             2'b10 : out <= i2;  
             2'b11 : out <= i3; 
    endcase
   end
    
endmodule

module mux_16_1(i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,sel,out);

    input wire[7:0] i0;
    input wire[7:0] i1;
    input wire[7:0] i2;
    input wire[7:0] i3;
    input wire[7:0] i4; 
    input wire[7:0] i5;
    input wire[7:0] i6;
    input wire[7:0] i7;
    input wire[7:0] i8;
    input wire[7:0] i9;
    input wire[7:0] i10;
    input wire[7:0] i11;
    input wire[7:0] i12;
    input wire[7:0] i13;
    input wire[7:0] i14;
    input wire[7:0] i15;
    
    input wire[3:0] sel;
    
    output reg[7:0] out;
    
    always@(i0 or i1 or i2 or i3 or i4 or i5 or i6 or i7 or i8 or i9 or i10 or i11 or i12 or i13 or i14 or i15 or sel) begin
    case (sel)
             4'b0000 : out <= i0;  
             4'b0001 : out <= i1;  
             4'b0010 : out <= i2;  
             4'b0011 : out <= i3;
             4'b0100 : out <= i4;  
             4'b0101 : out <= i5;  
             4'b0110 : out <= i6;  
             4'b0111 : out <= i7;
             4'b1000 : out <= i8;  
             4'b1001 : out <= i9;  
             4'b1010 : out <= i10;  
             4'b1011 : out <= i11;
             4'b1100 : out <= i12;  
             4'b1101 : out <= i13;  
             4'b1110 : out <= i14;  
             4'b1111 : out <= i15;    
    endcase
    end
    

endmodule

module and_gate_1bit(
    input wire  A,
    input wire  B,
    output wire C
    );
    
    assign C = A&B;
    
endmodule

module half_adder1(a,b,s,c);

       input wire a;
       input wire b;
       
       output wire s;
       output wire c;
       
       xor_gate_1bit XOR1(.A(a),.B(b),.C(s));
       and_gate_1bit AND1(.A(a),.B(b),.C(c));
       
endmodule

module full_adder1(a,b,cin,s,cout);

       input wire a;
       input wire b;
       input wire cin;
       
       output wire s;
       output wire cout;
       
       wire s1;
       wire cout1;
       wire ab;
       
       
       half_adder1 HALF1(.a(a),.b(b),.s(s1),.c(ab));
       half_adder1 HALF2(.a(cin),.b(s1),.s(s),.c(cout1));
       or_gate_1bit OR1(.A(cout1),.B(ab),.C(cout));
       
endmodule

module full_adder8(a,b,cin,s,cout);

       input wire [7:0] a;
       input wire [7:0] b;
       input wire cin;
       
       output wire [7:0] s;
       output wire cout;
       
       wire c1;
       wire c2;
       wire c3;
       wire c4;
       wire c5;
       wire c6;
       wire c7;
       
       
       full_adder1 FULL1(.a(a[0]),.b(b[0]),.cin(cin),.s(s[0]),.cout(c1));
       full_adder1 FULL2(.a(a[1]),.b(b[1]),.cin(c1),.s(s[1]),.cout(c2));
       full_adder1 FULL3(.a(a[2]),.b(b[2]),.cin(c2),.s(s[2]),.cout(c3));
       full_adder1 FULL4(.a(a[3]),.b(b[3]),.cin(c3),.s(s[3]),.cout(c4));
       full_adder1 FULL5(.a(a[4]),.b(b[4]),.cin(c4),.s(s[4]),.cout(c5));
       full_adder1 FULL6(.a(a[5]),.b(b[5]),.cin(c5),.s(s[5]),.cout(c6));
       full_adder1 FULL7(.a(a[6]),.b(b[6]),.cin(c6),.s(s[6]),.cout(c7));
       full_adder1 FULL8(.a(a[7]),.b(b[7]),.cin(c7),.s(s[7]),.cout(cout));
                                                 
       
endmodule

module ALU(A,B,OutALU,FunSel,ALUOutFlag,clk);

    input wire [7:0] A;
    input wire [7:0] B;
    input wire [3:0] FunSel;
    input wire clk;
    
    output wire [7:0] OutALU;
    output reg [3:0] ALUOutFlag;
    
    initial 
    ALUOutFlag = 4'b0000;
    
    
    //Negation
    wire [7:0] notA;
    wire [7:0] notB;
    
    not_gate nota(.A(A),.C(notA));
    not_gate notb(.A(B),.C(notB));
    
    //Logic Operations
    
    wire [7:0] AandB;
    wire [7:0] AorB;
    wire [7:0] AnandB;
    wire [7:0] AxorB;
    
    and_gate aandb(.A(A),.B(B),.C(AandB));
    or_gate aorb(.A(A),.B(B),.C(AorB));
    nand_gate anandb(.A(A),.B(B),.C(AnandB));
    xor_gate axorb(.A(A),.B(B),.C(AxorB));
    
    //Adder-Subtractor-Compare
  
    wire [7:0] AplusB;
    wire AplusBcarry;//overflow control
    
    full_adder8 aplusb(.a(A),.b(B),.cin(ALUOutFlag[2]),.s(AplusB),.cout(AplusBcarry));
    
    wire [7:0] AminusB;
    wire AminusBcarry;
    wire [7:0] bcomplement;
    
    full_adder8 bComplement(.a(8'b00000001),.b(notB),.cin(1'b0),.s(bcomplement),.cout(AminusBcarry));
    full_adder8 aminusb(.a(A),.b(bcomplement),.cin(ALUOutFlag[2]),.s(AminusB),.cout(AminusBcarry));
    
    wire [7:0] AcompareB;
    
    compare acompb(.num1(A),.num2(B),.result(AcompareB));
    
    //Shifting
    
    wire [7:0] csr;
    assign csr[0] = A[1], csr[1] = A[2], csr[2] = A[3], csr[3] = A[4],
    csr[4] = A[5], csr[5] = A[6], csr[6] = A[7], csr[7] = ALUOutFlag[2];
    
    wire [7:0] lsr;
    assign lsr[0] = A[1], lsr[1] = A[2], lsr[2] = A[3], lsr[3] = A[4],
    lsr[4] = A[5], lsr[5] = A[6], lsr[6] = A[7], lsr[7] = 0;
    
    wire [7:0] lsl;
    assign lsl[0] = 0, lsl[1] = A[0], lsl[2] = A[1], lsl[3] = A[2],
    lsl[4] = A[3], lsl[5] = A[4], lsl[6] = A[5], lsl[7] = A[6];

    wire [7:0] asl;
    assign asl[7] = A[6], asl[6] = A[5], asl[5] = A[4], asl[4] = A[3],
    asl[3] = A[2], asl[2] = A[1], asl[1] = A[0], asl[0] = 0;
    
    wire [7:0] asr;
    assign asr[7]= A[7], asr[6]= A[7], asr[5]= A[6], asr[4]= A[5],
    asr[3]= A[4], asr[2]= A[3], asr[1]= A[2], asr[0]= A[1];

    mux_16_1 ALUMUX(.i0(A),.i1(B),.i2(notA),.i3(notB),.i4(AplusB),.i5(AminusB),.i6(AcompareB),.i7(AandB),.i8(AorB),.i9(AnandB),.i10(AxorB),.i11(lsl),.i12(lsr),.i13(asl),.i14(asr),.i15(csr),.sel(FunSel),.out(OutALU));
    
    
    
    always@ (*)
        begin
            case(FunSel)
                4'b0000:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b0001:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b0010:
                    if (!OutALU) // OutALU == 8'b10000000???
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b0011:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b0100:
                    if(AplusBcarry)
                    begin
                        if((A[7] && B[7] && !OutALU[7]) || (!A[7] && !B[7] && OutALU[7]))//overflow
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=1;
                        end
                        else
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=0;
                        end
                        ALUOutFlag[2]<=1;
                    end
                    else 
                    begin
                        if((A[7] && B[7] && !OutALU[7]) || (!A[7] && !B[7] && OutALU[7]))//overflow
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=1;
                        end
                        else
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=0;
                        end
                        ALUOutFlag[2]<=0;
                    end
                4'b0101:
                    if(AminusBcarry)
                    begin
                        if((A[7] && bcomplement[7] && !OutALU[7]) || (!A[7] && !bcomplement[7] && OutALU[7]))//overflow
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=1;
                        end
                        else
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=0;
                        end
                        ALUOutFlag[2]<=1;
                    end
                    else 
                    begin
                        if((A[7] && bcomplement[7] && !OutALU[7]) || (!A[7] && !bcomplement[7] && OutALU[7]))//overflow
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=1;
                        end
                        else
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=0;
                        end
                        ALUOutFlag[2]<=0;
                    end
                4'b0110:
                    if(AminusBcarry)
                    begin
                        if((A[7] && bcomplement[7] && !OutALU[7]) || (!A[7] && !bcomplement[7] && OutALU[7]))//overflow
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=1;
                        end
                        else
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=0;
                        end
                        ALUOutFlag[2]<=1;
                    end
                    else 
                    begin
                        if((A[7] && bcomplement[7] && !OutALU[7]) || (!A[7] && !bcomplement[7] && OutALU[7]))//overflow
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=1;
                        end
                        else
                        begin
                            if (!OutALU) 
                            begin//OutALU is 00000000
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 1;
                            end
                            else 
                            begin
                                if (OutALU[7]) 
                                begin//8th bit is 1
                                    ALUOutFlag[1] <= 1;
                                end
                                else 
                                begin
                                    ALUOutFlag[1]<=0;
                                end
                                ALUOutFlag[3] <= 0;
                            end
                            ALUOutFlag[0]<=0;
                        end
                        ALUOutFlag[2]<=0;
                    end
                4'b0111:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end  
                4'b1000:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b1001:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b1010:
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                    end
                4'b1011://lsl                     
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 1;
                        ALUOutFlag[2] <= A[7];//carry
                    end
                    else 
                    begin
                        if (OutALU[7]) 
                        begin//8th bit is 1
                            ALUOutFlag[1] <= 1;
                        end
                        else 
                        begin
                            ALUOutFlag[1]<=0;
                        end
                        ALUOutFlag[3] <= 0;
                        ALUOutFlag[2] <= A[7];//carry
                    end
                4'b1100://lsr A[7]=0 always positive                     
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        ALUOutFlag[1] <= 0;
                        ALUOutFlag[3] <= 1;
                        ALUOutFlag[2] <= A[0];//carry
                    end
                    else 
                    begin
                        ALUOutFlag[1] <= 0;
                        ALUOutFlag[3] <= 0;
                        ALUOutFlag[2] <= A[0];//carry
                    end
                4'b1101://asl
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        ALUOutFlag[1] <= A[6];//will be the 7th index after shifting
                        ALUOutFlag[3] <= 1;
                        ALUOutFlag[0] <= (A[7]&&!A[6]) || (A[6]&&!A[7]);//overflow -> sign has to change, control with xor
                    end
                    else 
                    begin
                        ALUOutFlag[1] <= A[6];
                        ALUOutFlag[3] <= 0;
                        ALUOutFlag[0] <= (A[7]&&!A[6]) || (A[6]&&!A[7]);//overflow -> sign has to change, control with xor
                    end
                4'b1110://asr
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        ALUOutFlag[3] <= 1;                       
                    end
                    else 
                    begin                       
                        ALUOutFlag[3] <= 0;                       
                    end
                4'b1111://csr
                    if (!OutALU) 
                    begin//OutALU is 00000000
                        ALUOutFlag[1] <= OutALU[7];
                        ALUOutFlag[3] <= 1;
                        ALUOutFlag[2] <= A[0];//carry
                    end
                    else 
                    begin
                        ALUOutFlag[1] <= OutALU[7];
                        ALUOutFlag[3] <= 0;
                        ALUOutFlag[2] = A[0];//carry
                    end
            endcase
            
        end
        
                        
endmodule

module Memory(
    input wire[7:0] address,
    input wire[7:0] data,
    input wire wr, //Read = 0, Write = 1
    input wire cs, //Chip is enable when cs = 0
    input wire clock,
    output reg[7:0] o // Output
);
    //Declaration o?f the RAM Area
    reg[7:0] RAM_DATA[0:255];
    //Read Ram data from the file
    initial $readmemh("RAM.mem", RAM_DATA);
    //Read the selected data from RAM
    always @(*) begin
        o = ~wr && ~cs ? RAM_DATA[address] : 8'hZ;
    end
    
    //Write the data to RAM
    always @(posedge clock) begin
        if (wr && ~cs) begin
            RAM_DATA[address] <= data; 
        end
    end
endmodule

module ALU_System(
    input wire[2:0] RF_OutASel, 
    input wire[2:0] RF_OutBSel, 
    input wire[1:0] RF_FunSel,
    input wire[3:0] RF_RSel,
    input wire[3:0] RF_TSel,
    
    //Bunu bi ayarlayalım
    input wire[3:0] ALU_FunSel,
    
    input wire[1:0] ARF_OutCSel, 
    input wire[1:0] ARF_OutDSel, 
    input wire[1:0] ARF_FunSel,
    input wire[3:0] ARF_RegSel,
    
    input wire IR_LH,
    input wire IR_Enable,
    input wire[1:0] IR_Funsel,
    
    input wire Mem_WR,
    input wire Mem_CS,
    
    input wire[1:0] MuxASel,
    input wire[1:0] MuxBSel,
    input wire MuxCSel,
    
    input wire Clock
    
    
);
    //wires about IR
    
    wire [15:0] IROut; 
    

    wire [7:0] MuxAOut;
    wire [7:0] MuxBOut;
    wire [7:0] MuxCOut;
    
    //wires about ARF
    wire [7:0] ARF_AOut;
    wire [7:0] Address;//Adress
    
    //wires about RF
    wire [7:0] AOut;
    wire [7:0] BOut;
    
    //wires about Alu
    wire [7:0] ALUOut;
    
    //Bu ikisine gerek kalmayabilir
    wire C_in;
    wire [3:0] FlagOut;
    
    //other
    wire [7:0] MemoryOut;
    
    
    part2a_IR IR(IR_LH, IR_Enable, IR_Funsel, MemoryOut, IROut, Clock);
    part2b_RF RF(MuxAOut, RF_OutASel, RF_OutBSel, RF_FunSel, RF_RSel,RF_TSel, Clock, AOut, BOut);
    part2c_ARF ARF(MuxBOut, ARF_OutCSel, ARF_OutDSel, ARF_FunSel, ARF_RegSel, Clock, ARF_AOut, Address);

    mux_4_1 MuxA(ALUOut, MemoryOut, IROut[7:0],ARF_AOut,MuxASel,MuxAOut);
    mux_4_1 MuxB(ALUOut, MemoryOut, IROut[7:0],ARF_AOut,MuxBSel,MuxBOut);
    mux_2_1 MuxC(AOut, ARF_AOut, MuxCSel, MuxCOut);
    
    Memory memory(Address, ALUOut, Mem_WR, Mem_CS,Clock,MemoryOut);
    
    wire [3:0]ALUOutFlag;
    ALU ALU(MuxCOut,BOut,ALUOut,ALU_FunSel,ALUOutFlag,Clock);
    
   
endmodule

/*

SECOND PROJECT

*/


module Decoder_2to4(
    input wire[1:0] in,
    output reg [3:0]out
    );
 //will be used for register selecting in Opcodes module
always@(*) begin   
    case(in)
        2'b00: begin
        out = 4'b0000;
        end
        2'b01: begin
        out = 4'b0010;
        end       
        2'b10: begin
        out = 4'b0100;
        end
        2'b11: begin
        out = 4'b1000;
        end
                          
    endcase
 end 
  
endmodule

module counter (input clock,      
                  input sc,              // Declare input port for the reset to allow the counter to be reset to 0 when required  
                  output reg[2:0] out);    
  
 
  // Once inside this block, it checks if the reset is 0, then change out to zero   
  // If reset is 1, then the design should be allowed to count up, so increment the counter   
  
always @ (posedge clock) begin  
    if (! sc)  
      out <= 0;  
    else  
      out <= out + 1;  
  end  
endmodule

module counter_decoder(
    input wire clock, 
    input wire sc,
    
    output reg T0,
    output reg T1,
    output reg T2,
    output reg T3,
    output reg T4,
    output reg T5,
    output reg T6,
    output reg T7
    );
    
    wire[2:0] count;
    counter Counter(clock, sc, count);
  
    always@(*)begin
    
    if(count == 3'b000)begin
            T0 = 1; T1 = 0; T2 = 0; T3 = 0; T4 = 0; T5 = 0; T6 = 0; T7 = 0;
    end
    else if(count == 3'b001)begin
            T0 = 0; T1 = 1; T2 = 0; T3 = 0; T4 = 0; T5 = 0; T6 = 0; T7 = 0;
        end  
    else if(count == 3'b010)begin
            T0 = 0; T1 = 0; T2 = 1; T3 = 0; T4 = 0; T5 = 0; T6 = 0; T7 = 0;
            end
    else if(count == 3'b011)begin
            T0 = 0; T1 = 0; T2 = 0; T3 = 1; T4 = 0; T5 = 0; T6 = 0; T7 = 0;
                end


    else if(count == 3'b100)begin
            T0 = 0; T1 = 0; T2 = 0; T3 = 0; T4 = 1; T5 = 0; T6 = 0; T7 = 0;
        end
    else if(count == 3'b101)begin
            T0 = 0; T1 = 0; T2 = 0; T3 = 0; T4 = 0; T5 = 1; T6 = 0; T7 = 0;
            end
    else if(count == 3'b110)begin
            T0 = 0; T1 = 0; T2 = 0; T3 = 0; T4 = 0; T5 = 0; T6 = 1; T7 = 0;
                end
    else if(count == 3'b111)begin
            T0 = 0; T1 = 0; T2 = 0; T3 = 0; T4 = 0; T5 = 0; T6 = 0; T7 = 1;
                    end  

    end

endmodule

module Opcodes(
    input wire [3:0] ZCNO, 
    input wire [15:0] IROut,
    input wire clock, 
    output reg [1:0] RF_Out1Sel, 
    output reg [1:0] RF_Out2Sel, 
    output reg [1:0] RF_FunSel,
    output reg [3:0] RF_RegSel,
    output reg [3:0] RF_TSel,
    output reg [3:0] ALU_FunSel,
    output reg [1:0] ARF_OutASel, 
    output reg [1:0] ARF_OutBSel, 
    output reg [1:0] ARF_FunSel,
    output reg [3:0] ARF_RegSel,
    output reg  IR_LH,
    output reg  IR_Enable,
    output reg [1:0] IR_FunSel,
    output reg  Mem_WR,
    output reg  Mem_CS,
    output reg [1:0] MuxASel,
    output reg [1:0] MuxBSel,
    output reg  MuxCSel);
    
 
    wire [7:0] address;
    assign address = IROut[7:0];
    
    wire addressing_mode;
    assign addressing_mode = IROut[10]; 
    
    wire [3:0]opcode;
    assign opcode[3:0] = IROut[15:12];
    
    wire [1:0] regsel;
    assign regsel[1:0] = IROut[9:8];
    
    reg sc;
    wire T0, T1, T2, T3, T4, T5, T6, T7;
    counter_decoder clock1(clock, sc, T0, T1, T2, T3, T4, T5, T6, T7);
    
    wire [3:0] SRCREG2 = IROut[3:0];
    wire [3:0] SRCREG1 = IROut[7:4];
    wire [3:0] DESTREG = IROut[11:8];
    
    /*
    Eğer RF ye yükleme yapacaksak, ARF'yi disable yapmalıyız. 
    Bunu yapmak için ilgili yere 4'b0000 vereceğiz
    
    mem wr, //Read = 0, Write = 1
    mem cs, //Chip is enable when cs = 0
    
    opcode ile ayarlamaları aşağıda always bloğunda yapacağız
    
    T0 ile T1 -> fetch yapılan ilk iki clock cycle
    
    işlemler bittikten sonra sc = 0 yapıcaz unutmayın
    */
    
    always@(*) begin
        if(T0)begin
            IR_LH <= 0;
            IR_FunSel <= 2'b01;
            IR_Enable <= 1;
            
            Mem_WR <= 0;
            Mem_CS <= 0;
        
            ARF_RegSel <= 4'b0000;
            RF_RegSel <= 4'b0000;
            RF_TSel <= 4'b0000;
    
        end
        if(T1) begin 
            IR_LH <= 1;
            IR_FunSel <= 2'b01;
            IR_Enable <= 1;
            
            Mem_WR <= 0;
            Mem_CS <= 0;
        
            ARF_RegSel <= 4'b0000;
            RF_RegSel <= 4'b0000;
            RF_TSel <= 4'b0000;
        end
        if(T2) begin
        end
        if(T3) begin
        end
       
    end

endmodule

module Project2( input wire clock);
                 
    wire[1:0] RF_Out1Sel; 
    wire[1:0] RF_Out2Sel; 
    wire[1:0] RF_FunSel;
    wire[3:0] RF_RegSel;
    wire[3:0] RF_TSel;
    wire[3:0] ALU_FunSel;
    wire[1:0] ARF_OutASel; 
    wire[1:0] ARF_OutBSel; 
    wire[1:0] ARF_FunSel;
    wire[2:0] ARF_RegSel;
    wire IR_LH;
    wire IR_Enable;
    wire[1:0] IR_Funsel;
    wire Mem_WR;
    wire Mem_CS;
    wire[1:0] MuxASel;
    wire[1:0] MuxBSel;
    wire MuxCSel;

    wire[3:0] ZCNO;
    wire[15:0] IR_Out;
    wire sc;
    
    Opcodes opcodes(ZCNO, IR_Out ,clock,RF_Out1Sel, RF_Out2Sel,
           RF_FunSel,
           RF_RegSel,
           RF_TSel,
           ALU_FunSel,
           ARF_OutASel, 
           ARF_OutBSel, 
           ARF_FunSel,
           ARF_RegSel,
           IR_LH,
           IR_Enable,
           IR_Funsel,
           Mem_WR,
           Mem_CS,
           MuxASel,
           MuxBSel,
           MuxCSel);
           
           
    ALU_System ALU(RF_Out1Sel, 
        RF_Out2Sel,
        RF_FunSel,
        RF_RegSel,
        RF_TSel,
        ALU_FunSel,
        ARF_OutASel, 
        ARF_OutBSel, 
        ARF_FunSel,
        ARF_RegSel,
        IR_LH,
        IR_Enable,
        IR_Funsel,
        Mem_WR,
        Mem_CS,
        MuxASel,
        MuxBSel,
        MuxCSel,
        clock,
        
        IR_Out,
        ZCNO
        );


endmodule
