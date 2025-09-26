package pe.compendio.myandess.onboarding.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtil {

  public static String getCurrentDate_yyyyMMdd_hhmm(){
    var now= LocalDateTime.now();
    return  now.format(DateTimeFormatter.ofPattern("yyyyMMdd_hhmm"));
  }
}
