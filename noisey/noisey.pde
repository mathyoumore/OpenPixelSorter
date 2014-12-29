
PGraphics out;
void setup()
{
  size(700, 700);
  out = createGraphics(width, height);
}

void draw()
{
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      out.set(i, j, color(random(100,255),random(100,255),random(100,255)));
    }
  }
  out.save("brightrandom.png");
  image(out,0,0);
  noLoop();
}

