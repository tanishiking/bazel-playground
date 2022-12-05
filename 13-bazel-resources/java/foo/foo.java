package foo;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class foo {
    public static void main(String args[]) throws IOException {
        InputStream is = foo.class.getResourceAsStream("/foo/resources/a.txt");
        String text = new String(is.readAllBytes(), StandardCharsets.UTF_8);
        System.out.println(text);
    }
}
