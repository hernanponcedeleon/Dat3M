// Generated from LitmusPPC.g4 by ANTLR 4.7

package dartagnan;

import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class LitmusPPCParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, LitmusLanguage=37, Register=38, 
		Label=39, ThreadIdentifier=40, AssertionExistsNot=41, AssertionExists=42, 
		AssertionFinal=43, AssertionForall=44, LogicAnd=45, LogicOr=46, Identifier=47, 
		DigitSequence=48, Word=49, Whitespace=50, Newline=51, BlockComment=52, 
		ExecConfig=53;
	public static final int
		RULE_main = 0, RULE_header = 1, RULE_headerComment = 2, RULE_variableDeclaratorList = 3, 
		RULE_variableDeclarator = 4, RULE_variableDeclaratorLocation = 5, RULE_variableDeclaratorRegister = 6, 
		RULE_variableDeclaratorRegisterLocation = 7, RULE_variableList = 8, RULE_variable = 9, 
		RULE_threadDeclaratorList = 10, RULE_instructionList = 11, RULE_instructionRow = 12, 
		RULE_instruction = 13, RULE_none = 14, RULE_li = 15, RULE_lwz = 16, RULE_lwzx = 17, 
		RULE_stw = 18, RULE_stwx = 19, RULE_mr = 20, RULE_addi = 21, RULE_xor = 22, 
		RULE_cmpw = 23, RULE_label = 24, RULE_beq = 25, RULE_bne = 26, RULE_blt = 27, 
		RULE_bgt = 28, RULE_ble = 29, RULE_bge = 30, RULE_sync = 31, RULE_lwsync = 32, 
		RULE_isync = 33, RULE_eieio = 34, RULE_thread = 35, RULE_r1 = 36, RULE_r2 = 37, 
		RULE_r3 = 38, RULE_location = 39, RULE_value = 40, RULE_offset = 41, RULE_assertionList = 42, 
		RULE_assertion = 43, RULE_assertionListExpectationList = 44, RULE_assertionListExpectation = 45, 
		RULE_assertionListExpectationTest = 46;
	public static final String[] ruleNames = {
		"main", "header", "headerComment", "variableDeclaratorList", "variableDeclarator", 
		"variableDeclaratorLocation", "variableDeclaratorRegister", "variableDeclaratorRegisterLocation", 
		"variableList", "variable", "threadDeclaratorList", "instructionList", 
		"instructionRow", "instruction", "none", "li", "lwz", "lwzx", "stw", "stwx", 
		"mr", "addi", "xor", "cmpw", "label", "beq", "bne", "blt", "bgt", "ble", 
		"bge", "sync", "lwsync", "isync", "eieio", "thread", "r1", "r2", "r3", 
		"location", "value", "offset", "assertionList", "assertion", "assertionListExpectationList", 
		"assertionListExpectation", "assertionListExpectationTest"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'{'", "';'", "'}'", "'='", "':'", "'locations'", "'['", "']'", 
		"'|'", "'li'", "','", "'lwz'", "'('", "')'", "'lwzx'", "'stw'", "'stwx'", 
		"'mr'", "'addi'", "'xor'", "'cmpw'", "'beq'", "'bne'", "'blt'", "'bgt'", 
		"'ble'", "'bge'", "'sync'", "'lwsync'", "'isync'", "'eieio'", "'with'", 
		"'tso'", "'cc'", "'optic'", "'default'", null, null, null, null, null, 
		"'exists'", "'final'", "'forall'", "'/\\'", "'\\/'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, "LitmusLanguage", "Register", "Label", "ThreadIdentifier", "AssertionExistsNot", 
		"AssertionExists", "AssertionFinal", "AssertionForall", "LogicAnd", "LogicOr", 
		"Identifier", "DigitSequence", "Word", "Whitespace", "Newline", "BlockComment", 
		"ExecConfig"
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

	@Override
	public String getGrammarFileName() { return "LitmusPPC.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public LitmusPPCParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class MainContext extends ParserRuleContext {
		public HeaderContext header() {
			return getRuleContext(HeaderContext.class,0);
		}
		public VariableDeclaratorListContext variableDeclaratorList() {
			return getRuleContext(VariableDeclaratorListContext.class,0);
		}
		public ThreadDeclaratorListContext threadDeclaratorList() {
			return getRuleContext(ThreadDeclaratorListContext.class,0);
		}
		public InstructionListContext instructionList() {
			return getRuleContext(InstructionListContext.class,0);
		}
		public TerminalNode EOF() { return getToken(LitmusPPCParser.EOF, 0); }
		public VariableListContext variableList() {
			return getRuleContext(VariableListContext.class,0);
		}
		public AssertionListContext assertionList() {
			return getRuleContext(AssertionListContext.class,0);
		}
		public MainContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_main; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitMain(this);
			else return visitor.visitChildren(this);
		}
	}

	public final MainContext main() throws RecognitionException {
		MainContext _localctx = new MainContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_main);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(94);
			header();
			setState(95);
			variableDeclaratorList();
			setState(96);
			threadDeclaratorList();
			setState(97);
			instructionList();
			setState(99);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5) {
				{
				setState(98);
				variableList();
				}
			}

			setState(102);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << AssertionExistsNot) | (1L << AssertionExists) | (1L << AssertionFinal) | (1L << AssertionForall))) != 0)) {
				{
				setState(101);
				assertionList();
				}
			}

			setState(104);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class HeaderContext extends ParserRuleContext {
		public TerminalNode LitmusLanguage() { return getToken(LitmusPPCParser.LitmusLanguage, 0); }
		public HeaderCommentContext headerComment() {
			return getRuleContext(HeaderCommentContext.class,0);
		}
		public HeaderContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_header; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitHeader(this);
			else return visitor.visitChildren(this);
		}
	}

	public final HeaderContext header() throws RecognitionException {
		HeaderContext _localctx = new HeaderContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_header);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(106);
			match(LitmusLanguage);
			setState(107);
			headerComment();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class HeaderCommentContext extends ParserRuleContext {
		public HeaderCommentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_headerComment; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitHeaderComment(this);
			else return visitor.visitChildren(this);
		}
	}

	public final HeaderCommentContext headerComment() throws RecognitionException {
		HeaderCommentContext _localctx = new HeaderCommentContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_headerComment);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(112);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__10) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << LitmusLanguage) | (1L << Register) | (1L << Label) | (1L << ThreadIdentifier) | (1L << AssertionExistsNot) | (1L << AssertionExists) | (1L << AssertionFinal) | (1L << AssertionForall) | (1L << LogicAnd) | (1L << LogicOr) | (1L << Identifier) | (1L << DigitSequence) | (1L << Word) | (1L << Whitespace) | (1L << Newline) | (1L << BlockComment) | (1L << ExecConfig))) != 0)) {
				{
				{
				setState(109);
				_la = _input.LA(1);
				if ( _la <= 0 || (_la==T__0) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				}
				setState(114);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableDeclaratorListContext extends ParserRuleContext {
		public List<VariableDeclaratorContext> variableDeclarator() {
			return getRuleContexts(VariableDeclaratorContext.class);
		}
		public VariableDeclaratorContext variableDeclarator(int i) {
			return getRuleContext(VariableDeclaratorContext.class,i);
		}
		public VariableDeclaratorListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variableDeclaratorList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariableDeclaratorList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorListContext variableDeclaratorList() throws RecognitionException {
		VariableDeclaratorListContext _localctx = new VariableDeclaratorListContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_variableDeclaratorList);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(115);
			match(T__0);
			setState(117);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ThreadIdentifier) | (1L << Identifier) | (1L << DigitSequence))) != 0)) {
				{
				setState(116);
				variableDeclarator();
				}
			}

			setState(123);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(119);
					match(T__1);
					setState(120);
					variableDeclarator();
					}
					} 
				}
				setState(125);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			}
			setState(127);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(126);
				match(T__1);
				}
			}

			setState(129);
			match(T__2);
			setState(131);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(130);
				match(T__1);
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableDeclaratorContext extends ParserRuleContext {
		public VariableDeclaratorLocationContext variableDeclaratorLocation() {
			return getRuleContext(VariableDeclaratorLocationContext.class,0);
		}
		public VariableDeclaratorRegisterContext variableDeclaratorRegister() {
			return getRuleContext(VariableDeclaratorRegisterContext.class,0);
		}
		public VariableDeclaratorRegisterLocationContext variableDeclaratorRegisterLocation() {
			return getRuleContext(VariableDeclaratorRegisterLocationContext.class,0);
		}
		public VariableDeclaratorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variableDeclarator; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariableDeclarator(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorContext variableDeclarator() throws RecognitionException {
		VariableDeclaratorContext _localctx = new VariableDeclaratorContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_variableDeclarator);
		try {
			setState(136);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(133);
				variableDeclaratorLocation();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(134);
				variableDeclaratorRegister();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(135);
				variableDeclaratorRegisterLocation();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableDeclaratorLocationContext extends ParserRuleContext {
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public VariableDeclaratorLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variableDeclaratorLocation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariableDeclaratorLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorLocationContext variableDeclaratorLocation() throws RecognitionException {
		VariableDeclaratorLocationContext _localctx = new VariableDeclaratorLocationContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_variableDeclaratorLocation);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(138);
			location();
			setState(139);
			match(T__3);
			setState(140);
			value();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableDeclaratorRegisterContext extends ParserRuleContext {
		public ThreadContext thread() {
			return getRuleContext(ThreadContext.class,0);
		}
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public VariableDeclaratorRegisterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variableDeclaratorRegister; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariableDeclaratorRegister(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorRegisterContext variableDeclaratorRegister() throws RecognitionException {
		VariableDeclaratorRegisterContext _localctx = new VariableDeclaratorRegisterContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_variableDeclaratorRegister);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(142);
			thread();
			setState(143);
			match(T__4);
			setState(144);
			r1();
			setState(145);
			match(T__3);
			setState(146);
			value();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableDeclaratorRegisterLocationContext extends ParserRuleContext {
		public ThreadContext thread() {
			return getRuleContext(ThreadContext.class,0);
		}
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public VariableDeclaratorRegisterLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variableDeclaratorRegisterLocation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariableDeclaratorRegisterLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorRegisterLocationContext variableDeclaratorRegisterLocation() throws RecognitionException {
		VariableDeclaratorRegisterLocationContext _localctx = new VariableDeclaratorRegisterLocationContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_variableDeclaratorRegisterLocation);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(148);
			thread();
			setState(149);
			match(T__4);
			setState(150);
			r1();
			setState(151);
			match(T__3);
			setState(152);
			location();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableListContext extends ParserRuleContext {
		public List<VariableContext> variable() {
			return getRuleContexts(VariableContext.class);
		}
		public VariableContext variable(int i) {
			return getRuleContext(VariableContext.class,i);
		}
		public VariableListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variableList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariableList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableListContext variableList() throws RecognitionException {
		VariableListContext _localctx = new VariableListContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_variableList);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(154);
			match(T__5);
			setState(155);
			match(T__6);
			setState(156);
			variable();
			setState(161);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(157);
					match(T__1);
					setState(158);
					variable();
					}
					} 
				}
				setState(163);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
			}
			setState(165);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(164);
				match(T__1);
				}
			}

			setState(167);
			match(T__7);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VariableContext extends ParserRuleContext {
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public ThreadContext thread() {
			return getRuleContext(ThreadContext.class,0);
		}
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public VariableContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_variable; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitVariable(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableContext variable() throws RecognitionException {
		VariableContext _localctx = new VariableContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_variable);
		try {
			setState(174);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case Identifier:
				enterOuterAlt(_localctx, 1);
				{
				setState(169);
				location();
				}
				break;
			case ThreadIdentifier:
			case DigitSequence:
				enterOuterAlt(_localctx, 2);
				{
				setState(170);
				thread();
				setState(171);
				match(T__4);
				setState(172);
				r1();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ThreadDeclaratorListContext extends ParserRuleContext {
		public List<ThreadContext> thread() {
			return getRuleContexts(ThreadContext.class);
		}
		public ThreadContext thread(int i) {
			return getRuleContext(ThreadContext.class,i);
		}
		public ThreadDeclaratorListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_threadDeclaratorList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitThreadDeclaratorList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ThreadDeclaratorListContext threadDeclaratorList() throws RecognitionException {
		ThreadDeclaratorListContext _localctx = new ThreadDeclaratorListContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_threadDeclaratorList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(176);
			thread();
			setState(181);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__8) {
				{
				{
				setState(177);
				match(T__8);
				setState(178);
				thread();
				}
				}
				setState(183);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(184);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InstructionListContext extends ParserRuleContext {
		public List<InstructionRowContext> instructionRow() {
			return getRuleContexts(InstructionRowContext.class);
		}
		public InstructionRowContext instructionRow(int i) {
			return getRuleContext(InstructionRowContext.class,i);
		}
		public InstructionListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instructionList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitInstructionList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final InstructionListContext instructionList() throws RecognitionException {
		InstructionListContext _localctx = new InstructionListContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_instructionList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(187); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(186);
				instructionRow();
				}
				}
				setState(189); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << Label))) != 0) );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InstructionRowContext extends ParserRuleContext {
		public List<InstructionContext> instruction() {
			return getRuleContexts(InstructionContext.class);
		}
		public InstructionContext instruction(int i) {
			return getRuleContext(InstructionContext.class,i);
		}
		public InstructionRowContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instructionRow; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitInstructionRow(this);
			else return visitor.visitChildren(this);
		}
	}

	public final InstructionRowContext instructionRow() throws RecognitionException {
		InstructionRowContext _localctx = new InstructionRowContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_instructionRow);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(191);
			instruction();
			setState(196);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__8) {
				{
				{
				setState(192);
				match(T__8);
				setState(193);
				instruction();
				}
				}
				setState(198);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(199);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InstructionContext extends ParserRuleContext {
		public NoneContext none() {
			return getRuleContext(NoneContext.class,0);
		}
		public LiContext li() {
			return getRuleContext(LiContext.class,0);
		}
		public LwzContext lwz() {
			return getRuleContext(LwzContext.class,0);
		}
		public LwzxContext lwzx() {
			return getRuleContext(LwzxContext.class,0);
		}
		public StwContext stw() {
			return getRuleContext(StwContext.class,0);
		}
		public StwxContext stwx() {
			return getRuleContext(StwxContext.class,0);
		}
		public MrContext mr() {
			return getRuleContext(MrContext.class,0);
		}
		public AddiContext addi() {
			return getRuleContext(AddiContext.class,0);
		}
		public XorContext xor() {
			return getRuleContext(XorContext.class,0);
		}
		public CmpwContext cmpw() {
			return getRuleContext(CmpwContext.class,0);
		}
		public LabelContext label() {
			return getRuleContext(LabelContext.class,0);
		}
		public BeqContext beq() {
			return getRuleContext(BeqContext.class,0);
		}
		public BneContext bne() {
			return getRuleContext(BneContext.class,0);
		}
		public BltContext blt() {
			return getRuleContext(BltContext.class,0);
		}
		public BgtContext bgt() {
			return getRuleContext(BgtContext.class,0);
		}
		public BleContext ble() {
			return getRuleContext(BleContext.class,0);
		}
		public BgeContext bge() {
			return getRuleContext(BgeContext.class,0);
		}
		public SyncContext sync() {
			return getRuleContext(SyncContext.class,0);
		}
		public LwsyncContext lwsync() {
			return getRuleContext(LwsyncContext.class,0);
		}
		public IsyncContext isync() {
			return getRuleContext(IsyncContext.class,0);
		}
		public EieioContext eieio() {
			return getRuleContext(EieioContext.class,0);
		}
		public InstructionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instruction; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitInstruction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final InstructionContext instruction() throws RecognitionException {
		InstructionContext _localctx = new InstructionContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_instruction);
		try {
			setState(222);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__1:
			case T__8:
				enterOuterAlt(_localctx, 1);
				{
				setState(201);
				none();
				}
				break;
			case T__9:
				enterOuterAlt(_localctx, 2);
				{
				setState(202);
				li();
				}
				break;
			case T__11:
				enterOuterAlt(_localctx, 3);
				{
				setState(203);
				lwz();
				}
				break;
			case T__14:
				enterOuterAlt(_localctx, 4);
				{
				setState(204);
				lwzx();
				}
				break;
			case T__15:
				enterOuterAlt(_localctx, 5);
				{
				setState(205);
				stw();
				}
				break;
			case T__16:
				enterOuterAlt(_localctx, 6);
				{
				setState(206);
				stwx();
				}
				break;
			case T__17:
				enterOuterAlt(_localctx, 7);
				{
				setState(207);
				mr();
				}
				break;
			case T__18:
				enterOuterAlt(_localctx, 8);
				{
				setState(208);
				addi();
				}
				break;
			case T__19:
				enterOuterAlt(_localctx, 9);
				{
				setState(209);
				xor();
				}
				break;
			case T__20:
				enterOuterAlt(_localctx, 10);
				{
				setState(210);
				cmpw();
				}
				break;
			case Label:
				enterOuterAlt(_localctx, 11);
				{
				setState(211);
				label();
				}
				break;
			case T__21:
				enterOuterAlt(_localctx, 12);
				{
				setState(212);
				beq();
				}
				break;
			case T__22:
				enterOuterAlt(_localctx, 13);
				{
				setState(213);
				bne();
				}
				break;
			case T__23:
				enterOuterAlt(_localctx, 14);
				{
				setState(214);
				blt();
				}
				break;
			case T__24:
				enterOuterAlt(_localctx, 15);
				{
				setState(215);
				bgt();
				}
				break;
			case T__25:
				enterOuterAlt(_localctx, 16);
				{
				setState(216);
				ble();
				}
				break;
			case T__26:
				enterOuterAlt(_localctx, 17);
				{
				setState(217);
				bge();
				}
				break;
			case T__27:
				enterOuterAlt(_localctx, 18);
				{
				setState(218);
				sync();
				}
				break;
			case T__28:
				enterOuterAlt(_localctx, 19);
				{
				setState(219);
				lwsync();
				}
				break;
			case T__29:
				enterOuterAlt(_localctx, 20);
				{
				setState(220);
				isync();
				}
				break;
			case T__30:
				enterOuterAlt(_localctx, 21);
				{
				setState(221);
				eieio();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NoneContext extends ParserRuleContext {
		public NoneContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_none; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitNone(this);
			else return visitor.visitChildren(this);
		}
	}

	public final NoneContext none() throws RecognitionException {
		NoneContext _localctx = new NoneContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_none);
		try {
			enterOuterAlt(_localctx, 1);
			{
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LiContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public LiContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_li; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitLi(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LiContext li() throws RecognitionException {
		LiContext _localctx = new LiContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_li);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(226);
			match(T__9);
			setState(227);
			r1();
			setState(228);
			match(T__10);
			setState(229);
			value();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LwzContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public OffsetContext offset() {
			return getRuleContext(OffsetContext.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public LwzContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lwz; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitLwz(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LwzContext lwz() throws RecognitionException {
		LwzContext _localctx = new LwzContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_lwz);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(231);
			match(T__11);
			setState(232);
			r1();
			setState(233);
			match(T__10);
			setState(234);
			offset();
			setState(235);
			match(T__12);
			setState(236);
			r2();
			setState(237);
			match(T__13);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LwzxContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public R3Context r3() {
			return getRuleContext(R3Context.class,0);
		}
		public LwzxContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lwzx; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitLwzx(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LwzxContext lwzx() throws RecognitionException {
		LwzxContext _localctx = new LwzxContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_lwzx);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(239);
			match(T__14);
			setState(240);
			r1();
			setState(241);
			match(T__10);
			setState(242);
			r2();
			setState(243);
			match(T__10);
			setState(244);
			r3();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StwContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public OffsetContext offset() {
			return getRuleContext(OffsetContext.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public StwContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_stw; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitStw(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StwContext stw() throws RecognitionException {
		StwContext _localctx = new StwContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_stw);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(246);
			match(T__15);
			setState(247);
			r1();
			setState(248);
			match(T__10);
			setState(249);
			offset();
			setState(250);
			match(T__12);
			setState(251);
			r2();
			setState(252);
			match(T__13);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StwxContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public R3Context r3() {
			return getRuleContext(R3Context.class,0);
		}
		public StwxContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_stwx; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitStwx(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StwxContext stwx() throws RecognitionException {
		StwxContext _localctx = new StwxContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_stwx);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(254);
			match(T__16);
			setState(255);
			r1();
			setState(256);
			match(T__10);
			setState(257);
			r2();
			setState(258);
			match(T__10);
			setState(259);
			r3();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class MrContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public MrContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_mr; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitMr(this);
			else return visitor.visitChildren(this);
		}
	}

	public final MrContext mr() throws RecognitionException {
		MrContext _localctx = new MrContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_mr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(261);
			match(T__17);
			setState(262);
			r1();
			setState(263);
			match(T__10);
			setState(264);
			r2();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AddiContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public AddiContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_addi; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAddi(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AddiContext addi() throws RecognitionException {
		AddiContext _localctx = new AddiContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_addi);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(266);
			match(T__18);
			setState(267);
			r1();
			setState(268);
			match(T__10);
			setState(269);
			r2();
			setState(270);
			match(T__10);
			setState(271);
			value();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class XorContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public R3Context r3() {
			return getRuleContext(R3Context.class,0);
		}
		public XorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_xor; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitXor(this);
			else return visitor.visitChildren(this);
		}
	}

	public final XorContext xor() throws RecognitionException {
		XorContext _localctx = new XorContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_xor);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(273);
			match(T__19);
			setState(274);
			r1();
			setState(275);
			match(T__10);
			setState(276);
			r2();
			setState(277);
			match(T__10);
			setState(278);
			r3();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CmpwContext extends ParserRuleContext {
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public CmpwContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cmpw; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitCmpw(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CmpwContext cmpw() throws RecognitionException {
		CmpwContext _localctx = new CmpwContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_cmpw);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(280);
			match(T__20);
			setState(281);
			r1();
			setState(282);
			match(T__10);
			setState(283);
			r2();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LabelContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public LabelContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_label; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitLabel(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LabelContext label() throws RecognitionException {
		LabelContext _localctx = new LabelContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_label);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(285);
			match(Label);
			setState(286);
			match(T__4);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BeqContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public BeqContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_beq; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitBeq(this);
			else return visitor.visitChildren(this);
		}
	}

	public final BeqContext beq() throws RecognitionException {
		BeqContext _localctx = new BeqContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_beq);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(288);
			match(T__21);
			setState(289);
			match(Label);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BneContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public BneContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bne; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitBne(this);
			else return visitor.visitChildren(this);
		}
	}

	public final BneContext bne() throws RecognitionException {
		BneContext _localctx = new BneContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_bne);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(291);
			match(T__22);
			setState(292);
			match(Label);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BltContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public BltContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_blt; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitBlt(this);
			else return visitor.visitChildren(this);
		}
	}

	public final BltContext blt() throws RecognitionException {
		BltContext _localctx = new BltContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_blt);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(294);
			match(T__23);
			setState(295);
			match(Label);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BgtContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public BgtContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bgt; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitBgt(this);
			else return visitor.visitChildren(this);
		}
	}

	public final BgtContext bgt() throws RecognitionException {
		BgtContext _localctx = new BgtContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_bgt);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(297);
			match(T__24);
			setState(298);
			match(Label);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BleContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public BleContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_ble; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitBle(this);
			else return visitor.visitChildren(this);
		}
	}

	public final BleContext ble() throws RecognitionException {
		BleContext _localctx = new BleContext(_ctx, getState());
		enterRule(_localctx, 58, RULE_ble);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(300);
			match(T__25);
			setState(301);
			match(Label);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BgeContext extends ParserRuleContext {
		public TerminalNode Label() { return getToken(LitmusPPCParser.Label, 0); }
		public BgeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bge; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitBge(this);
			else return visitor.visitChildren(this);
		}
	}

	public final BgeContext bge() throws RecognitionException {
		BgeContext _localctx = new BgeContext(_ctx, getState());
		enterRule(_localctx, 60, RULE_bge);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(303);
			match(T__26);
			setState(304);
			match(Label);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SyncContext extends ParserRuleContext {
		public SyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sync; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitSync(this);
			else return visitor.visitChildren(this);
		}
	}

	public final SyncContext sync() throws RecognitionException {
		SyncContext _localctx = new SyncContext(_ctx, getState());
		enterRule(_localctx, 62, RULE_sync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(306);
			match(T__27);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LwsyncContext extends ParserRuleContext {
		public LwsyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lwsync; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitLwsync(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LwsyncContext lwsync() throws RecognitionException {
		LwsyncContext _localctx = new LwsyncContext(_ctx, getState());
		enterRule(_localctx, 64, RULE_lwsync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(308);
			match(T__28);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IsyncContext extends ParserRuleContext {
		public IsyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_isync; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitIsync(this);
			else return visitor.visitChildren(this);
		}
	}

	public final IsyncContext isync() throws RecognitionException {
		IsyncContext _localctx = new IsyncContext(_ctx, getState());
		enterRule(_localctx, 66, RULE_isync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(310);
			match(T__29);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EieioContext extends ParserRuleContext {
		public EieioContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_eieio; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitEieio(this);
			else return visitor.visitChildren(this);
		}
	}

	public final EieioContext eieio() throws RecognitionException {
		EieioContext _localctx = new EieioContext(_ctx, getState());
		enterRule(_localctx, 68, RULE_eieio);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(312);
			match(T__30);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ThreadContext extends ParserRuleContext {
		public TerminalNode ThreadIdentifier() { return getToken(LitmusPPCParser.ThreadIdentifier, 0); }
		public TerminalNode DigitSequence() { return getToken(LitmusPPCParser.DigitSequence, 0); }
		public ThreadContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_thread; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitThread(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ThreadContext thread() throws RecognitionException {
		ThreadContext _localctx = new ThreadContext(_ctx, getState());
		enterRule(_localctx, 70, RULE_thread);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(314);
			_la = _input.LA(1);
			if ( !(_la==ThreadIdentifier || _la==DigitSequence) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class R1Context extends ParserRuleContext {
		public TerminalNode Register() { return getToken(LitmusPPCParser.Register, 0); }
		public R1Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_r1; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitR1(this);
			else return visitor.visitChildren(this);
		}
	}

	public final R1Context r1() throws RecognitionException {
		R1Context _localctx = new R1Context(_ctx, getState());
		enterRule(_localctx, 72, RULE_r1);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(316);
			match(Register);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class R2Context extends ParserRuleContext {
		public TerminalNode Register() { return getToken(LitmusPPCParser.Register, 0); }
		public R2Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_r2; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitR2(this);
			else return visitor.visitChildren(this);
		}
	}

	public final R2Context r2() throws RecognitionException {
		R2Context _localctx = new R2Context(_ctx, getState());
		enterRule(_localctx, 74, RULE_r2);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(318);
			match(Register);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class R3Context extends ParserRuleContext {
		public TerminalNode Register() { return getToken(LitmusPPCParser.Register, 0); }
		public R3Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_r3; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitR3(this);
			else return visitor.visitChildren(this);
		}
	}

	public final R3Context r3() throws RecognitionException {
		R3Context _localctx = new R3Context(_ctx, getState());
		enterRule(_localctx, 76, RULE_r3);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(320);
			match(Register);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LocationContext extends ParserRuleContext {
		public TerminalNode Identifier() { return getToken(LitmusPPCParser.Identifier, 0); }
		public LocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_location; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LocationContext location() throws RecognitionException {
		LocationContext _localctx = new LocationContext(_ctx, getState());
		enterRule(_localctx, 78, RULE_location);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(322);
			match(Identifier);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ValueContext extends ParserRuleContext {
		public TerminalNode DigitSequence() { return getToken(LitmusPPCParser.DigitSequence, 0); }
		public ValueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_value; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitValue(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ValueContext value() throws RecognitionException {
		ValueContext _localctx = new ValueContext(_ctx, getState());
		enterRule(_localctx, 80, RULE_value);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(324);
			match(DigitSequence);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class OffsetContext extends ParserRuleContext {
		public TerminalNode DigitSequence() { return getToken(LitmusPPCParser.DigitSequence, 0); }
		public OffsetContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_offset; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitOffset(this);
			else return visitor.visitChildren(this);
		}
	}

	public final OffsetContext offset() throws RecognitionException {
		OffsetContext _localctx = new OffsetContext(_ctx, getState());
		enterRule(_localctx, 82, RULE_offset);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(326);
			match(DigitSequence);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssertionListContext extends ParserRuleContext {
		public AssertionContext assertion() {
			return getRuleContext(AssertionContext.class,0);
		}
		public TerminalNode AssertionExists() { return getToken(LitmusPPCParser.AssertionExists, 0); }
		public TerminalNode AssertionExistsNot() { return getToken(LitmusPPCParser.AssertionExistsNot, 0); }
		public TerminalNode AssertionForall() { return getToken(LitmusPPCParser.AssertionForall, 0); }
		public TerminalNode AssertionFinal() { return getToken(LitmusPPCParser.AssertionFinal, 0); }
		public AssertionListExpectationListContext assertionListExpectationList() {
			return getRuleContext(AssertionListExpectationListContext.class,0);
		}
		public AssertionListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertionList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListContext assertionList() throws RecognitionException {
		AssertionListContext _localctx = new AssertionListContext(_ctx, getState());
		enterRule(_localctx, 84, RULE_assertionList);
		int _la;
		try {
			setState(340);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case AssertionExistsNot:
			case AssertionExists:
			case AssertionForall:
				enterOuterAlt(_localctx, 1);
				{
				setState(328);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << AssertionExistsNot) | (1L << AssertionExists) | (1L << AssertionForall))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(329);
				assertion(0);
				setState(331);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__1) {
					{
					setState(330);
					match(T__1);
					}
				}

				}
				break;
			case AssertionFinal:
				enterOuterAlt(_localctx, 2);
				{
				setState(333);
				match(AssertionFinal);
				setState(334);
				assertion(0);
				setState(336);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__1) {
					{
					setState(335);
					match(T__1);
					}
				}

				setState(338);
				assertionListExpectationList();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssertionContext extends ParserRuleContext {
		public AssertionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertion; }
	 
		public AssertionContext() { }
		public void copyFrom(AssertionContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AssertionLocationContext extends AssertionContext {
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public AssertionLocationContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionLocation(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AssertionRegisterContext extends AssertionContext {
		public ThreadContext thread() {
			return getRuleContext(ThreadContext.class,0);
		}
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public AssertionRegisterContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionRegister(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AssertionAndContext extends AssertionContext {
		public List<AssertionContext> assertion() {
			return getRuleContexts(AssertionContext.class);
		}
		public AssertionContext assertion(int i) {
			return getRuleContext(AssertionContext.class,i);
		}
		public TerminalNode LogicAnd() { return getToken(LitmusPPCParser.LogicAnd, 0); }
		public AssertionAndContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionAnd(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AssertionOrContext extends AssertionContext {
		public List<AssertionContext> assertion() {
			return getRuleContexts(AssertionContext.class);
		}
		public AssertionContext assertion(int i) {
			return getRuleContext(AssertionContext.class,i);
		}
		public TerminalNode LogicOr() { return getToken(LitmusPPCParser.LogicOr, 0); }
		public AssertionOrContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionOr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AssertionParenthesisContext extends AssertionContext {
		public AssertionContext assertion() {
			return getRuleContext(AssertionContext.class,0);
		}
		public AssertionParenthesisContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionParenthesis(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionContext assertion() throws RecognitionException {
		return assertion(0);
	}

	private AssertionContext assertion(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		AssertionContext _localctx = new AssertionContext(_ctx, _parentState);
		AssertionContext _prevctx = _localctx;
		int _startState = 86;
		enterRecursionRule(_localctx, 86, RULE_assertion, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(357);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__12:
				{
				_localctx = new AssertionParenthesisContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(343);
				match(T__12);
				setState(344);
				assertion(0);
				setState(345);
				match(T__13);
				}
				break;
			case Identifier:
				{
				_localctx = new AssertionLocationContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(347);
				location();
				setState(348);
				match(T__3);
				setState(349);
				value();
				}
				break;
			case ThreadIdentifier:
			case DigitSequence:
				{
				_localctx = new AssertionRegisterContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(351);
				thread();
				setState(352);
				match(T__4);
				setState(353);
				r1();
				setState(354);
				match(T__3);
				setState(355);
				value();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(367);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,20,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(365);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,19,_ctx) ) {
					case 1:
						{
						_localctx = new AssertionAndContext(new AssertionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_assertion);
						setState(359);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(360);
						match(LogicAnd);
						setState(361);
						assertion(5);
						}
						break;
					case 2:
						{
						_localctx = new AssertionOrContext(new AssertionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_assertion);
						setState(362);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(363);
						match(LogicOr);
						setState(364);
						assertion(4);
						}
						break;
					}
					} 
				}
				setState(369);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,20,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class AssertionListExpectationListContext extends ParserRuleContext {
		public List<AssertionListExpectationContext> assertionListExpectation() {
			return getRuleContexts(AssertionListExpectationContext.class);
		}
		public AssertionListExpectationContext assertionListExpectation(int i) {
			return getRuleContext(AssertionListExpectationContext.class,i);
		}
		public AssertionListExpectationListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertionListExpectationList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionListExpectationList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListExpectationListContext assertionListExpectationList() throws RecognitionException {
		AssertionListExpectationListContext _localctx = new AssertionListExpectationListContext(_ctx, getState());
		enterRule(_localctx, 88, RULE_assertionListExpectationList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(370);
			match(T__31);
			setState(372); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(371);
				assertionListExpectation();
				}
				}
				setState(374); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35))) != 0) );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssertionListExpectationContext extends ParserRuleContext {
		public AssertionListExpectationTestContext assertionListExpectationTest() {
			return getRuleContext(AssertionListExpectationTestContext.class,0);
		}
		public TerminalNode AssertionExists() { return getToken(LitmusPPCParser.AssertionExists, 0); }
		public TerminalNode AssertionExistsNot() { return getToken(LitmusPPCParser.AssertionExistsNot, 0); }
		public AssertionListExpectationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertionListExpectation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionListExpectation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListExpectationContext assertionListExpectation() throws RecognitionException {
		AssertionListExpectationContext _localctx = new AssertionListExpectationContext(_ctx, getState());
		enterRule(_localctx, 90, RULE_assertionListExpectation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(376);
			assertionListExpectationTest();
			setState(377);
			match(T__4);
			setState(378);
			_la = _input.LA(1);
			if ( !(_la==AssertionExistsNot || _la==AssertionExists) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(379);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssertionListExpectationTestContext extends ParserRuleContext {
		public AssertionListExpectationTestContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertionListExpectationTest; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusPPCVisitor ) return ((LitmusPPCVisitor<? extends T>)visitor).visitAssertionListExpectationTest(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListExpectationTestContext assertionListExpectationTest() throws RecognitionException {
		AssertionListExpectationTestContext _localctx = new AssertionListExpectationTestContext(_ctx, getState());
		enterRule(_localctx, 92, RULE_assertionListExpectationTest);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(381);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 43:
			return assertion_sempred((AssertionContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean assertion_sempred(AssertionContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 4);
		case 1:
			return precpred(_ctx, 3);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\67\u0182\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\3\2\3\2\3\2\3\2\3\2\5\2f\n\2\3\2\5\2"+
		"i\n\2\3\2\3\2\3\3\3\3\3\3\3\4\7\4q\n\4\f\4\16\4t\13\4\3\5\3\5\5\5x\n\5"+
		"\3\5\3\5\7\5|\n\5\f\5\16\5\177\13\5\3\5\5\5\u0082\n\5\3\5\3\5\5\5\u0086"+
		"\n\5\3\6\3\6\3\6\5\6\u008b\n\6\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\b\3\b\3\b"+
		"\3\t\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\7\n\u00a2\n\n\f\n\16\n\u00a5"+
		"\13\n\3\n\5\n\u00a8\n\n\3\n\3\n\3\13\3\13\3\13\3\13\3\13\5\13\u00b1\n"+
		"\13\3\f\3\f\3\f\7\f\u00b6\n\f\f\f\16\f\u00b9\13\f\3\f\3\f\3\r\6\r\u00be"+
		"\n\r\r\r\16\r\u00bf\3\16\3\16\3\16\7\16\u00c5\n\16\f\16\16\16\u00c8\13"+
		"\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3"+
		"\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\5\17\u00e1\n\17\3\20"+
		"\3\20\3\21\3\21\3\21\3\21\3\21\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\22"+
		"\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\24\3\24"+
		"\3\24\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\3\27\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\31"+
		"\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\34\3\35"+
		"\3\35\3\35\3\36\3\36\3\36\3\37\3\37\3\37\3 \3 \3 \3!\3!\3\"\3\"\3#\3#"+
		"\3$\3$\3%\3%\3&\3&\3\'\3\'\3(\3(\3)\3)\3*\3*\3+\3+\3,\3,\3,\5,\u014e\n"+
		",\3,\3,\3,\5,\u0153\n,\3,\3,\5,\u0157\n,\3-\3-\3-\3-\3-\3-\3-\3-\3-\3"+
		"-\3-\3-\3-\3-\3-\5-\u0168\n-\3-\3-\3-\3-\3-\3-\7-\u0170\n-\f-\16-\u0173"+
		"\13-\3.\3.\6.\u0177\n.\r.\16.\u0178\3/\3/\3/\3/\3/\3\60\3\60\3\60\2\3"+
		"X\61\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\668:<>@"+
		"BDFHJLNPRTVXZ\\^\2\7\3\2\3\3\4\2**\62\62\4\2+,..\3\2+,\3\2#&\2\u017d\2"+
		"`\3\2\2\2\4l\3\2\2\2\6r\3\2\2\2\bu\3\2\2\2\n\u008a\3\2\2\2\f\u008c\3\2"+
		"\2\2\16\u0090\3\2\2\2\20\u0096\3\2\2\2\22\u009c\3\2\2\2\24\u00b0\3\2\2"+
		"\2\26\u00b2\3\2\2\2\30\u00bd\3\2\2\2\32\u00c1\3\2\2\2\34\u00e0\3\2\2\2"+
		"\36\u00e2\3\2\2\2 \u00e4\3\2\2\2\"\u00e9\3\2\2\2$\u00f1\3\2\2\2&\u00f8"+
		"\3\2\2\2(\u0100\3\2\2\2*\u0107\3\2\2\2,\u010c\3\2\2\2.\u0113\3\2\2\2\60"+
		"\u011a\3\2\2\2\62\u011f\3\2\2\2\64\u0122\3\2\2\2\66\u0125\3\2\2\28\u0128"+
		"\3\2\2\2:\u012b\3\2\2\2<\u012e\3\2\2\2>\u0131\3\2\2\2@\u0134\3\2\2\2B"+
		"\u0136\3\2\2\2D\u0138\3\2\2\2F\u013a\3\2\2\2H\u013c\3\2\2\2J\u013e\3\2"+
		"\2\2L\u0140\3\2\2\2N\u0142\3\2\2\2P\u0144\3\2\2\2R\u0146\3\2\2\2T\u0148"+
		"\3\2\2\2V\u0156\3\2\2\2X\u0167\3\2\2\2Z\u0174\3\2\2\2\\\u017a\3\2\2\2"+
		"^\u017f\3\2\2\2`a\5\4\3\2ab\5\b\5\2bc\5\26\f\2ce\5\30\r\2df\5\22\n\2e"+
		"d\3\2\2\2ef\3\2\2\2fh\3\2\2\2gi\5V,\2hg\3\2\2\2hi\3\2\2\2ij\3\2\2\2jk"+
		"\7\2\2\3k\3\3\2\2\2lm\7\'\2\2mn\5\6\4\2n\5\3\2\2\2oq\n\2\2\2po\3\2\2\2"+
		"qt\3\2\2\2rp\3\2\2\2rs\3\2\2\2s\7\3\2\2\2tr\3\2\2\2uw\7\3\2\2vx\5\n\6"+
		"\2wv\3\2\2\2wx\3\2\2\2x}\3\2\2\2yz\7\4\2\2z|\5\n\6\2{y\3\2\2\2|\177\3"+
		"\2\2\2}{\3\2\2\2}~\3\2\2\2~\u0081\3\2\2\2\177}\3\2\2\2\u0080\u0082\7\4"+
		"\2\2\u0081\u0080\3\2\2\2\u0081\u0082\3\2\2\2\u0082\u0083\3\2\2\2\u0083"+
		"\u0085\7\5\2\2\u0084\u0086\7\4\2\2\u0085\u0084\3\2\2\2\u0085\u0086\3\2"+
		"\2\2\u0086\t\3\2\2\2\u0087\u008b\5\f\7\2\u0088\u008b\5\16\b\2\u0089\u008b"+
		"\5\20\t\2\u008a\u0087\3\2\2\2\u008a\u0088\3\2\2\2\u008a\u0089\3\2\2\2"+
		"\u008b\13\3\2\2\2\u008c\u008d\5P)\2\u008d\u008e\7\6\2\2\u008e\u008f\5"+
		"R*\2\u008f\r\3\2\2\2\u0090\u0091\5H%\2\u0091\u0092\7\7\2\2\u0092\u0093"+
		"\5J&\2\u0093\u0094\7\6\2\2\u0094\u0095\5R*\2\u0095\17\3\2\2\2\u0096\u0097"+
		"\5H%\2\u0097\u0098\7\7\2\2\u0098\u0099\5J&\2\u0099\u009a\7\6\2\2\u009a"+
		"\u009b\5P)\2\u009b\21\3\2\2\2\u009c\u009d\7\b\2\2\u009d\u009e\7\t\2\2"+
		"\u009e\u00a3\5\24\13\2\u009f\u00a0\7\4\2\2\u00a0\u00a2\5\24\13\2\u00a1"+
		"\u009f\3\2\2\2\u00a2\u00a5\3\2\2\2\u00a3\u00a1\3\2\2\2\u00a3\u00a4\3\2"+
		"\2\2\u00a4\u00a7\3\2\2\2\u00a5\u00a3\3\2\2\2\u00a6\u00a8\7\4\2\2\u00a7"+
		"\u00a6\3\2\2\2\u00a7\u00a8\3\2\2\2\u00a8\u00a9\3\2\2\2\u00a9\u00aa\7\n"+
		"\2\2\u00aa\23\3\2\2\2\u00ab\u00b1\5P)\2\u00ac\u00ad\5H%\2\u00ad\u00ae"+
		"\7\7\2\2\u00ae\u00af\5J&\2\u00af\u00b1\3\2\2\2\u00b0\u00ab\3\2\2\2\u00b0"+
		"\u00ac\3\2\2\2\u00b1\25\3\2\2\2\u00b2\u00b7\5H%\2\u00b3\u00b4\7\13\2\2"+
		"\u00b4\u00b6\5H%\2\u00b5\u00b3\3\2\2\2\u00b6\u00b9\3\2\2\2\u00b7\u00b5"+
		"\3\2\2\2\u00b7\u00b8\3\2\2\2\u00b8\u00ba\3\2\2\2\u00b9\u00b7\3\2\2\2\u00ba"+
		"\u00bb\7\4\2\2\u00bb\27\3\2\2\2\u00bc\u00be\5\32\16\2\u00bd\u00bc\3\2"+
		"\2\2\u00be\u00bf\3\2\2\2\u00bf\u00bd\3\2\2\2\u00bf\u00c0\3\2\2\2\u00c0"+
		"\31\3\2\2\2\u00c1\u00c6\5\34\17\2\u00c2\u00c3\7\13\2\2\u00c3\u00c5\5\34"+
		"\17\2\u00c4\u00c2\3\2\2\2\u00c5\u00c8\3\2\2\2\u00c6\u00c4\3\2\2\2\u00c6"+
		"\u00c7\3\2\2\2\u00c7\u00c9\3\2\2\2\u00c8\u00c6\3\2\2\2\u00c9\u00ca\7\4"+
		"\2\2\u00ca\33\3\2\2\2\u00cb\u00e1\5\36\20\2\u00cc\u00e1\5 \21\2\u00cd"+
		"\u00e1\5\"\22\2\u00ce\u00e1\5$\23\2\u00cf\u00e1\5&\24\2\u00d0\u00e1\5"+
		"(\25\2\u00d1\u00e1\5*\26\2\u00d2\u00e1\5,\27\2\u00d3\u00e1\5.\30\2\u00d4"+
		"\u00e1\5\60\31\2\u00d5\u00e1\5\62\32\2\u00d6\u00e1\5\64\33\2\u00d7\u00e1"+
		"\5\66\34\2\u00d8\u00e1\58\35\2\u00d9\u00e1\5:\36\2\u00da\u00e1\5<\37\2"+
		"\u00db\u00e1\5> \2\u00dc\u00e1\5@!\2\u00dd\u00e1\5B\"\2\u00de\u00e1\5"+
		"D#\2\u00df\u00e1\5F$\2\u00e0\u00cb\3\2\2\2\u00e0\u00cc\3\2\2\2\u00e0\u00cd"+
		"\3\2\2\2\u00e0\u00ce\3\2\2\2\u00e0\u00cf\3\2\2\2\u00e0\u00d0\3\2\2\2\u00e0"+
		"\u00d1\3\2\2\2\u00e0\u00d2\3\2\2\2\u00e0\u00d3\3\2\2\2\u00e0\u00d4\3\2"+
		"\2\2\u00e0\u00d5\3\2\2\2\u00e0\u00d6\3\2\2\2\u00e0\u00d7\3\2\2\2\u00e0"+
		"\u00d8\3\2\2\2\u00e0\u00d9\3\2\2\2\u00e0\u00da\3\2\2\2\u00e0\u00db\3\2"+
		"\2\2\u00e0\u00dc\3\2\2\2\u00e0\u00dd\3\2\2\2\u00e0\u00de\3\2\2\2\u00e0"+
		"\u00df\3\2\2\2\u00e1\35\3\2\2\2\u00e2\u00e3\3\2\2\2\u00e3\37\3\2\2\2\u00e4"+
		"\u00e5\7\f\2\2\u00e5\u00e6\5J&\2\u00e6\u00e7\7\r\2\2\u00e7\u00e8\5R*\2"+
		"\u00e8!\3\2\2\2\u00e9\u00ea\7\16\2\2\u00ea\u00eb\5J&\2\u00eb\u00ec\7\r"+
		"\2\2\u00ec\u00ed\5T+\2\u00ed\u00ee\7\17\2\2\u00ee\u00ef\5L\'\2\u00ef\u00f0"+
		"\7\20\2\2\u00f0#\3\2\2\2\u00f1\u00f2\7\21\2\2\u00f2\u00f3\5J&\2\u00f3"+
		"\u00f4\7\r\2\2\u00f4\u00f5\5L\'\2\u00f5\u00f6\7\r\2\2\u00f6\u00f7\5N("+
		"\2\u00f7%\3\2\2\2\u00f8\u00f9\7\22\2\2\u00f9\u00fa\5J&\2\u00fa\u00fb\7"+
		"\r\2\2\u00fb\u00fc\5T+\2\u00fc\u00fd\7\17\2\2\u00fd\u00fe\5L\'\2\u00fe"+
		"\u00ff\7\20\2\2\u00ff\'\3\2\2\2\u0100\u0101\7\23\2\2\u0101\u0102\5J&\2"+
		"\u0102\u0103\7\r\2\2\u0103\u0104\5L\'\2\u0104\u0105\7\r\2\2\u0105\u0106"+
		"\5N(\2\u0106)\3\2\2\2\u0107\u0108\7\24\2\2\u0108\u0109\5J&\2\u0109\u010a"+
		"\7\r\2\2\u010a\u010b\5L\'\2\u010b+\3\2\2\2\u010c\u010d\7\25\2\2\u010d"+
		"\u010e\5J&\2\u010e\u010f\7\r\2\2\u010f\u0110\5L\'\2\u0110\u0111\7\r\2"+
		"\2\u0111\u0112\5R*\2\u0112-\3\2\2\2\u0113\u0114\7\26\2\2\u0114\u0115\5"+
		"J&\2\u0115\u0116\7\r\2\2\u0116\u0117\5L\'\2\u0117\u0118\7\r\2\2\u0118"+
		"\u0119\5N(\2\u0119/\3\2\2\2\u011a\u011b\7\27\2\2\u011b\u011c\5J&\2\u011c"+
		"\u011d\7\r\2\2\u011d\u011e\5L\'\2\u011e\61\3\2\2\2\u011f\u0120\7)\2\2"+
		"\u0120\u0121\7\7\2\2\u0121\63\3\2\2\2\u0122\u0123\7\30\2\2\u0123\u0124"+
		"\7)\2\2\u0124\65\3\2\2\2\u0125\u0126\7\31\2\2\u0126\u0127\7)\2\2\u0127"+
		"\67\3\2\2\2\u0128\u0129\7\32\2\2\u0129\u012a\7)\2\2\u012a9\3\2\2\2\u012b"+
		"\u012c\7\33\2\2\u012c\u012d\7)\2\2\u012d;\3\2\2\2\u012e\u012f\7\34\2\2"+
		"\u012f\u0130\7)\2\2\u0130=\3\2\2\2\u0131\u0132\7\35\2\2\u0132\u0133\7"+
		")\2\2\u0133?\3\2\2\2\u0134\u0135\7\36\2\2\u0135A\3\2\2\2\u0136\u0137\7"+
		"\37\2\2\u0137C\3\2\2\2\u0138\u0139\7 \2\2\u0139E\3\2\2\2\u013a\u013b\7"+
		"!\2\2\u013bG\3\2\2\2\u013c\u013d\t\3\2\2\u013dI\3\2\2\2\u013e\u013f\7"+
		"(\2\2\u013fK\3\2\2\2\u0140\u0141\7(\2\2\u0141M\3\2\2\2\u0142\u0143\7("+
		"\2\2\u0143O\3\2\2\2\u0144\u0145\7\61\2\2\u0145Q\3\2\2\2\u0146\u0147\7"+
		"\62\2\2\u0147S\3\2\2\2\u0148\u0149\7\62\2\2\u0149U\3\2\2\2\u014a\u014b"+
		"\t\4\2\2\u014b\u014d\5X-\2\u014c\u014e\7\4\2\2\u014d\u014c\3\2\2\2\u014d"+
		"\u014e\3\2\2\2\u014e\u0157\3\2\2\2\u014f\u0150\7-\2\2\u0150\u0152\5X-"+
		"\2\u0151\u0153\7\4\2\2\u0152\u0151\3\2\2\2\u0152\u0153\3\2\2\2\u0153\u0154"+
		"\3\2\2\2\u0154\u0155\5Z.\2\u0155\u0157\3\2\2\2\u0156\u014a\3\2\2\2\u0156"+
		"\u014f\3\2\2\2\u0157W\3\2\2\2\u0158\u0159\b-\1\2\u0159\u015a\7\17\2\2"+
		"\u015a\u015b\5X-\2\u015b\u015c\7\20\2\2\u015c\u0168\3\2\2\2\u015d\u015e"+
		"\5P)\2\u015e\u015f\7\6\2\2\u015f\u0160\5R*\2\u0160\u0168\3\2\2\2\u0161"+
		"\u0162\5H%\2\u0162\u0163\7\7\2\2\u0163\u0164\5J&\2\u0164\u0165\7\6\2\2"+
		"\u0165\u0166\5R*\2\u0166\u0168\3\2\2\2\u0167\u0158\3\2\2\2\u0167\u015d"+
		"\3\2\2\2\u0167\u0161\3\2\2\2\u0168\u0171\3\2\2\2\u0169\u016a\f\6\2\2\u016a"+
		"\u016b\7/\2\2\u016b\u0170\5X-\7\u016c\u016d\f\5\2\2\u016d\u016e\7\60\2"+
		"\2\u016e\u0170\5X-\6\u016f\u0169\3\2\2\2\u016f\u016c\3\2\2\2\u0170\u0173"+
		"\3\2\2\2\u0171\u016f\3\2\2\2\u0171\u0172\3\2\2\2\u0172Y\3\2\2\2\u0173"+
		"\u0171\3\2\2\2\u0174\u0176\7\"\2\2\u0175\u0177\5\\/\2\u0176\u0175\3\2"+
		"\2\2\u0177\u0178\3\2\2\2\u0178\u0176\3\2\2\2\u0178\u0179\3\2\2\2\u0179"+
		"[\3\2\2\2\u017a\u017b\5^\60\2\u017b\u017c\7\7\2\2\u017c\u017d\t\5\2\2"+
		"\u017d\u017e\7\4\2\2\u017e]\3\2\2\2\u017f\u0180\t\6\2\2\u0180_\3\2\2\2"+
		"\30ehrw}\u0081\u0085\u008a\u00a3\u00a7\u00b0\u00b7\u00bf\u00c6\u00e0\u014d"+
		"\u0152\u0156\u0167\u016f\u0171\u0178";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}