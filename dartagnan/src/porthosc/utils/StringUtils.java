package porthosc.utils;

import java.util.Map;


public class StringUtils {
    public static String nonNull(String value) {
        if (value == null) {
            return "";
        }
        return value;
    }

    public static <T> String wrap(T value) {
        return wrap(value.toString());
    }

    public static String wrap(String value) {
        return "`" + value + "'";
    }

    public static <T> String jsonSerialize(Map<? extends T, ? extends T> map) {
        int decreasingCounter = map.size() - 1;
        StringBuilder sb = new StringBuilder("[");
        for (Map.Entry<? extends T, ? extends T> entry : map.entrySet()) {
            sb.append(wrap(entry.getKey())).append("->").append(wrap(entry.getValue()));
            if ((decreasingCounter--) >= 0) {
                sb.append(" , ");
            }
        }
        sb.append("]");
        return sb.toString();
    }
}
