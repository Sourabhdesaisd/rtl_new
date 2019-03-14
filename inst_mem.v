// inst_mem.v
// Simple 32-bit word-addressed instruction memory

module inst_mem (
	input clk,
	input rst,
 	input   [9:0] pc, 
	input   write_en,
	input   [9:0] write_addr,
	input   [31:0] write_data,
	
    output  [31:0] instruction
);
    reg [31:0] mem [0:1023];
   
 integer i;
/*    initial begin
        $readmemh("instructions.hex", mem);  // optional
    end */

always@(posedge clk or posedge rst)
begin

if(rst)
begin

for(i=0; i<1024 ; i= i+1 )
mem[i] 		<= 		32'd0 				;

end

else if (write_en)

mem[write_addr] <= write_data ;


end

assign instruction = mem[pc];

endmodule





