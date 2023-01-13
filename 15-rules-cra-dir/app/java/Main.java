package example;

import java.net.URL;

public class Main {
   public static void main(String[] args) throws Exception {
      Main c = new Main();
      Class cls = c.getClass();

      URL url = cls.getResource("/build/index.html");
      System.out.println(url);
   }
}
