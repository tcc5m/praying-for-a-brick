
class Ball
{
   float x, y;
   float vx, vy;
   float r = 6;
   Boolean isCaught;
   Boolean isInvincible = false;
   int maxSpeed = 4;
   Ball()
   {
      x = 0;
      y = 0;
      vx = 0;
      vy = 0;
      isCaught = true;
   }
   Ball(float x, float y)
   {
      this.x = x;
      this.y = y;
      vx = 0;
      vy = 0;
      isCaught = true;
   }
   Ball(float x, float y, float vx, float vy, Boolean isCaught)
   {
      this.x = x;
      this.y = y;
      this.vy = vy;
      this.vx = vx; 
      this.isCaught = isCaught;
   }
   void update(int screenWidth, int screenHeight, Brick[][] daBricks, Paddle daPaddle, GameState daGame)
   {
      if(isCaught) //if the ball is caught (new game or catch powerup)
      {
         if(daController.buttons[0])
         {
            daBall.isCaught = false;
            daBall.vy = maxSpeed * -1; 
         }
         x = daPaddle.x + daPaddle.w / 2;
         y = daPaddle.y - r;
      }
      else
      {
         x = constrain(x + vx, 0 + r, screenWidth - r);
         y = constrain(y + vy, 0 + r, screenHeight - r);
         if(!hitDaPaddle(daPaddle) && !hitDaBricks(daBricks))
         {
            updateDirection(screenWidth, screenHeight, daGame);
         }
      }
      Random ran = new Random();
      int i = ran.nextInt(7);
      fill(colors[i][0],colors[i][1],colors[i][2]);
      ellipse(x, y, r * 2, r * 2);
   }
   Boolean hitDaBricks(Brick[][] daBricks)
   {
      int flipSide = 0;
      for(int i = 0; i < daBricks.length; i++)
      {
         for(int j = 0; j < daBricks[i].length; j++)
         {
            if(!daBricks[i][j].isHit) //if the brick has not already been hit
            {
               int side = rectHit(daBricks[i][j].x, daBricks[i][j].y, daBricks[i][j].w, daBricks[i][j].h);
               if(side != 0) //if the ball has hit a brick
               {
                  daBricks[i][j].hit(); //indicate the brick has been hit
                  if(side == 1 || side == 2) //the ball has hit a brick on the left or right
                  {
                     if(flipSide == 0) //the ball has not hit any other bricks
                     {
                        flipSide = 1; //indicate that we need to change the x direction
                     }
                     else if(flipSide == 2) //the ball has hit another brick on the top or booty
                     {
                        flipSide = 3; //indicate that we need to change x and y directions
                     }
                  }
                  else //the ball has hit a brick on the top or bottom
                  {
                     if(flipSide == 0) //the ball has not hit any other bricks
                     {
                        flipSide = 2; //indicate that we need to change the y direction
                     }
                     else if(flipSide == 1) //the ball has hit another brick on the left or right
                     {
                        flipSide = 3; //indicate that we need to change both x and y directions
                     }
                  }
               }
            }
         }
      }
      if(flipSide == 3 || flipSide == 1) //if we need to change x direction
      {
         vx *= -1;
      }
      if( flipSide == 3 || flipSide == 2) //if we need to change y direction
      {
         vy *= -1;
      }
      return flipSide != 0;
   }
   Boolean hitDaPaddle(Paddle daPaddle)
   {
      int side = rectHit(daPaddle.x, daPaddle.y, daPaddle.w, daPaddle.h);
      if(side == 3 || side == 4) //if the ball has hit the left or right side of the paddle
      {
         int i = int(constrain(map(daPaddle.x - x, 0, -100, -1 * (maxSpeed -1), maxSpeed - 1), -1 * (maxSpeed - 1), maxSpeed - 1));
         vy = abs(maxSpeed - i) * -1;
         vx = i;
      }
      else if(side == 1 || side == 2) //if the ball has hit the top or booty of the paddle
      {
         
      }
      return side != 0;
   }
   Boolean isLost(int screenHeight)
   {
      return (y + vy + r > screenHeight);
   }
   void updateDirection(int screenWidth, int screenHeight, GameState daGame)
   {
      if(x + r >= screenWidth || x - r <= 0)
      {
         vx *= -1;
      }
      if(y + r >= screenHeight || y - r <= 0 + daGame.h)
      {
         vy *= -1;
      }
   }
   int rectHit(float itemX, float itemY, float itemW, float itemH)
   {
      if(
           (x + vx + r >= itemX && x - r < itemX) && //left side hit
           (y + vy >= itemY && y + vy <= itemY + itemH)
        )
      {
         return 1;
      }
      else if(
                (x + vx - r <= itemX + itemW && x + r > itemX + itemW) && //right side hit
                (y + vy >= itemY && y + vy <= itemY + itemH)
             )
      {
         return 2;
      }
      else if(
                (y + vy + r >= itemY && y - r < itemY) &&
                (x + vx >= itemX && x + vx <= itemX + itemW)
             )
      {
         return 3;
      }
      else if(
                (y + vy - r <= itemY + itemH && y + r > itemY + itemH) &&
                (x + vx + r >= itemX && x + vx - r <= itemX + itemW)
             )
      {
         return 4;
      }
      else
      {
         return 0;
      }
   }
}