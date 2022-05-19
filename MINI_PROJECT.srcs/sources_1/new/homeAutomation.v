`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2022 23:28:15
// Design Name: 
// Module Name: homeAutomation
// Project Name: Home Automation System
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

// assigning numbers to states
`define start 4'd0
`define fire_st 4'd2
`define cool_st 4'd3
`define heat_st 4'd4
`define windows 4'd5
`define bright 4'd6
`define dim 4'd7
`define comb_lock 4'd8


module homeAutomation(clk,reset,din,fire,temp,humidity,light,seg_out,fire_alm,heater,cooler,wd,l_high,l_low);
input clk,reset,fire,din;
input [7:0] temp,light;
input [6:0] humidity;
output reg fire_alm,heater,cooler,wd,l_high,l_low; 
output [7:0] seg_out;
reg [3:0] current_st;
reg [3:0] next_st;
wire dclk;
wire [3:0] bcd_data;
debounce_filter m1 (.clk(clk), .rst (reset), .din(din), .dout(dclk));
bcd_counter m2 (.clk(dclk), .rst(reset), .q (bcd_data));
bcd_7seg m3 (.bcd_in(bcd_data), .sseg(seg_out));
initial
begin
    current_st=`start;
    next_st= `start;
    fire_alm='b0;
    cooler='b0;
    heater='b0;
    wd='b0;
    l_high='b0;
    l_low='b0;
end

always @(posedge clk)
current_st=next_st;
always @(current_st)
begin
    case(current_st)
    `start: 
    begin
        fire_alm='b0;
        cooler='b0;
        heater='b0;        
        wd='b0;
        l_high='b0;
        l_low='b0;
    end
    `fire_st: fire_alm='b1;
    `cool_st: cooler='b1;
    `heat_st: heater='b1;    
    `windows:wd='b1;
    `bright: l_high='b1; //confirm whether its l_low or l_high
    `dim: l_low='b1;    
    endcase 
end
always @(current_st,fire,temp,humidity,light,reset,din)
begin
    if(reset=='b1)
        next_st=`start;
    else
        case(current_st)
        `start:
            begin
            if(fire=='b1)
            next_st=`fire_st;
    //        else if(f_sen=='b1)
    //        next_st=`fire_st;
            else if(temp > 'b00011110)
            next_st=`cool_st;
            else if(temp < 'b00001111)
            next_st=`heat_st;
            else if(humidity>'b0110010)
            next_st=`windows;
            else if(light < 'b00110010)
            next_st=`bright;
            else if(light > 'b00110010)
            next_st=`dim;
            else next_st=`start;
            end 
         `fire_st:
         
            begin
            if(temp > 'b00011110)
            next_st=`cool_st;
            else if(temp < 'b00001111)
            next_st=`heat_st;
            else if(humidity>'b0110010)
            next_st=`windows;
            else if(light < 'b00110010)
            next_st=`bright;
            else if(light > 'b00110010)
            next_st=`dim;
            else next_st=`start;
            end
         `cool_st:
            begin
            if(temp < 'b00001111)
            next_st=`heat_st;
            else if(humidity>'b0110010)
            next_st=`windows;
            else if(light < 'b00110010)
            next_st=`bright;
            else if(light > 'b00110010)
            next_st=`dim;
            else next_st=`start;
            end 
          `heat_st:
            begin
            if(humidity>'b0110010)
            next_st=`windows;
            else if(light < 'b00110010)
            next_st=`bright;
            else if(light > 'b00110010)
            next_st=`dim;
            else next_st=`start;
            end
          `windows:
            begin
            if(light < 'b00110010)
            next_st=`bright;
            else if(light > 'b00110010)
            next_st=`dim;
            else next_st=`start;
            end
          `bright:
            begin
            if(light > 'b00110010)
            next_st=`dim;
            else next_st=`start;
            end
          `dim:
            begin
            next_st=`start;
            end
           endcase
end
endmodule

//Debounce Filter
module debounce_filter(
 input din,
 input clk,
 input rst,
 output dout
 );
reg [2:0] temp;
always @ (posedge clk or posedge rst)
begin
    if (rst == 1'b1)
        temp <= 4'b000;
    else
        temp <= {temp[1:0], din};
end
assign dout = temp[0] & temp[1] & (!temp[2]);
endmodule

//BCD Counter
module bcd_counter(
 input clk,
 input rst,
 output reg [3:0] q
 );
always@ (posedge clk or posedge rst)
begin
    if (rst)
        q <= 4'b0000;
    else if (q == 4'b1001)
        q <= 4'b0000;
    else
        q <= q + 1;
end
endmodule

//BCD to 7 Segment Display
module bcd_7seg(
 input wire [3:0] bcd_in,
 output reg [7:0] sseg
 );
always @ (bcd_in)
begin
    case (bcd_in)
    4'b0000: 
        sseg = 8'b10000001; //01111110;
    4'b0001: 
        sseg = 8'b11001111; //00110000;
    4'b0010: 
        sseg = 8'b10010010; //01101101;
    4'b0011: 
        sseg = 8'b10000110; //01111001;
    4'b0100:
        sseg = 8'b11001100 ;//00110011;
    4'b0101: 
        sseg = 8'b10100100; //01011011;
    4'b0110: 
        sseg = 8'b10100000; //01011111;
    4'b0111: 
        sseg = 8'b10001111; //01110000;
    4'b1000: 
        sseg = 8'b10000000; //01111111;
    default : sseg = 8'b10000100; //01111011;
    endcase
end
endmodule
