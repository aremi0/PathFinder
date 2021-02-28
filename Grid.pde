public class Grid {
  Node[][] node;
  Grid copy;

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
        fill(node[i][j].c);
        rect(j*dX, i*dY, (j+1)*dX-1, (i+1)*dY-1); //Disegna ogni casella

        fill(0, 0, 255);
        if ((node[i][j].open) || (!node[i][j].open) && (node[i][j].peso != nR*nC)) //Mostra il peso di ogni casella;
          text("" + node[i][j].peso, (2*j+1)*dX/2, (2*i+1)*dY/2);
      }
    }
  }

  public void setValues(int i, int j, int v) { //Setta la griglia dei cammini minimi su tutte le caselle aperte settate a MAX di default, partendo da un Target (0)
    if (node[i][j].peso > v) {
      node[i][j].peso = v++;

      if ((i > 0) && (node[i-1][j].open)) setValues(i-1, j, v); //Casella sopra (se la riga è > 0)
      if ((i+1 < nR) && (node[i+1][j].open)) setValues(i+1, j, v); //Casella sopra (se la riga è < nR)
      if ((j > 0) && (node[i][j-1].open)) setValues(i, j-1, v); //Casella sinistra (se la colonna è > 0)
      if ((j+1 < nC) && (node[i][j+1].open)) setValues(i, j+1, v); //Casella destra (se la colonna è < nC)
    }
  }

  public ArrayList<Node> shortestPath(int i, int j) { //Ritorna la lista di nodi del cammino minimo, tra la casella selezionata ed il Target (0)
    ArrayList<Node> res = new ArrayList<Node>();
    res.add(node[i][j]); //Aggiungo il nodo di partenza
    int peso = node[i][j].peso;

    while (peso != 0) { //Aggiunge nodi fin tanto che non arrivo al Target (0)
      if ((i > 0) && (node[i-1][j].open) && (node[i-1][j].peso < peso)) { //check casella sopra
        res.add(node[i-1][j]);
        i--; //prossima iterazione sulla casella sopra
      } else if ((i+1 < nR) && (node[i+1][j].open) && (node[i+1][j].peso < peso)) { //check casella sotto
        res.add(node[i+1][j]);
        i++; //prossima iterazione sulla casella sopra
      } else if ((j > 0) && (node[i][j-1].open) && (node[i][j-1].peso < peso)) { //check casella destra
        res.add(node[i][j-1]);
        j--; //prossima iterazione sulla casella destra
      } else if ((j+1 < nC) && (node[i][j+1].open) && (node[i][j+1].peso < peso)) { //check casella sinistra
        res.add(node[i][j+1]);
        j++; //prossima iterazione sulla casella sopra
      }

      peso--; //perchè aggiunta ogni casella, la successiva avrà peso minore
    }
    return res;
  }

  public void copy() {
    copy = new Grid();

    for (int i = 0; i < nR; i++) {
      for (int j = 0; j < nC; j++) {
        copy.node[i][j].peso = node[i][j].peso;
        copy.node[i][j].c = node[i][j].c;
        copy.node[i][j].open = node[i][j].open;
      }
    }
  }

  public void restore() {
    for (int i = 0; i < nR; i++) {
      for (int j = 0; j < nC; j++) {
        node[i][j].peso = copy.node[i][j].peso;
        node[i][j].c = copy.node[i][j].c;
        node[i][j].open = copy.node[i][j].open;
      }
    }
  }

  public void reset() { //Necessario per il ricalcolo dei pesi, perchè esso richiede che i nodi aperti abbiano il peso MAX
    for (int i = 0; i < nR; i++) {
      for (int j = 0; j < nC; j++) {
        if (node[i][j].open)
          node[i][j].peso = nR*nC;
      }
    }
  }

  public ArrayList<Node> longestPath(int i, int j) {
    ArrayList<Node> res = new ArrayList<Node>();
    res.add(node[i][j]); //Aggiungo il nodo di partenza
    ArrayList<Node> neighbors = new ArrayList<Node>();
    int max;
    int count = 0;
    Node step = null;

    node[i][j].peso = count;
    //node[i][j].c = color(255, 255, 0);

    while (!((i == iTarget) && (j == jTarget))) { //Fin quando non raggiungi il Target (0), prosegui...
      neighbors.clear();
      node[i][j].open = false; //Devo bloccare la casella per impedire che il percorso più lungo passi più volte su caselle già selezionate.
      reset();
      setValues(iTarget, jTarget, 0);
      //Mi serve ricalcolare perchè, bloccando di volta in volta le caselle, il peso delle adiacenti alla bloccata potrebbe variare...
      //In questo modo evito che si entri in un vicolo cieco. (Perchè setterà il peso delle caselle al MAX)

      //Adesso cerco tutte le caselle adiacenti (neighbors) che hanno il peso più alto
      max = 0;
      if ((i > 0) && (node[i-1][j].open) && (node[i-1][j].peso != nR*nC)) { //check casella sopra
        //Inizialmente dò per scontato che sia il massimo, poi con gli altri controlli vedo se è vero
        max = node[i-1][j].peso;
        neighbors.add(node[i-1][j]);
      }
      if ((i+1 < nR) && (node[i+1][j].open) && (node[i+1][j].peso != nR*nC) && (node[i+1][j].peso >= max)) { //check casella sotto
        if (node[i+1][j].peso > max) {
          neighbors.clear();
        }
        max = node[i+1][j].peso;
        neighbors.add(node[i+1][j]);
      }
      if ((j > 0) && (node[i][j-1].open) && (node[i][j-1].peso != nR*nC) && (node[i][j-1].peso >= max)) { //check casella destra
        if (node[i][j-1].peso > max) {
          neighbors.clear();
        }
        max = node[i][j-1].peso;
        neighbors.add(node[i][j-1]);
      }
      if ((j+1 < nC) && (node[i][j+1].open) && (node[i][j+1].peso != nR*nC) && (node[i][j+1].peso >= max)) { //check casella sinistra
        if (node[i][j+1].peso > max) {
          neighbors.clear();
        }
        neighbors.add(node[i][j+1]);
      }

      if (neighbors.size() == 1) { //Se nelle vicinanze c'è solo un nodo con valore alto, lo aggiungo a res e setto (i,j) a lui per il prossimo ciclo...
        Node n = neighbors.get(0);
        res.add(n);
        n.peso = ++count;
        //n.c = color(255, 255, 0);
        i = n.i;
        j = n.j;
      } else { //Altrimenti se ci sono più nodi asiacenti con lo stesso peso...
        //... tra questi andremo a scegliere il nodo che avrà il maggior numero di nodi adiacenti, occlusi
        max = 0;
        Node node;
        for (int k = 0; k < neighbors.size(); k++) { //alla fine "step" conterrà il prossimo nodo...
          node = neighbors.get(k);
          int cn = closedNeighbors(node);
          if (cn > max) {
            max = cn;
            step = node;
          }
        }
        res.add(step);
        step.peso = ++count;
        //step.c = color(255, 255, 0);
        i = step.i;
        j = step.j;
      }
    }

    return res;
  }

  public int closedNeighbors(Node n) { //Ritorna il numero di caselle occluse, adiacenti ad un nodo
    int res = 0;

    //Controlli sui bordi
    if (n.i == 0) res++; //Se il nodo è nella prima riga, sicuramente non possiamo accedere al nodo sopra...
    if (n.i == nR-1) res++;
    if (n.j == 0) res++;
    if (n.j == nC-1) res++; 

    //Controllo su caselle centrali
    if ((n.i > 0) && (!node[n.i-1][n.j].open)) res++; //check sopra
    if ((n.i+1 < nR) && (!node[n.i+1][n.j].open)) res++; //check sotto
    if ((n.j > 0) && (!node[n.i][n.j-1].open)) res++; //check destra
    if ((n.j+1 < nC) && (!node[n.i][n.j+1].open)) res++; //check sinistra

    return res;
  }
}
