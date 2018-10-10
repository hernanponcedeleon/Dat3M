package dartagnan.program.event.filter;

import dartagnan.program.event.Event;

public class FilterBasic extends FilterAbstract {

    private String param;

    public FilterBasic(String param){
        this.param = param;
    }

    public boolean filter(Event e){
        return e.is(param);
    }

    public String toString(){
        return param;
    }

    public Integer toRepositoryCode(){
        return FilterUtils.toRepositoryCode.get(param);
    }
}
