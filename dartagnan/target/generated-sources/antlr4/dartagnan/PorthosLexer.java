// Generated from Porthos.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.asserts.AssertCompositeAnd;
import dartagnan.asserts.AssertLocation;
import dartagnan.asserts.AssertRegister;
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
		T__24=25, T__25=26, COMP_OP=27, ARITH_OP=28, BOOL_OP=29, DIGIT=30, WORD=31, 
		LETTER=32, WS=33, LPAR=34, RPAR=35, LCBRA=36, RCBRA=37, COMMA=38, POINT=39, 
		EQ=40, NEQ=41, LEQ=42, LT=43, GEQ=44, GT=45, ADD=46, SUB=47, MULT=48, 
		DIV=49, MOD=50, AND=51, OR=52, XOR=53, ATOMIC=54;
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
		"T__25", "COMP_OP", "ARITH_OP", "BOOL_OP", "DIGIT", "WORD", "LETTER", 
		"WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", "POINT", "EQ", "NEQ", 
		"LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", "DIV", "MOD", "AND", "OR", 
		"XOR", "ATOMIC"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'True'", "'true'", "'False'", "'false'", "'H:'", "'<-'", "'<:-'", 
		"':='", "'='", "'load'", "'store'", "'mfence'", "'sync'", "'lwsync'", 
		"'isync'", "'skip'", "';'", "'if'", "'then'", "'else'", "'while'", "'['", 
		"']'", "'thread t'", "'exists'", "':'", null, null, null, null, null, 
		null, null, "'('", "')'", "'{'", "'}'", "','", "'.'", "'=='", "'!='", 
		"'<='", "'<'", "'>='", "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "'and'", 
		"'or'", "'xor'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, "COMP_OP", "ARITH_OP", "BOOL_OP", "DIGIT", "WORD", "LETTER", 
		"WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", "POINT", "EQ", "NEQ", 
		"LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", "DIV", "MOD", "AND", "OR", 
		"XOR", "ATOMIC"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\28\u0158\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\3\3\3"+
		"\3\3\3\4\3\4\3\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3\5\3\5\3\6\3\6\3\6\3\7\3"+
		"\7\3\7\3\b\3\b\3\b\3\b\3\t\3\t\3\t\3\n\3\n\3\13\3\13\3\13\3\13\3\13\3"+
		"\f\3\f\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\16"+
		"\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\20\3\20\3\20\3\20\3\20\3\20"+
		"\3\21\3\21\3\21\3\21\3\21\3\22\3\22\3\23\3\23\3\23\3\24\3\24\3\24\3\24"+
		"\3\24\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\27\3\27"+
		"\3\30\3\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\32\3\32\3\32"+
		"\3\32\3\32\3\32\3\32\3\33\3\33\3\34\3\34\3\34\3\34\3\34\3\34\5\34\u00ef"+
		"\n\34\3\35\3\35\3\35\3\35\3\35\3\35\5\35\u00f7\n\35\3\36\3\36\5\36\u00fb"+
		"\n\36\3\37\6\37\u00fe\n\37\r\37\16\37\u00ff\3 \3 \6 \u0104\n \r \16 \u0105"+
		"\3!\3!\3\"\6\"\u010b\n\"\r\"\16\"\u010c\3\"\3\"\3#\3#\3$\3$\3%\3%\3&\3"+
		"&\3\'\3\'\3(\3(\3)\3)\3)\3*\3*\3*\3+\3+\3+\3,\3,\3-\3-\3-\3.\3.\3/\3/"+
		"\3\60\3\60\3\61\3\61\3\62\3\62\3\63\3\63\3\64\3\64\3\64\3\64\3\65\3\65"+
		"\3\65\3\66\3\66\3\66\3\66\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67"+
		"\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\5\67\u0157"+
		"\n\67\2\28\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33"+
		"\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33\65\34\67"+
		"\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62c\63e\64g\65"+
		"i\66k\67m8\3\2\5\3\2\62;\4\2C\\c|\5\2\13\f\17\17\"\"\2\u016b\2\3\3\2\2"+
		"\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3"+
		"\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2"+
		"\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2"+
		"\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2"+
		"\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3"+
		"\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2"+
		"\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2"+
		"W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3"+
		"\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2m\3\2\2\2\3o\3\2\2"+
		"\2\5t\3\2\2\2\7y\3\2\2\2\t\177\3\2\2\2\13\u0085\3\2\2\2\r\u0088\3\2\2"+
		"\2\17\u008b\3\2\2\2\21\u008f\3\2\2\2\23\u0092\3\2\2\2\25\u0094\3\2\2\2"+
		"\27\u0099\3\2\2\2\31\u009f\3\2\2\2\33\u00a6\3\2\2\2\35\u00ab\3\2\2\2\37"+
		"\u00b2\3\2\2\2!\u00b8\3\2\2\2#\u00bd\3\2\2\2%\u00bf\3\2\2\2\'\u00c2\3"+
		"\2\2\2)\u00c7\3\2\2\2+\u00cc\3\2\2\2-\u00d2\3\2\2\2/\u00d4\3\2\2\2\61"+
		"\u00d6\3\2\2\2\63\u00df\3\2\2\2\65\u00e6\3\2\2\2\67\u00ee\3\2\2\29\u00f6"+
		"\3\2\2\2;\u00fa\3\2\2\2=\u00fd\3\2\2\2?\u0103\3\2\2\2A\u0107\3\2\2\2C"+
		"\u010a\3\2\2\2E\u0110\3\2\2\2G\u0112\3\2\2\2I\u0114\3\2\2\2K\u0116\3\2"+
		"\2\2M\u0118\3\2\2\2O\u011a\3\2\2\2Q\u011c\3\2\2\2S\u011f\3\2\2\2U\u0122"+
		"\3\2\2\2W\u0125\3\2\2\2Y\u0127\3\2\2\2[\u012a\3\2\2\2]\u012c\3\2\2\2_"+
		"\u012e\3\2\2\2a\u0130\3\2\2\2c\u0132\3\2\2\2e\u0134\3\2\2\2g\u0136\3\2"+
		"\2\2i\u013a\3\2\2\2k\u013d\3\2\2\2m\u0156\3\2\2\2op\7V\2\2pq\7t\2\2qr"+
		"\7w\2\2rs\7g\2\2s\4\3\2\2\2tu\7v\2\2uv\7t\2\2vw\7w\2\2wx\7g\2\2x\6\3\2"+
		"\2\2yz\7H\2\2z{\7c\2\2{|\7n\2\2|}\7u\2\2}~\7g\2\2~\b\3\2\2\2\177\u0080"+
		"\7h\2\2\u0080\u0081\7c\2\2\u0081\u0082\7n\2\2\u0082\u0083\7u\2\2\u0083"+
		"\u0084\7g\2\2\u0084\n\3\2\2\2\u0085\u0086\7J\2\2\u0086\u0087\7<\2\2\u0087"+
		"\f\3\2\2\2\u0088\u0089\7>\2\2\u0089\u008a\7/\2\2\u008a\16\3\2\2\2\u008b"+
		"\u008c\7>\2\2\u008c\u008d\7<\2\2\u008d\u008e\7/\2\2\u008e\20\3\2\2\2\u008f"+
		"\u0090\7<\2\2\u0090\u0091\7?\2\2\u0091\22\3\2\2\2\u0092\u0093\7?\2\2\u0093"+
		"\24\3\2\2\2\u0094\u0095\7n\2\2\u0095\u0096\7q\2\2\u0096\u0097\7c\2\2\u0097"+
		"\u0098\7f\2\2\u0098\26\3\2\2\2\u0099\u009a\7u\2\2\u009a\u009b\7v\2\2\u009b"+
		"\u009c\7q\2\2\u009c\u009d\7t\2\2\u009d\u009e\7g\2\2\u009e\30\3\2\2\2\u009f"+
		"\u00a0\7o\2\2\u00a0\u00a1\7h\2\2\u00a1\u00a2\7g\2\2\u00a2\u00a3\7p\2\2"+
		"\u00a3\u00a4\7e\2\2\u00a4\u00a5\7g\2\2\u00a5\32\3\2\2\2\u00a6\u00a7\7"+
		"u\2\2\u00a7\u00a8\7{\2\2\u00a8\u00a9\7p\2\2\u00a9\u00aa\7e\2\2\u00aa\34"+
		"\3\2\2\2\u00ab\u00ac\7n\2\2\u00ac\u00ad\7y\2\2\u00ad\u00ae\7u\2\2\u00ae"+
		"\u00af\7{\2\2\u00af\u00b0\7p\2\2\u00b0\u00b1\7e\2\2\u00b1\36\3\2\2\2\u00b2"+
		"\u00b3\7k\2\2\u00b3\u00b4\7u\2\2\u00b4\u00b5\7{\2\2\u00b5\u00b6\7p\2\2"+
		"\u00b6\u00b7\7e\2\2\u00b7 \3\2\2\2\u00b8\u00b9\7u\2\2\u00b9\u00ba\7m\2"+
		"\2\u00ba\u00bb\7k\2\2\u00bb\u00bc\7r\2\2\u00bc\"\3\2\2\2\u00bd\u00be\7"+
		"=\2\2\u00be$\3\2\2\2\u00bf\u00c0\7k\2\2\u00c0\u00c1\7h\2\2\u00c1&\3\2"+
		"\2\2\u00c2\u00c3\7v\2\2\u00c3\u00c4\7j\2\2\u00c4\u00c5\7g\2\2\u00c5\u00c6"+
		"\7p\2\2\u00c6(\3\2\2\2\u00c7\u00c8\7g\2\2\u00c8\u00c9\7n\2\2\u00c9\u00ca"+
		"\7u\2\2\u00ca\u00cb\7g\2\2\u00cb*\3\2\2\2\u00cc\u00cd\7y\2\2\u00cd\u00ce"+
		"\7j\2\2\u00ce\u00cf\7k\2\2\u00cf\u00d0\7n\2\2\u00d0\u00d1\7g\2\2\u00d1"+
		",\3\2\2\2\u00d2\u00d3\7]\2\2\u00d3.\3\2\2\2\u00d4\u00d5\7_\2\2\u00d5\60"+
		"\3\2\2\2\u00d6\u00d7\7v\2\2\u00d7\u00d8\7j\2\2\u00d8\u00d9\7t\2\2\u00d9"+
		"\u00da\7g\2\2\u00da\u00db\7c\2\2\u00db\u00dc\7f\2\2\u00dc\u00dd\7\"\2"+
		"\2\u00dd\u00de\7v\2\2\u00de\62\3\2\2\2\u00df\u00e0\7g\2\2\u00e0\u00e1"+
		"\7z\2\2\u00e1\u00e2\7k\2\2\u00e2\u00e3\7u\2\2\u00e3\u00e4\7v\2\2\u00e4"+
		"\u00e5\7u\2\2\u00e5\64\3\2\2\2\u00e6\u00e7\7<\2\2\u00e7\66\3\2\2\2\u00e8"+
		"\u00ef\5Q)\2\u00e9\u00ef\5S*\2\u00ea\u00ef\5U+\2\u00eb\u00ef\5W,\2\u00ec"+
		"\u00ef\5Y-\2\u00ed\u00ef\5[.\2\u00ee\u00e8\3\2\2\2\u00ee\u00e9\3\2\2\2"+
		"\u00ee\u00ea\3\2\2\2\u00ee\u00eb\3\2\2\2\u00ee\u00ec\3\2\2\2\u00ee\u00ed"+
		"\3\2\2\2\u00ef8\3\2\2\2\u00f0\u00f7\5]/\2\u00f1\u00f7\5_\60\2\u00f2\u00f7"+
		"\5a\61\2\u00f3\u00f7\5c\62\2\u00f4\u00f7\5e\63\2\u00f5\u00f7\5k\66\2\u00f6"+
		"\u00f0\3\2\2\2\u00f6\u00f1\3\2\2\2\u00f6\u00f2\3\2\2\2\u00f6\u00f3\3\2"+
		"\2\2\u00f6\u00f4\3\2\2\2\u00f6\u00f5\3\2\2\2\u00f7:\3\2\2\2\u00f8\u00fb"+
		"\5g\64\2\u00f9\u00fb\5i\65\2\u00fa\u00f8\3\2\2\2\u00fa\u00f9\3\2\2\2\u00fb"+
		"<\3\2\2\2\u00fc\u00fe\t\2\2\2\u00fd\u00fc\3\2\2\2\u00fe\u00ff\3\2\2\2"+
		"\u00ff\u00fd\3\2\2\2\u00ff\u0100\3\2\2\2\u0100>\3\2\2\2\u0101\u0104\5"+
		"A!\2\u0102\u0104\5=\37\2\u0103\u0101\3\2\2\2\u0103\u0102\3\2\2\2\u0104"+
		"\u0105\3\2\2\2\u0105\u0103\3\2\2\2\u0105\u0106\3\2\2\2\u0106@\3\2\2\2"+
		"\u0107\u0108\t\3\2\2\u0108B\3\2\2\2\u0109\u010b\t\4\2\2\u010a\u0109\3"+
		"\2\2\2\u010b\u010c\3\2\2\2\u010c\u010a\3\2\2\2\u010c\u010d\3\2\2\2\u010d"+
		"\u010e\3\2\2\2\u010e\u010f\b\"\2\2\u010fD\3\2\2\2\u0110\u0111\7*\2\2\u0111"+
		"F\3\2\2\2\u0112\u0113\7+\2\2\u0113H\3\2\2\2\u0114\u0115\7}\2\2\u0115J"+
		"\3\2\2\2\u0116\u0117\7\177\2\2\u0117L\3\2\2\2\u0118\u0119\7.\2\2\u0119"+
		"N\3\2\2\2\u011a\u011b\7\60\2\2\u011bP\3\2\2\2\u011c\u011d\7?\2\2\u011d"+
		"\u011e\7?\2\2\u011eR\3\2\2\2\u011f\u0120\7#\2\2\u0120\u0121\7?\2\2\u0121"+
		"T\3\2\2\2\u0122\u0123\7>\2\2\u0123\u0124\7?\2\2\u0124V\3\2\2\2\u0125\u0126"+
		"\7>\2\2\u0126X\3\2\2\2\u0127\u0128\7@\2\2\u0128\u0129\7?\2\2\u0129Z\3"+
		"\2\2\2\u012a\u012b\7@\2\2\u012b\\\3\2\2\2\u012c\u012d\7-\2\2\u012d^\3"+
		"\2\2\2\u012e\u012f\7/\2\2\u012f`\3\2\2\2\u0130\u0131\7,\2\2\u0131b\3\2"+
		"\2\2\u0132\u0133\7\61\2\2\u0133d\3\2\2\2\u0134\u0135\7\'\2\2\u0135f\3"+
		"\2\2\2\u0136\u0137\7c\2\2\u0137\u0138\7p\2\2\u0138\u0139\7f\2\2\u0139"+
		"h\3\2\2\2\u013a\u013b\7q\2\2\u013b\u013c\7t\2\2\u013cj\3\2\2\2\u013d\u013e"+
		"\7z\2\2\u013e\u013f\7q\2\2\u013f\u0140\7t\2\2\u0140l\3\2\2\2\u0141\u0142"+
		"\7a\2\2\u0142\u0143\7p\2\2\u0143\u0157\7c\2\2\u0144\u0145\7a\2\2\u0145"+
		"\u0146\7u\2\2\u0146\u0157\7e\2\2\u0147\u0148\7a\2\2\u0148\u0149\7t\2\2"+
		"\u0149\u0157\7z\2\2\u014a\u014b\7a\2\2\u014b\u014c\7c\2\2\u014c\u014d"+
		"\7e\2\2\u014d\u0157\7s\2\2\u014e\u014f\7a\2\2\u014f\u0150\7t\2\2\u0150"+
		"\u0151\7g\2\2\u0151\u0157\7n\2\2\u0152\u0153\7a\2\2\u0153\u0154\7e\2\2"+
		"\u0154\u0155\7q\2\2\u0155\u0157\7p\2\2\u0156\u0141\3\2\2\2\u0156\u0144"+
		"\3\2\2\2\u0156\u0147\3\2\2\2\u0156\u014a\3\2\2\2\u0156\u014e\3\2\2\2\u0156"+
		"\u0152\3\2\2\2\u0157n\3\2\2\2\13\2\u00ee\u00f6\u00fa\u00ff\u0103\u0105"+
		"\u010c\u0156\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}