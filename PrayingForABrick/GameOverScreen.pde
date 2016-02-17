class GameOverScreen
{
   MenuBox[] menu = new MenuBox[2];
   int selectedItem = 0;
   GameOverScreen(int[][] shades)
   {
      float h = width / 8;
      float w = width / 2;
      float x = width / 2 - w / 2;
      float y = ( (height - (h / menu.length) ) / (menu.length + 1) ) - (h / 2); 
      menu[0] = new MenuBox("New Game", x, y, w, h, shades[2][0], shades[2][1], shades[2][2]);
      y *= 2;
      menu[1] = new MenuBox("Exit", x, y, w, h, shades[2][0], shades[2][1], shades[2][2]);
   }
   void update(int [][] shades)
   {
      menu[selectedItem].r = shades[4][0];
      menu[selectedItem].g = shades[4][1];
      menu[selectedItem].b = shades[4][2];
      menu[selectedItem].update();
      for(int i = 0; i < menu.length; i ++)
      {
         if(i != selectedItem)
         {
            menu[i].r = shades[2][0];
            menu[i].g = shades[2][1];
            menu[i].b = shades[2][2];
            menu[i].update();
         }
      }
   }
}
