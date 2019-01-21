package dartagnan.program.memory.utils;

public class IllegalMemoryAccessException extends RuntimeException {

    public IllegalMemoryAccessException(String msg){
        super(msg);
    }
}
