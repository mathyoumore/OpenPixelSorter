//OpenPixelSorter hopes to give the power of pixel sorting to the people. 
//Run the jewels, y'all

/*
Receive image (static for dev, upload for deployment)
 Click drag area to modify/sort
 Prompt loop:
 - Choose sorting technique {
 1:    V
 2:    H
 3:    ContrastH
 4:    ConstrastV
 5:    MeanDragH
 6:    MeanDragV
 7:    MedianDragH
 8:    MedianDragV
 9:    bongiovanniV
 10:   bongiovanniH
 99:   Save and Continue
 100:  Save and Exit
 }
 */

PGraphics deb;
PImage img, outH, outS, outL, outV, outR, outG, outB;
PImage rCopy, gCopy, bCopy, hCopy, sCopy, lCopy;
ePixel ePixels[];
String iname = "gr4096big";
String inExt = ".jpg";

float averageV;
void setup()
{
  img = loadImage(iname + inExt);
  rCopy = loadImage(iname + inExt);
  gCopy = loadImage(iname + inExt);
  bCopy = loadImage(iname + inExt);
  hCopy = loadImage(iname + inExt);
  sCopy = loadImage(iname + inExt);
  lCopy = loadImage(iname + inExt);
  size(img.width, img.height);
  rectMode(CORNERS);
  ePixels = new ePixel[img.width];
}

void draw()
{
  int topLim = 0;
  int bottomLim = height;
  int leftLim = topLim;
  int rightLim = width;
  //This is where you switch this to an upload/download to webpage thing
  image (img, 0, 0);
  stroke(255, 0, 0);
  noFill();
  strokeWeight(1);

  img.loadPixels();
  rCopy.loadPixels();
  int t = millis();
  float tRow = millis();
  for (int he = topLim; he < bottomLim; he++)
  {
    if (he % 100 == 0) {
      println("Row " + he + " " + tRow/100.0 + " per row, probably " );
      tRow = millis() - tRow;
    }
    outR = hardSortByRed(rCopy, he, leftLim, rightLim);
    outG = hardSortByGreen(gCopy, he, leftLim, rightLim);
    outB = hardSortByBlue(bCopy, he, leftLim, rightLim);
    outH = hardSortByHue(hCopy, he, leftLim, rightLim);
    outS = hardSortBySat(sCopy, he, leftLim, rightLim);
    outL = hardSortByLight(lCopy, he, leftLim, rightLim);
  }
  outR.save(iname + "SortRed.png");
  outG.save(iname + "SortGreen.png");
  outB.save(iname + "SortBlue.png");
  outH.save(iname + "SortHue.png");
  outS.save(iname + "SortSat.png");
  outL.save(iname + "SortLight.png");
  println("Time taken to sort: " + (millis()-t)/1000);
  noLoop();
}

PImage hardSortByRed(PImage copyImg, int row, int leftLim, int rightLim)
{
  int minAddress = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    minAddress = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getRDelta(copyImg.pixels[i+(row*img.width)]) < getRDelta(copyImg.pixels[minAddress+(row*img.width)]) && i > j)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
    }
  }
  return copyImg;
}

int getRDelta(color c)
{
  return floor(red(c)-green(c)-blue(c));
}

PImage hardSortByGreen(PImage copyImg, int row, int leftLim, int rightLim)
{
  int minAddress = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    minAddress = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getGDelta(copyImg.pixels[i+(row*img.width)]) < getGDelta(copyImg.pixels[minAddress+(row*img.width)]) && i > j)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
    }
  }
  return copyImg;
}

int getGDelta(color c)
{
  return floor(green(c)-blue(c)-red(c));
}

PImage hardSortByBlue(PImage copyImg, int row, int leftLim, int rightLim)
{
  int minAddress = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    minAddress = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getBDelta(copyImg.pixels[i+(row*img.width)]) < getBDelta(copyImg.pixels[minAddress+(row*img.width)]) && i > j)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
    }
  }
  return copyImg;
}

int getBDelta(color c)
{
  return floor(blue(c)-red(c)-green(c));
}

PImage hardSortByHue(PImage copyImg, int row, int leftLim, int rightLim)
{
  int minAddress = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    minAddress = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getH(copyImg.pixels[i+(row*img.width)]) < getH(copyImg.pixels[minAddress+(row*img.width)]) && i > j)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
    }
  }
  return copyImg;
}

float getH(color c)
{
  float h = 0;
  float max = max(red(c), green(c), blue(c));
  float min = min(red(c), green(c), blue(c));
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  if (max == min) {
    h = 0;
  } else
  {
    if (max == red(c))
    {
      h = ((g - b) / ((max-min) + (g < b ? 6 : 0)));
    } else if (max == green(c))
    {
      h = (b - r)/((max-min) + max - min);
    } else
    {
      h = (r - g) / (max - min + 4);
    }
  }
  return h;
}

PImage hardSortBySat(PImage copyImg, int row, int leftLim, int rightLim)
{
  int minAddress = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    minAddress = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getS(copyImg.pixels[i+(row*img.width)]) < getS(copyImg.pixels[minAddress+(row*img.width)]) && i > j)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
    }
  }
  return copyImg;
}

float getS(color c)
{
  float d = max(red(c), green(c), blue(c)) - min(red(c), green(c), blue(c));
  if (d == 0)
  {
    return 0;
  } else
  {
    return d/(1-abs(2*getL(c)-1));
  }
}
PImage hardSortByLight(PImage copyImg, int row, int leftLim, int rightLim)
{
  int minAddress = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    minAddress = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getL(copyImg.pixels[i+(row*img.width)]) < getL(copyImg.pixels[minAddress+(row*img.width)]) && i > j)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
    }
  }
  return copyImg;
}

float getL(color c)
{
  return (max(red(c), green(c), blue(c)) + min(red(c), green(c), blue(c))) / 2.0;
}

