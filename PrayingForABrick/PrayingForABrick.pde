import processing.serial.*;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;
import java.util.Vector;

//brick settings
int[][] colors = {
  {255, 100, 100},
  {255, 127, 100},
  {255, 255, 100},
  {100, 255, 100},
  {100, 100, 255},
  {75, 100, 130},
  {139, 100, 255} 
};
int[][] shades = {
  {0, 0, 0},
  {50, 50, 50},
  {150, 150, 150},
  {225, 225, 225},
  {255, 255, 255}
};
float brickH = 16; //height of a brick/paddle
float brickW; //width of a brick/.5 width of paddle
float brickSpacing = 10;
int brickCols = 10;
int brickRows = colors.length;


//ball settings
float ballRadius;
int maxSpeed = 6;

//game settings
int startLives = 3;
int startLevel = 1;

//powerup settings
int[] powerUpLength = {-1, 10000, 10000, 10000};
int streakReward = 4;



Boolean isGameOver = false;
Serial myPort = getPort();
Brick[][] daBricks;
Paddle daPaddle;
GameState daGame;
Controller daController = new Controller();
Vector<PowerUp> daPowerUps = new Vector<PowerUp>();
Ball daBall;
Menu menu;



void setup()
{
   size(800 ,800); //create a new window
   ballRadius = min(width, height) / 100;
   brickW = (width - ( (brickCols + 1) * brickSpacing) ) / brickCols; 
   daGame = new GameState(startLives, 0, width, colors);
   menu = new Menu(startLevel, startLives, streakReward, maxSpeed, shades[2]);
}

void setupGame()
{
   daBricks = setupBricks(brickRows, brickCols);
   daPaddle = new Paddle( (width / 2) - brickW, height - brickH - (3 * ballRadius), brickW * 2, brickH, 155, 155, 155); //create the paddle using these data points
   daBall = new Ball(daPaddle.x + (daPaddle.w / 2), daPaddle.y - ballRadius, ballRadius, maxSpeed); //put the ball atop the paddle
}

Serial getPort()
{
   String[] ports = Serial.list();
   return new Serial(this, ports[ports.length - 1], 250000);
}

void draw()
{
   background(shades[1][0], shades[1][1], shades[1][1]); //draw the background
   if(daGame.level == 0)
      updateMenu();
   else if(!isGameOver) //if the player has not lost the game
      mainGame(); //and call update on all those bitches
   else
      gameOverYeah();
}
void updateMenu()
{
   ArrayList<Integer> pressedButtons = daController.update(getControllerState()); //update the controller's state
   int yIncrement = (int) map(daController.yStick, 1023, 0, -1, 1);
   int xIncrement = (int) map(daController.xStick, 0, 1023, -1, 1);
   if(menu.isOptions)
   {
      menu.selectedItem = (int) constrain(menu.selectedItem + yIncrement, 0, menu.optionsMenu.length);
      String selection = menu.getSelectedText();
      if(pressedButtons.indexOf(2) != -1 && selection == "Back")
      {
         menu.isOptions = false;
         menu.selectedItem = 0;
      }
      else if(selection != "Back")
      {
         int newValue = (int) constrain(menu.optionsMenu[menu.selectedItem].value + xIncrement,
                                        (float) menu.optionsMenu[menu.selectedItem].minValue,
                                        (float) menu.optionsMenu[menu.selectedItem].maxValue);
         menu.optionsMenu[menu.selectedItem].value = newValue;
         if(selection == "Level")
            startLevel = newValue;
         else if(selection == "Lives")
            startLives = newValue;
         else if(selection == "Speed")
            maxSpeed = newValue;
         else if(selection == "Reward")
            streakReward = newValue;
      }
   }
   else
   {
      menu.selectedItem = (int) constrain(menu.selectedItem + yIncrement, 0, menu.mainMenu.length - 1);
      String selection = menu.getSelectedText();
      if(pressedButtons.indexOf(2) != -1)
      {
         if(selection == "Exit")
            System.exit(0);
         else if(selection == "New Game")
         {
            isGameOver = false;
            setupGame();
            reset(true, true, true);
         }
         else if(selection == "Options")
         {
            menu.isOptions = true;
            menu.selectedItem = 0;
         }
      }
   }
   menu.drawMenu(colors);
   if(yIncrement != 0 || (xIncrement != 0 && menu.isOptions))
     delay(100);
     
}

