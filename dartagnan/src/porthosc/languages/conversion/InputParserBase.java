package porthosc.languages.conversion;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import porthosc.languages.common.InputLanguage;
import porthosc.languages.common.citation.CitationService;
import porthosc.languages.syntax.ytree.YSyntaxTree;

import java.io.File;
import java.io.IOException;


public abstract class InputParserBase {

    private final File inputFile;
    private final InputLanguage language;

    private CitationService citationService;
    private YSyntaxTree result;

    public InputParserBase(File inputFile, InputLanguage language) {
        this.inputFile = inputFile;
        this.language = language;
    }

    public YSyntaxTree parseFile() throws IOException {
        if (result == null) {
            CommonTokenStream tokenStream = InputParserFactory.getTokenStream(inputFile, language);
            citationService = new CitationService(inputFile.getAbsolutePath(), tokenStream);
            ParserRuleContext parserEntryPoint = InputParserFactory.getParser(tokenStream, language);

            InputProgramConvertersFactory convertersFactory = new InputProgramConvertersFactory(citationService);
            InputProgram2YtreeConverter transformer = convertersFactory.getConverter(language);
            result = transformer.convert(parserEntryPoint);
        }
        return result;
    }

    public CitationService getCitationService() {
        assert result != null : "'parseFile()' must been already called";
        assert citationService != null;
        return citationService;
    }
}
