package dartagnan.program.event.filter;

import dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class FilterIntersection extends FilterAbstract {

    private List<FilterAbstract> filters = new ArrayList<FilterAbstract>();

    public FilterIntersection(){}

    public FilterIntersection(FilterAbstract filter1, FilterAbstract filter2){
        filters.add(filter1);
        filters.add(filter2);
    }

    public void addFilter(FilterAbstract filter){
        this.filters.add(filter);
    }

    public boolean filter(Event e){
        for(FilterAbstract filter : filters){
            if(!filter.filter(e)){
                return false;
            }
        }
        return true;
    }

    public String toString(){
        return filters.stream()
                .map(f -> (f instanceof FilterBasic) ? f.toString() : "( " + f.toString() + " )")
                .collect(Collectors.joining(" & "));
    }

    public Integer toRepositoryCode(){
        Integer result = Integer.MAX_VALUE;
        for(FilterAbstract filter : filters){
            result &= filter.toRepositoryCode();
        }
        return result;
    }
}
