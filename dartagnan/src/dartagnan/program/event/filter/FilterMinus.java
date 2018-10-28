package dartagnan.program.event.filter;

import dartagnan.program.event.Event;

public class FilterMinus extends FilterAbstract {

    private FilterAbstract filter1;
    private FilterAbstract filter2;

    public FilterMinus(FilterAbstract filterPresent, FilterAbstract filterAbsent){
        this.filter1 = filterPresent;
        this.filter2 = filterAbsent;
    }

    @Override
    public boolean filter(Event e){
        return filter1.filter(e) && !filter2.filter(e);
    }

    @Override
    public String toString(){
        return ((filter1 instanceof FilterBasic) ? filter1 : "( " + filter1 + " )")
                + " \\ " + ((filter2 instanceof FilterBasic) ? filter2 : "( " + filter2 + " )");
    }

    @Override
    public int toRepositoryCode(){
        return filter1.toRepositoryCode();
        // TODO: Return absent filter after tight bounds are ready
        //return filter1.toRepositoryCode() & (Integer.MAX_VALUE ^ filter2.toRepositoryCode());
    }
}