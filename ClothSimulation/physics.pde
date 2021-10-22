void clothPhysics(float dt) {

  //Reset accelerations each multtep (momenum only applies to velocity)
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes; j++){
      acc[i][j] = new PVector(0,0,0);
      acc[i][j].add(gravity);
    }
  }
  
  
  //Compute (damped) Hooke's law for each rope horizontally
  for (int i = 0; i < numRopes-1; i++){
    for (int j = 0; j < numNodes; j++){
      // get the vector connecting one rope to next rope
      PVector diff = pos[i+1][j].copy();
      diff.sub(pos[i][j]);
      
      // diff.mag() is the length of the vector
      // println(diff.mag());
      
      float stringF = -kHoriz*(diff.mag() - restLenRope);
      //println(stringF,diff.length(),restLenRope);
      
      // normalize stringDir
      PVector stringDir = diff.copy();
      stringDir.normalize();
      
      float projVbot = vel[i][j].dot(stringDir);
      float projVtop = vel[i+1][j].dot(stringDir);
      float dampF = -kvHoriz*(projVtop - projVbot);
      
      PVector force = stringDir.mult(stringF+dampF);
      acc[i][j].add(force.mult(-1.0/mass));
      acc[i+1][j].add(force.mult(-1.0));
    }
  }
  
  //Compute (damped) Hooke's law for each rope vertically
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes-1; j++){
      PVector diff = pos[i][j+1].copy();
      diff.sub(pos[i][j]);
      
      float stringF = -kVert*(diff.mag() - restLenNode);
      //println(stringF,diff.length(),restLenNode);
      
      PVector stringDir = diff.copy();
      stringDir.normalize();
      float projVbot = vel[i][j].dot(stringDir);
      float projVtop = vel[i][j+1].dot(stringDir);
      float dampF = -kvVert*(projVtop - projVbot);
      
      PVector force = stringDir.mult(stringF+dampF);
      acc[i][j].add(force.mult(-1.0/mass));
      acc[i][j+1].add(force.mult(-1.0));
    }
  }
  

   PVector velocity = new PVector (0,0,0);
  println(acc[20][20]);
  for (int i = 0; i < numRopes-1; i++){
    for (int j = 0; j < numNodes-1; j++){
      PVector area;
      PVector vAir = new PVector(0, 0, -1.0);
      PVector normal;
      PVector van;
      PVector faero;
      float coef;
      
      velocity = (vel[i][j].copy().add(vel[i+1][j]).add(vel[i][j+1]));
      velocity.mult(1.0/3.0);
      velocity.sub(vAir);
      //println(vel[i][j].copy().add(vel[i+1][j]).add(vel[i][j+1]));
      
      
      PVector v1 = pos[i][j+1].copy();
      PVector v2 = pos[i+1][j].copy();
      v1.sub(pos[i][j]);
      v2.sub(pos[i][j]);
      
      area = v1.cross(v2);
      
      normal = area.copy().div(area.mag());
      
      coef = velocity.mag();
      coef *= velocity.dot(area);
      coef /= (2.0 * area.mag());
      
      van = area.copy().mult(coef);
      
      faero = van.copy().mult(-0.5 * cd);
      
      faero.div(mass);
      
      acc[i][j].sub(faero.mult(1.0/3.0));
      acc[i+1][j].sub(faero);
      acc[i][j+1].sub(faero);
      
      
      //finding second triangle
      
      velocity = (vel[i+1][j].copy().add(vel[i+1][j+1]).add(vel[i][j+1])).mult(1.0/3.0).sub(vAir);
      
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
      
      faero.div(mass);
      
      acc[i+1][j+1].sub(faero.mult(1.0/3.0));
      acc[i+1][j].sub(faero);
      acc[i][j+1].sub(faero);
      
    }
  }  
  //println(velocity);
  println(acc[20][20]);



  /*
  //Eulerian integration
  for (int i = 0; i < numRopes; i++){
    for (int j = 1; j < numNodes; j++){
      PVector dv = acc[i][j].copy();
      vel[i][j].add(dv.mult(dt));
      PVector dp = vel[i][j].copy();
      pos[i][j].add(dp.mult(dt));
    }
  }
  */

  //Midpoint integration
  for (int i = 0; i < numRopes; i++){
    for (int j = 1; j < numNodes; j++){
      PVector dv = acc[i][j].copy();
      vel[i][j].add(dv.mult(dt));
      PVector dp = vel[i][j].copy();
      pos[i][j].add(dp.mult(dt));
      pos[i][j].add(dv.mult(0.5*dt));
    }
  }
  
  
   
  //Collision detection with sphere
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes; j++){
      float dist = distTo(pos[i][j], spherePos);
      // PVector dist = pos[i][j].copy();
      // dist.sub(spherePos);
      if (dist < sphereR + radius + offset) {
      // if (dist.mag() < sphereR + radius + 0.5 && dist.y < 0) {
        PVector normal = pos[i][j].copy();
        normal.sub(spherePos);
        normal.normalize();
        
        PVector bounce = normal.copy();
        float bncStr = vel[i][j].dot(normal);
        bounce.mult(bncStr);
        
        vel[i][j].sub(bounce.mult(1.0 + COR));
        pos[i][j].add(normal.mult(sphereR - dist + radius + offset + 0.1));
        // pos[i][j].add(normal.mult(sphereR - dist.mag() + 0.6));
      }
    }
  } 
}

float distTo(PVector first, PVector second) {
  return dist(first.x, first.y, first.z, second.x, second.y, second.z);
}
