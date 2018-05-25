// Generated from Model.g4 by ANTLR 4.4

package dartagnan;
import dartagnan.wmm.*;

import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class ModelParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__14=1, T__13=2, T__12=3, T__11=4, T__10=5, T__9=6, T__8=7, T__7=8, T__6=9, 
		T__5=10, T__4=11, T__3=12, T__2=13, T__1=14, T__0=15, PO=16, POLOC=17, 
		RFE=18, RFI=19, RF=20, FR=21, FRE=22, FRI=23, CO=24, COE=25, COI=26, AD=27, 
		IDD=28, ISH=29, CD=30, STHD=31, SLOC=32, MFENCE=33, LWSYNC=34, CTRLISYNC=35, 
		ISYNC=36, SYNC=37, CTRLDIREKT=38, CTRLISB=39, CTRL=40, ISB=41, ADDR=42, 
		DATA=43, ID=44, RW=45, WR=46, RR=47, WW=48, RM=49, WM=50, MR=51, MW=52, 
		MM=53, IR=54, IW=55, IM=56, EMPTY=57, NAME=58, MCMNAME=59, WS=60, ENDE=61, 
		ML_COMMENT=62, INCLUDE=63, MODELNAME=64;
	public static final String[] tokenNames = {
		"<INVALID>", "'as'", "'irreflexive'", "'\\'", "';'", "'acyclic'", "'|'", 
		"'='", "'let'", "'&'", "'('", "')'", "'*'", "'rec'", "'and'", "'+'", "'po'", 
		"'po-loc'", "'rfe'", "'rfi'", "'rf'", "'fr'", "'fre'", "'fri'", "'co'", 
		"'coe'", "'coi'", "'ad'", "'idd'", "'ish'", "'cd'", "'sthd'", "'sloc'", 
		"'mfence'", "'lwsync'", "'ctrlisync'", "'isync'", "'sync'", "'ctrlDirect'", 
		"'ctrlisb'", "'ctrl'", "'isb'", "'addr'", "'data'", "'id'", "'R*W'", "'W*R'", 
		"'R*R'", "'W*W'", "'R*M'", "'W*M'", "'M*R'", "'M*W'", "'M*M'", "'I*R'", 
		"'I*W'", "'I*M'", "'0'", "NAME", "MCMNAME", "WS", "ENDE", "ML_COMMENT", 
		"INCLUDE", "MODELNAME"
	};
	public static final int
		RULE_mcm = 0, RULE_axiom = 1, RULE_reldef = 2, RULE_fancyrel = 3, RULE_relation = 4, 
		RULE_base = 5;
	public static final String[] ruleNames = {
		"mcm", "axiom", "reldef", "fancyrel", "relation", "base"
	};

	@Override
	public String getGrammarFileName() { return "Model.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }


	String test="test";

	public ModelParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class McmContext extends ParserRuleContext {
		public Wmm value;
		public AxiomContext ax1;
		public ReldefContext r1;
		public List<AxiomContext> axiom() {
			return getRuleContexts(AxiomContext.class);
		}
		public TerminalNode MCMNAME() { return getToken(ModelParser.MCMNAME, 0); }
		public AxiomContext axiom(int i) {
			return getRuleContext(AxiomContext.class,i);
		}
		public ReldefContext reldef(int i) {
			return getRuleContext(ReldefContext.class,i);
		}
		public List<ReldefContext> reldef() {
			return getRuleContexts(ReldefContext.class);
		}
		public McmContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_mcm; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).enterMcm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).exitMcm(this);
		}
	}

	public final McmContext mcm() throws RecognitionException {
		McmContext _localctx = new McmContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_mcm);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			((McmContext)_localctx).value =   new Wmm();
			setState(14);
			_la = _input.LA(1);
			if (_la==MCMNAME) {
				{
				setState(13); match(MCMNAME);
				}
			}

			setState(22); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				setState(22);
				switch (_input.LA(1)) {
				case T__13:
				case T__10:
					{
					setState(16); ((McmContext)_localctx).ax1 = axiom();
					_localctx.value.addAxiom(((McmContext)_localctx).ax1.value);
					}
					break;
				case T__7:
				case T__1:
					{
					setState(19); ((McmContext)_localctx).r1 = reldef();
					_localctx.value.addRel(((McmContext)_localctx).r1.value);
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				}
				setState(24); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__10) | (1L << T__7) | (1L << T__1))) != 0) );
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

	public static class AxiomContext extends ParserRuleContext {
		public Axiom value;
		public FancyrelContext m1;
		public TerminalNode NAME() { return getToken(ModelParser.NAME, 0); }
		public FancyrelContext fancyrel() {
			return getRuleContext(FancyrelContext.class,0);
		}
		public AxiomContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_axiom; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).enterAxiom(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).exitAxiom(this);
		}
	}

	public final AxiomContext axiom() throws RecognitionException {
		AxiomContext _localctx = new AxiomContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_axiom);
		int _la;
		try {
			setState(40);
			switch (_input.LA(1)) {
			case T__10:
				enterOuterAlt(_localctx, 1);
				{
				setState(26); match(T__10);
				setState(27); ((AxiomContext)_localctx).m1 = fancyrel();
				((AxiomContext)_localctx).value =   new Acyclic(((AxiomContext)_localctx).m1.value);
				setState(31);
				_la = _input.LA(1);
				if (_la==T__14) {
					{
					setState(29); match(T__14);
					setState(30); match(NAME);
					}
				}

				}
				break;
			case T__13:
				enterOuterAlt(_localctx, 2);
				{
				setState(33); match(T__13);
				setState(34); ((AxiomContext)_localctx).m1 = fancyrel();
				((AxiomContext)_localctx).value =   new Irreflexive(((AxiomContext)_localctx).m1.value);
				setState(38);
				_la = _input.LA(1);
				if (_la==T__14) {
					{
					setState(36); match(T__14);
					setState(37); match(NAME);
					}
				}

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

	public static class ReldefContext extends ParserRuleContext {
		public Relation value;
		public Token n;
		public FancyrelContext m1;
		public TerminalNode NAME() { return getToken(ModelParser.NAME, 0); }
		public FancyrelContext fancyrel() {
			return getRuleContext(FancyrelContext.class,0);
		}
		public ReldefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_reldef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).enterReldef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).exitReldef(this);
		}
	}

	public final ReldefContext reldef() throws RecognitionException {
		ReldefContext _localctx = new ReldefContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_reldef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(42);
			_la = _input.LA(1);
			if ( !(_la==T__7 || _la==T__1) ) {
			_errHandler.recoverInline(this);
			}
			consume();
			setState(44);
			_la = _input.LA(1);
			if (_la==T__2) {
				{
				setState(43); match(T__2);
				}
			}

			setState(46); ((ReldefContext)_localctx).n = match(NAME);
			setState(47); match(T__8);
			setState(48); ((ReldefContext)_localctx).m1 = fancyrel();
			((ReldefContext)_localctx).value = ((ReldefContext)_localctx).m1.value; _localctx.value.setName((((ReldefContext)_localctx).n!=null?((ReldefContext)_localctx).n.getText():null));
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

	public static class FancyrelContext extends ParserRuleContext {
		public Relation value;
		public RelationContext m1;
		public RelationContext m2;
		public List<RelationContext> relation() {
			return getRuleContexts(RelationContext.class);
		}
		public RelationContext relation(int i) {
			return getRuleContext(RelationContext.class,i);
		}
		public FancyrelContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fancyrel; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).enterFancyrel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).exitFancyrel(this);
		}
	}

	public final FancyrelContext fancyrel() throws RecognitionException {
		FancyrelContext _localctx = new FancyrelContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_fancyrel);
		int _la;
		try {
			setState(84);
			switch ( getInterpreter().adaptivePredict(_input,10,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(51); ((FancyrelContext)_localctx).m1 = relation(0);
				((FancyrelContext)_localctx).value = ((FancyrelContext)_localctx).m1.value;
				setState(59);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__9) {
					{
					{
					setState(53); match(T__9);
					setState(54); ((FancyrelContext)_localctx).m2 = relation(0);
					((FancyrelContext)_localctx).value = new RelUnion(_localctx.value, ((FancyrelContext)_localctx).m2.value);
					}
					}
					setState(61);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(62); ((FancyrelContext)_localctx).m1 = relation(0);
				((FancyrelContext)_localctx).value = ((FancyrelContext)_localctx).m1.value;
				setState(70);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__6) {
					{
					{
					setState(64); match(T__6);
					setState(65); ((FancyrelContext)_localctx).m2 = relation(0);
					((FancyrelContext)_localctx).value = new RelInterSect(_localctx.value, ((FancyrelContext)_localctx).m2.value);
					}
					}
					setState(72);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(73); ((FancyrelContext)_localctx).m1 = relation(0);
				((FancyrelContext)_localctx).value = ((FancyrelContext)_localctx).m1.value;
				setState(81);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__11) {
					{
					{
					setState(75); match(T__11);
					setState(76); ((FancyrelContext)_localctx).m2 = relation(0);
					((FancyrelContext)_localctx).value = new RelComposition(_localctx.value, ((FancyrelContext)_localctx).m2.value);
					}
					}
					setState(83);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
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

	public static class RelationContext extends ParserRuleContext {
		public Relation value;
		public RelationContext m1;
		public BaseContext b1;
		public RelationContext m2;
		public RelationContext m3;
		public BaseContext base() {
			return getRuleContext(BaseContext.class,0);
		}
		public List<RelationContext> relation() {
			return getRuleContexts(RelationContext.class);
		}
		public RelationContext relation(int i) {
			return getRuleContext(RelationContext.class,i);
		}
		public RelationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_relation; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).enterRelation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).exitRelation(this);
		}
	}

	public final RelationContext relation() throws RecognitionException {
		return relation(0);
	}

	private RelationContext relation(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		RelationContext _localctx = new RelationContext(_ctx, _parentState);
		RelationContext _prevctx = _localctx;
		int _startState = 8;
		enterRecursionRule(_localctx, 8, RULE_relation, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(140);
			switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
			case 1:
				{
				setState(87); ((RelationContext)_localctx).b1 = base();
				((RelationContext)_localctx).value = ((RelationContext)_localctx).b1.value;
				}
				break;
			case 2:
				{
				setState(90); match(T__5);
				{
				setState(91); ((RelationContext)_localctx).m1 = relation(0);
				setState(92); match(T__9);
				((RelationContext)_localctx).value = ((RelationContext)_localctx).m1.value;
				}
				setState(101);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(95); ((RelationContext)_localctx).m2 = relation(0);
						setState(96); match(T__9);
						((RelationContext)_localctx).value = new RelUnion(_localctx.value, ((RelationContext)_localctx).m2.value);
						}
						} 
					}
					setState(103);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
				}
				setState(104); ((RelationContext)_localctx).m3 = relation(0);
				setState(105); match(T__4);
				((RelationContext)_localctx).value = new RelUnion(_localctx.value, ((RelationContext)_localctx).m3.value);
				}
				break;
			case 3:
				{
				setState(108); match(T__5);
				setState(109); ((RelationContext)_localctx).m1 = relation(0);
				setState(110); match(T__12);
				setState(111); ((RelationContext)_localctx).m2 = relation(0);
				setState(112); match(T__4);
				((RelationContext)_localctx).value = new RelMinus(((RelationContext)_localctx).m1.value, ((RelationContext)_localctx).m2.value);
				}
				break;
			case 4:
				{
				setState(115); match(T__5);
				setState(116); ((RelationContext)_localctx).m1 = relation(0);
				setState(117); match(T__6);
				setState(118); ((RelationContext)_localctx).m2 = relation(0);
				setState(119); match(T__4);
				((RelationContext)_localctx).value = new RelInterSect(((RelationContext)_localctx).m1.value, ((RelationContext)_localctx).m2.value);
				}
				break;
			case 5:
				{
				setState(122); match(T__5);
				{
				setState(123); ((RelationContext)_localctx).m1 = relation(0);
				setState(124); match(T__11);
				((RelationContext)_localctx).value = ((RelationContext)_localctx).m1.value;
				}
				setState(133);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,12,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(127); ((RelationContext)_localctx).m2 = relation(0);
						setState(128); match(T__11);
						((RelationContext)_localctx).value = new RelComposition(_localctx.value, ((RelationContext)_localctx).m2.value);
						}
						} 
					}
					setState(135);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,12,_ctx);
				}
				setState(136); ((RelationContext)_localctx).m3 = relation(0);
				setState(137); match(T__4);
				((RelationContext)_localctx).value = new RelComposition(_localctx.value, ((RelationContext)_localctx).m3.value);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(150);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(148);
					switch ( getInterpreter().adaptivePredict(_input,14,_ctx) ) {
					case 1:
						{
						_localctx = new RelationContext(_parentctx, _parentState);
						_localctx.m1 = _prevctx;
						pushNewRecursionContext(_localctx, _startState, RULE_relation);
						setState(142);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(143); match(T__0);
						((RelationContext)_localctx).value = new RelTrans(((RelationContext)_localctx).m1.value);
						}
						break;
					case 2:
						{
						_localctx = new RelationContext(_parentctx, _parentState);
						_localctx.m1 = _prevctx;
						pushNewRecursionContext(_localctx, _startState, RULE_relation);
						setState(145);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(146); match(T__3);
						((RelationContext)_localctx).value = new RelTransRef(((RelationContext)_localctx).m1.value);
						}
						break;
					}
					} 
				}
				setState(152);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
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

	public static class BaseContext extends ParserRuleContext {
		public Relation value;
		public Token n;
		public TerminalNode POLOC() { return getToken(ModelParser.POLOC, 0); }
		public TerminalNode FR() { return getToken(ModelParser.FR, 0); }
		public TerminalNode FRE() { return getToken(ModelParser.FRE, 0); }
		public TerminalNode CTRLISYNC() { return getToken(ModelParser.CTRLISYNC, 0); }
		public TerminalNode WM() { return getToken(ModelParser.WM, 0); }
		public TerminalNode ISB() { return getToken(ModelParser.ISB, 0); }
		public TerminalNode IDD() { return getToken(ModelParser.IDD, 0); }
		public TerminalNode IW() { return getToken(ModelParser.IW, 0); }
		public TerminalNode IR() { return getToken(ModelParser.IR, 0); }
		public TerminalNode IM() { return getToken(ModelParser.IM, 0); }
		public TerminalNode WR() { return getToken(ModelParser.WR, 0); }
		public TerminalNode MW() { return getToken(ModelParser.MW, 0); }
		public TerminalNode LWSYNC() { return getToken(ModelParser.LWSYNC, 0); }
		public TerminalNode MR() { return getToken(ModelParser.MR, 0); }
		public TerminalNode RF() { return getToken(ModelParser.RF, 0); }
		public TerminalNode ID() { return getToken(ModelParser.ID, 0); }
		public TerminalNode MFENCE() { return getToken(ModelParser.MFENCE, 0); }
		public TerminalNode NAME() { return getToken(ModelParser.NAME, 0); }
		public TerminalNode ISYNC() { return getToken(ModelParser.ISYNC, 0); }
		public TerminalNode COI() { return getToken(ModelParser.COI, 0); }
		public TerminalNode AD() { return getToken(ModelParser.AD, 0); }
		public TerminalNode CD() { return getToken(ModelParser.CD, 0); }
		public TerminalNode RW() { return getToken(ModelParser.RW, 0); }
		public TerminalNode RFE() { return getToken(ModelParser.RFE, 0); }
		public TerminalNode WW() { return getToken(ModelParser.WW, 0); }
		public TerminalNode CO() { return getToken(ModelParser.CO, 0); }
		public TerminalNode PO() { return getToken(ModelParser.PO, 0); }
		public TerminalNode MM() { return getToken(ModelParser.MM, 0); }
		public TerminalNode DATA() { return getToken(ModelParser.DATA, 0); }
		public TerminalNode RFI() { return getToken(ModelParser.RFI, 0); }
		public TerminalNode CTRLISB() { return getToken(ModelParser.CTRLISB, 0); }
		public TerminalNode SYNC() { return getToken(ModelParser.SYNC, 0); }
		public TerminalNode COE() { return getToken(ModelParser.COE, 0); }
		public TerminalNode CTRL() { return getToken(ModelParser.CTRL, 0); }
		public TerminalNode RR() { return getToken(ModelParser.RR, 0); }
		public TerminalNode RM() { return getToken(ModelParser.RM, 0); }
		public TerminalNode CTRLDIREKT() { return getToken(ModelParser.CTRLDIREKT, 0); }
		public TerminalNode SLOC() { return getToken(ModelParser.SLOC, 0); }
		public TerminalNode ADDR() { return getToken(ModelParser.ADDR, 0); }
		public TerminalNode EMPTY() { return getToken(ModelParser.EMPTY, 0); }
		public TerminalNode FRI() { return getToken(ModelParser.FRI, 0); }
		public TerminalNode ISH() { return getToken(ModelParser.ISH, 0); }
		public TerminalNode STHD() { return getToken(ModelParser.STHD, 0); }
		public BaseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_base; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).enterBase(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ModelListener ) ((ModelListener)listener).exitBase(this);
		}
	}

	public final BaseContext base() throws RecognitionException {
		BaseContext _localctx = new BaseContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_base);
		try {
			setState(239);
			switch (_input.LA(1)) {
			case PO:
				enterOuterAlt(_localctx, 1);
				{
				setState(153); match(PO);
				((BaseContext)_localctx).value = new BasicRelation("po");
				}
				break;
			case POLOC:
				enterOuterAlt(_localctx, 2);
				{
				setState(155); match(POLOC);
				((BaseContext)_localctx).value = new BasicRelation("poloc");
				}
				break;
			case RFE:
				enterOuterAlt(_localctx, 3);
				{
				setState(157); match(RFE);
				((BaseContext)_localctx).value = new BasicRelation("rfe");
				}
				break;
			case RFI:
				enterOuterAlt(_localctx, 4);
				{
				setState(159); match(RFI);
				((BaseContext)_localctx).value = new BasicRelation("rfi");
				}
				break;
			case RF:
				enterOuterAlt(_localctx, 5);
				{
				setState(161); match(RF);
				((BaseContext)_localctx).value = new BasicRelation("rf");
				}
				break;
			case FR:
				enterOuterAlt(_localctx, 6);
				{
				setState(163); match(FR);
				((BaseContext)_localctx).value = new BasicRelation("fr");
				}
				break;
			case FRI:
				enterOuterAlt(_localctx, 7);
				{
				setState(165); match(FRI);
				((BaseContext)_localctx).value = new BasicRelation("fri");
				}
				break;
			case FRE:
				enterOuterAlt(_localctx, 8);
				{
				setState(167); match(FRE);
				((BaseContext)_localctx).value = new BasicRelation("fre");
				}
				break;
			case CO:
				enterOuterAlt(_localctx, 9);
				{
				setState(169); match(CO);
				((BaseContext)_localctx).value = new BasicRelation("co");
				}
				break;
			case COE:
				enterOuterAlt(_localctx, 10);
				{
				setState(171); match(COE);
				((BaseContext)_localctx).value = new BasicRelation("coe");
				}
				break;
			case COI:
				enterOuterAlt(_localctx, 11);
				{
				setState(173); match(COI);
				((BaseContext)_localctx).value = new BasicRelation("coi");
				}
				break;
			case AD:
				enterOuterAlt(_localctx, 12);
				{
				setState(175); match(AD);
				((BaseContext)_localctx).value = new BasicRelation("po");
				}
				break;
			case IDD:
				enterOuterAlt(_localctx, 13);
				{
				setState(177); match(IDD);
				((BaseContext)_localctx).value = new BasicRelation("idd");
				}
				break;
			case ISH:
				enterOuterAlt(_localctx, 14);
				{
				setState(179); match(ISH);
				((BaseContext)_localctx).value = new BasicRelation("ish");
				}
				break;
			case CD:
				enterOuterAlt(_localctx, 15);
				{
				setState(181); match(CD);
				((BaseContext)_localctx).value = new BasicRelation("cd");
				}
				break;
			case STHD:
				enterOuterAlt(_localctx, 16);
				{
				setState(183); match(STHD);
				((BaseContext)_localctx).value = new BasicRelation("sthd");
				}
				break;
			case SLOC:
				enterOuterAlt(_localctx, 17);
				{
				setState(185); match(SLOC);
				((BaseContext)_localctx).value = new BasicRelation("sloc");
				}
				break;
			case MFENCE:
				enterOuterAlt(_localctx, 18);
				{
				setState(187); match(MFENCE);
				((BaseContext)_localctx).value = new BasicRelation("mfence");
				}
				break;
			case CTRLISYNC:
				enterOuterAlt(_localctx, 19);
				{
				setState(189); match(CTRLISYNC);
				((BaseContext)_localctx).value = new BasicRelation("ctrlisync");
				}
				break;
			case LWSYNC:
				enterOuterAlt(_localctx, 20);
				{
				setState(191); match(LWSYNC);
				((BaseContext)_localctx).value = new BasicRelation("lwsync");
				}
				break;
			case ISYNC:
				enterOuterAlt(_localctx, 21);
				{
				setState(193); match(ISYNC);
				((BaseContext)_localctx).value = new BasicRelation("isync");
				}
				break;
			case SYNC:
				enterOuterAlt(_localctx, 22);
				{
				setState(195); match(SYNC);
				((BaseContext)_localctx).value = new BasicRelation("sync");
				}
				break;
			case CTRLDIREKT:
				enterOuterAlt(_localctx, 23);
				{
				setState(197); match(CTRLDIREKT);
				((BaseContext)_localctx).value = new BasicRelation("ctrlDirect");
				}
				break;
			case CTRLISB:
				enterOuterAlt(_localctx, 24);
				{
				setState(199); match(CTRLISB);
				((BaseContext)_localctx).value = new BasicRelation("ctrlisb");
				}
				break;
			case CTRL:
				enterOuterAlt(_localctx, 25);
				{
				setState(201); match(CTRL);
				((BaseContext)_localctx).value = new BasicRelation("ctrl");
				}
				break;
			case ISB:
				enterOuterAlt(_localctx, 26);
				{
				setState(203); match(ISB);
				((BaseContext)_localctx).value = new BasicRelation("isb");
				}
				break;
			case ADDR:
				enterOuterAlt(_localctx, 27);
				{
				setState(205); match(ADDR);
				((BaseContext)_localctx).value = new EmptyRel();
				}
				break;
			case DATA:
				enterOuterAlt(_localctx, 28);
				{
				setState(207); match(DATA);
				((BaseContext)_localctx).value = new RelInterSect(new RelLocTrans(new BasicRelation("idd")), new BasicRelation("RW"));
				}
				break;
			case NAME:
				enterOuterAlt(_localctx, 29);
				{
				setState(209); ((BaseContext)_localctx).n = match(NAME);
				((BaseContext)_localctx).value = new RelDummy((((BaseContext)_localctx).n!=null?((BaseContext)_localctx).n.getText():null));
				}
				break;
			case EMPTY:
				enterOuterAlt(_localctx, 30);
				{
				setState(211); match(EMPTY);
				((BaseContext)_localctx).value = new EmptyRel();
				}
				break;
			case RW:
				enterOuterAlt(_localctx, 31);
				{
				setState(213); match(RW);
				((BaseContext)_localctx).value = new BasicRelation("RW");
				}
				break;
			case WR:
				enterOuterAlt(_localctx, 32);
				{
				setState(215); match(WR);
				((BaseContext)_localctx).value = new BasicRelation("WR");
				}
				break;
			case RR:
				enterOuterAlt(_localctx, 33);
				{
				setState(217); match(RR);
				((BaseContext)_localctx).value = new BasicRelation("RR");
				}
				break;
			case WW:
				enterOuterAlt(_localctx, 34);
				{
				setState(219); match(WW);
				((BaseContext)_localctx).value = new BasicRelation("WW");
				}
				break;
			case RM:
				enterOuterAlt(_localctx, 35);
				{
				setState(221); match(RM);
				((BaseContext)_localctx).value = new BasicRelation("RM");
				}
				break;
			case WM:
				enterOuterAlt(_localctx, 36);
				{
				setState(223); match(WM);
				((BaseContext)_localctx).value = new BasicRelation("WM");
				}
				break;
			case MR:
				enterOuterAlt(_localctx, 37);
				{
				setState(225); match(MR);
				((BaseContext)_localctx).value = new BasicRelation("MR");
				}
				break;
			case MW:
				enterOuterAlt(_localctx, 38);
				{
				setState(227); match(MW);
				((BaseContext)_localctx).value = new BasicRelation("MW");
				}
				break;
			case MM:
				enterOuterAlt(_localctx, 39);
				{
				setState(229); match(MM);
				((BaseContext)_localctx).value = new BasicRelation("MM");
				}
				break;
			case IR:
				enterOuterAlt(_localctx, 40);
				{
				setState(231); match(IR);
				((BaseContext)_localctx).value = new BasicRelation("IR");
				}
				break;
			case IW:
				enterOuterAlt(_localctx, 41);
				{
				setState(233); match(IW);
				((BaseContext)_localctx).value = new BasicRelation("IW");
				}
				break;
			case IM:
				enterOuterAlt(_localctx, 42);
				{
				setState(235); match(IM);
				((BaseContext)_localctx).value = new BasicRelation("IM");
				}
				break;
			case ID:
				enterOuterAlt(_localctx, 43);
				{
				setState(237); match(ID);
				((BaseContext)_localctx).value = new BasicRelation("id");
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

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 4: return relation_sempred((RelationContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean relation_sempred(RelationContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0: return precpred(_ctx, 2);
		case 1: return precpred(_ctx, 1);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\3B\u00f4\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\3\2\3\2\5\2\21\n\2\3\2\3\2\3\2"+
		"\3\2\3\2\3\2\6\2\31\n\2\r\2\16\2\32\3\3\3\3\3\3\3\3\3\3\5\3\"\n\3\3\3"+
		"\3\3\3\3\3\3\3\3\5\3)\n\3\5\3+\n\3\3\4\3\4\5\4/\n\4\3\4\3\4\3\4\3\4\3"+
		"\4\3\5\3\5\3\5\3\5\3\5\3\5\7\5<\n\5\f\5\16\5?\13\5\3\5\3\5\3\5\3\5\3\5"+
		"\3\5\7\5G\n\5\f\5\16\5J\13\5\3\5\3\5\3\5\3\5\3\5\3\5\7\5R\n\5\f\5\16\5"+
		"U\13\5\5\5W\n\5\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\7"+
		"\6f\n\6\f\6\16\6i\13\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6"+
		"\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\7\6\u0086"+
		"\n\6\f\6\16\6\u0089\13\6\3\6\3\6\3\6\3\6\5\6\u008f\n\6\3\6\3\6\3\6\3\6"+
		"\3\6\3\6\7\6\u0097\n\6\f\6\16\6\u009a\13\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3"+
		"\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3"+
		"\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7\u00f2\n\7\3\7\2\3\n\b\2\4\6\b"+
		"\n\f\2\3\4\2\n\n\20\20\u012b\2\16\3\2\2\2\4*\3\2\2\2\6,\3\2\2\2\bV\3\2"+
		"\2\2\n\u008e\3\2\2\2\f\u00f1\3\2\2\2\16\20\b\2\1\2\17\21\7=\2\2\20\17"+
		"\3\2\2\2\20\21\3\2\2\2\21\30\3\2\2\2\22\23\5\4\3\2\23\24\b\2\1\2\24\31"+
		"\3\2\2\2\25\26\5\6\4\2\26\27\b\2\1\2\27\31\3\2\2\2\30\22\3\2\2\2\30\25"+
		"\3\2\2\2\31\32\3\2\2\2\32\30\3\2\2\2\32\33\3\2\2\2\33\3\3\2\2\2\34\35"+
		"\7\7\2\2\35\36\5\b\5\2\36!\b\3\1\2\37 \7\3\2\2 \"\7<\2\2!\37\3\2\2\2!"+
		"\"\3\2\2\2\"+\3\2\2\2#$\7\4\2\2$%\5\b\5\2%(\b\3\1\2&\'\7\3\2\2\')\7<\2"+
		"\2(&\3\2\2\2()\3\2\2\2)+\3\2\2\2*\34\3\2\2\2*#\3\2\2\2+\5\3\2\2\2,.\t"+
		"\2\2\2-/\7\17\2\2.-\3\2\2\2./\3\2\2\2/\60\3\2\2\2\60\61\7<\2\2\61\62\7"+
		"\t\2\2\62\63\5\b\5\2\63\64\b\4\1\2\64\7\3\2\2\2\65\66\5\n\6\2\66=\b\5"+
		"\1\2\678\7\b\2\289\5\n\6\29:\b\5\1\2:<\3\2\2\2;\67\3\2\2\2<?\3\2\2\2="+
		";\3\2\2\2=>\3\2\2\2>W\3\2\2\2?=\3\2\2\2@A\5\n\6\2AH\b\5\1\2BC\7\13\2\2"+
		"CD\5\n\6\2DE\b\5\1\2EG\3\2\2\2FB\3\2\2\2GJ\3\2\2\2HF\3\2\2\2HI\3\2\2\2"+
		"IW\3\2\2\2JH\3\2\2\2KL\5\n\6\2LS\b\5\1\2MN\7\6\2\2NO\5\n\6\2OP\b\5\1\2"+
		"PR\3\2\2\2QM\3\2\2\2RU\3\2\2\2SQ\3\2\2\2ST\3\2\2\2TW\3\2\2\2US\3\2\2\2"+
		"V\65\3\2\2\2V@\3\2\2\2VK\3\2\2\2W\t\3\2\2\2XY\b\6\1\2YZ\5\f\7\2Z[\b\6"+
		"\1\2[\u008f\3\2\2\2\\]\7\f\2\2]^\5\n\6\2^_\7\b\2\2_`\b\6\1\2`g\3\2\2\2"+
		"ab\5\n\6\2bc\7\b\2\2cd\b\6\1\2df\3\2\2\2ea\3\2\2\2fi\3\2\2\2ge\3\2\2\2"+
		"gh\3\2\2\2hj\3\2\2\2ig\3\2\2\2jk\5\n\6\2kl\7\r\2\2lm\b\6\1\2m\u008f\3"+
		"\2\2\2no\7\f\2\2op\5\n\6\2pq\7\5\2\2qr\5\n\6\2rs\7\r\2\2st\b\6\1\2t\u008f"+
		"\3\2\2\2uv\7\f\2\2vw\5\n\6\2wx\7\13\2\2xy\5\n\6\2yz\7\r\2\2z{\b\6\1\2"+
		"{\u008f\3\2\2\2|}\7\f\2\2}~\5\n\6\2~\177\7\6\2\2\177\u0080\b\6\1\2\u0080"+
		"\u0087\3\2\2\2\u0081\u0082\5\n\6\2\u0082\u0083\7\6\2\2\u0083\u0084\b\6"+
		"\1\2\u0084\u0086\3\2\2\2\u0085\u0081\3\2\2\2\u0086\u0089\3\2\2\2\u0087"+
		"\u0085\3\2\2\2\u0087\u0088\3\2\2\2\u0088\u008a\3\2\2\2\u0089\u0087\3\2"+
		"\2\2\u008a\u008b\5\n\6\2\u008b\u008c\7\r\2\2\u008c\u008d\b\6\1\2\u008d"+
		"\u008f\3\2\2\2\u008eX\3\2\2\2\u008e\\\3\2\2\2\u008en\3\2\2\2\u008eu\3"+
		"\2\2\2\u008e|\3\2\2\2\u008f\u0098\3\2\2\2\u0090\u0091\f\4\2\2\u0091\u0092"+
		"\7\21\2\2\u0092\u0097\b\6\1\2\u0093\u0094\f\3\2\2\u0094\u0095\7\16\2\2"+
		"\u0095\u0097\b\6\1\2\u0096\u0090\3\2\2\2\u0096\u0093\3\2\2\2\u0097\u009a"+
		"\3\2\2\2\u0098\u0096\3\2\2\2\u0098\u0099\3\2\2\2\u0099\13\3\2\2\2\u009a"+
		"\u0098\3\2\2\2\u009b\u009c\7\22\2\2\u009c\u00f2\b\7\1\2\u009d\u009e\7"+
		"\23\2\2\u009e\u00f2\b\7\1\2\u009f\u00a0\7\24\2\2\u00a0\u00f2\b\7\1\2\u00a1"+
		"\u00a2\7\25\2\2\u00a2\u00f2\b\7\1\2\u00a3\u00a4\7\26\2\2\u00a4\u00f2\b"+
		"\7\1\2\u00a5\u00a6\7\27\2\2\u00a6\u00f2\b\7\1\2\u00a7\u00a8\7\31\2\2\u00a8"+
		"\u00f2\b\7\1\2\u00a9\u00aa\7\30\2\2\u00aa\u00f2\b\7\1\2\u00ab\u00ac\7"+
		"\32\2\2\u00ac\u00f2\b\7\1\2\u00ad\u00ae\7\33\2\2\u00ae\u00f2\b\7\1\2\u00af"+
		"\u00b0\7\34\2\2\u00b0\u00f2\b\7\1\2\u00b1\u00b2\7\35\2\2\u00b2\u00f2\b"+
		"\7\1\2\u00b3\u00b4\7\36\2\2\u00b4\u00f2\b\7\1\2\u00b5\u00b6\7\37\2\2\u00b6"+
		"\u00f2\b\7\1\2\u00b7\u00b8\7 \2\2\u00b8\u00f2\b\7\1\2\u00b9\u00ba\7!\2"+
		"\2\u00ba\u00f2\b\7\1\2\u00bb\u00bc\7\"\2\2\u00bc\u00f2\b\7\1\2\u00bd\u00be"+
		"\7#\2\2\u00be\u00f2\b\7\1\2\u00bf\u00c0\7%\2\2\u00c0\u00f2\b\7\1\2\u00c1"+
		"\u00c2\7$\2\2\u00c2\u00f2\b\7\1\2\u00c3\u00c4\7&\2\2\u00c4\u00f2\b\7\1"+
		"\2\u00c5\u00c6\7\'\2\2\u00c6\u00f2\b\7\1\2\u00c7\u00c8\7(\2\2\u00c8\u00f2"+
		"\b\7\1\2\u00c9\u00ca\7)\2\2\u00ca\u00f2\b\7\1\2\u00cb\u00cc\7*\2\2\u00cc"+
		"\u00f2\b\7\1\2\u00cd\u00ce\7+\2\2\u00ce\u00f2\b\7\1\2\u00cf\u00d0\7,\2"+
		"\2\u00d0\u00f2\b\7\1\2\u00d1\u00d2\7-\2\2\u00d2\u00f2\b\7\1\2\u00d3\u00d4"+
		"\7<\2\2\u00d4\u00f2\b\7\1\2\u00d5\u00d6\7;\2\2\u00d6\u00f2\b\7\1\2\u00d7"+
		"\u00d8\7/\2\2\u00d8\u00f2\b\7\1\2\u00d9\u00da\7\60\2\2\u00da\u00f2\b\7"+
		"\1\2\u00db\u00dc\7\61\2\2\u00dc\u00f2\b\7\1\2\u00dd\u00de\7\62\2\2\u00de"+
		"\u00f2\b\7\1\2\u00df\u00e0\7\63\2\2\u00e0\u00f2\b\7\1\2\u00e1\u00e2\7"+
		"\64\2\2\u00e2\u00f2\b\7\1\2\u00e3\u00e4\7\65\2\2\u00e4\u00f2\b\7\1\2\u00e5"+
		"\u00e6\7\66\2\2\u00e6\u00f2\b\7\1\2\u00e7\u00e8\7\67\2\2\u00e8\u00f2\b"+
		"\7\1\2\u00e9\u00ea\78\2\2\u00ea\u00f2\b\7\1\2\u00eb\u00ec\79\2\2\u00ec"+
		"\u00f2\b\7\1\2\u00ed\u00ee\7:\2\2\u00ee\u00f2\b\7\1\2\u00ef\u00f0\7.\2"+
		"\2\u00f0\u00f2\b\7\1\2\u00f1\u009b\3\2\2\2\u00f1\u009d\3\2\2\2\u00f1\u009f"+
		"\3\2\2\2\u00f1\u00a1\3\2\2\2\u00f1\u00a3\3\2\2\2\u00f1\u00a5\3\2\2\2\u00f1"+
		"\u00a7\3\2\2\2\u00f1\u00a9\3\2\2\2\u00f1\u00ab\3\2\2\2\u00f1\u00ad\3\2"+
		"\2\2\u00f1\u00af\3\2\2\2\u00f1\u00b1\3\2\2\2\u00f1\u00b3\3\2\2\2\u00f1"+
		"\u00b5\3\2\2\2\u00f1\u00b7\3\2\2\2\u00f1\u00b9\3\2\2\2\u00f1\u00bb\3\2"+
		"\2\2\u00f1\u00bd\3\2\2\2\u00f1\u00bf\3\2\2\2\u00f1\u00c1\3\2\2\2\u00f1"+
		"\u00c3\3\2\2\2\u00f1\u00c5\3\2\2\2\u00f1\u00c7\3\2\2\2\u00f1\u00c9\3\2"+
		"\2\2\u00f1\u00cb\3\2\2\2\u00f1\u00cd\3\2\2\2\u00f1\u00cf\3\2\2\2\u00f1"+
		"\u00d1\3\2\2\2\u00f1\u00d3\3\2\2\2\u00f1\u00d5\3\2\2\2\u00f1\u00d7\3\2"+
		"\2\2\u00f1\u00d9\3\2\2\2\u00f1\u00db\3\2\2\2\u00f1\u00dd\3\2\2\2\u00f1"+
		"\u00df\3\2\2\2\u00f1\u00e1\3\2\2\2\u00f1\u00e3\3\2\2\2\u00f1\u00e5\3\2"+
		"\2\2\u00f1\u00e7\3\2\2\2\u00f1\u00e9\3\2\2\2\u00f1\u00eb\3\2\2\2\u00f1"+
		"\u00ed\3\2\2\2\u00f1\u00ef\3\2\2\2\u00f2\r\3\2\2\2\23\20\30\32!(*.=HS"+
		"Vg\u0087\u008e\u0096\u0098\u00f1";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}