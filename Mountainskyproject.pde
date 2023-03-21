float move = 0;
Sky sky = new Sky();
Mountain mountain1 = new Mountain(1);        // input 1 == farthest
Mountain mountain2 = new Mountain(2);
Mountain mountain3 = new Mountain(3);        // input 3 == closest

void setup() {
  size(800, 600);
}

void draw() {
  background(255);
  sky.display();
  noiseDetail(4);
  mountain1.display();
  mountain2.display();
  mountain3.display();
  move += 0.03;//moves clouds to the left
}

void mousePressed() {
  sky.reset();
  mountain1.reset(); 
  mountain2.reset(); 
  mountain3.reset();
}

class Sky {
  color blue, orange, white;
  Sky(){
    blue = color(100,100,255);
    white = color(255);
    orange = color(255,149,6);
  }
  void display(){
    loadPixels();
    for(int x = 0; x < width; x++){//loop through canvas
      for(int y = 0; y < 0.7*height; y++){
        int index = y*width + x;
        float frac = map(y, 0, 0.7*height, 0, 1);//more orange as y increases
        color sunset = lerpColor(blue, orange, pow(frac,0.7));//power of 0.7 seems to be a good gradient for a sunset
        float n = noise(x/100.0 + move, y/100.0);//add to x value to move clouds to the left
        color c = lerpColor(white, sunset, pow(n,0.3));//power of 0.3 ensures there aren't too many clouds
        pixels[index] = c;
      }
    }
    updatePixels();
  }
  void reset(){
    move += 100;//changes where the computer is sampling the noise curve when mouse is clicked
  }
}

class Mountain {
  color brown, darkbrown, darkerbrown, black, brownc;
  float yheight, offset;
  int type;
  Mountain(int _type){
    black = color(0,0,0);
    brown = color(180,82,45);
    darkbrown = color(139,69,19);
    darkerbrown = color(101,67,33);
    type = _type;//three mountains
    offset = random(0, 1000);
  }
  void display(){
    if(type == 1){
      yheight = 0.1;
      brownc = brown;
    }
    if(type == 2){
      yheight = 0.3;
      brownc = darkbrown;
    }
    if(type==3){
      yheight = 0.5;
      brownc = darkerbrown;//closer mountains are darker and shorter
    }
    loadPixels();
    for(int x = 0; x < width; x++){
      float n = noise(x/150.0 + offset);//offset changes the sample of the noise curve for each mountain
      int ytop = int(map(n, 0, 1, yheight * height, 0.7*height)); 
    for(int y = ytop; y < height; y++){//loop through top of mountain to the bottom
      int index = y*width + x;
      float frac = map(y, ytop, height, 0, 1);
      color c = lerpColor(brownc, black, frac);//darker as y increases
      pixels[index] = c;
    }
    }
    updatePixels();
  }
  void reset(){
    offset += 100;//changes sample of noise curve when mouse is clicked
  }
}
