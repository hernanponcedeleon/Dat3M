package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;

import java.util.Map;
import java.util.stream.Collectors;

class VisitorHelper {

    static void applyPostParsing(Program program, Map<String, Label> labelMap) {
        for (Thread thread : program.getThreads()) {
            thread.append(labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel));
        }
        if (labelMap.values().stream().anyMatch(label -> label.getPredecessor() == null)) {
            throw new MalformedProgramException(String.format("Reference to undefined labels %s.",
                    labelMap.values().stream()
                            .filter(label -> label.getPredecessor() == null)
                            .map(Label::getName)
                            .collect(Collectors.joining(", "))));
        }
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
    }
}
