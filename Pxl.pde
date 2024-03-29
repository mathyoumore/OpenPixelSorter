public class ePixel
{
  float r;
  float g;
  float b;

  float h;
  float s;
  float l;
  float v;

  float rDel;
  float gDel;
  float bDel;
  //  int c;
  //  int m;
  //  int y;
  //  int k;

  int originalLoc;
  int currentLoc;

  ePixel(int c, int loc)
  {
    r = red(c);
    g = green(c);
    b = blue(c);

    rDel = r - g - b;
    gDel = g - r - b;
    bDel = b - r - g;

    float tempR = r / 255.0;
    float tempG = g / 255.0;
    float tempB = b / 255.0;  

    //CALCULATE HSL
    float max = max(tempR, tempG, tempB);
    float min = min(tempR, tempG, tempB);
    h = (max + min / 2.0)*100;
    s = (max + min / 2.0)*100;
    l = (max + min / 2.0)*100;
    v = max*100;
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
        h = (g - b) / delta + (g < b ? 6 : 0);
      } else if (max == tempG)
      { 
        h = (b - r) / delta + 2;
      }
      if (max == tempB)
      { 
        h = (r - g) / delta + 4;
      }
      h = h/6.0;
      //Calculate l
      l = ((max+min)/2.0)*100;
      //Calculate s
      s = 10000*(l > 50 ? delta/(2-(2*l)) : delta/(2*l));
    }
    //END CACLULATE HSL

    originalLoc = loc;
    currentLoc = loc;
  }

  void verbose()
  {
    println("R,G,B: (" + r +"," + g + "," + b + ")");
    println("H,S,V,L: (" + h +"," + s + "," + v + "," + l +")");
  }

  void copyFrom(ePixel blank)
  {
    this.r = blank.r;
    this.g = blank.g;
    this.b = blank.b;
    this.h = blank.h;
    this.s = blank.s;
    this.l = blank.l;
    this.v = blank.v;
    this.originalLoc = blank.originalLoc;
  }

  void swap(ePixel b)
  {
    ePixel tmp1 = this;
    ePixel tmp2 = b;
    this.copyFrom(tmp2);
    b.copyFrom(tmp1);
  }

  void init()
  {
    this.h = 0;
    this.s = 0;
    this.l = 0;
    this.v = 0;
    this.r = 0;
    this.g = 0;
    this.b = 0;
    this.originalLoc = 0;
  }
}

