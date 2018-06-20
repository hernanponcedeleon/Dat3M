package porthosc.languages.conversion.tozformula;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import porthosc.languages.conversion.tozformula.process.XFlowGraphEncoder;
import porthosc.languages.conversion.tozformula.process.XProcessEncoderFactory;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.memory.*;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.process.XProcess;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.memorymodels.Encodings;
import porthosc.utils.Utils;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import static porthosc.utils.Utils.*;


public class XProgram2ZformulaEncoder {

    private final Context ctx;
    private final StaticSingleAssignmentMap ssaMap;
    private final XDataflowEncoder dataFlowEncoder;

    public XProgram2ZformulaEncoder(Context ctx, XProgram program) {
        this.ctx = ctx;
        this.ssaMap = new StaticSingleAssignmentMap(ctx, program.size(), program.getEntryEvents());
        this.dataFlowEncoder = new XDataflowEncoder(ctx, ssaMap);
    }

    public BoolExpr encodeProgram(XProgram program) {
        BoolExpr enc = ctx.mkTrue();

        XProcessEncoderFactory factory = new XProcessEncoderFactory(ctx, ssaMap, dataFlowEncoder);
        boolean postludeEncoded = false;
        for (XProcess process : program.getProcesses()) {

            //kostyl==
            if (postludeEncoded) {
                throw new IllegalStateException();
            }
            if (process.getId() == XProcessId.PostludeProcessId) {
                for (XProcess anotherProcess : program.getProcesses()) {
                    if (anotherProcess != process) {
                        ssaMap.updateRefs(process.source(), anotherProcess.sink());
                    }
                }
                postludeEncoded = true;
            }
            //kostyl==

            XFlowGraphEncoder encoder = factory.getEncoder(process);

            enc = ctx.mkAnd(enc, encoder.encodeProcess(process));
            enc = ctx.mkAnd(enc, encoder.encodeProcessRFRelation(process));
        }

        return enc;
    }

