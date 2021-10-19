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
      
      float stringF = -k*(diff.mag() - restLen);
      //println(stringF,diff.length(),restLen);
      
      // normalize stringDir
      PVector stringDir = diff.copy();
      stringDir.normalize();
      
      float projVbot = vel[i][j].dot(stringDir);
      float projVtop = vel[i+1][j].dot(stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
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
      
      float stringF = -k*(diff.mag() - restLen);
      //println(stringF,diff.length(),restLen);
      
      PVector stringDir = diff.copy();
      stringDir.normalize();
      float projVbot = vel[i][j].dot(stringDir);
      float projVtop = vel[i][j+1].dot(stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
      PVector force = stringDir.mult(stringF+dampF);
      acc[i][j].add(force.mult(-1.0/mass));
      acc[i][j+1].add(force.mult(-1.0));
    }
  }


  //Eulerian integration
  for (int i = 0; i < numRopes; i++){
    for (int j = 1; j < numNodes; j++){
      PVector dv = acc[i][j].copy();;
      vel[i][j].add(dv.mult(dt));
      PVector dp = vel[i][j].copy();;
      pos[i][j].add(dp.mult(dt));
    }
  }
   
  //Collision detection with sphere
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes; j++){
      float dist = distTo(pos[i][j], spherePos);
      if (dist < sphereR + radius) {
        PVector normal = pos[i][j].copy();
        normal.sub(spherePos);
        normal.normalize();
        
        PVector bounce = normal.copy();
        float bncStr = vel[i][j].dot(normal);
        bounce.mult(bncStr);
        
        vel[i][j].sub(bounce.mult(1.0 + COR));
        pos[i][j].add(normal.mult(sphereR - dist + 0.1));
      }
    }
  } 
}

float distTo(PVector first, PVector second) {
  return dist(first.x, first.y, first.z, second.x, second.y, second.z);
}
