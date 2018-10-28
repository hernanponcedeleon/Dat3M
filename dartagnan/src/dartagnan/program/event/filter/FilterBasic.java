package dartagnan.program.event.filter;

import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;

public class FilterBasic extends FilterAbstract {

    private String param;

    public FilterBasic(String param){
        this.param = param;
    }

    @Override
    public boolean filter(Event e){
        return e.is(param);
    }

    @Override
    public String toString(){
        return param;
    }

    @Override
    public int toRepositoryCode(){
        if(FilterUtils.toRepositoryCode.containsKey(param)){
            return FilterUtils.toRepositoryCode.get(param);
        }
        return EventRepository.ALL;
    }
}
