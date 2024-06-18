`timescale 1ns/1ps
module find_MAX(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire valid,
    input wire [7:0] data_A,
    input wire [7:0] data_B,
    input wire [7:0] data_C,
    input wire [7:0] instruction,
    input wire [2:0] count,
    input wire [2:0] select,
    output reg [7:0] second_maximum
);
    wire [7:0] result;

    // Functional_Unit instantiation
    Functional_Unit fu(
        .instruction(instruction), 
        .A(data_A),
        .B(data_B),
        .C(data_C),
        .select(select),
        .F(result)
    );
    //TODO: write your design below
    //You cannot modify anything above
    reg [9:0] round;
    reg [2:0] origin_count;
    reg [2:0] now_count;
    reg [7:0] max;
    reg [7:0] sec;
    reg [7:0] tmp_ans;
    reg Started;
    reg [2:0] control;
    always @(posedge clk) begin
        if(!rst_n) begin
            round = 1;
            origin_count = 3'b0;
            now_count = 3'b0;
            max = 8'b0;
            sec = 8'b0;
            tmp_ans = 8'b0;
            second_maximum = 8'b0;
            Started = 0;
            control = 3'b0;
            $display("reset, max: %b, sec: %b",max,sec);
        end
        else begin
            if(start) begin
                now_count = count;
                origin_count = count;
                Started = 1;
                $display("round: %b",round);
                round = round + 1;
                max = 8'b0;
                sec = 8'b0;
                tmp_ans = 8'b0;
            end
            if(valid && now_count != 0 && Started) begin
                $display("round %b",now_count);
                $display("result: %b",result);
                now_count = now_count - 1;
                control = origin_count - now_count;
                $display("now control: %b",control);
                case (control)
                    3'b001: begin
                        max = result;
                        $display("set max: %b",max);
                    end
                    3'b010: begin
                        if(result > max) begin
                            sec = max;
                            max = result;
                        end
                        else sec = result;
                        $display("set sec: %b",sec);
                        $display("now max: %b",max);
                    end
                    default: begin
                        if(result > max) begin
                            sec = max;
                            max = result;
                            $display("now sec: %b",sec);
                            $display("now max: %b",max);
                        end
                        else if(result < max && result > sec) begin
                            sec = result;
                            $display("set sec: %b",sec);
                        end
                        else if(result == max) begin
                            sec = max;
                            $display("set sec: %b",sec);
                        end
                    end
                endcase
                tmp_ans = sec;
                $display("the tmp ans now: %b",tmp_ans);
            end
            else if(now_count == 0 && Started == 1) begin
                second_maximum = tmp_ans;
                Started = 0;
            end
            else;
        end 
    end

endmodule