package com.dat3m.ui.editor;

public enum EditorCode {

    PROGRAM, TARGET_MM;

    @Override
    public String toString() {
        return switch (this) {
            case PROGRAM -> "Program";
            case TARGET_MM -> "Target Memory Model";
        };
    }

    public String editorMenuImportActionCommand() {
        return switch (this) {
            case PROGRAM -> "editor_menu_import_action_program";
            case TARGET_MM -> "editor_menu_import_action_target_mm";
        };
    }

    public String editorMenuExportActionCommand() {
        return switch (this) {
            case PROGRAM -> "editor_menu_export_action_program";
            case TARGET_MM -> "editor_menu_export_action_target_mm";
        };
    }

    public String editorActionCommand() {
        return switch (this) {
            case PROGRAM -> "editor_action_program";
            case TARGET_MM -> "editor_action_target_mm";
        };
    }
}
