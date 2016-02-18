class TickerBox extends MenuBox
{
   int value;
   double maxValue;
   double minValue;
   Boolean isSelected = false;
   public TickerBox(String text, int value, double minValue, double maxValue, float x, float y, float w, float h, float r, float g, float b)
   {
      super(text, x, y, w, h, r, g, b);
      this.value = value;
      this.maxValue = maxValue;
      this.minValue = minValue;
   }
   void update()
   {
      if(!isSelected)
      {
         super.update();
      }
      else
      {
         noStroke();
         fill(r, g, b);
         rect(x, y, w, h);
         fill(0);
         textSize(3 * h / 4);
         textAlign(CENTER, CENTER);
         text(value, x + (w / 2), y + (h / 2) );
      }
      fill(0);
      triangle(x + (w / 10), y, x + (w / 10), y + h, x, y + (h / 2) );
      triangle(x + w - (w / 10), y, x + w - (w / 10), y + h, x + w, y + (h / 2) );
   }
}
