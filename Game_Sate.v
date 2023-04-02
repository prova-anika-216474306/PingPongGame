module Game_State(
	input clk, clk_1ms, reset,
	input [3:0] p1_score, p2_score,
	output reg [1:0] gstate
	);
	
	reg [3:0] win = 4'b0101; //No. of goals to win

	//check at every clock change what is the state
	always @ (posedge clk)
	begin
		if (!reset)
			gstate = 0; //begin
		else 
		begin
			if ( p1_score == win)
				gstate = 2'b10;//player ONE won
				
			else if ( p2_score == win)
				gstate = 2'b11;//player TWO won
				
			else 
				gstate = 2'b01;//still playing
		end
	end

endmodule