static int n = 200;
float dx = 400/n;
float dy = 40;

// keep track of heights and momentum
float h[] = new float[n];
float hu[] = new float[n];
float dhdt[] = new float[n]; //Height (midpoint)
float dhudt[] = new float[n]; //Momentum (mid)

// store midpoints
float h_mid[] = new float[n];
float hu_mid[] = new float[n];
float dhdt_mid[] = new float[n]; //Height (midpoint)
float dhudt_mid[] = new float[n]; //Momentum (mid)

// other parameteres
float damp = 0.5;
float k = 50;
float g = 100;

//Set up screen and initial conditions
String windowTitle = "Fluid Simulation";
void setup(){
  size(600, 600);
  //Initial height distribution
  for (int i = 0; i < n; i++){
    h[i] = 200 + 50*sin(2*3.14159265*i/(n));
  }
}


void update(float dt){
  //Compute midpoint heights and momentums
  for (int i = 0; i < n-1; i++){ 
    h_mid[i] = (h[i+1]+h[i])/2;
    hu_mid[i] = (hu[i+1]+hu[i])/2;
  }
  
  for (int i = 1; i < n-1; i++){
    //Compute dh/dt (mid)
    float dhudx_mid = (hu[i+1] - hu[i])/dx;
    dhdt_mid[i] = -dhudx_mid;
    //Compute dhu/dt (mid)   
    float dhu2dx_mid = (squ(hu[i+1])/h[i+1] - squ(hu[i])/h[i])/dx;
    float dgh2dx_mid = g*(squ(h[i+1]) -squ(h[i]))/dx;
    dhudt_mid[i] = -(dhu2dx_mid + .5*dgh2dx_mid);
  }
  
  for (int i = 1; i < n-1; i++){
    h_mid[i] += dhdt_mid[i]*dt/2;
    hu_mid[i] += dhudt_mid[i]*dt/2;
  }
  
  for (int i = 1; i < n-1; i++){
    //Compute dh/dt
    float dhudx = (hu_mid[i] - hu_mid[i-1])/dx;
    dhdt[i] = -dhudx;
    //Compute dhu/dt
    float dhu2dx = (squ(hu_mid[i])/h_mid[i] - squ(hu_mid[i-1])/h_mid[i-1])/dx;
    float dgh2dx = g*(squ(h_mid[i]) - squ(h_mid[i-1]))/dx;
    dhudt[i] = -(dhu2dx + .5*dgh2dx);
  }
  
  //Impose reflective Bounardy Conditions
  h[0] = h[1];
  h[n-1] = h[n-2];
  hu[0] = -hu[1];
  hu[n-1] = -hu[n-2];
  
  
  //Integrate heights and momentum
  for (int i = 0; i < n-1; i++){
    h[i] += damp*dhdt[i]*dt;
    hu[i] += damp*dhudt[i]*dt;
  }
  
}

boolean paused = true;
void draw() {
  background(255);
  
  float dt = 0.001;
  float sim_dt = 0.000005;
  for (int i = 0; i < int(dt/sim_dt); i++){
    if (!paused) update(dt);
  }
    
  fill(0, 0, 255);
  stroke(0, 0, 255);
  for (int i = 0; i < n; i++) {
    rect(10 + i*580/n, 600 - h[i], 581/n, h[i]);
  }
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

float squ(float x) {
  return x*x;
}

void keyPressed(){
  if (key == 'r'){
    setup();
    println("Resetting Simulation");
  }
  if (key == ' ') {
    paused = !paused;
  }
}
