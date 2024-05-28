package com.dat3m.ui.options.utils;

public enum ControlCode {

    TASK, TARGET, BOUND, TIMEOUT, TEST, CLEAR, METHOD, SOLVER, PROPERTY;

    @Override
    public String toString(){
        switch(this){
            case TASK:
                return "Task";
            case TARGET:
                return "Target";
            case BOUND:
                return "Bound";
            case TIMEOUT:
                return "Timeout";
            case TEST:
                return "Test";
            case CLEAR:
                return "Clear";
            case METHOD:
                return "Method";
            case SOLVER:
                return "Solver";
            case PROPERTY:
                return "Property";
        }
        return super.toString();
    }

    public String actionCommand(){
        switch(this){
            case TASK:
                return "control_command_task";
            case TARGET:
                return "control_command_target";
            case BOUND:
                return "control_command_bound";
            case TIMEOUT:
                return "control_command_timeout";
            case TEST:
                return "control_command_test";
            case CLEAR:
                return "control_command_clear";
            case METHOD:
                return "control_command_method";
            case SOLVER:
                return "control_command_solver";
            case PROPERTY:
                return "control_command_property";
        }
        throw new RuntimeException("Illegal EditorCode");
    }
}
