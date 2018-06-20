package porthosc.languages.conversion;

import porthosc.languages.common.InputLanguage;
import porthosc.languages.common.citation.CitationService;
import porthosc.languages.conversion.toytree.c11.C2YtreeConverter;


public class InputProgramConvertersFactory {

    private final CitationService citationService;

    public InputProgramConvertersFactory(CitationService citationService) {
        this.citationService = citationService;
    }

    public InputProgram2YtreeConverter getConverter(InputLanguage inputLanguage) {
        switch (inputLanguage) {
            case C11:
                return new C2YtreeConverter(citationService);
            //case Porthos:
            //    return new PorthosToYtreeTransformer();
            //case Litmus:
            //    throw new NotImplementedException();
            case Cat:
                throw new IllegalArgumentException("Please use the input-model converter for the " + InputLanguage.Cat + " language");
            default:
                throw new UnsupportedOperationException("Unsupported language: " + inputLanguage.toString());
        }
    }
}
