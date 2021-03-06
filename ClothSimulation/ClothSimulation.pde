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
PVector spherePos = new PVector(60, 60, 25);//(60,40,20);
PVector gravity = new PVector(0, 100, 0); //100
// PVector gravity = new PVector(0,400,0);
float radius = 1.0;
PVector stringTop = new PVector(0, 0, 0);
float restLenNode = 2;
float restLenRope = 2;
float mass = 0.05;
float kHoriz = 40;
float kVert = 40;
float kvHoriz = 20; 
float kvVert = 20;
float offset = 0.1;
float cd = 0.001;
//float cd = 0;

//Initial positions and velocities of masses
static int maxRopes = 100;
static int maxNodes = 100;
PVector pos[][] = new PVector[maxRopes][maxNodes];
PVector vel[][] = new PVector[maxRopes][maxNodes];
PVector acc[][] = new PVector[maxRopes][maxNodes];

// number of ropes and nodes in each rope
int numRopes = 50;
int numNodes = 25;

void initScene() {

  for (int i = 0; i < numRopes; i++) {
    for (int j = 0; j < numNodes; j++) {
      pos[i][j] = new PVector(0, 0, 0);
      pos[i][j].x = stringTop.x + restLenRope*i; // push each node to the side a little
      pos[i][j].z = stringTop.z + restLenNode*j; //Make each node a little lower
      vel[i][j] = new PVector(0, 0, 0);
    }
  }
}

void update(float dt) {
  clothPhysics(dt);
}

//Draw the scene: one sphere per mass, one line connecting each pair
boolean paused = true;
PImage cat;
void draw() {
  // got this image at website https://www.theguardian.com/lifeandstyle/2020/sep/05/what-cats-mean-by-miaow-japans-pet-guru-knows-just-what-your-feline-friend-wants
  cat = loadImage("cat.jpg");
  background(255, 255, 255);
  //lights();
  ambientLight(128, 128, 128);
  directionalLight(128, 128, 128, 2, -1, 0);
  lightFalloff(1, 0, 0);
  lightSpecular(0, 0, 0);

  camera.Update(1.0/(frameRate));

  if (!paused) {
    for (int i = 0; i < 120; i++) {
      update(1.0/(120*frameRate)); //20
    }
  }
  
  // create cloth
  createTri();

  fill(#CC90F2);
  pushMatrix();
  translate( spherePos.x, spherePos.y, spherePos.z );
  noStroke();
  sphere( sphereR );
  popMatrix(); 

  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate, 0, 2) + "FPS");
}

void keyPressed() {
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
