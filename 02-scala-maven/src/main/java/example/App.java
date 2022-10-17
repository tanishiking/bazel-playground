package example;

import com.typesafe.config.*;

class App {
    public static void main(String[] args) {
        Config conf = ConfigFactory.load();
        System.out.println("The answer is: " + conf.getString("simple-app.answer"));
    }
}
