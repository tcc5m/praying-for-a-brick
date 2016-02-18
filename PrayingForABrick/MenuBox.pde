class MenuBox
{
   float x, y;
   float w, h;
   float r, g, b;
   String text;
   MenuBox(String text, float x, float y, float w, float h, float r, float g, float b)
   {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.r = r;
      this.g = g;
      this.b = b;
      this.text = text;
   }
   MenuBox()
   {
      x = 0;
      y = 0;
      w = 0;
      h = 0;
      r = 0;
      g = 0;
      b = 0;
      text = "";
   }
   void update()
   {
      noStroke();
      fill(r, g, b);
      rect(x, y, w, h);
      fill(0);
      textSize(3 * h / 4);
      textAlign(CENTER, CENTER);
      text(text, x + (w / 2), y + (h / 2) );
   }
}