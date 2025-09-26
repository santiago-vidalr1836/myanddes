package pe.compendio.myandess.onboarding.util;

import org.springframework.stereotype.Component;

import java.util.GregorianCalendar;

@Component
public class RandomUtil {
  public static String text(int size) {
    String password = "";
    long ms = new GregorianCalendar().getTimeInMillis();
    java.util.Random r = new java.util.Random(ms);
    int i = 0;

    while (i < size) {
      char c = (char) r.nextInt(255);
      if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')) {
        password += c;
        i++;
      }
    }
    return password;
  }
}
