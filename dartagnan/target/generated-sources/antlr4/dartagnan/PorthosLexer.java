// Generated from Porthos.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.asserts.*;
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
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, COMP_OP=31, 
		ARITH_OP=32, BOOL_OP=33, DIGIT=34, WORD=35, LETTER=36, WS=37, LPAR=38, 
		RPAR=39, LCBRA=40, RCBRA=41, COMMA=42, POINT=43, EQ=44, NEQ=45, LEQ=46, 
		LT=47, GEQ=48, GT=49, ADD=50, SUB=51, MULT=52, DIV=53, MOD=54, AND=55, 
		OR=56, XOR=57, ATOMIC=58;
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
		"T__25", "T__26", "T__27", "T__28", "T__29", "COMP_OP", "ARITH_OP", "BOOL_OP", 
		"DIGIT", "WORD", "LETTER", "WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", 
		"POINT", "EQ", "NEQ", "LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", 
		"DIV", "MOD", "AND", "OR", "XOR", "ATOMIC"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'True'", "'true'", "'False'", "'false'", "'H:'", "'<-'", "'<:-'", 
		"':='", "'='", "'load'", "'store'", "'mfence'", "'sync'", "'lwsync'", 
		"'isync'", "'skip'", "';'", "'if'", "'then'", "'else'", "'while'", "'exists'", 
		"'~'", "'forall'", "'&&'", "'||'", "':'", "'['", "']'", "'thread t'", 
		null, null, null, null, null, null, null, "'('", "')'", "'{'", "'}'", 
		"','", "'.'", "'=='", "'!='", "'<='", "'<'", "'>='", "'>'", "'+'", "'-'", 
		"'*'", "'/'", "'%'", "'and'", "'or'", "'xor'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, "COMP_OP", "ARITH_OP", "BOOL_OP", 
		"DIGIT", "WORD", "LETTER", "WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", 
		"POINT", "EQ", "NEQ", "LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", 
		"DIV", "MOD", "AND", "OR", "XOR", "ATOMIC"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2<\u016f\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\3\2\3\2\3\2"+
		"\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3"+
		"\5\3\5\3\6\3\6\3\6\3\7\3\7\3\7\3\b\3\b\3\b\3\b\3\t\3\t\3\t\3\n\3\n\3\13"+
		"\3\13\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3"+
		"\r\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\20\3"+
		"\20\3\20\3\20\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\22\3\22\3\23\3\23\3"+
		"\23\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3"+
		"\26\3\26\3\26\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\30\3\30\3\31\3\31\3"+
		"\31\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\35\3"+
		"\35\3\36\3\36\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3 \3 \3 \3"+
		" \3 \3 \5 \u0106\n \3!\3!\3!\3!\3!\3!\5!\u010e\n!\3\"\3\"\5\"\u0112\n"+
		"\"\3#\6#\u0115\n#\r#\16#\u0116\3$\3$\6$\u011b\n$\r$\16$\u011c\3%\3%\3"+
		"&\6&\u0122\n&\r&\16&\u0123\3&\3&\3\'\3\'\3(\3(\3)\3)\3*\3*\3+\3+\3,\3"+
		",\3-\3-\3-\3.\3.\3.\3/\3/\3/\3\60\3\60\3\61\3\61\3\61\3\62\3\62\3\63\3"+
		"\63\3\64\3\64\3\65\3\65\3\66\3\66\3\67\3\67\38\38\38\38\39\39\39\3:\3"+
		":\3:\3:\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3"+
		";\5;\u016e\n;\2\2<\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r"+
		"\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33"+
		"\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62c\63"+
		"e\64g\65i\66k\67m8o9q:s;u<\3\2\5\3\2\62;\4\2C\\c|\5\2\13\f\17\17\"\"\2"+
		"\u0182\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2"+
		"\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3"+
		"\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2"+
		"\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2"+
		"/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2"+
		"\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2"+
		"G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3"+
		"\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2"+
		"\2\2a\3\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2"+
		"m\3\2\2\2\2o\3\2\2\2\2q\3\2\2\2\2s\3\2\2\2\2u\3\2\2\2\3w\3\2\2\2\5|\3"+
		"\2\2\2\7\u0081\3\2\2\2\t\u0087\3\2\2\2\13\u008d\3\2\2\2\r\u0090\3\2\2"+
		"\2\17\u0093\3\2\2\2\21\u0097\3\2\2\2\23\u009a\3\2\2\2\25\u009c\3\2\2\2"+
		"\27\u00a1\3\2\2\2\31\u00a7\3\2\2\2\33\u00ae\3\2\2\2\35\u00b3\3\2\2\2\37"+
		"\u00ba\3\2\2\2!\u00c0\3\2\2\2#\u00c5\3\2\2\2%\u00c7\3\2\2\2\'\u00ca\3"+
		"\2\2\2)\u00cf\3\2\2\2+\u00d4\3\2\2\2-\u00da\3\2\2\2/\u00e1\3\2\2\2\61"+
		"\u00e3\3\2\2\2\63\u00ea\3\2\2\2\65\u00ed\3\2\2\2\67\u00f0\3\2\2\29\u00f2"+
		"\3\2\2\2;\u00f4\3\2\2\2=\u00f6\3\2\2\2?\u0105\3\2\2\2A\u010d\3\2\2\2C"+
		"\u0111\3\2\2\2E\u0114\3\2\2\2G\u011a\3\2\2\2I\u011e\3\2\2\2K\u0121\3\2"+
		"\2\2M\u0127\3\2\2\2O\u0129\3\2\2\2Q\u012b\3\2\2\2S\u012d\3\2\2\2U\u012f"+
		"\3\2\2\2W\u0131\3\2\2\2Y\u0133\3\2\2\2[\u0136\3\2\2\2]\u0139\3\2\2\2_"+
		"\u013c\3\2\2\2a\u013e\3\2\2\2c\u0141\3\2\2\2e\u0143\3\2\2\2g\u0145\3\2"+
		"\2\2i\u0147\3\2\2\2k\u0149\3\2\2\2m\u014b\3\2\2\2o\u014d\3\2\2\2q\u0151"+
		"\3\2\2\2s\u0154\3\2\2\2u\u016d\3\2\2\2wx\7V\2\2xy\7t\2\2yz\7w\2\2z{\7"+
		"g\2\2{\4\3\2\2\2|}\7v\2\2}~\7t\2\2~\177\7w\2\2\177\u0080\7g\2\2\u0080"+
		"\6\3\2\2\2\u0081\u0082\7H\2\2\u0082\u0083\7c\2\2\u0083\u0084\7n\2\2\u0084"+
		"\u0085\7u\2\2\u0085\u0086\7g\2\2\u0086\b\3\2\2\2\u0087\u0088\7h\2\2\u0088"+
		"\u0089\7c\2\2\u0089\u008a\7n\2\2\u008a\u008b\7u\2\2\u008b\u008c\7g\2\2"+
		"\u008c\n\3\2\2\2\u008d\u008e\7J\2\2\u008e\u008f\7<\2\2\u008f\f\3\2\2\2"+
		"\u0090\u0091\7>\2\2\u0091\u0092\7/\2\2\u0092\16\3\2\2\2\u0093\u0094\7"+
		">\2\2\u0094\u0095\7<\2\2\u0095\u0096\7/\2\2\u0096\20\3\2\2\2\u0097\u0098"+
		"\7<\2\2\u0098\u0099\7?\2\2\u0099\22\3\2\2\2\u009a\u009b\7?\2\2\u009b\24"+
		"\3\2\2\2\u009c\u009d\7n\2\2\u009d\u009e\7q\2\2\u009e\u009f\7c\2\2\u009f"+
		"\u00a0\7f\2\2\u00a0\26\3\2\2\2\u00a1\u00a2\7u\2\2\u00a2\u00a3\7v\2\2\u00a3"+
		"\u00a4\7q\2\2\u00a4\u00a5\7t\2\2\u00a5\u00a6\7g\2\2\u00a6\30\3\2\2\2\u00a7"+
		"\u00a8\7o\2\2\u00a8\u00a9\7h\2\2\u00a9\u00aa\7g\2\2\u00aa\u00ab\7p\2\2"+
		"\u00ab\u00ac\7e\2\2\u00ac\u00ad\7g\2\2\u00ad\32\3\2\2\2\u00ae\u00af\7"+
		"u\2\2\u00af\u00b0\7{\2\2\u00b0\u00b1\7p\2\2\u00b1\u00b2\7e\2\2\u00b2\34"+
		"\3\2\2\2\u00b3\u00b4\7n\2\2\u00b4\u00b5\7y\2\2\u00b5\u00b6\7u\2\2\u00b6"+
		"\u00b7\7{\2\2\u00b7\u00b8\7p\2\2\u00b8\u00b9\7e\2\2\u00b9\36\3\2\2\2\u00ba"+
		"\u00bb\7k\2\2\u00bb\u00bc\7u\2\2\u00bc\u00bd\7{\2\2\u00bd\u00be\7p\2\2"+
		"\u00be\u00bf\7e\2\2\u00bf \3\2\2\2\u00c0\u00c1\7u\2\2\u00c1\u00c2\7m\2"+
		"\2\u00c2\u00c3\7k\2\2\u00c3\u00c4\7r\2\2\u00c4\"\3\2\2\2\u00c5\u00c6\7"+
		"=\2\2\u00c6$\3\2\2\2\u00c7\u00c8\7k\2\2\u00c8\u00c9\7h\2\2\u00c9&\3\2"+
		"\2\2\u00ca\u00cb\7v\2\2\u00cb\u00cc\7j\2\2\u00cc\u00cd\7g\2\2\u00cd\u00ce"+
		"\7p\2\2\u00ce(\3\2\2\2\u00cf\u00d0\7g\2\2\u00d0\u00d1\7n\2\2\u00d1\u00d2"+
		"\7u\2\2\u00d2\u00d3\7g\2\2\u00d3*\3\2\2\2\u00d4\u00d5\7y\2\2\u00d5\u00d6"+
		"\7j\2\2\u00d6\u00d7\7k\2\2\u00d7\u00d8\7n\2\2\u00d8\u00d9\7g\2\2\u00d9"+
		",\3\2\2\2\u00da\u00db\7g\2\2\u00db\u00dc\7z\2\2\u00dc\u00dd\7k\2\2\u00dd"+
		"\u00de\7u\2\2\u00de\u00df\7v\2\2\u00df\u00e0\7u\2\2\u00e0.\3\2\2\2\u00e1"+
		"\u00e2\7\u0080\2\2\u00e2\60\3\2\2\2\u00e3\u00e4\7h\2\2\u00e4\u00e5\7q"+
		"\2\2\u00e5\u00e6\7t\2\2\u00e6\u00e7\7c\2\2\u00e7\u00e8\7n\2\2\u00e8\u00e9"+
		"\7n\2\2\u00e9\62\3\2\2\2\u00ea\u00eb\7(\2\2\u00eb\u00ec\7(\2\2\u00ec\64"+
		"\3\2\2\2\u00ed\u00ee\7~\2\2\u00ee\u00ef\7~\2\2\u00ef\66\3\2\2\2\u00f0"+
		"\u00f1\7<\2\2\u00f18\3\2\2\2\u00f2\u00f3\7]\2\2\u00f3:\3\2\2\2\u00f4\u00f5"+
		"\7_\2\2\u00f5<\3\2\2\2\u00f6\u00f7\7v\2\2\u00f7\u00f8\7j\2\2\u00f8\u00f9"+
		"\7t\2\2\u00f9\u00fa\7g\2\2\u00fa\u00fb\7c\2\2\u00fb\u00fc\7f\2\2\u00fc"+
		"\u00fd\7\"\2\2\u00fd\u00fe\7v\2\2\u00fe>\3\2\2\2\u00ff\u0106\5Y-\2\u0100"+
		"\u0106\5[.\2\u0101\u0106\5]/\2\u0102\u0106\5_\60\2\u0103\u0106\5a\61\2"+
		"\u0104\u0106\5c\62\2\u0105\u00ff\3\2\2\2\u0105\u0100\3\2\2\2\u0105\u0101"+
		"\3\2\2\2\u0105\u0102\3\2\2\2\u0105\u0103\3\2\2\2\u0105\u0104\3\2\2\2\u0106"+
		"@\3\2\2\2\u0107\u010e\5e\63\2\u0108\u010e\5g\64\2\u0109\u010e\5i\65\2"+
		"\u010a\u010e\5k\66\2\u010b\u010e\5m\67\2\u010c\u010e\5s:\2\u010d\u0107"+
		"\3\2\2\2\u010d\u0108\3\2\2\2\u010d\u0109\3\2\2\2\u010d\u010a\3\2\2\2\u010d"+
		"\u010b\3\2\2\2\u010d\u010c\3\2\2\2\u010eB\3\2\2\2\u010f\u0112\5o8\2\u0110"+
		"\u0112\5q9\2\u0111\u010f\3\2\2\2\u0111\u0110\3\2\2\2\u0112D\3\2\2\2\u0113"+
		"\u0115\t\2\2\2\u0114\u0113\3\2\2\2\u0115\u0116\3\2\2\2\u0116\u0114\3\2"+
		"\2\2\u0116\u0117\3\2\2\2\u0117F\3\2\2\2\u0118\u011b\5I%\2\u0119\u011b"+
		"\5E#\2\u011a\u0118\3\2\2\2\u011a\u0119\3\2\2\2\u011b\u011c\3\2\2\2\u011c"+
		"\u011a\3\2\2\2\u011c\u011d\3\2\2\2\u011dH\3\2\2\2\u011e\u011f\t\3\2\2"+
		"\u011fJ\3\2\2\2\u0120\u0122\t\4\2\2\u0121\u0120\3\2\2\2\u0122\u0123\3"+
		"\2\2\2\u0123\u0121\3\2\2\2\u0123\u0124\3\2\2\2\u0124\u0125\3\2\2\2\u0125"+
		"\u0126\b&\2\2\u0126L\3\2\2\2\u0127\u0128\7*\2\2\u0128N\3\2\2\2\u0129\u012a"+
		"\7+\2\2\u012aP\3\2\2\2\u012b\u012c\7}\2\2\u012cR\3\2\2\2\u012d\u012e\7"+
		"\177\2\2\u012eT\3\2\2\2\u012f\u0130\7.\2\2\u0130V\3\2\2\2\u0131\u0132"+
		"\7\60\2\2\u0132X\3\2\2\2\u0133\u0134\7?\2\2\u0134\u0135\7?\2\2\u0135Z"+
		"\3\2\2\2\u0136\u0137\7#\2\2\u0137\u0138\7?\2\2\u0138\\\3\2\2\2\u0139\u013a"+
		"\7>\2\2\u013a\u013b\7?\2\2\u013b^\3\2\2\2\u013c\u013d\7>\2\2\u013d`\3"+
		"\2\2\2\u013e\u013f\7@\2\2\u013f\u0140\7?\2\2\u0140b\3\2\2\2\u0141\u0142"+
		"\7@\2\2\u0142d\3\2\2\2\u0143\u0144\7-\2\2\u0144f\3\2\2\2\u0145\u0146\7"+
		"/\2\2\u0146h\3\2\2\2\u0147\u0148\7,\2\2\u0148j\3\2\2\2\u0149\u014a\7\61"+
		"\2\2\u014al\3\2\2\2\u014b\u014c\7\'\2\2\u014cn\3\2\2\2\u014d\u014e\7c"+
		"\2\2\u014e\u014f\7p\2\2\u014f\u0150\7f\2\2\u0150p\3\2\2\2\u0151\u0152"+
		"\7q\2\2\u0152\u0153\7t\2\2\u0153r\3\2\2\2\u0154\u0155\7z\2\2\u0155\u0156"+
		"\7q\2\2\u0156\u0157\7t\2\2\u0157t\3\2\2\2\u0158\u0159\7a\2\2\u0159\u015a"+
		"\7p\2\2\u015a\u016e\7c\2\2\u015b\u015c\7a\2\2\u015c\u015d\7u\2\2\u015d"+
		"\u016e\7e\2\2\u015e\u015f\7a\2\2\u015f\u0160\7t\2\2\u0160\u016e\7z\2\2"+
		"\u0161\u0162\7a\2\2\u0162\u0163\7c\2\2\u0163\u0164\7e\2\2\u0164\u016e"+
		"\7s\2\2\u0165\u0166\7a\2\2\u0166\u0167\7t\2\2\u0167\u0168\7g\2\2\u0168"+
		"\u016e\7n\2\2\u0169\u016a\7a\2\2\u016a\u016b\7e\2\2\u016b\u016c\7q\2\2"+
		"\u016c\u016e\7p\2\2\u016d\u0158\3\2\2\2\u016d\u015b\3\2\2\2\u016d\u015e"+
		"\3\2\2\2\u016d\u0161\3\2\2\2\u016d\u0165\3\2\2\2\u016d\u0169\3\2\2\2\u016e"+
		"v\3\2\2\2\13\2\u0105\u010d\u0111\u0116\u011a\u011c\u0123\u016d\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}