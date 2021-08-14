PImage img;
color[][] energies;
color[][] finals;

void setup() {
  size(500, 500);
  img = loadImage("aot.jpg");
  img.resize(500, 500);
  energies = new color[width][height];
  finals = new color[width][height];
  noLoop();
}

color apply(int _x, int _y) {
  color left = img.get(_x-1, _y);
  color right = img.get(_x+1, _y);
  color up = img.get(_x, _y-1);
  color down = img.get(_x, _y+1);

  int rx = round(red(left)-red(right));
  rx = rx * rx;
  int ry = round(red(up)-red(down));
  ry = ry * ry;

  int gx = round(green(left)-green(right));
  gx = gx * gx;
  int gy = round(green(up)-green(down));
  gy = gy * gy;

  int bx = round(blue(left)-blue(right));
  bx = bx * bx;
  int by = round(blue(up)-blue(down));
  by = by * by;

  int hx = rx + gx + bx;
  int vx = ry + gy + by;

  return hx + vx;
}

void energize() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      energies[x][y] = color(map(apply(x, y), 0, 20000, 0, 255));
    }
  }
}

void recolor() {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      color c = color(energies[i][j]);
      if (c > 50) {
        finals[i][j] = color(0,0,0);
      } else {
        finals[i][j] = color(255, 255, 255);
      }
    }
  }
}


void draw() {
  energize();
  recolor();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x, y, finals[x][y]);
    }
  }
}

