package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.IntStream;

class ParserLitmus implements ParserInterface {

    private static final String TYPE_AARCH64 = "AARCH64";
    private static final String TYPE_PPC = "PPC";
    private static final String TYPE_RISCV = "RISCV";
    private static final String TYPE_X86 = "X86";
    private static final String TYPE_PTX = "PTX";
    private static final String TYPE_VULKAN = "VULKAN";
    private static final String TYPE_C = "C";
    private static final String TYPE_OPENCL = "OPENCL";

    @Override
    public Program parse(CharStream charStream) {
        return getParser(getFirstWord(peekFirstLine(charStream))).parse(charStream);
    }

    private static ParserLitmus getParser(String type) {
        return switch (type.toUpperCase()) {
            case TYPE_AARCH64 -> new ParserLitmusAArch64();
            case TYPE_PPC -> new ParserLitmusPPC();
            case TYPE_X86 -> new ParserLitmusX86();
            case TYPE_RISCV -> new ParserLitmusRISCV();
            case TYPE_PTX -> new ParserLitmusPTX();
            case TYPE_VULKAN -> new ParserLitmusVulkan();
            case TYPE_C, TYPE_OPENCL -> new ParserLitmusC();
            default -> throw new ParsingException("No litmus parser recognizes the input.");
        };
    }

    private static String getFirstWord(String line) {
        final String trimmedLine = line.stripLeading();
        final int endOfFirstWord = trimmedLine.indexOf(" ");
        return endOfFirstWord == -1 ? trimmedLine : trimmedLine.substring(0, endOfFirstWord);
    }

    private static String peekFirstLine(CharStream input) {
        final StringBuilder line = new StringBuilder();
        for (int index = 1;; index++) {
            final int character = input.LA(index);
            if (character == IntStream.EOF || character == '\n') {
                return line.toString();
            }
            if (character != '\r') {
                line.append((char) character);
            }
        }
    }
}
