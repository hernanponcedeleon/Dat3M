package com.dat3m.ui.options.utils;

public enum ControlCode {

    TASK, TARGET, BOUND, TIMEOUT, TEST, CANCEL, CLEAR, METHOD, SOLVER, PROGRESS;

    @Override
    public String toString() {
        return switch (this) {
            case TASK -> "Task";
            case TARGET -> "Target";
            case BOUND -> "Bound";
            case TIMEOUT -> "Timeout";
            case TEST -> "Test";
            case CANCEL -> "Cancel";
            case CLEAR -> "Clear";
            case METHOD -> "Method";
            case SOLVER -> "Solver";
            case PROGRESS -> "Forward Progress";
        };
    }

    public String actionCommand() {
        return switch (this) {
            case TASK -> "control_command_task";
            case TARGET -> "control_command_target";
            case BOUND -> "control_command_bound";
            case TIMEOUT -> "control_command_timeout";
            case TEST -> "control_command_test";
            case CANCEL -> "control_command_cancel";
            case CLEAR -> "control_command_clear";
            case METHOD -> "control_command_method";
            case SOLVER -> "control_command_solver";
            case PROGRESS -> "control_command_progress";
        };
    }
}
