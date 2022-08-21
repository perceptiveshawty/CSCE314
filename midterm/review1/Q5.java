import java.util.*;
import java.lang.Object.*;

public class Q5 {
  public static void main(String[] args) {
    Furniture furniture1 = new Furniture();
    CaseGoods casegoods1 = new CaseGoods();
    Chair chair1 = new Chair();
    SwivelChair swivelchair1 = new SwivelChair();

    // (A) What is a function declaration for a function, doSomething1, that could be called in the following ways:
    furniture1 = doSomething1(chair1, casegoods1);
    casegoods1 = doSomething1(swivelchair1, furniture1);

    // (B) What is a function declaration, doSomething2, that could be called in the following ways:
    Pair<Chair, CaseGoods> thing1 = new Pair<Chair, CaseGoods>();
    Pair<SwivelChair, Furniture> thing2 = new Pair<SwivelChair, Furniture>();
    doSomething2(thing1);
    doSomething2(thing2);

  }

  // (A)
  public static <T extends Chair, U extends Furniture> CaseGoods doSomething1(T o1, U o2) {
    System.out.println("succeeded 1");

    return (new CaseGoods());
  }

  // (B)
  public static void doSomething2(Pair<? extends Furniture, ? extends Furniture> sp) {
    System.out.println("succeeded 2");
  }
}

class Pair<K, V> {}

class Furniture {}
class Chair extends Furniture {}
class SwivelChair extends Chair {}
class CaseGoods extends Furniture {}
class Dresser extends CaseGoods {}
