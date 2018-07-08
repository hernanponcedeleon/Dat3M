// Generated from LitmusX86.g4 by ANTLR 4.7

package dartagnan;

import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class LitmusX86Lexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, LitmusLanguage=19, Mov=20, Xchg=21, Mfence=22, Lfence=23, Sfence=24, 
		Inc=25, Cmp=26, Add=27, Register=28, ThreadIdentifier=29, AssertionExistsNot=30, 
		AssertionExists=31, AssertionFinal=32, AssertionForall=33, LogicAnd=34, 
		LogicOr=35, Identifier=36, DigitSequence=37, Word=38, Whitespace=39, Newline=40, 
		BlockComment=41, ExecConfig=42;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "LitmusLanguage", "Mov", "Xchg", "Mfence", "Lfence", "Sfence", 
		"Inc", "Cmp", "Add", "Register", "ThreadIdentifier", "AssertionExistsNot", 
		"AssertionExists", "AssertionFinal", "AssertionForall", "LogicAnd", "LogicOr", 
		"Identifier", "DigitSequence", "Word", "Digit", "Letter", "Symbol", "Whitespace", 
		"Newline", "BlockComment", "ExecConfig"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'{'", "';'", "'}'", "'='", "':'", "'locations'", "'['", "']'", 
		"'|'", "','", "'$'", "'('", "')'", "'with'", "'tso'", "'cc'", "'optic'", 
		"'default'", null, null, null, null, null, null, null, null, null, null, 
		null, null, "'exists'", "'final'", "'forall'", "'/\\'", "'\\/'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, "LitmusLanguage", "Mov", "Xchg", 
		"Mfence", "Lfence", "Sfence", "Inc", "Cmp", "Add", "Register", "ThreadIdentifier", 
		"AssertionExistsNot", "AssertionExists", "AssertionFinal", "AssertionForall", 
		"LogicAnd", "LogicOr", "Identifier", "DigitSequence", "Word", "Whitespace", 
		"Newline", "BlockComment", "ExecConfig"
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


	public LitmusX86Lexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "LitmusX86.g4"; }

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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2,\u0187\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\7\3"+
		"\7\3\7\3\7\3\7\3\7\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3"+
		"\r\3\r\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\20\3\20\3\20\3\20\3\21\3\21"+
		"\3\21\3\22\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\23\3\23"+
		"\3\23\3\24\3\24\3\24\3\24\3\24\3\24\5\24\u00a0\n\24\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\5\25\u00a8\n\25\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\5\26"+
		"\u00b2\n\26\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27"+
		"\5\27\u00c0\n\27\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30"+
		"\3\30\5\30\u00ce\n\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31"+
		"\3\31\3\31\5\31\u00dc\n\31\3\32\3\32\3\32\3\32\3\32\3\32\5\32\u00e4\n"+
		"\32\3\33\3\33\3\33\3\33\3\33\3\33\5\33\u00ec\n\33\3\34\3\34\3\34\3\34"+
		"\3\34\3\34\5\34\u00f4\n\34\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\5\35\u010e\n\35\3\36\3\36\3\36\3\37\3\37\3\37\3\37\3\37\3\37\3\37"+
		"\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\5\37\u0122\n\37\3 \3 \3 \3 \3"+
		" \3 \3 \3!\3!\3!\3!\3!\3!\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3#\3#\3#\3$\3$\3"+
		"$\3%\6%\u013f\n%\r%\16%\u0140\3%\3%\7%\u0145\n%\f%\16%\u0148\13%\3&\6"+
		"&\u014b\n&\r&\16&\u014c\3\'\3\'\3\'\6\'\u0152\n\'\r\'\16\'\u0153\3(\3"+
		"(\3)\3)\3*\3*\3+\6+\u015d\n+\r+\16+\u015e\3+\3+\3,\3,\5,\u0165\n,\3,\5"+
		",\u0168\n,\3,\3,\3-\3-\3-\3-\7-\u0170\n-\f-\16-\u0173\13-\3-\3-\3-\3-"+
		"\3-\3.\3.\3.\3.\7.\u017e\n.\f.\16.\u0181\13.\3.\3.\3.\3.\3.\4\u0171\u017f"+
		"\2/\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35"+
		"\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33\65\34\67\359\36"+
		";\37= ?!A\"C#E$G%I&K\'M(O\2Q\2S\2U)W*Y+[,\3\2\6\3\2\62;\4\2C\\c|\t\2$"+
		"$(),-/\61AB^^aa\4\2\13\13\"\"\2\u01a0\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2"+
		"\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2"+
		"\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3"+
		"\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3"+
		"\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65"+
		"\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3"+
		"\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2"+
		"\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\3]\3\2\2\2\5_\3\2\2\2\7"+
		"a\3\2\2\2\tc\3\2\2\2\13e\3\2\2\2\rg\3\2\2\2\17q\3\2\2\2\21s\3\2\2\2\23"+
		"u\3\2\2\2\25w\3\2\2\2\27y\3\2\2\2\31{\3\2\2\2\33}\3\2\2\2\35\177\3\2\2"+
		"\2\37\u0084\3\2\2\2!\u0088\3\2\2\2#\u008b\3\2\2\2%\u0091\3\2\2\2\'\u009f"+
		"\3\2\2\2)\u00a7\3\2\2\2+\u00b1\3\2\2\2-\u00bf\3\2\2\2/\u00cd\3\2\2\2\61"+
		"\u00db\3\2\2\2\63\u00e3\3\2\2\2\65\u00eb\3\2\2\2\67\u00f3\3\2\2\29\u010d"+
		"\3\2\2\2;\u010f\3\2\2\2=\u0121\3\2\2\2?\u0123\3\2\2\2A\u012a\3\2\2\2C"+
		"\u0130\3\2\2\2E\u0137\3\2\2\2G\u013a\3\2\2\2I\u013e\3\2\2\2K\u014a\3\2"+
		"\2\2M\u0151\3\2\2\2O\u0155\3\2\2\2Q\u0157\3\2\2\2S\u0159\3\2\2\2U\u015c"+
		"\3\2\2\2W\u0167\3\2\2\2Y\u016b\3\2\2\2[\u0179\3\2\2\2]^\7}\2\2^\4\3\2"+
		"\2\2_`\7=\2\2`\6\3\2\2\2ab\7\177\2\2b\b\3\2\2\2cd\7?\2\2d\n\3\2\2\2ef"+
		"\7<\2\2f\f\3\2\2\2gh\7n\2\2hi\7q\2\2ij\7e\2\2jk\7c\2\2kl\7v\2\2lm\7k\2"+
		"\2mn\7q\2\2no\7p\2\2op\7u\2\2p\16\3\2\2\2qr\7]\2\2r\20\3\2\2\2st\7_\2"+
		"\2t\22\3\2\2\2uv\7~\2\2v\24\3\2\2\2wx\7.\2\2x\26\3\2\2\2yz\7&\2\2z\30"+
		"\3\2\2\2{|\7*\2\2|\32\3\2\2\2}~\7+\2\2~\34\3\2\2\2\177\u0080\7y\2\2\u0080"+
		"\u0081\7k\2\2\u0081\u0082\7v\2\2\u0082\u0083\7j\2\2\u0083\36\3\2\2\2\u0084"+
		"\u0085\7v\2\2\u0085\u0086\7u\2\2\u0086\u0087\7q\2\2\u0087 \3\2\2\2\u0088"+
		"\u0089\7e\2\2\u0089\u008a\7e\2\2\u008a\"\3\2\2\2\u008b\u008c\7q\2\2\u008c"+
		"\u008d\7r\2\2\u008d\u008e\7v\2\2\u008e\u008f\7k\2\2\u008f\u0090\7e\2\2"+
		"\u0090$\3\2\2\2\u0091\u0092\7f\2\2\u0092\u0093\7g\2\2\u0093\u0094\7h\2"+
		"\2\u0094\u0095\7c\2\2\u0095\u0096\7w\2\2\u0096\u0097\7n\2\2\u0097\u0098"+
		"\7v\2\2\u0098&\3\2\2\2\u0099\u009a\7Z\2\2\u009a\u009b\7:\2\2\u009b\u00a0"+
		"\78\2\2\u009c\u009d\7z\2\2\u009d\u009e\7:\2\2\u009e\u00a0\78\2\2\u009f"+
		"\u0099\3\2\2\2\u009f\u009c\3\2\2\2\u00a0(\3\2\2\2\u00a1\u00a2\7O\2\2\u00a2"+
		"\u00a3\7Q\2\2\u00a3\u00a8\7X\2\2\u00a4\u00a5\7o\2\2\u00a5\u00a6\7q\2\2"+
		"\u00a6\u00a8\7x\2\2\u00a7\u00a1\3\2\2\2\u00a7\u00a4\3\2\2\2\u00a8*\3\2"+
		"\2\2\u00a9\u00aa\7Z\2\2\u00aa\u00ab\7E\2\2\u00ab\u00ac\7J\2\2\u00ac\u00b2"+
		"\7I\2\2\u00ad\u00ae\7z\2\2\u00ae\u00af\7e\2\2\u00af\u00b0\7j\2\2\u00b0"+
		"\u00b2\7i\2\2\u00b1\u00a9\3\2\2\2\u00b1\u00ad\3\2\2\2\u00b2,\3\2\2\2\u00b3"+
		"\u00b4\7O\2\2\u00b4\u00b5\7H\2\2\u00b5\u00b6\7G\2\2\u00b6\u00b7\7P\2\2"+
		"\u00b7\u00b8\7E\2\2\u00b8\u00c0\7G\2\2\u00b9\u00ba\7o\2\2\u00ba\u00bb"+
		"\7h\2\2\u00bb\u00bc\7g\2\2\u00bc\u00bd\7p\2\2\u00bd\u00be\7e\2\2\u00be"+
		"\u00c0\7g\2\2\u00bf\u00b3\3\2\2\2\u00bf\u00b9\3\2\2\2\u00c0.\3\2\2\2\u00c1"+
		"\u00c2\7N\2\2\u00c2\u00c3\7H\2\2\u00c3\u00c4\7G\2\2\u00c4\u00c5\7P\2\2"+
		"\u00c5\u00c6\7E\2\2\u00c6\u00ce\7G\2\2\u00c7\u00c8\7n\2\2\u00c8\u00c9"+
		"\7h\2\2\u00c9\u00ca\7g\2\2\u00ca\u00cb\7p\2\2\u00cb\u00cc\7e\2\2\u00cc"+
		"\u00ce\7g\2\2\u00cd\u00c1\3\2\2\2\u00cd\u00c7\3\2\2\2\u00ce\60\3\2\2\2"+
		"\u00cf\u00d0\7U\2\2\u00d0\u00d1\7H\2\2\u00d1\u00d2\7G\2\2\u00d2\u00d3"+
		"\7P\2\2\u00d3\u00d4\7E\2\2\u00d4\u00dc\7G\2\2\u00d5\u00d6\7u\2\2\u00d6"+
		"\u00d7\7h\2\2\u00d7\u00d8\7g\2\2\u00d8\u00d9\7p\2\2\u00d9\u00da\7e\2\2"+
		"\u00da\u00dc\7g\2\2\u00db\u00cf\3\2\2\2\u00db\u00d5\3\2\2\2\u00dc\62\3"+
		"\2\2\2\u00dd\u00de\7K\2\2\u00de\u00df\7P\2\2\u00df\u00e4\7E\2\2\u00e0"+
		"\u00e1\7k\2\2\u00e1\u00e2\7p\2\2\u00e2\u00e4\7e\2\2\u00e3\u00dd\3\2\2"+
		"\2\u00e3\u00e0\3\2\2\2\u00e4\64\3\2\2\2\u00e5\u00e6\7E\2\2\u00e6\u00e7"+
		"\7O\2\2\u00e7\u00ec\7R\2\2\u00e8\u00e9\7e\2\2\u00e9\u00ea\7o\2\2\u00ea"+
		"\u00ec\7r\2\2\u00eb\u00e5\3\2\2\2\u00eb\u00e8\3\2\2\2\u00ec\66\3\2\2\2"+
		"\u00ed\u00ee\7C\2\2\u00ee\u00ef\7F\2\2\u00ef\u00f4\7F\2\2\u00f0\u00f1"+
		"\7c\2\2\u00f1\u00f2\7f\2\2\u00f2\u00f4\7f\2\2\u00f3\u00ed\3\2\2\2\u00f3"+
		"\u00f0\3\2\2\2\u00f48\3\2\2\2\u00f5\u00f6\7G\2\2\u00f6\u00f7\7C\2\2\u00f7"+
		"\u010e\7Z\2\2\u00f8\u00f9\7G\2\2\u00f9\u00fa\7D\2\2\u00fa\u010e\7Z\2\2"+
		"\u00fb\u00fc\7G\2\2\u00fc\u00fd\7E\2\2\u00fd\u010e\7Z\2\2\u00fe\u00ff"+
		"\7G\2\2\u00ff\u0100\7F\2\2\u0100\u010e\7Z\2\2\u0101\u0102\7G\2\2\u0102"+
		"\u0103\7U\2\2\u0103\u010e\7R\2\2\u0104\u0105\7G\2\2\u0105\u0106\7D\2\2"+
		"\u0106\u010e\7R\2\2\u0107\u0108\7G\2\2\u0108\u0109\7U\2\2\u0109\u010e"+
		"\7K\2\2\u010a\u010b\7G\2\2\u010b\u010c\7F\2\2\u010c\u010e\7K\2\2\u010d"+
		"\u00f5\3\2\2\2\u010d\u00f8\3\2\2\2\u010d\u00fb\3\2\2\2\u010d\u00fe\3\2"+
		"\2\2\u010d\u0101\3\2\2\2\u010d\u0104\3\2\2\2\u010d\u0107\3\2\2\2\u010d"+
		"\u010a\3\2\2\2\u010e:\3\2\2\2\u010f\u0110\7R\2\2\u0110\u0111\5K&\2\u0111"+
		"<\3\2\2\2\u0112\u0113\7\u0080\2\2\u0113\u0114\7g\2\2\u0114\u0115\7z\2"+
		"\2\u0115\u0116\7k\2\2\u0116\u0117\7u\2\2\u0117\u0118\7v\2\2\u0118\u0122"+
		"\7u\2\2\u0119\u011a\7\u0080\2\2\u011a\u011b\7\"\2\2\u011b\u011c\7g\2\2"+
		"\u011c\u011d\7z\2\2\u011d\u011e\7k\2\2\u011e\u011f\7u\2\2\u011f\u0120"+
		"\7v\2\2\u0120\u0122\7u\2\2\u0121\u0112\3\2\2\2\u0121\u0119\3\2\2\2\u0122"+
		">\3\2\2\2\u0123\u0124\7g\2\2\u0124\u0125\7z\2\2\u0125\u0126\7k\2\2\u0126"+
		"\u0127\7u\2\2\u0127\u0128\7v\2\2\u0128\u0129\7u\2\2\u0129@\3\2\2\2\u012a"+
		"\u012b\7h\2\2\u012b\u012c\7k\2\2\u012c\u012d\7p\2\2\u012d\u012e\7c\2\2"+
		"\u012e\u012f\7n\2\2\u012fB\3\2\2\2\u0130\u0131\7h\2\2\u0131\u0132\7q\2"+
		"\2\u0132\u0133\7t\2\2\u0133\u0134\7c\2\2\u0134\u0135\7n\2\2\u0135\u0136"+
		"\7n\2\2\u0136D\3\2\2\2\u0137\u0138\7\61\2\2\u0138\u0139\7^\2\2\u0139F"+
		"\3\2\2\2\u013a\u013b\7^\2\2\u013b\u013c\7\61\2\2\u013cH\3\2\2\2\u013d"+
		"\u013f\5Q)\2\u013e\u013d\3\2\2\2\u013f\u0140\3\2\2\2\u0140\u013e\3\2\2"+
		"\2\u0140\u0141\3\2\2\2\u0141\u0146\3\2\2\2\u0142\u0145\5Q)\2\u0143\u0145"+
		"\5O(\2\u0144\u0142\3\2\2\2\u0144\u0143\3\2\2\2\u0145\u0148\3\2\2\2\u0146"+
		"\u0144\3\2\2\2\u0146\u0147\3\2\2\2\u0147J\3\2\2\2\u0148\u0146\3\2\2\2"+
		"\u0149\u014b\5O(\2\u014a\u0149\3\2\2\2\u014b\u014c\3\2\2\2\u014c\u014a"+
		"\3\2\2\2\u014c\u014d\3\2\2\2\u014dL\3\2\2\2\u014e\u0152\5Q)\2\u014f\u0152"+
		"\5O(\2\u0150\u0152\5S*\2\u0151\u014e\3\2\2\2\u0151\u014f\3\2\2\2\u0151"+
		"\u0150\3\2\2\2\u0152\u0153\3\2\2\2\u0153\u0151\3\2\2\2\u0153\u0154\3\2"+
		"\2\2\u0154N\3\2\2\2\u0155\u0156\t\2\2\2\u0156P\3\2\2\2\u0157\u0158\t\3"+
		"\2\2\u0158R\3\2\2\2\u0159\u015a\t\4\2\2\u015aT\3\2\2\2\u015b\u015d\t\5"+
		"\2\2\u015c\u015b\3\2\2\2\u015d\u015e\3\2\2\2\u015e\u015c\3\2\2\2\u015e"+
		"\u015f\3\2\2\2\u015f\u0160\3\2\2\2\u0160\u0161\b+\2\2\u0161V\3\2\2\2\u0162"+
		"\u0164\7\17\2\2\u0163\u0165\7\f\2\2\u0164\u0163\3\2\2\2\u0164\u0165\3"+
		"\2\2\2\u0165\u0168\3\2\2\2\u0166\u0168\7\f\2\2\u0167\u0162\3\2\2\2\u0167"+
		"\u0166\3\2\2\2\u0168\u0169\3\2\2\2\u0169\u016a\b,\2\2\u016aX\3\2\2\2\u016b"+
		"\u016c\7*\2\2\u016c\u016d\7,\2\2\u016d\u0171\3\2\2\2\u016e\u0170\13\2"+
		"\2\2\u016f\u016e\3\2\2\2\u0170\u0173\3\2\2\2\u0171\u0172\3\2\2\2\u0171"+
		"\u016f\3\2\2\2\u0172\u0174\3\2\2\2\u0173\u0171\3\2\2\2\u0174\u0175\7,"+
		"\2\2\u0175\u0176\7+\2\2\u0176\u0177\3\2\2\2\u0177\u0178\b-\2\2\u0178Z"+
		"\3\2\2\2\u0179\u017a\7>\2\2\u017a\u017b\7>\2\2\u017b\u017f\3\2\2\2\u017c"+
		"\u017e\13\2\2\2\u017d\u017c\3\2\2\2\u017e\u0181\3\2\2\2\u017f\u0180\3"+
		"\2\2\2\u017f\u017d\3\2\2\2\u0180\u0182\3\2\2\2\u0181\u017f\3\2\2\2\u0182"+
		"\u0183\7@\2\2\u0183\u0184\7@\2\2\u0184\u0185\3\2\2\2\u0185\u0186\b.\2"+
		"\2\u0186\\\3\2\2\2\31\2\u009f\u00a7\u00b1\u00bf\u00cd\u00db\u00e3\u00eb"+
		"\u00f3\u010d\u0121\u0140\u0144\u0146\u014c\u0151\u0153\u015e\u0164\u0167"+
		"\u0171\u017f\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}