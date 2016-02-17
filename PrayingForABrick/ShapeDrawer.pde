class ShapeDrawer
{
   void drawInvincibility(float x, float y, float r, int[] colors)
   {
      noStroke();
      fill(colors[0], colors[1], colors[2]);
      drawStar(x, y, (3 * r) / 4, r / 3, 5);
   }
   void drawCatchBall(float x, float y, float r, int[] colors)
   {
      noStroke();
      fill(colors[0], colors[1], colors[2]);
      rect(x - (r / 2), y - (r / 8), r, r / 4);
      ellipse(x, y - (r / 8), r / 4, r / 4);
   }
   void drawWidePaddle(float x, float y, float r, int[] colors)
   {
      noStroke();
      fill(colors[0], colors[1], colors[2]);
      rect(x - (r / 2), y - (r / 8), r, r / 4);
      triangle(x - ( (7 * r) / 8), y, x - (r / 2), y - ( (5 * r) / 8), x - (r / 2), y + ( (5 * r) / 8) );
      triangle(x + ( (7 * r) / 8), y, x + (r / 2), y - ( (5 * r) / 8), x + (r / 2), y + ( (5 * r) / 8) );
   }
   void drawSlowBall(float x, float y, float r, int[] colors, int[] bgColors)
   {
      noStroke();
      fill(colors[0], colors[1], colors[2]);
      y += r / 4;
      triangle(x, y + (r / 3), x + ( (3 * r) / 4), y - ( (3 * r) / 4), x - ( (3 * r) / 4), y - ( (3 * r) / 4));
      fill(bgColors[0], bgColors[1], bgColors[2]);
      triangle(x, y + (r / 4), x + ( (5 * r) / 8), y - ( (5 * r) / 8), x - ( ( 5 * r) / 8), y - ( (5 * r) / 8) );
   }
   void drawStar(float x, float y, float radius1, float radius2, int npoints) 
   {
      float angle = TWO_PI / npoints;
      float halfAngle = angle/2.0;
      beginShape();
      for (float a = 0; a < TWO_PI; a += angle) 
      {
         float sx = x + cos(a) * radius2;
         float sy = y + sin(a) * radius2;
         vertex(sx, sy);
         sx = x + cos(a+halfAngle) * radius1;
         sy = y + sin(a+halfAngle) * radius1;
         vertex(sx, sy);
      }
      endShape(CLOSE);
   }
   void drawType(float x, float y, float r, int type, int[] colors, int[] bgColors)
   {
      noStroke();
      fill(colors[0], colors[1], colors[2]);
      switch(type)
      {
         case 0: //catch ball
            drawCatchBall(x, y, r, colors);
            break;
         case 1: //wide paddle
            drawWidePaddle(x, y, r, colors);
            break;
         case 2: //slow ball
            drawSlowBall(x, y, r, colors, bgColors);
            break;
         case 3: //invincible
            drawInvincibility(x, y, r, colors);
            break;
      }
   }
}
