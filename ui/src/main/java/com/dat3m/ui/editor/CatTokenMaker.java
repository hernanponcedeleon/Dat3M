package com.dat3m.ui.editor;

import org.fife.ui.rsyntaxtextarea.AbstractTokenMakerFactory;
import org.fife.ui.rsyntaxtextarea.Token;
import org.fife.ui.rsyntaxtextarea.TokenMakerBase;
import org.fife.ui.rsyntaxtextarea.TokenMakerFactory;

import javax.swing.text.Segment;
import java.util.Set;

// Syntax highlighting for memory models written in CAT.
public class CatTokenMaker extends TokenMakerBase {

    public static final String SYNTAX_STYLE_CAT = "text/cat";

    private static final Set<String> KEYWORDS = Set.of(
            "let", "rec", "and", "as", "show", "include", "cut",
            "acyclic", "irreflexive", "empty", "flag", "undefined_unless");
    private static final Set<String> FUNCTIONS = Set.of("domain", "range", "toid", "newSet", "newRelation");

    // The two kinds of block comments end differently, so they are tracked by different token types.
    private static final int ML_COMMENT = Token.COMMENT_MULTILINE;
    private static final int C_COMMENT = Token.COMMENT_DOCUMENTATION;

    public static void register() {
        final AbstractTokenMakerFactory factory = (AbstractTokenMakerFactory) TokenMakerFactory.getDefaultInstance();
        factory.putMapping(SYNTAX_STYLE_CAT, CatTokenMaker.class.getName());
    }

    @Override
    public Token getTokenList(Segment text, int initialTokenType, int startOffset) {
        resetTokenList();
        final char[] array = text.array;
        final int end = text.offset + text.count;
        final int shift = startOffset - text.offset;
        int i = text.offset;

        if (initialTokenType == ML_COMMENT || initialTokenType == C_COMMENT) {
            final int commentEnd = findCommentEnd(array, i, end, initialTokenType);
            if (commentEnd < 0) {
                // The comment continues on the next line. An empty line still needs a token to carry the state.
                addToken(array, i, end - 1, initialTokenType, i + shift);
                return firstToken;
            }
            addToken(array, i, commentEnd - 1, initialTokenType, i + shift);
            i = commentEnd;
        }

        while (i < end) {
            final char c = array[i];
            final int start = i;
            if (Character.isWhitespace(c)) {
                while (i < end && Character.isWhitespace(array[i])) {
                    i++;
                }
                addToken(array, start, i - 1, Token.WHITESPACE, start + shift);
            } else if (c == '/' && i + 1 < end && array[i + 1] == '/') {
                addToken(array, start, end - 1, Token.COMMENT_EOL, start + shift);
                i = end;
            } else if ((c == '(' || c == '/') && i + 1 < end && array[i + 1] == '*') {
                final int type = c == '(' ? ML_COMMENT : C_COMMENT;
                final int commentEnd = findCommentEnd(array, i + 2, end, type);
                if (commentEnd < 0) {
                    addToken(array, start, end - 1, type, start + shift);
                    return firstToken;
                }
                addToken(array, start, commentEnd - 1, type, start + shift);
                i = commentEnd;
            } else if (c == '"') {
                i++;
                while (i < end && array[i] != '"') {
                    i++;
                }
                i = Math.min(i + 1, end);
                addToken(array, start, i - 1, Token.LITERAL_STRING_DOUBLE_QUOTE, start + shift);
            } else if (Character.isLetter(c) || c == '_') {
                while (i < end && isNamePart(array[i])) {
                    i++;
                }
                final String name = new String(array, start, i - start);
                final int type = KEYWORDS.contains(name) ? Token.RESERVED_WORD
                        : FUNCTIONS.contains(name) ? Token.RESERVED_WORD_2
                        : Token.IDENTIFIER;
                addToken(array, start, i - 1, type, start + shift);
            } else if (Character.isDigit(c)) {
                while (i < end && Character.isDigit(array[i])) {
                    i++;
                }
                addToken(array, start, i - 1, Token.LITERAL_NUMBER_DECIMAL_INT, start + shift);
            } else {
                i++;
                final boolean isSeparator = c == '(' || c == ')' || c == '[' || c == ']' || c == ',';
                addToken(array, start, start, isSeparator ? Token.SEPARATOR : Token.OPERATOR, start + shift);
            }
        }

        addNullToken();
        return firstToken;
    }

    // Returns the index after the end of the comment, or -1 if the comment does not end in [from, end).
    private static int findCommentEnd(char[] array, int from, int end, int commentType) {
        final char closer = commentType == ML_COMMENT ? ')' : '/';
        for (int i = from; i + 1 < end; i++) {
            if (array[i] == '*' && array[i + 1] == closer) {
                return i + 2;
            }
        }
        return -1;
    }

    // Names in CAT may contain dots and hyphens, e.g., po-loc.
    private static boolean isNamePart(char c) {
        return Character.isLetterOrDigit(c) || c == '_' || c == '.' || c == '-';
    }

    @Override
    public String[] getLineCommentStartAndEnd(int languageIndex) {
        return new String[]{"//", null};
    }
}
