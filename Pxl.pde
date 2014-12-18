public class Pxl
{
  int r;
  int g;
  int b;

  int h;
  int s;
  int l;
  int v;

  //  int c;
  //  int m;
  //  int y;
  //  int k;

  int originalLoc;
  int currentLoc;

  Pxl(int c)
  {
    r = floor(red(c));
    g = floor(green(c));
    b = floor(blue(c));

    float tempR = r / 255.0;
    float tempG = g / 255.0;
    float tempB = b / 255.0;  

    //CALCULATE HSL
    float max = max(tempR, tempG, tempB);
    float min = min(tempR, tempG, tempB);
    h = floor((max + min / 2.0)*100);
    s = floor((max + min / 2.0)*100);
    l = floor((max + min / 2.0)*100);
    v = floor(max*100);
    if (max == min)
    {
      //Achromatic
      h = 0;
      s = 0;
    } else //Calculate h
    {
      float delta = max - min;
      //      s > 0.5 ? d / (2 - max - min) : d /(max + min);
      if (max == tempR) 
      {
        h = floor((g - b) / delta + (g < b ? 6 : 0));
      } else if (max == tempG)
      { 
        h = floor((b - r) / delta + 2);
      }
      if (max == tempB)
      { 
        h = floor((r - g) / delta + 4);
      }
      h = floor(h/6.0);
      //Calculate l
      l = ceil(((max+min)/2.0)*100);
      //Calculate s
      if (delta == 0)
      {
        s = 0;
      } else
      {
        s = ceil((delta/(1-abs(2*l-1)))*100);
      }
    }
  }

  void verbose()
  {
    println("R,G,B: (" + r +"," + g + "," + b + ")");
    println("H,S,V,L: (" + h +"," + s + "," + v + "," + l +")");
  }
}

