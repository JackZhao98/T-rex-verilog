module SRAM #(parameter ADDR_W = 8, DATA_W = 8, DEPTH = 256, MEMFILE="")
   (
    input wire 		     clk,
    input wire [ADD_W-1:0]   ADDR,
    input wire 		     MemWrite,
    input wire [DATA_W-1:0]  DATA,
    output wire [DATA_W-1:0] DATA_OUT);

   reg [DATA_W-1:0] 	     DataReg;
   reg [DATA_W-1:0] 	     memory [0:DEPTH-1];

   initial
     begin
	if (MEMFILE > 0)
	  $readmemh(MEMFILE, memory);
     end

   always @(posedge clk)
     begin
	if (MemWrite)
	  memory[ADDR] <= DATA;
	else
	  DataReg <= memory[ADDR];
     end

   assign DATA_OUT = DataReg;

endmodule // SRAM 
