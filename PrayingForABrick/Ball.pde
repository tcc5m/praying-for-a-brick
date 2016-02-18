
class Ball
{
   float x, y;
   float vx, vy;
   float r;
   Boolean isCaught;
   Boolean isInvincible = false;
   Boolean doCatch = false;
   float maxSpeed = 8; //this is the max speed of the ball
   Ball()
   {
      x = 0;
      y = 0;
      vx = 0;
      vy = 0;
      isCaught = true;
      r = 6;
   }
   Ball(float x, float y, float r, int maxSpeed)
   {
      this.x = x;
      this.y = y;
      vx = 0;
      vy = 0;
      isCaught = true;
      this.r = r;
      this.maxSpeed = maxSpeed;
   }
   Ball(float x, float y, float r, int maxSpeed, float vx, float vy, Boolean isCaught)
   {
      this.x = x;
      this.y = y;
      this.r = r;
      this.vy = vy;
      this.vx = vx; 
      this.isCaught = isCaught;
      this.maxSpeed = maxSpeed;
   }
   Boolean update(int screenWidth, int screenHeight, int[][] colors, int [][] shades, Brick[][] daBricks, Paddle daPaddle, GameState daGame)
   {
      maxSpeed *= 1.0001;
      Boolean lifeLost = false; //
      if(isCaught) //if the ball is caught (new game or catch powerup)
         caughtRoutine(daPaddle);
      else
         lifeLost = freeRoutine(screenHeight, screenWidth, daPaddle, daGame, daBricks);
      drawBall(colors, shades);
      return lifeLost;
   }
   void drawBall(int[][] colors, int[][] shades)
   {
      if(isInvincible) //if the incinvibility powerup is active
      {
         Random ran = new Random();
         int i = ran.nextInt(7);
         fill(colors[i][0],colors[i][1],colors[i][2]); //make the ball all rainbow n stuff
      }
      else
         fill(shades[4][0], shades[4][0], shades[4][0]); //white balls
      ellipse(x, y, r * 2, r * 2); //draw that big beautiful ball
   }
   void caughtRoutine(Paddle daPaddle)
   {
      x = daPaddle.x + daPaddle.w / 2;
      y = daPaddle.y - r;
   }
   Boolean freeRoutine(int screenHeight, int screenWidth, Paddle daPaddle, GameState daGame, Brick[][] daBricks)
   {
      Boolean lifeLost = false;
      x = constrain(x + vx, 0 + r, screenWidth - r); //keep the ball from going off the screen
      y = constrain(y + vy, 0 + r, screenHeight - r); //while incrementing x and y values
      if(!hitDaPaddle(daPaddle, daGame) && !hitDaBricks(daBricks, daGame)) //if the ball has not hit the paddle or the bricks
         lifeLost = hitWalls(screenWidth, screenHeight, daGame); //update the direction of the ball if wall hit, returns true if a life was lost (bottom hit and not invincible)
      return lifeLost;
   }
   Boolean hitDaBricks(Brick[][] daBricks, GameState daGame)
   {
      Physics p = new Physics();
      Boolean flipX = false, flipY = false;
      for(int i = 0; i < daBricks.length; i++)
      {
         for(int j = 0; j < daBricks[i].length; j++)
         {
            if(!daBricks[i][j].isHit) //if the brick has not already been hit
            {
               int side = p.getHitSide(this, daBricks[i][j]);
               if(side != -1) //if the ball has hit a brick
               {
                  daBricks[i][j].hit(); //indicate the brick has been hit
                  daGame.score += 1; //increment score
                  daGame.streak++;
                  if(daBricks[i][j].isHit)
                     daGame.hitBricks++;
                  if(side == 1 || side == 2 || side == 0) //the ball has hit a brick on the left or right
                     flipX = true;
                  if(side == 3 || side == 4 || side == 0) //the ball has hit a brick on the top or bottom
                     flipY = true;
               }
            }
         }
      }
      if(flipX) //if we need to change x direction
         vx *= -1;
      if(flipY) //if we need to change y direction
         vy *= -1;
      return (flipX || flipY);
   }
   Boolean hitDaPaddle(Paddle daPaddle, GameState daGame)
   {
      Physics p = new Physics();
      int side = p.getHitSide(this, daPaddle); //get what side of the paddle, if any, the ball hit
      if(doCatch && side != -1) //if the catch powerup is active but the ball has not yet hit the paddle
      {
         isCaught = true;
         doCatch = false;
         daGame.powerUps[0] = 0;
      }
      else if(side == 3 || side == 4) //if the ball has hit the top or booty side of the paddle
      {
         float f = map(daPaddle.x - x, 0, -1 * daPaddle.w, -1 * (maxSpeed - 1), maxSpeed - 1); //f will be more negative to the left side of the paddle and more positive to the right
         f = constrain(f, -1 * (maxSpeed - 1), maxSpeed - 1); //but it will not exceed maxSpeed -1 or -maxSpeed +1
         vx = f; //if the ball hit the very left side, it will angle very far to the left, and if it hits right
         //it will angle far to the right. if it hits in the middle,
         vy = maxSpeed - abs(f); //the ball will bounce straight up (or down if it hits the bottom)
         if(side == 3)
            vy *= -1;
      }
      else if(side == 1 || side == 2) //if the ball has hit the left or right of the paddle
      {
         float f = map(daPaddle.y - y, 0, -1 * daPaddle.h, -1, -1 * (maxSpeed -1) );
         f = constrain(f, -1, maxSpeed - 1);
         vy = f;
         vx = maxSpeed - abs(f);
         if(side == 1)
            vx *= -1;
      }
      else if(side == 0)
      {
         if(daPaddle.x + daPaddle.w - x > x - daPaddle.x)
            vx = 4;
         else
            vx = -4;
         if(daPaddle.y + daPaddle.h - y > y - daPaddle.y)
            vy = 4; 
         else
            vy = -4;
      }
      float multiplier = maxSpeed / sqrt(pow(abs(vx), 2) + pow(abs(vy), 2) );
      vx *= multiplier;
      vy *= multiplier;
      return side != -1 && !isCaught;
   }
   Boolean hitWalls(int screenWidth, int screenHeight, GameState daGame)
   {
      if(y + r >= screenHeight && !isInvincible) //if the ball has hit the bottom without invincibility
         return true; //return true indicating a life has been lost
      if(x + r >= screenWidth || x - r <= 0) //if the ball hit the left or right
         vx *= -1; //flip the x
      if(y + r >= screenHeight || y - r <= 0 + daGame.h) //if the ball hit the top or bottom
         vy *= -1; //flip the y
      return false; //return false indicating that no lives were lost this day
   }
}
