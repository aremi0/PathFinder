public class Grid {
  Node[][] node;

  public Grid() {
    node = new Node[nR][nC];

    for (int i = 0; i < nR; i++) {
      for (int j = 0; j < nC; j++) {
        node[i][j] = new Node(i, j);
      }
    }
  }

  public void display() {
    rectMode(CORNERS);
    noStroke();
    textSize(dY*0.5);
    textAlign(CENTER, CENTER);

    for (int i = 0; i < nR; i++) {
      for (int j = 0; j < nC; j++) {
        if (!node[i][j].open)
          fill(0);
        else
          fill(node[i][j].c); 

        rect(j*dX, i*dY, (j+1)*dX-1, (i+1)*dY-1); //Disegna ogni casella
        fill(0, 0, 255);

        if (node[i][j].open) //Mostra il peso di ogni casella;
          text("" + node[i][j].peso, (2*j+1)*dX/2, (2*i+1)*dY/2);
      }
    }
  }

  public void setValues(int i, int j, int v) { //Setta la griglia dei cammini minimi su tutte le caselle, partendo da un Target (0)
    if (node[i][j].peso > v) {
      node[i][j].peso = v++;

      if ((i > 0) && (node[i-1][j].open)) setValues(i-1, j, v); //Casella sopra (se la riga è > 0)
      if ((i+1 < nR) && (node[i+1][j].open)) setValues(i+1, j, v); //Casella sopra (se la riga è < nR)
      if ((j > 0) && (node[i][j-1].open)) setValues(i, j-1, v); //Casella sinistra (se la colonna è > 0)
      if ((j+1 < nC) && (node[i][j+1].open)) setValues(i, j+1, v); //Casella destra (se la colonna è < nC)
    }
  }
  
  public ArrayList<Node> shortestPath(int i, int j){ //Ritorna la lista di nodi del cammino minimo, tra la casella selezionata ed il Target (0)
    ArrayList<Node> res = new ArrayList<Node>();
    res.add(node[i][j]); //Aggiungo il nodo di partenza
    int peso = node[i][j].peso;
    
    while(peso != 0){ //Aggiunge nodi fin tanto che non arrivo al Target (0)
      if((i > 0) && (node[i-1][j].open) && (node[i-1][j].peso < peso)){ //check casella sopra
         res.add(node[i-1][j]);
         i--; //prossima iterazione sulla casella sopra
      }
      else if((i+1 < nR) && (node[i+1][j].open) && (node[i+1][j].peso < peso)){ //check casella sotto
         res.add(node[i+1][j]);
         i++; //prossima iterazione sulla casella sopra
      }
      else if((j > 0) && (node[i][j-1].open) && (node[i][j-1].peso < peso)){ //check casella destra
         res.add(node[i][j-1]);
         j--; //prossima iterazione sulla casella destra
      }
      else if((j+1 < nC) && (node[i][j+1].open) && (node[i][j+1].peso < peso)){ //check casella sinistra
         res.add(node[i][j+1]);
         j++; //prossima iterazione sulla casella sopra
      }
      
      peso--; //perchè aggiunta ogni casella, la successiva avrà peso minore
    }
    return res;
  }
  
  public void resetColor(){
   for(int i = 0; i < nR; i++){
    for(int j = 0; j < nC; j++){
     node[i][j].c = color(255); 
    }
   }
  }
}
