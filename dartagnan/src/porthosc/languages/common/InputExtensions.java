package porthosc.languages.common;

import org.apache.commons.io.FilenameUtils;

import java.util.HashMap;


public class InputExtensions {
    private static final HashMap<String, InputLanguage> inputProgramExtensionsMap =
            new HashMap<String, InputLanguage>() {{
                put("c11", InputLanguage.C11);
                put("c", InputLanguage.C11);
                //put("pts", ProgramLanguage.Porthos);
                //put("litmus", Syntax.Litmus);
                put("cat", InputLanguage.Cat);
            }};

    // Uncomment when being implementing the cat file parser
    //private static final HashMap<String, InputModelLanguage> inputModelExtensionsMap =
    //        new HashMap<>() {{
    //            put("cat", InputModelLanguage.CAT);
    //        }};

    // result is null if not valid extension
    public static InputLanguage tryParseProgramLanguage(String fileName) {
        return inputProgramExtensionsMap.get(FilenameUtils.getExtension(fileName));
    }

    public static InputLanguage parseProgramLanguage(String fileName) {
        InputLanguage result = inputProgramExtensionsMap.get(FilenameUtils.getExtension(fileName));
        if (result == null) {
            throw new IllegalArgumentException(fileName);
        }
        return result;
    }

    // Uncomment when being implementing the cat file parser
    //// result is null if not valid extension
    //public static InputModelLanguage tryParseInputModelExtension(String fileName) {
    //    return inputModelExtensionsMap.get(fileName);
    //}
}
