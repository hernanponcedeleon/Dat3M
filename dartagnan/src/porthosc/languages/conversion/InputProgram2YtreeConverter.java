package porthosc.languages.conversion;

import org.antlr.v4.runtime.ParserRuleContext;
import porthosc.languages.syntax.ytree.YSyntaxTree;


public interface InputProgram2YtreeConverter {

    YSyntaxTree convert(ParserRuleContext mainRuleContext);
}
