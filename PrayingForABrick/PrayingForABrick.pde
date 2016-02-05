import processing.serial.*;
import java.util.Random;

Serial myPort = getPort();
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

void setup()
{
   size(600, 600); //create a new window
   daGame = new GameState(3, 1, width);
   float h = 16; //height of a brick/paddle
   float w = 50; //width of a brick/.5 width of paddle
   float offset = (width - ( ( (w + 10) * 10) - 10) ) / 2; //amount of space to offset the bricks from the wall
   daPaddle = new Paddle(width / 2 - w, height - h - 18, w * 2, h, 155, 155, 155); //create the paddle using these data points
   daBall = new Ball(daPaddle.x + (daPaddle.w / 2), daPaddle.y - 6); //put the ball atop the paddle
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
   updateAll(); //and call update on all those bitches
}

void updateAll() //updates the states of all parts of our beautiful game
{
   int[] state = getControllerState(); //gets all the buttons from the controller
   if(state.length >= 7) //ensuring we got all 7 inputs
   {
      daController.update(state); //update the controller's state
   }
   daGame.update(); //update the game state
   for(int i = 0; i < daBricks.length; i++) //update brix
   {
      for(int j = 0; j < daBricks[i].length; j++)
      {
         daBricks[i][j].update();
      }
   }
   daPaddle.update(int(getPaddleIncrement() ), width ); //update paddle with an increment dependent upon the controller direction
   daBall.update(width, height, daBricks, daPaddle); //update ball
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
   return map(daController.stick,0, 1023, -5, 5);
}