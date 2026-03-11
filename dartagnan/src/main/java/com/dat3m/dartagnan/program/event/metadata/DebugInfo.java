package com.dat3m.dartagnan.program.event.metadata;

sealed interface DebugInfo extends Metadata permits SourceLocation, LineNumber {}