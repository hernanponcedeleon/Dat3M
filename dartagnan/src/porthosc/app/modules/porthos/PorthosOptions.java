package porthosc.app.modules.porthos;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.converters.FileConverter;
import porthosc.app.options.AppOptions;
import porthosc.app.options.converters.MemoryModelNameConverter;
import porthosc.app.options.converters.PorthosModeConverter;
import porthosc.app.options.validators.FileValidator;
import porthosc.app.options.validators.InputProgramExtensionValidator;
import porthosc.app.options.validators.MemoryModelNameValidator;
import porthosc.app.options.validators.PorthosModeValidator;
import porthosc.memorymodels.wmm.MemoryModel;

import java.io.File;


public class PorthosOptions extends AppOptions {

    @Parameter(names = {"-i", "--input"},
            arity = 1,
            description = "Input source-code file path",
            converter = FileConverter.class,
            validateValueWith = {FileValidator.class, InputProgramExtensionValidator.class})
    public File inputProgramFile;

    @Parameter(names = {"-s", "--source-model"},
            required = true,
            arity = 1,
            description = "Source weak memory model name",
            // uncomment when we'll be parsing .cat-files
            //converter = FileConverter.class,
            //validateValueWith = {FileValidator.class, InputModelExtensionValidator.class})
            converter = MemoryModelNameConverter.class,
            validateValueWith = MemoryModelNameValidator.class)
    public MemoryModel.Kind sourceModel;

    @Parameter(names = {"-t", "--target-model"},
            required = true,
            arity = 1,
            description = "Target weak memory model name",
            // uncomment when we'll be parsing .cat-files
            //converter = FileConverter.class,
            //validateValueWith = {FileValidator.class, InputModelExtensionValidator.class})
            converter = MemoryModelNameConverter.class,
            validateValueWith = MemoryModelNameValidator.class)
    public MemoryModel.Kind targetModel;

    @Parameter(names = {"-m", "--mode"},
            arity = 1,
            description = "Mode of the portability analysis",
            // uncomment when we'll be parsing .cat-files
            //converter = FileConverter.class,
            //validateValueWith = {FileValidator.class, InputModelExtensionValidator.class})
            converter = PorthosModeConverter.class,
            validateValueWith = PorthosModeValidator.class)
    public PorthosMode mode = PorthosMode.StateInclusion;


}
