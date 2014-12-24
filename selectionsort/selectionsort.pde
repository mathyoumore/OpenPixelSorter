void setup()
{
}

void draw()
{
  float[] unsorted = new float[100]; 
  for (int i = 0; i < 100; i++)
  {
    unsorted[i] = random(100);
  }
  unsorted = selectionSort(unsorted);
  for (int i = 0; i < 100; i++)
  {
    print("\n" + unsorted[i]);
  } 
  noLoop();
}

float[] selectionSort(float[] u)
{
  float[] sorted = u;
  int min;
  for (int j = 0; j < 100; j++)
  {
    min = j+1;
    for (int i = j + 1; i < 100; i++)
    {
      if (sorted[i] < sorted[min])
      {
        min = i;
      }
    }
    if (min != j && min < 100)
    {
      float tmp1 = sorted[j];
      float tmp2 = sorted[min];
      sorted[j] = tmp2;
      sorted[min] = tmp1;
    }
  }
  return sorted;
}

