//1D Heat Equation : du/dt = k*(d2/dx2)u
//CSCI 5611 PDE Integration [Exercise]
// Stephen J. Guy <sjguy@umn.edu>

//NOTE: The simulation begins paused, press space to un-pause it
  
//TODO:
// \ 1. Currently pressing r, prints "Resetting Simulation", but does not actually reset anything.
//    Update the code so that r actually resets the heat to its inital condition.
// \ 2. Recall the heat equation says the amount of heat will change at a rate proportional 
//    to the negative of the laplacian, confirm that it is implemented correctly here.
// \ 3. The laplacian of a function is defined by how fast the slope changes. Show that
//    the functions laplacian() and laplacian_alt() compute the same value.
// \ 4. The function colorByTemp() takes in a temperature (expected to be between 0 and 1)
//     and calls fill with a color based on that temperature. Currently colorByTemp() is
//     grayscale, change it to follow a blackbody color ramp. This is:
//        -From 0 - 0.333, interpolate from black to red
//        -From 0.333 - 0.666, interpolate from red to yellow
//        -From 0.666 - 1.0, interpolate from yellow to white
//        -You can choose any color you like for outside to 0 to 1 range (or simply
//         clamp the input to be from 0 to 1).
// \ 5. Currently, the temperature is not fixed on either end (free boundary conditions)
//     Set one end of the bar to always be a fixed temperature of 1.0.
// 6. The Stefan–Boltzmann law of evaporative cooling states that heat in a vacuum will
//     dissipate by a rate proportional to heat^4. Add a Stefan–Boltzmann evaporative 
//     cooling term to the simulated used in the PDE.
// 7. How does the final state of the system compare with a cooling rate k=0 vs k=1 vs k = 100

// Challenge:
//  -Allow the user to set hot spots using their mouse or keyboard.
//  -Why is the weight factor, alpha, multiplied by n?
//   (Hint: How might you simulate a longer bar with n slices?)
//  -Try midpoint integration, is it any more stable?

static int n = 20;
float dx = 400/n;
float dy = 40;
float h[] = new float[n];
float hu[] = new float[n];

// store midpoints
float h_mid[] = new float[n];
float hu_mid[] = new float[n];
float dhdt_mid[] = new float[n]; //Height (midpoint)
float dhudt_mid[] = new float[n]; //Momentum (mid)

float alpha = 1000*n; 

float k = 50;

//Set up screen and initial conditions
String windowTitle = "Fluid Simulation";
void setup(){
  size(600, 300);
  //Initial height distribution
  for (int i = 0; i < n; i++){ //TODO: Try different initial conditions
    h[i] = i/(float)n;
  }
}

//TODO: Change me to a blackbody color ramp
void colorByTemp(float u){
//        -From 0 - 0.333, interpolate from black to red
//        -From 0.333 - 0.666, interpolate from red to yellow
//        -From 0.666 - 1.0, interpolate from yellow to white
  float r, g, b;
  if (u < 0.333) {
    r = u/0.333;
    g = 0;
    b = 0;
  } else if (u < 0.666) {
    r = 1;
    g = (u-0.333)/0.333;
    b = 0;
  } else {
    r = 1;
    g = 1;
    b = (u-0.666)/0.333;
    if (b > 1) b = 1;
  }
  fill(255*r,255*g,255*b);
}

//Red for positive values, blue for negative ones.
void redBlue(float u){
  if (u < 0)
    fill(0,0,-255*u);
  else
    fill(255*u,0,0);
}

void update(float dt){
  //use eulerian integration
  for (int i = 1; i < n-1; i++){
    h_mid[i] = (h[i+1]+h[i])/2;
    hu_mid[i] = (hu[i+1]+hu[i])/2;
    
    //Compute dh/dt (mid)
    float dhudx_mid = (hu[i+1] - hu[i])/dx;
    dhdt_mid[i] = -dhudx_mid;
    //Compute dhu/dt (mid)   
    dhu2dx_mid = (sq(hu[i+1])/h[i+1] -sq(hu[i])/h[i])/dx;
    dgh2dx_mid = g*(sq(h[i+1]) - sq(h[i]))/dx;
    dhudt_mid[i] = -(dhu2dx_mid + .5*dgh2dx_mid);
    
    h[i] += dhdt*dt;
    hu[i] += dhudt*dt;
  }
  
}

boolean paused = true;
void draw() {
  background(200,200,200);
  
  float dt = 0.0002;
  for (int i = 0; i < 20; i++){
    if (!paused) update(dt);
  }
    
  //Draw Heat
  fill(0);
  text("Heat:", 50, 105);
  noStroke();
  for (int i = 0; i < n; i++){
    colorByTemp(heat[i]);
    pushMatrix();
    translate(100+dx*i,100+0);
    beginShape();
    vertex(-dx/2, -dy/2);
    vertex(dx/2, -dy/2);
    vertex(dx/2, dy/2);
    vertex(-dx/2, dy/2);
    endShape();
    popMatrix();
  }
  noFill();
  stroke(1);
  rect(100-dx/2,100-dy/2,n*dx,dy);
  
  //Draw derivative (dHeat/dt)
  fill(0);
  text("Derivative:", 22, 205);
  noStroke();
  for (int i = 0; i < n; i++){
    redBlue(4*dheat_dt[i]);
    pushMatrix();
    translate(100+dx*i,200+0);
    beginShape();
    vertex(-dx/2, -dy/2);
    vertex(dx/2, -dy/2);
    vertex(dx/2, dy/2);
    vertex(-dx/2, dy/2);
    endShape();
    popMatrix();
  }
  noFill();
  stroke(1);
  rect(100-dx/2,200-dy/2,n*dx,dy);
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

void keyPressed(){
  if (key == 'r'){
    for (int i = 0; i < n; i++){ //TODO: Try different initial conditions
      heat[i] = i/(float)n;
    }
    println("Resetting Simulation");
  }
  else {
    paused = !paused;
  }
}
