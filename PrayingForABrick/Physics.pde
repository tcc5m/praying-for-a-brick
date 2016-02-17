import java.awt.geom.Ellipse2D;
class Physics
{
   Boolean didBallHitLeft(float ballX, float ballY, float ballR, float rectX, float rectY, float rectH)
   {
      return 
      (
           (ballX + ballR >= rectX && ballX - ballR < rectX) && //left side hit
           (ballY >= rectY && ballY <= rectY + rectH)
      );
   }
   Boolean didBallHitRight(float ballX, float ballY, float ballR, float rectX, float rectY, float rectW, float rectH)g
   {
      return (
                (ballX - ballR <= rectX + rectW && ballX + ballR > rectX + rectW) && //right side hit
                (ballY >= rectY && ballY <= rectY + rectH)
             );
   }
   Boolean didBallHitTop(float ballX, float ballY, float ballR, float rectX, float rectY, float rectW)
   {
      return (
                (ballY + ballR >= rectY && ballY - ballR < rectY) && //top hit
                (ballX >= rectX && ballX <= rectX + rectW)
             );
   }
   Boolean didBallHitBottom(float ballX, float ballY, float ballR, float rectX, float rectY, float rectW, float rectH)
   {
      return (
                (ballY - ballR <= rectY + rectH && ballY + ballR > rectY + rectH) && //booty hit
                (ballX + ballR >= rectX && ballX - ballR <= rectX + rectW)
             );
   }
   int getHitSide(Ball ball, Paddle paddle)
   {
      return getHitSide(ball.x + ball.vx, ball.y + ball.vy, ball.r, paddle.x, paddle.y, paddle.w, paddle.h);
   }
   int getHitSide(Ball ball, Brick brick)
   {
      return getHitSide(ball.x + ball.vx, ball.y + ball.vy, ball.r, brick.x, brick.y, brick.w, brick.h);
   }
   int getHitSide(float ballX, float ballY, float ballR, float rectX, float rectY, float rectW, float rectH)
   {
      Boolean left = didBallHitLeft(ballX, ballY, ballR, rectX, rectY, rectH);
      Boolean right = didBallHitRight(ballX, ballY, ballR, rectX, rectY, rectW, rectH);
      Boolean top = didBallHitTop(ballX, ballY, ballR, rectX, rectY, rectW);
      Boolean bottom = didBallHitBottom(ballX, ballY, ballR, rectX, rectY, rectW, rectH);
      if(left && top)
         return getSideMoreHit(ballX, ballY, ballR, rectX, rectY, rectW, rectH, 1, 3);
      else if(left && bottom)
         return getSideMoreHit(ballX, ballY, ballR, rectX, rectY, rectW, rectH, 1, 4);
      else if(right && top)
         return getSideMoreHit(ballX, ballY, ballR, rectX, rectY, rectW, rectH, 2, 3);
      else if(right && bottom)
         return getSideMoreHit(ballX, ballY, ballR, rectX, rectY, rectW, rectH, 2, 4);
      else if(left)
         return 1;
      else if(right)
         return 2;
      else if(top)
         return 3;
      else if(bottom)
         return 4;
      else
         return -1;
   }
   int getSideMoreHit(float ballX, float ballY, float ballR, float rectX, float rectY, float rectW, float rectH, int side1, int side2)
   {
      float sideOneOverlap = getIntersectionDifference(ballX, ballY, ballR, rectX, rectY, rectW, rectH, side1);
      float sideTwoOverlap = getIntersectionDifference(ballX, ballY, ballR, rectX, rectY, rectW, rectH, side2);
      if(sideOneOverlap > sideTwoOverlap)
         return side1;
      else if(sideTwoOverlap > sideOneOverlap)
         return side2;
      else
        return 0;
   }
   float getIntersectionDifference(float ballX, float ballY, float ballR, float rectX, float rectY, float rectW, float rectH, int side)
   {
      switch(side)
      {
         case 1: //left
            return (ballX + ballR) - rectX;
         case 2: //right
            return (rectX + rectH) - (ballX - ballR);
         case 3: //top
            return (ballY + ballR) - rectY;
         case 4: //bottom
            return (rectY + rectH) - (ballY - ballR);
      }
      return 0;
   }
}
