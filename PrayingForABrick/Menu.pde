class Menu
{
   TickerBox[] optionsMenu = new TickerBox[4];
   MenuBox optionsBack;
   MenuBox[] mainMenu = new MenuBox[3];
   int selectedItem = 0;
   Boolean isOptions = false;
   Boolean isIncremented = false;
   Menu(int startLevel, int startLives, int streakReward, int maxSpeed, int[] colors)
   {
      float h = height / 8;
      float w = width / 2;
      float x = width / 2 - w / 2;
      setupOptionsMenu(x, w, h, startLevel, startLives, streakReward, maxSpeed, colors);
      setupMainMenu(x, w, h, colors);
   }
   void setupOptionsMenu(float x, float w, float h, int startLevel, int startLives, int streakReward, int maxSpeed, int[] colors)
   {
      //float y = height / ((optionsMenu.length + 2) * h + (optionsMenu.length + 3) * (h / 2)) + (h / 2);
      float dy = height / (optionsMenu.length + 1);
      float y = (dy - h) / 2;
      optionsMenu[0] = new TickerBox("Level", startLevel, 1, 100, x, y, w, h, colors[0], colors[1], colors[2]);
      y += dy;
      optionsMenu[1] = new TickerBox("Lives", startLives, 0, 100, x, y, w, h, colors[0], colors[1], colors[2]);
      y += dy;
      optionsMenu[2] = new TickerBox("Reward", streakReward, 1, 10, x, y, w, h, colors[0], colors[1], colors[2]);
      y += dy;
      optionsMenu[3] = new TickerBox("Speed", maxSpeed, 4, 16, x, y, w, h, colors[0], colors[1], colors[2]);
      y += dy;
      optionsBack = new MenuBox("Back", x, y, w, h, colors[0], colors[1], colors[2]);
   }
   void setupMainMenu(float x, float w, float h, int[] colors)
   {
      float dy = height / mainMenu.length;
      float y = (dy - h) / 2;
      mainMenu[0] = new MenuBox("New Game", x, y, w, h, colors[0], colors[1], colors[2]);
      y += dy;
      mainMenu[1] = new MenuBox("Options", x, y, w, h, colors[0], colors[1], colors[2]);
      y += dy;
      mainMenu[2] = new MenuBox("Exit", x, y, w, h, colors[0], colors[1], colors[2]);
   }
   void drawGameOver(int[] colors)
   {
      background(0);
      textAlign(CENTER, CENTER);
      textSize(48);
      fill(colors[0], colors[1], colors[2]);
      text("GAME OVER", width / 2, height / 2);
      delay(1500);
   }
   void drawMenu(int[][] colors)
   {
      if(isOptions)
         drawOptions(colors);
      else
        drawMainMenu(colors);
   }
   void drawMainMenu(int[][] colors)
   {
      for(int i = 0; i < mainMenu.length; i++)
      {
         int colorIndex = (int) map(i, 0, mainMenu.length - 1, 0, colors.length - 1);
         mainMenu[i].r = colors[colorIndex][0];
         mainMenu[i].g = colors[colorIndex][1];
         mainMenu[i].b = colors[colorIndex][2];
         mainMenu[i].update();
      }
      int colorIndex = (int) map(selectedItem, 0, mainMenu.length - 1, 0, colors.length - 1);
      mainMenu[selectedItem].r = colors[colorIndex][0] + (3 * colors[colorIndex][0] / 4);
      mainMenu[selectedItem].g = colors[colorIndex][1] + (3 * colors[colorIndex][1] / 4);
      mainMenu[selectedItem].b = colors[colorIndex][2] + (3 * colors[colorIndex][2] / 4);
      mainMenu[selectedItem].update();
   }
   void drawOptions(int[][] colors)
   {
      for(int i = 0; i < optionsMenu.length; i++)
      {
         int colorIndex = (int) map(i, 0, optionsMenu.length, 0, colors.length - 1);
         optionsMenu[i].r = colors[colorIndex][0];
         optionsMenu[i].g = colors[colorIndex][1];
         optionsMenu[i].b = colors[colorIndex][2];
         optionsMenu[i].isSelected = false;
         optionsMenu[i].update();
      }
      if(selectedItem == optionsMenu.length)
      {
         int colorIndex = (int) map(selectedItem, 0, optionsMenu.length, 0, colors.length - 1);
         optionsBack.r = colors[colorIndex][0] + (3 * colors[colorIndex][0] / 4);
         optionsBack.g = colors[colorIndex][1] + (3 * colors[colorIndex][1] / 4);
         optionsBack.b = colors[colorIndex][2] + (3 * colors[colorIndex][2] / 4);
         optionsBack.update();
      }
      else
      {
         int colorIndex = (int) map(selectedItem, 0, optionsMenu.length, 0, colors.length - 1);
         optionsMenu[selectedItem].r = colors[colorIndex][0] + (3 * colors[colorIndex][0] / 4);
         optionsMenu[selectedItem].g = colors[colorIndex][1] + (3 * colors[colorIndex][1] / 4);
         optionsMenu[selectedItem].b = colors[colorIndex][2] + (3 * colors[colorIndex][2] / 4);
         optionsMenu[selectedItem].isSelected = true;
         optionsMenu[selectedItem].update();
         optionsBack.r = colors[colors.length - 1][0];
         optionsBack.g = colors[colors.length - 1][1];
         optionsBack.b = colors[colors.length - 1][2];
         optionsBack.update();
      }
   }
   String getSelectedText()
   {
      if(isOptions)
      {
         if(selectedItem == optionsMenu.length)
           return optionsBack.text;
         else
           return optionsMenu[selectedItem].text;
      }
      else
         return mainMenu[selectedItem].text;
   }
}
