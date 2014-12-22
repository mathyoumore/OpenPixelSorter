public class ePixel
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

  ePixel(int c)
  {
    r = floor(red(c));
    g = floor(green(c));
    b = floor(blue(c));

    float tempR = r;
    float tempG = g;
    float tempB = b;  

    //CALCULATE HSL
    float max = max(tempR, tempG, tempB);
    float min = min(tempR, tempG, tempB);
    h = floor(max + min / 2.0);
    v = floor(max);
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
      l =ceil((max+min)/2.0);
      //Calculate s
      println("Saturation: " + s);
      s = ceil(delta/(1-abs(2*l-1)));
      println(1-abs(2*l-1));
      println(delta/(1-abs(2*l-1)));
    }
  }
}

void verbose()
{
  println("R,G,B: (" + r +"," + g + "," + b + ")");
  println("H,S,V,L: (" + h +"," + s + "," + v + "," + l +")");
}
}
