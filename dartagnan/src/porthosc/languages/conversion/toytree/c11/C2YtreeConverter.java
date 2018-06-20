package porthosc.languages.conversion.toytree.c11;


import org.antlr.v4.runtime.ParserRuleContext;
import porthosc.languages.common.citation.CitationService;
import porthosc.languages.conversion.InputProgram2YtreeConverter;
import porthosc.languages.syntax.ytree.YSyntaxTree;


public final class C2YtreeConverter implements InputProgram2YtreeConverter {

    private final CitationService citationService;

    public C2YtreeConverter(CitationService citationService) {
        this.citationService = citationService;
    }

    public YSyntaxTree convert(ParserRuleContext mainRuleContext) {
        C2YtreeConverterVisitor visitor = new C2YtreeConverterVisitor(citationService);
        return (YSyntaxTree) mainRuleContext.accept(visitor);
    }
}
