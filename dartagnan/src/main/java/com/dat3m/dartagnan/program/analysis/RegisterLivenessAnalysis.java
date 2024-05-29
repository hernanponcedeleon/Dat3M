package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Label;

import java.util.*;

public class RegisterLivenessAnalysis {

    private final Map<Label, Set<Register>> liveRegistersAtLabel = new HashMap<>();

    public RegisterLivenessAnalysis forFunction(Function f) {
        List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(f).getLoopsOfFunction(f);
        Map<Label, Set<Register>> liveRegsAtLabel = new HashMap<>();
        Set<Register> liveRegs = new HashSet<>();
        Event cur = f.getExit();

        while (cur != null) {

            if (cur instanceof RegWriter writer) {
                liveRegs.remove(writer.getResultRegister());
            }

            if (cur instanceof RegReader reader) {
                reader.getRegisterReads().stream().map(Register.Read::register).forEach(liveRegs::add);
            }

            if (cur instanceof Label label) {
                liveRegsAtLabel.put(label, liveRegs);
            }

            //if (cur instanceof )
        }


        return new RegisterLivenessAnalysis();
    }
}
