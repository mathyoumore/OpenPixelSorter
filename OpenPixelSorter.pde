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


PGraphics out;
PImage img;
int iX = 0, iY = 0; //Initial coords for selection draw
int fX = 0, fY = 0; //Final coords for selection draw
boolean selecting = false;
boolean drawing = false;

void setup()
{
  img = loadImage("http://www.sqrlbee.com/3001/MattMohr/bird.jpg");
  size(img.width, img.height);
  rectMode(CORNERS);
  out = createGraphics(width, height);
}

void draw()
{

  //This is where you switch this to an upload/download to webpage thing
  image (img, 0, 0);
  stroke(255, 0, 0);
  noFill();
  strokeWeight(1);
  if (selecting && !drawing)
  {
    fX = mouseX;
    fY = mouseY;
    rect(iX, iY, fX, fY);
  } else if (fX != iX || fY != iY) //Temporary, should be a prompt
  {
    // vSort(iX, iY, fX, fY, out);
  }
}

void mouseClicked()
{
  if (!selecting)
  {
    drawing = false;
    iX = mouseX;
    iY = mouseY;
    selecting = true;
  } else
  {
    fX = mouseX;
    fY = mouseY;
    selecting = false;
    drawing = true;
  }
}

void vBrightSort (int minX, int minY, int maxX, int maxY, PGraphics p)
{
  //This is a paragon sorter
  //In the javascript version, make it so that this works with a bunch of variables
  //That whole manip(seed,goal,func){func(seed,goal)} thing
  int col = minX; 
  int row = minY * img.width + minX; 
  //Below value should be something like "sorter value"
  float[] bright = new float[(maxX-minX) * (maxY-minY)];
  //PImage is stored as a single dimension array of pixels, so row is added to col to find the pixel location
  int maxCol = maxX;
  int maxRow = maxY * img.width + maxX;

  out.image(img, 0, 0);
  img.loadPixels();

  while (row < maxRow)
  {
    //Stores all brightnesses of the selected region
    
    //Need to be able to remember the location of the original pixels before they were sorted
    //May need to manually sort, create some kind of parallel sorter/scrambler
    ////Which takes an unsorted array and a sorted array, then sorts the unsorted while unsorting the other
    ////according to the sortedness of the first one. 
   //Also remember that this needs to be on a row-by-row basis, so the sort and put needs to happen every row, not globally. 
   
    bright[col + row] = brightness(img.pixels[col+row]);

    if (col >= maxCol)
    {
      row++;
      col = 0;
    } else
    {
      col++;
    }
  }
}

