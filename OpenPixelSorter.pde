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
PImage img, outH, outS, outL, outV, outR, outG, outB, outBongio;
PImage rCopy, gCopy, bCopy, hCopy, sCopy, lCopy;
PGraphics bongioCopy;
ePixel ePixels[];
String iname = "cocoteel";
String inExt = ".jpg";

boolean selecting = true;
boolean finalizing = false;
boolean drawing = false;
int topLim = 0;
int bottomLim = 0;
int leftLim = 0;
int rightLim = 0;

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
  bongioCopy = createGraphics(img.width, img.height);
  bongioCopy.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
  size(img.width, img.height);
  rectMode(CORNERS);
  ePixels = new ePixel[img.width];
}

void draw()
{
  bongioCopy.beginDraw();
  image(img, 0, 0);
  if (selecting || finalizing)
  {
    stroke(255, 0, 0);
    line(mouseX, 0, mouseX, height);
    line(0, mouseY, width, mouseY);
    if (finalizing)
    {
      noFill();
      rect(leftLim, topLim, mouseX, mouseY);
    }
  } else if (drawing)
  {
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
        //  println("Row " + he + " " + tRow/100.0 + " per row, probably " );
        tRow = millis() - tRow;
      }
      outR = hardSortByRed(rCopy, he, leftLim, rightLim);
      outG = hardSortByGreen(gCopy, he, leftLim, rightLim);
      outB = hardSortByBlue(bCopy, he, leftLim, rightLim);
      outH = hardSortByHue(hCopy, he, leftLim, rightLim);
      outS = hardSortBySat(sCopy, he, leftLim, rightLim);
      outL = hardSortByLight(lCopy, he, leftLim, rightLim);
    }
    outBongio = bongiovanniSort(bongioCopy, leftLim, topLim, rightLim, bottomLim, 0.0);
    outBongio.save(iname + "SortBongio.png");
    /* outR.save(iname + "SortRed.png");
     outG.save(iname + "SortGreen.png");
     outB.save(iname + "SortBlue.png");
     outH.save(iname + "SortHue.png");
     outS.save(iname + "SortSat.png");
     outL.save(iname + "SortLight.png");*/
    println("Time taken to sort: " + (millis()-t)/1000);
    image(outBongio, 0, 0);
    noLoop();
    drawing = false;
    finalizing = false;
    selecting = true;
    bongioCopy.endDraw();
  }
}

void mousePressed()
{
  if (selecting)
  {
    topLim = mouseY;
    leftLim = mouseX;
    selecting = false;
    finalizing = true;
  } else if (finalizing)
  {
    if (mouseX < leftLim)
    {
      rightLim = leftLim;
      leftLim = mouseX;
    } else
    {
      rightLim = mouseX;
    }
    if (mouseY < bottomLim)
    {
      bottomLim = topLim;
      topLim = mouseY;
    } else
    {
      bottomLim = mouseY;
    }
    drawing = true;
    finalizing = false;
    selecting = false;
  }
}

PImage bongiovanniSort(PGraphics copyImg, int row, int col, int wide, int tall, float angle)
{
  /*
  Receive image and coordinate of the point to start drawing
   Copy pixels starting at (row,col) and going for wide
   Repeat copied pixels for tall
   
   - ANGLE should determine angle of melting
   - Need to get the bulb at the bottom
   - Layering strands
   
   */
  int actualWidth = wide-row;
  float halfWidth = (wide-row)/2.0;
  color c[] = new color[actualWidth];
  for (int i = 0; i < actualWidth; i++)
  {
    c[i] = img.pixels[i+row+(col*copyImg.width)];
  }
  //Drip
  println(actualWidth);
  int half_r;
  for (int r = 0; r < actualWidth; r++)
  {
    color ave;
    
    println("Going to " + actualWidth + " At " + r);
    half_r = floor(r/2.0);
    float divi = (2.0-(2/(half_r+1)));
    ave = color((red(c[half_r])+red(c[(actualWidth-1)-(half_r)]))/divi,(green(c[half_r])+green(c[(actualWidth-1)-(half_r)]))/divi,(blue(c[half_r])+blue(c[(actualWidth-1)-(half_r)]))/divi);
    copyImg.strokeWeight(0.5);
    //copyImg.line(halfWidth+row, 0, halfWidth+row, height);
    copyImg.noStroke();
    copyImg.fill(c[half_r]);
    //copyImg.fill(ave);
    //      copyImg.fill(r*2);
    copyImg.arc((row+wide)/2.0, tall*1.0, float(actualWidth-r), float(actualWidth-r), HALF_PI, PI);
  }
  for (int r = 0; r < actualWidth; r++)
  {
    half_r = ceil(r/2.0);
    println(actualWidth + " - " + half_r + " = " + (actualWidth-half_r));
    copyImg.fill(c[(actualWidth-1)-(half_r)]);
    //      copyImg.fill(r*2-halfWidth*2);
    copyImg.arc((row+wide)/2.0, tall*1.0, float(actualWidth-r), float(actualWidth-r), 0, HALF_PI);
  }
  //copyImg.ellipse((row+wide)/2.0, tall*1.0, (wide-row) - r, (wide-row) - r);

  //Drop
  for (int h = 0; h < floor (tall-col); h++)
  {
    for (int i = 0; i < wide-row; i++)
    {
      copyImg.set((i + row), col+h, c[i]);
    }
  }
  return copyImg;
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

