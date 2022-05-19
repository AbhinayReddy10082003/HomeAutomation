`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2022 02:28:15
// Design Name: 
// Module Name: testBench
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


module testBench;
reg clk,reset,fire,din;
reg [7:0] temp,light;
reg [6:0] humidity;
wire fire_alm,heater,cooler,wd,l_high,l_low;
wire [7:0] seg_out;
homeAutomation m(.clk(clk),.reset(reset),.fire(fire),.din(din),.temp(temp),
.light(light),.seg_out(seg_out),.humidity(humidity),.fire_alm(fire_alm),
.heater(heater),.cooler(cooler),.wd(wd),.l_high(l_high),.l_low(l_low));
initial clk=0;
always #5 clk = ~clk;
initial
begin
//$monitor($time,"clk=%b,reset=%b,fire=%b,temp=%b,fire_alm=%b,heater=%b,cooler=%b",clk,reset,fire,temp,fire_alm,heater,cooler);
//$monitor($time,"clk=%b,reset=%b,temp=%b,heater=%b,cooler=%b",clk,reset,temp,heater,cooler);

reset=1;
#5 reset=0;
#10 fire=1;temp=8'b00100010;humidity=7'b0111000;light=8'b00010000;
#20 fire=0;

//#10 reset=1;
//#10 reset=0;
//#5 fire=1;
//#10 temp=8'b00101001;
//#10 temp=8'b00000111;
//#10 reset=1;
//#5 light=8'b00010011;
//#10 reset=1;
#20 $finish;

end
endmodule
