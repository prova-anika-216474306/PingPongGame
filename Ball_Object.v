module Ball_Object(
	input clk,clk_1ms,reset,
	input [9:0] x, y,
	output ball_on,
	output [11:0] rgb_ball,
	input [9:0] x_paddle1, x_paddle2, y_paddle1, y_paddle2,
	output reg [3:0]  p1_score, p2_score,
	input [1:0] game_state
	);
		
	//boundaries of the screen -horizontal and vertical
	localparam H_ACTIVE	= 640;
	localparam V_ACTIVE	= 480;
	
	//size of the ball
	localparam ball_width = 16; 
	localparam ball_height = 16;
	
	//size of the paddle
	localparam paddlewidth = 16;
	localparam paddleheight = 80;
	
	//instantaneous direction of the ball
	integer dx = 1, dy = 1;
	
	//current position of the ball
	reg [9:0] x_ball, y_ball;
		
	always @ (posedge clk_1ms)
	begin
		if(!reset)
		begin
			x_ball <= H_ACTIVE/2;
			y_ball <= V_ACTIVE/2;
			p1_score <= 0;
			p2_score <= 0;	
		end
		else if (game_state == 2'b01)
		begin
		
			// collision with the screen edges
			if (y_ball == (ball_height/2)+1)
				dy = dy*-1;
			if (y_ball == (V_ACTIVE-(ball_height/2)-1))
				dy = dy*-1;

			// after collision with the paddle,the direction of the ball changes
			if (x_ball > (x_paddle2-ball_width/2) && y_ball > (y_paddle2 - paddleheight/2) && y_ball < (y_paddle2 + paddleheight/2))
				dx = dx*-1;
			if (x_ball < (x_paddle1+ball_width/2) && y_ball > (y_paddle1 - paddleheight/2) && y_ball < (y_paddle1 + paddleheight/2))
				dx = dx*-1;
			
			//which half of the screen was the ball -> other side wins
			if (x_ball == (H_ACTIVE -ball_width/2))
			begin 
				x_ball <= H_ACTIVE/2;
				y_ball <= V_ACTIVE/2;
				dy = dy*-1;
				dx = dx*-1;
				p1_score <= p1_score+1;
			end
			else if (x_ball == 0)
			begin 
				x_ball <= H_ACTIVE/2;
				y_ball <= V_ACTIVE/2;
				dy = dy*-1;
				dx = dx*-1;
				p2_score <= p2_score+1;
			end
			else
			begin
				x_ball <= x_ball + dx;
				y_ball <= y_ball + dy;	
			end
		end
		else 
		//stagnant state -> no hits
		begin
			x_ball <= x_ball;
			y_ball <= y_ball;
		end	
	end
		
	assign ball_on = (x >= x_ball-(ball_width/2) && x <= x_ball+(ball_width/2) && y >= y_ball-(ball_height/2) && y <= y_ball+(ball_height/2))?1:0;
	
	//design to render
	assign rgb_ball = 12'b000011111111;
	
	
	
endmodule