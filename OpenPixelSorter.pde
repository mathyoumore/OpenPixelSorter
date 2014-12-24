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
PImage rCopy, gCopy, bCopy;
ePixel ePixels[];
String iname = "gr4096";

float averageV;
void setup()
{
  img = loadImage(iname + ".jpg");
  rCopy = loadImage(iname + ".jpg");
  gCopy = loadImage(iname + ".jpg");
  bCopy = loadImage(iname + ".jpg");
  size(img.width, img.height);
  rectMode(CORNERS);
  ePixels = new ePixel[img.width];
}

void draw()
{
  int topLim = 0;
  int bottomLim = height;
  int leftLim = topLim;
  int rightLim = bottomLim;
  //This is where you switch this to an upload/download to webpage thing
  image (img, 0, 0);
  stroke(255, 0, 0);
  noFill();
  strokeWeight(1);
  
  img.loadPixels();
  rCopy.loadPixels();
  int t = millis();
  for (int he = topLim; he < bottomLim - 1; he++)
  {
    if (he % 100 == 0) {
      println("Row " + he);
    }
    outR = hardSortByRed(rCopy, he, leftLim, rightLim);
    outG = hardSortByGreen(gCopy, he, leftLim, rightLim);
    outB = hardSortByBlue(bCopy, he, leftLim, rightLim);
  }
  outR.save(iname + "SortRedHard.png");
  outG.save(iname + "SortGreenHard.png");
  outB.save(iname + "SortBlueHard.png");
  println("Time taken to sort: " + (millis()-t)/1000);
//
//  t = millis();
//  for (int he = topLim; he < bottomLim - 1; he++)
//  {
//    if (he % 100 == 0) {
//      println("Row " + he);
//    }
//    
//  }
//  
//  println("Time taken to sort: " + (millis()-t)/1000);
//
//  t = millis();
//  for (int he = topLim; he < bottomLim - 1; he++)
//  {
//    if (he % 100 == 0) {
//      println("Row " + he);
//    }
//    
//  }  
//  
//
//  println("Time taken to sort: " + (millis()-t)/1000);

  noLoop();
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
  float l = floor(max(red(c), green(c), blue(c))+min(red(c), green(c), blue(c)));
  l = l/255;
  l = l/2;
  l *= 100;
  //println(l);
  return l;
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

