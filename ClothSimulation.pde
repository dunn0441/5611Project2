Camera camera;

//Create Window
String windowTitle = "Swinging Rope";
void setup() {
  size(600, 600, P3D);
  camera = new Camera();
  surface.setTitle(windowTitle);
  initScene();
}

//Simulation Parameters
float sphereR = 20;
float COR = 0.8;
PVector spherePos = new PVector(60,40,20);
PVector gravity = new PVector(0,100,0);
// PVector gravity = new PVector(0,400,0);
float radius = 1;
PVector stringTop = new PVector(0,0,0);
float restLenNode = 2;
float restLenRope = 4;
float mass = 1.0; //TRY-IT: How does changing mass affect resting length of the rope?
float k = 500; //TRY-IT: How does changing k affect resting length of the rope?
float kv = 250; //TRY-IT: How big can you make kv?
float offset = 2;

//Initial positions and velocities of masses
static int maxRopes = 100;
static int maxNodes = 100;
PVector pos[][] = new PVector[maxRopes][maxNodes];
PVector vel[][] = new PVector[maxRopes][maxNodes];
PVector acc[][] = new PVector[maxRopes][maxNodes];

// number of ropes and nodes in each rope
int numRopes = 30;
int numNodes = 20;

void initScene(){
  
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes; j++){
      pos[i][j] = new PVector(0,0,0);
      pos[i][j].x = stringTop.x + restLenRope*i; // push each node to the side a little
      pos[i][j].z = stringTop.z + restLenNode*j; //Make each node a little lower
      vel[i][j] = new PVector(0,0,0);
    }
  }
}

void update(float dt){
  clothPhysics(dt);
}

//Draw the scene: one sphere per mass, one line connecting each pair
boolean paused = true;
void draw() {
  background(255,255,255);
  noLights();

  camera.Update(1.0/(frameRate));
  
  if (!paused) {
    for (int i = 0; i < 20; i++) {
      update(1/(20*frameRate));
    }
  }
  fill(0,0,0);
  
  /*
  for (int i = 0; i < numRopes; i++){
    for (int j = 0; j < numNodes-1; j++){
      pushMatrix();
      line(pos[i][j].x,pos[i][j].y,pos[i][j].z,pos[i][j+1].x,pos[i][j+1].y,pos[i][j+1].z);
      translate(pos[i][j+1].x,pos[i][j+1].y,pos[i][j+1].z);
      sphere(radius);
      popMatrix();
    }
  }
  */
   
  fill( 0, 0, 255 );
  pushMatrix();
  translate( spherePos.x, spherePos.y, spherePos.z );
  sphere( sphereR );
  popMatrix(); 
  
  // color in the cloth
  createTri();
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

void keyPressed(){
  if (key == ' ')
    paused = !paused;
  if (key == 'p') {
    initScene();
    paused = true;
  }
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
