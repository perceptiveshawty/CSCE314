// This test checks for proper error handling. This test passes
// if and only if Main4 runs without throwing an exception.



public class TestErrorHandling {

    // ExitException and NoExitSecurityManager are modified from here: https://stackoverflow.com/a/309427
    // This code ensures that we can continue running the test even if Main4.main
    // attempts to call System.exit.
    private static class ExitException extends SecurityException {
        private static final long serialVersionUID = 1L; // Suppress warning from javac
    }

    private static class NoExitSecurityManager extends SecurityManager {
        @Override
        public void checkPermission(java.security.Permission perm) {
            // allow anything.
        }

        @Override
        public void checkPermission(java.security.Permission perm, Object context) {
            // allow anything.
        }

        @Override
        public void checkExit(int status) {
            super.checkExit(status);
            throw new ExitException();
        }
    }

    public static void main(String[] args) {
        SecurityManager oldsm = System.getSecurityManager(); // Save this to restore it later
        System.setSecurityManager(new NoExitSecurityManager());

        boolean noExceptions = true;

        try {
            String[] localArgs = {"HasNoMethods"};
            assert localArgs.length == 1;
            Main4.main(localArgs);
        } catch (ExitException e) {
            // Do nothing.
        } catch (Exception e) {
            System.err.println("Exception when given class with no methods:");
            e.printStackTrace();
            noExceptions = false;
        }

        try {
            String[] localArgs = {};
            assert localArgs.length == 0;
            Main4.main(localArgs);
        } catch (ExitException e) {
            // Do nothing.
        } catch (Exception e) {
            System.err.println("Exception when given no command-line args:");
            e.printStackTrace();
            noExceptions = false;
        }

        try {
            String[] localArgs = {"not a class"};
            assert localArgs.length == 1;
            Main4.main(localArgs);
        } catch (ExitException e) {
            // Do nothing.
        } catch (Exception e) {
            System.err.println("Exception when given an invalid class name:");
            e.printStackTrace();
            noExceptions = false;
        }

        try {
            String[] localArgs = {"ThrowsException"};
            assert localArgs.length == 1;
            Main4.main(localArgs);
        } catch (ExitException e) {
            // Do nothing.
        } catch (Exception e) {
            System.err.println("Exception when invoking a method that throws:");
            e.printStackTrace();
            noExceptions = false;
        }

        System.setSecurityManager(oldsm);
        if (noExceptions) {
            System.out.println("TestErrorHandling passed");
        } else {
            System.out.println("TestErrorHandling failed");
            System.exit(1);
        }
    }
}

class HasNoMethods {}

class ThrowsException {
    public static boolean testThrowsException() {
        throw new RuntimeException("Hello from TestThrowsException");
    }
}
