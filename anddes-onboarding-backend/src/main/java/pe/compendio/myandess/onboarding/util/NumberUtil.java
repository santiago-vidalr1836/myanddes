package pe.compendio.myandess.onboarding.util;

import java.util.Objects;

public class NumberUtil {

    public static String formatNoDecimal(Double valor) {
        if(Objects.isNull(valor)) return "";
        return String.valueOf((int)Math.round(valor));
    }
}
