// Sachin Chanchani
// UIN: 828004948
// CSCE 314

import java.lang.Class.*;
import java.lang.reflect.*;

public class Main3 {
    public static void main(String args[]) {
        displayMethodInfo(new A());
    }

    public static void displayMethodInfo(Object obj) {
        //TODO - Implement the method displayMethodInfo
        // 1. get name of method to string
        // 2. get declaring class IFF not static
        // 3. get parameter types
        // 4. get return type
        Method[] methods = obj.getClass().getDeclaredMethods();
        for (Method m : methods) {
          String methodInfo = "";

          methodInfo += m.getName();
          methodInfo += " (";
          methodInfo += declaringClassToString(m);

          for (Type t : m.getGenericParameterTypes()) {
            if (t != m.getGenericParameterTypes()[m.getGenericParameterTypes().length - 1]) {
              methodInfo += t.getTypeName();
              methodInfo += ", ";
            } else {
              methodInfo += t.getTypeName();
            }
          }

          methodInfo += ") -> ";

          methodInfo += m.getReturnType().getName();
          System.out.println(methodInfo);
        }
    }

    private static String declaringClassToString(Method m) {
      if (!Modifier.isStatic(m.getModifiers())) {
        return m.getDeclaringClass().getName() + ", ";
      }
      return "";
    }

    public boolean areRelatedAtDist(String o1, String o2, int k) {
      Class<?> c1 = Class.forName(o1);
      Class<?> c2 = Class.forName(o2);

      Class<? super c1> kthSuperc1 = c1;
      Class<? extends c1> kthSubc1 = c1;

      Class<? super c2> kthSuperc2 = c2;
      Class<? extends c2> kthSubc2 = c2;

      for (int i = 0, i < k; ++i) {
        kthSuperc1 = kthSuperc1.getSuperClass();
        kthSubc1 = kthSubc1.getSubClass();

        kthSuperc2 = kthSuperc2.getSuperClass();
        kthSubc2 = kthSubc2.getSuperClass();
      }

      if (c1 == kthSuperc2 || c1 == kthSubc2 || c2 == kthSuperc1 || c2 == kthSubc1) {
        return true;
      }

      return false;
    }

}

class A  {
    //TODO - Implement class A
    void foo(int a, double b) {return;}
    int bar(int c, double d, int e) {return 1;}
    static double doo() {return 2.1;}
}
