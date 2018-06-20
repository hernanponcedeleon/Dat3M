package porthosc.utils.io;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;


public class FileUtils {

    //public static boolean isCatFile(String fileName) {
    //    return FilenameUtils.getExtension(fileName) == "cat";
    //}
    //
    //public static boolean isKnownInputProgramExtension(String fileName) {
    //    return FilenameUtils.getExtension(fileName) == "cat";
    //}

    public static FileInputStream getFileInputStream(File file) throws FileNotFoundException {
        return new FileInputStream(file);
    }

    public static CharStream getFileCharStream(File file) throws IOException {
        FileInputStream stream = getFileInputStream(file);
        return CharStreams.fromStream(stream);
    }

    public static String combine(String path, String file) {
        return new File(path, file).getPath();
    }
}
