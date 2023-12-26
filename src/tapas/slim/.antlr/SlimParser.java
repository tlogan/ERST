// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 


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
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, ID=30, INT=31, WS=32;
	public static final int
		RULE_ids = 0, RULE_typ_base = 1, RULE_typ = 2, RULE_negchain = 3, RULE_qualification = 4, 
		RULE_subtyping = 5, RULE_expr = 6, RULE_base = 7, RULE_function = 8, RULE_record = 9, 
		RULE_argchain = 10, RULE_pipeline = 11, RULE_keychain = 12, RULE_target = 13, 
		RULE_pattern = 14, RULE_pattern_base = 15, RULE_pattern_record = 16;
	private static String[] makeRuleNames() {
		return new String[] {
			"ids", "typ_base", "typ", "negchain", "qualification", "subtyping", "expr", 
			"base", "function", "record", "argchain", "pipeline", "keychain", "target", 
			"pattern", "pattern_base", "pattern_record"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'@'", "':'", "'('", "')'", "'|'", "'&'", "'->'", "','", "'{'", 
			"'.'", "'}'", "'['", "']'", "'least'", "'with'", "'greatest'", "'of'", 
			"'\\'", "'<:'", "'if'", "'then'", "'else'", "'let'", "';'", "'fix'", 
			"'case'", "'=>'", "'='", "'|>'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, "ID", "INT", "WS"
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

	def init(self): 
	    self._solver = Solver() 
	    self._cache = {}
	    self._guidance = nt_default 
	    self._overflow = False  

	def reset(self): 
	    self._guidance = nt_default
	    self._overflow = False
	    # self.getCurrentToken()
	    # self.getTokenStream()



	def getGuidance(self):
	    return self._guidance

	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex

	def guide_nonterm(self, f : Callable, *args) -> Optional[Nonterm]:
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    nt_result = None
	    if not self._overflow:
	        nt_result = f(*args)
	        self._guidance = nt_result

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 

	    return nt_result 



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
		public list[str] combo;
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
			setState(41);
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
				setState(35);
				((IdsContext)_localctx).ID = match(ID);

				_localctx.combo = [(((IdsContext)_localctx).ID!=null?((IdsContext)_localctx).ID.getText():null)]

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(37);
				((IdsContext)_localctx).ID = match(ID);
				setState(38);
				((IdsContext)_localctx).ids = ids();

				_localctx.combo = [(((IdsContext)_localctx).ID!=null?((IdsContext)_localctx).ID.getText():null)] ++ ((IdsContext)_localctx).ids.combo

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
		enterRule(_localctx, 2, RULE_typ_base);
		try {
			setState(63);
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
				setState(44);
				((Typ_baseContext)_localctx).ID = match(ID);

				_localctx.combo = TVar((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null)) 

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(46);
				match(T__0);

				_localctx.combo = TUnit() 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(48);
				match(T__1);
				setState(49);
				((Typ_baseContext)_localctx).ID = match(ID);
				setState(50);
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TTag((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(53);
				((Typ_baseContext)_localctx).ID = match(ID);
				setState(54);
				match(T__1);
				setState(55);
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TField((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(58);
				match(T__2);
				setState(59);
				((Typ_baseContext)_localctx).typ = typ();
				setState(60);
				match(T__3);

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
		enterRule(_localctx, 4, RULE_typ);
		try {
			setState(121);
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
				setState(66);
				((TypContext)_localctx).typ_base = typ_base();

				_localctx.combo = ((TypContext)_localctx).typ_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(69);
				((TypContext)_localctx).typ_base = typ_base();
				setState(70);
				match(T__4);
				setState(71);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Unio(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(74);
				((TypContext)_localctx).typ_base = typ_base();
				setState(75);
				match(T__5);
				setState(76);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(79);
				((TypContext)_localctx).context = typ_base();
				setState(80);
				((TypContext)_localctx).acc = negchain(((TypContext)_localctx).context.combo);

				_localctx.combo = ((TypContext)_localctx).acc.combo 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(83);
				((TypContext)_localctx).typ_base = typ_base();
				setState(84);
				match(T__6);
				setState(85);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Imp(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(88);
				((TypContext)_localctx).typ_base = typ_base();
				setState(89);
				match(T__7);
				setState(90);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(TField('left', ((TypContext)_localctx).typ_base.combo), TField('right', ((TypContext)_localctx).typ.combo)) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(93);
				match(T__8);
				setState(94);
				((TypContext)_localctx).ids = ids();
				setState(95);
				match(T__9);
				setState(96);
				((TypContext)_localctx).qualification = qualification();
				setState(97);
				match(T__10);
				setState(98);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = IdxUnio(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(101);
				match(T__11);
				setState(102);
				((TypContext)_localctx).ids = ids();
				setState(103);
				match(T__9);
				setState(104);
				((TypContext)_localctx).qualification = qualification();
				setState(105);
				match(T__12);
				setState(106);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = IdxInter(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(109);
				match(T__13);
				setState(110);
				((TypContext)_localctx).ID = match(ID);
				setState(111);
				match(T__14);
				setState(112);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Least((((TypContext)_localctx).ID!=null?((TypContext)_localctx).ID.getText():null), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(115);
				match(T__15);
				setState(116);
				((TypContext)_localctx).ID = match(ID);
				setState(117);
				match(T__16);
				setState(118);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Greatest((((TypContext)_localctx).ID!=null?((TypContext)_localctx).ID.getText():null), ((TypContext)_localctx).typ.combo) 

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
		enterRule(_localctx, 6, RULE_negchain);
		try {
			setState(134);
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
				setState(124);
				match(T__17);
				setState(125);
				((NegchainContext)_localctx).negation = typ();

				_localctx.combo = Diff(context, ((NegchainContext)_localctx).negation.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(128);
				match(T__17);
				setState(129);
				((NegchainContext)_localctx).negation = typ();

				context_tail = Diff(context, ((NegchainContext)_localctx).negation.combo)

				setState(131);
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
		public list[tuple[Typ, Typ]] combo;
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
		enterRule(_localctx, 8, RULE_qualification);
		try {
			setState(142);
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
				setState(137);
				subtyping();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(138);
				subtyping();
				setState(139);
				match(T__7);
				setState(140);
				qualification();
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
		public tuple[Typ, Typ] combo;
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
		enterRule(_localctx, 10, RULE_subtyping);
		try {
			setState(149);
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
				setState(145);
				typ();
				setState(146);
				match(T__18);
				setState(147);
				typ();
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
	public static class ExprContext extends ParserRuleContext {
		public Nonterm nt;
		public Typ combo;
		public BaseContext base;
		public BaseContext head;
		public BaseContext tail;
		public ExprContext condition;
		public ExprContext branch_true;
		public ExprContext branch_false;
		public BaseContext cator;
		public KeychainContext keychain;
		public ArgchainContext argchain;
		public PipelineContext pipeline;
		public Token ID;
		public TargetContext target;
		public ExprContext contin;
		public ExprContext body;
		public List<BaseContext> base() {
			return getRuleContexts(BaseContext.class);
		}
		public BaseContext base(int i) {
			return getRuleContext(BaseContext.class,i);
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
		public ExprContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(Nonterm nt) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), nt);
		enterRule(_localctx, 12, RULE_expr);
		try {
			setState(214);
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
				setState(152);
				((ExprContext)_localctx).base = base(nt);

				_localctx.combo = ((ExprContext)_localctx).base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_head)

				setState(156);
				((ExprContext)_localctx).head = base(nt);

				self.guide_symbol(',')

				setState(158);
				match(T__7);

				nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_tail, ((ExprContext)_localctx).head.combo)

				setState(160);
				((ExprContext)_localctx).tail = base(nt);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, ((ExprContext)_localctx).head.combo, ((ExprContext)_localctx).tail.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(163);
				match(T__19);

				nt_condition = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_condition)

				setState(165);
				((ExprContext)_localctx).condition = expr(nt_condition);

				self.guide_symbol('then')

				setState(167);
				match(T__20);

				nt_branch_true = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_true, ((ExprContext)_localctx).condition.combo)

				setState(169);
				((ExprContext)_localctx).branch_true = expr(nt_branch_true);

				self.guide_symbol('else')

				setState(171);
				match(T__21);

				nt_branch_false = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_false, ((ExprContext)_localctx).condition.combo, ((ExprContext)_localctx).branch_true.combo)

				setState(173);
				((ExprContext)_localctx).branch_false = expr(nt_branch_false);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_ite, ((ExprContext)_localctx).condition.combo, ((ExprContext)_localctx).branch_true.combo, ((ExprContext)_localctx).branch_false.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{

				nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_cator)

				setState(177);
				((ExprContext)_localctx).cator = base(nt_cator);

				nt_keychain = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_keychain, ((ExprContext)_localctx).cator.combo)

				setState(179);
				((ExprContext)_localctx).keychain = keychain(nt_keychain);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_projection, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).keychain.combo) 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{

				nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_cator)

				setState(183);
				((ExprContext)_localctx).cator = base(nt_cator);

				nt_argchain = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_argchain, ((ExprContext)_localctx).cator.combo)

				setState(185);
				((ExprContext)_localctx).argchain = argchain(nt_argchain);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_application, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).argchain.combo)

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{

				nt_arg = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_arg)

				setState(189);
				((ExprContext)_localctx).cator = base(nt_arg);

				nt_pipeline = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_pipeline, ((ExprContext)_localctx).cator.combo)

				setState(191);
				((ExprContext)_localctx).pipeline = pipeline(nt_pipeline);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_funnel, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).pipeline.combo)

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(194);
				match(T__22);

				self.guide_terminal('ID')

				setState(196);
				((ExprContext)_localctx).ID = match(ID);

				nt_target = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_target, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(198);
				((ExprContext)_localctx).target = target(nt_target);

				self.guide_symbol(';')

				setState(200);
				match(T__23);

				nt_contin = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_contin, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.combo)

				setState(202);
				((ExprContext)_localctx).contin = expr(nt_contin);

				_localctx.combo = ((ExprContext)_localctx).contin.combo

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(205);
				match(T__24);

				self.guide_symbol('(')

				setState(207);
				match(T__2);

				nt_body = self.guide_nonterm(ExprRule(self._solver, nt).distill_fix_body)

				setState(209);
				((ExprContext)_localctx).body = expr(nt_body);

				self.guide_symbol(')')

				setState(211);
				match(T__3);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_fix, ((ExprContext)_localctx).body.combo)

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
		public Nonterm nt;
		public Typ combo;
		public Token ID;
		public ExprContext body;
		public RecordContext record;
		public FunctionContext function;
		public ExprContext expr;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public RecordContext record() {
			return getRuleContext(RecordContext.class,0);
		}
		public FunctionContext function() {
			return getRuleContext(FunctionContext.class,0);
		}
		public BaseContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public BaseContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_base; }
	}

	public final BaseContext base(Nonterm nt) throws RecognitionException {
		BaseContext _localctx = new BaseContext(_ctx, getState(), nt);
		enterRule(_localctx, 14, RULE_base);
		try {
			setState(242);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(217);
				match(T__0);

				_localctx.combo = self.collect(BaseRule(self._solver, nt).combine_unit)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(219);
				match(T__1);

				self.guide_terminal('ID')

				setState(221);
				((BaseContext)_localctx).ID = match(ID);

				nt_body = self.guide_nonterm(BaseRule(self._solver, nt).distill_tag_body, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				setState(223);
				((BaseContext)_localctx).body = expr(nt_body);

				_localctx.combo = self.collect(BaseRule(self._solver, nt).combine_tag, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null), ((BaseContext)_localctx).body.combo)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(226);
				((BaseContext)_localctx).record = record(nt);

				_localctx.combo = ((BaseContext)_localctx).record.combo

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{


				setState(230);
				((BaseContext)_localctx).function = function(nt);

				_localctx.combo = self.collect(BaseRule(self._solver, nt).combine_function, ((BaseContext)_localctx).function.combo)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(233);
				((BaseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(BaseRule(self._solver, nt).combine_var, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(235);
				match(T__2);

				nt_expr = self.guide_nonterm(lambda: nt)

				setState(237);
				((BaseContext)_localctx).expr = expr(nt_expr);

				self.guide_symbol(')')

				setState(239);
				match(T__3);

				_localctx.combo = ((BaseContext)_localctx).expr.combo

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
		public Nonterm nt;
		public list[Imp] combo;
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
		public FunctionContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function(Nonterm nt) throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState(), nt);
		enterRule(_localctx, 16, RULE_function);
		try {
			setState(265);
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
				setState(245);
				match(T__25);

				nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_pattern)

				setState(247);
				((FunctionContext)_localctx).pattern = pattern(nt_pattern);

				self.guide_symbol('=>')

				setState(249);
				match(T__26);

				nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_body, ((FunctionContext)_localctx).pattern.combo)

				setState(251);
				((FunctionContext)_localctx).body = expr(nt_body);

				_localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_single, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(254);
				match(T__25);

				nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_pattern)

				setState(256);
				((FunctionContext)_localctx).pattern = pattern(nt_pattern);

				self.guide_symbol('=>')

				setState(258);
				match(T__26);

				nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_body, ((FunctionContext)_localctx).pattern.combo)

				setState(260);
				((FunctionContext)_localctx).body = expr(nt_body);

				nt_tail = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_tail, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				setState(262);
				((FunctionContext)_localctx).tail = function(nt);

				_localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_cons, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo, ((FunctionContext)_localctx).tail.combo)

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
		public Nonterm nt;
		public Typ combo;
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
		public RecordContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record(Nonterm nt) throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState(), nt);
		enterRule(_localctx, 18, RULE_record);
		try {
			setState(288);
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
				setState(268);
				match(T__1);

				self.guide_terminal('ID')

				setState(270);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(272);
				match(T__27);

				nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_single_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(274);
				((RecordContext)_localctx).body = expr(nt_body);

				_localctx.combo = self.collect(RecordRule(self._solver, nt).combine_single, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(277);
				match(T__1);

				self.guide_terminal('ID')

				setState(279);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(281);
				match(T__27);

				nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(283);
				((RecordContext)_localctx).body = expr(nt);

				nt_tail = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_tail, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				setState(285);
				((RecordContext)_localctx).tail = record(nt);

				_localctx.combo = self.collect(RecordRule(self._solver, nt).combine_cons, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo, ((RecordContext)_localctx).tail.combo)

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
		public Nonterm nt;
		public list[Typ] combo;
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
		public ArgchainContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_argchain; }
	}

	public final ArgchainContext argchain(Nonterm nt) throws RecognitionException {
		ArgchainContext _localctx = new ArgchainContext(_ctx, getState(), nt);
		enterRule(_localctx, 20, RULE_argchain);
		try {
			setState(307);
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
				setState(291);
				match(T__2);

				nt_content = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_single_content) 

				setState(293);
				((ArgchainContext)_localctx).content = expr(nt_content);

				self.guide_symbol(')')

				setState(295);
				match(T__3);

				_localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_single, ((ArgchainContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(298);
				match(T__2);

				nt_head = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_head) 

				setState(300);
				((ArgchainContext)_localctx).head = expr(nt_head);

				self.guide_symbol(')')

				setState(302);
				match(T__3);

				nt_tail = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_tail, ((ArgchainContext)_localctx).head.combo) 

				setState(304);
				((ArgchainContext)_localctx).tail = argchain(nt_tail);

				_localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_cons, ((ArgchainContext)_localctx).head.combo, ((ArgchainContext)_localctx).tail.combo)

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
		public Nonterm nt;
		public list[Typ] combo;
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
		public PipelineContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_pipeline; }
	}

	public final PipelineContext pipeline(Nonterm nt) throws RecognitionException {
		PipelineContext _localctx = new PipelineContext(_ctx, getState(), nt);
		enterRule(_localctx, 22, RULE_pipeline);
		try {
			setState(322);
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
				setState(310);
				match(T__28);

				nt_content = self.guide_nonterm(PipelineRule(self._solver, nt).distill_single_content) 

				setState(312);
				((PipelineContext)_localctx).content = expr(nt_content);

				_localctx.combo = self.collect(PipelineRule(self._solver, nt).combine_single, ((PipelineContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(315);
				match(T__28);

				nt_head = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_head) 

				setState(317);
				((PipelineContext)_localctx).head = expr(nt_head);

				nt_tail = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_tail, ((PipelineContext)_localctx).head.combo) 

				setState(319);
				((PipelineContext)_localctx).tail = pipeline(nt_tail);

				_localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_cons, ((PipelineContext)_localctx).head.combo, ((PipelineContext)_localctx).tail.combo)

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
		public Nonterm nt;
		public list[str] combo;
		public Token ID;
		public KeychainContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public KeychainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public KeychainContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_keychain; }
	}

	public final KeychainContext keychain(Nonterm nt) throws RecognitionException {
		KeychainContext _localctx = new KeychainContext(_ctx, getState(), nt);
		enterRule(_localctx, 24, RULE_keychain);
		try {
			setState(336);
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
				setState(325);
				match(T__9);

				self.guide_terminal('ID')

				setState(327);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_single, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(329);
				match(T__9);

				self.guide_terminal('ID')

				setState(331);
				((KeychainContext)_localctx).ID = match(ID);

				nt_tail = self.guide_nonterm(KeychainRule(self._solver, nt).distill_cons_tail, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null)) 

				setState(333);
				((KeychainContext)_localctx).tail = keychain(nt_tail);

				_localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_cons, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.combo)

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
		public Nonterm nt;
		public Typ combo;
		public ExprContext expr;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TargetContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public TargetContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_target; }
	}

	public final TargetContext target(Nonterm nt) throws RecognitionException {
		TargetContext _localctx = new TargetContext(_ctx, getState(), nt);
		enterRule(_localctx, 26, RULE_target);
		try {
			setState(344);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__23:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__27:
				enterOuterAlt(_localctx, 2);
				{
				setState(339);
				match(T__27);

				nt_expr = self.guide_nonterm(lambda: nt)

				setState(341);
				((TargetContext)_localctx).expr = expr(nt_expr);

				_localctx.combo = ((TargetContext)_localctx).expr.combo

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
		public Nonterm nt;
		public PatternAttr combo;
		public Pattern_baseContext pattern_base;
		public BaseContext head;
		public BaseContext tail;
		public Pattern_baseContext pattern_base() {
			return getRuleContext(Pattern_baseContext.class,0);
		}
		public List<BaseContext> base() {
			return getRuleContexts(BaseContext.class);
		}
		public BaseContext base(int i) {
			return getRuleContext(BaseContext.class,i);
		}
		public PatternContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public PatternContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
	}

	public final PatternContext pattern(Nonterm nt) throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState(), nt);
		enterRule(_localctx, 28, RULE_pattern);
		try {
			setState(358);
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
				setState(347);
				((PatternContext)_localctx).pattern_base = pattern_base(nt);

				_localctx.combo = ((PatternContext)_localctx).pattern_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_head)

				setState(351);
				((PatternContext)_localctx).head = base(nt);

				self.guide_symbol(',')

				setState(353);
				match(T__7);

				nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_tail, ((PatternContext)_localctx).head.combo)

				setState(355);
				((PatternContext)_localctx).tail = base(nt);

				_localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, ((PatternContext)_localctx).head.combo, ((PatternContext)_localctx).tail.combo) 

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
	public static class Pattern_baseContext extends ParserRuleContext {
		public Nonterm nt;
		public PatternAttr combo;
		public Token ID;
		public PatternContext body;
		public Pattern_recordContext pattern_record;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public Pattern_recordContext pattern_record() {
			return getRuleContext(Pattern_recordContext.class,0);
		}
		public Pattern_baseContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Pattern_baseContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_pattern_base; }
	}

	public final Pattern_baseContext pattern_base(Nonterm nt) throws RecognitionException {
		Pattern_baseContext _localctx = new Pattern_baseContext(_ctx, getState(), nt);
		enterRule(_localctx, 30, RULE_pattern_base);
		try {
			setState(377);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,15,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(361);
				((Pattern_baseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(363);
				((Pattern_baseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(365);
				match(T__0);

				_localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_unit)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(367);
				match(T__1);

				self.guide_terminal('ID')

				setState(369);
				((Pattern_baseContext)_localctx).ID = match(ID);

				nt_body = self.guide_nonterm(PatternBaseRule(self._solver, nt).distill_tag_body, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				setState(371);
				((Pattern_baseContext)_localctx).body = pattern(nt_body);

				_localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_tag, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null), ((Pattern_baseContext)_localctx).body.combo)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(374);
				((Pattern_baseContext)_localctx).pattern_record = pattern_record(nt);

				_localctx.combo = ((Pattern_baseContext)_localctx).pattern_record.combo

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
	public static class Pattern_recordContext extends ParserRuleContext {
		public Nonterm nt;
		public PatternAttr combo;
		public Token ID;
		public PatternContext body;
		public Pattern_recordContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public Pattern_recordContext pattern_record() {
			return getRuleContext(Pattern_recordContext.class,0);
		}
		public Pattern_recordContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Pattern_recordContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_pattern_record; }
	}

	public final Pattern_recordContext pattern_record(Nonterm nt) throws RecognitionException {
		Pattern_recordContext _localctx = new Pattern_recordContext(_ctx, getState(), nt);
		enterRule(_localctx, 32, RULE_pattern_record);
		try {
			setState(400);
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
				setState(380);
				match(T__1);

				self.guide_terminal('ID')

				setState(382);
				((Pattern_recordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(384);
				match(T__27);

				nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_single_body, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null))

				setState(386);
				((Pattern_recordContext)_localctx).body = pattern(nt_body);

				_localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_single, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(389);
				match(T__1);

				self.guide_terminal('ID')

				setState(391);
				((Pattern_recordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(393);
				match(T__27);

				nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_body, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null))

				setState(395);
				((Pattern_recordContext)_localctx).body = pattern(nt_body);

				nt_tail = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_tail, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo)

				setState(397);
				((Pattern_recordContext)_localctx).tail = pattern_record(nt_tail);

				_localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_cons, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo, ((Pattern_recordContext)_localctx).tail.combo)

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
		"\u0004\u0001 \u0193\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004\u0002"+
		"\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007\u0002"+
		"\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b\u0007\u000b\u0002"+
		"\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0002\u000f\u0007\u000f"+
		"\u0002\u0010\u0007\u0010\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u0000*\b\u0000\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0003\u0001@\b\u0001\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0003\u0002"+
		"z\b\u0002\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0003\u0003\u0087\b\u0003\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0003\u0004\u008f\b\u0004\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0003\u0005\u0096\b\u0005\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0003\u0006\u00d7\b\u0006\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0003\u0007\u00f3\b\u0007\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0003\b\u010a\b\b\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0003\t\u0121\b\t\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0003\n\u0134\b\n\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0003\u000b\u0143"+
		"\b\u000b\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001"+
		"\f\u0001\f\u0001\f\u0001\f\u0001\f\u0003\f\u0151\b\f\u0001\r\u0001\r\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0003\r\u0159\b\r\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0003\u000e\u0167\b\u000e\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0003\u000f\u017a"+
		"\b\u000f\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0003\u0010\u0191\b\u0010\u0001"+
		"\u0010\u0000\u0000\u0011\u0000\u0002\u0004\u0006\b\n\f\u000e\u0010\u0012"+
		"\u0014\u0016\u0018\u001a\u001c\u001e \u0000\u0000\u01b9\u0000)\u0001\u0000"+
		"\u0000\u0000\u0002?\u0001\u0000\u0000\u0000\u0004y\u0001\u0000\u0000\u0000"+
		"\u0006\u0086\u0001\u0000\u0000\u0000\b\u008e\u0001\u0000\u0000\u0000\n"+
		"\u0095\u0001\u0000\u0000\u0000\f\u00d6\u0001\u0000\u0000\u0000\u000e\u00f2"+
		"\u0001\u0000\u0000\u0000\u0010\u0109\u0001\u0000\u0000\u0000\u0012\u0120"+
		"\u0001\u0000\u0000\u0000\u0014\u0133\u0001\u0000\u0000\u0000\u0016\u0142"+
		"\u0001\u0000\u0000\u0000\u0018\u0150\u0001\u0000\u0000\u0000\u001a\u0158"+
		"\u0001\u0000\u0000\u0000\u001c\u0166\u0001\u0000\u0000\u0000\u001e\u0179"+
		"\u0001\u0000\u0000\u0000 \u0190\u0001\u0000\u0000\u0000\"*\u0001\u0000"+
		"\u0000\u0000#$\u0005\u001e\u0000\u0000$*\u0006\u0000\uffff\uffff\u0000"+
		"%&\u0005\u001e\u0000\u0000&\'\u0003\u0000\u0000\u0000\'(\u0006\u0000\uffff"+
		"\uffff\u0000(*\u0001\u0000\u0000\u0000)\"\u0001\u0000\u0000\u0000)#\u0001"+
		"\u0000\u0000\u0000)%\u0001\u0000\u0000\u0000*\u0001\u0001\u0000\u0000"+
		"\u0000+@\u0001\u0000\u0000\u0000,-\u0005\u001e\u0000\u0000-@\u0006\u0001"+
		"\uffff\uffff\u0000./\u0005\u0001\u0000\u0000/@\u0006\u0001\uffff\uffff"+
		"\u000001\u0005\u0002\u0000\u000012\u0005\u001e\u0000\u000023\u0003\u0002"+
		"\u0001\u000034\u0006\u0001\uffff\uffff\u00004@\u0001\u0000\u0000\u0000"+
		"56\u0005\u001e\u0000\u000067\u0005\u0002\u0000\u000078\u0003\u0002\u0001"+
		"\u000089\u0006\u0001\uffff\uffff\u00009@\u0001\u0000\u0000\u0000:;\u0005"+
		"\u0003\u0000\u0000;<\u0003\u0004\u0002\u0000<=\u0005\u0004\u0000\u0000"+
		"=>\u0006\u0001\uffff\uffff\u0000>@\u0001\u0000\u0000\u0000?+\u0001\u0000"+
		"\u0000\u0000?,\u0001\u0000\u0000\u0000?.\u0001\u0000\u0000\u0000?0\u0001"+
		"\u0000\u0000\u0000?5\u0001\u0000\u0000\u0000?:\u0001\u0000\u0000\u0000"+
		"@\u0003\u0001\u0000\u0000\u0000Az\u0001\u0000\u0000\u0000BC\u0003\u0002"+
		"\u0001\u0000CD\u0006\u0002\uffff\uffff\u0000Dz\u0001\u0000\u0000\u0000"+
		"EF\u0003\u0002\u0001\u0000FG\u0005\u0005\u0000\u0000GH\u0003\u0004\u0002"+
		"\u0000HI\u0006\u0002\uffff\uffff\u0000Iz\u0001\u0000\u0000\u0000JK\u0003"+
		"\u0002\u0001\u0000KL\u0005\u0006\u0000\u0000LM\u0003\u0004\u0002\u0000"+
		"MN\u0006\u0002\uffff\uffff\u0000Nz\u0001\u0000\u0000\u0000OP\u0003\u0002"+
		"\u0001\u0000PQ\u0003\u0006\u0003\u0000QR\u0006\u0002\uffff\uffff\u0000"+
		"Rz\u0001\u0000\u0000\u0000ST\u0003\u0002\u0001\u0000TU\u0005\u0007\u0000"+
		"\u0000UV\u0003\u0004\u0002\u0000VW\u0006\u0002\uffff\uffff\u0000Wz\u0001"+
		"\u0000\u0000\u0000XY\u0003\u0002\u0001\u0000YZ\u0005\b\u0000\u0000Z[\u0003"+
		"\u0004\u0002\u0000[\\\u0006\u0002\uffff\uffff\u0000\\z\u0001\u0000\u0000"+
		"\u0000]^\u0005\t\u0000\u0000^_\u0003\u0000\u0000\u0000_`\u0005\n\u0000"+
		"\u0000`a\u0003\b\u0004\u0000ab\u0005\u000b\u0000\u0000bc\u0003\u0004\u0002"+
		"\u0000cd\u0006\u0002\uffff\uffff\u0000dz\u0001\u0000\u0000\u0000ef\u0005"+
		"\f\u0000\u0000fg\u0003\u0000\u0000\u0000gh\u0005\n\u0000\u0000hi\u0003"+
		"\b\u0004\u0000ij\u0005\r\u0000\u0000jk\u0003\u0004\u0002\u0000kl\u0006"+
		"\u0002\uffff\uffff\u0000lz\u0001\u0000\u0000\u0000mn\u0005\u000e\u0000"+
		"\u0000no\u0005\u001e\u0000\u0000op\u0005\u000f\u0000\u0000pq\u0003\u0004"+
		"\u0002\u0000qr\u0006\u0002\uffff\uffff\u0000rz\u0001\u0000\u0000\u0000"+
		"st\u0005\u0010\u0000\u0000tu\u0005\u001e\u0000\u0000uv\u0005\u0011\u0000"+
		"\u0000vw\u0003\u0004\u0002\u0000wx\u0006\u0002\uffff\uffff\u0000xz\u0001"+
		"\u0000\u0000\u0000yA\u0001\u0000\u0000\u0000yB\u0001\u0000\u0000\u0000"+
		"yE\u0001\u0000\u0000\u0000yJ\u0001\u0000\u0000\u0000yO\u0001\u0000\u0000"+
		"\u0000yS\u0001\u0000\u0000\u0000yX\u0001\u0000\u0000\u0000y]\u0001\u0000"+
		"\u0000\u0000ye\u0001\u0000\u0000\u0000ym\u0001\u0000\u0000\u0000ys\u0001"+
		"\u0000\u0000\u0000z\u0005\u0001\u0000\u0000\u0000{\u0087\u0001\u0000\u0000"+
		"\u0000|}\u0005\u0012\u0000\u0000}~\u0003\u0004\u0002\u0000~\u007f\u0006"+
		"\u0003\uffff\uffff\u0000\u007f\u0087\u0001\u0000\u0000\u0000\u0080\u0081"+
		"\u0005\u0012\u0000\u0000\u0081\u0082\u0003\u0004\u0002\u0000\u0082\u0083"+
		"\u0006\u0003\uffff\uffff\u0000\u0083\u0084\u0003\u0006\u0003\u0000\u0084"+
		"\u0085\u0006\u0003\uffff\uffff\u0000\u0085\u0087\u0001\u0000\u0000\u0000"+
		"\u0086{\u0001\u0000\u0000\u0000\u0086|\u0001\u0000\u0000\u0000\u0086\u0080"+
		"\u0001\u0000\u0000\u0000\u0087\u0007\u0001\u0000\u0000\u0000\u0088\u008f"+
		"\u0001\u0000\u0000\u0000\u0089\u008f\u0003\n\u0005\u0000\u008a\u008b\u0003"+
		"\n\u0005\u0000\u008b\u008c\u0005\b\u0000\u0000\u008c\u008d\u0003\b\u0004"+
		"\u0000\u008d\u008f\u0001\u0000\u0000\u0000\u008e\u0088\u0001\u0000\u0000"+
		"\u0000\u008e\u0089\u0001\u0000\u0000\u0000\u008e\u008a\u0001\u0000\u0000"+
		"\u0000\u008f\t\u0001\u0000\u0000\u0000\u0090\u0096\u0001\u0000\u0000\u0000"+
		"\u0091\u0092\u0003\u0004\u0002\u0000\u0092\u0093\u0005\u0013\u0000\u0000"+
		"\u0093\u0094\u0003\u0004\u0002\u0000\u0094\u0096\u0001\u0000\u0000\u0000"+
		"\u0095\u0090\u0001\u0000\u0000\u0000\u0095\u0091\u0001\u0000\u0000\u0000"+
		"\u0096\u000b\u0001\u0000\u0000\u0000\u0097\u00d7\u0001\u0000\u0000\u0000"+
		"\u0098\u0099\u0003\u000e\u0007\u0000\u0099\u009a\u0006\u0006\uffff\uffff"+
		"\u0000\u009a\u00d7\u0001\u0000\u0000\u0000\u009b\u009c\u0006\u0006\uffff"+
		"\uffff\u0000\u009c\u009d\u0003\u000e\u0007\u0000\u009d\u009e\u0006\u0006"+
		"\uffff\uffff\u0000\u009e\u009f\u0005\b\u0000\u0000\u009f\u00a0\u0006\u0006"+
		"\uffff\uffff\u0000\u00a0\u00a1\u0003\u000e\u0007\u0000\u00a1\u00a2\u0006"+
		"\u0006\uffff\uffff\u0000\u00a2\u00d7\u0001\u0000\u0000\u0000\u00a3\u00a4"+
		"\u0005\u0014\u0000\u0000\u00a4\u00a5\u0006\u0006\uffff\uffff\u0000\u00a5"+
		"\u00a6\u0003\f\u0006\u0000\u00a6\u00a7\u0006\u0006\uffff\uffff\u0000\u00a7"+
		"\u00a8\u0005\u0015\u0000\u0000\u00a8\u00a9\u0006\u0006\uffff\uffff\u0000"+
		"\u00a9\u00aa\u0003\f\u0006\u0000\u00aa\u00ab\u0006\u0006\uffff\uffff\u0000"+
		"\u00ab\u00ac\u0005\u0016\u0000\u0000\u00ac\u00ad\u0006\u0006\uffff\uffff"+
		"\u0000\u00ad\u00ae\u0003\f\u0006\u0000\u00ae\u00af\u0006\u0006\uffff\uffff"+
		"\u0000\u00af\u00d7\u0001\u0000\u0000\u0000\u00b0\u00b1\u0006\u0006\uffff"+
		"\uffff\u0000\u00b1\u00b2\u0003\u000e\u0007\u0000\u00b2\u00b3\u0006\u0006"+
		"\uffff\uffff\u0000\u00b3\u00b4\u0003\u0018\f\u0000\u00b4\u00b5\u0006\u0006"+
		"\uffff\uffff\u0000\u00b5\u00d7\u0001\u0000\u0000\u0000\u00b6\u00b7\u0006"+
		"\u0006\uffff\uffff\u0000\u00b7\u00b8\u0003\u000e\u0007\u0000\u00b8\u00b9"+
		"\u0006\u0006\uffff\uffff\u0000\u00b9\u00ba\u0003\u0014\n\u0000\u00ba\u00bb"+
		"\u0006\u0006\uffff\uffff\u0000\u00bb\u00d7\u0001\u0000\u0000\u0000\u00bc"+
		"\u00bd\u0006\u0006\uffff\uffff\u0000\u00bd\u00be\u0003\u000e\u0007\u0000"+
		"\u00be\u00bf\u0006\u0006\uffff\uffff\u0000\u00bf\u00c0\u0003\u0016\u000b"+
		"\u0000\u00c0\u00c1\u0006\u0006\uffff\uffff\u0000\u00c1\u00d7\u0001\u0000"+
		"\u0000\u0000\u00c2\u00c3\u0005\u0017\u0000\u0000\u00c3\u00c4\u0006\u0006"+
		"\uffff\uffff\u0000\u00c4\u00c5\u0005\u001e\u0000\u0000\u00c5\u00c6\u0006"+
		"\u0006\uffff\uffff\u0000\u00c6\u00c7\u0003\u001a\r\u0000\u00c7\u00c8\u0006"+
		"\u0006\uffff\uffff\u0000\u00c8\u00c9\u0005\u0018\u0000\u0000\u00c9\u00ca"+
		"\u0006\u0006\uffff\uffff\u0000\u00ca\u00cb\u0003\f\u0006\u0000\u00cb\u00cc"+
		"\u0006\u0006\uffff\uffff\u0000\u00cc\u00d7\u0001\u0000\u0000\u0000\u00cd"+
		"\u00ce\u0005\u0019\u0000\u0000\u00ce\u00cf\u0006\u0006\uffff\uffff\u0000"+
		"\u00cf\u00d0\u0005\u0003\u0000\u0000\u00d0\u00d1\u0006\u0006\uffff\uffff"+
		"\u0000\u00d1\u00d2\u0003\f\u0006\u0000\u00d2\u00d3\u0006\u0006\uffff\uffff"+
		"\u0000\u00d3\u00d4\u0005\u0004\u0000\u0000\u00d4\u00d5\u0006\u0006\uffff"+
		"\uffff\u0000\u00d5\u00d7\u0001\u0000\u0000\u0000\u00d6\u0097\u0001\u0000"+
		"\u0000\u0000\u00d6\u0098\u0001\u0000\u0000\u0000\u00d6\u009b\u0001\u0000"+
		"\u0000\u0000\u00d6\u00a3\u0001\u0000\u0000\u0000\u00d6\u00b0\u0001\u0000"+
		"\u0000\u0000\u00d6\u00b6\u0001\u0000\u0000\u0000\u00d6\u00bc\u0001\u0000"+
		"\u0000\u0000\u00d6\u00c2\u0001\u0000\u0000\u0000\u00d6\u00cd\u0001\u0000"+
		"\u0000\u0000\u00d7\r\u0001\u0000\u0000\u0000\u00d8\u00f3\u0001\u0000\u0000"+
		"\u0000\u00d9\u00da\u0005\u0001\u0000\u0000\u00da\u00f3\u0006\u0007\uffff"+
		"\uffff\u0000\u00db\u00dc\u0005\u0002\u0000\u0000\u00dc\u00dd\u0006\u0007"+
		"\uffff\uffff\u0000\u00dd\u00de\u0005\u001e\u0000\u0000\u00de\u00df\u0006"+
		"\u0007\uffff\uffff\u0000\u00df\u00e0\u0003\f\u0006\u0000\u00e0\u00e1\u0006"+
		"\u0007\uffff\uffff\u0000\u00e1\u00f3\u0001\u0000\u0000\u0000\u00e2\u00e3"+
		"\u0003\u0012\t\u0000\u00e3\u00e4\u0006\u0007\uffff\uffff\u0000\u00e4\u00f3"+
		"\u0001\u0000\u0000\u0000\u00e5\u00e6\u0006\u0007\uffff\uffff\u0000\u00e6"+
		"\u00e7\u0003\u0010\b\u0000\u00e7\u00e8\u0006\u0007\uffff\uffff\u0000\u00e8"+
		"\u00f3\u0001\u0000\u0000\u0000\u00e9\u00ea\u0005\u001e\u0000\u0000\u00ea"+
		"\u00f3\u0006\u0007\uffff\uffff\u0000\u00eb\u00ec\u0005\u0003\u0000\u0000"+
		"\u00ec\u00ed\u0006\u0007\uffff\uffff\u0000\u00ed\u00ee\u0003\f\u0006\u0000"+
		"\u00ee\u00ef\u0006\u0007\uffff\uffff\u0000\u00ef\u00f0\u0005\u0004\u0000"+
		"\u0000\u00f0\u00f1\u0006\u0007\uffff\uffff\u0000\u00f1\u00f3\u0001\u0000"+
		"\u0000\u0000\u00f2\u00d8\u0001\u0000\u0000\u0000\u00f2\u00d9\u0001\u0000"+
		"\u0000\u0000\u00f2\u00db\u0001\u0000\u0000\u0000\u00f2\u00e2\u0001\u0000"+
		"\u0000\u0000\u00f2\u00e5\u0001\u0000\u0000\u0000\u00f2\u00e9\u0001\u0000"+
		"\u0000\u0000\u00f2\u00eb\u0001\u0000\u0000\u0000\u00f3\u000f\u0001\u0000"+
		"\u0000\u0000\u00f4\u010a\u0001\u0000\u0000\u0000\u00f5\u00f6\u0005\u001a"+
		"\u0000\u0000\u00f6\u00f7\u0006\b\uffff\uffff\u0000\u00f7\u00f8\u0003\u001c"+
		"\u000e\u0000\u00f8\u00f9\u0006\b\uffff\uffff\u0000\u00f9\u00fa\u0005\u001b"+
		"\u0000\u0000\u00fa\u00fb\u0006\b\uffff\uffff\u0000\u00fb\u00fc\u0003\f"+
		"\u0006\u0000\u00fc\u00fd\u0006\b\uffff\uffff\u0000\u00fd\u010a\u0001\u0000"+
		"\u0000\u0000\u00fe\u00ff\u0005\u001a\u0000\u0000\u00ff\u0100\u0006\b\uffff"+
		"\uffff\u0000\u0100\u0101\u0003\u001c\u000e\u0000\u0101\u0102\u0006\b\uffff"+
		"\uffff\u0000\u0102\u0103\u0005\u001b\u0000\u0000\u0103\u0104\u0006\b\uffff"+
		"\uffff\u0000\u0104\u0105\u0003\f\u0006\u0000\u0105\u0106\u0006\b\uffff"+
		"\uffff\u0000\u0106\u0107\u0003\u0010\b\u0000\u0107\u0108\u0006\b\uffff"+
		"\uffff\u0000\u0108\u010a\u0001\u0000\u0000\u0000\u0109\u00f4\u0001\u0000"+
		"\u0000\u0000\u0109\u00f5\u0001\u0000\u0000\u0000\u0109\u00fe\u0001\u0000"+
		"\u0000\u0000\u010a\u0011\u0001\u0000\u0000\u0000\u010b\u0121\u0001\u0000"+
		"\u0000\u0000\u010c\u010d\u0005\u0002\u0000\u0000\u010d\u010e\u0006\t\uffff"+
		"\uffff\u0000\u010e\u010f\u0005\u001e\u0000\u0000\u010f\u0110\u0006\t\uffff"+
		"\uffff\u0000\u0110\u0111\u0005\u001c\u0000\u0000\u0111\u0112\u0006\t\uffff"+
		"\uffff\u0000\u0112\u0113\u0003\f\u0006\u0000\u0113\u0114\u0006\t\uffff"+
		"\uffff\u0000\u0114\u0121\u0001\u0000\u0000\u0000\u0115\u0116\u0005\u0002"+
		"\u0000\u0000\u0116\u0117\u0006\t\uffff\uffff\u0000\u0117\u0118\u0005\u001e"+
		"\u0000\u0000\u0118\u0119\u0006\t\uffff\uffff\u0000\u0119\u011a\u0005\u001c"+
		"\u0000\u0000\u011a\u011b\u0006\t\uffff\uffff\u0000\u011b\u011c\u0003\f"+
		"\u0006\u0000\u011c\u011d\u0006\t\uffff\uffff\u0000\u011d\u011e\u0003\u0012"+
		"\t\u0000\u011e\u011f\u0006\t\uffff\uffff\u0000\u011f\u0121\u0001\u0000"+
		"\u0000\u0000\u0120\u010b\u0001\u0000\u0000\u0000\u0120\u010c\u0001\u0000"+
		"\u0000\u0000\u0120\u0115\u0001\u0000\u0000\u0000\u0121\u0013\u0001\u0000"+
		"\u0000\u0000\u0122\u0134\u0001\u0000\u0000\u0000\u0123\u0124\u0005\u0003"+
		"\u0000\u0000\u0124\u0125\u0006\n\uffff\uffff\u0000\u0125\u0126\u0003\f"+
		"\u0006\u0000\u0126\u0127\u0006\n\uffff\uffff\u0000\u0127\u0128\u0005\u0004"+
		"\u0000\u0000\u0128\u0129\u0006\n\uffff\uffff\u0000\u0129\u0134\u0001\u0000"+
		"\u0000\u0000\u012a\u012b\u0005\u0003\u0000\u0000\u012b\u012c\u0006\n\uffff"+
		"\uffff\u0000\u012c\u012d\u0003\f\u0006\u0000\u012d\u012e\u0006\n\uffff"+
		"\uffff\u0000\u012e\u012f\u0005\u0004\u0000\u0000\u012f\u0130\u0006\n\uffff"+
		"\uffff\u0000\u0130\u0131\u0003\u0014\n\u0000\u0131\u0132\u0006\n\uffff"+
		"\uffff\u0000\u0132\u0134\u0001\u0000\u0000\u0000\u0133\u0122\u0001\u0000"+
		"\u0000\u0000\u0133\u0123\u0001\u0000\u0000\u0000\u0133\u012a\u0001\u0000"+
		"\u0000\u0000\u0134\u0015\u0001\u0000\u0000\u0000\u0135\u0143\u0001\u0000"+
		"\u0000\u0000\u0136\u0137\u0005\u001d\u0000\u0000\u0137\u0138\u0006\u000b"+
		"\uffff\uffff\u0000\u0138\u0139\u0003\f\u0006\u0000\u0139\u013a\u0006\u000b"+
		"\uffff\uffff\u0000\u013a\u0143\u0001\u0000\u0000\u0000\u013b\u013c\u0005"+
		"\u001d\u0000\u0000\u013c\u013d\u0006\u000b\uffff\uffff\u0000\u013d\u013e"+
		"\u0003\f\u0006\u0000\u013e\u013f\u0006\u000b\uffff\uffff\u0000\u013f\u0140"+
		"\u0003\u0016\u000b\u0000\u0140\u0141\u0006\u000b\uffff\uffff\u0000\u0141"+
		"\u0143\u0001\u0000\u0000\u0000\u0142\u0135\u0001\u0000\u0000\u0000\u0142"+
		"\u0136\u0001\u0000\u0000\u0000\u0142\u013b\u0001\u0000\u0000\u0000\u0143"+
		"\u0017\u0001\u0000\u0000\u0000\u0144\u0151\u0001\u0000\u0000\u0000\u0145"+
		"\u0146\u0005\n\u0000\u0000\u0146\u0147\u0006\f\uffff\uffff\u0000\u0147"+
		"\u0148\u0005\u001e\u0000\u0000\u0148\u0151\u0006\f\uffff\uffff\u0000\u0149"+
		"\u014a\u0005\n\u0000\u0000\u014a\u014b\u0006\f\uffff\uffff\u0000\u014b"+
		"\u014c\u0005\u001e\u0000\u0000\u014c\u014d\u0006\f\uffff\uffff\u0000\u014d"+
		"\u014e\u0003\u0018\f\u0000\u014e\u014f\u0006\f\uffff\uffff\u0000\u014f"+
		"\u0151\u0001\u0000\u0000\u0000\u0150\u0144\u0001\u0000\u0000\u0000\u0150"+
		"\u0145\u0001\u0000\u0000\u0000\u0150\u0149\u0001\u0000\u0000\u0000\u0151"+
		"\u0019\u0001\u0000\u0000\u0000\u0152\u0159\u0001\u0000\u0000\u0000\u0153"+
		"\u0154\u0005\u001c\u0000\u0000\u0154\u0155\u0006\r\uffff\uffff\u0000\u0155"+
		"\u0156\u0003\f\u0006\u0000\u0156\u0157\u0006\r\uffff\uffff\u0000\u0157"+
		"\u0159\u0001\u0000\u0000\u0000\u0158\u0152\u0001\u0000\u0000\u0000\u0158"+
		"\u0153\u0001\u0000\u0000\u0000\u0159\u001b\u0001\u0000\u0000\u0000\u015a"+
		"\u0167\u0001\u0000\u0000\u0000\u015b\u015c\u0003\u001e\u000f\u0000\u015c"+
		"\u015d\u0006\u000e\uffff\uffff\u0000\u015d\u0167\u0001\u0000\u0000\u0000"+
		"\u015e\u015f\u0006\u000e\uffff\uffff\u0000\u015f\u0160\u0003\u000e\u0007"+
		"\u0000\u0160\u0161\u0006\u000e\uffff\uffff\u0000\u0161\u0162\u0005\b\u0000"+
		"\u0000\u0162\u0163\u0006\u000e\uffff\uffff\u0000\u0163\u0164\u0003\u000e"+
		"\u0007\u0000\u0164\u0165\u0006\u000e\uffff\uffff\u0000\u0165\u0167\u0001"+
		"\u0000\u0000\u0000\u0166\u015a\u0001\u0000\u0000\u0000\u0166\u015b\u0001"+
		"\u0000\u0000\u0000\u0166\u015e\u0001\u0000\u0000\u0000\u0167\u001d\u0001"+
		"\u0000\u0000\u0000\u0168\u017a\u0001\u0000\u0000\u0000\u0169\u016a\u0005"+
		"\u001e\u0000\u0000\u016a\u017a\u0006\u000f\uffff\uffff\u0000\u016b\u016c"+
		"\u0005\u001e\u0000\u0000\u016c\u017a\u0006\u000f\uffff\uffff\u0000\u016d"+
		"\u016e\u0005\u0001\u0000\u0000\u016e\u017a\u0006\u000f\uffff\uffff\u0000"+
		"\u016f\u0170\u0005\u0002\u0000\u0000\u0170\u0171\u0006\u000f\uffff\uffff"+
		"\u0000\u0171\u0172\u0005\u001e\u0000\u0000\u0172\u0173\u0006\u000f\uffff"+
		"\uffff\u0000\u0173\u0174\u0003\u001c\u000e\u0000\u0174\u0175\u0006\u000f"+
		"\uffff\uffff\u0000\u0175\u017a\u0001\u0000\u0000\u0000\u0176\u0177\u0003"+
		" \u0010\u0000\u0177\u0178\u0006\u000f\uffff\uffff\u0000\u0178\u017a\u0001"+
		"\u0000\u0000\u0000\u0179\u0168\u0001\u0000\u0000\u0000\u0179\u0169\u0001"+
		"\u0000\u0000\u0000\u0179\u016b\u0001\u0000\u0000\u0000\u0179\u016d\u0001"+
		"\u0000\u0000\u0000\u0179\u016f\u0001\u0000\u0000\u0000\u0179\u0176\u0001"+
		"\u0000\u0000\u0000\u017a\u001f\u0001\u0000\u0000\u0000\u017b\u0191\u0001"+
		"\u0000\u0000\u0000\u017c\u017d\u0005\u0002\u0000\u0000\u017d\u017e\u0006"+
		"\u0010\uffff\uffff\u0000\u017e\u017f\u0005\u001e\u0000\u0000\u017f\u0180"+
		"\u0006\u0010\uffff\uffff\u0000\u0180\u0181\u0005\u001c\u0000\u0000\u0181"+
		"\u0182\u0006\u0010\uffff\uffff\u0000\u0182\u0183\u0003\u001c\u000e\u0000"+
		"\u0183\u0184\u0006\u0010\uffff\uffff\u0000\u0184\u0191\u0001\u0000\u0000"+
		"\u0000\u0185\u0186\u0005\u0002\u0000\u0000\u0186\u0187\u0006\u0010\uffff"+
		"\uffff\u0000\u0187\u0188\u0005\u001e\u0000\u0000\u0188\u0189\u0006\u0010"+
		"\uffff\uffff\u0000\u0189\u018a\u0005\u001c\u0000\u0000\u018a\u018b\u0006"+
		"\u0010\uffff\uffff\u0000\u018b\u018c\u0003\u001c\u000e\u0000\u018c\u018d"+
		"\u0006\u0010\uffff\uffff\u0000\u018d\u018e\u0003 \u0010\u0000\u018e\u018f"+
		"\u0006\u0010\uffff\uffff\u0000\u018f\u0191\u0001\u0000\u0000\u0000\u0190"+
		"\u017b\u0001\u0000\u0000\u0000\u0190\u017c\u0001\u0000\u0000\u0000\u0190"+
		"\u0185\u0001\u0000\u0000\u0000\u0191!\u0001\u0000\u0000\u0000\u0011)?"+
		"y\u0086\u008e\u0095\u00d6\u00f2\u0109\u0120\u0133\u0142\u0150\u0158\u0166"+
		"\u0179\u0190";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}