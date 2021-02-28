public class Node {
  int i, j;
  int peso;
  boolean open;
  color c;

  public Node(int i, int j) {
    this.i = i;
    this.j = j;
    open = true;
    peso = nR*nC; //Peso di default
    c = color(255);
  }

  public void reset() {
    open = true;
    c = color(255);
    peso = nR*nC;
  }
}
