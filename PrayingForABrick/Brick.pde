class Brick
{
   float x, y;
   float r, g, b;
   float bR, bG, bB;
   float h, w;
   boolean isHit = false; //determines whether or not the brick has been hit
   Brick()
   {
      x = 0;
      y = 0;
      r = 0;
      g = 0;
      b = 0;
      h = 0; 
      w = 0;
      bR = 0;
      bG = 0;
      bB = 0;
   }
   Brick(float x, float y, float w, float h, float r, float g, float b, float bR, float bG, float bB)
   {
      this.x = x;
      this.y = y;
      this.h = h;
      this.w = w;
      this.r = r;
      this.g = g;
      this.b = b;
      this.bR = bR;
      this.bG = bG;
      this.bB = bB;
   }
   void hit()
   {
      r = bR;
      g = bG;
      b = bB;
      isHit = true;
   }
   void update()
   {
      noStroke();
      fill(r, g, b);
      rect(x, y, w, h);
   }
}