// Generated from Porthos.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class PorthosLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, COMP_OP=26, ARITH_OP=27, BOOL_OP=28, DIGIT=29, WORD=30, LETTER=31, 
		WS=32, LPAR=33, RPAR=34, LCBRA=35, RCBRA=36, COMMA=37, POINT=38, EQ=39, 
		NEQ=40, LEQ=41, LT=42, GEQ=43, GT=44, ADD=45, SUB=46, MULT=47, DIV=48, 
		MOD=49, AND=50, OR=51, ATOMIC=52;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", "T__24", 
		"COMP_OP", "ARITH_OP", "BOOL_OP", "DIGIT", "WORD", "LETTER", "WS", "LPAR", 
		"RPAR", "LCBRA", "RCBRA", "COMMA", "POINT", "EQ", "NEQ", "LEQ", "LT", 
		"GEQ", "GT", "ADD", "SUB", "MULT", "DIV", "MOD", "AND", "OR", "ATOMIC"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'True'", "'true'", "'False'", "'false'", "'H:'", "'<-'", "'<:-'", 
		"':='", "'='", "'load'", "'store'", "'mfence'", "'sync'", "'lwsync'", 
		"'isync'", "';'", "'if'", "'then'", "'else'", "'while'", "'['", "']'", 
		"'thread t'", "'exists'", "':'", null, null, null, null, null, null, null, 
		"'('", "')'", "'{'", "'}'", "','", "'.'", "'=='", "'!='", "'<='", "'<'", 
		"'>='", "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "'and'", "'or'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, "COMP_OP", "ARITH_OP", "BOOL_OP", "DIGIT", "WORD", "LETTER", 
		"WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", "POINT", "EQ", "NEQ", 
		"LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", "DIV", "MOD", "AND", "OR", 
		"ATOMIC"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public PorthosLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Porthos.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\66\u014a\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t"+
		" \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t"+
		"+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64"+
		"\t\64\4\65\t\65\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3"+
		"\4\3\4\3\4\3\5\3\5\3\5\3\5\3\5\3\5\3\6\3\6\3\6\3\7\3\7\3\7\3\b\3\b\3\b"+
		"\3\b\3\t\3\t\3\t\3\n\3\n\3\13\3\13\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\f"+
		"\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3"+
		"\17\3\17\3\17\3\17\3\17\3\20\3\20\3\20\3\20\3\20\3\20\3\21\3\21\3\22\3"+
		"\22\3\22\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3"+
		"\25\3\25\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30\3\30\3\30\3\30\3\30\3"+
		"\30\3\30\3\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\32\3\32\3\33\3\33\3"+
		"\33\3\33\3\33\3\33\5\33\u00e6\n\33\3\34\3\34\3\34\3\34\3\34\5\34\u00ed"+
		"\n\34\3\35\3\35\5\35\u00f1\n\35\3\36\6\36\u00f4\n\36\r\36\16\36\u00f5"+
		"\3\37\3\37\6\37\u00fa\n\37\r\37\16\37\u00fb\3 \3 \3!\6!\u0101\n!\r!\16"+
		"!\u0102\3!\3!\3\"\3\"\3#\3#\3$\3$\3%\3%\3&\3&\3\'\3\'\3(\3(\3(\3)\3)\3"+
		")\3*\3*\3*\3+\3+\3,\3,\3,\3-\3-\3.\3.\3/\3/\3\60\3\60\3\61\3\61\3\62\3"+
		"\62\3\63\3\63\3\63\3\63\3\64\3\64\3\64\3\65\3\65\3\65\3\65\3\65\3\65\3"+
		"\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3"+
		"\65\5\65\u0149\n\65\2\2\66\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25"+
		"\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32"+
		"\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a"+
		"\62c\63e\64g\65i\66\3\2\5\3\2\62;\4\2C\\c|\5\2\13\f\17\17\"\"\2\u015c"+
		"\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2"+
		"\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2"+
		"\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2"+
		"\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2"+
		"\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3"+
		"\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2"+
		"\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2"+
		"U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3"+
		"\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\3k\3\2\2\2\5p\3\2\2"+
		"\2\7u\3\2\2\2\t{\3\2\2\2\13\u0081\3\2\2\2\r\u0084\3\2\2\2\17\u0087\3\2"+
		"\2\2\21\u008b\3\2\2\2\23\u008e\3\2\2\2\25\u0090\3\2\2\2\27\u0095\3\2\2"+
		"\2\31\u009b\3\2\2\2\33\u00a2\3\2\2\2\35\u00a7\3\2\2\2\37\u00ae\3\2\2\2"+
		"!\u00b4\3\2\2\2#\u00b6\3\2\2\2%\u00b9\3\2\2\2\'\u00be\3\2\2\2)\u00c3\3"+
		"\2\2\2+\u00c9\3\2\2\2-\u00cb\3\2\2\2/\u00cd\3\2\2\2\61\u00d6\3\2\2\2\63"+
		"\u00dd\3\2\2\2\65\u00e5\3\2\2\2\67\u00ec\3\2\2\29\u00f0\3\2\2\2;\u00f3"+
		"\3\2\2\2=\u00f9\3\2\2\2?\u00fd\3\2\2\2A\u0100\3\2\2\2C\u0106\3\2\2\2E"+
		"\u0108\3\2\2\2G\u010a\3\2\2\2I\u010c\3\2\2\2K\u010e\3\2\2\2M\u0110\3\2"+
		"\2\2O\u0112\3\2\2\2Q\u0115\3\2\2\2S\u0118\3\2\2\2U\u011b\3\2\2\2W\u011d"+
		"\3\2\2\2Y\u0120\3\2\2\2[\u0122\3\2\2\2]\u0124\3\2\2\2_\u0126\3\2\2\2a"+
		"\u0128\3\2\2\2c\u012a\3\2\2\2e\u012c\3\2\2\2g\u0130\3\2\2\2i\u0148\3\2"+
		"\2\2kl\7V\2\2lm\7t\2\2mn\7w\2\2no\7g\2\2o\4\3\2\2\2pq\7v\2\2qr\7t\2\2"+
		"rs\7w\2\2st\7g\2\2t\6\3\2\2\2uv\7H\2\2vw\7c\2\2wx\7n\2\2xy\7u\2\2yz\7"+
		"g\2\2z\b\3\2\2\2{|\7h\2\2|}\7c\2\2}~\7n\2\2~\177\7u\2\2\177\u0080\7g\2"+
		"\2\u0080\n\3\2\2\2\u0081\u0082\7J\2\2\u0082\u0083\7<\2\2\u0083\f\3\2\2"+
		"\2\u0084\u0085\7>\2\2\u0085\u0086\7/\2\2\u0086\16\3\2\2\2\u0087\u0088"+
		"\7>\2\2\u0088\u0089\7<\2\2\u0089\u008a\7/\2\2\u008a\20\3\2\2\2\u008b\u008c"+
		"\7<\2\2\u008c\u008d\7?\2\2\u008d\22\3\2\2\2\u008e\u008f\7?\2\2\u008f\24"+
		"\3\2\2\2\u0090\u0091\7n\2\2\u0091\u0092\7q\2\2\u0092\u0093\7c\2\2\u0093"+
		"\u0094\7f\2\2\u0094\26\3\2\2\2\u0095\u0096\7u\2\2\u0096\u0097\7v\2\2\u0097"+
		"\u0098\7q\2\2\u0098\u0099\7t\2\2\u0099\u009a\7g\2\2\u009a\30\3\2\2\2\u009b"+
		"\u009c\7o\2\2\u009c\u009d\7h\2\2\u009d\u009e\7g\2\2\u009e\u009f\7p\2\2"+
		"\u009f\u00a0\7e\2\2\u00a0\u00a1\7g\2\2\u00a1\32\3\2\2\2\u00a2\u00a3\7"+
		"u\2\2\u00a3\u00a4\7{\2\2\u00a4\u00a5\7p\2\2\u00a5\u00a6\7e\2\2\u00a6\34"+
		"\3\2\2\2\u00a7\u00a8\7n\2\2\u00a8\u00a9\7y\2\2\u00a9\u00aa\7u\2\2\u00aa"+
		"\u00ab\7{\2\2\u00ab\u00ac\7p\2\2\u00ac\u00ad\7e\2\2\u00ad\36\3\2\2\2\u00ae"+
		"\u00af\7k\2\2\u00af\u00b0\7u\2\2\u00b0\u00b1\7{\2\2\u00b1\u00b2\7p\2\2"+
		"\u00b2\u00b3\7e\2\2\u00b3 \3\2\2\2\u00b4\u00b5\7=\2\2\u00b5\"\3\2\2\2"+
		"\u00b6\u00b7\7k\2\2\u00b7\u00b8\7h\2\2\u00b8$\3\2\2\2\u00b9\u00ba\7v\2"+
		"\2\u00ba\u00bb\7j\2\2\u00bb\u00bc\7g\2\2\u00bc\u00bd\7p\2\2\u00bd&\3\2"+
		"\2\2\u00be\u00bf\7g\2\2\u00bf\u00c0\7n\2\2\u00c0\u00c1\7u\2\2\u00c1\u00c2"+
		"\7g\2\2\u00c2(\3\2\2\2\u00c3\u00c4\7y\2\2\u00c4\u00c5\7j\2\2\u00c5\u00c6"+
		"\7k\2\2\u00c6\u00c7\7n\2\2\u00c7\u00c8\7g\2\2\u00c8*\3\2\2\2\u00c9\u00ca"+
		"\7]\2\2\u00ca,\3\2\2\2\u00cb\u00cc\7_\2\2\u00cc.\3\2\2\2\u00cd\u00ce\7"+
		"v\2\2\u00ce\u00cf\7j\2\2\u00cf\u00d0\7t\2\2\u00d0\u00d1\7g\2\2\u00d1\u00d2"+
		"\7c\2\2\u00d2\u00d3\7f\2\2\u00d3\u00d4\7\"\2\2\u00d4\u00d5\7v\2\2\u00d5"+
		"\60\3\2\2\2\u00d6\u00d7\7g\2\2\u00d7\u00d8\7z\2\2\u00d8\u00d9\7k\2\2\u00d9"+
		"\u00da\7u\2\2\u00da\u00db\7v\2\2\u00db\u00dc\7u\2\2\u00dc\62\3\2\2\2\u00dd"+
		"\u00de\7<\2\2\u00de\64\3\2\2\2\u00df\u00e6\5O(\2\u00e0\u00e6\5Q)\2\u00e1"+
		"\u00e6\5S*\2\u00e2\u00e6\5U+\2\u00e3\u00e6\5W,\2\u00e4\u00e6\5Y-\2\u00e5"+
		"\u00df\3\2\2\2\u00e5\u00e0\3\2\2\2\u00e5\u00e1\3\2\2\2\u00e5\u00e2\3\2"+
		"\2\2\u00e5\u00e3\3\2\2\2\u00e5\u00e4\3\2\2\2\u00e6\66\3\2\2\2\u00e7\u00ed"+
		"\5[.\2\u00e8\u00ed\5]/\2\u00e9\u00ed\5_\60\2\u00ea\u00ed\5a\61\2\u00eb"+
		"\u00ed\5c\62\2\u00ec\u00e7\3\2\2\2\u00ec\u00e8\3\2\2\2\u00ec\u00e9\3\2"+
		"\2\2\u00ec\u00ea\3\2\2\2\u00ec\u00eb\3\2\2\2\u00ed8\3\2\2\2\u00ee\u00f1"+
		"\5e\63\2\u00ef\u00f1\5g\64\2\u00f0\u00ee\3\2\2\2\u00f0\u00ef\3\2\2\2\u00f1"+
		":\3\2\2\2\u00f2\u00f4\t\2\2\2\u00f3\u00f2\3\2\2\2\u00f4\u00f5\3\2\2\2"+
		"\u00f5\u00f3\3\2\2\2\u00f5\u00f6\3\2\2\2\u00f6<\3\2\2\2\u00f7\u00fa\5"+
		"? \2\u00f8\u00fa\5;\36\2\u00f9\u00f7\3\2\2\2\u00f9\u00f8\3\2\2\2\u00fa"+
		"\u00fb\3\2\2\2\u00fb\u00f9\3\2\2\2\u00fb\u00fc\3\2\2\2\u00fc>\3\2\2\2"+
		"\u00fd\u00fe\t\3\2\2\u00fe@\3\2\2\2\u00ff\u0101\t\4\2\2\u0100\u00ff\3"+
		"\2\2\2\u0101\u0102\3\2\2\2\u0102\u0100\3\2\2\2\u0102\u0103\3\2\2\2\u0103"+
		"\u0104\3\2\2\2\u0104\u0105\b!\2\2\u0105B\3\2\2\2\u0106\u0107\7*\2\2\u0107"+
		"D\3\2\2\2\u0108\u0109\7+\2\2\u0109F\3\2\2\2\u010a\u010b\7}\2\2\u010bH"+
		"\3\2\2\2\u010c\u010d\7\177\2\2\u010dJ\3\2\2\2\u010e\u010f\7.\2\2\u010f"+
		"L\3\2\2\2\u0110\u0111\7\60\2\2\u0111N\3\2\2\2\u0112\u0113\7?\2\2\u0113"+
		"\u0114\7?\2\2\u0114P\3\2\2\2\u0115\u0116\7#\2\2\u0116\u0117\7?\2\2\u0117"+
		"R\3\2\2\2\u0118\u0119\7>\2\2\u0119\u011a\7?\2\2\u011aT\3\2\2\2\u011b\u011c"+
		"\7>\2\2\u011cV\3\2\2\2\u011d\u011e\7@\2\2\u011e\u011f\7?\2\2\u011fX\3"+
		"\2\2\2\u0120\u0121\7@\2\2\u0121Z\3\2\2\2\u0122\u0123\7-\2\2\u0123\\\3"+
		"\2\2\2\u0124\u0125\7/\2\2\u0125^\3\2\2\2\u0126\u0127\7,\2\2\u0127`\3\2"+
		"\2\2\u0128\u0129\7\61\2\2\u0129b\3\2\2\2\u012a\u012b\7\'\2\2\u012bd\3"+
		"\2\2\2\u012c\u012d\7c\2\2\u012d\u012e\7p\2\2\u012e\u012f\7f\2\2\u012f"+
		"f\3\2\2\2\u0130\u0131\7q\2\2\u0131\u0132\7t\2\2\u0132h\3\2\2\2\u0133\u0134"+
		"\7a\2\2\u0134\u0135\7p\2\2\u0135\u0149\7c\2\2\u0136\u0137\7a\2\2\u0137"+
		"\u0138\7u\2\2\u0138\u0149\7e\2\2\u0139\u013a\7a\2\2\u013a\u013b\7t\2\2"+
		"\u013b\u0149\7z\2\2\u013c\u013d\7a\2\2\u013d\u013e\7c\2\2\u013e\u013f"+
		"\7e\2\2\u013f\u0149\7s\2\2\u0140\u0141\7a\2\2\u0141\u0142\7t\2\2\u0142"+
		"\u0143\7g\2\2\u0143\u0149\7n\2\2\u0144\u0145\7a\2\2\u0145\u0146\7e\2\2"+
		"\u0146\u0147\7q\2\2\u0147\u0149\7p\2\2\u0148\u0133\3\2\2\2\u0148\u0136"+
		"\3\2\2\2\u0148\u0139\3\2\2\2\u0148\u013c\3\2\2\2\u0148\u0140\3\2\2\2\u0148"+
		"\u0144\3\2\2\2\u0149j\3\2\2\2\13\2\u00e5\u00ec\u00f0\u00f5\u00f9\u00fb"+
		"\u0102\u0148\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}