void mainGame() //updates the states of all parts of our beautiful game
{
   if(daGame.numBricks == daGame.hitBricks && daGame.numBricks != 0)
   {
     daGame.levelUp();
     reset(false, true, false);
   }
   triggerPowerUps(daController.update(getControllerState() ) ); //update the controller's state
   daGame.update(daController.getHeldButtons(), colors, shades, streakReward);
   updateBricks();
   updatePowerUps();
   daPaddle.update(int(getPaddleIncrement() ), width ); //update paddle with an increment dependent upon the controller direction
   if(daBall.update(width, height, colors, shades, daBricks, daPaddle, daGame) ) //update ball; returns true if life is lost
   {
      if(daGame.lives == 0) //if the player has nothing left to lose
         isGameOver = true; //the game is over
      else
      {
         daGame.loseLife();
         reset(false, false, true);
      }
   }
}
void gameOverYeah()
{
  isGameOver = false;
  daGame.level = 0;
}
int[] getControllerState() //returns an array containing all of the information from the controller
{
   int[] state = new int[0];
   if ( myPort.available() > 0) 
   { 
      String input = myPort.readStringUntil('\n'); 
      if(input != null)
         state = int(split(input, ',') ); //split the string into ints
   }
   return state;
}
float getPaddleIncrement()
{
   return map(daController.xStick,0, 1023, -1 * maxSpeed, maxSpeed);
}
void reset(Boolean doResetGameState, Boolean doResetBricks, Boolean doResetPowerUps)
{
   if(doResetPowerUps)
      daPowerUps.clear();
   daPaddle.x = (width / 2) - brickW;
   daPaddle.y = (height - brickH - (3 * ballRadius) );
   daPaddle.h = brickH;
   daPaddle.w = brickW * 2;
   daBall.x = daPaddle.x + (daPaddle.w / 2);
   daBall.y = daPaddle.y - ballRadius;
   daBall.vy = -8;
   daBall.vx = 0;
   daBall.isCaught = true;
   daBall.isInvincible = false;
   daBall.doCatch = false;
   for(int i = 0; i < daGame.powerUps.length; i++)
   {
      if(daGame.powerUps[i] == 0);
         daGame.powerUps[i] = -1;
   }
   if(doResetGameState)
   {
      daGame.lives = startLives;
      daGame.streak = 0;
      daGame.level = startLevel;
      daGame.powerUpType = 0;
      daGame.score = 0;
      for(int i = 1; i < daGame.powerUps.length; i++)
         daGame.powerUps[i] = -1;
   }
   daGame.powerUps[0] = 0;
   if(doResetBricks)
   {
      daBall.maxSpeed = maxSpeed;
      daGame.numBricks = 0;
      daGame.hitBricks = 0;
      daGame.multiplier = ( (daGame.level - 1) / colors.length) + 1;
      for(int i = 0; i < daBricks.length && i <= (daGame.level - 1) % 7; i++)
      {
         for(int j = 0; j < daBricks[i].length; j++)
         {
            daGame.numBricks++;
            daBricks[i][j].r = colors[i][0];
            daBricks[i][j].g = colors[i][1];
            daBricks[i][j].b = colors[i][2];
            daBricks[i][j].isHit = false;
            daBricks[i][j].maxHits = daGame.multiplier;
            daBricks[i][j].hitsLeft = daGame.multiplier;
            daBricks[i][j].setDecrement();
         }
      }
      for(int i = ( (daGame.level - 1) % 7) + 1; i < daBricks.length; i++)
      {
         for(int j = 0; j < daBricks[i].length; j++)
         {
            daBricks[i][j].r = 50;
            daBricks[i][j].g = 50;
            daBricks[i][j].b = 50;
            daBricks[i][j].isHit = true;
            daBricks[i][j].setDecrement();
         }
      }
   }
}
void triggerPowerUps(ArrayList<Integer> pressedButtons)
{
   for(int i : pressedButtons)
   {
      Timer timer = new Timer();
      if(i == 0 || i == 4 || daGame.powerUps[i] == 1)
      {
         switch(i)
         {
            case 0:
               if(daBall.isCaught)
               {
                 daBall.isCaught = false;
                 daBall.vy = maxSpeed * -1;
                 daBall.vx = 0;
                 daGame.powerUps[0] = -1;
               }
               else if(!daBall.doCatch && daGame.powerUps[i] == 1)
               {
                  daBall.doCatch = true;
                  daGame.powerUps[i] = 0;
               }
               break;
            case 1:
               daGame.powerUps[i] = 0;
               daPaddle.x = constrain(daPaddle.x - brickW, 0, width);
               daPaddle.w = daPaddle.w * 2;
               timer.schedule(new TimerTask()
               {
                  @Override
                  public void run()
                  {
                     daPaddle.x = constrain(daPaddle.x + brickW, 0, width);
                     daPaddle.w = brickW * 2;
                     daGame.powerUps[1] = -1;
                  }
               }, powerUpLength[1]);
               break;
            case 2:
               daGame.powerUps[i] = 0;
               daBall.vx /= 2;
               daBall.vy /= 2;
               daBall.maxSpeed /= 2;
               timer.schedule(new TimerTask()
               {
                  @Override
                  public void run()
                  {
                     daBall.vx *= 2;
                     daBall.vy *= 2;
                     daBall.maxSpeed *= 2;
                     daGame.powerUps[2] = -1;
                  }
               }, powerUpLength[2]);
               break;
            case 3:
               daGame.powerUps[i] = 0;
               daBall.isInvincible = true;
               timer.schedule(new TimerTask()
               {
                  @Override
                  public void run()
                  {
                     daBall.isInvincible = false;
                     daGame.powerUps[3] = -1;
                  }
               }, powerUpLength[3]);
               break;
            case 4:
               daPaddle.x = (width / 2) - (daPaddle.w / 2);
               break;
         }
      }
   }
}
void updatePowerUps()
{
   if (daGame.streak >= streakReward) //if the player deserves a reward for their streak
   {
      Random r = new Random();
      int x = r.nextInt( (int) (width - (4 * ballRadius) ) );
      x += 2 * ballRadius;
      daPowerUps.add(new PowerUp(x, (daBricks[(daGame.level - 1) % daBricks.length][0].y) + (brickH * 2), 2, ballRadius * 2, daGame.powerUpType++ % daGame.powerUps.length) );
      daGame.streak -= streakReward;
   }
   for(int i = 0; i < daPowerUps.size(); i++)
   {
      if(daPowerUps.elementAt(i).y - daPowerUps.elementAt(i).r >= height)
         daPowerUps.remove(i);
      else if(daPowerUps.elementAt(i).update(daPaddle, daGame, colors) )
         daGame.powerUps[daPowerUps.elementAt(i).type] = 1;
   }
}
void updateBricks()
{
   for(int i = 0; i < daBricks.length; i++) //update brix
      for(int j = 0; j < daBricks[i].length; j++)
         daBricks[i][j].update();
}
Brick[][] setupBricks(int rows, int cols)
{
   Brick[][] theseBricks = new Brick[rows][cols];
   float offset = (width - ( ( (brickW + brickSpacing) * cols) - brickSpacing) ) / 2; //amount of space to offset the bricks from the wall
   for(int i = 0; i < rows && i <= (daGame.level - 1) % 7; i++)
   {
      for(int j = 0; j < cols; j++)
      {
         daGame.numBricks++;
         float x = offset + (j * (brickW + brickSpacing) );
         float y = brickSpacing + daGame.h + (i * (brickSpacing + brickH) );
         theseBricks[i][j] = new Brick(x, y, brickW, brickH, daGame.multiplier, colors[i][0], colors[i][1], colors[i][2], shades[1][0], shades[1][1], shades[1][2]);
      }
   }
   for(int i = ( (daGame.level - 1) % 7) + 1; i < rows; i++)
   {
      for(int j = 0; j < cols; j++)
      {
         float x = offset + (j * (brickW + brickSpacing) );
         float y = brickSpacing + daGame.h + (i * (brickSpacing + brickH) );
         theseBricks[i][j] = new Brick(x, y, brickW, brickH, daGame.multiplier, shades[1][0], shades[1][1], shades[1][2], shades[1][0], shades[1][1], shades[1][2]);
         theseBricks[i][j].isHit = true;
      }
   }
   return theseBricks;
}
