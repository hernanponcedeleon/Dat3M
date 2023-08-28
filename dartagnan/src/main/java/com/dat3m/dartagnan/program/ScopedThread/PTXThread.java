package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;

import java.util.List;

public class PTXThread extends ScopedThread {

    // There is a unique system level

    public PTXThread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry,
                     int GpuId, int CtaId) {
        super(name, funcType, parameterNames, id,  entry);
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }

}
