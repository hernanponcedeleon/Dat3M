package com.dat3m.ui.options.utils;

public enum ControlCode {

    TASK, TARGET, ALIAS, BOUND, TIMEOUT, TEST, CLEAR, METHOD;

    @Override
    public String toString(){
        switch(this){
            case TASK:
                return "Task";
            case TARGET:
                return "Target";
            case ALIAS:
                return "Alias";
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
        }
        return super.toString();
    }

    public String actionCommand(){
        switch(this){
            case TASK:
                return "control_command_task";
            case TARGET:
                return "control_command_target";
            case ALIAS:
                return "control_command_alias";
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
        }
        throw new RuntimeException("Illegal EditorCode");
    }
}
