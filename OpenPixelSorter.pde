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


PGraphics outH, outS, outL, outV, outR, outG, outB;
PGraphics deb;
PImage img, copyImg;
ePixel ePixels[];
String iname = "redbird";

float averageV;
void setup()
{
  img = loadImage(iname + ".jpg");
  copyImg = loadImage(iname + ".jpg");
  size(img.width, img.height);
  rectMode(CORNERS);
  outR = createGraphics(width, height);
  outG = createGraphics(width, height);
  outB = createGraphics(width, height);
  deb = createGraphics(width, height);
  ePixels = new ePixel[img.width];
}

void draw()
{
  int topLim = floor(img.height/3.0);
  int bottomLim = floor(2*img.height/3.0);
  int leftLim = topLim;
  int rightLim = bottomLim;
  //This is where you switch this to an upload/download to webpage thing
  image (img, 0, 0);
  stroke(255, 0, 0);
  noFill();
  strokeWeight(1);

  img.loadPixels();
  copyImg.loadPixels();
  for (int he = topLim; he < bottomLim; he++)
  {
    for (int i = 0; i < img.width; i++)
    {
      ePixels[i] = new ePixel(img.pixels[i+(he*img.width)], i);
    } 
    /* ePixel redSorted[] = sortRowByRed(he);
     
     ePixel greenSorted[] = sortRowByGreen(he);
     
     ePixel blueSorted[] = sortRowByBlue(he);
     int pastV = 256;
     */
    //hardSortByRed(he);

    hardSortByLight(he, leftLim, rightLim);

    /* for (int run = 0; run < img.width; run++)
     {
     outR.set(run, he, color(redSorted[run].r, redSorted[run].g, redSorted[run].b));
     outG.set(run, he, color(greenSorted[run].r, greenSorted[run].g, greenSorted[run].b));
     outB.set(run, he, color(blueSorted[run].r, blueSorted[run].g, blueSorted[run].b));
     deb.set(run, he, color(ePixels[run].r, ePixels[run].g, ePixels[run].b));
     }*/
  }
  copyImg.save(iname + "SortLightHard.png");
  //copyImg.save(iname + "SortRedHard.png");
  //  outR.save(iname + "SortRed.png");
  //  outG.save(iname + "SortGreen.png");
  //  outB.save(iname + "SortBlue.png");
  //  deb.save(iname + "SortDebug.png");
  // copyImg.save(iname + "SortRedHard.png");
  //out.save("SortSaturation.png");
  //Remember to deal with row
  image(copyImg, 0, 0);
  println("Infidelity: " + (averageV/img.height));
  noLoop();
}

void hardSortByLight(int row, int leftLim, int rightLim)
{
  float lDel, lDelMin;
  int minAddress = 0;
  float prevMin = 0;
  int swaps = 0;
  int dummy = 0;
  for (int j = leftLim; j < rightLim; j++)
  {
    minAddress = j;
    lDelMin = 256;
    for (int i = (j + 1); i < rightLim; i++)
    {
      lDel = getLDelta(copyImg.pixels[i+(row*img.width)]);
      if (lDel < lDelMin)
      {
        minAddress = i;
        lDelMin = lDel;
      }
    }
    if (j != minAddress)
    {
      //println(lDelMin);
      color a = copyImg.pixels[j+(row*img.width)];
      color b = copyImg.pixels[minAddress+(row*img.width)];
      copyImg.pixels[j+(row*img.width)] = b;
      copyImg.pixels[minAddress+(row*img.width)] = a;
      swaps++;
      if (j > 1 && copyImg.pixels[j+(row*img.width)] < copyImg.pixels[j-1+(row*img.width)])
      {
        dummy++;
      }
    }
  }
  int v = 0;
  for (int i = leftLim; i < rightLim; i++)
  {
    if (i < (img.width-1) && (getLDelta(copyImg.pixels[i+(row*img.width)]) < getLDelta(copyImg.pixels[i+1+(row*img.width)])))
    {  
      //copyImg.pixels[i+(row*img.width)] = color(255, 255, 0);
      v++;
      println(i + " is less than " + (i+1));
    }
  }
  //  println("Second Row " + row + " violations: " + v + " out of " + img.width);
  averageV += v;
  println("I'm a dummy x" + dummy);
  println("Row " + row + " violations: " + v + ", swaps: " + swaps);
}

float getLDelta(color c)
{
  float l = floor(max(red(c), green(c), blue(c))+min(red(c), green(c), blue(c)));
  l = l/255;
  l = l/2;
  l *= 100;
  //println(l);
  return l;
}

void hardSortByRed(int row)
{
  int leftLim = floor(img.width/5.0);
  int rightLim = floor(4*img.width/5.0);
  float rDel, rDelMin;
  int minAddress = 0;
  float prevMin = 0;
  for (int j = leftLim; j < rightLim; j++)
  {
    minAddress = j;
    rDelMin = 256;
    for (int i = (j + 1); i < rightLim; i++)
    {
      rDel = getRDelta(copyImg.pixels[i+(row*img.width)]);
      if (rDel < rDelMin)
      {
        minAddress = i;
        rDelMin = rDel;
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
  int v = 0;
  for (int i = leftLim; i < rightLim; i++)
  {
    if (i < (img.width-1) && (getRDelta(copyImg.pixels[i+(row*img.width)]) < getRDelta(copyImg.pixels[i+1+(row*img.width)])))
    {        
      v++;
    }
  }
  //  println("Second Row " + row + " violations: " + v + " out of " + img.width);
  averageV += v;
}


int getRDelta(color c)
{
  return floor(red(c)-green(c)-blue(c));
}

int getGDelta(color c)
{
  return floor(green(c)-blue(c)-red(c));
}

int getBDelta(color c)
{
  return floor(blue(c)-red(c)-green(c));
}


