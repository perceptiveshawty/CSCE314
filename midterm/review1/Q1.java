// Question 1 - Interfaces

public class Q1 {
  public static void main(String[] args) {

    Royalty king = new Royalty();
    Lawyer defender = new Lawyer("Vinny");
    Judge districtjudge = new Judge("Judy");

    king.setName("Arthur");

    printgreeting(king);
    printgreeting(districtjudge);
    printgreeting(defender);
  }

  public static void printgreeting(Greetable g) {
    System.out.println(g.formal() + g.informal());
  }
}

interface Greetable {

  public void setName(String n);
  public String formal();
  public String informal();

}

class Royalty implements Greetable {
  // override interface methods
  String name;

  public Royalty() {}

  public Royalty(String n) {
    name = n;
  }

  public void setName(String n) {
    name = n;
  }

  public String formal() {
    return "Your Highness ";
  }

  public String informal() {
    return name;
  }

}

class Lawyer implements Greetable {
  // override
  String name;

  public Lawyer() {}

  public Lawyer(String n) {
    name = n;
  }

  public void setName(String n) {
    name = n;
  }

  public String formal() {
    return "Attorney ";
  }

  public String informal() {
    return name;
  }
}

class Judge extends Lawyer implements Greetable  {
  // override
  // String name = super.name;

  // extended classes can have two versions of same member - this.x and super.x

  public Judge() {super();}
  public Judge(String n) {super.name = n;}

  public String formal() {
    return "Your Honor ";
  }
}
