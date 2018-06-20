package porthosc.languages.conversion.toxgraph.hooks;


interface XInvocationHook {

    // TODO: work with signature
    XInvocationHookAction tryInterceptInvocation(String methodName);
}
