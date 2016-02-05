class Controller
{
   Boolean[] buttons = new Boolean[4];
   int stick;
   Controller()
   {
      stick = 512;
      for(int i = 0; i < 4; i++)
      {
         buttons[i] = false; 
      }
   }
   void update(int[] state)
   {
      stick = state[0];
      for(int i = 0; i < 4; i++)
      {
         if(state[i + 3] == 1)
         {
            buttons[i] = false;
         }
         else
         {
            buttons[i] = true; 
         }
      }
   }
}