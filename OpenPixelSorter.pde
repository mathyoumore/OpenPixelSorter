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
  img.loadPixels();
  color c = img.pixels[0];
  Pxl p = new Pxl(c);
  p.verbose();
  println("H,S,V,L: (76,21,xx,50)");
  noLoop();
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

