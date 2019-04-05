module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, up,down,left,right);

	
input iRST_n;
input iVGA_CLK;
input up,down,left,right; 
reg[18:0] xcoordinate, ycoordinate;
reg[64:0] counter; 


initial
begin 
	xcoordinate = 200; 
	ycoordinate = 200; 
	
	
	
	
	counter = 0; 
end




output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
reg [7:0] temp; 
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;

//address stuff
wire [18:0]address_x,address_y;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
assign address_x = ADDR % 19'd640; 
assign address_y = ADDR / 19'd640; 
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
//
//
img_data	img_data_inst (
				.address ( ADDR ),
				.clock ( VGA_CLK_n ),
				.q ( index )
				);
				
//always@(posedge iVGA_CLK)
//begin
//	begin
//		if(((address_x > xcoordinate) && address_x < (xcoordinate+50)) && ((address_y > ycoordinate)&&address_y<(ycoordinate+50)))
//				temp <= 1;
//		else if(address_y<240)
//				temp<=2;
//		else
//				temp<=0;
//	end	
//	if(~up&&ycoordinate>0&&counter>1000000)
//		begin
//			ycoordinate = ycoordinate - 1;
//			counter = 0 ; 
//		end
//	if(~down&&ycoordinate<430&&counter>1000000)
//		begin
//			ycoordinate = ycoordinate +1; 
//			counter = 0; 
//		end
//	if(~right&&xcoordinate<590&&counter>1000000)
//		begin
//			xcoordinate = xcoordinate +1; 
//			counter = 0;
//		end
//	if(~left&&xcoordinate>0&&counter>1000000)
//		begin
//			xcoordinate = xcoordinate -1; 
//			counter = 0; 
//		end
//	if(counter>10000000000)
//		counter =0;
//	counter = counter +1; 
//end
//assign index = temp; 
/////////////////////////
//////Add switch-input logic here


//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















