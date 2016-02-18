class GameState
{
   int[] powerUps = new int[4];
   int score = 0;
   int streak = 0;
   int powerUpType = 0;
   int lives;
   int level;
   int h;
   int w;
   int multiplier;
   int numBricks = 0;
   int hitBricks = 0;
   GameState()
   {
      for(int i = 0; i < 4; i++)
         powerUps[i] = -1; 
      lives = 3;
      level = 1;
      multiplier = ( (level - 1) / 7) + 1;
      h = height / 6;
      w = width;
   }
   GameState(int lives, int level, int screenWidth, int[][] colors)
   {
      for(int i = 0; i < 4; i++)
         powerUps[i] = -1; 
      powerUps[0] = 0;
      this.lives = lives;
      this.level = level;
      multiplier = ( (level - 1) / colors.length) + 1;
      h = height / 6;
      w = screenWidth;
   }
   void drawBackground(int[][] shades)
   {
      noStroke();
      fill(shades[3][0], shades[3][0], shades[3][0]);
      rect(0, 0, w, h);
   }
   void drawButtons(ArrayList<Integer> pressedButtons, int[][] colors, int[][] shades)
   {
      noStroke();
      fill(150, 150, 150);
      rect(width - h, 0, h, h);
      for(int i = 0; i < 4; i++)
         drawButton(i, (pressedButtons.indexOf(i) != -1), colors, shades);
   }
   void drawButton(int button, Boolean isButtonPressed, int[][] colors, int[][] shades)
   {
      int x = -100, y = -100, r = 0;
      int[] bgFill = shades[2];
      int[] fill = shades[0];
      ShapeDrawer s = new ShapeDrawer();
      if(isButtonPressed)
      {
         noStroke();
         fill(colors[0][0], colors[0][1], colors[0][2]);
         bgFill = colors[0];
      }
      else if(powerUps[button] == 1)
      {
         noStroke();
         fill(colors[3][0], colors[3][1], colors[3][2]);
         bgFill = colors[3];
      }
      else if(powerUps[button] == 0)
      {
         noStroke();
         fill(colors[6][0], colors[6][1], colors[6][2]);
         bgFill = colors[6];
      }
      else
      {
         stroke(0);
         noFill();
         bgFill = shades[2];
      }
      r = h / 10;
      switch(button)
      {
         case 0:
            x = w - (h / 4);
            y = h / 2;
            break;
         case 1:
            x = w - (h / 2);
            y = h / 4;
            break;
         case 2:
            x = w - (h / 2);
            y = 3 * (h / 4);
            break;
         case 3:
            x = w - ( (3 * h) / 4);
            y = h / 2;
            break;
      }
      ellipse(x, y, r * 2, r * 2);
      s.drawType(x, y, r, button, fill, bgFill);
   }
   void star(float x, float y, float radius1, float radius2, int npoints) 
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
   void drawLives(int[][] shades)
   {
      int spacing = h / 4;
      int size = h / 8;
      noStroke();
      fill(shades[2][0], shades[2][1], shades[2][2]);
      rect(0, 0, h, h);
      int offset = (h - ( (2 * spacing) + (size / 2) ) ) / 2;
      if(lives > 9)
      {
         textSize(32);
         fill(shades[0][0], shades[0][1], shades[0][2]);
         textAlign(LEFT, CENTER);
         text(lives, offset + 10, h / 2 - 4);
         ellipse(offset, h / 2, size * 2, size * 2);
      }
      else
      {
         for(int i = 0; i < (lives + 2) / 3; i++)
         {
            for(int j = 0; j < lives - (i * 3) && j < 3; j++)
            {
               fill(0);
               ellipse(offset + j * spacing, offset + i * spacing, size, size);
            }
         }
      }
   }
   void drawTopUi(int[][] shades, int streakReward)
   {
      textSize(48);
      fill(shades[0][0], shades[0][1], shades[0][2]);
      textAlign(CENTER, TOP);
      text(romanize(level), w / 2, 0);
      textSize(18);
      text("Level", w / 2, h / 2);
      textSize(24);
      textAlign(LEFT, BOTTOM);
      text(score, 17 * h / 16, 15 * h / 16);
      textSize(12);
      text("Score", 17 * h / 16, 11 * h / 16);
      textAlign(RIGHT, BOTTOM);
      textSize(24);
      text(streakReward - streak, width - (17 * h / 16), 15 * h / 16);
      textSize(12);
      text("Reward", width - (17 * h / 16), 11 * h / 16); 
   }
   void update(ArrayList<Integer> pressedButtons, int[][] colors, int[][] shades, int streakReward)
   {
      drawBackground(shades);
      drawLives(shades);
      drawButtons(pressedButtons, colors, shades);
      drawTopUi(shades, streakReward);
   }
   void loseLife()
   {
      lives--;
      streak = 0;
   }
   void levelUp()
   {
      level++;
      lives++;
      streak = 0;
      multiplier = ( (level - 1) / 7) + 1;
   }
   String romanize(int i)
   {
      if(i >= 1000)
         return "M" + romanize(i - 1000); 
      else if(i >= 900)
         return "CM" + romanize(i - 900);
      else if(i >= 500)
         return "D" + romanize(i - 500);
      else if(i >= 400)
         return "CD" + romanize(i - 400);
      else if(i >= 100)
         return "C" + romanize(i - 100);
      else if(i >= 90)
         return "XC" + romanize(i - 90);
      else if(i >= 50)
         return "L" + romanize(i - 50);
      else if(i >= 40)
         return "XL" + romanize(i - 40);
      else if(i >= 10)
         return "X" + romanize(i - 10);
      else if(i >= 9)
         return "IX" + romanize(i - 9);
      else if(i >= 5)
         return "V" + romanize(i - 5);
      else if(i >= 4)
         return "IV" + romanize(i - 4);
      else if(i >= 1)
         return "I" + romanize(i - 1);
      else if(i == 0)
         return "";
      else
         return "-" + romanize(i * -1); 
   }
}
