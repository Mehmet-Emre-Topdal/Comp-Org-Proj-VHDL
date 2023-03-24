`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2023 21:45:53
// Design Name: 
// Module Name: simulations
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

module Register_test( );
    parameter N = 8;
    reg[N-1:0] in;
    reg enable;
    reg[1:0] select;
    reg clock;
    wire [N-1:0] out;
    
    Register #(N)test( in, enable, select, clock, out);
        
    initial begin clock = 0;
        in = 1'b1; select = 2'b01 ;enable = 1; #200; /*Load*/
        in = 1'b1; select = 2'b11 ;enable = 1; #200;/*increment*/
        in = 1'b1; select = 2'b10 ;enable = 1; #200;/*decrement*/
        in = 1'b1; select = 2'b00 ;enable = 1; #200;/*clear*/
        in = 1'b1; select = 2'b01 ;enable = 0; #200;/*retain*/

    end
    
    always begin
        clock = ~ clock; #50;
    end
    
endmodule

module part2a_test();
    reg[7:0] in;
    reg enable;
    reg[1:0] select;
    reg clock;
    reg LH;
    wire [15:0] out;
    
    part2a_IR test(LH, enable, select, in, out, clock);
    initial begin clock = 0;
        //Load 0-7
        in = 8'b00000000; select = 2'b01 ;enable = 1; LH=0;#100;

        //load 8-15
        in = 8'b11111111; select = 2'b01 ;enable = 1; LH=1;#100;

        //increment
        in = 8'b00000100; select = 2'b11 ;enable = 1; LH=0;#100;

        //decrement
        in = 8'b00000100; select = 2'b10 ;enable = 1; LH=0;#100;

        //retain value
        in = 8'b00000100; select = 2'b10 ;enable = 0; LH=1;#100;

        //clear
        in = 8'b00000100; select = 2'b00 ;enable = 1; LH=0;#100;

    end
    
    always begin
        clock = ~ clock; #50;
    end
endmodule

module part2b_RF_test();
    reg[7:0] in;
    reg[2:0] O1Sel;
    reg[2:0] O2Sel;
    reg[1:0] fun_sel;
    reg[3:0] reg_sel;
    reg[3:0] t_sel;
    reg clock;
    wire[7:0] O1;
    wire[7:0] O2;
    
    part2b_RF test(in, O1Sel, O2Sel, fun_sel, reg_sel,t_sel, clock, O1, O2);
    
    initial begin clock = 0;
        //load every register with 5
        in = 8'b00000101; fun_sel = 2'b01 ;reg_sel = 4'b1111;t_sel = 4'b1111; O1Sel = 3'b100; O2Sel = 3'b000;  #200; 
        //select two and decrement them
        in = 8'b00000101; fun_sel = 2'b10 ;reg_sel = 4'b1000;t_sel = 4'b1000; O1Sel = 3'b100; O2Sel = 3'b000;  #200; 
        //select other two and increment them
        in = 8'b00000101; fun_sel = 2'b11 ;reg_sel = 4'b0100;t_sel = 4'b0100; O1Sel = 3'b101; O2Sel = 3'b001;  #200; 
        //retain value -not enable-
        in = 8'b11111111; fun_sel = 2'b01 ;reg_sel = 4'b0000;t_sel = 4'b0000; O1Sel = 3'b101; O2Sel = 3'b001;  #200;
        //clear all 
        in = 8'b01010101; fun_sel = 2'b00 ;reg_sel = 4'b1111;t_sel = 4'b1111; O1Sel = 3'b101; O2Sel = 3'b001;  #200;
    end
    
    always begin
        clock = ~ clock; #100;
    end
endmodule

module part2c_ARF_test();
    reg[7:0] in;
    reg[1:0] OutASel;
    reg[1:0] OutBSel;
    reg[1:0] fun_sel;
    reg[3:0] reg_sel;
    reg clock;
    wire[7:0] outA;
    wire[7:0] outB;
    
    part2c_ARF test(in, OutASel, OutBSel, fun_sel, reg_sel, clock, outA, outB);
    
    initial begin clock = 0;
        //load
        in = 8'b00000001; fun_sel = 2'b01 ;reg_sel = 4'b1111; OutASel = 2'b00; OutBSel = 2'b10;  #200;
        //increment
        in = 8'b00000001; fun_sel = 2'b11 ;reg_sel = 4'b1111; OutASel = 2'b00; OutBSel = 2'b10;  #200;
        //decrement
        in = 8'b00000001; fun_sel = 2'b10 ;reg_sel = 4'b1111; OutASel = 2'b00; OutBSel = 2'b10;  #200;
        //retain
        in = 8'b00000001; fun_sel = 2'b11 ;reg_sel = 4'b0000; OutASel = 2'b00; OutBSel = 2'b10;  #200;
        //clear
        in = 8'b00000001; fun_sel = 2'b00 ;reg_sel = 4'b1111; OutASel = 2'b00; OutBSel = 2'b10;  #200;
    end
    
    always begin
        clock = ~ clock; #50;
    end
endmodule



