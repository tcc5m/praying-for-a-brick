import java.awt.geom.Ellipse2D;
import java.awt.Graphics;

class PowerUp
{
   float x;
   float y;
   float vy;
   float r;
   int type;
   PowerUp(float x, float y, float vy, float r, int type)
   {
      this.x = x;
      this.y = y;
      this.vy = vy;
      this.r = r;
      this.type = type;
   }
   Boolean update(Paddle daPaddle, GameState daGame, int[][] colors)
   {
      Boolean didHit = hitPaddle(daPaddle);
      if(!didHit)
      {
         ShapeDrawer s = new ShapeDrawer();
         int[] foreGround = {0, 0, 0};
         y += vy;
         noStroke();
         fill(colors[3][0], colors[3][1], colors[3][2]);
         ellipse(x, y, r * 2, r * 2);
         s.drawType(x, y, r, type, foreGround, colors[3]);
      }
      else
      {
         y = height + 100;
      }
      return didHit;
   }
   Boolean hitPaddle(Paddle daPaddle)
   {
      Ellipse2D.Float e = new Ellipse2D.Float(x, y, r * 2, r * 2);
      return e.intersects(daPaddle.x, daPaddle.y, daPaddle.w, daPaddle.h);
   }
}