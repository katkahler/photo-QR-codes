class Column {
  ArrayList<Voxel> voxels = new ArrayList<Voxel>();
  int xPos;

  Column (int _xpos, color[] _myColors) {
    xPos = _xpos;

    for (int colorIndex = 0; colorIndex < _myColors.length; colorIndex++) {
      voxels.add(new Voxel(_myColors[colorIndex]));
    }
  }

  void displayColumn() {
    noStroke();
    int pixelsDisplayed = 0;
    for (Voxel v : voxels) {

      if (brightness(v.c) > 120) {
        fill(255);
      } else {
        fill(0);
      }

      square(xPos * voxelSize, pixelsDisplayed * voxelSize, voxelSize);
      pixelsDisplayed++;
    }
  }
}
