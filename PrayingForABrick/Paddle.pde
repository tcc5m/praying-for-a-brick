class Paddle
{
   float x, y;
   float r, g, b;
   float h, w;
   Paddle(float x, float y, float w, float h, float r, float g, float b)
   {
      this.x = x;
      this.y = y;
      this.h = h;
      this.w = w;
      this.r = r;
      this.g = g;
      this.b = b;
   }
   void update(int increment, int screenWidth)
   {
      if(x + increment >= 0 && x + increment + w <= screenWidth) //if you're not about to go off the screen
         x += increment;
      else if(x + increment < 0) //if you're about to go off to the left
         x = 0; 
      else //if you're about to go off to the right
         x = screenWidth - w; 
      noStroke();
      fill(r, g, b);
      rect(x, y, w, h);
   }
}
