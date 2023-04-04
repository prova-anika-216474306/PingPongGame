//module Clock_Divider(
//    input clk,
//    output reg clk_1ms = 0
//    );
//  
//    reg [27:0] i = 0;
//    
//	 always @ (posedge clk)
//    begin
//        if (i == 124999)
//        begin
//            i <= 0;
//            clk_1ms = ~clk_1ms;
//        end
//        else i <= i+1;
//    end
//    
//endmodule

module Clock_Divider(clk,clk_1ms);

input clk;
output reg clk_1ms;
   
reg[31:0] count     = 32'd0;
parameter D         = 65000;    // toggle every 0.5 sec  

always @(posedge clk) begin
        
    if (count >= D-1) begin             //reset to 0
        count <= 32'd0;
        clk_1ms  <= ~clk_1ms;                 // toggle           
    end else begin
        count <= count + 32'd1;
    end
end

endmodule