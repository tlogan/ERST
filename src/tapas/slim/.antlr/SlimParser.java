// Generated from /Users/thomas/tlogan@github.com/ERST/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset


import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue"})
public class SlimParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.13.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, ID=33, INT=34, WS=35;
	public static final int
		RULE_ids = 0, RULE_preamble = 1, RULE_program = 2, RULE_typ_base = 3, 
		RULE_typ = 4, RULE_negchain = 5, RULE_qualification = 6, RULE_subtyping = 7, 
		RULE_expr = 8, RULE_base = 9, RULE_record = 10, RULE_function = 11, RULE_keychain = 12, 
		RULE_argchain = 13, RULE_pipeline = 14, RULE_target = 15, RULE_pattern = 16, 
		RULE_base_pattern = 17, RULE_record_pattern = 18;
	private static String[] makeRuleNames() {
		return new String[] {
			"ids", "preamble", "program", "typ_base", "typ", "negchain", "qualification", 
			"subtyping", "expr", "base", "record", "function", "keychain", "argchain", 
			"pipeline", "target", "pattern", "base_pattern", "record_pattern"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'alias'", "'='", "'TOP'", "'BOT'", "'@'", "'<'", "'>'", "'('", 
			"')'", "'|'", "'&'", "'->'", "'*'", "'EXI'", "'['", "']'", "'ALL'", "'LFP'", 
			"'\\'", "':'", "'<:'", "','", "'if'", "'then'", "'else'", "'def'", "'in'", 
			"'loop'", "';'", "'=>'", "'.'", "'|>'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, "ID", "INT", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
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
	public String getGrammarFileName() { return "Slim.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }



	_solver : Solver 
	_cache : dict[int, str] = {}

	_guidance : Guidance 
	_overflow = False  
	_light_mode : bool  

	_syntax_rules : PSet[SyntaxRule] = s() 

	def init(self, light_mode = False): 
	    self._cache = {}
	    self._guidance = [default_context]
	    self._overflow = False  
	    self._light_mode = light_mode  

	def reset(self): 
	    self._guidance = [default_context]
	    self._overflow = False
	    # self.getCurrentToken()
	    # self.getTokenStream()

	def filter(self, i, rs):
	    return [
	        r
	        for r in rs  
	        if r.pid == i
	    ]


	def get_syntax_rules(self):
	    return self._syntax_rules

	def update_sr(self, head : str, body : list[Union[Nonterm, Termin]]):
	    rule = SyntaxRule(head, tuple(body))
	    self._syntax_rules = self._syntax_rules.add(rule)

	def getGuidance(self):
	    return self._guidance

	def getSolver(self):
	    return self._solver

	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex



	public SlimParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@SuppressWarnings("CheckReturnValue")
	public static class IdsContext extends ParserRuleContext {
		public tuple[str, ...] combo;
		public Token ID;
		public IdsContext ids;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public IdsContext ids() {
			return getRuleContext(IdsContext.class,0);
		}
		public IdsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_ids; }
	}

	public final IdsContext ids() throws RecognitionException {
		IdsContext _localctx = new IdsContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_ids);
		try {
			setState(45);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(39);
				((IdsContext)_localctx).ID = match(ID);

				_localctx.combo = tuple([(((IdsContext)_localctx).ID!=null?((IdsContext)_localctx).ID.getText():null)])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(41);
				((IdsContext)_localctx).ID = match(ID);
				setState(42);
				((IdsContext)_localctx).ids = ids();

				_localctx.combo = tuple([(((IdsContext)_localctx).ID!=null?((IdsContext)_localctx).ID.getText():null)]) + ((IdsContext)_localctx).ids.combo

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

	@SuppressWarnings("CheckReturnValue")
	public static class PreambleContext extends ParserRuleContext {
		public PMap[str, Typ] aliasing;
		public Token ID;
		public TypContext typ;
		public PreambleContext preamble;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
		}
		public PreambleContext preamble() {
			return getRuleContext(PreambleContext.class,0);
		}
		public PreambleContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_preamble; }
	}

	public final PreambleContext preamble() throws RecognitionException {
		PreambleContext _localctx = new PreambleContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_preamble);
		try {
			setState(61);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(48);
				match(T__0);
				setState(49);
				((PreambleContext)_localctx).ID = match(ID);
				setState(50);
				match(T__1);
				setState(51);
				((PreambleContext)_localctx).typ = typ();

				_localctx.aliasing = m().set((((PreambleContext)_localctx).ID!=null?((PreambleContext)_localctx).ID.getText():null), ((PreambleContext)_localctx).typ.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(54);
				match(T__0);
				setState(55);
				((PreambleContext)_localctx).ID = match(ID);
				setState(56);
				match(T__1);
				setState(57);
				((PreambleContext)_localctx).typ = typ();
				setState(58);
				((PreambleContext)_localctx).preamble = preamble();

				_localctx.aliasing = ((PreambleContext)_localctx).preamble.aliasing.set((((PreambleContext)_localctx).ID!=null?((PreambleContext)_localctx).ID.getText():null), ((PreambleContext)_localctx).typ.combo)

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

	@SuppressWarnings("CheckReturnValue")
	public static class ProgramContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[Result] results;
		public PreambleContext preamble;
		public ExprContext expr;
		public PreambleContext preamble() {
			return getRuleContext(PreambleContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ProgramContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_program; }
	}

	public final ProgramContext program(list[Context] contexts) throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState(), contexts);
		enterRule(_localctx, 4, RULE_program);
		try {
			setState(72);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(64);
				((ProgramContext)_localctx).preamble = preamble();

				self._solver = Solver(((ProgramContext)_localctx).preamble.aliasing if ((ProgramContext)_localctx).preamble.aliasing else m())

				setState(66);
				((ProgramContext)_localctx).expr = expr(contexts);

				_localctx.results = ((ProgramContext)_localctx).expr.results

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(69);
				((ProgramContext)_localctx).expr = expr(contexts);

				self._solver = Solver(m())
				_localctx.results = ((ProgramContext)_localctx).expr.results

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

	@SuppressWarnings("CheckReturnValue")
	public static class Typ_baseContext extends ParserRuleContext {
		public Typ combo;
		public Token ID;
		public Typ_baseContext typ_base;
		public TypContext typ;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public Typ_baseContext typ_base() {
			return getRuleContext(Typ_baseContext.class,0);
		}
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
		}
		public Typ_baseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typ_base; }
	}

	public final Typ_baseContext typ_base() throws RecognitionException {
		Typ_baseContext _localctx = new Typ_baseContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_typ_base);
		try {
			setState(94);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(75);
				match(T__2);

				_localctx.combo = Top() 

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(77);
				match(T__3);

				_localctx.combo = Bot() 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(79);
				((Typ_baseContext)_localctx).ID = match(ID);

				_localctx.combo = TVar((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null)) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(81);
				match(T__4);

				_localctx.combo = TUnit() 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(83);
				match(T__5);
				setState(84);
				((Typ_baseContext)_localctx).ID = match(ID);
				setState(85);
				match(T__6);
				setState(86);
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TEntry((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(89);
				match(T__7);
				setState(90);
				((Typ_baseContext)_localctx).typ = typ();
				setState(91);
				match(T__8);

				_localctx.combo = ((Typ_baseContext)_localctx).typ.combo   

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

	@SuppressWarnings("CheckReturnValue")
	public static class TypContext extends ParserRuleContext {
		public Typ combo;
		public Typ_baseContext typ_base;
		public TypContext typ;
		public Typ_baseContext context;
		public NegchainContext acc;
		public IdsContext ids;
		public QualificationContext qualification;
		public Token ID;
		public Typ_baseContext typ_base() {
			return getRuleContext(Typ_baseContext.class,0);
		}
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
		}
		public NegchainContext negchain() {
			return getRuleContext(NegchainContext.class,0);
		}
		public IdsContext ids() {
			return getRuleContext(IdsContext.class,0);
		}
		public QualificationContext qualification() {
			return getRuleContext(QualificationContext.class,0);
		}
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public TypContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typ; }
	}

	public final TypContext typ() throws RecognitionException {
		TypContext _localctx = new TypContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_typ);
		try {
			setState(180);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(97);
				((TypContext)_localctx).typ_base = typ_base();

				_localctx.combo = ((TypContext)_localctx).typ_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(100);
				((TypContext)_localctx).typ_base = typ_base();
				setState(101);
				match(T__9);
				setState(102);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Unio(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(105);
				((TypContext)_localctx).typ_base = typ_base();
				setState(106);
				match(T__10);
				setState(107);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(110);
				((TypContext)_localctx).context = typ_base();
				setState(111);
				((TypContext)_localctx).acc = negchain(((TypContext)_localctx).context.combo);

				_localctx.combo = ((TypContext)_localctx).acc.combo 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(114);
				((TypContext)_localctx).typ_base = typ_base();
				setState(115);
				match(T__11);
				setState(116);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Imp(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(119);
				((TypContext)_localctx).typ_base = typ_base();
				setState(120);
				match(T__12);
				setState(121);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(TEntry('head', ((TypContext)_localctx).typ_base.combo), TEntry('tail', ((TypContext)_localctx).typ.combo)) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(124);
				match(T__13);
				setState(125);
				match(T__14);
				setState(126);
				match(T__15);
				setState(127);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi((), (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(130);
				match(T__13);
				setState(131);
				match(T__14);
				setState(132);
				((TypContext)_localctx).ids = ids();
				setState(133);
				match(T__15);
				setState(134);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi(((TypContext)_localctx).ids.combo, (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(137);
				match(T__13);
				setState(138);
				match(T__14);
				setState(139);
				((TypContext)_localctx).ids = ids();
				setState(140);
				match(T__15);
				setState(141);
				((TypContext)_localctx).qualification = qualification();
				setState(142);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(145);
				match(T__16);
				setState(146);
				match(T__14);
				setState(147);
				match(T__15);
				setState(148);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All((), (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(151);
				match(T__16);
				setState(152);
				match(T__14);
				setState(153);
				((TypContext)_localctx).ids = ids();
				setState(154);
				match(T__15);
				setState(155);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All(((TypContext)_localctx).ids.combo, (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(158);
				match(T__16);
				setState(159);
				match(T__14);
				setState(160);
				((TypContext)_localctx).ids = ids();
				setState(161);
				match(T__15);
				setState(162);
				((TypContext)_localctx).qualification = qualification();
				setState(163);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 14:
				enterOuterAlt(_localctx, 14);
				{
				setState(166);
				match(T__16);
				setState(167);
				match(T__14);
				setState(168);
				match(T__15);
				setState(169);
				((TypContext)_localctx).qualification = qualification();
				setState(170);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All((), ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 15:
				enterOuterAlt(_localctx, 15);
				{
				setState(173);
				match(T__17);
				setState(174);
				match(T__14);
				setState(175);
				((TypContext)_localctx).ID = match(ID);
				setState(176);
				match(T__15);
				setState(177);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = LeastFP((((TypContext)_localctx).ID!=null?((TypContext)_localctx).ID.getText():null), ((TypContext)_localctx).typ.combo) 

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

	@SuppressWarnings("CheckReturnValue")
	public static class NegchainContext extends ParserRuleContext {
		public Typ context;
		public Diff combo;
		public TypContext negation;
		public NegchainContext tail;
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
		}
		public NegchainContext negchain() {
			return getRuleContext(NegchainContext.class,0);
		}
		public NegchainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public NegchainContext(ParserRuleContext parent, int invokingState, Typ context) {
			super(parent, invokingState);
			this.context = context;
		}
		@Override public int getRuleIndex() { return RULE_negchain; }
	}

	public final NegchainContext negchain(Typ context) throws RecognitionException {
		NegchainContext _localctx = new NegchainContext(_ctx, getState(), context);
		enterRule(_localctx, 10, RULE_negchain);
		try {
			setState(193);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(183);
				match(T__18);
				setState(184);
				((NegchainContext)_localctx).negation = typ();

				_localctx.combo = Diff(context, ((NegchainContext)_localctx).negation.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(187);
				match(T__18);
				setState(188);
				((NegchainContext)_localctx).negation = typ();

				context_tail = Diff(context, ((NegchainContext)_localctx).negation.combo)

				setState(190);
				((NegchainContext)_localctx).tail = negchain(context_tail);

				_localctx.combo = Diff(context, ((NegchainContext)_localctx).negation.combo)

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

	@SuppressWarnings("CheckReturnValue")
	public static class QualificationContext extends ParserRuleContext {
		public tuple[Subtyping, ...] combo;
		public SubtypingContext subtyping;
		public QualificationContext qualification;
		public SubtypingContext subtyping() {
			return getRuleContext(SubtypingContext.class,0);
		}
		public QualificationContext qualification() {
			return getRuleContext(QualificationContext.class,0);
		}
		public QualificationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualification; }
	}

	public final QualificationContext qualification() throws RecognitionException {
		QualificationContext _localctx = new QualificationContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_qualification);
		try {
			setState(204);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(196);
				match(T__19);

				_localctx.combo = tuple([])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(198);
				match(T__7);
				setState(199);
				((QualificationContext)_localctx).subtyping = subtyping();
				setState(200);
				match(T__8);
				setState(201);
				((QualificationContext)_localctx).qualification = qualification();

				_localctx.combo = tuple([((QualificationContext)_localctx).subtyping.combo]) + ((QualificationContext)_localctx).qualification.combo

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

	@SuppressWarnings("CheckReturnValue")
	public static class SubtypingContext extends ParserRuleContext {
		public Subtyping combo;
		public TypContext strong;
		public TypContext weak;
		public List<TypContext> typ() {
			return getRuleContexts(TypContext.class);
		}
		public TypContext typ(int i) {
			return getRuleContext(TypContext.class,i);
		}
		public SubtypingContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_subtyping; }
	}

	public final SubtypingContext subtyping() throws RecognitionException {
		SubtypingContext _localctx = new SubtypingContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_subtyping);
		try {
			setState(212);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__8:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__7:
			case T__9:
			case T__10:
			case T__11:
			case T__12:
			case T__13:
			case T__16:
			case T__17:
			case T__18:
			case T__20:
			case ID:
				enterOuterAlt(_localctx, 2);
				{
				setState(207);
				((SubtypingContext)_localctx).strong = typ();
				setState(208);
				match(T__20);
				setState(209);
				((SubtypingContext)_localctx).weak = typ();

				_localctx.combo = Subtyping(((SubtypingContext)_localctx).strong.combo, ((SubtypingContext)_localctx).weak.combo)

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

	@SuppressWarnings("CheckReturnValue")
	public static class ExprContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[Result] results;
		public BaseContext base;
		public BaseContext head;
		public ExprContext tail;
		public ExprContext condition;
		public ExprContext true_branch;
		public ExprContext false_branch;
		public BaseContext rator;
		public KeychainContext keychain;
		public BaseContext cator;
		public ArgchainContext argchain;
		public BaseContext arg;
		public PipelineContext pipeline;
		public Token ID;
		public TargetContext target;
		public ExprContext contin;
		public ExprContext body;
		public BaseContext base() {
			return getRuleContext(BaseContext.class,0);
		}
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public ArgchainContext argchain() {
			return getRuleContext(ArgchainContext.class,0);
		}
		public PipelineContext pipeline() {
			return getRuleContext(PipelineContext.class,0);
		}
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public TargetContext target() {
			return getRuleContext(TargetContext.class,0);
		}
		public ExprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ExprContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(list[Context] contexts) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), contexts);
		enterRule(_localctx, 16, RULE_expr);
		try {
			setState(261);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(215);
				((ExprContext)_localctx).base = base(contexts);

				_localctx.results = ((ExprContext)_localctx).base.results

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(218);
				((ExprContext)_localctx).head = base(contexts);
				setState(219);
				match(T__21);

				tail_contexts = [
				    Context(contexts[head_result.pid].enviro, head_result.world)
				    for head_result in ((ExprContext)_localctx).head.results 
				] 

				setState(221);
				((ExprContext)_localctx).tail = expr(tail_contexts);

				_localctx.results = [
				    ExprRule(self._solver).combine_tuple(
				        pid, 
				        tail_result.world, 
				        head_result.typ, 
				        tail_result.typ
				    ) 
				    for tail_result in ((ExprContext)_localctx).tail.results 
				    for head_result in [((ExprContext)_localctx).head.results[tail_result.pid]]
				    for pid in [head_result.pid]
				]

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(224);
				match(T__22);
				setState(225);
				((ExprContext)_localctx).condition = expr(contexts);
				setState(226);
				match(T__23);

				branch_contexts = [
				    Context(contexts[conditionr.pid].enviro, conditionr.world)
				    for conditionr in ((ExprContext)_localctx).condition.results
				]

				setState(228);
				((ExprContext)_localctx).true_branch = expr(branch_contexts);
				setState(229);
				match(T__24);
				setState(230);
				((ExprContext)_localctx).false_branch = expr(branch_contexts);

				_localctx.results = [
				    result
				    for condition_id, condition_result in enumerate(((ExprContext)_localctx).condition.results)
				    for true_branch_results in [self.filter(condition_id, ((ExprContext)_localctx).true_branch.results)]
				    for false_branch_results in [self.filter(condition_id, ((ExprContext)_localctx).false_branch.results)]
				    for pid in [condition_result.pid]
				    for result in ExprRule(self._solver).combine_ite(
				        pid,  
				        contexts[pid].enviro,
				        condition_result.world,
				        condition_result.typ,
				        true_branch_results,
				        false_branch_results,
				    )
				]

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(233);
				((ExprContext)_localctx).rator = base(contexts);
				setState(234);
				((ExprContext)_localctx).keychain = keychain();

				_localctx.results = [
				    result
				    for rator_result in ((ExprContext)_localctx).rator.results
				    for pid in [rator_result.pid]
				    for result in ExprRule(self._solver).combine_projection(
				        pid,
				        rator_result.world,
				        rator_result.typ,
				        ((ExprContext)_localctx).keychain.keys
				    ) 
				]

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(237);
				((ExprContext)_localctx).cator = base(contexts);

				argchain_contexts = [
				    Context(contexts[cator_result.pid].enviro, cator_result.world)
				    for cator_result in ((ExprContext)_localctx).cator.results 
				]

				setState(239);
				((ExprContext)_localctx).argchain = argchain(argchain_contexts);

				_localctx.results = [
				    result 
				    for argchain_result in ((ExprContext)_localctx).argchain.results
				    for cator_result in [((ExprContext)_localctx).cator.results[argchain_result.pid]]
				    for pid in [cator_result.pid]
				    for result in ExprRule(self._solver).combine_application(
				        pid,
				        argchain_result.world,
				        cator_result.typ,
				        argchain_result.typs,
				    )
				]

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(242);
				((ExprContext)_localctx).arg = base(contexts);

				pipeline_contexts = [
				    Context(contexts[arg_result.pid].enviro, arg_result.world)
				    for arg_result in ((ExprContext)_localctx).arg.results 
				]

				setState(244);
				((ExprContext)_localctx).pipeline = pipeline(pipeline_contexts);

				_localctx.results = [
				    result
				    for pipeline_result in ((ExprContext)_localctx).pipeline.results 
				    for arg_result in [((ExprContext)_localctx).arg.results[pipeline_result.pid]]
				    for pid in [arg_result.pid]
				    for result in ExprRule(self._solver).combine_funnel(
				        pid,
				        pipeline_result.world,
				        arg_result.typ,
				        pipeline_result.typs
				    )
				]

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(247);
				match(T__25);
				setState(248);
				((ExprContext)_localctx).ID = match(ID);
				setState(249);
				((ExprContext)_localctx).target = target(contexts);
				setState(250);
				match(T__26);

				contin_contexts = [
				    Context(enviro, world)
				    for target_result in ((ExprContext)_localctx).target.results
				    for enviro in [contexts[target_result.pid].enviro.set((((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), target_result.typ)]
				    for world in [target_result.world]
				]

				setState(252);
				((ExprContext)_localctx).contin = expr(contin_contexts);

				_localctx.results = [
				    Result(pid, contin_result.world, contin_result.typ)
				    for contin_result in ((ExprContext)_localctx).contin.results
				    for target_result in [((ExprContext)_localctx).target.results[contin_result.pid]]
				    for pid in [target_result.pid]
				]

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(255);
				match(T__27);
				setState(256);
				match(T__7);
				setState(257);
				((ExprContext)_localctx).body = expr(contexts);
				setState(258);
				match(T__8);

				_localctx.results = [
				    ExprRule(self._solver).combine_fix(
				        pid,
				        contexts[pid].enviro,
				        body_result.world,
				        body_result.typ
				    )
				    for body_result in ((ExprContext)_localctx).body.results 
				    for pid in [body_result.pid]
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class BaseContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[Result] results;
		public Token ID;
		public BaseContext body;
		public RecordContext record;
		public FunctionContext function;
		public ArgchainContext argchain;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public BaseContext base() {
			return getRuleContext(BaseContext.class,0);
		}
		public RecordContext record() {
			return getRuleContext(RecordContext.class,0);
		}
		public FunctionContext function() {
			return getRuleContext(FunctionContext.class,0);
		}
		public ArgchainContext argchain() {
			return getRuleContext(ArgchainContext.class,0);
		}
		public BaseContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public BaseContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_base; }
	}

	public final BaseContext base(list[Context] contexts) throws RecognitionException {
		BaseContext _localctx = new BaseContext(_ctx, getState(), contexts);
		enterRule(_localctx, 18, RULE_base);
		try {
			setState(283);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(264);
				match(T__4);

				_localctx.results = [
				    BaseRule(self._solver).combine_unit(pid, context.world)
				    for pid, context in enumerate(contexts)
				]

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(266);
				((BaseContext)_localctx).ID = match(ID);
				setState(267);
				match(T__28);
				setState(268);
				((BaseContext)_localctx).body = base(contexts);

				_localctx.results = [
				    RecordRule(self._solver).combine_single(pid, body_result.world, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null), body_result.typ)
				    for body_result in ((BaseContext)_localctx).body.results
				    for pid in [body_result.pid]
				]

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(271);
				((BaseContext)_localctx).record = record(contexts);

				_localctx.results = ((BaseContext)_localctx).record.results 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{


				setState(275);
				((BaseContext)_localctx).function = function(contexts);

				_localctx.results = [
				    BaseRule(self._solver).combine_function(pid, contexts[pid].enviro, function_result.world, function_result.branches)
				    for function_result in ((BaseContext)_localctx).function.results
				    for pid in [function_result.pid]
				]

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(278);
				((BaseContext)_localctx).ID = match(ID);

				_localctx.results = [
				    result
				    for pid, context in enumerate(contexts)
				    for result in BaseRule(self._solver).combine_var(pid, context.enviro, context.world, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))
				]

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(280);
				((BaseContext)_localctx).argchain = argchain(contexts);

				_localctx.results = [
				    result
				    for argchain_result in ((BaseContext)_localctx).argchain.results
				    for pid in [argchain_result.pid]
				    for result in BaseRule(self._solver).combine_assoc(pid, argchain_result.world, argchain_result.typs)
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class RecordContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[Result] results;
		public Token ID;
		public BaseContext body;
		public RecordContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public BaseContext base() {
			return getRuleContext(BaseContext.class,0);
		}
		public RecordContext record() {
			return getRuleContext(RecordContext.class,0);
		}
		public RecordContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public RecordContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record(list[Context] contexts) throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState(), contexts);
		enterRule(_localctx, 20, RULE_record);
		try {
			setState(300);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,10,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(286);
				match(T__5);
				setState(287);
				((RecordContext)_localctx).ID = match(ID);
				setState(288);
				match(T__6);
				setState(289);
				((RecordContext)_localctx).body = base(contexts);

				_localctx.results = [
				    RecordRule(self._solver).combine_single(pid, body_result.world, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), body_result.typ)
				    for body_result in ((RecordContext)_localctx).body.results
				    for pid in [body_result.pid]
				]

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(292);
				match(T__5);
				setState(293);
				((RecordContext)_localctx).ID = match(ID);
				setState(294);
				match(T__6);
				setState(295);
				((RecordContext)_localctx).body = base(contexts);

				tail_contexts = [
				    Context(contexts[body_result.pid].enviro, body_result.world)
				    for body_result in ((RecordContext)_localctx).body.results
				]

				setState(297);
				((RecordContext)_localctx).tail = record(tail_contexts);

				_localctx.results = [
				    RecordRule(self._solver).combine_cons(pid, tail_result.world, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), body_result.typ, tail_result.typ) 
				    for tail_result in ((RecordContext)_localctx).tail.results
				    for body_result in [((RecordContext)_localctx).body.results[tail_result.pid]]
				    for pid in [body_result.pid]
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class FunctionContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[Switch] results;
		public PatternContext pattern;
		public ExprContext body;
		public FunctionContext tail;
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public FunctionContext function() {
			return getRuleContext(FunctionContext.class,0);
		}
		public FunctionContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public FunctionContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function(list[Context] contexts) throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState(), contexts);
		enterRule(_localctx, 22, RULE_function);
		try {
			setState(320);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(303);
				match(T__14);
				setState(304);
				((FunctionContext)_localctx).pattern = pattern();
				setState(305);
				match(T__29);

				body_contexts = [
				    Context(context.enviro.update(((FunctionContext)_localctx).pattern.result.enviro), context.world)
				    for context in contexts 
				]

				setState(307);
				((FunctionContext)_localctx).body = expr(body_contexts);
				setState(308);
				match(T__15);

				_localctx.results = [
				    FunctionRule(self._solver).combine_single(pid, context.world, ((FunctionContext)_localctx).pattern.result.typ, body_results)
				    for pid, context in enumerate(contexts)
				    for body_results in [self.filter(pid, ((FunctionContext)_localctx).body.results)]
				]

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(311);
				match(T__14);
				setState(312);
				((FunctionContext)_localctx).pattern = pattern();
				setState(313);
				match(T__29);

				body_contexts = [
				    Context(context.enviro.update(((FunctionContext)_localctx).pattern.result.enviro), context.world)
				    for context in contexts 
				]

				setState(315);
				((FunctionContext)_localctx).body = expr(body_contexts);
				setState(316);
				match(T__15);
				setState(317);
				((FunctionContext)_localctx).tail = function(contexts);

				_localctx.results = [
				    FunctionRule(self._solver).combine_cons(pid, context.world, ((FunctionContext)_localctx).pattern.result.typ, body_results, tail_result)
				    for pid, context in enumerate(contexts)
				    for body_results in [self.filter(pid, ((FunctionContext)_localctx).body.results)]
				    for tail_result in [((FunctionContext)_localctx).tail.results[pid]]
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class KeychainContext extends ParserRuleContext {
		public Keychain keys;
		public Token ID;
		public KeychainContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public KeychainContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_keychain; }
	}

	public final KeychainContext keychain() throws RecognitionException {
		KeychainContext _localctx = new KeychainContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_keychain);
		try {
			setState(332);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(323);
				match(T__30);
				setState(324);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.keys = KeychainRule(self._solver).combine_single((((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(326);
				match(T__30);
				setState(327);
				((KeychainContext)_localctx).ID = match(ID);


				setState(329);
				((KeychainContext)_localctx).tail = keychain();

				_localctx.keys = KeychainRule(self._solver).combine_cons((((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.keys)

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

	@SuppressWarnings("CheckReturnValue")
	public static class ArgchainContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[ArgchainResult] results;
		public ExprContext content;
		public ExprContext head;
		public ArgchainContext tail;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ArgchainContext argchain() {
			return getRuleContext(ArgchainContext.class,0);
		}
		public ArgchainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ArgchainContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_argchain; }
	}

	public final ArgchainContext argchain(list[Context] contexts) throws RecognitionException {
		ArgchainContext _localctx = new ArgchainContext(_ctx, getState(), contexts);
		enterRule(_localctx, 26, RULE_argchain);
		try {
			setState(347);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(335);
				match(T__7);
				setState(336);
				((ArgchainContext)_localctx).content = expr(contexts);
				setState(337);
				match(T__8);

				_localctx.results = [
				    ArgchainRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
				    for content_result in ((ArgchainContext)_localctx).content.results 
				    for pid in [content_result.pid]
				]

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(340);
				match(T__7);
				setState(341);
				((ArgchainContext)_localctx).head = expr(contexts);
				setState(342);
				match(T__8);

				tail_contexts = [
				    Context(contexts[head_result.pid].enviro, head_result.world)
				    for head_result in ((ArgchainContext)_localctx).head.results
				]

				setState(344);
				((ArgchainContext)_localctx).tail = argchain(tail_contexts);

				_localctx.results = [
				    ArgchainRule(self._solver).combine_cons(pid, tail_result.world, head_result.typ, tail_result.typs)
				    for tail_result in ((ArgchainContext)_localctx).tail.results 
				    for head_result in [((ArgchainContext)_localctx).head.results[tail_result.pid]]
				    for pid in [head_result.pid]
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class PipelineContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[PipelineResult] results;
		public ExprContext content;
		public ExprContext head;
		public PipelineContext tail;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public PipelineContext pipeline() {
			return getRuleContext(PipelineContext.class,0);
		}
		public PipelineContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public PipelineContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_pipeline; }
	}

	public final PipelineContext pipeline(list[Context] contexts) throws RecognitionException {
		PipelineContext _localctx = new PipelineContext(_ctx, getState(), contexts);
		enterRule(_localctx, 28, RULE_pipeline);
		try {
			setState(360);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,14,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(350);
				match(T__31);
				setState(351);
				((PipelineContext)_localctx).content = expr(contexts);

				_localctx.results = [
				    PipelineRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
				    for content_result in ((PipelineContext)_localctx).content.results 
				    for pid in [content_result.pid]
				]

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(354);
				match(T__31);
				setState(355);
				((PipelineContext)_localctx).head = expr(contexts);

				tail_contexts = [
				    Context(contexts[head_result.pid].enviro, head_result.world)
				    for head_result in ((PipelineContext)_localctx).head.results
				]

				setState(357);
				((PipelineContext)_localctx).tail = pipeline(tail_contexts);

				_localctx.results = [
				    PipelineRule(self._solver).combine_cons(pid, tail_result.world, head_result.typ, tail_result.typs)
				    for tail_result in ((PipelineContext)_localctx).tail.results 
				    for head_result in [((PipelineContext)_localctx).head.results[tail_result.pid]]
				    for pid in [head_result.pid]
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class TargetContext extends ParserRuleContext {
		public list[Context] contexts;
		public list[Result] results;
		public ExprContext expr;
		public TypContext typ;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
		}
		public TargetContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public TargetContext(ParserRuleContext parent, int invokingState, list[Context] contexts) {
			super(parent, invokingState);
			this.contexts = contexts;
		}
		@Override public int getRuleIndex() { return RULE_target; }
	}

	public final TargetContext target(list[Context] contexts) throws RecognitionException {
		TargetContext _localctx = new TargetContext(_ctx, getState(), contexts);
		enterRule(_localctx, 30, RULE_target);
		try {
			setState(373);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__26:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__1:
				enterOuterAlt(_localctx, 2);
				{
				setState(363);
				match(T__1);
				setState(364);
				((TargetContext)_localctx).expr = expr(contexts);

				_localctx.results = ((TargetContext)_localctx).expr.results

				}
				break;
			case T__19:
				enterOuterAlt(_localctx, 3);
				{
				setState(367);
				match(T__19);
				setState(368);
				((TargetContext)_localctx).typ = typ();
				setState(369);
				match(T__1);
				setState(370);
				((TargetContext)_localctx).expr = expr(contexts);

				_localctx.results = [
				    result
				    for pid, context in enumerate(contexts)
				    for expr_results in [self.filter(pid, ((TargetContext)_localctx).expr.results)]
				    for result in TargetRule(self._solver).combine_anno(
				        pid,
				        context.enviro,
				        context.world,
				        expr_results,
				        ((TargetContext)_localctx).typ.combo
				    )
				]

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

	@SuppressWarnings("CheckReturnValue")
	public static class PatternContext extends ParserRuleContext {
		public PatternResult result;
		public Base_patternContext base_pattern;
		public Base_patternContext head;
		public PatternContext tail;
		public Base_patternContext base_pattern() {
			return getRuleContext(Base_patternContext.class,0);
		}
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public PatternContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
	}

	public final PatternContext pattern() throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_pattern);
		try {
			setState(385);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(376);
				((PatternContext)_localctx).base_pattern = base_pattern();

				_localctx.result = ((PatternContext)_localctx).base_pattern.result

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{


				setState(380);
				((PatternContext)_localctx).head = base_pattern();
				setState(381);
				match(T__21);
				setState(382);
				((PatternContext)_localctx).tail = pattern();

				_localctx.result = PatternRule(self._solver).combine_tuple(((PatternContext)_localctx).head.result, ((PatternContext)_localctx).tail.result)

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

	@SuppressWarnings("CheckReturnValue")
	public static class Base_patternContext extends ParserRuleContext {
		public PatternResult result;
		public Token ID;
		public PatternContext body;
		public Record_patternContext record_pattern;
		public PatternContext pattern;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public Record_patternContext record_pattern() {
			return getRuleContext(Record_patternContext.class,0);
		}
		public Base_patternContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_base_pattern; }
	}

	public final Base_patternContext base_pattern() throws RecognitionException {
		Base_patternContext _localctx = new Base_patternContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_base_pattern);
		try {
			setState(405);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(388);
				((Base_patternContext)_localctx).ID = match(ID);

				_localctx.result = BasePatternRule(self._solver).combine_var((((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(390);
				match(T__4);

				_localctx.result = BasePatternRule(self._solver).combine_unit()

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(392);
				((Base_patternContext)_localctx).ID = match(ID);
				setState(393);
				match(T__28);
				setState(394);
				((Base_patternContext)_localctx).body = pattern();

				_localctx.result = RecordPatternRule(self._solver, self._light_mode).combine_single((((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null), ((Base_patternContext)_localctx).body.result)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(397);
				((Base_patternContext)_localctx).record_pattern = record_pattern();

				_localctx.result = ((Base_patternContext)_localctx).record_pattern.result

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(400);
				match(T__7);
				setState(401);
				((Base_patternContext)_localctx).pattern = pattern();
				setState(402);
				match(T__8);

				_localctx.result = ((Base_patternContext)_localctx).pattern.result

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

	@SuppressWarnings("CheckReturnValue")
	public static class Record_patternContext extends ParserRuleContext {
		public PatternResult result;
		public Token ID;
		public PatternContext body;
		public Record_patternContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public Record_patternContext record_pattern() {
			return getRuleContext(Record_patternContext.class,0);
		}
		public Record_patternContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_record_pattern; }
	}

	public final Record_patternContext record_pattern() throws RecognitionException {
		Record_patternContext _localctx = new Record_patternContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_record_pattern);
		try {
			setState(421);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,18,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(408);
				match(T__5);
				setState(409);
				((Record_patternContext)_localctx).ID = match(ID);
				setState(410);
				match(T__6);
				setState(411);
				((Record_patternContext)_localctx).body = pattern();

				_localctx.result = RecordPatternRule(self._solver, self._light_mode).combine_single((((Record_patternContext)_localctx).ID!=null?((Record_patternContext)_localctx).ID.getText():null), ((Record_patternContext)_localctx).body.result)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(414);
				match(T__5);
				setState(415);
				((Record_patternContext)_localctx).ID = match(ID);
				setState(416);
				match(T__6);
				setState(417);
				((Record_patternContext)_localctx).body = pattern();
				setState(418);
				((Record_patternContext)_localctx).tail = record_pattern();

				_localctx.result = RecordPatternRule(self._solver).combine_cons((((Record_patternContext)_localctx).ID!=null?((Record_patternContext)_localctx).ID.getText():null), ((Record_patternContext)_localctx).body.result, ((Record_patternContext)_localctx).tail.result)

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

	public static final String _serializedATN =
		"\u0004\u0001#\u01a8\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004\u0002"+
		"\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007\u0002"+
		"\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b\u0007\u000b\u0002"+
		"\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0002\u000f\u0007\u000f"+
		"\u0002\u0010\u0007\u0010\u0002\u0011\u0007\u0011\u0002\u0012\u0007\u0012"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0003\u0000.\b\u0000\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0003\u0001"+
		">\b\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0003\u0002I\b\u0002"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0003\u0003_\b\u0003\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0003\u0004\u00b5\b\u0004"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0003\u0005"+
		"\u00c2\b\u0005\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0003\u0006\u00cd\b\u0006"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0003\u0007\u00d5\b\u0007\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0003\b\u0106\b\b\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0003\t\u011c\b\t\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0003"+
		"\n\u012d\b\n\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0003\u000b\u0141\b\u000b\u0001\f\u0001\f\u0001\f\u0001\f"+
		"\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0003\f\u014d\b\f\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0003\r\u015c\b\r\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0003\u000e\u0169\b\u000e\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0003\u000f\u0176\b\u000f\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0003\u0010\u0182\b\u0010\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0003"+
		"\u0011\u0196\b\u0011\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001"+
		"\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001"+
		"\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0003\u0012\u01a6\b\u0012\u0001"+
		"\u0012\u0000\u0000\u0013\u0000\u0002\u0004\u0006\b\n\f\u000e\u0010\u0012"+
		"\u0014\u0016\u0018\u001a\u001c\u001e \"$\u0000\u0000\u01d6\u0000-\u0001"+
		"\u0000\u0000\u0000\u0002=\u0001\u0000\u0000\u0000\u0004H\u0001\u0000\u0000"+
		"\u0000\u0006^\u0001\u0000\u0000\u0000\b\u00b4\u0001\u0000\u0000\u0000"+
		"\n\u00c1\u0001\u0000\u0000\u0000\f\u00cc\u0001\u0000\u0000\u0000\u000e"+
		"\u00d4\u0001\u0000\u0000\u0000\u0010\u0105\u0001\u0000\u0000\u0000\u0012"+
		"\u011b\u0001\u0000\u0000\u0000\u0014\u012c\u0001\u0000\u0000\u0000\u0016"+
		"\u0140\u0001\u0000\u0000\u0000\u0018\u014c\u0001\u0000\u0000\u0000\u001a"+
		"\u015b\u0001\u0000\u0000\u0000\u001c\u0168\u0001\u0000\u0000\u0000\u001e"+
		"\u0175\u0001\u0000\u0000\u0000 \u0181\u0001\u0000\u0000\u0000\"\u0195"+
		"\u0001\u0000\u0000\u0000$\u01a5\u0001\u0000\u0000\u0000&.\u0001\u0000"+
		"\u0000\u0000\'(\u0005!\u0000\u0000(.\u0006\u0000\uffff\uffff\u0000)*\u0005"+
		"!\u0000\u0000*+\u0003\u0000\u0000\u0000+,\u0006\u0000\uffff\uffff\u0000"+
		",.\u0001\u0000\u0000\u0000-&\u0001\u0000\u0000\u0000-\'\u0001\u0000\u0000"+
		"\u0000-)\u0001\u0000\u0000\u0000.\u0001\u0001\u0000\u0000\u0000/>\u0001"+
		"\u0000\u0000\u000001\u0005\u0001\u0000\u000012\u0005!\u0000\u000023\u0005"+
		"\u0002\u0000\u000034\u0003\b\u0004\u000045\u0006\u0001\uffff\uffff\u0000"+
		"5>\u0001\u0000\u0000\u000067\u0005\u0001\u0000\u000078\u0005!\u0000\u0000"+
		"89\u0005\u0002\u0000\u00009:\u0003\b\u0004\u0000:;\u0003\u0002\u0001\u0000"+
		";<\u0006\u0001\uffff\uffff\u0000<>\u0001\u0000\u0000\u0000=/\u0001\u0000"+
		"\u0000\u0000=0\u0001\u0000\u0000\u0000=6\u0001\u0000\u0000\u0000>\u0003"+
		"\u0001\u0000\u0000\u0000?I\u0001\u0000\u0000\u0000@A\u0003\u0002\u0001"+
		"\u0000AB\u0006\u0002\uffff\uffff\u0000BC\u0003\u0010\b\u0000CD\u0006\u0002"+
		"\uffff\uffff\u0000DI\u0001\u0000\u0000\u0000EF\u0003\u0010\b\u0000FG\u0006"+
		"\u0002\uffff\uffff\u0000GI\u0001\u0000\u0000\u0000H?\u0001\u0000\u0000"+
		"\u0000H@\u0001\u0000\u0000\u0000HE\u0001\u0000\u0000\u0000I\u0005\u0001"+
		"\u0000\u0000\u0000J_\u0001\u0000\u0000\u0000KL\u0005\u0003\u0000\u0000"+
		"L_\u0006\u0003\uffff\uffff\u0000MN\u0005\u0004\u0000\u0000N_\u0006\u0003"+
		"\uffff\uffff\u0000OP\u0005!\u0000\u0000P_\u0006\u0003\uffff\uffff\u0000"+
		"QR\u0005\u0005\u0000\u0000R_\u0006\u0003\uffff\uffff\u0000ST\u0005\u0006"+
		"\u0000\u0000TU\u0005!\u0000\u0000UV\u0005\u0007\u0000\u0000VW\u0003\u0006"+
		"\u0003\u0000WX\u0006\u0003\uffff\uffff\u0000X_\u0001\u0000\u0000\u0000"+
		"YZ\u0005\b\u0000\u0000Z[\u0003\b\u0004\u0000[\\\u0005\t\u0000\u0000\\"+
		"]\u0006\u0003\uffff\uffff\u0000]_\u0001\u0000\u0000\u0000^J\u0001\u0000"+
		"\u0000\u0000^K\u0001\u0000\u0000\u0000^M\u0001\u0000\u0000\u0000^O\u0001"+
		"\u0000\u0000\u0000^Q\u0001\u0000\u0000\u0000^S\u0001\u0000\u0000\u0000"+
		"^Y\u0001\u0000\u0000\u0000_\u0007\u0001\u0000\u0000\u0000`\u00b5\u0001"+
		"\u0000\u0000\u0000ab\u0003\u0006\u0003\u0000bc\u0006\u0004\uffff\uffff"+
		"\u0000c\u00b5\u0001\u0000\u0000\u0000de\u0003\u0006\u0003\u0000ef\u0005"+
		"\n\u0000\u0000fg\u0003\b\u0004\u0000gh\u0006\u0004\uffff\uffff\u0000h"+
		"\u00b5\u0001\u0000\u0000\u0000ij\u0003\u0006\u0003\u0000jk\u0005\u000b"+
		"\u0000\u0000kl\u0003\b\u0004\u0000lm\u0006\u0004\uffff\uffff\u0000m\u00b5"+
		"\u0001\u0000\u0000\u0000no\u0003\u0006\u0003\u0000op\u0003\n\u0005\u0000"+
		"pq\u0006\u0004\uffff\uffff\u0000q\u00b5\u0001\u0000\u0000\u0000rs\u0003"+
		"\u0006\u0003\u0000st\u0005\f\u0000\u0000tu\u0003\b\u0004\u0000uv\u0006"+
		"\u0004\uffff\uffff\u0000v\u00b5\u0001\u0000\u0000\u0000wx\u0003\u0006"+
		"\u0003\u0000xy\u0005\r\u0000\u0000yz\u0003\b\u0004\u0000z{\u0006\u0004"+
		"\uffff\uffff\u0000{\u00b5\u0001\u0000\u0000\u0000|}\u0005\u000e\u0000"+
		"\u0000}~\u0005\u000f\u0000\u0000~\u007f\u0005\u0010\u0000\u0000\u007f"+
		"\u0080\u0003\b\u0004\u0000\u0080\u0081\u0006\u0004\uffff\uffff\u0000\u0081"+
		"\u00b5\u0001\u0000\u0000\u0000\u0082\u0083\u0005\u000e\u0000\u0000\u0083"+
		"\u0084\u0005\u000f\u0000\u0000\u0084\u0085\u0003\u0000\u0000\u0000\u0085"+
		"\u0086\u0005\u0010\u0000\u0000\u0086\u0087\u0003\b\u0004\u0000\u0087\u0088"+
		"\u0006\u0004\uffff\uffff\u0000\u0088\u00b5\u0001\u0000\u0000\u0000\u0089"+
		"\u008a\u0005\u000e\u0000\u0000\u008a\u008b\u0005\u000f\u0000\u0000\u008b"+
		"\u008c\u0003\u0000\u0000\u0000\u008c\u008d\u0005\u0010\u0000\u0000\u008d"+
		"\u008e\u0003\f\u0006\u0000\u008e\u008f\u0003\b\u0004\u0000\u008f\u0090"+
		"\u0006\u0004\uffff\uffff\u0000\u0090\u00b5\u0001\u0000\u0000\u0000\u0091"+
		"\u0092\u0005\u0011\u0000\u0000\u0092\u0093\u0005\u000f\u0000\u0000\u0093"+
		"\u0094\u0005\u0010\u0000\u0000\u0094\u0095\u0003\b\u0004\u0000\u0095\u0096"+
		"\u0006\u0004\uffff\uffff\u0000\u0096\u00b5\u0001\u0000\u0000\u0000\u0097"+
		"\u0098\u0005\u0011\u0000\u0000\u0098\u0099\u0005\u000f\u0000\u0000\u0099"+
		"\u009a\u0003\u0000\u0000\u0000\u009a\u009b\u0005\u0010\u0000\u0000\u009b"+
		"\u009c\u0003\b\u0004\u0000\u009c\u009d\u0006\u0004\uffff\uffff\u0000\u009d"+
		"\u00b5\u0001\u0000\u0000\u0000\u009e\u009f\u0005\u0011\u0000\u0000\u009f"+
		"\u00a0\u0005\u000f\u0000\u0000\u00a0\u00a1\u0003\u0000\u0000\u0000\u00a1"+
		"\u00a2\u0005\u0010\u0000\u0000\u00a2\u00a3\u0003\f\u0006\u0000\u00a3\u00a4"+
		"\u0003\b\u0004\u0000\u00a4\u00a5\u0006\u0004\uffff\uffff\u0000\u00a5\u00b5"+
		"\u0001\u0000\u0000\u0000\u00a6\u00a7\u0005\u0011\u0000\u0000\u00a7\u00a8"+
		"\u0005\u000f\u0000\u0000\u00a8\u00a9\u0005\u0010\u0000\u0000\u00a9\u00aa"+
		"\u0003\f\u0006\u0000\u00aa\u00ab\u0003\b\u0004\u0000\u00ab\u00ac\u0006"+
		"\u0004\uffff\uffff\u0000\u00ac\u00b5\u0001\u0000\u0000\u0000\u00ad\u00ae"+
		"\u0005\u0012\u0000\u0000\u00ae\u00af\u0005\u000f\u0000\u0000\u00af\u00b0"+
		"\u0005!\u0000\u0000\u00b0\u00b1\u0005\u0010\u0000\u0000\u00b1\u00b2\u0003"+
		"\b\u0004\u0000\u00b2\u00b3\u0006\u0004\uffff\uffff\u0000\u00b3\u00b5\u0001"+
		"\u0000\u0000\u0000\u00b4`\u0001\u0000\u0000\u0000\u00b4a\u0001\u0000\u0000"+
		"\u0000\u00b4d\u0001\u0000\u0000\u0000\u00b4i\u0001\u0000\u0000\u0000\u00b4"+
		"n\u0001\u0000\u0000\u0000\u00b4r\u0001\u0000\u0000\u0000\u00b4w\u0001"+
		"\u0000\u0000\u0000\u00b4|\u0001\u0000\u0000\u0000\u00b4\u0082\u0001\u0000"+
		"\u0000\u0000\u00b4\u0089\u0001\u0000\u0000\u0000\u00b4\u0091\u0001\u0000"+
		"\u0000\u0000\u00b4\u0097\u0001\u0000\u0000\u0000\u00b4\u009e\u0001\u0000"+
		"\u0000\u0000\u00b4\u00a6\u0001\u0000\u0000\u0000\u00b4\u00ad\u0001\u0000"+
		"\u0000\u0000\u00b5\t\u0001\u0000\u0000\u0000\u00b6\u00c2\u0001\u0000\u0000"+
		"\u0000\u00b7\u00b8\u0005\u0013\u0000\u0000\u00b8\u00b9\u0003\b\u0004\u0000"+
		"\u00b9\u00ba\u0006\u0005\uffff\uffff\u0000\u00ba\u00c2\u0001\u0000\u0000"+
		"\u0000\u00bb\u00bc\u0005\u0013\u0000\u0000\u00bc\u00bd\u0003\b\u0004\u0000"+
		"\u00bd\u00be\u0006\u0005\uffff\uffff\u0000\u00be\u00bf\u0003\n\u0005\u0000"+
		"\u00bf\u00c0\u0006\u0005\uffff\uffff\u0000\u00c0\u00c2\u0001\u0000\u0000"+
		"\u0000\u00c1\u00b6\u0001\u0000\u0000\u0000\u00c1\u00b7\u0001\u0000\u0000"+
		"\u0000\u00c1\u00bb\u0001\u0000\u0000\u0000\u00c2\u000b\u0001\u0000\u0000"+
		"\u0000\u00c3\u00cd\u0001\u0000\u0000\u0000\u00c4\u00c5\u0005\u0014\u0000"+
		"\u0000\u00c5\u00cd\u0006\u0006\uffff\uffff\u0000\u00c6\u00c7\u0005\b\u0000"+
		"\u0000\u00c7\u00c8\u0003\u000e\u0007\u0000\u00c8\u00c9\u0005\t\u0000\u0000"+
		"\u00c9\u00ca\u0003\f\u0006\u0000\u00ca\u00cb\u0006\u0006\uffff\uffff\u0000"+
		"\u00cb\u00cd\u0001\u0000\u0000\u0000\u00cc\u00c3\u0001\u0000\u0000\u0000"+
		"\u00cc\u00c4\u0001\u0000\u0000\u0000\u00cc\u00c6\u0001\u0000\u0000\u0000"+
		"\u00cd\r\u0001\u0000\u0000\u0000\u00ce\u00d5\u0001\u0000\u0000\u0000\u00cf"+
		"\u00d0\u0003\b\u0004\u0000\u00d0\u00d1\u0005\u0015\u0000\u0000\u00d1\u00d2"+
		"\u0003\b\u0004\u0000\u00d2\u00d3\u0006\u0007\uffff\uffff\u0000\u00d3\u00d5"+
		"\u0001\u0000\u0000\u0000\u00d4\u00ce\u0001\u0000\u0000\u0000\u00d4\u00cf"+
		"\u0001\u0000\u0000\u0000\u00d5\u000f\u0001\u0000\u0000\u0000\u00d6\u0106"+
		"\u0001\u0000\u0000\u0000\u00d7\u00d8\u0003\u0012\t\u0000\u00d8\u00d9\u0006"+
		"\b\uffff\uffff\u0000\u00d9\u0106\u0001\u0000\u0000\u0000\u00da\u00db\u0003"+
		"\u0012\t\u0000\u00db\u00dc\u0005\u0016\u0000\u0000\u00dc\u00dd\u0006\b"+
		"\uffff\uffff\u0000\u00dd\u00de\u0003\u0010\b\u0000\u00de\u00df\u0006\b"+
		"\uffff\uffff\u0000\u00df\u0106\u0001\u0000\u0000\u0000\u00e0\u00e1\u0005"+
		"\u0017\u0000\u0000\u00e1\u00e2\u0003\u0010\b\u0000\u00e2\u00e3\u0005\u0018"+
		"\u0000\u0000\u00e3\u00e4\u0006\b\uffff\uffff\u0000\u00e4\u00e5\u0003\u0010"+
		"\b\u0000\u00e5\u00e6\u0005\u0019\u0000\u0000\u00e6\u00e7\u0003\u0010\b"+
		"\u0000\u00e7\u00e8\u0006\b\uffff\uffff\u0000\u00e8\u0106\u0001\u0000\u0000"+
		"\u0000\u00e9\u00ea\u0003\u0012\t\u0000\u00ea\u00eb\u0003\u0018\f\u0000"+
		"\u00eb\u00ec\u0006\b\uffff\uffff\u0000\u00ec\u0106\u0001\u0000\u0000\u0000"+
		"\u00ed\u00ee\u0003\u0012\t\u0000\u00ee\u00ef\u0006\b\uffff\uffff\u0000"+
		"\u00ef\u00f0\u0003\u001a\r\u0000\u00f0\u00f1\u0006\b\uffff\uffff\u0000"+
		"\u00f1\u0106\u0001\u0000\u0000\u0000\u00f2\u00f3\u0003\u0012\t\u0000\u00f3"+
		"\u00f4\u0006\b\uffff\uffff\u0000\u00f4\u00f5\u0003\u001c\u000e\u0000\u00f5"+
		"\u00f6\u0006\b\uffff\uffff\u0000\u00f6\u0106\u0001\u0000\u0000\u0000\u00f7"+
		"\u00f8\u0005\u001a\u0000\u0000\u00f8\u00f9\u0005!\u0000\u0000\u00f9\u00fa"+
		"\u0003\u001e\u000f\u0000\u00fa\u00fb\u0005\u001b\u0000\u0000\u00fb\u00fc"+
		"\u0006\b\uffff\uffff\u0000\u00fc\u00fd\u0003\u0010\b\u0000\u00fd\u00fe"+
		"\u0006\b\uffff\uffff\u0000\u00fe\u0106\u0001\u0000\u0000\u0000\u00ff\u0100"+
		"\u0005\u001c\u0000\u0000\u0100\u0101\u0005\b\u0000\u0000\u0101\u0102\u0003"+
		"\u0010\b\u0000\u0102\u0103\u0005\t\u0000\u0000\u0103\u0104\u0006\b\uffff"+
		"\uffff\u0000\u0104\u0106\u0001\u0000\u0000\u0000\u0105\u00d6\u0001\u0000"+
		"\u0000\u0000\u0105\u00d7\u0001\u0000\u0000\u0000\u0105\u00da\u0001\u0000"+
		"\u0000\u0000\u0105\u00e0\u0001\u0000\u0000\u0000\u0105\u00e9\u0001\u0000"+
		"\u0000\u0000\u0105\u00ed\u0001\u0000\u0000\u0000\u0105\u00f2\u0001\u0000"+
		"\u0000\u0000\u0105\u00f7\u0001\u0000\u0000\u0000\u0105\u00ff\u0001\u0000"+
		"\u0000\u0000\u0106\u0011\u0001\u0000\u0000\u0000\u0107\u011c\u0001\u0000"+
		"\u0000\u0000\u0108\u0109\u0005\u0005\u0000\u0000\u0109\u011c\u0006\t\uffff"+
		"\uffff\u0000\u010a\u010b\u0005!\u0000\u0000\u010b\u010c\u0005\u001d\u0000"+
		"\u0000\u010c\u010d\u0003\u0012\t\u0000\u010d\u010e\u0006\t\uffff\uffff"+
		"\u0000\u010e\u011c\u0001\u0000\u0000\u0000\u010f\u0110\u0003\u0014\n\u0000"+
		"\u0110\u0111\u0006\t\uffff\uffff\u0000\u0111\u011c\u0001\u0000\u0000\u0000"+
		"\u0112\u0113\u0006\t\uffff\uffff\u0000\u0113\u0114\u0003\u0016\u000b\u0000"+
		"\u0114\u0115\u0006\t\uffff\uffff\u0000\u0115\u011c\u0001\u0000\u0000\u0000"+
		"\u0116\u0117\u0005!\u0000\u0000\u0117\u011c\u0006\t\uffff\uffff\u0000"+
		"\u0118\u0119\u0003\u001a\r\u0000\u0119\u011a\u0006\t\uffff\uffff\u0000"+
		"\u011a\u011c\u0001\u0000\u0000\u0000\u011b\u0107\u0001\u0000\u0000\u0000"+
		"\u011b\u0108\u0001\u0000\u0000\u0000\u011b\u010a\u0001\u0000\u0000\u0000"+
		"\u011b\u010f\u0001\u0000\u0000\u0000\u011b\u0112\u0001\u0000\u0000\u0000"+
		"\u011b\u0116\u0001\u0000\u0000\u0000\u011b\u0118\u0001\u0000\u0000\u0000"+
		"\u011c\u0013\u0001\u0000\u0000\u0000\u011d\u012d\u0001\u0000\u0000\u0000"+
		"\u011e\u011f\u0005\u0006\u0000\u0000\u011f\u0120\u0005!\u0000\u0000\u0120"+
		"\u0121\u0005\u0007\u0000\u0000\u0121\u0122\u0003\u0012\t\u0000\u0122\u0123"+
		"\u0006\n\uffff\uffff\u0000\u0123\u012d\u0001\u0000\u0000\u0000\u0124\u0125"+
		"\u0005\u0006\u0000\u0000\u0125\u0126\u0005!\u0000\u0000\u0126\u0127\u0005"+
		"\u0007\u0000\u0000\u0127\u0128\u0003\u0012\t\u0000\u0128\u0129\u0006\n"+
		"\uffff\uffff\u0000\u0129\u012a\u0003\u0014\n\u0000\u012a\u012b\u0006\n"+
		"\uffff\uffff\u0000\u012b\u012d\u0001\u0000\u0000\u0000\u012c\u011d\u0001"+
		"\u0000\u0000\u0000\u012c\u011e\u0001\u0000\u0000\u0000\u012c\u0124\u0001"+
		"\u0000\u0000\u0000\u012d\u0015\u0001\u0000\u0000\u0000\u012e\u0141\u0001"+
		"\u0000\u0000\u0000\u012f\u0130\u0005\u000f\u0000\u0000\u0130\u0131\u0003"+
		" \u0010\u0000\u0131\u0132\u0005\u001e\u0000\u0000\u0132\u0133\u0006\u000b"+
		"\uffff\uffff\u0000\u0133\u0134\u0003\u0010\b\u0000\u0134\u0135\u0005\u0010"+
		"\u0000\u0000\u0135\u0136\u0006\u000b\uffff\uffff\u0000\u0136\u0141\u0001"+
		"\u0000\u0000\u0000\u0137\u0138\u0005\u000f\u0000\u0000\u0138\u0139\u0003"+
		" \u0010\u0000\u0139\u013a\u0005\u001e\u0000\u0000\u013a\u013b\u0006\u000b"+
		"\uffff\uffff\u0000\u013b\u013c\u0003\u0010\b\u0000\u013c\u013d\u0005\u0010"+
		"\u0000\u0000\u013d\u013e\u0003\u0016\u000b\u0000\u013e\u013f\u0006\u000b"+
		"\uffff\uffff\u0000\u013f\u0141\u0001\u0000\u0000\u0000\u0140\u012e\u0001"+
		"\u0000\u0000\u0000\u0140\u012f\u0001\u0000\u0000\u0000\u0140\u0137\u0001"+
		"\u0000\u0000\u0000\u0141\u0017\u0001\u0000\u0000\u0000\u0142\u014d\u0001"+
		"\u0000\u0000\u0000\u0143\u0144\u0005\u001f\u0000\u0000\u0144\u0145\u0005"+
		"!\u0000\u0000\u0145\u014d\u0006\f\uffff\uffff\u0000\u0146\u0147\u0005"+
		"\u001f\u0000\u0000\u0147\u0148\u0005!\u0000\u0000\u0148\u0149\u0006\f"+
		"\uffff\uffff\u0000\u0149\u014a\u0003\u0018\f\u0000\u014a\u014b\u0006\f"+
		"\uffff\uffff\u0000\u014b\u014d\u0001\u0000\u0000\u0000\u014c\u0142\u0001"+
		"\u0000\u0000\u0000\u014c\u0143\u0001\u0000\u0000\u0000\u014c\u0146\u0001"+
		"\u0000\u0000\u0000\u014d\u0019\u0001\u0000\u0000\u0000\u014e\u015c\u0001"+
		"\u0000\u0000\u0000\u014f\u0150\u0005\b\u0000\u0000\u0150\u0151\u0003\u0010"+
		"\b\u0000\u0151\u0152\u0005\t\u0000\u0000\u0152\u0153\u0006\r\uffff\uffff"+
		"\u0000\u0153\u015c\u0001\u0000\u0000\u0000\u0154\u0155\u0005\b\u0000\u0000"+
		"\u0155\u0156\u0003\u0010\b\u0000\u0156\u0157\u0005\t\u0000\u0000\u0157"+
		"\u0158\u0006\r\uffff\uffff\u0000\u0158\u0159\u0003\u001a\r\u0000\u0159"+
		"\u015a\u0006\r\uffff\uffff\u0000\u015a\u015c\u0001\u0000\u0000\u0000\u015b"+
		"\u014e\u0001\u0000\u0000\u0000\u015b\u014f\u0001\u0000\u0000\u0000\u015b"+
		"\u0154\u0001\u0000\u0000\u0000\u015c\u001b\u0001\u0000\u0000\u0000\u015d"+
		"\u0169\u0001\u0000\u0000\u0000\u015e\u015f\u0005 \u0000\u0000\u015f\u0160"+
		"\u0003\u0010\b\u0000\u0160\u0161\u0006\u000e\uffff\uffff\u0000\u0161\u0169"+
		"\u0001\u0000\u0000\u0000\u0162\u0163\u0005 \u0000\u0000\u0163\u0164\u0003"+
		"\u0010\b\u0000\u0164\u0165\u0006\u000e\uffff\uffff\u0000\u0165\u0166\u0003"+
		"\u001c\u000e\u0000\u0166\u0167\u0006\u000e\uffff\uffff\u0000\u0167\u0169"+
		"\u0001\u0000\u0000\u0000\u0168\u015d\u0001\u0000\u0000\u0000\u0168\u015e"+
		"\u0001\u0000\u0000\u0000\u0168\u0162\u0001\u0000\u0000\u0000\u0169\u001d"+
		"\u0001\u0000\u0000\u0000\u016a\u0176\u0001\u0000\u0000\u0000\u016b\u016c"+
		"\u0005\u0002\u0000\u0000\u016c\u016d\u0003\u0010\b\u0000\u016d\u016e\u0006"+
		"\u000f\uffff\uffff\u0000\u016e\u0176\u0001\u0000\u0000\u0000\u016f\u0170"+
		"\u0005\u0014\u0000\u0000\u0170\u0171\u0003\b\u0004\u0000\u0171\u0172\u0005"+
		"\u0002\u0000\u0000\u0172\u0173\u0003\u0010\b\u0000\u0173\u0174\u0006\u000f"+
		"\uffff\uffff\u0000\u0174\u0176\u0001\u0000\u0000\u0000\u0175\u016a\u0001"+
		"\u0000\u0000\u0000\u0175\u016b\u0001\u0000\u0000\u0000\u0175\u016f\u0001"+
		"\u0000\u0000\u0000\u0176\u001f\u0001\u0000\u0000\u0000\u0177\u0182\u0001"+
		"\u0000\u0000\u0000\u0178\u0179\u0003\"\u0011\u0000\u0179\u017a\u0006\u0010"+
		"\uffff\uffff\u0000\u017a\u0182\u0001\u0000\u0000\u0000\u017b\u017c\u0006"+
		"\u0010\uffff\uffff\u0000\u017c\u017d\u0003\"\u0011\u0000\u017d\u017e\u0005"+
		"\u0016\u0000\u0000\u017e\u017f\u0003 \u0010\u0000\u017f\u0180\u0006\u0010"+
		"\uffff\uffff\u0000\u0180\u0182\u0001\u0000\u0000\u0000\u0181\u0177\u0001"+
		"\u0000\u0000\u0000\u0181\u0178\u0001\u0000\u0000\u0000\u0181\u017b\u0001"+
		"\u0000\u0000\u0000\u0182!\u0001\u0000\u0000\u0000\u0183\u0196\u0001\u0000"+
		"\u0000\u0000\u0184\u0185\u0005!\u0000\u0000\u0185\u0196\u0006\u0011\uffff"+
		"\uffff\u0000\u0186\u0187\u0005\u0005\u0000\u0000\u0187\u0196\u0006\u0011"+
		"\uffff\uffff\u0000\u0188\u0189\u0005!\u0000\u0000\u0189\u018a\u0005\u001d"+
		"\u0000\u0000\u018a\u018b\u0003 \u0010\u0000\u018b\u018c\u0006\u0011\uffff"+
		"\uffff\u0000\u018c\u0196\u0001\u0000\u0000\u0000\u018d\u018e\u0003$\u0012"+
		"\u0000\u018e\u018f\u0006\u0011\uffff\uffff\u0000\u018f\u0196\u0001\u0000"+
		"\u0000\u0000\u0190\u0191\u0005\b\u0000\u0000\u0191\u0192\u0003 \u0010"+
		"\u0000\u0192\u0193\u0005\t\u0000\u0000\u0193\u0194\u0006\u0011\uffff\uffff"+
		"\u0000\u0194\u0196\u0001\u0000\u0000\u0000\u0195\u0183\u0001\u0000\u0000"+
		"\u0000\u0195\u0184\u0001\u0000\u0000\u0000\u0195\u0186\u0001\u0000\u0000"+
		"\u0000\u0195\u0188\u0001\u0000\u0000\u0000\u0195\u018d\u0001\u0000\u0000"+
		"\u0000\u0195\u0190\u0001\u0000\u0000\u0000\u0196#\u0001\u0000\u0000\u0000"+
		"\u0197\u01a6\u0001\u0000\u0000\u0000\u0198\u0199\u0005\u0006\u0000\u0000"+
		"\u0199\u019a\u0005!\u0000\u0000\u019a\u019b\u0005\u0007\u0000\u0000\u019b"+
		"\u019c\u0003 \u0010\u0000\u019c\u019d\u0006\u0012\uffff\uffff\u0000\u019d"+
		"\u01a6\u0001\u0000\u0000\u0000\u019e\u019f\u0005\u0006\u0000\u0000\u019f"+
		"\u01a0\u0005!\u0000\u0000\u01a0\u01a1\u0005\u0007\u0000\u0000\u01a1\u01a2"+
		"\u0003 \u0010\u0000\u01a2\u01a3\u0003$\u0012\u0000\u01a3\u01a4\u0006\u0012"+
		"\uffff\uffff\u0000\u01a4\u01a6\u0001\u0000\u0000\u0000\u01a5\u0197\u0001"+
		"\u0000\u0000\u0000\u01a5\u0198\u0001\u0000\u0000\u0000\u01a5\u019e\u0001"+
		"\u0000\u0000\u0000\u01a6%\u0001\u0000\u0000\u0000\u0013-=H^\u00b4\u00c1"+
		"\u00cc\u00d4\u0105\u011b\u012c\u0140\u014c\u015b\u0168\u0175\u0181\u0195"+
		"\u01a5";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}