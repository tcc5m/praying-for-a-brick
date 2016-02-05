class Brick
{
   float x, y;
   float r, g, b;
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
   }
   Brick(float x, float y, float w, float h, float r, float g, float b)
   {
      this.x = x;
      this.y = y;
      this.h = h;
      this.w = w;
      this.r = r;
      this.g = g;
      this.b = b;
   }
   void hit()
   {
      r = 50;
      g = 50;
      b = 50;
      isHit = true;
   }
   void update()
   {
      noStroke();
      fill(r, g, b);
      rect(x, y, w, h);
   }
}