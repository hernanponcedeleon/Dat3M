package porthosc.languages.conversion.toxgraph;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.ytree.expressions.atomics.YConstant;
import porthosc.languages.syntax.ytree.types.YType;


public class Y2XTypeConverter {

    public static XType determineType(YConstant constant) {
        //assert constant.getValue() instanceof Integer : "for now, only ints are supported; found constant of type: "
        //        + constant.getValue().getClass().getSimpleName();
        return XType.int32;//todo: there's no typing yet
    }

    public static XType convert(YType yType) {
        return XType.int32;//todo: there's no typing yet
    }
}
