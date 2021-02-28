public class Node {
  int i, j;
  int peso;
  boolean open;
  color c;

  public Node(int i, int j) {
    this.i = i;
    this.j = j;
    open = true;
    peso = nR*nC;
    c = color(255);
  }
  
  public void reset(){
    open = true;
    peso = nR*nC;
  }
}
