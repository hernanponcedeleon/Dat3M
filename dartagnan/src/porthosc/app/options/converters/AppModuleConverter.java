package porthosc.app.options.converters;

import com.beust.jcommander.IStringConverter;
import porthosc.app.modules.AppModuleName;


public class AppModuleConverter implements IStringConverter<AppModuleName> {

    @Override
    public AppModuleName convert(String value) {
        return AppModuleName.parse(value);
    }
}
