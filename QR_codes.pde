PImage img;
int pointCount = 100;
int centCount = 2;
int voxelSize = 10; //div by 10
int cornerSize = voxelSize*10; //div by 10
int cornersWidth = cornerSize-cornerSize/8;

int xMax, yMax;

ArrayList<Column> columns;
Point[] centroids = new Point[centCount];  // ARRAY of rgb triplets
Point[][] points2d = new Point[500][500];

void setup() {
  size(500, 500); 
  noStroke();
  //stroke(255,0,0); //check if corners align
  xMax = width/voxelSize;
  yMax = height/voxelSize;

  img = loadImage("armin.jpg");
  img.resize(500, 0);

  for (int x = 0; x < 500; x++) { //creating the points
    for (int y = 0; y < 500; y++) {
      points2d[x][y] = new Point(red(img.get(x, y)), green(img.get(x, y)), blue(img.get(x, y)));
    }
  }

  for (int ce = 0; ce < centroids.length; ce++) { //creating the centroids
    color imgget = img.get(round(random(0, 500)), round(random(0, 500)));
    centroids[ce] = new Point(red(imgget), green(imgget), blue(imgget));
  }

  assign(); 

  for (int x = 0; x < 500; x++) {
    for (int y = 0; y < 500; y++) {
      points2d[x][y].display(x, y);
    }
  }

  //APPLYING K-MEANS
  boolean changed = true;
  while (changed) {
    for (int cent = 0; cent < centroids.length; cent++) {  // recalculate centroid means
      findMeans();
    }
    changed = assign(); //reassign points to centroids
  }


  //VOXELIZING
  columns = new ArrayList<Column>();
  int numRows = width / voxelSize;
  int numColumns = height / voxelSize;

  for (int x = 0; x < numColumns; x++) {
    color[] voxelList = new color[numRows];
    for (int y = 0; y < numRows; y++) {
      int centroid = points2d[x * voxelSize][y * voxelSize].myCentroidIndex;
      color c = color(centroids[centroid].r, centroids[centroid].g, centroids[centroid].b);
      voxelList[y] = c;
    }
    Column c = new Column(x, voxelList);
    columns.add(c);
  }

  for (Column c : columns) {
    c.displayColumn(); //draw the columns of voxels
  } 
  
  fill(255);
  square(0,0,cornerSize);
  square(width-cornerSize, 0, cornerSize);
  square(0, height-cornerSize, cornerSize);
  corner(0,0,cornerSize-cornerSize/8);
  corner(width-cornersWidth, 0, cornersWidth);
  corner(0,height-cornersWidth, cornersWidth);

}

boolean assign() {
  boolean changed = false;
  for (int x = 0; x < 500; x++) {
    for (int y = 0; y <500; y++) {
      int oldCentroid = points2d[x][y].myCentroidIndex;
      float id = 1000000;
      for (int c = 0; c < centroids.length; c++) {
        float d = dist(points2d[x][y].r, points2d[x][y].g, points2d[x][y].b, centroids[c].r, centroids[c].g, centroids[c].b);
        if (d < id) {
          points2d[x][y].myCentroidIndex = c;
          id = dist(points2d[x][y].r, points2d[x][y].g, points2d[x][y].b, centroids[c].r, centroids[c].g, centroids[c].b);
        }
      }
      if (points2d[x][y].myCentroidIndex != oldCentroid)
        changed = true;
    }
  }
  return changed;
}

void findMeans() {
  float sumR[] = new float[centCount];
  float sumG[] = new float[centCount];
  float sumB[] = new float[centCount];
  float total[] = new float[centCount];

  for (int x = 0; x < 500; x++) {
    for (int y = 0; y < 500; y++) {
      Point pgp = points2d[x][y];
      sumR[pgp.myCentroidIndex] += pgp.r;
      sumG[pgp.myCentroidIndex] += pgp.g;
      sumB[pgp.myCentroidIndex] += pgp.b;
      total[pgp.myCentroidIndex] += 1;
    }
  }

  for (int c = 0; c < centroids.length; c++) {
    centroids[c].r = sumR[c] / total[c];
    centroids[c].g = sumG[c] / total[c];
    centroids[c].b = sumB[c] / total[c];
  }
}

void corner(float _x, float _y, float size){
  fill(0);
square(_x, _y, size);
fill(255);
square(_x + size/8, _y + size/8, size-size/4);
fill(0);
square(_x + size/4, _y + size/4, size-size/2);


}
