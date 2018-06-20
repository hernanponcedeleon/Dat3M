package porthosc.app.options.validators;

import com.beust.jcommander.IValueValidator;
import com.beust.jcommander.ParameterException;
import porthosc.app.modules.porthos.PorthosMode;

import java.util.Arrays;


public class PorthosModeValidator implements IValueValidator<PorthosMode> {

    @Override
    public void validate(String name, PorthosMode value) throws ParameterException {
        if (value == null) {
            throw new ParameterException("Invalid type of the portability analysis mode. Available options: " +
                    Arrays.toString(PorthosMode.values()));
        }
    }
}
