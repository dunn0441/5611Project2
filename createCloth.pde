
// simulate cloth using triangles
void createTri() {
  stroke(255);
  fill(255,0,0);
  for (int i = 0; i < numRopes-1; i++){
    for (int j = 0; j < numNodes-1; j++){
      beginShape();
      vertex(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      endShape(CLOSE);
      beginShape();
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      endShape(CLOSE);
    }
  }  
}


// simulate cloth using quads
void createQuad() {
  stroke(255);
  fill(255,0,0);
  for (int i = 0; i < numRopes-1; i++){
    for (int j = 0; j < numNodes-1; j++){
      beginShape();
      vertex(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      endShape(CLOSE);
    }
  }  
}
