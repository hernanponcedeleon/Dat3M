package porthosc.languages.common.citation;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;


public class CitationService {

    private final String file;
    private final CommonTokenStream input;

    public CitationService(String file, CommonTokenStream input) {
        this.file = file;
        this.input = input;
    }

    public Origin getLocation(ParserRuleContext ctx) {
        int start = ctx.getStart().getTokenIndex();
        int stop = ctx.stop.getTokenIndex();
        return new Origin(file, start, stop);
    }

    public String getCitation(Origin origin) {
        Interval interval = new Interval(origin.start(), origin.end());
        return input.getText(interval);
    }
}
