`timescale 1ns/1ps

module Functional_Unit(instruction, A, B, C, select, F);
    input wire [7:0] instruction;
    input wire [7:0] A;
    input wire [7:0] B;
    input wire [7:0] C;
    input wire [2:0] select;
    output [7:0] F;
    reg [7:0] F;
    reg [7:0] X, Y;
    wire [2:0] encoder_instruction;

    encoder e1(instruction,encoder_instruction);

    always @(select, encoder_instruction, A, B, C) begin
        case (select)
            3'b011 : begin
                X = B;
                Y = C;
            end 
            3'b101 : begin
                X = A;
                Y = C;
            end
            3'b110 : begin
                X = A;
                Y = B;
            end
            default: begin
                X = C;
                Y = A;
            end 
        endcase

        case (encoder_instruction)
            3'b000: F = X + Y;
            3'b001: F = X + ~Y;
            3'b010: F = X & Y;
            3'b011: F = X | Y;
            3'b100: begin
                if(X > Y) F = X;
                else F = Y;
            end
            3'b101: begin
                if(X < Y) F = X;
                else F = Y;
            end
            3'b110: F = {X[0], X[7:1]} + Y;
            3'b111: F = {X[6:0], X[7]} + Y;
            default: F = F;
        endcase
    end
    //TODO: write your design below
    //You can define F as 'reg' or 'wire'
    //You must only use "encoder_instructions", not "instruction".

endmodule

module encoder (instruction,encoder_instruction);

    input wire[7:0] instruction;
    output [2:0] encoder_instruction;
    reg [2:0] encoder_instruction;

    always @(instruction) begin
        casex (instruction)
            8'b00000000: encoder_instruction = 0;
            8'b00000001: encoder_instruction = 0;
            8'b0000001X: encoder_instruction = 1;
            8'b000001XX: encoder_instruction = 2;
            8'b00001XXX: encoder_instruction = 3;
            8'b0001XXXX: encoder_instruction = 4;
            8'b001XXXXX: encoder_instruction = 5;
            8'b01XXXXXX: encoder_instruction = 6;
            8'b1XXXXXXX: encoder_instruction = 7;
            default: encoder_instruction = 0;
        endcase
    end
    //TODO: write your design below
    //You can define encoder_instruction as 'reg' or 'wire'

endmodule