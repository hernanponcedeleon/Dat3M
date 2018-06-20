package porthosc.utils.exceptions.ytree;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import porthosc.utils.AntlrUtils;
import porthosc.utils.StringUtils;


public class YParserNotImplementedException extends YParserException {

    public YParserNotImplementedException(ParserRuleContext context) {
        super(context, getErrorMessage(context));
    }

    public YParserNotImplementedException(ParserRuleContext context, String comment) {
        super(context, getErrorMessage(context) + "\n" + comment);
    }

    private static String getErrorMessage(ParserRuleContext context) {
        return context.getClass().getSimpleName() +
                ", (yet) not supported syntax: " + StringUtils.wrap(AntlrUtils.getText(context)) +
                ".\nNon-null children: " + getNonNullChildrenText(context);
    }

    // for debug only
    private static String getNonNullChildrenText(ParserRuleContext context) {
        StringBuilder sb = new StringBuilder("[");
        int count = context.children.size();
        int iteration = 0;
        for (ParseTree child : context.children) {
            if (child != null) {
                sb.append(getAntlrRuleName(child)).append(" ")
                        .append(StringUtils.wrap(child.getText()));
            }
            if (iteration++ < count) {
                sb.append(", ");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    // for pretty-print
    private static String getAntlrRuleName(ParseTree nodeContext) {
        String nodeContextText = nodeContext.getClass().getSimpleName();
        final String nodeContextName = Character.toLowerCase(nodeContextText.charAt(0)) + nodeContextText.substring(1);
        final String contextText = "Context";
        int contextIndex = nodeContextName.indexOf(contextText);
        return contextIndex > 0
                ? nodeContextName.substring(0, contextIndex)
                : nodeContextName;
    }
}
