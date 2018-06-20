package porthosc.languages.syntax.ytree.types;

import porthosc.languages.syntax.ytree.YEntity;


public interface YType extends YEntity {

    interface Qualifier {
    }

    interface Specifier {
    }

    YType.Qualifier getQualifier();

    YType.Specifier getSpecifier();
}
