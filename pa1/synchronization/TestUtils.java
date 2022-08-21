// This file contains utility functions for the tests.

public class TestUtils {
    public static void pause(long n) {
        try { Thread.sleep(n); } catch (InterruptedException e) {}
    }

    // Exception handler to fail the test upon any uncaught exception
    public static void exceptionHandler(Thread t, Throwable e) {
        System.err.println("Exception in thread \"" + t.getName() + "\":");
        e.printStackTrace();
        System.err.println("");
        System.err.println("Test failed. Exiting now.");
        System.exit(2);
    }
}
