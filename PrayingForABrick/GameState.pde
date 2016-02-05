class GameState
{
   Boolean[] powerUps = new Boolean[4];
   int score;
   int streak;
   int lives;
   int level;
   int h;
   int w;
   GameState()
   {
      for(int i = 0; i < 4; i++)
      {
         powerUps[i] = false; 
      }
      lives = 3;
      level = 1;
      h = 100;
      w = 600;
   }
   GameState(int lives, int level, int screenWidth)
   {
      for(int i = 0; i < 4; i++)
      {
         powerUps[i] = false; 
      }
      powerUps[0] = true;
      this.lives = lives;
      this.level = level;
      h = 100;
      w = screenWidth;
   }
   void drawBackground()
   {
      noStroke();
      fill(225, 225, 225);
      rect(0, 0, w, h);
   }
   void drawButtons(int[][] colors)
   {
      noStroke();
      fill(150, 150, 150);
      rect(600 - h, 0, h, h);
      for(int i = 0; i < 4; i++)
      {
         drawButton(colors, i);
      }
   }
   void drawButton(int[][] colors, int i)
   {
      if(daController.buttons[i])
      {
         powerUps[i] = false;
         noStroke();
         fill(colors[0][0], colors[0][1], colors[0][2]); 
      }
      else if(powerUps[i])
      {
         noStroke();
         fill(colors[3][0], colors[3][1], colors[3][2]); 
      }
      else
      {
         stroke(0);
         noFill(); 
      }
      switch(i)
      {
         case 0:
            ellipse(600 - h / 4, h / 2, 20, 20);
            break;
         case 1:
            ellipse(600 - h / 2, h / 4, 20, 20);
            break;
         case 2:
            ellipse(600 - h / 2, 3 * (h / 4), 20, 20);
            break;
         case 3:
            ellipse(600 - 3 * h / 4, h / 2, 20, 20);
            break;
      }
   }
   void drawLives()
   {
      int spacing = 30;
      int size = 15;
      noStroke();
      fill(150, 150, 150);
      rect(0, 0, h, h);
      int offset = (h - ( (2 * spacing) + (size / 2) ) ) / 2;
      if(lives > 9)
      {
         textSize(32);
         fill(0);
         textAlign(LEFT, CENTER);
         text(lives, offset + 10, h / 2 - 4);
         ellipse(offset, h / 2, size * 2, size * 2);
      }
      else
      {
         for(int i = 0; i < (lives + 1) / 3; i++)
         {
            for(int j = 0; j < lives - i * 3 && j < 3; j++)
            {
               fill(0);
               ellipse(offset + j * spacing, offset + i * spacing, size, size);
            }
         }
      }
   }
   void update()
   {
      drawBackground();
      drawButtons(colors);
      drawLives();
   }
}