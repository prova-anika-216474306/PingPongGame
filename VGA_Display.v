module VGA_Display(
	input clk, reset,
	input [9:0] x, y,//position of point
	input video_on,
	output [11:0]rgb,
	input clk_1ms,
	input paddle1_on, paddle2_on, ball_on, 
	input [11:0]rgb_paddle1, rgb_paddle2, rgb_ball,
	input [1:0] game_state
	);
	
	reg [11:0] rgb_reg;

	
	localparam H_ACTIVE	= 640;
	localparam V_ACTIVE	= 480;
	localparam zero		= 0;
	
	localparam X_blocksize = 50; 
	localparam Y_blocksize = 50;
	
	reg [9:0] x_block = H_ACTIVE/2, y_block=V_ACTIVE/2;
	
	
	always @(posedge clk)
	begin
	if (!reset)
		rgb_reg <= 0;//black screen or start screen?
	else
		begin
			if (game_state == 2'b01)
			begin
			//drawing components on screen by detecting if object signal is on
				if (paddle1_on)
					rgb_reg <= rgb_paddle1;
				else if (paddle2_on) 
					rgb_reg <= rgb_paddle2;
				else if (ball_on)
					rgb_reg <= rgb_ball;
				else
					rgb_reg <= 12'b000000000000;
			end
			else if (game_state == 2'b10)
				rgb_reg <= rgb_paddle1;
			else if (game_state == 2'b11)
				rgb_reg <= rgb_paddle2;
			else rgb_reg <= 0;
		end
	end
	//if video on they display 
	assign rgb = (video_on) ? rgb_reg : 8'b0;
	
endmodule