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
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, COMP_OP=23, ARITH_OP=24, 
		BOOL_OP=25, DIGIT=26, WORD=27, LETTER=28, WS=29, LPAR=30, RPAR=31, LCBRA=32, 
		RCBRA=33, COMMA=34, POINT=35, EQ=36, NEQ=37, LEQ=38, LT=39, GEQ=40, GT=41, 
		ADD=42, SUB=43, MULT=44, DIV=45, MOD=46, AND=47, OR=48, ATOMIC=49;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "T__18", "T__19", "T__20", "T__21", "COMP_OP", "ARITH_OP", "BOOL_OP", 
		"DIGIT", "WORD", "LETTER", "WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", 
		"POINT", "EQ", "NEQ", "LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", 
		"DIV", "MOD", "AND", "OR", "ATOMIC"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'True'", "'true'", "'False'", "'false'", "'<-'", "'<:-'", "':='", 
		"'='", "'load'", "'store'", "'mfence'", "'sync'", "'lwsync'", "'isync'", 
		"';'", "'if'", "'then'", "'else'", "'while'", "'thread t'", "'exists'", 
		"':'", null, null, null, null, null, null, null, "'('", "')'", "'{'", 
		"'}'", "','", "'.'", "'=='", "'!='", "'<='", "'<'", "'>='", "'>'", "'+'", 
		"'-'", "'*'", "'/'", "'%'", "'and'", "'or'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, "COMP_OP", 
		"ARITH_OP", "BOOL_OP", "DIGIT", "WORD", "LETTER", "WS", "LPAR", "RPAR", 
		"LCBRA", "RCBRA", "COMMA", "POINT", "EQ", "NEQ", "LEQ", "LT", "GEQ", "GT", 
		"ADD", "SUB", "MULT", "DIV", "MOD", "AND", "OR", "ATOMIC"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\63\u013a\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t"+
		" \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t"+
		"+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\3\2\3\2\3\2\3"+
		"\2\3\2\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3\5"+
		"\3\5\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\t\3\t\3\n\3\n\3\n\3\n\3"+
		"\n\3\13\3\13\3\13\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\r\3\r\3"+
		"\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17"+
		"\3\17\3\20\3\20\3\21\3\21\3\21\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23"+
		"\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\27\3\27\3\30\3\30"+
		"\3\30\3\30\3\30\3\30\5\30\u00d9\n\30\3\31\3\31\3\31\3\31\3\31\5\31\u00e0"+
		"\n\31\3\32\3\32\5\32\u00e4\n\32\3\33\3\33\3\34\3\34\6\34\u00ea\n\34\r"+
		"\34\16\34\u00eb\3\35\3\35\3\36\6\36\u00f1\n\36\r\36\16\36\u00f2\3\36\3"+
		"\36\3\37\3\37\3 \3 \3!\3!\3\"\3\"\3#\3#\3$\3$\3%\3%\3%\3&\3&\3&\3\'\3"+
		"\'\3\'\3(\3(\3)\3)\3)\3*\3*\3+\3+\3,\3,\3-\3-\3.\3.\3/\3/\3\60\3\60\3"+
		"\60\3\60\3\61\3\61\3\61\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3"+
		"\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\5\62\u0139"+
		"\n\62\2\2\63\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16"+
		"\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33\65\34"+
		"\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62c\63\3\2\5"+
		"\3\2\62;\4\2C\\c|\5\2\13\f\17\17\"\"\2\u014b\2\3\3\2\2\2\2\5\3\2\2\2\2"+
		"\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2"+
		"\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2"+
		"\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2"+
		"\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2"+
		"\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2"+
		"\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2"+
		"M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3"+
		"\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\3e\3\2\2"+
		"\2\5j\3\2\2\2\7o\3\2\2\2\tu\3\2\2\2\13{\3\2\2\2\r~\3\2\2\2\17\u0082\3"+
		"\2\2\2\21\u0085\3\2\2\2\23\u0087\3\2\2\2\25\u008c\3\2\2\2\27\u0092\3\2"+
		"\2\2\31\u0099\3\2\2\2\33\u009e\3\2\2\2\35\u00a5\3\2\2\2\37\u00ab\3\2\2"+
		"\2!\u00ad\3\2\2\2#\u00b0\3\2\2\2%\u00b5\3\2\2\2\'\u00ba\3\2\2\2)\u00c0"+
		"\3\2\2\2+\u00c9\3\2\2\2-\u00d0\3\2\2\2/\u00d8\3\2\2\2\61\u00df\3\2\2\2"+
		"\63\u00e3\3\2\2\2\65\u00e5\3\2\2\2\67\u00e9\3\2\2\29\u00ed\3\2\2\2;\u00f0"+
		"\3\2\2\2=\u00f6\3\2\2\2?\u00f8\3\2\2\2A\u00fa\3\2\2\2C\u00fc\3\2\2\2E"+
		"\u00fe\3\2\2\2G\u0100\3\2\2\2I\u0102\3\2\2\2K\u0105\3\2\2\2M\u0108\3\2"+
		"\2\2O\u010b\3\2\2\2Q\u010d\3\2\2\2S\u0110\3\2\2\2U\u0112\3\2\2\2W\u0114"+
		"\3\2\2\2Y\u0116\3\2\2\2[\u0118\3\2\2\2]\u011a\3\2\2\2_\u011c\3\2\2\2a"+
		"\u0120\3\2\2\2c\u0138\3\2\2\2ef\7V\2\2fg\7t\2\2gh\7w\2\2hi\7g\2\2i\4\3"+
		"\2\2\2jk\7v\2\2kl\7t\2\2lm\7w\2\2mn\7g\2\2n\6\3\2\2\2op\7H\2\2pq\7c\2"+
		"\2qr\7n\2\2rs\7u\2\2st\7g\2\2t\b\3\2\2\2uv\7h\2\2vw\7c\2\2wx\7n\2\2xy"+
		"\7u\2\2yz\7g\2\2z\n\3\2\2\2{|\7>\2\2|}\7/\2\2}\f\3\2\2\2~\177\7>\2\2\177"+
		"\u0080\7<\2\2\u0080\u0081\7/\2\2\u0081\16\3\2\2\2\u0082\u0083\7<\2\2\u0083"+
		"\u0084\7?\2\2\u0084\20\3\2\2\2\u0085\u0086\7?\2\2\u0086\22\3\2\2\2\u0087"+
		"\u0088\7n\2\2\u0088\u0089\7q\2\2\u0089\u008a\7c\2\2\u008a\u008b\7f\2\2"+
		"\u008b\24\3\2\2\2\u008c\u008d\7u\2\2\u008d\u008e\7v\2\2\u008e\u008f\7"+
		"q\2\2\u008f\u0090\7t\2\2\u0090\u0091\7g\2\2\u0091\26\3\2\2\2\u0092\u0093"+
		"\7o\2\2\u0093\u0094\7h\2\2\u0094\u0095\7g\2\2\u0095\u0096\7p\2\2\u0096"+
		"\u0097\7e\2\2\u0097\u0098\7g\2\2\u0098\30\3\2\2\2\u0099\u009a\7u\2\2\u009a"+
		"\u009b\7{\2\2\u009b\u009c\7p\2\2\u009c\u009d\7e\2\2\u009d\32\3\2\2\2\u009e"+
		"\u009f\7n\2\2\u009f\u00a0\7y\2\2\u00a0\u00a1\7u\2\2\u00a1\u00a2\7{\2\2"+
		"\u00a2\u00a3\7p\2\2\u00a3\u00a4\7e\2\2\u00a4\34\3\2\2\2\u00a5\u00a6\7"+
		"k\2\2\u00a6\u00a7\7u\2\2\u00a7\u00a8\7{\2\2\u00a8\u00a9\7p\2\2\u00a9\u00aa"+
		"\7e\2\2\u00aa\36\3\2\2\2\u00ab\u00ac\7=\2\2\u00ac \3\2\2\2\u00ad\u00ae"+
		"\7k\2\2\u00ae\u00af\7h\2\2\u00af\"\3\2\2\2\u00b0\u00b1\7v\2\2\u00b1\u00b2"+
		"\7j\2\2\u00b2\u00b3\7g\2\2\u00b3\u00b4\7p\2\2\u00b4$\3\2\2\2\u00b5\u00b6"+
		"\7g\2\2\u00b6\u00b7\7n\2\2\u00b7\u00b8\7u\2\2\u00b8\u00b9\7g\2\2\u00b9"+
		"&\3\2\2\2\u00ba\u00bb\7y\2\2\u00bb\u00bc\7j\2\2\u00bc\u00bd\7k\2\2\u00bd"+
		"\u00be\7n\2\2\u00be\u00bf\7g\2\2\u00bf(\3\2\2\2\u00c0\u00c1\7v\2\2\u00c1"+
		"\u00c2\7j\2\2\u00c2\u00c3\7t\2\2\u00c3\u00c4\7g\2\2\u00c4\u00c5\7c\2\2"+
		"\u00c5\u00c6\7f\2\2\u00c6\u00c7\7\"\2\2\u00c7\u00c8\7v\2\2\u00c8*\3\2"+
		"\2\2\u00c9\u00ca\7g\2\2\u00ca\u00cb\7z\2\2\u00cb\u00cc\7k\2\2\u00cc\u00cd"+
		"\7u\2\2\u00cd\u00ce\7v\2\2\u00ce\u00cf\7u\2\2\u00cf,\3\2\2\2\u00d0\u00d1"+
		"\7<\2\2\u00d1.\3\2\2\2\u00d2\u00d9\5I%\2\u00d3\u00d9\5K&\2\u00d4\u00d9"+
		"\5M\'\2\u00d5\u00d9\5O(\2\u00d6\u00d9\5Q)\2\u00d7\u00d9\5S*\2\u00d8\u00d2"+
		"\3\2\2\2\u00d8\u00d3\3\2\2\2\u00d8\u00d4\3\2\2\2\u00d8\u00d5\3\2\2\2\u00d8"+
		"\u00d6\3\2\2\2\u00d8\u00d7\3\2\2\2\u00d9\60\3\2\2\2\u00da\u00e0\5U+\2"+
		"\u00db\u00e0\5W,\2\u00dc\u00e0\5Y-\2\u00dd\u00e0\5[.\2\u00de\u00e0\5]"+
		"/\2\u00df\u00da\3\2\2\2\u00df\u00db\3\2\2\2\u00df\u00dc\3\2\2\2\u00df"+
		"\u00dd\3\2\2\2\u00df\u00de\3\2\2\2\u00e0\62\3\2\2\2\u00e1\u00e4\5_\60"+
		"\2\u00e2\u00e4\5a\61\2\u00e3\u00e1\3\2\2\2\u00e3\u00e2\3\2\2\2\u00e4\64"+
		"\3\2\2\2\u00e5\u00e6\t\2\2\2\u00e6\66\3\2\2\2\u00e7\u00ea\59\35\2\u00e8"+
		"\u00ea\5\65\33\2\u00e9\u00e7\3\2\2\2\u00e9\u00e8\3\2\2\2\u00ea\u00eb\3"+
		"\2\2\2\u00eb\u00e9\3\2\2\2\u00eb\u00ec\3\2\2\2\u00ec8\3\2\2\2\u00ed\u00ee"+
		"\t\3\2\2\u00ee:\3\2\2\2\u00ef\u00f1\t\4\2\2\u00f0\u00ef\3\2\2\2\u00f1"+
		"\u00f2\3\2\2\2\u00f2\u00f0\3\2\2\2\u00f2\u00f3\3\2\2\2\u00f3\u00f4\3\2"+
		"\2\2\u00f4\u00f5\b\36\2\2\u00f5<\3\2\2\2\u00f6\u00f7\7*\2\2\u00f7>\3\2"+
		"\2\2\u00f8\u00f9\7+\2\2\u00f9@\3\2\2\2\u00fa\u00fb\7}\2\2\u00fbB\3\2\2"+
		"\2\u00fc\u00fd\7\177\2\2\u00fdD\3\2\2\2\u00fe\u00ff\7.\2\2\u00ffF\3\2"+
		"\2\2\u0100\u0101\7\60\2\2\u0101H\3\2\2\2\u0102\u0103\7?\2\2\u0103\u0104"+
		"\7?\2\2\u0104J\3\2\2\2\u0105\u0106\7#\2\2\u0106\u0107\7?\2\2\u0107L\3"+
		"\2\2\2\u0108\u0109\7>\2\2\u0109\u010a\7?\2\2\u010aN\3\2\2\2\u010b\u010c"+
		"\7>\2\2\u010cP\3\2\2\2\u010d\u010e\7@\2\2\u010e\u010f\7?\2\2\u010fR\3"+
		"\2\2\2\u0110\u0111\7@\2\2\u0111T\3\2\2\2\u0112\u0113\7-\2\2\u0113V\3\2"+
		"\2\2\u0114\u0115\7/\2\2\u0115X\3\2\2\2\u0116\u0117\7,\2\2\u0117Z\3\2\2"+
		"\2\u0118\u0119\7\61\2\2\u0119\\\3\2\2\2\u011a\u011b\7\'\2\2\u011b^\3\2"+
		"\2\2\u011c\u011d\7c\2\2\u011d\u011e\7p\2\2\u011e\u011f\7f\2\2\u011f`\3"+
		"\2\2\2\u0120\u0121\7q\2\2\u0121\u0122\7t\2\2\u0122b\3\2\2\2\u0123\u0124"+
		"\7a\2\2\u0124\u0125\7p\2\2\u0125\u0139\7c\2\2\u0126\u0127\7a\2\2\u0127"+
		"\u0128\7u\2\2\u0128\u0139\7e\2\2\u0129\u012a\7a\2\2\u012a\u012b\7t\2\2"+
		"\u012b\u0139\7z\2\2\u012c\u012d\7a\2\2\u012d\u012e\7c\2\2\u012e\u012f"+
		"\7e\2\2\u012f\u0139\7s\2\2\u0130\u0131\7a\2\2\u0131\u0132\7t\2\2\u0132"+
		"\u0133\7g\2\2\u0133\u0139\7n\2\2\u0134\u0135\7a\2\2\u0135\u0136\7e\2\2"+
		"\u0136\u0137\7q\2\2\u0137\u0139\7p\2\2\u0138\u0123\3\2\2\2\u0138\u0126"+
		"\3\2\2\2\u0138\u0129\3\2\2\2\u0138\u012c\3\2\2\2\u0138\u0130\3\2\2\2\u0138"+
		"\u0134\3\2\2\2\u0139d\3\2\2\2\n\2\u00d8\u00df\u00e3\u00e9\u00eb\u00f2"+
		"\u0138\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}