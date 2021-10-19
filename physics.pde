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
  
  //Collision detection and response
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes; j++){
      if (pos[i][j].y+radius > floor){
        vel[i][j].y *= -.9;
        pos[i][j].y = floor - radius;
      }
    }
  }
  
}