    public BoolExpr Domain_encode(XProgram program) {
        BoolExpr enc = ctx.mkTrue();

        //System.out.println(String.format("#=%d(%d)", program.getAllEvents().size(), program.getMemoryEvents().size()));

        ImmutableSet<XSharedMemoryEvent> mEvents = program.getSharedMemoryEvents();
        ImmutableSet<XBarrierEvent> barriers = program.getBarrierEvents();
        ImmutableSet<XMemoryEvent> eventsL = program.getMemoryEvents(); //(o1, o2) -> o1.toString().compareTo(o2.toString())

        //System.out.println(String.format("#=%d (%d)", eventsL.size(), mEvents.size()));

        for(XMemoryEvent e : eventsL) {
            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ii", e, e, ctx)));
            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ic", e, e, ctx)));
            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ci", e, e, ctx)));
            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("cc", e, e, ctx)));
        }

        for(XSharedMemoryEvent e1 : mEvents) {
            for(XSharedMemoryEvent e2 : mEvents) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("rf", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("co", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));

                if(!(e1.isInit())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("IM", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("IW", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("IR", e1, e2, ctx)));
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("IM", e1, e2, ctx));
                }

                if(!(e2.isInit())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("MI", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("WI", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("RI", e1, e2, ctx)));
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("MI", e1, e2, ctx));
                }

                if(!(e1 instanceof XLoadMemoryEvent)) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("RM", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("RW", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("RR", e1, e2, ctx)));
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("RM", e1, e2, ctx));
                }

                if(!(e2 instanceof XLoadMemoryEvent)) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("MR", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("WR", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("RR", e1, e2, ctx)));
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("MR", e1, e2, ctx));
                }

                if(!(e1 instanceof XStoreMemoryEvent || e1.isInit())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("WM", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("WW", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("WR", e1, e2, ctx)));
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("WM", e1, e2, ctx));
                }

                if(!(e2 instanceof XStoreMemoryEvent || e2.isInit())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("MW", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("WW", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("RW", e1, e2, ctx)));
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("MW", e1, e2, ctx));
                }

                if(e1 instanceof XLoadMemoryEvent && e2 instanceof XLoadMemoryEvent) {
                    enc = ctx.mkAnd(enc, Utils.edge("RR", e1, e2, ctx));
                }

                if(e1 instanceof XLoadMemoryEvent && (e2.isInit() || e2 instanceof XStoreMemoryEvent)) {
                    enc = ctx.mkAnd(enc, Utils.edge("RW", e1, e2, ctx));
                }

                if((e1.isInit() || e1 instanceof XStoreMemoryEvent) && (e2.isInit() || e2 instanceof XStoreMemoryEvent)) {
                    enc = ctx.mkAnd(enc, Utils.edge("WW", e1, e2, ctx));
                }

                if((e1.isInit() || e1 instanceof XStoreMemoryEvent) && e2 instanceof XLoadMemoryEvent) {
                    enc = ctx.mkAnd(enc, Utils.edge("WR", e1, e2, ctx));
                }

                if(e1 == e2) {
                    enc = ctx.mkAnd(enc, Utils.edge("id", e1, e2, ctx));
                }
                else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("id", e1, e2, ctx)));
                }

                if(e1.getProcessId() == e2.getProcessId()) {
                    enc = ctx.mkAnd(enc, Utils.edge("int", e1, e2, ctx));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ext", e1, e2, ctx)));
                    if(program.compareTopologically(e1, e2) < 0) {//e1.getEId() < e2.getEId()
                        enc = ctx.mkAnd(enc, Utils.edge("po", e1, e2, ctx));
                        // TODO: check this condLevel comparison
                        //see 'ctrl' in Herding cats p. 30
                        if(program.compareTopologicallyAndCondLevel(e1, e2) < 0 //e1.getCondLevel() < e2.getCondLevel()
                                && e1 instanceof XLoadMemoryEvent
                                && program.getCondRegs(e2).contains(e1.getReg())) {//e2.getCondRegs().contains(e1.getReg())) {
                            enc = ctx.mkAnd(enc, Utils.edge("ctrl", e1, e2, ctx));
                        }
                        else {
                            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ctrl", e1, e2, ctx)));
                        }
                    }
                    else {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("po", e1, e2, ctx)));
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ctrl", e1, e2, ctx)));
                    }
                    boolean noMfence = true;
                    boolean noSync = true;
                    boolean noLwsync = true;
                    boolean noIsync = true;
                    boolean noIsh = true;
                    boolean noIsb = true;
                    for(XBarrierEvent b : barriers.stream().filter(e -> e.getProcessId() == e1.getProcessId()
                            && program.compareTopologically(e1, e) < 0 //e1.getEId() < e.getEId()
                            && program.compareTopologically(e, e2) < 0 //e.getEId() < e2.getEId()
                    ).collect(Collectors.toSet())) {
                        switch (b.getKind()) {
                            case Mfence:
                                noMfence = false;
                                break;
                            case Sync:
                                noSync = false;
                                break;
                            case OptSync:
                                noLwsync = false;
                                break;
                            case Lwsync:
                                break;
                            case OptLwsync:
                                break;
                            case Ish:
                                noIsh = false;
                                break;
                            case Isb:
                                noIsb = false;
                                break;
                            case Isync:
                                noIsync = false;
                                break;
                        }
                    }
                    if(noMfence) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("mfence", e1, e2, ctx)));
                    }
                    if(noSync) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("sync", e1, e2, ctx)));
                    }
                    if(noLwsync) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("lwsync", e1, e2, ctx)));
                    }
                    if(noIsync) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("isync", e1, e2, ctx)));
                    }
                    if(noIsh) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ish", e1, e2, ctx)));
                    }
                    if(noIsb) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("isb", e1, e2, ctx)));
                    }
                }
                else {
                    enc = ctx.mkAnd(enc, Utils.edge("ext", e1, e2, ctx));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("int", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("po", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ctrl", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ii", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ic", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ci", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("cc", e1, e2, ctx)));
                }
                if(e1.getLoc() == e2.getLoc()) {
                    enc = ctx.mkAnd(enc, Utils.edge("loc", e1, e2, ctx));
                }
                else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("loc", e1, e2, ctx)));
                }
                if(!((e1 instanceof XStoreMemoryEvent || e1.isInit()) && e2 instanceof XLoadMemoryEvent && e1.getLoc() == e2.getLoc())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("rf", e1, e2, ctx)));
                }
                if(!((e1 instanceof XStoreMemoryEvent || e1.isInit()) && (e2 instanceof XStoreMemoryEvent || e2.isInit()) && e1.getLoc() == e2.getLoc())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("co", e1, e2, ctx)));
                }
                if(!(e1.getProcessId() == e2.getProcessId()
                        && program.compareTopologically(e1, e2) < 0 /*e1.getEId() < e2.getEId()*/)) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("mfence", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("sync", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("lwsync", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("isync", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("ish", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("isb", e1, e2, ctx)));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("rfe", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("rf", e1, e2, ctx), Utils.edge("ext", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("rfi", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("rf", e1, e2, ctx), Utils.edge("int", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("coe", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("co", e1, e2, ctx), Utils.edge("ext", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("coi", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("co", e1, e2, ctx), Utils.edge("int", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("fre", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("fr", e1, e2, ctx), Utils.edge("ext", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("fri", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("fr", e1, e2, ctx), Utils.edge("int", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("poloc", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("po", e1, e2, ctx), Utils.edge("loc", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ctrlisync", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("ctrl", e1, e2, ctx), Utils.edge("isync", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ctrlisb", e1, e2, ctx),
                                              ctx.mkAnd(Utils.edge("ctrl", e1, e2, ctx), Utils.edge("isb", e1, e2, ctx))));
            }
        }

        for (XSharedMemoryEvent e1 : mEvents) {
            for (XSharedMemoryEvent e2 : mEvents) {
                BoolExpr mfences = ctx.mkFalse();
                BoolExpr syncs = ctx.mkFalse();
                BoolExpr lwsyncs = ctx.mkFalse();
                BoolExpr isyncs = ctx.mkFalse();
                BoolExpr ishs = ctx.mkFalse();
                BoolExpr isbs = ctx.mkFalse();

                for(XBarrierEvent b : barriers) {
                    if (e1.getProcessId() == b.getProcessId()
                            && b.getProcessId() == e2.getProcessId()
                            && program.compareTopologically(e1, b) < 0
                            && program.compareTopologically(b, e2) < 0) {

                        switch (b.getKind()) {
                            case Mfence:
                                mfences = ctx.mkOr(mfences, b.executes(ctx));
                                enc = ctx.mkAnd(enc, ctx.mkImplies(
                                        ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
                                        Utils.edge("mfence", e1, e2, ctx)));
                                break;
                            case Sync:
                                syncs = ctx.mkOr(syncs, b.executes(ctx));
                                enc = ctx.mkAnd(enc, ctx.mkImplies(
                                        ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
                                        Utils.edge("sync", e1, e2, ctx)));
                                break;
                            case OptSync:
                                break;
                            case Lwsync:
                                lwsyncs = ctx.mkOr(lwsyncs, b.executes(ctx));
                                enc = ctx.mkAnd(enc, ctx.mkImplies(
                                        ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
                                        Utils.edge("lwsync", e1, e2, ctx)));
                                break;
                            case OptLwsync:
                                break;
                            case Ish:
                                ishs = ctx.mkOr(ishs, b.executes(ctx));
                                enc = ctx.mkAnd(enc, ctx.mkImplies(
                                        ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
                                        Utils.edge("ish", e1, e2, ctx)));
                                break;
                            case Isb:
                                isbs = ctx.mkOr(isbs, b.executes(ctx));
                                enc = ctx.mkAnd(enc, ctx.mkImplies(
                                        ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
                                        Utils.edge("isb", e1, e2, ctx)));
                                break;
                            case Isync:
                                isyncs = ctx.mkOr(isyncs, b.executes(ctx));
                                enc = ctx.mkAnd(enc, ctx.mkImplies(
                                        ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
                                        Utils.edge("isync", e1, e2, ctx)));
                                break;
                        }
                    }
                }
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("mfence", e1, e2, ctx), mfences));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("sync", e1, e2, ctx), syncs));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("lwsync", e1, e2, ctx), lwsyncs));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("isync", e1, e2, ctx), isyncs));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("ish", e1, e2, ctx), ishs));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("isb", e1, e2, ctx), isbs));
            }
        }

        //for (XMemoryEvent e1 : eventsL) {
        //    for (XMemoryEvent e2 : eventsL) {
        //        if(e1 == e2
        //                || e1.getProcessId() != e2.getProcessId()
        //                || program.compareTopologically(e2, e1) < 0) { //e2.getEId() < e1.getEId()
        //            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("idd", e1, e2, ctx)));
        //            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("data", e1, e2, ctx)));
        //        }
        //        VarRefCollection e2VarRefs = ssaMap.getEventMap(e2);
        //        if(e2 instanceof XStoreMemoryEvent) {
        //            // TODO: Check here
        //            XStoreMemoryEvent e2store = (XStoreMemoryEvent) e2;
        //            if (! (ssaMap.getLastModEvents(e2store.getReg()).contains(e1)) ) { //if(!e2.getLastModMap().get(e2.getReg()).contains(e1)) {
        //                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("idd", e1, e2, ctx)));
        //            }
        //        }
        //        if(e2 instanceof XLoadMemoryEvent) {
        //            // TODO: Check here
        //            XLoadMemoryEvent e2load = (XLoadMemoryEvent) e2;
        //            if(! (e2VarRefs.containsVarRef(e2load.getLoc())) ) {//if(!e2.getLastModMap().keySet().contains(e2.getLoc())) {
        //                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("idd", e1, e2, ctx)));
        //            }
        //        }
        //        if(e2 instanceof XLocalMemoryEvent && (e2.getSource() instanceof XConstant || e2.getDestination() instanceof XConstant)) {
        //            // TODO: Check here
        //            XLocalMemoryEvent e2local = (XLocalMemoryEvent) e2;
        //            if (e2local.getSource() instanceof XConstant) { //e2 instanceof Local && e2.getExpr() instanceof AConst) {
        //                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("idd", e1, e2, ctx)));
        //            }
        //        }
        //    }
        //}

        //for(XMemoryEvent e : eventsL) {
        //    if(e instanceof XStoreMemoryEvent) {
        //        XStoreMemoryEvent eStore = (XStoreMemoryEvent) e;
        //        BoolExpr orClause = ctx.mkFalse();
        //        // TODO: Check here
        //        for(XEvent x : ssaMap.getLastModEvents(eStore.getReg())) { //e.getLastModMap().get(e.getReg())) {
        //            orClause = ctx.mkOr(orClause, Utils.edge("idd", x, e, ctx));
        //        }
        //        enc = ctx.mkAnd(enc, orClause);
        //    }
        //    if(e instanceof XLoadMemoryEvent) {
        //        XLoadMemoryEvent eLoad = (XLoadMemoryEvent) e;
        //        // TODO: Check here. Is this a hack?
        //        if (!ssaMap.getLastModEvents(eLoad.getLoc()).contains(e)) { //if(!e.getLastModMap().keySet().contains(e.getLoc())) {
        //            continue;
        //        }
        //        BoolExpr orClause = ctx.mkFalse();
        //        // TODO: Check here
        //        for(XEvent x : ssaMap.getLastModEvents(eLoad.getLoc())) {//e.getLastModMap().get(e.getLoc())) {
        //            orClause = ctx.mkOr(orClause, Utils.edge("idd", x, e, ctx));
        //        }
        //        enc = ctx.mkAnd(enc, orClause);
        //    }
        //    if(e instanceof XLocalMemoryEvent) {
        //        // TODO: Check here
        //        XLocalMemoryUnitCollector registerCollector = new XLocalMemoryUnitCollector();
        //        for (XLocalMemoryUnit localMemoryUnit : e.accept(registerCollector)) {
        //            BoolExpr orClause = ctx.mkFalse();
        //            if (localMemoryUnit instanceof XLocalLvalueMemoryUnit) {
        //                for (XEvent x : ssaMap.getLastModEvents((XLocalLvalueMemoryUnit) localMemoryUnit)) {
        //                    orClause = ctx.mkOr(orClause, Utils.edge("idd", x, e, ctx));
        //                }
        //            }
        //            enc = ctx.mkAnd(enc, orClause);
        //        }
        //        //for(Register reg : e.getExpr().getRegs()) {
        //        //    BoolExpr orClause = ctx.mkFalse();
        //        //    for(XEvent x : e.getLastModMap().get(reg)) {
        //        //        orClause = ctx.mkOr(orClause, Utils.edge("idd", x, e, ctx));
        //        //    }
        //        //    enc = ctx.mkAnd(enc, orClause);
        //        //}
        //    }
        //}

        for(XSharedMemoryEvent e1 : mEvents) {
            for(XSharedMemoryEvent e2 : mEvents) {
                BoolExpr orClause = ctx.mkFalse();
                for(XSharedMemoryEvent e3 : mEvents) {
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge("rf", e3, e1, ctx), Utils.edge("co", e3, e2, ctx)));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("fr", e1, e2, ctx), orClause));
            }
        }

        //Set<Location> locs = mEvents.stream().filter(e -> e instanceof SharedMemEvent).map(e -> e.getLoc()).collect(Collectors.toSet());
        //for(Location loc : locs) {
        for (XEvent w1 : mEvents) {
            if (w1 instanceof XSharedMemoryEvent) {
                XSharedLvalueMemoryUnit w1Loc = ((XSharedMemoryEvent) w1).getLoc();
                //Set<XEvent> writesEventsLoc = mEvents.stream().filter(e -> (e instanceof XStoreMemoryEvent || e.isInit()) && e.getLoc() == loc).collect(Collectors.toSet());
                Set<XEvent> writesEventsLoc = new HashSet<>();
                for (XSharedMemoryEvent e : mEvents) {
                    if (e instanceof XStoreMemoryEvent || e.isInit()) {
                        if (e.getLoc() == w1Loc) {
                            writesEventsLoc.add(e);
                        }
                    }
                }
                enc = ctx.mkAnd(enc, Encodings.satTO("co", writesEventsLoc, ctx));
            }
        }

        for(XSharedMemoryEvent e : mEvents) {
            if (e.isInit()) {
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.intVar("co", e, ctx), ctx.mkInt(1)));
            }
        }

        // todo: merge this with pre-pre loop
        for(XSharedMemoryEvent w1 : mEvents) {
            if (w1.isInit() || w1 instanceof XStoreMemoryEvent) {
                Set<XEvent> writesEventsLoc = new HashSet<>();
                for (XSharedMemoryEvent e : mEvents) {
                    if (e instanceof XStoreMemoryEvent || e.isInit()) {
                        if (e.getLoc() == w1.getLoc()) {
                            writesEventsLoc.add(e);
                        }
                    }
                }
                BoolExpr lastCoOrder = w1.executes(ctx);
                for(XEvent w2 : writesEventsLoc) {
                    lastCoOrder = ctx.mkAnd(lastCoOrder, ctx.mkNot(Utils.edge("co", w1, w2, ctx)));
                }
                Expr w1ssaLoc = dataFlowEncoder.encodeMemoryUnit(w1.getLoc(), w1); // TODO: check that this is indeed equivalent to `w1.ssaLoc'

                //lastCoOrder = w1.executes(ctx);
                enc = ctx.mkAnd(enc, ctx.mkImplies(lastCoOrder, ctx.mkEq(lastValueLoc(w1.getLoc(), ctx), w1ssaLoc)));
                enc = ctx.mkAnd(enc, ctx.mkEq(lastValueLoc(w1.getLoc(), ctx), w1ssaLoc));
            }
        }

        for(XMemoryEvent r1 : eventsL) {
            if (r1 instanceof XLoadMemoryEvent || r1 instanceof XLocalMemoryEvent) {
                Set<XEvent> modRegLater = new HashSet<>(); //eventsL.stream().filter(e -> (e instanceof XLoadMemoryEvent || e instanceof LocalEvent) && r1.getReg() == e.getReg() && r1.getEId() < e.getEId()).collect(Collectors.toSet());
                for (XMemoryEvent e : eventsL) {
                    if ((e instanceof XLoadMemoryEvent || e instanceof XLocalMemoryEvent)
                            && r1.getDestination() == e.getDestination() // TODO: check: before there was 'getReg()'
                            && program.compareTopologically(r1, e) < 0) { //r1.getEId() < e.getEId())
                        modRegLater.add(e);
                    }
                }

                BoolExpr lastModReg = r1.executes(ctx);
                for(XEvent r2 : modRegLater) {
                    lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(r2.executes(ctx)));
                }
                // TODO:  `(XLvalueMemoryUnit) r1.getDestination()' is bad. Fix it
                XLocalLvalueMemoryUnit r1Register = (XLocalLvalueMemoryUnit) r1.getDestination();
                int r1ssaIndex = ssaMap.getEventMap(r1).getRefIndex(r1Register);
                IntExpr left = lastValueReg(r1Register, ctx);
                IntExpr right = ssaReg(r1Register, r1ssaIndex, ctx);
                enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg, ctx.mkEq(left, right)));
            }
        }

        // RF construction
        for(XEvent e : mEvents) {
            if (e instanceof XLoadMemoryEvent) {
                //Set<XEvent> storeEventsLoc = mEvents.stream().filter(x -> (x instanceof XStoreMemoryEvent || x.isInit()) && e.getLoc() == x.getLoc()).collect(Collectors.toSet());
                XLoadMemoryEvent eLoad = (XLoadMemoryEvent) e;
                XSharedLvalueMemoryUnit eLocation = eLoad.getLoc();
                Set<XEvent> storeEventsLoc = new HashSet<>();
                for (XSharedMemoryEvent x : mEvents) {
                    if ((x instanceof XStoreMemoryEvent || x.isInit()) && eLocation == x.getLoc()) {
                        storeEventsLoc.add(x);
                    }
                }
                Set<BoolExpr> rfPairs = new HashSet<>();
                for(XEvent w : storeEventsLoc) {
                    rfPairs.add(Utils.edge("rf", w, e, ctx));
                }
                enc = ctx.mkAnd(enc, ctx.mkImplies(e.executes(ctx), Encodings.encodeEO(rfPairs, ctx)));
            }
        }
        return enc;
    }
}
