package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import java.util.*;

public class IRHelper {

    private IRHelper() {}

    /*
    Returns true if the syntactic successor of <e> (e.getSuccessor()) is not (generally) a semantic successor,
    because <e> always jumps/branches/terminates etc.
 */
    public static boolean isAlwaysBranching(Event e) {
        return e instanceof Return
                || e instanceof AbortIf abort && abort.getCondition() instanceof BoolLiteral b && b.getValue()
                || e instanceof CondJump jump && jump.isGoto();
    }

    public static Set<Event> bulkDelete(Set<Event> toBeDeleted) {
        final Set<Event> nonDeleted = new HashSet<>();
        for (Event e : toBeDeleted) {
            if (toBeDeleted.containsAll(e.getUsers())) {
                e.forceDelete();
            } else {
                nonDeleted.add(e);
            }
        }
        return nonDeleted;
    }

    public static List<Event> getEventsFromTo(Event from, Event to) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction());
        final List<Event> events = new ArrayList<>();
        Event cur = from;
        do {
            events.add(cur);
            if (cur == to) {
                break;
            }
            cur = cur.getSuccessor();
        } while (cur != null);
        assert cur != null;

        return events;
    }

    public static List<Event> copyPath(Event from, Event until, Map<Event, Event> copyContext,
                                       Map<Register, Register> regReplacement) {
        final List<Event> copies = new ArrayList<>();

        Event cur = from;
        while (cur != null && !cur.equals(until)) {
            final Event copy = cur.getCopy();
            copies.add(copy);
            copyContext.put(cur, copy);
            cur = cur.getSuccessor();
        }

        final ExprTransformer regSubstitutor = new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                return regReplacement.getOrDefault(reg, reg);
            }
        };

        for (Event copy : copies) {
            if (copy instanceof EventUser user) {
                user.updateReferences(copyContext);
            }
            if (copy instanceof RegReader reader) {
                reader.transformExpressions(regSubstitutor);
            }
            if (copy instanceof LlvmCmpXchg xchg) {
                xchg.setStructRegister(0, (Register)xchg.getStructRegister(0).accept(regSubstitutor));
                xchg.setStructRegister(1, (Register)xchg.getStructRegister(1).accept(regSubstitutor));
            } else if (copy instanceof RegWriter regWriter) {
                regWriter.setResultRegister((Register) regWriter.getResultRegister().accept(regSubstitutor));
            }

        }

        return copies;
    }

    public static Function translateFunction(Function func, Program targetProgram,
                                             Map<MemoryObject, MemoryObject> memMap,
                                             Map<NonDetValue, NonDetValue> progConstMap
                                             ) {
        final int id = targetProgram.getFunctions().stream().mapToInt(Function::getId).max().orElse(0);
        final Function copy = new Function(func.getName(), func.getFunctionType(),
                Lists.transform(func.getParameterRegisters(), Register::getName), id, null);
        copy.copyDummyCountFrom(func);

        // --------------- Copy over registers ---------------
        final Map<Register, Register> registerMap = new HashMap<>();
        for (Register reg : func.getRegisters()) {
            final Register regCopy = copy.getOrNewRegister(reg.getName(), reg.getType());
            registerMap.put(reg, regCopy);
        }

        final ExprTransformer translator = new ExprTransformer() {
            @Override
            public Expression visitMemoryObject(MemoryObject memObj) {
                final MemoryObject mapped = memMap.get(memObj);
                assert mapped != null && targetProgram.getMemory().getObjects().contains(mapped);
                return mapped;
            }

            @Override
            public Expression visitNonDetValue(NonDetValue nonDet) {
                final NonDetValue mapped = progConstMap.get(nonDet);
                assert mapped != null && targetProgram.getConstants().contains(mapped);
                return mapped;
            }
        };

        // --------------- Copy over body and translate ---------------
        final List<Event> bodyCopy = IRHelper.copyPath(func.getEntry(), func.getExit().getSuccessor(), new HashMap<>(), registerMap);
        bodyCopy.stream().filter(RegReader.class::isInstance).map(RegReader.class::cast)
                .forEach(reader -> reader.transformExpressions(translator));
        copy.append(bodyCopy);

        return copy;
    }

    public static Set<Register> collectWrittenRegisters(List<Event> events) {
        final Set<Register> regs = new HashSet<>();
        events.stream().filter(RegWriter.class::isInstance).map(RegWriter.class::cast)
                .forEach(writer -> regs.add(writer.getResultRegister()));
        return regs;
    }

    public static Set<MemoryObject> collectMemoryObjects(List<Event> events) {
        final Set<MemoryObject> set = new HashSet<>();
        final ExpressionInspector collector = new ExpressionInspector() {
            @Override
            public Expression visitMemoryObject(MemoryObject memObj) {
                set.add(memObj);
                return memObj;
            }
        };
        events.stream().filter(RegReader.class::isInstance).map(RegReader.class::cast)
                .forEach(reader -> reader.transformExpressions(collector));
        return set;
    }

    public static Set<NonDetValue> collectProgramConstants(List<Event> events) {
        final Set<NonDetValue> set = new HashSet<>();
        final ExpressionInspector collector = new ExpressionInspector() {
            @Override
            public Expression visitNonDetValue(NonDetValue nonDet) {
                set.add(nonDet);
                return nonDet;
            }
        };
        events.stream().filter(RegReader.class::isInstance).map(RegReader.class::cast)
                .forEach(reader -> reader.transformExpressions(collector));
        return set;
    }

    public static Map<Register, Register> copyOverRegisters(Iterable<Register> toCopy, Function to) {
        final Map<Register, Register> registerMap = new HashMap<>();
        for (Register reg : toCopy) {
            registerMap.put(reg, to.getOrNewRegister(reg.getName(), reg.getType()));
        }
        return registerMap;
    }
}
