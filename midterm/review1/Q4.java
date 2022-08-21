//  Question 4 - Threads/Synchronisation/Runnables

import java.util.*;

public class Main {
  // These can be accessed from other functions as Main.mylock,
  // Main.cond, Main.trophies
  final public static Lock mylock = new ReentrantLock();
  final public static Condition cond = mylock.newCondition();
  public static int trophies;

  public static void main(String[] args) {
    // This is a 2-player situation
    Player p1 = new Player();
    Player p2 = new Player();
    // Stuff here to initialize players

    Manager m = new Manager();
    // Stuff here to initialize game manager

    PlayerRunnable pr1 = new PlayerRunnable(p1);
    PlayerRunnable pr2 = new PlayerRunnable(p2);

    Thread t1 = new Thread(pr1);
    Thread t2 = new Thread(pr1);

    t1.start();
    t2.start();
    m.start();
  }
}

/*
(a) Show how you would write the PlayerRunnable class, such that in each thread, as long
as the player is alive, we will get a player move, evaluate the result of that move, and award
some number of trophies. [6 points]
*/

class PlayerRunnable implements Runnable {
  private Player player;

  public PlayerRunnable(Player p) {
    this.player = p;
  }

  public void run() {
    while (player.isAlive()) {
      player.awardTrophies(player.getResult(player.getMove()));
    }
  }
}

// (c) Create a game manager class, called Manager, that includes routines awardBonus and
// increaseLevel.
// (i) Show the header for the Manager class. [3 points]
// (ii) Show the run routine that must be created in Manager so that the awardBonus and
// increaseLevel methods are called at the appropriate point times. Note that this
// might require changes to the awardTrophies command in the Player class — you
// may show a modified Player class. [8 points]

class Manager extends Thread {
  // Some attributes, constructors, methods, etc. defined here
  public Manager() {}

  public void awardBonus() {
    synchronized(trophies) {
      while (trophies % 1000 != 0 && trophies != 0) {
        try {trophies.wait();} catch (InterruptedException e) {}
      }
      trophies += 1000;
      try {trophies.wait();} catch (InterruptedException e) {}
    }
  }

  public void run() {
    while (true) {
      awardBonus();
    }
  }

}


public class Player {
  // Some attributes, constructors, methods, etc. defined here
  Player() {}

  public boolean isAlive() {
    //... This returns true if the player is alive
  }

  public Move getMove() {
    //... This gets a move from a user
  }

  public int getResult(Move nextmove) {
    //... This returns the number of trophies the move resulted in
  }

/*
Give an implementation of awardTrophies that will avoid race conditions. Your implementation of awardTrophies should increase the number of shared trophies by the amount
passed in as a parameter. [5 points]
*/

  public void awardTrophies(int numtrophies) {
    synchronized(trophies) {
      trophies += numtrophies;
      trophies.notifyAll();
      try {Thread.sleep(250);} catch (InterruptedException e) {}
    }
  }
}
