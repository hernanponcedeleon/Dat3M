package com.dat3m.dartagnan.utils.printer;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;

public class Printer {

    private StringBuilder result;
    private StringBuilder padding;

    private boolean showAuxiliaryEvents = true;
    private boolean showInitThreads = false;
    private IDType idType = IDType.AUTO;

    private final String paddingBase = "      ";

    public String print(Program program){
        result = new StringBuilder();
        padding = new StringBuilder(paddingBase);

        IDType origType = idType;
        idType = resolveIDType(program);

        String name = program.getName();
        if(name == null){
            name = "program";
        }
        result.append(name).append("\n");

        for(Thread thread : program.getThreads()){
            if(shouldPrintThread(thread)){
                appendThread(thread);
            }
        }
        idType = origType;
        return result.toString();
    }

    public Printer setIdType(IDType type){
        this.idType = type;
        return this;
    }

    public Printer setShowAuxiliaryEvents(boolean flag){
        this.showAuxiliaryEvents = flag;
        return this;
    }

    public Printer setShowInitThreads(boolean flag){
        this.showInitThreads = flag;
        return this;
    }

    private boolean shouldPrintThread(Thread thread){
        if(showInitThreads){
            return true;
        }
        Event firstEvent = thread.getEntry().getSuccessor();
        // Thread always have at least two events, Skip and end Label
        return firstEvent.getSuccessor() != null && !(firstEvent instanceof Init);
    }

    private void appendThread(Thread thread){
        try {
            Integer.parseInt(thread.getName());
            result.append("\nthread_").append(thread.getName()).append("\n");
        } catch (Exception e) {
            result.append("\n").append(thread.getName()).append("\n");        	
        }
        for(Event e : thread.getCache().getEvents(FilterBasic.get(EType.ANY))){
            appendEvent(e);
        }
    }

    private void appendEvent(Event event){
        if(showAuxiliaryEvents || !isAuxiliary(event)){
            StringBuilder idSb = new StringBuilder();
            switch(idType){
                case ORIG:
                    idSb.append("(").append(event.getOId()).append(")");
                    break;
                case UNROLLED:
                    idSb.append("[").append(event.getUId()).append("]");
                    break;
                case COMPILED:
                    idSb.append(event.getCId()).append(":");
                    break;
                default:
                	throw new RuntimeException("Unrecognized event id type " + idType);
            }
            result.append(idSb);
            result.append(padding, idSb.length(), padding.length());
            result.append(event).append("\n");
        }
    }

    private boolean isAuxiliary(Event event){
        return event instanceof Skip;
    }

    private IDType resolveIDType(Program program){
        if(idType == IDType.AUTO){
            if(program.isCompiled()) {
                return IDType.COMPILED;
            }
            if(program.isUnrolled()){
                return IDType.UNROLLED;
            }
            return IDType.ORIG;
        }
        return idType;
    }
}
