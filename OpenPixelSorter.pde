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
PImage img;
ePixel ePixels[];
String iname = "bird";
void setup()
{
  img = loadImage(iname + ".jpg");
  size(img.width, img.height);
  rectMode(CORNERS);
  outH = createGraphics(width, height);
  outS = createGraphics(width, height);
  outL = createGraphics(width, height);
  outV = createGraphics(width, height);
  outR = createGraphics(width, height);
  outG = createGraphics(width, height);
  outB = createGraphics(width, height);
  deb = createGraphics(width, height);
  ePixels = new ePixel[img.width];
}

void draw()
{

  //This is where you switch this to an upload/download to webpage thing
  image (img, 0, 0);
  stroke(255, 0, 0);
  noFill();
  strokeWeight(1);

  img.loadPixels();
  for (int he = 0; he < img.height; he++)
  {
    for (int i = 0; i < img.width; i++)
    {
      ePixels[i] = new ePixel(img.pixels[i+(he*img.width)], i);
      //ePixels[i].verbose();
    } 
    ePixel hueSorted[] = sortRowByHue(he);
    //  ePixel satSorted[] = sortRowBySat(he);
    // ePixel lightSorted[] = sortRowByLight(he, ePixels);
    //  ePixel valueSorted[] = sortRowByValue(he);
    // ePixel redSorted[] = sortRowByRed(he);
    //  ePixel greenSorted[] = sortRowByGreen(he);
    ePixel blueSorted[] = sortRowByBlue(he, ePixels);
    int pastV = 256; 
    for (int run = 0; run < img.width; run++)
    {
      outH.set(run, he, color(hueSorted[run].r, hueSorted[run].g, hueSorted[run].b));
      //if (run == 100) { outH.set(run, he, color(255,0,0));}
      //  outS.set(run, he, color(satSorted[run].r, satSorted[run].g, satSorted[run].b));
      //    if (run == 200) { outS.set(run, he, color(0,255,0));}
      //outL.set(run, he, color(lightSorted[run].r, lightSorted[run].g, lightSorted[run].b));
      // if (run == 300) { outL.set(run, he, color(0,0,255));}
      //   outV.set(run, he, color(valueSorted[run].r, valueSorted[run].g, valueSorted[run].b));
      //   outR.set(run, he, color(redSorted[run].r, redSorted[run].g, redSorted[run].b));
      //    outG.set(run, he, color(greenSorted[run].r, greenSorted[run].g, greenSorted[run].b));
      outB.set(run, he, color(blueSorted[run].r, blueSorted[run].g, blueSorted[run].b));
      deb.set(run, he, color(ePixels[run].r, ePixels[run].g, ePixels[run].b));
    }
  }

  outH.save(iname + "SortHue.png");
  outS.save(iname + "SortSat.png");
  outL.save(iname + "SortLight.png");
  outV.save(iname + "SortValue.png");
  outR.save(iname + "SortRed.png");
  outG.save(iname + "SortGreen.png");
  outB.save(iname + "SortBlue.png");
  deb.save(iname + "SortDebug.png");
  //out.save("SortSaturation.png");
  //Remember to deal with row
  noLoop();
}

ePixel[] sortRowByHue(int row)
{
  ePixel sorted[] = ePixels; 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].h < sorted[minAddress].h)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
    }
  }
  return sorted;
}

ePixel[] sortRowBySat(int row)
{
  ePixel sorted[] = ePixels; 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].s < sorted[minAddress].s)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
    }
  }
  return sorted;
}

ePixel[] sortRowByLight(int row, ePixel[] o)
{
  ePixel sorted[] = o; 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].l < sorted[minAddress].l)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
    }
  }
  return sorted;
}

ePixel[] sortRowByValue(int row)
{
  ePixel sorted[] = ePixels; 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].v < sorted[minAddress].v)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
    }
  }
  return sorted;
}

ePixel[] sortRowByRed(int row)
{
  ePixel sorted[] = ePixels; 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].r < sorted[minAddress].r)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
    }
  }
  return sorted;
}

ePixel[] sortRowByGreen(int row)
{
  ePixel sorted[] = ePixels; 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].g < sorted[minAddress].g)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
    }
  }
  return sorted;
}

ePixel[] sortRowByBlue(int row, ePixel[] o)
{
  ePixel[] sorted = new ePixel[img.width];
  for (int i = 0; i < img.width; i++)
  {
    sorted[i] = new ePixel(0, 0);
    sorted[i].copyFrom(ePixels[i]);
  } 
  int minAddress;
  int prevMin = 0;
  for (int j = 0; j < img.width-1; j++)
  {
    minAddress = j;
    for (int i = j + 1; i < img.width; i++)
    {
      if (sorted[i].b < sorted[minAddress].b)
      {
        minAddress = i;
      }
    }
    if (j != minAddress)
    {
      ePixel tmp1 = sorted[j];
      ePixel tmp2 = sorted[minAddress];
      sorted[j] = tmp2;
      sorted[minAddress] = tmp1;
      sorted[j].swap(sorted[minAddress]);
    }
  }
  return sorted;
}

