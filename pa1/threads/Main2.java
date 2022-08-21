// Sachin Chanchani
// UIN: 828004948
// CSCE 314

public class Main2 {
    public static void main(String[] args) {

        Counter counter = new Counter();
        counter.value = 0;

        Thread t1 = new counterIncrementer(counter);
        Thread t2 = new sevenSecondMessage(counter);
        Thread t3 = new fifteenSecondMessage(counter);

        t1.start();
        t2.start();
        t3.start();

    }
}

class Counter implements Runnable {
    //TODO - implement the Counter class
    public int value;
    public void run() {}

}

class counterIncrementer extends Thread {
    //TODO - implement a thread that increments the synchronized counter value every 1000ms (1 second)
    // and prints the counter value
    private Counter counter;

    public counterIncrementer(Counter c) {
      this.counter = c;
    }

    public void increment() {
      synchronized(counter) {
        ++counter.value;
        counter.notifyAll();
      }
    }

    public void run() {
      while (true) {
        increment();
        try {Thread.sleep(1000);} catch (InterruptedException e) {}
        System.out.print(counter.value + " ");
      }
    }

}

class sevenSecondMessage extends Thread {
    //TODO - implement a thread that uses the synchronized counter to print "7 second message" when counter.value % 7 == 0
    private Counter counter;

    public sevenSecondMessage(Counter c) {
      this.counter = c;
    }

    public void printSeven() {
      synchronized(counter) {
        while (counter.value % 7 != 0) {
          try {counter.wait();} catch (InterruptedException e) {}
        }
        System.out.println("\n7 second message");
        try {counter.wait();} catch (InterruptedException e) {}
      }
    }

    public void run() {
      while (true) {
        printSeven();
      }
    }
}

class fifteenSecondMessage extends Thread {
    //TODO - implement a thread that uses the synchronized counter to print "15 second message" when counter.value % 15 == 0
    private Counter counter;

    public fifteenSecondMessage(Counter c) {
      this.counter = c;
    }

    public void printFifteen() {
      synchronized(counter) {
        while (counter.value % 15 != 0) {
          try {counter.wait();} catch (InterruptedException e) {}
        }
        System.out.println("\n15 second message");
        try {counter.wait();} catch (InterruptedException e) {}
      }
    }

    public void run() {
      while (true) {
        printFifteen();
      }
    }
}
