`timescale 1ns / 1ps


//PART 1
module Register #(parameter n = 8)(in, enable, select, clock, out);

    input wire[n-1:0] in;
    input wire[0:0] enable;
    input wire[1:0] select;
    input wire clock;
    reg[n-1:0] present;
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

/* TODO
BURASI 16 BÝT REGÝSTER ÝLE YAPILMALI
*/
module part2a_IR(LH, enable, select, in, out, clock);
    input wire[7:0] in;
    input wire[0:0] enable;
    input wire[1:0] select;
    input wire clock;
    input wire LH;
    output wire[15:0] out;
    reg[15:0] present;
    
    assign out = present;
  
          always @ (posedge clock && enable) begin
               
               if(select == 2'b00) begin
                  present <= 16'b0000000000000000;

               end
                 
               else if(select == 2'b01) begin 
                   if(LH == 0)begin 
                    present <= {present[15:8],in};                  
                   end
                   
                   
                   if(LH == 1)begin 
                   present <= {in,present[7:0]};              
                   end
               end
               
               else if(select == 2'b10) begin
                   present <= present - 16'b0000000000000001;

                  
               end
               
               else if(select == 2'b11) begin
                   
                   present <= present + 16'b0000000000000001; 
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

module part2c_ARF(in, O1Sel, O2Sel, fun_sel, reg_sel, clock, outA, outB, PC_out, AR_out, SP_out,PC_prev_out);
    input wire[7:0] in;
    input wire[1:0] O1Sel;
    input wire[1:0] O2Sel;
    input wire[1:0] fun_sel;
    input wire[2:0] reg_sel;
    input wire clock;
    output reg[7:0] outA;
    output reg[7:0] outB;
    
    output wire[7:0] PC_out;
    output wire[7:0] AR_out;
    output wire[7:0] SP_out;
    output wire[7:0] PC_prev_out;
    
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

