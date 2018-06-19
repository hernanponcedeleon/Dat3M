package dartagnan;

import com.microsoft.z3.*;
import java.io.*;
import java.nio.file.*;
import java.util.HashMap;
import java.util.stream.*;

public class DartagnanTest {

    public static void main(String[] args) throws Z3Exception, IOException {

        Logger logger = new Logger("litmus/porthos.csv");
        logger.setHerdSource("litmus/herd.csv");
        logger.setOutputConsole(true);
        logger.initialize();

        Runner runner = new Runner(logger);
        //System.err.close();

        runner.run("litmus/PPC", "power", null, 2, true, true);
        //runner.run("litmus/X86", "tso", null, 2, true);

        logger.close();
    }
}

class Runner{

    private Logger logger;

    Runner(Logger logger){
        this.logger = logger;
    }

    void run(String testsDirectoryPath, String target, String catFilePath, int steps, boolean relax, boolean idl){
        try(Stream<Path> paths = Files.walk(Paths.get(testsDirectoryPath))){
            paths
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus") || f.toString().endsWith("pts")))
                    .forEach(f -> {
                        try{
                            Executor ex = Dartagnan.getExecutor(f.toString());
                            boolean result = ex.execute(target, catFilePath, steps, relax, idl);
                            logger.log(f.toString(), result ? "Allowed" : "Forbidden");
                        } catch (Exception e){
                            logger.log(f.toString(), "Error");
                        }
                    });

        } catch(Exception e){
            logger.log(testsDirectoryPath, e.getMessage());
        }
    }
}

class Logger{

    private boolean console = false;
    private boolean herd = false;
    private PrintWriter writter;
    private HashMap<String, String> herdSource;

    Logger(String outFile) throws IOException{
        File file = new File(outFile);
        if(file.exists()){
            if(!file.delete() || !file.createNewFile()){
                throw new IOException("Failed to truncate output file " + outFile);
            }
        }
        writter = new PrintWriter(file);
    }

    void setOutputConsole(boolean flag){
        console = flag;
    }

    void setHerdSource(String file) throws IOException{
        herdSource = loadHerdData(file, ",");
        if(herdSource != null){
            herd = true;
        }
    }

    void initialize(){
        String header;
        if(herd){
            header = String.format("%-60s%-12s%-12s\n", "TEST", "PORTHOS", "HERD");
        } else {
            header = String.format("%-60s%-12s\n", "TEST", "PORTHOS");
        }
        writter.write(header);

        if(console){
            System.out.print(header);
        }
    }

    void log(String testFile, String result){
        String data;
        if(herd){
            String herdResult = herdSource.get(testFile);
            if(herdResult == null){
                herdResult = "N/A";
            }
            data = String.format("%-60s%-12s%-12s\n", testFile, result, herdResult);
        } else {
            data = String.format("%-60s%-12s\n", testFile, result);
        }

        writter.write(data);
        if(console){
            System.out.print(data);
        }
    }

    void close(){
        writter.close();
    }

    private HashMap<String, String> loadHerdData(String file, String separator) throws IOException{
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(file));
            HashMap<String, String> result = new HashMap<String, String>();
            String line = "";

            while((line = reader.readLine()) != null){
                String[] data = line.split(separator);
                if(data.length == 2){
                    result.put(data[0], data[1]);
                }
            }
            return result;

        } catch(IOException e){
            throw new IOException("Failed to read HERD test data from " + file);
        } finally {
            if (reader != null) {
                reader.close();
            }
        }
    }
}