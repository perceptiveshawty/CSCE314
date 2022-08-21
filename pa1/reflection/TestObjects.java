// This test checks for proper handling of non-primitive types and private methods.

public class TestObjects {
    public static void main(String[] args) {
        MethodsForTest m = new MethodsForTest();
        Main3.displayMethodInfo(m);
        B b = new B();
        Main3.displayMethodInfo(b);
    }
}

class MethodsForTest {
    static void method1() {}

    public B method2(int a, B b, double c) {return b;}

    private Object method3(String s) {return s;}
}

class B {}
