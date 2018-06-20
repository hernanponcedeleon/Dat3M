package porthosc.languages.syntax.wmodel.operators;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.WEntityBase;
import porthosc.languages.syntax.wmodel.WOperator;


public abstract class WOperatorBase extends WEntityBase implements WOperator {

    public final WOperator.Kind kind;

    WOperatorBase(Origin origin, boolean containsRecursion, WOperator.Kind kind) {
        super(origin, containsRecursion);
        this.kind = kind;
    }

    public WOperator.Kind getKind() {
        return kind;
    }
}
