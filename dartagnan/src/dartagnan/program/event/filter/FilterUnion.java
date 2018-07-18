package dartagnan.program.event.filter;

import dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class FilterUnion extends FilterAbstract {

    private List<FilterAbstract> filters = new ArrayList<FilterAbstract>();

    public FilterUnion(){}

    public FilterUnion(FilterAbstract filter1, FilterAbstract filter2){
        filters.add(filter1);
        filters.add(filter2);
    }

    public void addFilter(FilterAbstract filter){
        this.filters.add(filter);
    }

    public boolean filter(Event e){
        for(FilterAbstract filter : filters){
            if(filter.filter(e)){
                return true;
            }
        }
        return false;
    }

    public String toString(){
        return filters.stream()
                .map(f -> (f instanceof FilterBasic) ? f.toString() : "( " + f.toString() + " )")
                .collect(Collectors.joining(" | "));
    }
}
