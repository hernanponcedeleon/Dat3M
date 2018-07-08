// Generated from LitmusX86.g4 by ANTLR 4.7

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
public class LitmusX86Parser extends Parser {
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
	public static final int
		RULE_main = 0, RULE_header = 1, RULE_headerComment = 2, RULE_variableDeclaratorList = 3, 
		RULE_variableDeclarator = 4, RULE_variableDeclaratorLocation = 5, RULE_variableDeclaratorRegister = 6, 
		RULE_variableDeclaratorRegisterLocation = 7, RULE_variableList = 8, RULE_variable = 9, 
		RULE_threadDeclaratorList = 10, RULE_instructionList = 11, RULE_instructionRow = 12, 
		RULE_instruction = 13, RULE_none = 14, RULE_loadValueToRegister = 15, 
		RULE_loadLocationToRegister = 16, RULE_storeValueToLocation = 17, RULE_storeRegisterToLocation = 18, 
		RULE_mfence = 19, RULE_lfence = 20, RULE_sfence = 21, RULE_exchangeRegisterLocation = 22, 
		RULE_incrementLocation = 23, RULE_compareRegisterValue = 24, RULE_compareLocationValue = 25, 
		RULE_addRegisterRegister = 26, RULE_addRegisterValue = 27, RULE_thread = 28, 
		RULE_r1 = 29, RULE_r2 = 30, RULE_location = 31, RULE_value = 32, RULE_assertionList = 33, 
		RULE_assertion = 34, RULE_assertionListExpectationList = 35, RULE_assertionListExpectation = 36, 
		RULE_assertionListExpectationTest = 37;
	public static final String[] ruleNames = {
		"main", "header", "headerComment", "variableDeclaratorList", "variableDeclarator", 
		"variableDeclaratorLocation", "variableDeclaratorRegister", "variableDeclaratorRegisterLocation", 
		"variableList", "variable", "threadDeclaratorList", "instructionList", 
		"instructionRow", "instruction", "none", "loadValueToRegister", "loadLocationToRegister", 
		"storeValueToLocation", "storeRegisterToLocation", "mfence", "lfence", 
		"sfence", "exchangeRegisterLocation", "incrementLocation", "compareRegisterValue", 
		"compareLocationValue", "addRegisterRegister", "addRegisterValue", "thread", 
		"r1", "r2", "location", "value", "assertionList", "assertion", "assertionListExpectationList", 
		"assertionListExpectation", "assertionListExpectationTest"
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

	@Override
	public String getGrammarFileName() { return "LitmusX86.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public LitmusX86Parser(TokenStream input) {
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
		public TerminalNode EOF() { return getToken(LitmusX86Parser.EOF, 0); }
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitMain(this);
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
			setState(76);
			header();
			setState(77);
			variableDeclaratorList();
			setState(78);
			threadDeclaratorList();
			setState(79);
			instructionList();
			setState(81);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5) {
				{
				setState(80);
				variableList();
				}
			}

			setState(84);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << AssertionExistsNot) | (1L << AssertionExists) | (1L << AssertionFinal) | (1L << AssertionForall))) != 0)) {
				{
				setState(83);
				assertionList();
				}
			}

			setState(86);
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
		public TerminalNode LitmusLanguage() { return getToken(LitmusX86Parser.LitmusLanguage, 0); }
		public HeaderCommentContext headerComment() {
			return getRuleContext(HeaderCommentContext.class,0);
		}
		public HeaderContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_header; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitHeader(this);
			else return visitor.visitChildren(this);
		}
	}

	public final HeaderContext header() throws RecognitionException {
		HeaderContext _localctx = new HeaderContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_header);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(88);
			match(LitmusLanguage);
			setState(89);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitHeaderComment(this);
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
			setState(94);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__10) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << LitmusLanguage) | (1L << Mov) | (1L << Xchg) | (1L << Mfence) | (1L << Lfence) | (1L << Sfence) | (1L << Inc) | (1L << Cmp) | (1L << Add) | (1L << Register) | (1L << ThreadIdentifier) | (1L << AssertionExistsNot) | (1L << AssertionExists) | (1L << AssertionFinal) | (1L << AssertionForall) | (1L << LogicAnd) | (1L << LogicOr) | (1L << Identifier) | (1L << DigitSequence) | (1L << Word) | (1L << Whitespace) | (1L << Newline) | (1L << BlockComment) | (1L << ExecConfig))) != 0)) {
				{
				{
				setState(91);
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
				setState(96);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariableDeclaratorList(this);
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
			setState(97);
			match(T__0);
			setState(99);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ThreadIdentifier) | (1L << Identifier) | (1L << DigitSequence))) != 0)) {
				{
				setState(98);
				variableDeclarator();
				}
			}

			setState(105);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(101);
					match(T__1);
					setState(102);
					variableDeclarator();
					}
					} 
				}
				setState(107);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			}
			setState(109);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(108);
				match(T__1);
				}
			}

			setState(111);
			match(T__2);
			setState(113);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(112);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariableDeclarator(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorContext variableDeclarator() throws RecognitionException {
		VariableDeclaratorContext _localctx = new VariableDeclaratorContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_variableDeclarator);
		try {
			setState(118);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(115);
				variableDeclaratorLocation();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(116);
				variableDeclaratorRegister();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(117);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariableDeclaratorLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorLocationContext variableDeclaratorLocation() throws RecognitionException {
		VariableDeclaratorLocationContext _localctx = new VariableDeclaratorLocationContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_variableDeclaratorLocation);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(120);
			location();
			setState(121);
			match(T__3);
			setState(122);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariableDeclaratorRegister(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorRegisterContext variableDeclaratorRegister() throws RecognitionException {
		VariableDeclaratorRegisterContext _localctx = new VariableDeclaratorRegisterContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_variableDeclaratorRegister);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(124);
			thread();
			setState(125);
			match(T__4);
			setState(126);
			r1();
			setState(127);
			match(T__3);
			setState(128);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariableDeclaratorRegisterLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableDeclaratorRegisterLocationContext variableDeclaratorRegisterLocation() throws RecognitionException {
		VariableDeclaratorRegisterLocationContext _localctx = new VariableDeclaratorRegisterLocationContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_variableDeclaratorRegisterLocation);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(130);
			thread();
			setState(131);
			match(T__4);
			setState(132);
			r1();
			setState(133);
			match(T__3);
			setState(134);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariableList(this);
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
			setState(136);
			match(T__5);
			setState(137);
			match(T__6);
			setState(138);
			variable();
			setState(143);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(139);
					match(T__1);
					setState(140);
					variable();
					}
					} 
				}
				setState(145);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
			}
			setState(147);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(146);
				match(T__1);
				}
			}

			setState(149);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitVariable(this);
			else return visitor.visitChildren(this);
		}
	}

	public final VariableContext variable() throws RecognitionException {
		VariableContext _localctx = new VariableContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_variable);
		try {
			setState(156);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case Identifier:
				enterOuterAlt(_localctx, 1);
				{
				setState(151);
				location();
				}
				break;
			case ThreadIdentifier:
			case DigitSequence:
				enterOuterAlt(_localctx, 2);
				{
				setState(152);
				thread();
				setState(153);
				match(T__4);
				setState(154);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitThreadDeclaratorList(this);
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
			setState(158);
			thread();
			setState(163);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__8) {
				{
				{
				setState(159);
				match(T__8);
				setState(160);
				thread();
				}
				}
				setState(165);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(166);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitInstructionList(this);
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
			setState(169); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(168);
				instructionRow();
				}
				}
				setState(171); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__8) | (1L << Mov) | (1L << Xchg) | (1L << Mfence) | (1L << Lfence) | (1L << Sfence) | (1L << Inc) | (1L << Cmp) | (1L << Add))) != 0) );
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitInstructionRow(this);
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
			setState(173);
			instruction();
			setState(178);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__8) {
				{
				{
				setState(174);
				match(T__8);
				setState(175);
				instruction();
				}
				}
				setState(180);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(181);
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
		public LoadValueToRegisterContext loadValueToRegister() {
			return getRuleContext(LoadValueToRegisterContext.class,0);
		}
		public LoadLocationToRegisterContext loadLocationToRegister() {
			return getRuleContext(LoadLocationToRegisterContext.class,0);
		}
		public StoreValueToLocationContext storeValueToLocation() {
			return getRuleContext(StoreValueToLocationContext.class,0);
		}
		public StoreRegisterToLocationContext storeRegisterToLocation() {
			return getRuleContext(StoreRegisterToLocationContext.class,0);
		}
		public MfenceContext mfence() {
			return getRuleContext(MfenceContext.class,0);
		}
		public LfenceContext lfence() {
			return getRuleContext(LfenceContext.class,0);
		}
		public SfenceContext sfence() {
			return getRuleContext(SfenceContext.class,0);
		}
		public ExchangeRegisterLocationContext exchangeRegisterLocation() {
			return getRuleContext(ExchangeRegisterLocationContext.class,0);
		}
		public IncrementLocationContext incrementLocation() {
			return getRuleContext(IncrementLocationContext.class,0);
		}
		public CompareRegisterValueContext compareRegisterValue() {
			return getRuleContext(CompareRegisterValueContext.class,0);
		}
		public CompareLocationValueContext compareLocationValue() {
			return getRuleContext(CompareLocationValueContext.class,0);
		}
		public AddRegisterRegisterContext addRegisterRegister() {
			return getRuleContext(AddRegisterRegisterContext.class,0);
		}
		public AddRegisterValueContext addRegisterValue() {
			return getRuleContext(AddRegisterValueContext.class,0);
		}
		public InstructionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instruction; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitInstruction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final InstructionContext instruction() throws RecognitionException {
		InstructionContext _localctx = new InstructionContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_instruction);
		try {
			setState(197);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,14,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(183);
				none();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(184);
				loadValueToRegister();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(185);
				loadLocationToRegister();
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(186);
				storeValueToLocation();
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(187);
				storeRegisterToLocation();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(188);
				mfence();
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(189);
				lfence();
				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(190);
				sfence();
				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(191);
				exchangeRegisterLocation();
				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(192);
				incrementLocation();
				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(193);
				compareRegisterValue();
				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(194);
				compareLocationValue();
				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(195);
				addRegisterRegister();
				}
				break;
			case 14:
				enterOuterAlt(_localctx, 14);
				{
				setState(196);
				addRegisterValue();
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

	public static class NoneContext extends ParserRuleContext {
		public NoneContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_none; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitNone(this);
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

	public static class LoadValueToRegisterContext extends ParserRuleContext {
		public TerminalNode Mov() { return getToken(LitmusX86Parser.Mov, 0); }
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public LoadValueToRegisterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_loadValueToRegister; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitLoadValueToRegister(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LoadValueToRegisterContext loadValueToRegister() throws RecognitionException {
		LoadValueToRegisterContext _localctx = new LoadValueToRegisterContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_loadValueToRegister);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(201);
			match(Mov);
			setState(202);
			r1();
			setState(203);
			match(T__9);
			setState(205);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__10) {
				{
				setState(204);
				match(T__10);
				}
			}

			setState(207);
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

	public static class LoadLocationToRegisterContext extends ParserRuleContext {
		public TerminalNode Mov() { return getToken(LitmusX86Parser.Mov, 0); }
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public LoadLocationToRegisterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_loadLocationToRegister; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitLoadLocationToRegister(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LoadLocationToRegisterContext loadLocationToRegister() throws RecognitionException {
		LoadLocationToRegisterContext _localctx = new LoadLocationToRegisterContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_loadLocationToRegister);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(209);
			match(Mov);
			setState(210);
			r1();
			setState(211);
			match(T__9);
			setState(213);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__6) {
				{
				setState(212);
				match(T__6);
				}
			}

			setState(215);
			location();
			setState(217);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(216);
				match(T__7);
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

	public static class StoreValueToLocationContext extends ParserRuleContext {
		public TerminalNode Mov() { return getToken(LitmusX86Parser.Mov, 0); }
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public StoreValueToLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_storeValueToLocation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitStoreValueToLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StoreValueToLocationContext storeValueToLocation() throws RecognitionException {
		StoreValueToLocationContext _localctx = new StoreValueToLocationContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_storeValueToLocation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(219);
			match(Mov);
			setState(221);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__6) {
				{
				setState(220);
				match(T__6);
				}
			}

			setState(223);
			location();
			setState(225);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(224);
				match(T__7);
				}
			}

			setState(227);
			match(T__9);
			setState(229);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__10) {
				{
				setState(228);
				match(T__10);
				}
			}

			setState(231);
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

	public static class StoreRegisterToLocationContext extends ParserRuleContext {
		public TerminalNode Mov() { return getToken(LitmusX86Parser.Mov, 0); }
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public StoreRegisterToLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_storeRegisterToLocation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitStoreRegisterToLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StoreRegisterToLocationContext storeRegisterToLocation() throws RecognitionException {
		StoreRegisterToLocationContext _localctx = new StoreRegisterToLocationContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_storeRegisterToLocation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(233);
			match(Mov);
			setState(235);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__6) {
				{
				setState(234);
				match(T__6);
				}
			}

			setState(237);
			location();
			setState(239);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(238);
				match(T__7);
				}
			}

			setState(241);
			match(T__9);
			setState(242);
			r1();
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

	public static class MfenceContext extends ParserRuleContext {
		public TerminalNode Mfence() { return getToken(LitmusX86Parser.Mfence, 0); }
		public MfenceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_mfence; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitMfence(this);
			else return visitor.visitChildren(this);
		}
	}

	public final MfenceContext mfence() throws RecognitionException {
		MfenceContext _localctx = new MfenceContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_mfence);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(244);
			match(Mfence);
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

	public static class LfenceContext extends ParserRuleContext {
		public TerminalNode Lfence() { return getToken(LitmusX86Parser.Lfence, 0); }
		public LfenceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lfence; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitLfence(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LfenceContext lfence() throws RecognitionException {
		LfenceContext _localctx = new LfenceContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_lfence);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(246);
			match(Lfence);
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

	public static class SfenceContext extends ParserRuleContext {
		public TerminalNode Sfence() { return getToken(LitmusX86Parser.Sfence, 0); }
		public SfenceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sfence; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitSfence(this);
			else return visitor.visitChildren(this);
		}
	}

	public final SfenceContext sfence() throws RecognitionException {
		SfenceContext _localctx = new SfenceContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_sfence);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(248);
			match(Sfence);
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

	public static class ExchangeRegisterLocationContext extends ParserRuleContext {
		public TerminalNode Xchg() { return getToken(LitmusX86Parser.Xchg, 0); }
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public ExchangeRegisterLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_exchangeRegisterLocation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitExchangeRegisterLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ExchangeRegisterLocationContext exchangeRegisterLocation() throws RecognitionException {
		ExchangeRegisterLocationContext _localctx = new ExchangeRegisterLocationContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_exchangeRegisterLocation);
		int _la;
		try {
			setState(271);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,27,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(250);
				match(Xchg);
				setState(251);
				r1();
				setState(252);
				match(T__9);
				setState(254);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__6) {
					{
					setState(253);
					match(T__6);
					}
				}

				setState(256);
				location();
				setState(258);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__7) {
					{
					setState(257);
					match(T__7);
					}
				}

				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(260);
				match(Xchg);
				setState(262);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__6) {
					{
					setState(261);
					match(T__6);
					}
				}

				setState(264);
				location();
				setState(266);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__7) {
					{
					setState(265);
					match(T__7);
					}
				}

				setState(268);
				match(T__9);
				setState(269);
				r1();
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

	public static class IncrementLocationContext extends ParserRuleContext {
		public TerminalNode Inc() { return getToken(LitmusX86Parser.Inc, 0); }
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public IncrementLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_incrementLocation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitIncrementLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final IncrementLocationContext incrementLocation() throws RecognitionException {
		IncrementLocationContext _localctx = new IncrementLocationContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_incrementLocation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(273);
			match(Inc);
			setState(275);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__6) {
				{
				setState(274);
				match(T__6);
				}
			}

			setState(277);
			location();
			setState(279);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(278);
				match(T__7);
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

	public static class CompareRegisterValueContext extends ParserRuleContext {
		public TerminalNode Cmp() { return getToken(LitmusX86Parser.Cmp, 0); }
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public CompareRegisterValueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_compareRegisterValue; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitCompareRegisterValue(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CompareRegisterValueContext compareRegisterValue() throws RecognitionException {
		CompareRegisterValueContext _localctx = new CompareRegisterValueContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_compareRegisterValue);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(281);
			match(Cmp);
			setState(282);
			r1();
			setState(283);
			match(T__9);
			setState(285);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__10) {
				{
				setState(284);
				match(T__10);
				}
			}

			setState(287);
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

	public static class CompareLocationValueContext extends ParserRuleContext {
		public TerminalNode Cmp() { return getToken(LitmusX86Parser.Cmp, 0); }
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public CompareLocationValueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_compareLocationValue; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitCompareLocationValue(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CompareLocationValueContext compareLocationValue() throws RecognitionException {
		CompareLocationValueContext _localctx = new CompareLocationValueContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_compareLocationValue);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(289);
			match(Cmp);
			setState(291);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__6) {
				{
				setState(290);
				match(T__6);
				}
			}

			setState(293);
			location();
			setState(295);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(294);
				match(T__7);
				}
			}

			setState(297);
			match(T__9);
			setState(299);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__10) {
				{
				setState(298);
				match(T__10);
				}
			}

			setState(301);
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

	public static class AddRegisterRegisterContext extends ParserRuleContext {
		public TerminalNode Add() { return getToken(LitmusX86Parser.Add, 0); }
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public R2Context r2() {
			return getRuleContext(R2Context.class,0);
		}
		public AddRegisterRegisterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_addRegisterRegister; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAddRegisterRegister(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AddRegisterRegisterContext addRegisterRegister() throws RecognitionException {
		AddRegisterRegisterContext _localctx = new AddRegisterRegisterContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_addRegisterRegister);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(303);
			match(Add);
			setState(304);
			r1();
			setState(305);
			match(T__9);
			setState(306);
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

	public static class AddRegisterValueContext extends ParserRuleContext {
		public TerminalNode Add() { return getToken(LitmusX86Parser.Add, 0); }
		public R1Context r1() {
			return getRuleContext(R1Context.class,0);
		}
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public AddRegisterValueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_addRegisterValue; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAddRegisterValue(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AddRegisterValueContext addRegisterValue() throws RecognitionException {
		AddRegisterValueContext _localctx = new AddRegisterValueContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_addRegisterValue);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(308);
			match(Add);
			setState(309);
			r1();
			setState(310);
			match(T__9);
			setState(312);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__10) {
				{
				setState(311);
				match(T__10);
				}
			}

			setState(314);
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

	public static class ThreadContext extends ParserRuleContext {
		public TerminalNode ThreadIdentifier() { return getToken(LitmusX86Parser.ThreadIdentifier, 0); }
		public TerminalNode DigitSequence() { return getToken(LitmusX86Parser.DigitSequence, 0); }
		public ThreadContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_thread; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitThread(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ThreadContext thread() throws RecognitionException {
		ThreadContext _localctx = new ThreadContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_thread);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(316);
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
		public TerminalNode Register() { return getToken(LitmusX86Parser.Register, 0); }
		public R1Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_r1; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitR1(this);
			else return visitor.visitChildren(this);
		}
	}

	public final R1Context r1() throws RecognitionException {
		R1Context _localctx = new R1Context(_ctx, getState());
		enterRule(_localctx, 58, RULE_r1);
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

	public static class R2Context extends ParserRuleContext {
		public TerminalNode Register() { return getToken(LitmusX86Parser.Register, 0); }
		public R2Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_r2; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitR2(this);
			else return visitor.visitChildren(this);
		}
	}

	public final R2Context r2() throws RecognitionException {
		R2Context _localctx = new R2Context(_ctx, getState());
		enterRule(_localctx, 60, RULE_r2);
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
		public TerminalNode Identifier() { return getToken(LitmusX86Parser.Identifier, 0); }
		public LocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_location; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitLocation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LocationContext location() throws RecognitionException {
		LocationContext _localctx = new LocationContext(_ctx, getState());
		enterRule(_localctx, 62, RULE_location);
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
		public TerminalNode DigitSequence() { return getToken(LitmusX86Parser.DigitSequence, 0); }
		public ValueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_value; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitValue(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ValueContext value() throws RecognitionException {
		ValueContext _localctx = new ValueContext(_ctx, getState());
		enterRule(_localctx, 64, RULE_value);
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

	public static class AssertionListContext extends ParserRuleContext {
		public AssertionContext assertion() {
			return getRuleContext(AssertionContext.class,0);
		}
		public TerminalNode AssertionExists() { return getToken(LitmusX86Parser.AssertionExists, 0); }
		public TerminalNode AssertionExistsNot() { return getToken(LitmusX86Parser.AssertionExistsNot, 0); }
		public TerminalNode AssertionForall() { return getToken(LitmusX86Parser.AssertionForall, 0); }
		public List<TerminalNode> AssertionFinal() { return getTokens(LitmusX86Parser.AssertionFinal); }
		public TerminalNode AssertionFinal(int i) {
			return getToken(LitmusX86Parser.AssertionFinal, i);
		}
		public AssertionListExpectationListContext assertionListExpectationList() {
			return getRuleContext(AssertionListExpectationListContext.class,0);
		}
		public AssertionListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertionList; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListContext assertionList() throws RecognitionException {
		AssertionListContext _localctx = new AssertionListContext(_ctx, getState());
		enterRule(_localctx, 66, RULE_assertionList);
		int _la;
		try {
			setState(337);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case AssertionExistsNot:
			case AssertionExists:
			case AssertionForall:
				enterOuterAlt(_localctx, 1);
				{
				setState(326);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << AssertionExistsNot) | (1L << AssertionExists) | (1L << AssertionForall))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(327);
				assertion(0);
				setState(329);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__1) {
					{
					setState(328);
					match(T__1);
					}
				}

				}
				break;
			case AssertionFinal:
				enterOuterAlt(_localctx, 2);
				{
				setState(331);
				match(AssertionFinal);
				setState(332);
				match(AssertionFinal);
				setState(334);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__1) {
					{
					setState(333);
					match(T__1);
					}
				}

				setState(336);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionLocation(this);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionRegister(this);
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
		public TerminalNode LogicAnd() { return getToken(LitmusX86Parser.LogicAnd, 0); }
		public AssertionAndContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionAnd(this);
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
		public TerminalNode LogicOr() { return getToken(LitmusX86Parser.LogicOr, 0); }
		public AssertionOrContext(AssertionContext ctx) { copyFrom(ctx); }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionOr(this);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionParenthesis(this);
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
		int _startState = 68;
		enterRecursionRule(_localctx, 68, RULE_assertion, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(354);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__11:
				{
				_localctx = new AssertionParenthesisContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(340);
				match(T__11);
				setState(341);
				assertion(0);
				setState(342);
				match(T__12);
				}
				break;
			case Identifier:
				{
				_localctx = new AssertionLocationContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(344);
				location();
				setState(345);
				match(T__3);
				setState(346);
				value();
				}
				break;
			case ThreadIdentifier:
			case DigitSequence:
				{
				_localctx = new AssertionRegisterContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(348);
				thread();
				setState(349);
				match(T__4);
				setState(350);
				r1();
				setState(351);
				match(T__3);
				setState(352);
				value();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(364);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,40,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(362);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,39,_ctx) ) {
					case 1:
						{
						_localctx = new AssertionAndContext(new AssertionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_assertion);
						setState(356);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(357);
						match(LogicAnd);
						setState(358);
						assertion(5);
						}
						break;
					case 2:
						{
						_localctx = new AssertionOrContext(new AssertionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_assertion);
						setState(359);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(360);
						match(LogicOr);
						setState(361);
						assertion(4);
						}
						break;
					}
					} 
				}
				setState(366);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,40,_ctx);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionListExpectationList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListExpectationListContext assertionListExpectationList() throws RecognitionException {
		AssertionListExpectationListContext _localctx = new AssertionListExpectationListContext(_ctx, getState());
		enterRule(_localctx, 70, RULE_assertionListExpectationList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(367);
			match(T__13);
			setState(369); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(368);
				assertionListExpectation();
				}
				}
				setState(371); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0) );
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
		public TerminalNode AssertionExists() { return getToken(LitmusX86Parser.AssertionExists, 0); }
		public TerminalNode AssertionExistsNot() { return getToken(LitmusX86Parser.AssertionExistsNot, 0); }
		public AssertionListExpectationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assertionListExpectation; }
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionListExpectation(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListExpectationContext assertionListExpectation() throws RecognitionException {
		AssertionListExpectationContext _localctx = new AssertionListExpectationContext(_ctx, getState());
		enterRule(_localctx, 72, RULE_assertionListExpectation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(373);
			assertionListExpectationTest();
			setState(374);
			match(T__4);
			setState(375);
			_la = _input.LA(1);
			if ( !(_la==AssertionExistsNot || _la==AssertionExists) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(376);
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
			if ( visitor instanceof LitmusX86Visitor ) return ((LitmusX86Visitor<? extends T>)visitor).visitAssertionListExpectationTest(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AssertionListExpectationTestContext assertionListExpectationTest() throws RecognitionException {
		AssertionListExpectationTestContext _localctx = new AssertionListExpectationTestContext(_ctx, getState());
		enterRule(_localctx, 74, RULE_assertionListExpectationTest);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(378);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) ) {
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
		case 34:
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3,\u017f\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\3\2\3\2\3\2\3\2\3\2\5\2T\n"+
		"\2\3\2\5\2W\n\2\3\2\3\2\3\3\3\3\3\3\3\4\7\4_\n\4\f\4\16\4b\13\4\3\5\3"+
		"\5\5\5f\n\5\3\5\3\5\7\5j\n\5\f\5\16\5m\13\5\3\5\5\5p\n\5\3\5\3\5\5\5t"+
		"\n\5\3\6\3\6\3\6\5\6y\n\6\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\b\3\b\3\b\3\t"+
		"\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\7\n\u0090\n\n\f\n\16\n\u0093"+
		"\13\n\3\n\5\n\u0096\n\n\3\n\3\n\3\13\3\13\3\13\3\13\3\13\5\13\u009f\n"+
		"\13\3\f\3\f\3\f\7\f\u00a4\n\f\f\f\16\f\u00a7\13\f\3\f\3\f\3\r\6\r\u00ac"+
		"\n\r\r\r\16\r\u00ad\3\16\3\16\3\16\7\16\u00b3\n\16\f\16\16\16\u00b6\13"+
		"\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3"+
		"\17\3\17\3\17\5\17\u00c8\n\17\3\20\3\20\3\21\3\21\3\21\3\21\5\21\u00d0"+
		"\n\21\3\21\3\21\3\22\3\22\3\22\3\22\5\22\u00d8\n\22\3\22\3\22\5\22\u00dc"+
		"\n\22\3\23\3\23\5\23\u00e0\n\23\3\23\3\23\5\23\u00e4\n\23\3\23\3\23\5"+
		"\23\u00e8\n\23\3\23\3\23\3\24\3\24\5\24\u00ee\n\24\3\24\3\24\5\24\u00f2"+
		"\n\24\3\24\3\24\3\24\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30\3\30\3\30"+
		"\5\30\u0101\n\30\3\30\3\30\5\30\u0105\n\30\3\30\3\30\5\30\u0109\n\30\3"+
		"\30\3\30\5\30\u010d\n\30\3\30\3\30\3\30\5\30\u0112\n\30\3\31\3\31\5\31"+
		"\u0116\n\31\3\31\3\31\5\31\u011a\n\31\3\32\3\32\3\32\3\32\5\32\u0120\n"+
		"\32\3\32\3\32\3\33\3\33\5\33\u0126\n\33\3\33\3\33\5\33\u012a\n\33\3\33"+
		"\3\33\5\33\u012e\n\33\3\33\3\33\3\34\3\34\3\34\3\34\3\34\3\35\3\35\3\35"+
		"\3\35\5\35\u013b\n\35\3\35\3\35\3\36\3\36\3\37\3\37\3 \3 \3!\3!\3\"\3"+
		"\"\3#\3#\3#\5#\u014c\n#\3#\3#\3#\5#\u0151\n#\3#\5#\u0154\n#\3$\3$\3$\3"+
		"$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\5$\u0165\n$\3$\3$\3$\3$\3$\3$\7$\u016d"+
		"\n$\f$\16$\u0170\13$\3%\3%\6%\u0174\n%\r%\16%\u0175\3&\3&\3&\3&\3&\3\'"+
		"\3\'\3\'\2\3F(\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64"+
		"\668:<>@BDFHJL\2\7\3\2\3\3\4\2\37\37\'\'\4\2 !##\3\2 !\3\2\21\24\2\u0190"+
		"\2N\3\2\2\2\4Z\3\2\2\2\6`\3\2\2\2\bc\3\2\2\2\nx\3\2\2\2\fz\3\2\2\2\16"+
		"~\3\2\2\2\20\u0084\3\2\2\2\22\u008a\3\2\2\2\24\u009e\3\2\2\2\26\u00a0"+
		"\3\2\2\2\30\u00ab\3\2\2\2\32\u00af\3\2\2\2\34\u00c7\3\2\2\2\36\u00c9\3"+
		"\2\2\2 \u00cb\3\2\2\2\"\u00d3\3\2\2\2$\u00dd\3\2\2\2&\u00eb\3\2\2\2(\u00f6"+
		"\3\2\2\2*\u00f8\3\2\2\2,\u00fa\3\2\2\2.\u0111\3\2\2\2\60\u0113\3\2\2\2"+
		"\62\u011b\3\2\2\2\64\u0123\3\2\2\2\66\u0131\3\2\2\28\u0136\3\2\2\2:\u013e"+
		"\3\2\2\2<\u0140\3\2\2\2>\u0142\3\2\2\2@\u0144\3\2\2\2B\u0146\3\2\2\2D"+
		"\u0153\3\2\2\2F\u0164\3\2\2\2H\u0171\3\2\2\2J\u0177\3\2\2\2L\u017c\3\2"+
		"\2\2NO\5\4\3\2OP\5\b\5\2PQ\5\26\f\2QS\5\30\r\2RT\5\22\n\2SR\3\2\2\2ST"+
		"\3\2\2\2TV\3\2\2\2UW\5D#\2VU\3\2\2\2VW\3\2\2\2WX\3\2\2\2XY\7\2\2\3Y\3"+
		"\3\2\2\2Z[\7\25\2\2[\\\5\6\4\2\\\5\3\2\2\2]_\n\2\2\2^]\3\2\2\2_b\3\2\2"+
		"\2`^\3\2\2\2`a\3\2\2\2a\7\3\2\2\2b`\3\2\2\2ce\7\3\2\2df\5\n\6\2ed\3\2"+
		"\2\2ef\3\2\2\2fk\3\2\2\2gh\7\4\2\2hj\5\n\6\2ig\3\2\2\2jm\3\2\2\2ki\3\2"+
		"\2\2kl\3\2\2\2lo\3\2\2\2mk\3\2\2\2np\7\4\2\2on\3\2\2\2op\3\2\2\2pq\3\2"+
		"\2\2qs\7\5\2\2rt\7\4\2\2sr\3\2\2\2st\3\2\2\2t\t\3\2\2\2uy\5\f\7\2vy\5"+
		"\16\b\2wy\5\20\t\2xu\3\2\2\2xv\3\2\2\2xw\3\2\2\2y\13\3\2\2\2z{\5@!\2{"+
		"|\7\6\2\2|}\5B\"\2}\r\3\2\2\2~\177\5:\36\2\177\u0080\7\7\2\2\u0080\u0081"+
		"\5<\37\2\u0081\u0082\7\6\2\2\u0082\u0083\5B\"\2\u0083\17\3\2\2\2\u0084"+
		"\u0085\5:\36\2\u0085\u0086\7\7\2\2\u0086\u0087\5<\37\2\u0087\u0088\7\6"+
		"\2\2\u0088\u0089\5@!\2\u0089\21\3\2\2\2\u008a\u008b\7\b\2\2\u008b\u008c"+
		"\7\t\2\2\u008c\u0091\5\24\13\2\u008d\u008e\7\4\2\2\u008e\u0090\5\24\13"+
		"\2\u008f\u008d\3\2\2\2\u0090\u0093\3\2\2\2\u0091\u008f\3\2\2\2\u0091\u0092"+
		"\3\2\2\2\u0092\u0095\3\2\2\2\u0093\u0091\3\2\2\2\u0094\u0096\7\4\2\2\u0095"+
		"\u0094\3\2\2\2\u0095\u0096\3\2\2\2\u0096\u0097\3\2\2\2\u0097\u0098\7\n"+
		"\2\2\u0098\23\3\2\2\2\u0099\u009f\5@!\2\u009a\u009b\5:\36\2\u009b\u009c"+
		"\7\7\2\2\u009c\u009d\5<\37\2\u009d\u009f\3\2\2\2\u009e\u0099\3\2\2\2\u009e"+
		"\u009a\3\2\2\2\u009f\25\3\2\2\2\u00a0\u00a5\5:\36\2\u00a1\u00a2\7\13\2"+
		"\2\u00a2\u00a4\5:\36\2\u00a3\u00a1\3\2\2\2\u00a4\u00a7\3\2\2\2\u00a5\u00a3"+
		"\3\2\2\2\u00a5\u00a6\3\2\2\2\u00a6\u00a8\3\2\2\2\u00a7\u00a5\3\2\2\2\u00a8"+
		"\u00a9\7\4\2\2\u00a9\27\3\2\2\2\u00aa\u00ac\5\32\16\2\u00ab\u00aa\3\2"+
		"\2\2\u00ac\u00ad\3\2\2\2\u00ad\u00ab\3\2\2\2\u00ad\u00ae\3\2\2\2\u00ae"+
		"\31\3\2\2\2\u00af\u00b4\5\34\17\2\u00b0\u00b1\7\13\2\2\u00b1\u00b3\5\34"+
		"\17\2\u00b2\u00b0\3\2\2\2\u00b3\u00b6\3\2\2\2\u00b4\u00b2\3\2\2\2\u00b4"+
		"\u00b5\3\2\2\2\u00b5\u00b7\3\2\2\2\u00b6\u00b4\3\2\2\2\u00b7\u00b8\7\4"+
		"\2\2\u00b8\33\3\2\2\2\u00b9\u00c8\5\36\20\2\u00ba\u00c8\5 \21\2\u00bb"+
		"\u00c8\5\"\22\2\u00bc\u00c8\5$\23\2\u00bd\u00c8\5&\24\2\u00be\u00c8\5"+
		"(\25\2\u00bf\u00c8\5*\26\2\u00c0\u00c8\5,\27\2\u00c1\u00c8\5.\30\2\u00c2"+
		"\u00c8\5\60\31\2\u00c3\u00c8\5\62\32\2\u00c4\u00c8\5\64\33\2\u00c5\u00c8"+
		"\5\66\34\2\u00c6\u00c8\58\35\2\u00c7\u00b9\3\2\2\2\u00c7\u00ba\3\2\2\2"+
		"\u00c7\u00bb\3\2\2\2\u00c7\u00bc\3\2\2\2\u00c7\u00bd\3\2\2\2\u00c7\u00be"+
		"\3\2\2\2\u00c7\u00bf\3\2\2\2\u00c7\u00c0\3\2\2\2\u00c7\u00c1\3\2\2\2\u00c7"+
		"\u00c2\3\2\2\2\u00c7\u00c3\3\2\2\2\u00c7\u00c4\3\2\2\2\u00c7\u00c5\3\2"+
		"\2\2\u00c7\u00c6\3\2\2\2\u00c8\35\3\2\2\2\u00c9\u00ca\3\2\2\2\u00ca\37"+
		"\3\2\2\2\u00cb\u00cc\7\26\2\2\u00cc\u00cd\5<\37\2\u00cd\u00cf\7\f\2\2"+
		"\u00ce\u00d0\7\r\2\2\u00cf\u00ce\3\2\2\2\u00cf\u00d0\3\2\2\2\u00d0\u00d1"+
		"\3\2\2\2\u00d1\u00d2\5B\"\2\u00d2!\3\2\2\2\u00d3\u00d4\7\26\2\2\u00d4"+
		"\u00d5\5<\37\2\u00d5\u00d7\7\f\2\2\u00d6\u00d8\7\t\2\2\u00d7\u00d6\3\2"+
		"\2\2\u00d7\u00d8\3\2\2\2\u00d8\u00d9\3\2\2\2\u00d9\u00db\5@!\2\u00da\u00dc"+
		"\7\n\2\2\u00db\u00da\3\2\2\2\u00db\u00dc\3\2\2\2\u00dc#\3\2\2\2\u00dd"+
		"\u00df\7\26\2\2\u00de\u00e0\7\t\2\2\u00df\u00de\3\2\2\2\u00df\u00e0\3"+
		"\2\2\2\u00e0\u00e1\3\2\2\2\u00e1\u00e3\5@!\2\u00e2\u00e4\7\n\2\2\u00e3"+
		"\u00e2\3\2\2\2\u00e3\u00e4\3\2\2\2\u00e4\u00e5\3\2\2\2\u00e5\u00e7\7\f"+
		"\2\2\u00e6\u00e8\7\r\2\2\u00e7\u00e6\3\2\2\2\u00e7\u00e8\3\2\2\2\u00e8"+
		"\u00e9\3\2\2\2\u00e9\u00ea\5B\"\2\u00ea%\3\2\2\2\u00eb\u00ed\7\26\2\2"+
		"\u00ec\u00ee\7\t\2\2\u00ed\u00ec\3\2\2\2\u00ed\u00ee\3\2\2\2\u00ee\u00ef"+
		"\3\2\2\2\u00ef\u00f1\5@!\2\u00f0\u00f2\7\n\2\2\u00f1\u00f0\3\2\2\2\u00f1"+
		"\u00f2\3\2\2\2\u00f2\u00f3\3\2\2\2\u00f3\u00f4\7\f\2\2\u00f4\u00f5\5<"+
		"\37\2\u00f5\'\3\2\2\2\u00f6\u00f7\7\30\2\2\u00f7)\3\2\2\2\u00f8\u00f9"+
		"\7\31\2\2\u00f9+\3\2\2\2\u00fa\u00fb\7\32\2\2\u00fb-\3\2\2\2\u00fc\u00fd"+
		"\7\27\2\2\u00fd\u00fe\5<\37\2\u00fe\u0100\7\f\2\2\u00ff\u0101\7\t\2\2"+
		"\u0100\u00ff\3\2\2\2\u0100\u0101\3\2\2\2\u0101\u0102\3\2\2\2\u0102\u0104"+
		"\5@!\2\u0103\u0105\7\n\2\2\u0104\u0103\3\2\2\2\u0104\u0105\3\2\2\2\u0105"+
		"\u0112\3\2\2\2\u0106\u0108\7\27\2\2\u0107\u0109\7\t\2\2\u0108\u0107\3"+
		"\2\2\2\u0108\u0109\3\2\2\2\u0109\u010a\3\2\2\2\u010a\u010c\5@!\2\u010b"+
		"\u010d\7\n\2\2\u010c\u010b\3\2\2\2\u010c\u010d\3\2\2\2\u010d\u010e\3\2"+
		"\2\2\u010e\u010f\7\f\2\2\u010f\u0110\5<\37\2\u0110\u0112\3\2\2\2\u0111"+
		"\u00fc\3\2\2\2\u0111\u0106\3\2\2\2\u0112/\3\2\2\2\u0113\u0115\7\33\2\2"+
		"\u0114\u0116\7\t\2\2\u0115\u0114\3\2\2\2\u0115\u0116\3\2\2\2\u0116\u0117"+
		"\3\2\2\2\u0117\u0119\5@!\2\u0118\u011a\7\n\2\2\u0119\u0118\3\2\2\2\u0119"+
		"\u011a\3\2\2\2\u011a\61\3\2\2\2\u011b\u011c\7\34\2\2\u011c\u011d\5<\37"+
		"\2\u011d\u011f\7\f\2\2\u011e\u0120\7\r\2\2\u011f\u011e\3\2\2\2\u011f\u0120"+
		"\3\2\2\2\u0120\u0121\3\2\2\2\u0121\u0122\5B\"\2\u0122\63\3\2\2\2\u0123"+
		"\u0125\7\34\2\2\u0124\u0126\7\t\2\2\u0125\u0124\3\2\2\2\u0125\u0126\3"+
		"\2\2\2\u0126\u0127\3\2\2\2\u0127\u0129\5@!\2\u0128\u012a\7\n\2\2\u0129"+
		"\u0128\3\2\2\2\u0129\u012a\3\2\2\2\u012a\u012b\3\2\2\2\u012b\u012d\7\f"+
		"\2\2\u012c\u012e\7\r\2\2\u012d\u012c\3\2\2\2\u012d\u012e\3\2\2\2\u012e"+
		"\u012f\3\2\2\2\u012f\u0130\5B\"\2\u0130\65\3\2\2\2\u0131\u0132\7\35\2"+
		"\2\u0132\u0133\5<\37\2\u0133\u0134\7\f\2\2\u0134\u0135\5> \2\u0135\67"+
		"\3\2\2\2\u0136\u0137\7\35\2\2\u0137\u0138\5<\37\2\u0138\u013a\7\f\2\2"+
		"\u0139\u013b\7\r\2\2\u013a\u0139\3\2\2\2\u013a\u013b\3\2\2\2\u013b\u013c"+
		"\3\2\2\2\u013c\u013d\5B\"\2\u013d9\3\2\2\2\u013e\u013f\t\3\2\2\u013f;"+
		"\3\2\2\2\u0140\u0141\7\36\2\2\u0141=\3\2\2\2\u0142\u0143\7\36\2\2\u0143"+
		"?\3\2\2\2\u0144\u0145\7&\2\2\u0145A\3\2\2\2\u0146\u0147\7\'\2\2\u0147"+
		"C\3\2\2\2\u0148\u0149\t\4\2\2\u0149\u014b\5F$\2\u014a\u014c\7\4\2\2\u014b"+
		"\u014a\3\2\2\2\u014b\u014c\3\2\2\2\u014c\u0154\3\2\2\2\u014d\u014e\7\""+
		"\2\2\u014e\u0150\7\"\2\2\u014f\u0151\7\4\2\2\u0150\u014f\3\2\2\2\u0150"+
		"\u0151\3\2\2\2\u0151\u0152\3\2\2\2\u0152\u0154\5H%\2\u0153\u0148\3\2\2"+
		"\2\u0153\u014d\3\2\2\2\u0154E\3\2\2\2\u0155\u0156\b$\1\2\u0156\u0157\7"+
		"\16\2\2\u0157\u0158\5F$\2\u0158\u0159\7\17\2\2\u0159\u0165\3\2\2\2\u015a"+
		"\u015b\5@!\2\u015b\u015c\7\6\2\2\u015c\u015d\5B\"\2\u015d\u0165\3\2\2"+
		"\2\u015e\u015f\5:\36\2\u015f\u0160\7\7\2\2\u0160\u0161\5<\37\2\u0161\u0162"+
		"\7\6\2\2\u0162\u0163\5B\"\2\u0163\u0165\3\2\2\2\u0164\u0155\3\2\2\2\u0164"+
		"\u015a\3\2\2\2\u0164\u015e\3\2\2\2\u0165\u016e\3\2\2\2\u0166\u0167\f\6"+
		"\2\2\u0167\u0168\7$\2\2\u0168\u016d\5F$\7\u0169\u016a\f\5\2\2\u016a\u016b"+
		"\7%\2\2\u016b\u016d\5F$\6\u016c\u0166\3\2\2\2\u016c\u0169\3\2\2\2\u016d"+
		"\u0170\3\2\2\2\u016e\u016c\3\2\2\2\u016e\u016f\3\2\2\2\u016fG\3\2\2\2"+
		"\u0170\u016e\3\2\2\2\u0171\u0173\7\20\2\2\u0172\u0174\5J&\2\u0173\u0172"+
		"\3\2\2\2\u0174\u0175\3\2\2\2\u0175\u0173\3\2\2\2\u0175\u0176\3\2\2\2\u0176"+
		"I\3\2\2\2\u0177\u0178\5L\'\2\u0178\u0179\7\7\2\2\u0179\u017a\t\5\2\2\u017a"+
		"\u017b\7\4\2\2\u017bK\3\2\2\2\u017c\u017d\t\6\2\2\u017dM\3\2\2\2,SV`e"+
		"kosx\u0091\u0095\u009e\u00a5\u00ad\u00b4\u00c7\u00cf\u00d7\u00db\u00df"+
		"\u00e3\u00e7\u00ed\u00f1\u0100\u0104\u0108\u010c\u0111\u0115\u0119\u011f"+
		"\u0125\u0129\u012d\u013a\u014b\u0150\u0153\u0164\u016c\u016e\u0175";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}