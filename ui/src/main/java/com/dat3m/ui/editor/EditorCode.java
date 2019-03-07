package com.dat3m.ui.editor;

public enum EditorCode {

    PROGRAM, SOURCE_MM, TARGET_MM;

    @Override
    public String toString(){
        switch(this){
            case PROGRAM:
                return "Program";
            case SOURCE_MM:
                return "Source Memory Model";
            case TARGET_MM:
                return "Target Memory Model";
        }
        return super.toString();
    }
}
