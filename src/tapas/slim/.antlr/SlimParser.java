// Generated from /Users/thomas/tlogan@github.com/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

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
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, ID=31, INT=32, 
		WS=33;
	public static final int
		RULE_ids = 0, RULE_typ_base = 1, RULE_typ = 2, RULE_negchain = 3, RULE_qualification = 4, 
		RULE_subtyping = 5, RULE_expr = 6, RULE_base = 7, RULE_function = 8, RULE_record = 9, 
		RULE_argchain = 10, RULE_pipeline = 11, RULE_keychain = 12, RULE_target = 13, 
		RULE_pattern = 14, RULE_base_pattern = 15, RULE_record_pattern = 16;
	private static String[] makeRuleNames() {
		return new String[] {
			"ids", "typ_base", "typ", "negchain", "qualification", "subtyping", "expr", 
			"base", "function", "record", "argchain", "pipeline", "keychain", "target", 
			"pattern", "base_pattern", "record_pattern"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'TOP'", "'BOT'", "'@'", "'~'", "':'", "'('", "')'", "'|'", "'&'", 
			"'->'", "','", "'EXI'", "'['", "']'", "'ALL'", "'LFP'", "'\\'", "';'", 
			"'<:'", "'if'", "'then'", "'else'", "'let'", "'fix'", "'case'", "'=>'", 
			"'_.'", "'='", "'|>'", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, "ID", "INT", "WS"
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
	    self._solver = default_solver 
	    self._cache = {}
	    self._guidance = default_nonterm 
	    self._overflow = False  

	def reset(self): 
	    self._guidance = default_nonterm
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

				_localctx.combo = tuple([(((IdsContext)_localctx).ID!=null?((IdsContext)_localctx).ID.getText():null)])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(37);
				((IdsContext)_localctx).ID = match(ID);
				setState(38);
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
			setState(67);
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
				match(T__0);

				_localctx.combo = Top() 

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(46);
				match(T__1);

				_localctx.combo = Bot() 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(48);
				((Typ_baseContext)_localctx).ID = match(ID);

				_localctx.combo = TVar((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null)) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(50);
				match(T__2);

				_localctx.combo = TUnit() 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(52);
				match(T__3);
				setState(53);
				((Typ_baseContext)_localctx).ID = match(ID);
				setState(54);
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TTag((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(57);
				((Typ_baseContext)_localctx).ID = match(ID);
				setState(58);
				match(T__4);
				setState(59);
				((Typ_baseContext)_localctx).typ_base = typ_base();

				_localctx.combo = TField((((Typ_baseContext)_localctx).ID!=null?((Typ_baseContext)_localctx).ID.getText():null), ((Typ_baseContext)_localctx).typ_base.combo) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(62);
				match(T__5);
				setState(63);
				((Typ_baseContext)_localctx).typ = typ();
				setState(64);
				match(T__6);

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
			setState(132);
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
				setState(70);
				((TypContext)_localctx).typ_base = typ_base();

				_localctx.combo = ((TypContext)_localctx).typ_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(73);
				((TypContext)_localctx).typ_base = typ_base();
				setState(74);
				match(T__7);
				setState(75);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Unio(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(78);
				((TypContext)_localctx).typ_base = typ_base();
				setState(79);
				match(T__8);
				setState(80);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(83);
				((TypContext)_localctx).context = typ_base();
				setState(84);
				((TypContext)_localctx).acc = negchain(((TypContext)_localctx).context.combo);

				_localctx.combo = ((TypContext)_localctx).acc.combo 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(87);
				((TypContext)_localctx).typ_base = typ_base();
				setState(88);
				match(T__9);
				setState(89);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Imp(((TypContext)_localctx).typ_base.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(92);
				((TypContext)_localctx).typ_base = typ_base();
				setState(93);
				match(T__10);
				setState(94);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Inter(TField('head', ((TypContext)_localctx).typ_base.combo), TField('tail', ((TypContext)_localctx).typ.combo)) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(97);
				match(T__11);
				setState(98);
				match(T__12);
				setState(99);
				((TypContext)_localctx).ids = ids();
				setState(100);
				match(T__13);
				setState(101);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi(((TypContext)_localctx).ids.combo, (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(104);
				match(T__11);
				setState(105);
				match(T__12);
				setState(106);
				((TypContext)_localctx).ids = ids();
				setState(107);
				((TypContext)_localctx).qualification = qualification();
				setState(108);
				match(T__13);
				setState(109);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = Exi(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(112);
				match(T__14);
				setState(113);
				match(T__12);
				setState(114);
				((TypContext)_localctx).ids = ids();
				setState(115);
				match(T__13);
				setState(116);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All(((TypContext)_localctx).ids.combo, (), ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(119);
				match(T__14);
				setState(120);
				match(T__12);
				setState(121);
				((TypContext)_localctx).ids = ids();
				setState(122);
				((TypContext)_localctx).qualification = qualification();
				setState(123);
				match(T__13);
				setState(124);
				((TypContext)_localctx).typ = typ();

				_localctx.combo = All(((TypContext)_localctx).ids.combo, ((TypContext)_localctx).qualification.combo, ((TypContext)_localctx).typ.combo) 

				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(127);
				match(T__15);
				setState(128);
				((TypContext)_localctx).ID = match(ID);
				setState(129);
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
		enterRule(_localctx, 6, RULE_negchain);
		try {
			setState(145);
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
				setState(135);
				match(T__16);
				setState(136);
				((NegchainContext)_localctx).negation = typ();

				_localctx.combo = Diff(context, ((NegchainContext)_localctx).negation.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(139);
				match(T__16);
				setState(140);
				((NegchainContext)_localctx).negation = typ();

				context_tail = Diff(context, ((NegchainContext)_localctx).negation.combo)

				setState(142);
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
		enterRule(_localctx, 8, RULE_qualification);
		try {
			setState(157);
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
				setState(148);
				match(T__17);
				setState(149);
				((QualificationContext)_localctx).subtyping = subtyping();

				_localctx.combo = tuple([((QualificationContext)_localctx).subtyping.combo])

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(152);
				match(T__17);
				setState(153);
				((QualificationContext)_localctx).subtyping = subtyping();
				setState(154);
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
		enterRule(_localctx, 10, RULE_subtyping);
		try {
			setState(165);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__13:
			case T__17:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__5:
			case T__7:
			case T__8:
			case T__9:
			case T__10:
			case T__11:
			case T__14:
			case T__15:
			case T__16:
			case T__18:
			case ID:
				enterOuterAlt(_localctx, 2);
				{
				setState(160);
				((SubtypingContext)_localctx).strong = typ();
				setState(161);
				match(T__18);
				setState(162);
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
		public Nonterm nt;
		public list[Model] models;
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
			setState(230);
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
				setState(168);
				((ExprContext)_localctx).base = base(nt);

				_localctx.models = ((ExprContext)_localctx).base.models

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				head_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_head, nt)

				setState(172);
				((ExprContext)_localctx).head = base(head_nt);

				self.guide_symbol(',')

				setState(174);
				match(T__10);

				nt = replace(nt, models = ((ExprContext)_localctx).head.models)
				tail_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_tail, nt, head_nt.typ_var)

				setState(176);
				((ExprContext)_localctx).tail = expr(tail_nt);

				nt = replace(nt, models = ((ExprContext)_localctx).tail.models)
				_localctx.models = self.collect(ExprRule(self._solver).combine_tuple, nt, head_nt.typ_var, tail_nt.typ_var) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(179);
				match(T__19);

				condition_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_condition, nt)

				setState(181);
				((ExprContext)_localctx).condition = expr(condition_nt);

				self.guide_symbol('then')

				setState(183);
				match(T__20);

				nt = replace(nt, models = ((ExprContext)_localctx).condition.models)
				true_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_true_branch, nt, condition_nt.typ_var)

				setState(185);
				((ExprContext)_localctx).true_branch = expr(true_branch_nt);

				self.guide_symbol('else')

				setState(187);
				match(T__21);

				nt = replace(nt, models = ((ExprContext)_localctx).true_branch.models)
				false_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_false_branch, nt, condition_nt.typ_var, true_branch_nt.typ_var)

				setState(189);
				((ExprContext)_localctx).false_branch = expr(false_branch_nt);

				_localctx.models = self.collect(ExprRule(self._solver).combine_ite, nt, condition_nt.typ_var, true_branch_nt.typ_var, false_branch_nt.typ_var) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{

				rator_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_rator, nt)

				setState(193);
				((ExprContext)_localctx).rator = base(rator_nt);

				nt = replace(nt, models = ((ExprContext)_localctx).rator.models)
				keychain_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_keychain, nt, rator_nt.typ_var)

				setState(195);
				((ExprContext)_localctx).keychain = keychain(keychain_nt);

				nt = replace(nt, models = keychain_nt.models)
				_localctx.models = self.collect(ExprRule(self._solver).combine_projection, nt, rator_nt.typ_var, ((ExprContext)_localctx).keychain.keys) 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{

				cator_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_cator, nt)

				setState(199);
				((ExprContext)_localctx).cator = base(cator_nt);

				nt = replace(nt, models = ((ExprContext)_localctx).cator.models)
				argchain_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_argchain, nt, cator_nt.typ_var)

				setState(201);
				((ExprContext)_localctx).argchain = argchain(argchain_nt);

				nt = replace(nt, models = ((ExprContext)_localctx).argchain.attr.models)
				_localctx.models = self.collect(ExprRule(self._solver).combine_application, nt, cator_nt.typ_var, ((ExprContext)_localctx).argchain.attr.args)

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{

				arg_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_arg, nt)

				setState(205);
				((ExprContext)_localctx).arg = base(arg_nt);

				nt = replace(nt, models = ((ExprContext)_localctx).arg.models)
				pipeline_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_pipeline, nt, arg_nt.typ_var)

				setState(207);
				((ExprContext)_localctx).pipeline = pipeline(pipeline_nt);

				nt = replace(nt, models = pipeline_nt.models)
				_localctx.models = self.collect(ExprRule(self._solver).combine_funnel, nt, arg_nt.typ_var, ((ExprContext)_localctx).pipeline.cator_vars)

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(210);
				match(T__22);

				self.guide_terminal('ID')

				setState(212);
				((ExprContext)_localctx).ID = match(ID);


				target_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_target, nt, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))


				setState(214);
				((ExprContext)_localctx).target = target(target_nt);

				self.guide_symbol(';')

				setState(216);
				match(T__17);

				nt = replace(nt, models = ((ExprContext)_localctx).target.models)

				contin_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_contin, nt, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), target_nt.typ_var)


				setState(218);
				((ExprContext)_localctx).contin = expr(contin_nt);


				_localctx.models = ((ExprContext)_localctx).contin.models

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(221);
				match(T__23);

				self.guide_symbol('(')

				setState(223);
				match(T__5);

				body_nt = self.guide_nonterm(ExprRule(self._solver).distill_fix_body, nt)

				setState(225);
				((ExprContext)_localctx).body = expr(body_nt);

				self.guide_symbol(')')

				setState(227);
				match(T__6);

				nt = replace(nt, models = ((ExprContext)_localctx).body.models)
				_localctx.models = self.collect(ExprRule(self._solver).combine_fix, nt, body_nt.typ_var)

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
		public list[Model] models;
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
			setState(254);
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
				setState(233);
				match(T__2);

				_localctx.models = self.collect(BaseRule(self._solver).combine_unit, nt)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(235);
				match(T__3);

				self.guide_terminal('ID')

				setState(237);
				((BaseContext)_localctx).ID = match(ID);

				body_nt = self.guide_nonterm(BaseRule(self._solver).distill_tag_body, nt, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				setState(239);
				((BaseContext)_localctx).body = base(body_nt);

				nt = replace(nt, models = ((BaseContext)_localctx).body.models)
				_localctx.models = self.collect(BaseRule(self._solver).combine_tag, nt, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null), body_nt.typ_var)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(242);
				((BaseContext)_localctx).record = record(nt);

				_localctx.models = ((BaseContext)_localctx).record.models

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{


				setState(246);
				((BaseContext)_localctx).function = function(nt);

				branches = ((BaseContext)_localctx).function.branches
				_localctx.models = self.collect(BaseRule(self._solver).combine_function, nt, branches)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(249);
				((BaseContext)_localctx).ID = match(ID);

				_localctx.models = self.collect(BaseRule(self._solver).combine_var, nt, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(251);
				((BaseContext)_localctx).argchain = argchain(nt);

				nt = replace(nt, models = ((BaseContext)_localctx).argchain.attr.models)
				_localctx.models = self.collect(BaseRule(self._solver).combine_assoc, nt, ((BaseContext)_localctx).argchain.attr.args)

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
			setState(277);
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
				setState(257);
				match(T__24);


				setState(259);
				((FunctionContext)_localctx).pattern = pattern(nt);

				self.guide_symbol('=>')

				setState(261);
				match(T__25);

				body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_body, nt, ((FunctionContext)_localctx).pattern.attr)

				setState(263);
				((FunctionContext)_localctx).body = expr(body_nt);

				_localctx.branches = self.collect(FunctionRule(self._solver).combine_single, nt, ((FunctionContext)_localctx).pattern.attr.typ, ((FunctionContext)_localctx).body.models, body_nt.typ_var)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(266);
				match(T__24);


				setState(268);
				((FunctionContext)_localctx).pattern = pattern(nt);

				self.guide_symbol('=>')

				setState(270);
				match(T__25);

				body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_body, nt, ((FunctionContext)_localctx).pattern.attr)

				setState(272);
				((FunctionContext)_localctx).body = expr(body_nt);

				tail_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_tail, nt, ((FunctionContext)_localctx).pattern.attr.typ, body_nt.typ_var)

				setState(274);
				((FunctionContext)_localctx).tail = function(tail_nt);

				tail_branches = ((FunctionContext)_localctx).tail.branches
				_localctx.branches = self.collect(FunctionRule(self._solver).combine_cons, nt, ((FunctionContext)_localctx).pattern.attr.typ, ((FunctionContext)_localctx).body.models, body_nt.typ_var, tail_branches)

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
		public list[Model] models;
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
			setState(300);
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
				setState(280);
				match(T__26);

				self.guide_terminal('ID')

				setState(282);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(284);
				match(T__27);

				body_nt = self.guide_nonterm(RecordRule(self._solver).distill_single_body, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(286);
				((RecordContext)_localctx).body = expr(body_nt);

				nt = replace(nt, models = ((RecordContext)_localctx).body.models)
				_localctx.models = self.collect(RecordRule(self._solver).combine_single, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), body_nt.typ_var)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(289);
				match(T__26);

				self.guide_terminal('ID')

				setState(291);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(293);
				match(T__27);

				body_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_body, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(295);
				((RecordContext)_localctx).body = expr(body_nt);

				nt = replace(nt, models = ((RecordContext)_localctx).body.models)
				tail_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_tail, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), body_nt.typ_var)

				setState(297);
				((RecordContext)_localctx).tail = record(tail_nt);

				nt = replace(nt, models = ((RecordContext)_localctx).tail.models)
				_localctx.models = self.collect(RecordRule(self._solver).combine_cons, nt, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), body_nt.typ_var, tail_nt.typ_var)

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
			setState(319);
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
				setState(303);
				match(T__5);

				content_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_single_content, nt) 

				setState(305);
				((ArgchainContext)_localctx).content = expr(content_nt);

				self.guide_symbol(')')

				setState(307);
				match(T__6);

				nt = replace(nt, models = ((ArgchainContext)_localctx).content.models)
				_localctx.attr = self.collect(ArgchainRule(self._solver).combine_single, nt, content_nt.typ_var)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(310);
				match(T__5);

				head_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_cons_head, nt) 

				setState(312);
				((ArgchainContext)_localctx).head = expr(head_nt);

				self.guide_symbol(')')

				setState(314);
				match(T__6);

				nt = replace(nt, models = ((ArgchainContext)_localctx).head.models)

				setState(316);
				((ArgchainContext)_localctx).tail = argchain(nt);

				nt = replace(nt, models = ((ArgchainContext)_localctx).tail.attr.models)
				_localctx.attr = self.collect(ArgchainRule(self._solver).combine_cons, nt, head_nt.typ_var, ((ArgchainContext)_localctx).tail.attr.args)

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
		public list[TVar] cator_vars;
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
			setState(334);
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
				setState(322);
				match(T__28);

				content_nt = self.guide_nonterm(PipelineRule(self._solver).distill_single_content, nt) 

				setState(324);
				((PipelineContext)_localctx).content = expr(content_nt);

				nt = replace(nt, models = ((PipelineContext)_localctx).content.models)
				_localctx.cator_vars = self.collect(PipelineRule(self._solver).combine_single, nt, content_nt.typ_var)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(327);
				match(T__28);

				head_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_head, nt) 

				setState(329);
				((PipelineContext)_localctx).head = expr(head_nt);

				nt = replace(nt, models = ((PipelineContext)_localctx).head.models)
				tail_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_tail, nt, head_nt.typ_var) 

				setState(331);
				((PipelineContext)_localctx).tail = pipeline(tail_nt);

				_localctx.cator_vars = self.collect(ArgchainRule(self._solver, nt).combine_cons, nt, head_nt.typ_var, ((PipelineContext)_localctx).tail.cator_vars)

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
		public list[str] keys;
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
			setState(348);
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
				setState(337);
				match(T__29);

				self.guide_terminal('ID')

				setState(339);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.keys = self.collect(KeychainRule(self._solver).combine_single, nt, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(341);
				match(T__29);

				self.guide_terminal('ID')

				setState(343);
				((KeychainContext)_localctx).ID = match(ID);


				setState(345);
				((KeychainContext)_localctx).tail = keychain(nt);

				_localctx.keys = self.collect(KeychainRule(self._solver).combine_cons, nt, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.keys)

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
		public list[Models] models;
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
			setState(356);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__17:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__27:
				enterOuterAlt(_localctx, 2);
				{
				setState(351);
				match(T__27);

				expr_nt = self.guide_nonterm(lambda: nt)

				setState(353);
				((TargetContext)_localctx).expr = expr(expr_nt);

				_localctx.models = ((TargetContext)_localctx).expr.models

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
			setState(370);
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
				setState(359);
				((PatternContext)_localctx).base_pattern = base_pattern(nt);

				_localctx.attr = ((PatternContext)_localctx).base_pattern.attr

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{


				setState(363);
				((PatternContext)_localctx).head = base_pattern(nt);

				self.guide_symbol(',')

				setState(365);
				match(T__10);


				setState(367);
				((PatternContext)_localctx).tail = pattern(nt);

				_localctx.attr = self.collect(PatternRule(self._solver).combine_tuple, nt, ((PatternContext)_localctx).head.attr, ((PatternContext)_localctx).tail.attr) 

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
		public Nonterm nt;
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
		public Base_patternContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_base_pattern; }
	}

	public final Base_patternContext base_pattern(Nonterm nt) throws RecognitionException {
		Base_patternContext _localctx = new Base_patternContext(_ctx, getState(), nt);
		enterRule(_localctx, 30, RULE_base_pattern);
		try {
			setState(394);
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
				setState(373);
				((Base_patternContext)_localctx).ID = match(ID);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_var, nt, (((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(375);
				((Base_patternContext)_localctx).ID = match(ID);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_var, nt, (((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null))

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(377);
				match(T__2);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_unit, nt)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(379);
				match(T__3);

				self.guide_terminal('ID')

				setState(381);
				((Base_patternContext)_localctx).ID = match(ID);


				setState(383);
				((Base_patternContext)_localctx).body = base_pattern(nt);

				_localctx.attr = self.collect(BasePatternRule(self._solver).combine_tag, nt, (((Base_patternContext)_localctx).ID!=null?((Base_patternContext)_localctx).ID.getText():null), ((Base_patternContext)_localctx).body.attr)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(386);
				((Base_patternContext)_localctx).record_pattern = record_pattern(nt);

				_localctx.attr = ((Base_patternContext)_localctx).record_pattern.attr

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(389);
				match(T__5);
				setState(390);
				((Base_patternContext)_localctx).pattern = pattern(nt);
				setState(391);
				match(T__6);

				_localctx.attr = ((Base_patternContext)_localctx).pattern.attr

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
		public Nonterm nt;
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
		public Record_patternContext(ParserRuleContext parent, int invokingState, Nonterm nt) {
			super(parent, invokingState);
			this.nt = nt;
		}
		@Override public int getRuleIndex() { return RULE_record_pattern; }
	}

	public final Record_patternContext record_pattern(Nonterm nt) throws RecognitionException {
		Record_patternContext _localctx = new Record_patternContext(_ctx, getState(), nt);
		enterRule(_localctx, 32, RULE_record_pattern);
		try {
			setState(417);
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
				match(T__26);

				self.guide_terminal('ID')

				setState(399);
				((Record_patternContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(401);
				match(T__27);


				setState(403);
				((Record_patternContext)_localctx).body = pattern(nt);

				_localctx.attr = self.collect(RecordPatternRule(self._solver).combine_single, nt, (((Record_patternContext)_localctx).ID!=null?((Record_patternContext)_localctx).ID.getText():null), ((Record_patternContext)_localctx).body.attr)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(406);
				match(T__26);

				self.guide_terminal('ID')

				setState(408);
				((Record_patternContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(410);
				match(T__27);


				setState(412);
				((Record_patternContext)_localctx).body = pattern(nt);


				setState(414);
				((Record_patternContext)_localctx).tail = record_pattern(nt);

				_localctx.attr = self.collect(RecordPatternRule(self._solver, nt).combine_cons, nt, (((Record_patternContext)_localctx).ID!=null?((Record_patternContext)_localctx).ID.getText():null), ((Record_patternContext)_localctx).body.attr, ((Record_patternContext)_localctx).tail.attr)

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
		"\u0004\u0001!\u01a4\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004\u0002"+
		"\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007\u0002"+
		"\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b\u0007\u000b\u0002"+
		"\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0002\u000f\u0007\u000f"+
		"\u0002\u0010\u0007\u0010\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u0000*\b\u0000\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0003\u0001"+
		"D\b\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0003\u0002\u0085\b\u0002"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0003\u0003"+
		"\u0092\b\u0003\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0003\u0004"+
		"\u009e\b\u0004\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0003\u0005\u00a6\b\u0005\u0001\u0006\u0001\u0006\u0001\u0006"+
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
		"\u0003\u0006\u00e7\b\u0006\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0003\u0007\u00ff\b\u0007\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0003\b\u0116\b\b\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0003\t\u012d\b\t\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0003\n\u0140\b\n\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0003\u000b\u014f"+
		"\b\u000b\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001"+
		"\f\u0001\f\u0001\f\u0001\f\u0001\f\u0003\f\u015d\b\f\u0001\r\u0001\r\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0003\r\u0165\b\r\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0003\u000e\u0173\b\u000e\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0001"+
		"\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0003\u000f\u018b\b\u000f\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0010\u0001\u0010\u0001\u0010\u0003\u0010\u01a2\b\u0010\u0001\u0010\u0000"+
		"\u0000\u0011\u0000\u0002\u0004\u0006\b\n\f\u000e\u0010\u0012\u0014\u0016"+
		"\u0018\u001a\u001c\u001e \u0000\u0000\u01ce\u0000)\u0001\u0000\u0000\u0000"+
		"\u0002C\u0001\u0000\u0000\u0000\u0004\u0084\u0001\u0000\u0000\u0000\u0006"+
		"\u0091\u0001\u0000\u0000\u0000\b\u009d\u0001\u0000\u0000\u0000\n\u00a5"+
		"\u0001\u0000\u0000\u0000\f\u00e6\u0001\u0000\u0000\u0000\u000e\u00fe\u0001"+
		"\u0000\u0000\u0000\u0010\u0115\u0001\u0000\u0000\u0000\u0012\u012c\u0001"+
		"\u0000\u0000\u0000\u0014\u013f\u0001\u0000\u0000\u0000\u0016\u014e\u0001"+
		"\u0000\u0000\u0000\u0018\u015c\u0001\u0000\u0000\u0000\u001a\u0164\u0001"+
		"\u0000\u0000\u0000\u001c\u0172\u0001\u0000\u0000\u0000\u001e\u018a\u0001"+
		"\u0000\u0000\u0000 \u01a1\u0001\u0000\u0000\u0000\"*\u0001\u0000\u0000"+
		"\u0000#$\u0005\u001f\u0000\u0000$*\u0006\u0000\uffff\uffff\u0000%&\u0005"+
		"\u001f\u0000\u0000&\'\u0003\u0000\u0000\u0000\'(\u0006\u0000\uffff\uffff"+
		"\u0000(*\u0001\u0000\u0000\u0000)\"\u0001\u0000\u0000\u0000)#\u0001\u0000"+
		"\u0000\u0000)%\u0001\u0000\u0000\u0000*\u0001\u0001\u0000\u0000\u0000"+
		"+D\u0001\u0000\u0000\u0000,-\u0005\u0001\u0000\u0000-D\u0006\u0001\uffff"+
		"\uffff\u0000./\u0005\u0002\u0000\u0000/D\u0006\u0001\uffff\uffff\u0000"+
		"01\u0005\u001f\u0000\u00001D\u0006\u0001\uffff\uffff\u000023\u0005\u0003"+
		"\u0000\u00003D\u0006\u0001\uffff\uffff\u000045\u0005\u0004\u0000\u0000"+
		"56\u0005\u001f\u0000\u000067\u0003\u0002\u0001\u000078\u0006\u0001\uffff"+
		"\uffff\u00008D\u0001\u0000\u0000\u00009:\u0005\u001f\u0000\u0000:;\u0005"+
		"\u0005\u0000\u0000;<\u0003\u0002\u0001\u0000<=\u0006\u0001\uffff\uffff"+
		"\u0000=D\u0001\u0000\u0000\u0000>?\u0005\u0006\u0000\u0000?@\u0003\u0004"+
		"\u0002\u0000@A\u0005\u0007\u0000\u0000AB\u0006\u0001\uffff\uffff\u0000"+
		"BD\u0001\u0000\u0000\u0000C+\u0001\u0000\u0000\u0000C,\u0001\u0000\u0000"+
		"\u0000C.\u0001\u0000\u0000\u0000C0\u0001\u0000\u0000\u0000C2\u0001\u0000"+
		"\u0000\u0000C4\u0001\u0000\u0000\u0000C9\u0001\u0000\u0000\u0000C>\u0001"+
		"\u0000\u0000\u0000D\u0003\u0001\u0000\u0000\u0000E\u0085\u0001\u0000\u0000"+
		"\u0000FG\u0003\u0002\u0001\u0000GH\u0006\u0002\uffff\uffff\u0000H\u0085"+
		"\u0001\u0000\u0000\u0000IJ\u0003\u0002\u0001\u0000JK\u0005\b\u0000\u0000"+
		"KL\u0003\u0004\u0002\u0000LM\u0006\u0002\uffff\uffff\u0000M\u0085\u0001"+
		"\u0000\u0000\u0000NO\u0003\u0002\u0001\u0000OP\u0005\t\u0000\u0000PQ\u0003"+
		"\u0004\u0002\u0000QR\u0006\u0002\uffff\uffff\u0000R\u0085\u0001\u0000"+
		"\u0000\u0000ST\u0003\u0002\u0001\u0000TU\u0003\u0006\u0003\u0000UV\u0006"+
		"\u0002\uffff\uffff\u0000V\u0085\u0001\u0000\u0000\u0000WX\u0003\u0002"+
		"\u0001\u0000XY\u0005\n\u0000\u0000YZ\u0003\u0004\u0002\u0000Z[\u0006\u0002"+
		"\uffff\uffff\u0000[\u0085\u0001\u0000\u0000\u0000\\]\u0003\u0002\u0001"+
		"\u0000]^\u0005\u000b\u0000\u0000^_\u0003\u0004\u0002\u0000_`\u0006\u0002"+
		"\uffff\uffff\u0000`\u0085\u0001\u0000\u0000\u0000ab\u0005\f\u0000\u0000"+
		"bc\u0005\r\u0000\u0000cd\u0003\u0000\u0000\u0000de\u0005\u000e\u0000\u0000"+
		"ef\u0003\u0004\u0002\u0000fg\u0006\u0002\uffff\uffff\u0000g\u0085\u0001"+
		"\u0000\u0000\u0000hi\u0005\f\u0000\u0000ij\u0005\r\u0000\u0000jk\u0003"+
		"\u0000\u0000\u0000kl\u0003\b\u0004\u0000lm\u0005\u000e\u0000\u0000mn\u0003"+
		"\u0004\u0002\u0000no\u0006\u0002\uffff\uffff\u0000o\u0085\u0001\u0000"+
		"\u0000\u0000pq\u0005\u000f\u0000\u0000qr\u0005\r\u0000\u0000rs\u0003\u0000"+
		"\u0000\u0000st\u0005\u000e\u0000\u0000tu\u0003\u0004\u0002\u0000uv\u0006"+
		"\u0002\uffff\uffff\u0000v\u0085\u0001\u0000\u0000\u0000wx\u0005\u000f"+
		"\u0000\u0000xy\u0005\r\u0000\u0000yz\u0003\u0000\u0000\u0000z{\u0003\b"+
		"\u0004\u0000{|\u0005\u000e\u0000\u0000|}\u0003\u0004\u0002\u0000}~\u0006"+
		"\u0002\uffff\uffff\u0000~\u0085\u0001\u0000\u0000\u0000\u007f\u0080\u0005"+
		"\u0010\u0000\u0000\u0080\u0081\u0005\u001f\u0000\u0000\u0081\u0082\u0003"+
		"\u0004\u0002\u0000\u0082\u0083\u0006\u0002\uffff\uffff\u0000\u0083\u0085"+
		"\u0001\u0000\u0000\u0000\u0084E\u0001\u0000\u0000\u0000\u0084F\u0001\u0000"+
		"\u0000\u0000\u0084I\u0001\u0000\u0000\u0000\u0084N\u0001\u0000\u0000\u0000"+
		"\u0084S\u0001\u0000\u0000\u0000\u0084W\u0001\u0000\u0000\u0000\u0084\\"+
		"\u0001\u0000\u0000\u0000\u0084a\u0001\u0000\u0000\u0000\u0084h\u0001\u0000"+
		"\u0000\u0000\u0084p\u0001\u0000\u0000\u0000\u0084w\u0001\u0000\u0000\u0000"+
		"\u0084\u007f\u0001\u0000\u0000\u0000\u0085\u0005\u0001\u0000\u0000\u0000"+
		"\u0086\u0092\u0001\u0000\u0000\u0000\u0087\u0088\u0005\u0011\u0000\u0000"+
		"\u0088\u0089\u0003\u0004\u0002\u0000\u0089\u008a\u0006\u0003\uffff\uffff"+
		"\u0000\u008a\u0092\u0001\u0000\u0000\u0000\u008b\u008c\u0005\u0011\u0000"+
		"\u0000\u008c\u008d\u0003\u0004\u0002\u0000\u008d\u008e\u0006\u0003\uffff"+
		"\uffff\u0000\u008e\u008f\u0003\u0006\u0003\u0000\u008f\u0090\u0006\u0003"+
		"\uffff\uffff\u0000\u0090\u0092\u0001\u0000\u0000\u0000\u0091\u0086\u0001"+
		"\u0000\u0000\u0000\u0091\u0087\u0001\u0000\u0000\u0000\u0091\u008b\u0001"+
		"\u0000\u0000\u0000\u0092\u0007\u0001\u0000\u0000\u0000\u0093\u009e\u0001"+
		"\u0000\u0000\u0000\u0094\u0095\u0005\u0012\u0000\u0000\u0095\u0096\u0003"+
		"\n\u0005\u0000\u0096\u0097\u0006\u0004\uffff\uffff\u0000\u0097\u009e\u0001"+
		"\u0000\u0000\u0000\u0098\u0099\u0005\u0012\u0000\u0000\u0099\u009a\u0003"+
		"\n\u0005\u0000\u009a\u009b\u0003\b\u0004\u0000\u009b\u009c\u0006\u0004"+
		"\uffff\uffff\u0000\u009c\u009e\u0001\u0000\u0000\u0000\u009d\u0093\u0001"+
		"\u0000\u0000\u0000\u009d\u0094\u0001\u0000\u0000\u0000\u009d\u0098\u0001"+
		"\u0000\u0000\u0000\u009e\t\u0001\u0000\u0000\u0000\u009f\u00a6\u0001\u0000"+
		"\u0000\u0000\u00a0\u00a1\u0003\u0004\u0002\u0000\u00a1\u00a2\u0005\u0013"+
		"\u0000\u0000\u00a2\u00a3\u0003\u0004\u0002\u0000\u00a3\u00a4\u0006\u0005"+
		"\uffff\uffff\u0000\u00a4\u00a6\u0001\u0000\u0000\u0000\u00a5\u009f\u0001"+
		"\u0000\u0000\u0000\u00a5\u00a0\u0001\u0000\u0000\u0000\u00a6\u000b\u0001"+
		"\u0000\u0000\u0000\u00a7\u00e7\u0001\u0000\u0000\u0000\u00a8\u00a9\u0003"+
		"\u000e\u0007\u0000\u00a9\u00aa\u0006\u0006\uffff\uffff\u0000\u00aa\u00e7"+
		"\u0001\u0000\u0000\u0000\u00ab\u00ac\u0006\u0006\uffff\uffff\u0000\u00ac"+
		"\u00ad\u0003\u000e\u0007\u0000\u00ad\u00ae\u0006\u0006\uffff\uffff\u0000"+
		"\u00ae\u00af\u0005\u000b\u0000\u0000\u00af\u00b0\u0006\u0006\uffff\uffff"+
		"\u0000\u00b0\u00b1\u0003\f\u0006\u0000\u00b1\u00b2\u0006\u0006\uffff\uffff"+
		"\u0000\u00b2\u00e7\u0001\u0000\u0000\u0000\u00b3\u00b4\u0005\u0014\u0000"+
		"\u0000\u00b4\u00b5\u0006\u0006\uffff\uffff\u0000\u00b5\u00b6\u0003\f\u0006"+
		"\u0000\u00b6\u00b7\u0006\u0006\uffff\uffff\u0000\u00b7\u00b8\u0005\u0015"+
		"\u0000\u0000\u00b8\u00b9\u0006\u0006\uffff\uffff\u0000\u00b9\u00ba\u0003"+
		"\f\u0006\u0000\u00ba\u00bb\u0006\u0006\uffff\uffff\u0000\u00bb\u00bc\u0005"+
		"\u0016\u0000\u0000\u00bc\u00bd\u0006\u0006\uffff\uffff\u0000\u00bd\u00be"+
		"\u0003\f\u0006\u0000\u00be\u00bf\u0006\u0006\uffff\uffff\u0000\u00bf\u00e7"+
		"\u0001\u0000\u0000\u0000\u00c0\u00c1\u0006\u0006\uffff\uffff\u0000\u00c1"+
		"\u00c2\u0003\u000e\u0007\u0000\u00c2\u00c3\u0006\u0006\uffff\uffff\u0000"+
		"\u00c3\u00c4\u0003\u0018\f\u0000\u00c4\u00c5\u0006\u0006\uffff\uffff\u0000"+
		"\u00c5\u00e7\u0001\u0000\u0000\u0000\u00c6\u00c7\u0006\u0006\uffff\uffff"+
		"\u0000\u00c7\u00c8\u0003\u000e\u0007\u0000\u00c8\u00c9\u0006\u0006\uffff"+
		"\uffff\u0000\u00c9\u00ca\u0003\u0014\n\u0000\u00ca\u00cb\u0006\u0006\uffff"+
		"\uffff\u0000\u00cb\u00e7\u0001\u0000\u0000\u0000\u00cc\u00cd\u0006\u0006"+
		"\uffff\uffff\u0000\u00cd\u00ce\u0003\u000e\u0007\u0000\u00ce\u00cf\u0006"+
		"\u0006\uffff\uffff\u0000\u00cf\u00d0\u0003\u0016\u000b\u0000\u00d0\u00d1"+
		"\u0006\u0006\uffff\uffff\u0000\u00d1\u00e7\u0001\u0000\u0000\u0000\u00d2"+
		"\u00d3\u0005\u0017\u0000\u0000\u00d3\u00d4\u0006\u0006\uffff\uffff\u0000"+
		"\u00d4\u00d5\u0005\u001f\u0000\u0000\u00d5\u00d6\u0006\u0006\uffff\uffff"+
		"\u0000\u00d6\u00d7\u0003\u001a\r\u0000\u00d7\u00d8\u0006\u0006\uffff\uffff"+
		"\u0000\u00d8\u00d9\u0005\u0012\u0000\u0000\u00d9\u00da\u0006\u0006\uffff"+
		"\uffff\u0000\u00da\u00db\u0003\f\u0006\u0000\u00db\u00dc\u0006\u0006\uffff"+
		"\uffff\u0000\u00dc\u00e7\u0001\u0000\u0000\u0000\u00dd\u00de\u0005\u0018"+
		"\u0000\u0000\u00de\u00df\u0006\u0006\uffff\uffff\u0000\u00df\u00e0\u0005"+
		"\u0006\u0000\u0000\u00e0\u00e1\u0006\u0006\uffff\uffff\u0000\u00e1\u00e2"+
		"\u0003\f\u0006\u0000\u00e2\u00e3\u0006\u0006\uffff\uffff\u0000\u00e3\u00e4"+
		"\u0005\u0007\u0000\u0000\u00e4\u00e5\u0006\u0006\uffff\uffff\u0000\u00e5"+
		"\u00e7\u0001\u0000\u0000\u0000\u00e6\u00a7\u0001\u0000\u0000\u0000\u00e6"+
		"\u00a8\u0001\u0000\u0000\u0000\u00e6\u00ab\u0001\u0000\u0000\u0000\u00e6"+
		"\u00b3\u0001\u0000\u0000\u0000\u00e6\u00c0\u0001\u0000\u0000\u0000\u00e6"+
		"\u00c6\u0001\u0000\u0000\u0000\u00e6\u00cc\u0001\u0000\u0000\u0000\u00e6"+
		"\u00d2\u0001\u0000\u0000\u0000\u00e6\u00dd\u0001\u0000\u0000\u0000\u00e7"+
		"\r\u0001\u0000\u0000\u0000\u00e8\u00ff\u0001\u0000\u0000\u0000\u00e9\u00ea"+
		"\u0005\u0003\u0000\u0000\u00ea\u00ff\u0006\u0007\uffff\uffff\u0000\u00eb"+
		"\u00ec\u0005\u0004\u0000\u0000\u00ec\u00ed\u0006\u0007\uffff\uffff\u0000"+
		"\u00ed\u00ee\u0005\u001f\u0000\u0000\u00ee\u00ef\u0006\u0007\uffff\uffff"+
		"\u0000\u00ef\u00f0\u0003\u000e\u0007\u0000\u00f0\u00f1\u0006\u0007\uffff"+
		"\uffff\u0000\u00f1\u00ff\u0001\u0000\u0000\u0000\u00f2\u00f3\u0003\u0012"+
		"\t\u0000\u00f3\u00f4\u0006\u0007\uffff\uffff\u0000\u00f4\u00ff\u0001\u0000"+
		"\u0000\u0000\u00f5\u00f6\u0006\u0007\uffff\uffff\u0000\u00f6\u00f7\u0003"+
		"\u0010\b\u0000\u00f7\u00f8\u0006\u0007\uffff\uffff\u0000\u00f8\u00ff\u0001"+
		"\u0000\u0000\u0000\u00f9\u00fa\u0005\u001f\u0000\u0000\u00fa\u00ff\u0006"+
		"\u0007\uffff\uffff\u0000\u00fb\u00fc\u0003\u0014\n\u0000\u00fc\u00fd\u0006"+
		"\u0007\uffff\uffff\u0000\u00fd\u00ff\u0001\u0000\u0000\u0000\u00fe\u00e8"+
		"\u0001\u0000\u0000\u0000\u00fe\u00e9\u0001\u0000\u0000\u0000\u00fe\u00eb"+
		"\u0001\u0000\u0000\u0000\u00fe\u00f2\u0001\u0000\u0000\u0000\u00fe\u00f5"+
		"\u0001\u0000\u0000\u0000\u00fe\u00f9\u0001\u0000\u0000\u0000\u00fe\u00fb"+
		"\u0001\u0000\u0000\u0000\u00ff\u000f\u0001\u0000\u0000\u0000\u0100\u0116"+
		"\u0001\u0000\u0000\u0000\u0101\u0102\u0005\u0019\u0000\u0000\u0102\u0103"+
		"\u0006\b\uffff\uffff\u0000\u0103\u0104\u0003\u001c\u000e\u0000\u0104\u0105"+
		"\u0006\b\uffff\uffff\u0000\u0105\u0106\u0005\u001a\u0000\u0000\u0106\u0107"+
		"\u0006\b\uffff\uffff\u0000\u0107\u0108\u0003\f\u0006\u0000\u0108\u0109"+
		"\u0006\b\uffff\uffff\u0000\u0109\u0116\u0001\u0000\u0000\u0000\u010a\u010b"+
		"\u0005\u0019\u0000\u0000\u010b\u010c\u0006\b\uffff\uffff\u0000\u010c\u010d"+
		"\u0003\u001c\u000e\u0000\u010d\u010e\u0006\b\uffff\uffff\u0000\u010e\u010f"+
		"\u0005\u001a\u0000\u0000\u010f\u0110\u0006\b\uffff\uffff\u0000\u0110\u0111"+
		"\u0003\f\u0006\u0000\u0111\u0112\u0006\b\uffff\uffff\u0000\u0112\u0113"+
		"\u0003\u0010\b\u0000\u0113\u0114\u0006\b\uffff\uffff\u0000\u0114\u0116"+
		"\u0001\u0000\u0000\u0000\u0115\u0100\u0001\u0000\u0000\u0000\u0115\u0101"+
		"\u0001\u0000\u0000\u0000\u0115\u010a\u0001\u0000\u0000\u0000\u0116\u0011"+
		"\u0001\u0000\u0000\u0000\u0117\u012d\u0001\u0000\u0000\u0000\u0118\u0119"+
		"\u0005\u001b\u0000\u0000\u0119\u011a\u0006\t\uffff\uffff\u0000\u011a\u011b"+
		"\u0005\u001f\u0000\u0000\u011b\u011c\u0006\t\uffff\uffff\u0000\u011c\u011d"+
		"\u0005\u001c\u0000\u0000\u011d\u011e\u0006\t\uffff\uffff\u0000\u011e\u011f"+
		"\u0003\f\u0006\u0000\u011f\u0120\u0006\t\uffff\uffff\u0000\u0120\u012d"+
		"\u0001\u0000\u0000\u0000\u0121\u0122\u0005\u001b\u0000\u0000\u0122\u0123"+
		"\u0006\t\uffff\uffff\u0000\u0123\u0124\u0005\u001f\u0000\u0000\u0124\u0125"+
		"\u0006\t\uffff\uffff\u0000\u0125\u0126\u0005\u001c\u0000\u0000\u0126\u0127"+
		"\u0006\t\uffff\uffff\u0000\u0127\u0128\u0003\f\u0006\u0000\u0128\u0129"+
		"\u0006\t\uffff\uffff\u0000\u0129\u012a\u0003\u0012\t\u0000\u012a\u012b"+
		"\u0006\t\uffff\uffff\u0000\u012b\u012d\u0001\u0000\u0000\u0000\u012c\u0117"+
		"\u0001\u0000\u0000\u0000\u012c\u0118\u0001\u0000\u0000\u0000\u012c\u0121"+
		"\u0001\u0000\u0000\u0000\u012d\u0013\u0001\u0000\u0000\u0000\u012e\u0140"+
		"\u0001\u0000\u0000\u0000\u012f\u0130\u0005\u0006\u0000\u0000\u0130\u0131"+
		"\u0006\n\uffff\uffff\u0000\u0131\u0132\u0003\f\u0006\u0000\u0132\u0133"+
		"\u0006\n\uffff\uffff\u0000\u0133\u0134\u0005\u0007\u0000\u0000\u0134\u0135"+
		"\u0006\n\uffff\uffff\u0000\u0135\u0140\u0001\u0000\u0000\u0000\u0136\u0137"+
		"\u0005\u0006\u0000\u0000\u0137\u0138\u0006\n\uffff\uffff\u0000\u0138\u0139"+
		"\u0003\f\u0006\u0000\u0139\u013a\u0006\n\uffff\uffff\u0000\u013a\u013b"+
		"\u0005\u0007\u0000\u0000\u013b\u013c\u0006\n\uffff\uffff\u0000\u013c\u013d"+
		"\u0003\u0014\n\u0000\u013d\u013e\u0006\n\uffff\uffff\u0000\u013e\u0140"+
		"\u0001\u0000\u0000\u0000\u013f\u012e\u0001\u0000\u0000\u0000\u013f\u012f"+
		"\u0001\u0000\u0000\u0000\u013f\u0136\u0001\u0000\u0000\u0000\u0140\u0015"+
		"\u0001\u0000\u0000\u0000\u0141\u014f\u0001\u0000\u0000\u0000\u0142\u0143"+
		"\u0005\u001d\u0000\u0000\u0143\u0144\u0006\u000b\uffff\uffff\u0000\u0144"+
		"\u0145\u0003\f\u0006\u0000\u0145\u0146\u0006\u000b\uffff\uffff\u0000\u0146"+
		"\u014f\u0001\u0000\u0000\u0000\u0147\u0148\u0005\u001d\u0000\u0000\u0148"+
		"\u0149\u0006\u000b\uffff\uffff\u0000\u0149\u014a\u0003\f\u0006\u0000\u014a"+
		"\u014b\u0006\u000b\uffff\uffff\u0000\u014b\u014c\u0003\u0016\u000b\u0000"+
		"\u014c\u014d\u0006\u000b\uffff\uffff\u0000\u014d\u014f\u0001\u0000\u0000"+
		"\u0000\u014e\u0141\u0001\u0000\u0000\u0000\u014e\u0142\u0001\u0000\u0000"+
		"\u0000\u014e\u0147\u0001\u0000\u0000\u0000\u014f\u0017\u0001\u0000\u0000"+
		"\u0000\u0150\u015d\u0001\u0000\u0000\u0000\u0151\u0152\u0005\u001e\u0000"+
		"\u0000\u0152\u0153\u0006\f\uffff\uffff\u0000\u0153\u0154\u0005\u001f\u0000"+
		"\u0000\u0154\u015d\u0006\f\uffff\uffff\u0000\u0155\u0156\u0005\u001e\u0000"+
		"\u0000\u0156\u0157\u0006\f\uffff\uffff\u0000\u0157\u0158\u0005\u001f\u0000"+
		"\u0000\u0158\u0159\u0006\f\uffff\uffff\u0000\u0159\u015a\u0003\u0018\f"+
		"\u0000\u015a\u015b\u0006\f\uffff\uffff\u0000\u015b\u015d\u0001\u0000\u0000"+
		"\u0000\u015c\u0150\u0001\u0000\u0000\u0000\u015c\u0151\u0001\u0000\u0000"+
		"\u0000\u015c\u0155\u0001\u0000\u0000\u0000\u015d\u0019\u0001\u0000\u0000"+
		"\u0000\u015e\u0165\u0001\u0000\u0000\u0000\u015f\u0160\u0005\u001c\u0000"+
		"\u0000\u0160\u0161\u0006\r\uffff\uffff\u0000\u0161\u0162\u0003\f\u0006"+
		"\u0000\u0162\u0163\u0006\r\uffff\uffff\u0000\u0163\u0165\u0001\u0000\u0000"+
		"\u0000\u0164\u015e\u0001\u0000\u0000\u0000\u0164\u015f\u0001\u0000\u0000"+
		"\u0000\u0165\u001b\u0001\u0000\u0000\u0000\u0166\u0173\u0001\u0000\u0000"+
		"\u0000\u0167\u0168\u0003\u001e\u000f\u0000\u0168\u0169\u0006\u000e\uffff"+
		"\uffff\u0000\u0169\u0173\u0001\u0000\u0000\u0000\u016a\u016b\u0006\u000e"+
		"\uffff\uffff\u0000\u016b\u016c\u0003\u001e\u000f\u0000\u016c\u016d\u0006"+
		"\u000e\uffff\uffff\u0000\u016d\u016e\u0005\u000b\u0000\u0000\u016e\u016f"+
		"\u0006\u000e\uffff\uffff\u0000\u016f\u0170\u0003\u001c\u000e\u0000\u0170"+
		"\u0171\u0006\u000e\uffff\uffff\u0000\u0171\u0173\u0001\u0000\u0000\u0000"+
		"\u0172\u0166\u0001\u0000\u0000\u0000\u0172\u0167\u0001\u0000\u0000\u0000"+
		"\u0172\u016a\u0001\u0000\u0000\u0000\u0173\u001d\u0001\u0000\u0000\u0000"+
		"\u0174\u018b\u0001\u0000\u0000\u0000\u0175\u0176\u0005\u001f\u0000\u0000"+
		"\u0176\u018b\u0006\u000f\uffff\uffff\u0000\u0177\u0178\u0005\u001f\u0000"+
		"\u0000\u0178\u018b\u0006\u000f\uffff\uffff\u0000\u0179\u017a\u0005\u0003"+
		"\u0000\u0000\u017a\u018b\u0006\u000f\uffff\uffff\u0000\u017b\u017c\u0005"+
		"\u0004\u0000\u0000\u017c\u017d\u0006\u000f\uffff\uffff\u0000\u017d\u017e"+
		"\u0005\u001f\u0000\u0000\u017e\u017f\u0006\u000f\uffff\uffff\u0000\u017f"+
		"\u0180\u0003\u001e\u000f\u0000\u0180\u0181\u0006\u000f\uffff\uffff\u0000"+
		"\u0181\u018b\u0001\u0000\u0000\u0000\u0182\u0183\u0003 \u0010\u0000\u0183"+
		"\u0184\u0006\u000f\uffff\uffff\u0000\u0184\u018b\u0001\u0000\u0000\u0000"+
		"\u0185\u0186\u0005\u0006\u0000\u0000\u0186\u0187\u0003\u001c\u000e\u0000"+
		"\u0187\u0188\u0005\u0007\u0000\u0000\u0188\u0189\u0006\u000f\uffff\uffff"+
		"\u0000\u0189\u018b\u0001\u0000\u0000\u0000\u018a\u0174\u0001\u0000\u0000"+
		"\u0000\u018a\u0175\u0001\u0000\u0000\u0000\u018a\u0177\u0001\u0000\u0000"+
		"\u0000\u018a\u0179\u0001\u0000\u0000\u0000\u018a\u017b\u0001\u0000\u0000"+
		"\u0000\u018a\u0182\u0001\u0000\u0000\u0000\u018a\u0185\u0001\u0000\u0000"+
		"\u0000\u018b\u001f\u0001\u0000\u0000\u0000\u018c\u01a2\u0001\u0000\u0000"+
		"\u0000\u018d\u018e\u0005\u001b\u0000\u0000\u018e\u018f\u0006\u0010\uffff"+
		"\uffff\u0000\u018f\u0190\u0005\u001f\u0000\u0000\u0190\u0191\u0006\u0010"+
		"\uffff\uffff\u0000\u0191\u0192\u0005\u001c\u0000\u0000\u0192\u0193\u0006"+
		"\u0010\uffff\uffff\u0000\u0193\u0194\u0003\u001c\u000e\u0000\u0194\u0195"+
		"\u0006\u0010\uffff\uffff\u0000\u0195\u01a2\u0001\u0000\u0000\u0000\u0196"+
		"\u0197\u0005\u001b\u0000\u0000\u0197\u0198\u0006\u0010\uffff\uffff\u0000"+
		"\u0198\u0199\u0005\u001f\u0000\u0000\u0199\u019a\u0006\u0010\uffff\uffff"+
		"\u0000\u019a\u019b\u0005\u001c\u0000\u0000\u019b\u019c\u0006\u0010\uffff"+
		"\uffff\u0000\u019c\u019d\u0003\u001c\u000e\u0000\u019d\u019e\u0006\u0010"+
		"\uffff\uffff\u0000\u019e\u019f\u0003 \u0010\u0000\u019f\u01a0\u0006\u0010"+
		"\uffff\uffff\u0000\u01a0\u01a2\u0001\u0000\u0000\u0000\u01a1\u018c\u0001"+
		"\u0000\u0000\u0000\u01a1\u018d\u0001\u0000\u0000\u0000\u01a1\u0196\u0001"+
		"\u0000\u0000\u0000\u01a2!\u0001\u0000\u0000\u0000\u0011)C\u0084\u0091"+
		"\u009d\u00a5\u00e6\u00fe\u0115\u012c\u013f\u014e\u015c\u0164\u0172\u018a"+
		"\u01a1";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}