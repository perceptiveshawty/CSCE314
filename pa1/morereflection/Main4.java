// Sachin Chanchani
// UIN: 828004948
// CSCE 314

 import java.lang.reflect.*;
 import java.lang.Class.*;

public class Main4 {
    public static void main(String[] args) {
      try {
        // get class from string in args
        Class<?> c = Class.forName(args[0]);

        // get list of methods
        Method[] methods = c.getDeclaredMethods();

        // for each method
          // if public static, no params, returns boolean, name starts with "test", invoke method
            // output based on method returning true or false

        for (Method m : methods) {
          if (Modifier.isStatic(m.getModifiers())
          && Modifier.isPublic(m.getModifiers())
          && m.getGenericParameterTypes().length == 0
          && m.getReturnType() == boolean.class
          && m.getName().indexOf("test") == 0) {
            boolean rtrn =  (Boolean) m.invoke(null);
            if (rtrn) {System.out.println("OK: " + m.getName() + " succeeded");}
            else {System.out.println("FAILED: " + m.getName() + " failed");}
          }

        }
      } catch (ClassNotFoundException e) {System.out.println("Error 1");}
        catch (IllegalAccessException e) {System.out.println("Error 2");}
        catch (IllegalArgumentException e) {System.out.println("Error 3");}
        catch (InvocationTargetException e) {System.out.println("Error 4");}
        catch (ArrayIndexOutOfBoundsException e) {System.out.println("Error 5");}
    }
}
