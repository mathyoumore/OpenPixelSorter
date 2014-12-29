import java.util.LinkedList;
import java.util.PriorityQueue;

String inFile = "whitemarble";
String inExtension = "jpg";
PImage in;
PGraphics out;
PImage inCopyR, inCopyC;
PImage lightOut;


float threshold = 1;
//int xMin = 53;
//int yMin = 84;
int xMin = 0;
int yMin = 0;
int xMax = 0;
int yMax = 0;

boolean drawing = false;
boolean selecting = true;
boolean finalizing = false;

void setup()
{
  in = loadImage(inFile + "." + inExtension);
  inCopyR = loadImage(inFile + "." + inExtension);
  inCopyC = loadImage(inFile + "." + inExtension);
  size(in.width, in.height);
  out = createGraphics(width, height);
  rectMode(CORNERS);
}

void draw()
{

  image(in, 0, 0);
  in.loadPixels();

  if (selecting || finalizing)
  {
    stroke(255, 0, 0);
    line(0, mouseY, width, mouseY);
    line(mouseX, 0, mouseX, height);
    chancePrintln(mouseX + ", " + mouseY);
    stroke(255, 0, 0);
    if (finalizing) {    
      rect(xMin, yMin, mouseX, mouseY);
    }
  }

  if (drawing)
  {
    println(xMin + ", " + yMin + " -> " + xMax + ", " + yMax);
    for (int y = yMin; y < yMax; y++)
    {
      lightOut = hardSortByLight(inCopyR, y, xMin, xMax);
    }
    lightOut.save("row.png");
    for (int x = xMin; x < xMax; x++)
    {
      lightOut = hardSortByLightColumn(inCopyR, x, yMin, yMax);
    }
    lightOut.save("col.png");

    drawing = false;
    selecting = true;
    xMin = 0;
    yMin = 0;
    xMax = 0;
    yMax = 0;
  }
}

void chancePrintln(String s)
{
  if (random(100) < 20) { 
    println(s);
  }
}

void mousePressed()
{
  if (selecting)
  {
    xMin = mouseX;
    yMin = mouseY;
    finalizing = true;
    selecting = false;
    println(xMin + ", " + yMin);
  } else if (finalizing)
  {
    xMax = mouseX;
    yMax = mouseY;
    if (xMax < xMin)
    {
      xMax = xMin;
      xMin = mouseX;
    }
    if (yMax < yMin)
    {
      yMax = yMin;
      yMin = mouseY;
    }
    finalizing = false;
    drawing = true;
    println(xMax + ", " + yMax);
  }
}

/*
void rowSort()
 {
 for (int y = yMin; y<yMax; y++)
 {
 for (int x = xMin; x < xMax; x++)
 {
 color c = in.pixels[x+(y*xMax)];
 
 fill(c);
 noStroke();
 out.set(x, y, c);
 color l = changeContrast(in.pixels[x+(y*xMax)], 2);
 color m = changeContrast(in.pixels[x+(y*xMax)], 2);
 color r = changeContrast(in.pixels[x+(y*xMax)], 2);
 if (x > 0)
 {
 l = changeContrast(in.pixels[x-1+(y*xMax)], 88);
 }
 if (x < (xMax - 1))
 {
 r = changeContrast(in.pixels[x+1+(y*in.width)], 88);
 }
 
 if ((abs(getL(l) - getL(m)) > threshold) || (abs(getL(m) - getL(r)) > threshold))
 {
 //Is an Edge
 stroke(255, 0, 0, 50);
 //          ellipse(x, y, 2, 2);
 //          stroke(r);
 //          line(x, y, x+30, y);
 for (int rx = xMax-1; rx > x; rx--)
 {
 
 l = changeContrast(in.pixels[rx+(y*in.width)], 88);
 m = changeContrast(in.pixels[rx+(y*in.width)], 88);
 r = changeContrast(in.pixels[rx+(y*in.width)], 88);
 if (rx > x)
 {
 l = changeContrast(in.pixels[rx-1+(y*in.width)], 88);
 }
 if (rx < (in.width - 1))
 {
 r = changeContrast(in.pixels[rx+1+(y*in.width)], 88);
 }
 if ((abs(getL(l) - getL(m)) > threshold) || (abs(getL(m) - getL(r)) > threshold))
 {
 lightOut = hardSortByLightColumn(inCopyR, y, x, rx);
 line(x, y, rx, y);
 rx = x;
 }
 }
 x = in.width;
 }
 }
 }
 }
 */
int findEdge(int row, boolean left)
{
  return 0;
}

float getL(color c)
{
  return (max(red(c), green(c), blue(c)) + min(red(c), green(c), blue(c))) / 2.0;
}

String pColor(color c)
{
  return " (" + red(c) + ", " + green(c) + ", " + blue(c) + ") ";
}

PImage hardSortByLightColumn(PImage copyImg, int col, int topLim, int bottomLim)
{
  int target = 0;
  for (int j = topLim; j < bottomLim - 1; j++)
  {
    target = j;
    for (int i = (j + 1); i < bottomLim; i++)
    {
      if (getL(copyImg.pixels[col+(i*in.width)]) < getL(copyImg.pixels[col+(target*in.width)]) && i > j)
      {
        target = i;
      }
    }
    if (j != target)
    {
      color a = copyImg.pixels[col+(j*copyImg.width)];
      color b = copyImg.pixels[col+(target*copyImg.width)];
      copyImg.pixels[col+(j*copyImg.width)] = b;
      copyImg.pixels[col+(target*copyImg.width)] = a;
    }
  }
  return copyImg;
}

PImage hardSortByLight(PImage copyImg, int row, int leftLim, int rightLim)
{
  int target = 0;
  for (int j = leftLim; j < rightLim - 1; j++)
  {
    target = j;
    for (int i = (j + 1); i < rightLim; i++)
    {
      if (getL(copyImg.pixels[i+(row*in.width)]) < getL(copyImg.pixels[target+(row*in.width)]) && i > j)
      {
        target = i;
      }
    }
    if (j != target)
    {
      color a = copyImg.pixels[j+(row*copyImg.width)];
      color b = copyImg.pixels[target+(row*copyImg.width)];
      copyImg.pixels[j+(row*copyImg.width)] = b;
      copyImg.pixels[target+(row*copyImg.width)] = a;
    }
  }
  return copyImg;
}

