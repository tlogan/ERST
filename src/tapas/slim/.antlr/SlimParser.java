// Generated from /Users/thomas/tlogan@github.com/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

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
		ID=32, INT=33, WS=34;
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
			null, "'alias'", "'='", "'TOP'", "'BOT'", "'@'", "'~'", "':'", "'('", 
			"')'", "'|'", "'&'", "'->'", "','", "'EXI'", "'['", "']'", "'ALL'", "'LFP'", 
			"'\\'", "';'", "'<:'", "'if'", "'then'", "'else'", "'let'", "'fix'", 
			"'_.'", "'case'", "'=>'", "'.'", "'|>'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, "ID", "INT", "WS"
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

	_syntax_rules : PSet[SyntaxRule] = s() 

	def init(self): 
	    self._cache = {}
	    self._guidance = default_context
	    self._overflow = False  

	def reset(self): 
	    self._guidance = default_context 
	    self._overflow = False
	    # self.getCurrentToken()
	    # self.getTokenStream()


	def get_syntax_rules(self):
	    return self._syntax_rules

	def update_sr(self, head : str, body : list[Union[Nonterm, Termin]]):
	    rule = SyntaxRule(head, tuple(body))
	    self._syntax_rules = self._syntax_rules.add(rule)

	def getGuidance(self):
	    return self._guidance

	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex

	def guide_nonterm(self, f : Callable, *args) -> Optional[Context]:
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    result_nt = None
	    if not self._overflow:
	        result_nt = f(*args)
	        self._guidance = result_nt

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 

	    return result_nt 



	def guide_lex(self, guidance : Union[Symbol, Terminal]):   
	    if not self._overflow:
	        self._guidance = guidance 

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 


	def guide_symbol(self, text : str):
	    self.guide_lex(Symbol(text))

	def guide_terminal(self, text : str):
	    self.guide_lex(Terminal(text))



	def collect(self, f : Callable, *args):

	    if self._overflow:
	        return None
	    else:

	        clean = next((
	            False
	            for arg in args
	            if arg == None
	        ), True)

	        if clean:
	            return f(*args)
	        else:
	            return None
	        # TODO: caching is broken; tokenIndex does not change 
	        # index = self.tokenIndex() 
	        # cache_result = self._cache.get(index)
	        # print(f"CACHE: {self._cache}")
	        # if False: # cache_result:
	        #     return cache_result
	        # else:
	        #     result = f(*args)
	        #     self._cache[index] = result
	        #     return result


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
		public Context context;
		public list[World] worlds;
		public PreambleContext preamble;
		public ExprContext expr;
		public PreambleContext preamble() {
			return getRuleContext(PreambleContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ProgramContext(ParserRuleContext parent, int invokingState, Context context) {
			super(parent, invokingState);
			this.context = context;
		}
		@Override public int getRuleIndex() { return RULE_program; }
	}

	public final ProgramContext program(Context context) throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState(), context);
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
				((ProgramContext)_localctx).expr = expr(context);

				_localctx.worlds = ((ProgramContext)_localctx).expr.worlds

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(69);
				((ProgramContext)_localctx).expr = expr(context);

				self._solver = Solver(m())
				_localctx.worlds = ((ProgramContext)_localctx).expr.worlds

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
			setState(98);
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
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TTag((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(88);
				((Typ_baseContext)_localctx).ID = match(ID);
				setState(89);
				match(T__6);
				setState(90);
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TField((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(93);
				match(T__7);
				setState(94);
				((Typ_baseContext)_localctx).typ = typ();
				setState(95);
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
			setState(163);
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
				setState(101);
				((TypContext)_localctx).typ_base = typ_base();

				_localctx.combo = ((TypContext)_localctx).typ_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(104);
				((TypContext)_localctx).typ_base = typ_base();
				setState(105);
				match(T__9);
				setState(106);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Unio(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(109);
				((TypContext)_localctx).typ_base = typ_base();
				setState(110);
				match(T__10);
				setState(111);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(114);
				((TypContext)_localctx).context = typ_base();
				setState(115);
				((TypContext)_localctx).acc = negchain(((TypContext)_localctx).context.combo);

				_localctx.combo = ((TypContext)_localctx).acc.combo 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(118);
				((TypContext)_localctx).typ_base = typ_base();
				setState(119);
				match(T__11);
				setState(120);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Imp(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(123);
				((TypContext)_localctx).typ_base = typ_base();
				setState(124);
				match(T__12);
				setState(125);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(TField('head', ((TypContext)_localctx).typ_base.combo), TField('tail', ((TypContext)_localctx).typ.combo)) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(128);
				match(T__13);
				setState(129);
				match(T__14);
				setState(130);
				((TypContext)_localctx).ids = ids();
				setState(131);
				match(T__15);
				setState(132);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi(((TypContext)_localctx).ids.combo, (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(135);
				match(T__13);
				setState(136);
				match(T__14);
				setState(137);
				((TypContext)_localctx).ids = ids();
				setState(138);
				((TypContext)_localctx).qualification = qualification();
				setState(139);
				match(T__15);
				setState(140);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(143);
				match(T__16);
				setState(144);
				match(T__14);
				setState(145);
				((TypContext)_localctx).ids = ids();
				setState(146);
				match(T__15);
				setState(147);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All(((TypContext)_localctx).ids.combo, (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(150);
				match(T__16);
				setState(151);
				match(T__14);
				setState(152);
				((TypContext)_localctx).ids = ids();
				setState(153);
				((TypContext)_localctx).qualification = qualification();
				setState(154);
				match(T__15);
				setState(155);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(158);
				match(T__17);
				setState(159);
				((TypContext)_localctx).ID = match(ID);
				setState(160);
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
			setState(176);
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
				setState(166);
				match(T__18);
				setState(167);
				((NegchainContext)_localctx).negation = typ();

				_localctx.combo = Diff(context, ((NegchainContext)_localctx).negation.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(170);
				match(T__18);
				setState(171);
				((NegchainContext)_localctx).negation = typ();

				context_tail = Diff(context, ((NegchainContext)_localctx).negation.combo)

				setState(173);
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
			setState(188);
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
				setState(179);
				match(T__19);
				setState(180);
				((QualificationContext)_localctx).subtyping = subtyping();

				_localctx.combo = tuple([((QualificationContext)_localctx).subtyping.combo])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(183);
				match(T__19);
				setState(184);
				((QualificationContext)_localctx).subtyping = subtyping();
				setState(185);
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
			setState(196);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__15:
			case T__19:
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
				setState(191);
				((SubtypingContext)_localctx).strong = typ();
				setState(192);
				match(T__20);
				setState(193);
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
		public Context nt;
		public list[World] worlds;
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
		public ExprContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(Context nt) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), nt);
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
				setState(199);
				((ExprContext)_localctx).base = base(nt);

				_localctx.worlds = ((ExprContext)_localctx).base.worlds
				self.update_sr('expr', [n('base')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				head_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_head, nt)

				setState(203);
				((ExprContext)_localctx).head = base(head_nt);

				self.guide_symbol(',')

				setState(205);
				match(T__12);

				nt = replace(nt, worlds = ((ExprContext)_localctx).head.worlds)
				tail_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_tail, nt, head_nt.typ_var)

				setState(207);
				((ExprContext)_localctx).tail = expr(tail_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).tail.worlds)
				_localctx.worlds = self.collect(ExprRule(self._solver).combine_tuple, nt, head_nt.typ_var, tail_nt.typ_var) 
				self.update_sr('expr', [n('base'), t(','), n('expr')])

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(210);
				match(T__21);

				condition_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_condition, nt)

				setState(212);
				((ExprContext)_localctx).condition = expr(condition_nt);

				self.guide_symbol('then')

				setState(214);
				match(T__22);

				true_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_true_branch, nt, condition_nt.typ_var)

				setState(216);
				((ExprContext)_localctx).true_branch = expr(true_branch_nt);

				self.guide_symbol('else')

				setState(218);
				match(T__23);

				false_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_false_branch, nt, condition_nt.typ_var, true_branch_nt.typ_var)

				setState(220);
				((ExprContext)_localctx).false_branch = expr(false_branch_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).condition.worlds)
				_localctx.worlds = self.collect(ExprRule(self._solver).combine_ite, nt, condition_nt.typ_var, 
				    ((ExprContext)_localctx).true_branch.worlds, true_branch_nt.typ_var, 
				    ((ExprContext)_localctx).false_branch.worlds, false_branch_nt.typ_var
				) 
				self.update_sr('expr', [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')])

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{

				rator_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_rator, nt)

				setState(224);
				((ExprContext)_localctx).rator = base(rator_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).rator.worlds)
				keychain_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_keychain, nt, rator_nt.typ_var)

				setState(226);
				((ExprContext)_localctx).keychain = keychain(keychain_nt);

				nt = replace(nt, worlds = keychain_nt.worlds)
				_localctx.worlds = self.collect(ExprRule(self._solver).combine_projection, nt, rator_nt.typ_var, ((ExprContext)_localctx).keychain.keys) 
				self.update_sr('expr', [n('base'), n('keychain')])

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{

				cator_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_cator, nt)

				setState(230);
				((ExprContext)_localctx).cator = base(cator_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).cator.worlds)
				argchain_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_argchain, nt, cator_nt.typ_var)

				setState(232);
				((ExprContext)_localctx).argchain = argchain(argchain_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).argchain.attr.worlds)
				_localctx.worlds = self.collect(ExprRule(self._solver).combine_application, nt, cator_nt.typ_var, ((ExprContext)_localctx).argchain.attr.args)
				self.update_sr('expr', [n('base'), n('argchain')])

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{

				arg_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_arg, nt)

				setState(236);
				((ExprContext)_localctx).arg = base(arg_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).arg.worlds)
				pipeline_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_pipeline, nt, arg_nt.typ_var)

				setState(238);
				((ExprContext)_localctx).pipeline = pipeline(pipeline_nt);

				nt = replace(nt, worlds = ((ExprContext)_localctx).pipeline.attr.worlds)
				_localctx.worlds = self.collect(ExprRule(self._solver).combine_funnel, nt, arg_nt.typ_var, ((ExprContext)_localctx).pipeline.attr.cators)
				self.update_sr('expr', [n('base'), n('pipeline')])

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(241);
				match(T__24);

				self.guide_terminal('ID')

				setState(243);
				((ExprContext)_localctx).ID = match(ID);

				target_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_target, nt, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(245);
				((ExprContext)_localctx).target = target(target_nt);

				self.guide_symbol(';')

				setState(247);
				match(T__19);

				nt = replace(nt, worlds = ((ExprContext)_localctx).target.worlds)
				contin_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_contin, nt, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), target_nt.typ_var)

				setState(249);
				((ExprContext)_localctx).contin = expr(contin_nt);

				((ExprContext)_localctx).worlds =  ((ExprContext)_localctx).contin.worlds
				self.update_sr('expr', [t('let'), ID, n('target'), t(';'), n('expr')])

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(252);
				match(T__25);

				self.guide_symbol('(')

				setState(254);
				match(T__7);

				body_nt = self.guide_nonterm(ExprRule(self._solver).distill_fix_body, nt)

				setState(256);
				((ExprContext)_localctx).body = expr(body_nt);

				self.guide_symbol(')')

				setState(258);
				match(T__8);

				nt = replace(nt, worlds = ((ExprContext)_localctx).body.worlds)
				_localctx.worlds = self.collect(ExprRule(self._solver).combine_fix, nt, body_nt.typ_var)
				self.update_sr('expr', [t('fix'), t('('), n('expr'), t(')')])

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
		public Context nt;
		public list[World] worlds;
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
		public BaseContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_base; }
	}

	public final BaseContext base(Context nt) throws RecognitionException {
		BaseContext _localctx = new BaseContext(_ctx, getState(), nt);
		enterRule(_localctx, 18, RULE_base);
		try {
			setState(285);
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

				_localctx.worlds = self.collect(BaseRule(self._solver).combine_unit, nt)
				self.update_sr('base', [t('@')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(266);
				match(T__5);

				self.guide_terminal('ID')

				setState(268);
				((BaseContext)_localctx).ID = match(ID);

				body_nt = self.guide_nonterm(BaseRule(self._solver).distill_tag_body, nt, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				setState(270);
				((BaseContext)_localctx).body = base(body_nt);

				nt = replace(nt, worlds = ((BaseContext)_localctx).body.worlds)
				_localctx.worlds = self.collect(BaseRule(self._solver).combine_tag, nt, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null), body_nt.typ_var)
				self.update_sr('base', [t('~'), ID, n('base')])

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(273);
				((BaseContext)_localctx).record = record(nt);

				branches = ((BaseContext)_localctx).record.branches
				_localctx.worlds = self.collect(BaseRule(self._solver).combine_record, nt, branches)
				self.update_sr('base', [n('record')])

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{


				setState(277);
				((BaseContext)_localctx).function = function(nt);

				branches = ((BaseContext)_localctx).function.branches
				_localctx.worlds = self.collect(BaseRule(self._solver).combine_function, nt, branches)
				self.update_sr('base', [n('function')])

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(280);
				((BaseContext)_localctx).ID = match(ID);

				_localctx.worlds = self.collect(BaseRule(self._solver).combine_var, nt, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))
				self.update_sr('base', [ID])

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(282);
				((BaseContext)_localctx).argchain = argchain(nt);

				nt = replace(nt, worlds = ((BaseContext)_localctx).argchain.attr.worlds)
				_localctx.worlds = self.collect(BaseRule(self._solver).combine_assoc, nt, ((BaseContext)_localctx).argchain.attr.args)
				self.update_sr('base', [n('argchain')])

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
		public Context nt;
		public list[RecordBranch] branches;
		public Token ID;
		public ExprContext body;
		public RecordContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public RecordContext record() {
			return getRuleContext(RecordContext.class,0);
		}
		public RecordContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public RecordContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record(Context nt) throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState(), nt);
		enterRule(_localctx, 20, RULE_record);
		try {
			setState(308);
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
				setState(288);
				match(T__26);

				self.guide_terminal('ID')

				setState(290);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(292);
				match(T__1);

				body_nt = self.guide_nonterm(RecordRule(self._solver).distill_single_body, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(294);
				((RecordContext)_localctx).body = expr(body_nt);

				_localctx.branches = self.collect(RecordRule(self._solver).combine_single, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.worlds, body_nt.typ_var)
				self.update_sr('record', [t('_.'), ID, t('='), n('expr')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(297);
				match(T__26);

				self.guide_terminal('ID')

				setState(299);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(301);
				match(T__1);

				body_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_body, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(303);
				((RecordContext)_localctx).body = expr(body_nt);

				tail_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_tail, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), body_nt.typ_var)

				setState(305);
				((RecordContext)_localctx).tail = record(tail_nt);

				tail_branches = ((RecordContext)_localctx).tail.branches
				_localctx.branches = self.collect(RecordRule(self._solver).combine_cons, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.worlds, body_nt.typ_var, tail_branches)
				self.update_sr('record', [t('_.'), ID, t('='), n('expr'), n('record')])

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
		public Context nt;
		public list[Branch] branches;
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
		public FunctionContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function(Context nt) throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState(), nt);
		enterRule(_localctx, 22, RULE_function);
		try {
			setState(331);
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
				setState(311);
				match(T__27);


				setState(313);
				((FunctionContext)_localctx).pattern = pattern(nt);

				self.guide_symbol('=>')

				setState(315);
				match(T__28);

				body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_body, nt, ((FunctionContext)_localctx).pattern.attr)

				setState(317);
				((FunctionContext)_localctx).body = expr(body_nt);

				_localctx.branches = self.collect(FunctionRule(self._solver).combine_single, nt, ((FunctionContext)_localctx).pattern.attr.typ, ((FunctionContext)_localctx).body.worlds, body_nt.typ_var)
				self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(320);
				match(T__27);


				setState(322);
				((FunctionContext)_localctx).pattern = pattern(nt);

				self.guide_symbol('=>')

				setState(324);
				match(T__28);

				body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_body, nt, ((FunctionContext)_localctx).pattern.attr)

				setState(326);
				((FunctionContext)_localctx).body = expr(body_nt);

				tail_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_tail, nt, ((FunctionContext)_localctx).pattern.attr.typ, body_nt.typ_var)

				setState(328);
				((FunctionContext)_localctx).tail = function(tail_nt);

				tail_branches = ((FunctionContext)_localctx).tail.branches
				_localctx.branches = self.collect(FunctionRule(self._solver).combine_cons, nt, ((FunctionContext)_localctx).pattern.attr.typ, ((FunctionContext)_localctx).body.worlds, body_nt.typ_var, tail_branches)
				self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr'), n('function')])

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
		public Context nt;
		public list[str] keys;
		public Token ID;
		public KeychainContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public KeychainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public KeychainContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_keychain; }
	}

	public final KeychainContext keychain(Context nt) throws RecognitionException {
		KeychainContext _localctx = new KeychainContext(_ctx, getState(), nt);
		enterRule(_localctx, 24, RULE_keychain);
		try {
			setState(345);
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
				setState(334);
				match(T__29);

				self.guide_terminal('ID')

				setState(336);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.keys = self.collect(KeychainRule(self._solver).combine_single, nt, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))
				self.update_sr('keychain', [t('.'), ID])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(338);
				match(T__29);

				self.guide_terminal('ID')

				setState(340);
				((KeychainContext)_localctx).ID = match(ID);


				setState(342);
				((KeychainContext)_localctx).tail = keychain(nt);

				_localctx.keys = self.collect(KeychainRule(self._solver).combine_cons, nt, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.keys)
				self.update_sr('keychain', [t('.'), ID, n('keychain')])

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
		public Context nt;
		public ArgchainAttr attr;
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
		public ArgchainContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_argchain; }
	}

	public final ArgchainContext argchain(Context nt) throws RecognitionException {
		ArgchainContext _localctx = new ArgchainContext(_ctx, getState(), nt);
		enterRule(_localctx, 26, RULE_argchain);
		try {
			setState(364);
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
				setState(348);
				match(T__7);

				content_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_single_content, nt) 

				setState(350);
				((ArgchainContext)_localctx).content = expr(content_nt);

				self.guide_symbol(')')

				setState(352);
				match(T__8);

				nt = replace(nt, worlds = ((ArgchainContext)_localctx).content.worlds)
				_localctx.attr = self.collect(ArgchainRule(self._solver).combine_single, nt, content_nt.typ_var)
				self.update_sr('argchain', [t('('), n('expr'), t(')')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(355);
				match(T__7);

				head_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_cons_head, nt) 

				setState(357);
				((ArgchainContext)_localctx).head = expr(head_nt);

				self.guide_symbol(')')

				setState(359);
				match(T__8);

				nt = replace(nt, worlds = ((ArgchainContext)_localctx).head.worlds)

				setState(361);
				((ArgchainContext)_localctx).tail = argchain(nt);

				nt = replace(nt, worlds = ((ArgchainContext)_localctx).tail.attr.worlds)
				_localctx.attr = self.collect(ArgchainRule(self._solver).combine_cons, nt, head_nt.typ_var, ((ArgchainContext)_localctx).tail.attr.args)
				self.update_sr('argchain', [t('('), n('expr'), t(')'), n('argchain')])

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
		public Context nt;
		public PipelineAttr attr;
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
		public PipelineContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_pipeline; }
	}

	public final PipelineContext pipeline(Context nt) throws RecognitionException {
		PipelineContext _localctx = new PipelineContext(_ctx, getState(), nt);
		enterRule(_localctx, 28, RULE_pipeline);
		try {
			setState(379);
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
				setState(367);
				match(T__30);

				content_nt = self.guide_nonterm(PipelineRule(self._solver).distill_single_content, nt) 

				setState(369);
				((PipelineContext)_localctx).content = expr(content_nt);

				nt = replace(nt, worlds = ((PipelineContext)_localctx).content.worlds)
				_localctx.attr = self.collect(PipelineRule(self._solver).combine_single, nt, content_nt.typ_var)
				self.update_sr('pipeline', [t('|>'), n('expr')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(372);
				match(T__30);

				head_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_head, nt) 

				setState(374);
				((PipelineContext)_localctx).head = expr(head_nt);

				nt = replace(nt, worlds = ((PipelineContext)_localctx).head.worlds)
				tail_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_tail, nt, head_nt.typ_var) 

				setState(376);
				((PipelineContext)_localctx).tail = pipeline(tail_nt);

				nt = replace(nt, worlds = ((PipelineContext)_localctx).tail.attr.worlds)
				_localctx.attr = self.collect(ArgchainRule(self._solver, nt).combine_cons, nt, head_nt.typ_var, ((PipelineContext)_localctx).tail.attr.cators)
				self.update_sr('pipeline', [t('|>'), n('expr'), n('pipeline')])

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
		public Context nt;
		public list[Worlds] worlds;
		public ExprContext expr;
		public TypContext typ;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
		}
		public TargetContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public TargetContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_target; }
	}

	public final TargetContext target(Context nt) throws RecognitionException {
		TargetContext _localctx = new TargetContext(_ctx, getState(), nt);
		enterRule(_localctx, 30, RULE_target);
		try {
			setState(394);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__19:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__1:
				enterOuterAlt(_localctx, 2);
				{
				setState(382);
				match(T__1);

				expr_nt = self.guide_nonterm(lambda: nt)

				setState(384);
				((TargetContext)_localctx).expr = expr(expr_nt);

				_localctx.worlds = ((TargetContext)_localctx).expr.worlds
				self.update_sr('target', [t('='), n('expr')])

				}
				break;
			case T__6:
				enterOuterAlt(_localctx, 3);
				{
				setState(387);
				match(T__6);
				setState(388);
				((TargetContext)_localctx).typ = typ();
				setState(389);
				match(T__1);

				expr_nt = self.guide_nonterm(lambda: nt)

				setState(391);
				((TargetContext)_localctx).expr = expr(expr_nt);

				nt = replace(nt, worlds = ((TargetContext)_localctx).expr.worlds)
				_localctx.worlds = self.collect(TargetRule(self._solver).combine_anno, nt, ((TargetContext)_localctx).typ.combo) 
				self.update_sr('target', [t(':'), TID, t('='), n('expr')])

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
		public Context nt;
		public PatternAttr attr;
		public Base_patternContext base_pattern;
		public Base_patternContext head;
		public PatternContext tail;
		public Base_patternContext base_pattern() {
			return getRuleContext(Base_patternContext.class,0);
		}
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public PatternContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public PatternContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
	}

	public final PatternContext pattern(Context nt) throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState(), nt);
		enterRule(_localctx, 32, RULE_pattern);
		try {
			setState(408);
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
				setState(397);
				((PatternContext)_localctx).base_pattern = base_pattern(nt);

				_localctx.attr = ((PatternContext)_localctx).base_pattern.attr
				self.update_sr('pattern', [n('basepat')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{


				setState(401);
				((PatternContext)_localctx).head = base_pattern(nt);

				self.guide_symbol(',')

				setState(403);
				match(T__12);


				setState(405);
				((PatternContext)_localctx).tail = pattern(nt);

				_localctx.attr = self.collect(PatternRule(self._solver).combine_tuple, nt, ((PatternContext)_localctx).head.attr, ((PatternContext)_localctx).tail.attr) 
				self.update_sr('pattern', [n('basepat'), t(','), n('pattern')])

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
		public Context nt;
		public PatternAttr attr;
		public Token ID;
		public Base_patternContext body;
		public Record_patternContext record_pattern;
		public PatternContext pattern;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public Base_patternContext base_pattern() {
			return getRuleContext(Base_patternContext.class,0);
		}
		public Record_patternContext record_pattern() {
			return getRuleContext(Record_patternContext.class,0);
		}
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public Base_patternContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Base_patternContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_base_pattern; }
	}

	public final Base_patternContext base_pattern(Context nt) throws RecognitionException {
		Base_patternContext _localctx = new Base_patternContext(_ctx, getState(), nt);
		enterRule(_localctx, 34, RULE_base_pattern);
		try {
			setState(430);
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
				setState(411);
				((Base_patternContext)_localctx).ID = match(ID);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_var, nt, (((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null))
				self.update_sr('basepat', [ID])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(413);
				match(T__4);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_unit, nt)
				self.update_sr('basepat', [t('@')])

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(415);
				match(T__5);

				self.guide_terminal('ID')

				setState(417);
				((Base_patternContext)_localctx).ID = match(ID);


				setState(419);
				((Base_patternContext)_localctx).body = base_pattern(nt);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_tag, nt, (((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null), ((Base_patternContext)_localctx).body.attr)
				self.update_sr('basepat', [t('~'), ID, n('basepat')])

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(422);
				((Base_patternContext)_localctx).record_pattern = record_pattern(nt);

				_localctx.attr = ((Base_patternContext)_localctx).record_pattern.attr
				self.update_sr('basepat', [n('recpat')])

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(425);
				match(T__7);
				setState(426);
				((Base_patternContext)_localctx).pattern = pattern(nt);
				setState(427);
				match(T__8);

				_localctx.attr = ((Base_patternContext)_localctx).pattern.attr
				self.update_sr('basepat', [t('('), n('pattern'), t(')')])

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
		public Context nt;
		public PatternAttr attr;
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
		public Record_patternContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Record_patternContext(ParserRuleContext parent, int invokingState, Context nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_record_pattern; }
	}

	public final Record_patternContext record_pattern(Context nt) throws RecognitionException {
		Record_patternContext _localctx = new Record_patternContext(_ctx, getState(), nt);
		enterRule(_localctx, 36, RULE_record_pattern);
		try {
			setState(453);
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
				setState(433);
				match(T__26);

				self.guide_terminal('ID')

				setState(435);
				((Record_patternContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(437);
				match(T__1);


				setState(439);
				((Record_patternContext)_localctx).body = pattern(nt);

				_localctx.attr = self.collect(RecordPatternRule(self._solver).combine_single, nt, (((Record_patternContext)_localctx).ID!=null?((Record_patternContext)_localctx).ID.getText():null), ((Record_patternContext)_localctx).body.attr)
				self.update_sr('recpat', [t('_.'), ID, t('='), n('pattern')])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(442);
				match(T__26);

				self.guide_terminal('ID')

				setState(444);
				((Record_patternContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(446);
				match(T__1);


				setState(448);
				((Record_patternContext)_localctx).body = pattern(nt);


				setState(450);
				((Record_patternContext)_localctx).tail = record_pattern(nt);

				_localctx.attr = self.collect(RecordPatternRule(self._solver, nt).combine_cons, nt, (((Record_patternContext)_localctx).ID!=null?((Record_patternContext)_localctx).ID.getText():null), ((Record_patternContext)_localctx).body.attr, ((Record_patternContext)_localctx).tail.attr)
				self.update_sr('recpat', [t('_.'), ID, t('='), n('pattern'), n('recpat')])

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
		"\u0004\u0001\"\u01c8\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
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
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0003\u0003c\b\u0003\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0003\u0004"+
		"\u00a4\b\u0004\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0003\u0005\u00b1\b\u0005\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0003\u0006\u00bd\b\u0006\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0003\u0007\u00c5\b\u0007\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0003\b\u0106\b\b\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0003\t\u011e\b\t\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0003"+
		"\n\u0135\b\n\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0003\u000b\u014c\b\u000b"+
		"\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001"+
		"\f\u0001\f\u0001\f\u0001\f\u0003\f\u015a\b\f\u0001\r\u0001\r\u0001\r\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0001\r\u0003\r\u016d\b\r\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0003"+
		"\u000e\u017c\b\u000e\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0003\u000f\u018b\b\u000f\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0003\u0010\u0199"+
		"\b\u0010\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0003\u0011\u01af\b\u0011\u0001\u0012\u0001"+
		"\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001"+
		"\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001"+
		"\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0012\u0001"+
		"\u0012\u0001\u0012\u0003\u0012\u01c6\b\u0012\u0001\u0012\u0000\u0000\u0013"+
		"\u0000\u0002\u0004\u0006\b\n\f\u000e\u0010\u0012\u0014\u0016\u0018\u001a"+
		"\u001c\u001e \"$\u0000\u0000\u01f4\u0000-\u0001\u0000\u0000\u0000\u0002"+
		"=\u0001\u0000\u0000\u0000\u0004H\u0001\u0000\u0000\u0000\u0006b\u0001"+
		"\u0000\u0000\u0000\b\u00a3\u0001\u0000\u0000\u0000\n\u00b0\u0001\u0000"+
		"\u0000\u0000\f\u00bc\u0001\u0000\u0000\u0000\u000e\u00c4\u0001\u0000\u0000"+
		"\u0000\u0010\u0105\u0001\u0000\u0000\u0000\u0012\u011d\u0001\u0000\u0000"+
		"\u0000\u0014\u0134\u0001\u0000\u0000\u0000\u0016\u014b\u0001\u0000\u0000"+
		"\u0000\u0018\u0159\u0001\u0000\u0000\u0000\u001a\u016c\u0001\u0000\u0000"+
		"\u0000\u001c\u017b\u0001\u0000\u0000\u0000\u001e\u018a\u0001\u0000\u0000"+
		"\u0000 \u0198\u0001\u0000\u0000\u0000\"\u01ae\u0001\u0000\u0000\u0000"+
		"$\u01c5\u0001\u0000\u0000\u0000&.\u0001\u0000\u0000\u0000\'(\u0005 \u0000"+
		"\u0000(.\u0006\u0000\uffff\uffff\u0000)*\u0005 \u0000\u0000*+\u0003\u0000"+
		"\u0000\u0000+,\u0006\u0000\uffff\uffff\u0000,.\u0001\u0000\u0000\u0000"+
		"-&\u0001\u0000\u0000\u0000-\'\u0001\u0000\u0000\u0000-)\u0001\u0000\u0000"+
		"\u0000.\u0001\u0001\u0000\u0000\u0000/>\u0001\u0000\u0000\u000001\u0005"+
		"\u0001\u0000\u000012\u0005 \u0000\u000023\u0005\u0002\u0000\u000034\u0003"+
		"\b\u0004\u000045\u0006\u0001\uffff\uffff\u00005>\u0001\u0000\u0000\u0000"+
		"67\u0005\u0001\u0000\u000078\u0005 \u0000\u000089\u0005\u0002\u0000\u0000"+
		"9:\u0003\b\u0004\u0000:;\u0003\u0002\u0001\u0000;<\u0006\u0001\uffff\uffff"+
		"\u0000<>\u0001\u0000\u0000\u0000=/\u0001\u0000\u0000\u0000=0\u0001\u0000"+
		"\u0000\u0000=6\u0001\u0000\u0000\u0000>\u0003\u0001\u0000\u0000\u0000"+
		"?I\u0001\u0000\u0000\u0000@A\u0003\u0002\u0001\u0000AB\u0006\u0002\uffff"+
		"\uffff\u0000BC\u0003\u0010\b\u0000CD\u0006\u0002\uffff\uffff\u0000DI\u0001"+
		"\u0000\u0000\u0000EF\u0003\u0010\b\u0000FG\u0006\u0002\uffff\uffff\u0000"+
		"GI\u0001\u0000\u0000\u0000H?\u0001\u0000\u0000\u0000H@\u0001\u0000\u0000"+
		"\u0000HE\u0001\u0000\u0000\u0000I\u0005\u0001\u0000\u0000\u0000Jc\u0001"+
		"\u0000\u0000\u0000KL\u0005\u0003\u0000\u0000Lc\u0006\u0003\uffff\uffff"+
		"\u0000MN\u0005\u0004\u0000\u0000Nc\u0006\u0003\uffff\uffff\u0000OP\u0005"+
		" \u0000\u0000Pc\u0006\u0003\uffff\uffff\u0000QR\u0005\u0005\u0000\u0000"+
		"Rc\u0006\u0003\uffff\uffff\u0000ST\u0005\u0006\u0000\u0000TU\u0005 \u0000"+
		"\u0000UV\u0003\u0006\u0003\u0000VW\u0006\u0003\uffff\uffff\u0000Wc\u0001"+
		"\u0000\u0000\u0000XY\u0005 \u0000\u0000YZ\u0005\u0007\u0000\u0000Z[\u0003"+
		"\u0006\u0003\u0000[\\\u0006\u0003\uffff\uffff\u0000\\c\u0001\u0000\u0000"+
		"\u0000]^\u0005\b\u0000\u0000^_\u0003\b\u0004\u0000_`\u0005\t\u0000\u0000"+
		"`a\u0006\u0003\uffff\uffff\u0000ac\u0001\u0000\u0000\u0000bJ\u0001\u0000"+
		"\u0000\u0000bK\u0001\u0000\u0000\u0000bM\u0001\u0000\u0000\u0000bO\u0001"+
		"\u0000\u0000\u0000bQ\u0001\u0000\u0000\u0000bS\u0001\u0000\u0000\u0000"+
		"bX\u0001\u0000\u0000\u0000b]\u0001\u0000\u0000\u0000c\u0007\u0001\u0000"+
		"\u0000\u0000d\u00a4\u0001\u0000\u0000\u0000ef\u0003\u0006\u0003\u0000"+
		"fg\u0006\u0004\uffff\uffff\u0000g\u00a4\u0001\u0000\u0000\u0000hi\u0003"+
		"\u0006\u0003\u0000ij\u0005\n\u0000\u0000jk\u0003\b\u0004\u0000kl\u0006"+
		"\u0004\uffff\uffff\u0000l\u00a4\u0001\u0000\u0000\u0000mn\u0003\u0006"+
		"\u0003\u0000no\u0005\u000b\u0000\u0000op\u0003\b\u0004\u0000pq\u0006\u0004"+
		"\uffff\uffff\u0000q\u00a4\u0001\u0000\u0000\u0000rs\u0003\u0006\u0003"+
		"\u0000st\u0003\n\u0005\u0000tu\u0006\u0004\uffff\uffff\u0000u\u00a4\u0001"+
		"\u0000\u0000\u0000vw\u0003\u0006\u0003\u0000wx\u0005\f\u0000\u0000xy\u0003"+
		"\b\u0004\u0000yz\u0006\u0004\uffff\uffff\u0000z\u00a4\u0001\u0000\u0000"+
		"\u0000{|\u0003\u0006\u0003\u0000|}\u0005\r\u0000\u0000}~\u0003\b\u0004"+
		"\u0000~\u007f\u0006\u0004\uffff\uffff\u0000\u007f\u00a4\u0001\u0000\u0000"+
		"\u0000\u0080\u0081\u0005\u000e\u0000\u0000\u0081\u0082\u0005\u000f\u0000"+
		"\u0000\u0082\u0083\u0003\u0000\u0000\u0000\u0083\u0084\u0005\u0010\u0000"+
		"\u0000\u0084\u0085\u0003\b\u0004\u0000\u0085\u0086\u0006\u0004\uffff\uffff"+
		"\u0000\u0086\u00a4\u0001\u0000\u0000\u0000\u0087\u0088\u0005\u000e\u0000"+
		"\u0000\u0088\u0089\u0005\u000f\u0000\u0000\u0089\u008a\u0003\u0000\u0000"+
		"\u0000\u008a\u008b\u0003\f\u0006\u0000\u008b\u008c\u0005\u0010\u0000\u0000"+
		"\u008c\u008d\u0003\b\u0004\u0000\u008d\u008e\u0006\u0004\uffff\uffff\u0000"+
		"\u008e\u00a4\u0001\u0000\u0000\u0000\u008f\u0090\u0005\u0011\u0000\u0000"+
		"\u0090\u0091\u0005\u000f\u0000\u0000\u0091\u0092\u0003\u0000\u0000\u0000"+
		"\u0092\u0093\u0005\u0010\u0000\u0000\u0093\u0094\u0003\b\u0004\u0000\u0094"+
		"\u0095\u0006\u0004\uffff\uffff\u0000\u0095\u00a4\u0001\u0000\u0000\u0000"+
		"\u0096\u0097\u0005\u0011\u0000\u0000\u0097\u0098\u0005\u000f\u0000\u0000"+
		"\u0098\u0099\u0003\u0000\u0000\u0000\u0099\u009a\u0003\f\u0006\u0000\u009a"+
		"\u009b\u0005\u0010\u0000\u0000\u009b\u009c\u0003\b\u0004\u0000\u009c\u009d"+
		"\u0006\u0004\uffff\uffff\u0000\u009d\u00a4\u0001\u0000\u0000\u0000\u009e"+
		"\u009f\u0005\u0012\u0000\u0000\u009f\u00a0\u0005 \u0000\u0000\u00a0\u00a1"+
		"\u0003\b\u0004\u0000\u00a1\u00a2\u0006\u0004\uffff\uffff\u0000\u00a2\u00a4"+
		"\u0001\u0000\u0000\u0000\u00a3d\u0001\u0000\u0000\u0000\u00a3e\u0001\u0000"+
		"\u0000\u0000\u00a3h\u0001\u0000\u0000\u0000\u00a3m\u0001\u0000\u0000\u0000"+
		"\u00a3r\u0001\u0000\u0000\u0000\u00a3v\u0001\u0000\u0000\u0000\u00a3{"+
		"\u0001\u0000\u0000\u0000\u00a3\u0080\u0001\u0000\u0000\u0000\u00a3\u0087"+
		"\u0001\u0000\u0000\u0000\u00a3\u008f\u0001\u0000\u0000\u0000\u00a3\u0096"+
		"\u0001\u0000\u0000\u0000\u00a3\u009e\u0001\u0000\u0000\u0000\u00a4\t\u0001"+
		"\u0000\u0000\u0000\u00a5\u00b1\u0001\u0000\u0000\u0000\u00a6\u00a7\u0005"+
		"\u0013\u0000\u0000\u00a7\u00a8\u0003\b\u0004\u0000\u00a8\u00a9\u0006\u0005"+
		"\uffff\uffff\u0000\u00a9\u00b1\u0001\u0000\u0000\u0000\u00aa\u00ab\u0005"+
		"\u0013\u0000\u0000\u00ab\u00ac\u0003\b\u0004\u0000\u00ac\u00ad\u0006\u0005"+
		"\uffff\uffff\u0000\u00ad\u00ae\u0003\n\u0005\u0000\u00ae\u00af\u0006\u0005"+
		"\uffff\uffff\u0000\u00af\u00b1\u0001\u0000\u0000\u0000\u00b0\u00a5\u0001"+
		"\u0000\u0000\u0000\u00b0\u00a6\u0001\u0000\u0000\u0000\u00b0\u00aa\u0001"+
		"\u0000\u0000\u0000\u00b1\u000b\u0001\u0000\u0000\u0000\u00b2\u00bd\u0001"+
		"\u0000\u0000\u0000\u00b3\u00b4\u0005\u0014\u0000\u0000\u00b4\u00b5\u0003"+
		"\u000e\u0007\u0000\u00b5\u00b6\u0006\u0006\uffff\uffff\u0000\u00b6\u00bd"+
		"\u0001\u0000\u0000\u0000\u00b7\u00b8\u0005\u0014\u0000\u0000\u00b8\u00b9"+
		"\u0003\u000e\u0007\u0000\u00b9\u00ba\u0003\f\u0006\u0000\u00ba\u00bb\u0006"+
		"\u0006\uffff\uffff\u0000\u00bb\u00bd\u0001\u0000\u0000\u0000\u00bc\u00b2"+
		"\u0001\u0000\u0000\u0000\u00bc\u00b3\u0001\u0000\u0000\u0000\u00bc\u00b7"+
		"\u0001\u0000\u0000\u0000\u00bd\r\u0001\u0000\u0000\u0000\u00be\u00c5\u0001"+
		"\u0000\u0000\u0000\u00bf\u00c0\u0003\b\u0004\u0000\u00c0\u00c1\u0005\u0015"+
		"\u0000\u0000\u00c1\u00c2\u0003\b\u0004\u0000\u00c2\u00c3\u0006\u0007\uffff"+
		"\uffff\u0000\u00c3\u00c5\u0001\u0000\u0000\u0000\u00c4\u00be\u0001\u0000"+
		"\u0000\u0000\u00c4\u00bf\u0001\u0000\u0000\u0000\u00c5\u000f\u0001\u0000"+
		"\u0000\u0000\u00c6\u0106\u0001\u0000\u0000\u0000\u00c7\u00c8\u0003\u0012"+
		"\t\u0000\u00c8\u00c9\u0006\b\uffff\uffff\u0000\u00c9\u0106\u0001\u0000"+
		"\u0000\u0000\u00ca\u00cb\u0006\b\uffff\uffff\u0000\u00cb\u00cc\u0003\u0012"+
		"\t\u0000\u00cc\u00cd\u0006\b\uffff\uffff\u0000\u00cd\u00ce\u0005\r\u0000"+
		"\u0000\u00ce\u00cf\u0006\b\uffff\uffff\u0000\u00cf\u00d0\u0003\u0010\b"+
		"\u0000\u00d0\u00d1\u0006\b\uffff\uffff\u0000\u00d1\u0106\u0001\u0000\u0000"+
		"\u0000\u00d2\u00d3\u0005\u0016\u0000\u0000\u00d3\u00d4\u0006\b\uffff\uffff"+
		"\u0000\u00d4\u00d5\u0003\u0010\b\u0000\u00d5\u00d6\u0006\b\uffff\uffff"+
		"\u0000\u00d6\u00d7\u0005\u0017\u0000\u0000\u00d7\u00d8\u0006\b\uffff\uffff"+
		"\u0000\u00d8\u00d9\u0003\u0010\b\u0000\u00d9\u00da\u0006\b\uffff\uffff"+
		"\u0000\u00da\u00db\u0005\u0018\u0000\u0000\u00db\u00dc\u0006\b\uffff\uffff"+
		"\u0000\u00dc\u00dd\u0003\u0010\b\u0000\u00dd\u00de\u0006\b\uffff\uffff"+
		"\u0000\u00de\u0106\u0001\u0000\u0000\u0000\u00df\u00e0\u0006\b\uffff\uffff"+
		"\u0000\u00e0\u00e1\u0003\u0012\t\u0000\u00e1\u00e2\u0006\b\uffff\uffff"+
		"\u0000\u00e2\u00e3\u0003\u0018\f\u0000\u00e3\u00e4\u0006\b\uffff\uffff"+
		"\u0000\u00e4\u0106\u0001\u0000\u0000\u0000\u00e5\u00e6\u0006\b\uffff\uffff"+
		"\u0000\u00e6\u00e7\u0003\u0012\t\u0000\u00e7\u00e8\u0006\b\uffff\uffff"+
		"\u0000\u00e8\u00e9\u0003\u001a\r\u0000\u00e9\u00ea\u0006\b\uffff\uffff"+
		"\u0000\u00ea\u0106\u0001\u0000\u0000\u0000\u00eb\u00ec\u0006\b\uffff\uffff"+
		"\u0000\u00ec\u00ed\u0003\u0012\t\u0000\u00ed\u00ee\u0006\b\uffff\uffff"+
		"\u0000\u00ee\u00ef\u0003\u001c\u000e\u0000\u00ef\u00f0\u0006\b\uffff\uffff"+
		"\u0000\u00f0\u0106\u0001\u0000\u0000\u0000\u00f1\u00f2\u0005\u0019\u0000"+
		"\u0000\u00f2\u00f3\u0006\b\uffff\uffff\u0000\u00f3\u00f4\u0005 \u0000"+
		"\u0000\u00f4\u00f5\u0006\b\uffff\uffff\u0000\u00f5\u00f6\u0003\u001e\u000f"+
		"\u0000\u00f6\u00f7\u0006\b\uffff\uffff\u0000\u00f7\u00f8\u0005\u0014\u0000"+
		"\u0000\u00f8\u00f9\u0006\b\uffff\uffff\u0000\u00f9\u00fa\u0003\u0010\b"+
		"\u0000\u00fa\u00fb\u0006\b\uffff\uffff\u0000\u00fb\u0106\u0001\u0000\u0000"+
		"\u0000\u00fc\u00fd\u0005\u001a\u0000\u0000\u00fd\u00fe\u0006\b\uffff\uffff"+
		"\u0000\u00fe\u00ff\u0005\b\u0000\u0000\u00ff\u0100\u0006\b\uffff\uffff"+
		"\u0000\u0100\u0101\u0003\u0010\b\u0000\u0101\u0102\u0006\b\uffff\uffff"+
		"\u0000\u0102\u0103\u0005\t\u0000\u0000\u0103\u0104\u0006\b\uffff\uffff"+
		"\u0000\u0104\u0106\u0001\u0000\u0000\u0000\u0105\u00c6\u0001\u0000\u0000"+
		"\u0000\u0105\u00c7\u0001\u0000\u0000\u0000\u0105\u00ca\u0001\u0000\u0000"+
		"\u0000\u0105\u00d2\u0001\u0000\u0000\u0000\u0105\u00df\u0001\u0000\u0000"+
		"\u0000\u0105\u00e5\u0001\u0000\u0000\u0000\u0105\u00eb\u0001\u0000\u0000"+
		"\u0000\u0105\u00f1\u0001\u0000\u0000\u0000\u0105\u00fc\u0001\u0000\u0000"+
		"\u0000\u0106\u0011\u0001\u0000\u0000\u0000\u0107\u011e\u0001\u0000\u0000"+
		"\u0000\u0108\u0109\u0005\u0005\u0000\u0000\u0109\u011e\u0006\t\uffff\uffff"+
		"\u0000\u010a\u010b\u0005\u0006\u0000\u0000\u010b\u010c\u0006\t\uffff\uffff"+
		"\u0000\u010c\u010d\u0005 \u0000\u0000\u010d\u010e\u0006\t\uffff\uffff"+
		"\u0000\u010e\u010f\u0003\u0012\t\u0000\u010f\u0110\u0006\t\uffff\uffff"+
		"\u0000\u0110\u011e\u0001\u0000\u0000\u0000\u0111\u0112\u0003\u0014\n\u0000"+
		"\u0112\u0113\u0006\t\uffff\uffff\u0000\u0113\u011e\u0001\u0000\u0000\u0000"+
		"\u0114\u0115\u0006\t\uffff\uffff\u0000\u0115\u0116\u0003\u0016\u000b\u0000"+
		"\u0116\u0117\u0006\t\uffff\uffff\u0000\u0117\u011e\u0001\u0000\u0000\u0000"+
		"\u0118\u0119\u0005 \u0000\u0000\u0119\u011e\u0006\t\uffff\uffff\u0000"+
		"\u011a\u011b\u0003\u001a\r\u0000\u011b\u011c\u0006\t\uffff\uffff\u0000"+
		"\u011c\u011e\u0001\u0000\u0000\u0000\u011d\u0107\u0001\u0000\u0000\u0000"+
		"\u011d\u0108\u0001\u0000\u0000\u0000\u011d\u010a\u0001\u0000\u0000\u0000"+
		"\u011d\u0111\u0001\u0000\u0000\u0000\u011d\u0114\u0001\u0000\u0000\u0000"+
		"\u011d\u0118\u0001\u0000\u0000\u0000\u011d\u011a\u0001\u0000\u0000\u0000"+
		"\u011e\u0013\u0001\u0000\u0000\u0000\u011f\u0135\u0001\u0000\u0000\u0000"+
		"\u0120\u0121\u0005\u001b\u0000\u0000\u0121\u0122\u0006\n\uffff\uffff\u0000"+
		"\u0122\u0123\u0005 \u0000\u0000\u0123\u0124\u0006\n\uffff\uffff\u0000"+
		"\u0124\u0125\u0005\u0002\u0000\u0000\u0125\u0126\u0006\n\uffff\uffff\u0000"+
		"\u0126\u0127\u0003\u0010\b\u0000\u0127\u0128\u0006\n\uffff\uffff\u0000"+
		"\u0128\u0135\u0001\u0000\u0000\u0000\u0129\u012a\u0005\u001b\u0000\u0000"+
		"\u012a\u012b\u0006\n\uffff\uffff\u0000\u012b\u012c\u0005 \u0000\u0000"+
		"\u012c\u012d\u0006\n\uffff\uffff\u0000\u012d\u012e\u0005\u0002\u0000\u0000"+
		"\u012e\u012f\u0006\n\uffff\uffff\u0000\u012f\u0130\u0003\u0010\b\u0000"+
		"\u0130\u0131\u0006\n\uffff\uffff\u0000\u0131\u0132\u0003\u0014\n\u0000"+
		"\u0132\u0133\u0006\n\uffff\uffff\u0000\u0133\u0135\u0001\u0000\u0000\u0000"+
		"\u0134\u011f\u0001\u0000\u0000\u0000\u0134\u0120\u0001\u0000\u0000\u0000"+
		"\u0134\u0129\u0001\u0000\u0000\u0000\u0135\u0015\u0001\u0000\u0000\u0000"+
		"\u0136\u014c\u0001\u0000\u0000\u0000\u0137\u0138\u0005\u001c\u0000\u0000"+
		"\u0138\u0139\u0006\u000b\uffff\uffff\u0000\u0139\u013a\u0003 \u0010\u0000"+
		"\u013a\u013b\u0006\u000b\uffff\uffff\u0000\u013b\u013c\u0005\u001d\u0000"+
		"\u0000\u013c\u013d\u0006\u000b\uffff\uffff\u0000\u013d\u013e\u0003\u0010"+
		"\b\u0000\u013e\u013f\u0006\u000b\uffff\uffff\u0000\u013f\u014c\u0001\u0000"+
		"\u0000\u0000\u0140\u0141\u0005\u001c\u0000\u0000\u0141\u0142\u0006\u000b"+
		"\uffff\uffff\u0000\u0142\u0143\u0003 \u0010\u0000\u0143\u0144\u0006\u000b"+
		"\uffff\uffff\u0000\u0144\u0145\u0005\u001d\u0000\u0000\u0145\u0146\u0006"+
		"\u000b\uffff\uffff\u0000\u0146\u0147\u0003\u0010\b\u0000\u0147\u0148\u0006"+
		"\u000b\uffff\uffff\u0000\u0148\u0149\u0003\u0016\u000b\u0000\u0149\u014a"+
		"\u0006\u000b\uffff\uffff\u0000\u014a\u014c\u0001\u0000\u0000\u0000\u014b"+
		"\u0136\u0001\u0000\u0000\u0000\u014b\u0137\u0001\u0000\u0000\u0000\u014b"+
		"\u0140\u0001\u0000\u0000\u0000\u014c\u0017\u0001\u0000\u0000\u0000\u014d"+
		"\u015a\u0001\u0000\u0000\u0000\u014e\u014f\u0005\u001e\u0000\u0000\u014f"+
		"\u0150\u0006\f\uffff\uffff\u0000\u0150\u0151\u0005 \u0000\u0000\u0151"+
		"\u015a\u0006\f\uffff\uffff\u0000\u0152\u0153\u0005\u001e\u0000\u0000\u0153"+
		"\u0154\u0006\f\uffff\uffff\u0000\u0154\u0155\u0005 \u0000\u0000\u0155"+
		"\u0156\u0006\f\uffff\uffff\u0000\u0156\u0157\u0003\u0018\f\u0000\u0157"+
		"\u0158\u0006\f\uffff\uffff\u0000\u0158\u015a\u0001\u0000\u0000\u0000\u0159"+
		"\u014d\u0001\u0000\u0000\u0000\u0159\u014e\u0001\u0000\u0000\u0000\u0159"+
		"\u0152\u0001\u0000\u0000\u0000\u015a\u0019\u0001\u0000\u0000\u0000\u015b"+
		"\u016d\u0001\u0000\u0000\u0000\u015c\u015d\u0005\b\u0000\u0000\u015d\u015e"+
		"\u0006\r\uffff\uffff\u0000\u015e\u015f\u0003\u0010\b\u0000\u015f\u0160"+
		"\u0006\r\uffff\uffff\u0000\u0160\u0161\u0005\t\u0000\u0000\u0161\u0162"+
		"\u0006\r\uffff\uffff\u0000\u0162\u016d\u0001\u0000\u0000\u0000\u0163\u0164"+
		"\u0005\b\u0000\u0000\u0164\u0165\u0006\r\uffff\uffff\u0000\u0165\u0166"+
		"\u0003\u0010\b\u0000\u0166\u0167\u0006\r\uffff\uffff\u0000\u0167\u0168"+
		"\u0005\t\u0000\u0000\u0168\u0169\u0006\r\uffff\uffff\u0000\u0169\u016a"+
		"\u0003\u001a\r\u0000\u016a\u016b\u0006\r\uffff\uffff\u0000\u016b\u016d"+
		"\u0001\u0000\u0000\u0000\u016c\u015b\u0001\u0000\u0000\u0000\u016c\u015c"+
		"\u0001\u0000\u0000\u0000\u016c\u0163\u0001\u0000\u0000\u0000\u016d\u001b"+
		"\u0001\u0000\u0000\u0000\u016e\u017c\u0001\u0000\u0000\u0000\u016f\u0170"+
		"\u0005\u001f\u0000\u0000\u0170\u0171\u0006\u000e\uffff\uffff\u0000\u0171"+
		"\u0172\u0003\u0010\b\u0000\u0172\u0173\u0006\u000e\uffff\uffff\u0000\u0173"+
		"\u017c\u0001\u0000\u0000\u0000\u0174\u0175\u0005\u001f\u0000\u0000\u0175"+
		"\u0176\u0006\u000e\uffff\uffff\u0000\u0176\u0177\u0003\u0010\b\u0000\u0177"+
		"\u0178\u0006\u000e\uffff\uffff\u0000\u0178\u0179\u0003\u001c\u000e\u0000"+
		"\u0179\u017a\u0006\u000e\uffff\uffff\u0000\u017a\u017c\u0001\u0000\u0000"+
		"\u0000\u017b\u016e\u0001\u0000\u0000\u0000\u017b\u016f\u0001\u0000\u0000"+
		"\u0000\u017b\u0174\u0001\u0000\u0000\u0000\u017c\u001d\u0001\u0000\u0000"+
		"\u0000\u017d\u018b\u0001\u0000\u0000\u0000\u017e\u017f\u0005\u0002\u0000"+
		"\u0000\u017f\u0180\u0006\u000f\uffff\uffff\u0000\u0180\u0181\u0003\u0010"+
		"\b\u0000\u0181\u0182\u0006\u000f\uffff\uffff\u0000\u0182\u018b\u0001\u0000"+
		"\u0000\u0000\u0183\u0184\u0005\u0007\u0000\u0000\u0184\u0185\u0003\b\u0004"+
		"\u0000\u0185\u0186\u0005\u0002\u0000\u0000\u0186\u0187\u0006\u000f\uffff"+
		"\uffff\u0000\u0187\u0188\u0003\u0010\b\u0000\u0188\u0189\u0006\u000f\uffff"+
		"\uffff\u0000\u0189\u018b\u0001\u0000\u0000\u0000\u018a\u017d\u0001\u0000"+
		"\u0000\u0000\u018a\u017e\u0001\u0000\u0000\u0000\u018a\u0183\u0001\u0000"+
		"\u0000\u0000\u018b\u001f\u0001\u0000\u0000\u0000\u018c\u0199\u0001\u0000"+
		"\u0000\u0000\u018d\u018e\u0003\"\u0011\u0000\u018e\u018f\u0006\u0010\uffff"+
		"\uffff\u0000\u018f\u0199\u0001\u0000\u0000\u0000\u0190\u0191\u0006\u0010"+
		"\uffff\uffff\u0000\u0191\u0192\u0003\"\u0011\u0000\u0192\u0193\u0006\u0010"+
		"\uffff\uffff\u0000\u0193\u0194\u0005\r\u0000\u0000\u0194\u0195\u0006\u0010"+
		"\uffff\uffff\u0000\u0195\u0196\u0003 \u0010\u0000\u0196\u0197\u0006\u0010"+
		"\uffff\uffff\u0000\u0197\u0199\u0001\u0000\u0000\u0000\u0198\u018c\u0001"+
		"\u0000\u0000\u0000\u0198\u018d\u0001\u0000\u0000\u0000\u0198\u0190\u0001"+
		"\u0000\u0000\u0000\u0199!\u0001\u0000\u0000\u0000\u019a\u01af\u0001\u0000"+
		"\u0000\u0000\u019b\u019c\u0005 \u0000\u0000\u019c\u01af\u0006\u0011\uffff"+
		"\uffff\u0000\u019d\u019e\u0005\u0005\u0000\u0000\u019e\u01af\u0006\u0011"+
		"\uffff\uffff\u0000\u019f\u01a0\u0005\u0006\u0000\u0000\u01a0\u01a1\u0006"+
		"\u0011\uffff\uffff\u0000\u01a1\u01a2\u0005 \u0000\u0000\u01a2\u01a3\u0006"+
		"\u0011\uffff\uffff\u0000\u01a3\u01a4\u0003\"\u0011\u0000\u01a4\u01a5\u0006"+
		"\u0011\uffff\uffff\u0000\u01a5\u01af\u0001\u0000\u0000\u0000\u01a6\u01a7"+
		"\u0003$\u0012\u0000\u01a7\u01a8\u0006\u0011\uffff\uffff\u0000\u01a8\u01af"+
		"\u0001\u0000\u0000\u0000\u01a9\u01aa\u0005\b\u0000\u0000\u01aa\u01ab\u0003"+
		" \u0010\u0000\u01ab\u01ac\u0005\t\u0000\u0000\u01ac\u01ad\u0006\u0011"+
		"\uffff\uffff\u0000\u01ad\u01af\u0001\u0000\u0000\u0000\u01ae\u019a\u0001"+
		"\u0000\u0000\u0000\u01ae\u019b\u0001\u0000\u0000\u0000\u01ae\u019d\u0001"+
		"\u0000\u0000\u0000\u01ae\u019f\u0001\u0000\u0000\u0000\u01ae\u01a6\u0001"+
		"\u0000\u0000\u0000\u01ae\u01a9\u0001\u0000\u0000\u0000\u01af#\u0001\u0000"+
		"\u0000\u0000\u01b0\u01c6\u0001\u0000\u0000\u0000\u01b1\u01b2\u0005\u001b"+
		"\u0000\u0000\u01b2\u01b3\u0006\u0012\uffff\uffff\u0000\u01b3\u01b4\u0005"+
		" \u0000\u0000\u01b4\u01b5\u0006\u0012\uffff\uffff\u0000\u01b5\u01b6\u0005"+
		"\u0002\u0000\u0000\u01b6\u01b7\u0006\u0012\uffff\uffff\u0000\u01b7\u01b8"+
		"\u0003 \u0010\u0000\u01b8\u01b9\u0006\u0012\uffff\uffff\u0000\u01b9\u01c6"+
		"\u0001\u0000\u0000\u0000\u01ba\u01bb\u0005\u001b\u0000\u0000\u01bb\u01bc"+
		"\u0006\u0012\uffff\uffff\u0000\u01bc\u01bd\u0005 \u0000\u0000\u01bd\u01be"+
		"\u0006\u0012\uffff\uffff\u0000\u01be\u01bf\u0005\u0002\u0000\u0000\u01bf"+
		"\u01c0\u0006\u0012\uffff\uffff\u0000\u01c0\u01c1\u0003 \u0010\u0000\u01c1"+
		"\u01c2\u0006\u0012\uffff\uffff\u0000\u01c2\u01c3\u0003$\u0012\u0000\u01c3"+
		"\u01c4\u0006\u0012\uffff\uffff\u0000\u01c4\u01c6\u0001\u0000\u0000\u0000"+
		"\u01c5\u01b0\u0001\u0000\u0000\u0000\u01c5\u01b1\u0001\u0000\u0000\u0000"+
		"\u01c5\u01ba\u0001\u0000\u0000\u0000\u01c6%\u0001\u0000\u0000\u0000\u0013"+
		"-=Hb\u00a3\u00b0\u00bc\u00c4\u0105\u011d\u0134\u014b\u0159\u016c\u017b"+
		"\u018a\u0198\u01ae\u01c5";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}