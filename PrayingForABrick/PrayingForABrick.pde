import processing.serial.*;
import java.util.Random;

Serial myPort = null; 
Brick[][] daBricks = new Brick[7][10];
Paddle daPaddle;
GameState daGame;
Controller daController = new Controller();
Ball daBall;
int[][] colors = {
  {255, 100, 100},
  {255, 127, 100},
  {255, 255, 100},
  {100, 255, 100},
  {100, 100, 255},
  {75, 100, 130},
  {139, 100, 255} 
};

boolean isKB = false; //are we using keyboard?
boolean isMovingLeft = false; //paddle
boolean isMovingRight = false;
boolean isMainUp = false; //main menu selectors
boolean isMainDown = false;
boolean isSelected = false;
boolean navLock = true;

void setup()
{
  
   size(600, 600); //create a new window
   daGame = new GameState(3, 0, width);
   float h = 16; //height of a brick/paddle
   float w = 50; //width of a brick/.5 width of paddle
   float offset = (width - ( ( (w + 10) * 10) - 10) ) / 2; //amount of space to offset the bricks from the wall
   daPaddle = new Paddle(width / 2 - w, height - h - 18, w * 2, h, 155, 155, 155); //create the paddle using these data points
   daBall = new Ball(daPaddle.x + (daPaddle.w / 2), daPaddle.y - 6); //put the ball atop the paddle
   
   PFont font;
   font = createFont("Comic Sans MS", 32);
   textFont(font);
   textAlign(CENTER, CENTER);

   if(!isKB)
      myPort = getPort(); //init myPort if not using keyboard
   
   for(int i = 0; i < daBricks.length; i++) //initializing bricks
   {
      for(int j = 0; j < daBricks[i].length; j++)
      {
         float x = offset + (j * (w + 10) );
         float y = offset + daGame.h + (i * (10 + h) );
         daBricks[i][j] = new Brick(x, y, w, h, colors[i][0], colors[i][1], colors[i][2]); //bricks will be in a rainbow 
      }
   }
}

Serial getPort()
{
   String[] ports = Serial.list();
   return new Serial(this, ports[ports.length - 1], 250000);
}

void draw()
{
   background(50,50,50); //draw the background
   updateAll(); //and call update on all
}

void updateAll() //updates the states of all parts of our beautiful game
{

   int[] state = getControllerState(); //gets all the buttons from the controller

   if(state.length >= 7) //ensuring we got all 7 inputs
   {
      daController.update(state); //update the controller's state
   }

   if(daGame.level == 1){ // if playing game

      daGame.update(); //update the game state
      for(int i = 0; i < daBricks.length; i++) //update brix
      {
         for(int j = 0; j < daBricks[i].length; j++)
         {
            daBricks[i][j].update();
         }
      }
      
      daPaddle.update(int(getPaddleIncrement() ), width ); //update paddle with an increment dependent upon the controller direction
         
      if(isMovingLeft)
         daPaddle.update(-5, width);
      else if(isMovingRight)
         daPaddle.update(5, width);
      else
         daPaddle.update(0, width);

      daBall.update(width, height, daBricks, daPaddle, daGame); //update ball

   }else if(daGame.level == 0){ // on main menu

      //menu navigation with controller
      int pInc = int(getPaddleIncrement());
      println("Increment = ", pInc);

      if(pInc == -5 && !navLock){
         isMainUp = true;
         navLock = true; // can only navigate ONCE without returning to 0 first
      } 
      else if(pInc == 5 && !navLock){
         isMainDown = true;
         navLock = true;
      } 
      else if(pInc == 0) {
         isMainUp = false;
         isMainDown = false;
         navLock = false;
      }

      //menu selection with controller
      if(daController.buttons[0] == true) isSelected = true;
      else isSelected = false; 

      if (isMainUp) daGame.drawMainMenu(1, isSelected); //selector up
      else if (isMainDown) daGame.drawMainMenu(-1, isSelected); //selector down
      else daGame.drawMainMenu(0, isSelected); //draw, but don't move selection

      //after one navigation, lock navigation until analog is centered
      isMainUp = false;
      isMainDown = false;

      println("navLock = ", navLock);
   //level 2 is options menu, pressing button 0 goes back to main menu
   }else if(daGame.level == 2){ //options menu

      if(daController.buttons[1] == false){
         daGame.drawOptions(false);
      }
      else{
         daGame.drawOptions(true);
      }
   }
}

int[] getControllerState() //returns an array containing all of the information from the controller
{
   int[] state = new int[0];
   if ( myPort.available() > 0) 
   { 
      String input = myPort.readStringUntil('\n'); 
      if(input != null)
      {
         state = int(split(input, ',') ); //split the string into ints
      }
   }
   return state;
}
float getPaddleIncrement()
{
   return map(daController.stick,0, 1023, -5, 5); //converts from raw stick range to more managable increments
}

// keyboard input control
void keyPressed(){
   switch(key){
      case 'a':
         isMovingLeft = true;
         isMainUp = true;
         break;
      case 'd':
         isMovingRight = true;
         isMainDown = true;
         break;
      case 'y':
         daController.buttons[0] = true;
         isSelected = true;
         break;
      case 'u':
         daController.buttons[1] = true;
         break;
      case 'i':
         daController.buttons[2] = true;
         break;
      case 'o':
         daController.buttons[3] = true;
         break;
      // case 'p':
      //    daController.buttons[4] = true;
      //    break;
   }
}

//may need
void keyReleased(){
      switch(key){
      case 'a':
         isMovingLeft = false;
         isMainUp = false;
         break;
      case 'd':
         isMovingRight = false;
         isMainDown = false;
         break;
      case 'y':
         daController.buttons[0] = false;
         isSelected = false;
         break;
      case 'u':
         daController.buttons[1] = false;
         break;
      case 'i':
         daController.buttons[2] = false;
         break;
      case 'o':
         daController.buttons[3] = false;
         break;
      // case 'p':
      //    daController.buttons[4] = false;
      //    break;
      }
   }