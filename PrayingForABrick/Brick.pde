class Brick
{
   float x, y;
   float r, g, b;
   float bR, bG, bB;
   float h, w;
   int hitsLeft;
   int maxHits;
   float[] decrement = new float[3];
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
      maxHits = 0;
      hitsLeft = maxHits;
      setDecrement();
   }
   Brick(float x, float y, float w, float h, int maxHits, float r, float g, float b, float bR, float bG, float bB)
   {
      this.x = x;
      this.y = y;
      this.h = h;
      this.w = w;
      this.maxHits = maxHits;
      this.r = r;
      this.g = g;
      this.b = b;
      this.bR = bR;
      this.bG = bG;
      this.bB = bB;
      hitsLeft = maxHits;
      setDecrement();
   }
   void hit()
   {
      if(--hitsLeft == 0)
      {
         r = bR;
         g = bG;
         b = bB;
         isHit = true;
      }
      else
      {
         r -= decrement[0];
         g -= decrement[1];
         b -= decrement[2];
      }
   }
   void setDecrement()
   {
      decrement[0] = ( (r - bR) - ( (r - bR) / 10) ) / maxHits;
      decrement[1] = ( (g - bG) - ( (g - bG) / 10) ) / maxHits;
      decrement[2] = ( (b - bB) - ( (b - bB) / 10) ) / maxHits;
   }
   void update()
   {
      noStroke();
      fill(r, g, b);
      rect(x, y, w, h);
   }
}
