package dartagnan.program.event.filter;

import dartagnan.program.event.Event;

public class FilterMinus extends FilterAbstract {

    private FilterAbstract filterPresent;
    private FilterAbstract filterAbsent;

    public FilterMinus(FilterAbstract filterPresent, FilterAbstract filterAbsent){
        this.filterPresent = filterPresent;
        this.filterAbsent = filterAbsent;
    }

    public boolean filter(Event e){
        return filterPresent.filter(e) && !filterAbsent.filter(e);
    }

    public String toString(){
        return ((filterPresent instanceof FilterBasic) ? filterPresent : "( " + filterPresent + " )")
                + " \\ "
                + ((filterAbsent instanceof FilterBasic) ? filterAbsent : "( " + filterAbsent + " )");
    }

    // TODO: Return absent filter after tight bounds are ready
    public Integer toRepositoryCode(){
        return filterPresent.toRepositoryCode();
        //return filterPresent.toRepositoryCode() & (Integer.MAX_VALUE ^ filterAbsent.toRepositoryCode());
    }
}