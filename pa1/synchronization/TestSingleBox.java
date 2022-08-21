// This tests handling of one PostBox with a single producer and a single consumer.
// Also tests correct handling of sending a message to the same PostBox, and the
// order of returned messages.

import java.util.List;

public class TestSingleBox {
    private static final String NAME = "postbox";
    private static final int MAX_SIZE = 10;

    public static void main(String[] args) {

        PostBox p = new PostBox(NAME, MAX_SIZE);

        // Producer puts 10 messages into the box.
        Thread producer = new Thread(() -> {
            for (int i = 0; i < 10; ++i) {
                p.send(NAME, Integer.toString(i));
                System.out.println("Sending a message " + i);
            }
        });

        // Consumer continually reads messages into OutputList until interrupted.
        List<String> outputList = new java.util.ArrayList<String>();
        Thread consumer = new Thread(() -> {
            while (true) {
                try {
                    outputList.addAll(p.retrieve());
                    System.out.println("Retrieved");
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    return;
                }
            }
        });

        producer.setUncaughtExceptionHandler((thread, exception) -> TestUtils.exceptionHandler(thread, exception));
        consumer.setUncaughtExceptionHandler((thread, exception) -> TestUtils.exceptionHandler(thread, exception));

        producer.start();
        consumer.start();

        // Main thread waits a few seconds then stops all remaining threads
        // The producer should exit on its own
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            // Do nothing.
        }
        consumer.interrupt();
        p.stop();
        try {
            producer.join();
        } catch (InterruptedException e) {
            assert false; // should never happen
        }

        for (int i = 0; i < 10; ++i) {
            String correct = "From " + NAME + " to " + NAME + ": " + Integer.toString(i);
            if (!outputList.get(i).equals(correct)) {
                System.err.println("Test failure: output list at index " + i + " is \"" + outputList.get(i) + "\", should be \"" + correct + "\"");
                // System.exit(1);
            }
        }

        // Finally we check whether outputList is correct.
        if (outputList.size() != 10) {
            System.err.println("Test failure: the size of the output list is " + outputList.size() + ", should be 10");
            System.exit(1);
        }

        System.out.println("TestSingleBox passed");
    }
}
