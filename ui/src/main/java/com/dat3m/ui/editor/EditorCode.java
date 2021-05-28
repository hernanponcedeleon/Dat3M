package com.dat3m.ui.editor;

public enum EditorCode {

    PROGRAM, TARGET_MM;

    @Override
    public String toString(){
        switch(this){
            case PROGRAM:
                return "Program";
            case TARGET_MM:
                return "Target Memory Model";
        }
        return super.toString();
    }

    public String editorMenuImportActionCommand(){
        switch(this){
            case PROGRAM:
                return "editor_menu_import_action_program";
            case TARGET_MM:
                return "editor_menu_import_action_target_mm";
        }
        throw new RuntimeException("Illegal EditorCode");
    }

    public String editorMenuExportActionCommand(){
        switch(this){
            case PROGRAM:
                return "editor_menu_export_action_program";
            case TARGET_MM:
                return "editor_menu_export_action_target_mm";
        }
        throw new RuntimeException("Illegal EditorCode");
    }

    public String editorActionCommand(){
        switch(this){
            case PROGRAM:
                return "editor_action_program";
            case TARGET_MM:
                return "editor_action_target_mm";
        }
        throw new RuntimeException("Illegal EditorCode");
    }
}
