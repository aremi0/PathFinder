int nR = 25;
int nC = 25;

float dX, dY; //Larghezza e altezza della generica casella

float closedRate = 0.2; //Probabilità caselle chiuse

Grid grid;

int iTarget, jTarget;

void setup() {
  size(600, 600);

  dX = 1.0*width/nC;
  dY = 1.0*height/nR;

  grid = new Grid();

  for (int i = 0; i < nR; i++) {  //Chiudo delle caselle della griglia con una prob del 20%
    for (int j = 0; j < nC; j++) {
      if (random(1) < closedRate) {
        grid.node[i][j].open = false;
        grid.node[i][j].c = color(0);
      }
    }
  }

  iTarget = floor(random(nR));
  jTarget = floor(random(nC));
  grid.node[iTarget][jTarget].reset(); //Se il Target è un nodo chiuso, lo apro e rendo Target...
  grid.setValues(iTarget, jTarget, 0);
  grid.copy();
}

void draw() {
  background(90);
  grid.display();
}

void mousePressed() {
  int i = floor(mouseY/dY); //...
  int j = floor(mouseX/dX); //Ottengo colonna e riga della casella cliccata

  if (mouseButton == CENTER)
    grid.restore();

  if (grid.node[i][j].open) {
    if (mouseButton == LEFT) { //Cammino minimo...
      grid.restore();
      ArrayList<Node> sPath = grid.shortestPath(i, j);
      for (int ii = 0; ii < sPath.size(); ii++) {
        Node n = sPath.get(ii);
        n.c = color(ii*5, 255, ii);
      }
    } else if (mouseButton == RIGHT) { //Cammino massimo...
      ArrayList<Node> lPath = grid.longestPath(i, j);
      for (int ii = 0; ii < lPath.size(); ii++) {
        Node n = lPath.get(ii);
        n.c = color(255-(ii%2), 255-ii, 0);
      }
      Node n = lPath.get(lPath.size()-1);
      n.c = color(180, 50, 180);
    }
  }
}
