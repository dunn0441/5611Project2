
// simulate cloth using triangles
void createTri() {
  //stroke(255);
  noStroke();
  fill(255,0,0);
  for (int i = 0; i < numRopes-1; i++){
    for (int j = 0; j < numNodes-1; j++){
      beginShape();
      normal(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      vertex(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      normal(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      normal(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      endShape(CLOSE);
      beginShape();
      normal(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      normal(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z);
      vertex(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z);
      normal(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      endShape(CLOSE);
    }
  }  
}


// simulate cloth using quads
void createQuad() {
  //stroke(255);
  noStroke();
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

void airDrag() {
  for (int i = 0; i < numRopes-1; i++){
    for (int j = 0; j < numNodes-1; j++){
      PVector area;
      PVector velocity;
      PVector vAir = new PVector(1, 1, 0);
      PVector normal;
      PVector van;
      PVector faero;
      float coef;
      
      velocity = (vel[i][j].copy().add(vel[i+1][j]).add(vel[i][j+1])).mult(1/3).sub(vAir);
      
      PVector v1 = pos[i][j+1].copy();
      PVector v2 = pos[i+1][j].copy();
      v1.sub(pos[i][j]);
      v2.sub(pos[i][j]);
      
      area = v1.cross(v2);
      
      normal = area.copy().div(area.mag());
      
      coef = velocity.mag();
      coef *= velocity.dot(area);
      coef /= (2 * area.mag());
      
      van = area.copy().mult(coef);
      
      faero = van.copy().mult(-0.5 * cd);
      
      acc[i][j].sub(faero.mult(1/3));
      acc[i+1][j].sub(faero);
      acc[i][j+1].sub(faero);
      
      
      //finding second triangle
      
      velocity = (vel[i+1][j].copy().add(vel[i+1][j+1]).add(vel[i][j+1])).mult(1/3).sub(vAir);
      
      v1 = pos[i+1][j+1].copy();
      v2 = pos[i][j+1].copy();
      v1.sub(pos[i+1][j]);
      v2.sub(pos[i+1][j]);
      
      area = v1.cross(v2);
      
      normal = area.copy().div(area.mag());
      
      coef = velocity.mag();
      coef *= velocity.dot(area);
      coef /= (2 * area.mag());
      
      van = area.copy().mult(coef);
      
      faero = van.copy().mult(-0.5 * cd);
      
      acc[i+1][j+1].sub(faero.mult(1/3));
      acc[i+1][j].sub(faero);
      acc[i][j+1].sub(faero);
      
    }
  }  
}
  
