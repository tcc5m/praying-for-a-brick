class Controller
{
   Boolean[] buttons = new Boolean[5]; //boolean array representing the 4 buttons on the controller
   int xStick; //the value of the direction of the stick (0 = all the way left to 1023 = all the way right)
             //we dont care about up and down (although this may be useful for menus)
   int yStick;
   Controller()
   {
      xStick = 512;
      yStick = 512;
      for(int i = 0; i < 5; i++)
         buttons[i] = false; 
   }
   ArrayList<Integer> update(int[] state)
   {
      updateButtons(state);
      return getPressedButtons();
   }
   ArrayList<Integer> getPressedButtons()
   {
      ArrayList<Integer> pressed = new ArrayList<Integer>();
      for(int i = 0; i < buttons.length; i++)
         if(buttons[i])
            pressed.add(i);
      return pressed;
   }
   void updateButtons(int[] state)
   {
      if(state.length >= 7)
      {
         xStick = state[0];
         yStick = state[1];
         for(int i = 0; i < 4; i++)
            buttons[i] = (state[i + 3] == 0);
         buttons[4] = (state[2] == 0);
      }
   }
}
