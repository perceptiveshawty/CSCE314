// This tests proper synchronization between two threads that go back and forth.
// TestSync expects your formatted message to include the actual payload at the
// end of the string.

import java.util.List;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.concurrent.atomic.AtomicInteger;

public class TestSync {
    private static final int NUMITERS = 20;
    private static final int MAX_SIZE = 10;

    private static void exitMsg(String msg) {
        System.err.println(msg);
        System.exit(1);
    }

    // Given a String where the last word is an int, return that int.
    private static int extractInt(String s) {
        Scanner sc = new Scanner(s);
        Integer lastInt = null; // Last int in the string
        while (sc.hasNext()) {
            if (sc.hasNextInt()) {
                lastInt = sc.nextInt();
            } else {
                sc.next();
            }
        }
        if (lastInt == null) {
            exitMsg("Test failure: string without an int given to extractInt.");
        }
        return lastInt;
    }

    public static void main (String[] args) throws InterruptedException {
        PostBox box1 = new PostBox("thread1", MAX_SIZE);
        PostBox box2 = new PostBox("thread2", MAX_SIZE, box1);
        AtomicInteger count1 = new AtomicInteger(0); // Number of messages received
        AtomicInteger count2 = new AtomicInteger(0);

        // The threads will send messages back and forth:
        // 1, 3, 5, 7, ..., 77, 79

        Thread thread1 = new Thread(() -> {
            int cur = 1;
            for (int i = 0; i < NUMITERS; ++i) {
                // we add a space here to ensure proper tokenization by the Scanner
                box1.send("thread2", " " + Integer.toString(cur));
                // Wait until we receive one response
                List<String> msgs;
                for (msgs = box1.retrieve(); msgs.size() < 1; msgs = box1.retrieve()) {
                    TestUtils.pause(50);
                }
                if (msgs.size() != 1) {
                    exitMsg("Test failure: thread 1 retrieved " + msgs.size() + " messages");
                }
                count1.incrementAndGet();
                int recv = extractInt(msgs.get(0));
                System.out.println("thread 1 received " + recv);
                if (recv != cur + 2) {
                    exitMsg("Test failure: thread 1 expected " + (cur+2) + " but received " + recv);
                }
                cur = recv + 2;
            }
        });

        Thread thread2 = new Thread(() -> {
            for (int i = 0; i < NUMITERS; ++i) {
                // Wait to receive one message
                List<String> msgs;
                for (msgs = box2.retrieve(); msgs.size() < 1; msgs = box2.retrieve()) {
                    TestUtils.pause(75);
                }
                if (msgs.size() != 1) {
                    exitMsg("Test failure: thread 2 retrieved " + msgs.size() + " messages");
                }
                count2.incrementAndGet();
                int recv = extractInt(msgs.get(0));
                System.out.println("thread 2 received " + recv);
                int expected = (4 * i) + 1;
                if (recv != expected) {
                    exitMsg("Test failure: thread 2 expected " + expected + " but received " + recv);
                }

                box2.send("thread1", " " + (recv + 2));
            }
        });

        thread1.setUncaughtExceptionHandler((thread, exception) -> TestUtils.exceptionHandler(thread, exception));
        thread2.setUncaughtExceptionHandler((thread, exception) -> TestUtils.exceptionHandler(thread, exception));

        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();

        box1.stop();
        box2.stop();

        if (count1.get() != NUMITERS) {
            exitMsg("Test failure: thread 1 only received " + count1.get() + " messages");
        }
        if (count2.get() != NUMITERS) {
            exitMsg("Test failure: thread 2 only received " + count2.get() + " messages");
        }
        System.out.println("TestSync passed");
    }
}
