package porthosc.utils;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;


public class AntlrUtils {
    public static String getText(ParserRuleContext ctx) {
        int a = ctx.start.getTokenIndex();
        int b = ctx.stop.getTokenIndex();
        Interval interval = new Interval(a,b);
        CharStream inputStream = ctx.start.getInputStream();
        return inputStream.getText(interval);
    }

    public static String wrap(ParserRuleContext ctx) {
        return StringUtils.wrap(getText(ctx));
    }
}
