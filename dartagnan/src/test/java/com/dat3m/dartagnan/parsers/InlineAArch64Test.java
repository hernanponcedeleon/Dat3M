package com.dat3m.dartagnan.parsers;


import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.junit.Test;

public class InlineAArch64Test {


    @Test
    public void InlineAArch64Test() throws IOException{
        Path path = Paths.get("/home/stefano/huawei/test_inline/mock.txt");
        String input = Files.readString(path, StandardCharsets.UTF_8);
        System.out.println(input);
        // CharStream charStream = CharStreams.fromString(input);
        // ParserInlineAArch64 parser = new ParserInlineAArch64(null,null,null); // this breaks the test because its going to try and create registers under null function
        // parser.parse(charStream);
    }
}
