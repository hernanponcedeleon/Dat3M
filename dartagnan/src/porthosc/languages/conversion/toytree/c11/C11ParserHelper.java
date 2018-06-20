package porthosc.languages.conversion.toytree.c11;

import org.antlr.v4.runtime.ParserRuleContext;
import porthosc.languages.parsers.C11Parser;


public class C11ParserHelper {
    // TODO: check this manually-restored method
    public static boolean hasToken(ParserRuleContext ctx, int tokenType) {
        return ctx.getTokens(tokenType).size() > 0;
    }

    // TODO: check this manually-restored method
    public static boolean hasParentheses(ParserRuleContext ctx) {
        return hasToken(ctx, C11Parser.LeftParen) && hasToken(ctx, C11Parser.RightParen);
    }
}
