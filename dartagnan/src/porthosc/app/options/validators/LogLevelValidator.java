package porthosc.app.options.validators;


import com.beust.jcommander.IValueValidator;
import com.beust.jcommander.ParameterException;
import porthosc.utils.logging.LogLevel;

import java.util.Arrays;


public class LogLevelValidator implements IValueValidator<LogLevel> {

    @Override
    public void validate(String name, LogLevel value) throws ParameterException {
        if (value == null) {
            throw new ParameterException("Invalid format of log level. Available options: " +
                Arrays.toString(LogLevel.values()).toLowerCase());
        }
    }
}
