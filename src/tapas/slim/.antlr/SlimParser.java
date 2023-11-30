// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analysis import * 

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
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, ID=17, 
		INT=18, WS=19;
	public static final int
		RULE_expr = 0, RULE_base = 1, RULE_function = 2, RULE_record = 3, RULE_argchain = 4, 
		RULE_pipeline = 5, RULE_keychain = 6, RULE_target = 7, RULE_pattern = 8, 
		RULE_pattern_base = 9, RULE_pattern_record = 10;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "base", "function", "record", "argchain", "pipeline", "keychain", 
			"target", "pattern", "pattern_base", "pattern_record"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "','", "'if'", "'then'", "'else'", "'let'", "';'", "'fix'", "'('", 
			"')'", "'@'", "':'", "'case'", "'=>'", "'='", "'|>'", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, "ID", "INT", "WS"
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
	    self._guidance = disn_default 
	    self._overflow = False  

	def reset(self): 
	    self._guidance = disn_default
	    self._overflow = False
	    # self.getCurrentToken()
	    # self.getTokenStream()



	def getGuidance(self):
	    return self._guidance

	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex

	def guide_nonterm(self, name : str, f : Callable, *args) -> Optional[Distillation]:
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    disn_result = None
	    if not self._overflow:
	        disn_result = f(*args)
	        self._guidance = Nonterm(name, disn_result)

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 

	    return disn_result 



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
	public static class ExprContext extends ParserRuleContext {
		public Distillation disn;
		public ECombo combo;
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
		public ExprContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(Distillation disn) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), disn);
		enterRule(_localctx, 0, RULE_expr);
		try {
			setState(85);
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
				setState(23);
				((ExprContext)_localctx).base = base(disn);

				_localctx.combo = ((ExprContext)_localctx).base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_tuple_head)

				setState(27);
				((ExprContext)_localctx).head = base(disn);

				self.guide_symbol(',')

				setState(29);
				match(T__0);

				disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_tuple_tail, ((ExprContext)_localctx).head.combo)

				setState(31);
				((ExprContext)_localctx).tail = base(disn);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_tuple, ((ExprContext)_localctx).head.combo, ((ExprContext)_localctx).tail.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(34);
				match(T__1);

				disn_condition = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_condition)

				setState(36);
				((ExprContext)_localctx).condition = expr(disn_condition);

				self.guide_symbol('then')

				setState(38);
				match(T__2);

				disn_branch_true = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_branch_true, ((ExprContext)_localctx).condition.combo)

				setState(40);
				((ExprContext)_localctx).branch_true = expr(disn_branch_true);

				self.guide_symbol('else')

				setState(42);
				match(T__3);

				disn_branch_false = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_branch_false, ((ExprContext)_localctx).condition.combo, ((ExprContext)_localctx).branch_true.combo)

				setState(44);
				((ExprContext)_localctx).branch_false = expr(disn_branch_false);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_ite, ((ExprContext)_localctx).condition.combo, ((ExprContext)_localctx).branch_true.combo, ((ExprContext)_localctx).branch_false.combo) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{

				disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_projection_cator)

				setState(48);
				((ExprContext)_localctx).cator = base(disn_cator);

				disn_keychain = self.guide_nonterm('keychain', ExprAttr(self._solver, disn).distill_projection_keychain, ((ExprContext)_localctx).cator.combo)

				setState(50);
				((ExprContext)_localctx).keychain = keychain(disn_keychain);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_projection, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{

				disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_application_cator)

				setState(54);
				((ExprContext)_localctx).cator = base(disn_cator);

				disn_argchain = self.guide_nonterm('argchain', ExprAttr(self._solver, disn).distill_application_argchain, ((ExprContext)_localctx).cator.combo)

				setState(56);
				((ExprContext)_localctx).argchain = argchain(disn_argchain);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_application, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).argchain.combos)

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{

				disn_arg = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_funnel_arg)

				setState(60);
				((ExprContext)_localctx).cator = base(disn_arg);

				disn_pipeline = self.guide_nonterm('pipeline', ExprAttr(self._solver, disn).distill_funnel_pipeline, ((ExprContext)_localctx).cator.combo)

				setState(62);
				((ExprContext)_localctx).pipeline = pipeline(disn_pipeline);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_funnel, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).pipeline.combos)

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(65);
				match(T__4);

				self.guide_terminal('ID')

				setState(67);
				((ExprContext)_localctx).ID = match(ID);

				disn_target = self.guide_nonterm('target', ExprAttr(self._solver, disn).distill_let_target, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(69);
				((ExprContext)_localctx).target = target(disn_target);

				self.guide_symbol(';')

				setState(71);
				match(T__5);

				disn_contin = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_let_contin, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.combo)

				setState(73);
				((ExprContext)_localctx).contin = expr(disn_contin);

				_localctx.combo = ((ExprContext)_localctx).contin.combo

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(76);
				match(T__6);

				self.guide_symbol('(')

				setState(78);
				match(T__7);

				disn_body = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_fix_body)

				setState(80);
				((ExprContext)_localctx).body = expr(disn_body);

				self.guide_symbol(')')

				setState(82);
				match(T__8);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_fix, ((ExprContext)_localctx).body.combo)

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
		public Distillation disn;
		public ECombo combo;
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
		public BaseContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_base; }
	}

	public final BaseContext base(Distillation disn) throws RecognitionException {
		BaseContext _localctx = new BaseContext(_ctx, getState(), disn);
		enterRule(_localctx, 2, RULE_base);
		try {
			setState(112);
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
				setState(88);
				match(T__9);

				_localctx.combo = self.collect(BaseAttr(self._solver, disn).combine_unit)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(90);
				match(T__10);

				self.guide_terminal('ID')

				setState(92);
				((BaseContext)_localctx).ID = match(ID);

				disn_body = self.guide_nonterm('expr', BaseAttr(self._solver, disn).distill_tag_body, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				setState(94);
				((BaseContext)_localctx).body = expr(disn_body);

				_localctx.combo = self.collect(BaseAttr(self._solver, disn).combine_tag, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null), ((BaseContext)_localctx).body.combo)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(97);
				((BaseContext)_localctx).record = record(disn);

				_localctx.combo = ((BaseContext)_localctx).record.combo

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(100);
				((BaseContext)_localctx).function = function(disn);

				_localctx.combo = ((BaseContext)_localctx).function.combo

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(103);
				((BaseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(BaseAttr(self._solver, disn).combine_var, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(105);
				match(T__7);

				disn_expr = self.guide_nonterm('expr', lambda: disn)

				setState(107);
				((BaseContext)_localctx).expr = expr(disn_expr);

				self.guide_symbol(')')

				setState(109);
				match(T__8);

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
		public Distillation disn;
		public ECombo combo;
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
		public FunctionContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function(Distillation disn) throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState(), disn);
		enterRule(_localctx, 4, RULE_function);
		try {
			setState(135);
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
				setState(115);
				match(T__11);

				disn_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, disn).distill_single_pattern)

				setState(117);
				((FunctionContext)_localctx).pattern = pattern(disn_pattern);

				self.guide_symbol('=>')

				setState(119);
				match(T__12);

				disn_body = self.guide_nonterm('expr', FunctionAttr(self._solver, disn).distill_single_body, ((FunctionContext)_localctx).pattern.combo)

				setState(121);
				((FunctionContext)_localctx).body = expr(disn_body);

				_localctx.combo = self.collect(FunctionAttr(self._solver, disn).combine_single, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(124);
				match(T__11);

				disn_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, disn).distill_cons_pattern)

				setState(126);
				((FunctionContext)_localctx).pattern = pattern(disn_pattern);

				self.guide_symbol('=>')

				setState(128);
				match(T__12);

				disn_body = self.guide_nonterm('expr', FunctionAttr(self._solver, disn).distill_cons_body, ((FunctionContext)_localctx).pattern.combo)

				setState(130);
				((FunctionContext)_localctx).body = expr(disn_body);

				disn_tail = self.guide_nonterm('function', FunctionAttr(self._solver, disn).distill_cons_tail, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				setState(132);
				((FunctionContext)_localctx).tail = function(disn);

				_localctx.combo = self.collect(FunctionAttr(self._solver, disn).combine_cons, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo, ((FunctionContext)_localctx).tail.combo)

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
		public Distillation disn;
		public ECombo combo;
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
		public RecordContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record(Distillation disn) throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState(), disn);
		enterRule(_localctx, 6, RULE_record);
		try {
			setState(158);
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
				setState(138);
				match(T__10);

				self.guide_terminal('ID')

				setState(140);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(142);
				match(T__13);

				disn_body = self.guide_nonterm('expr', RecordAttr(self._solver, disn).distill_single_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(144);
				((RecordContext)_localctx).body = expr(disn_body);

				_localctx.combo = self.collect(RecordAttr(self._solver, disn).combine_single, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(147);
				match(T__10);

				self.guide_terminal('ID')

				setState(149);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(151);
				match(T__13);

				disn_body = self.guide_nonterm('expr', RecordAttr(self._solver, disn).distill_cons_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(153);
				((RecordContext)_localctx).body = expr(disn);

				disn_tail = self.guide_nonterm('record', RecordAttr(self._solver, disn).distill_cons_tail, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				setState(155);
				((RecordContext)_localctx).tail = record(disn);

				_localctx.combo = self.collect(RecordAttr(self._solver, disn).combine_cons, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo, ((RecordContext)_localctx).tail.combo)

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
		public Distillation disn;
		public list[ECombo] combos;
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
		public ArgchainContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_argchain; }
	}

	public final ArgchainContext argchain(Distillation disn) throws RecognitionException {
		ArgchainContext _localctx = new ArgchainContext(_ctx, getState(), disn);
		enterRule(_localctx, 8, RULE_argchain);
		try {
			setState(177);
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
				setState(161);
				match(T__7);

				disn_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, disn).distill_single_content) 

				setState(163);
				((ArgchainContext)_localctx).content = expr(disn_content);

				self.guide_symbol(')')

				setState(165);
				match(T__8);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, disn).combine_single, ((ArgchainContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(168);
				match(T__7);

				disn_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, disn).distill_cons_head) 

				setState(170);
				((ArgchainContext)_localctx).head = expr(disn_head);

				self.guide_symbol(')')

				setState(172);
				match(T__8);

				disn_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, disn).distill_cons_tail, ((ArgchainContext)_localctx).head.combo) 

				setState(174);
				((ArgchainContext)_localctx).tail = argchain(disn_tail);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, disn).combine_cons, ((ArgchainContext)_localctx).head.combo, ((ArgchainContext)_localctx).tail.combos)

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
		public Distillation disn;
		public list[ECombo] combos;
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
		public PipelineContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_pipeline; }
	}

	public final PipelineContext pipeline(Distillation disn) throws RecognitionException {
		PipelineContext _localctx = new PipelineContext(_ctx, getState(), disn);
		enterRule(_localctx, 10, RULE_pipeline);
		try {
			setState(192);
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
				setState(180);
				match(T__14);

				disn_content = self.guide_nonterm('expr', PipelineAttr(self._solver, disn).distill_single_content) 

				setState(182);
				((PipelineContext)_localctx).content = expr(disn_content);

				_localctx.combos = self.collect(PipelineAttr(self._solver, disn).combine_single, ((PipelineContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(185);
				match(T__14);

				disn_head = self.guide_nonterm('expr', PipelineAttr(self._solver, disn).distill_cons_head) 

				setState(187);
				((PipelineContext)_localctx).head = expr(disn_head);

				disn_tail = self.guide_nonterm('pipeline', PipelineAttr(self._solver, disn).distill_cons_tail, ((PipelineContext)_localctx).head.combo) 

				setState(189);
				((PipelineContext)_localctx).tail = pipeline(disn_tail);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, disn).combine_cons, ((PipelineContext)_localctx).head.combo, ((PipelineContext)_localctx).tail.combos)

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
		public Distillation disn;
		public list[str] ids;
		public Token ID;
		public KeychainContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public KeychainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public KeychainContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_keychain; }
	}

	public final KeychainContext keychain(Distillation disn) throws RecognitionException {
		KeychainContext _localctx = new KeychainContext(_ctx, getState(), disn);
		enterRule(_localctx, 12, RULE_keychain);
		try {
			setState(206);
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
				setState(195);
				match(T__15);

				self.guide_terminal('ID')

				setState(197);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.ids = self.collect(KeychainAttr(self._solver, disn).combine_single, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(199);
				match(T__15);

				self.guide_terminal('ID')

				setState(201);
				((KeychainContext)_localctx).ID = match(ID);

				disn_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, disn).distill_cons_tail, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null)) 

				setState(203);
				((KeychainContext)_localctx).tail = keychain(disn_tail);

				_localctx.ids = self.collect(KeychainAttr(self._solver, disn).combine_cons, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.ids)

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
		public Distillation disn;
		public ECombo combo;
		public ExprContext expr;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TargetContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public TargetContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_target; }
	}

	public final TargetContext target(Distillation disn) throws RecognitionException {
		TargetContext _localctx = new TargetContext(_ctx, getState(), disn);
		enterRule(_localctx, 14, RULE_target);
		try {
			setState(214);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__5:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__13:
				enterOuterAlt(_localctx, 2);
				{
				setState(209);
				match(T__13);

				disn_expr = self.guide_nonterm('expr', lambda: disn)

				setState(211);
				((TargetContext)_localctx).expr = expr(disn_expr);

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
		public Distillation disn;
		public PCombo combo;
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
		public PatternContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
	}

	public final PatternContext pattern(Distillation disn) throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState(), disn);
		enterRule(_localctx, 16, RULE_pattern);
		try {
			setState(228);
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
				setState(217);
				((PatternContext)_localctx).pattern_base = pattern_base(disn);

				_localctx.combo = ((PatternContext)_localctx).pattern_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				disn_cator = self.guide_nonterm('expr', PatternAttr(self._solver, disn).distill_tuple_head)

				setState(221);
				((PatternContext)_localctx).head = base(disn);

				self.guide_symbol(',')

				setState(223);
				match(T__0);

				disn_cator = self.guide_nonterm('expr', PatternAttr(self._solver, disn).distill_tuple_tail, ((PatternContext)_localctx).head.combo)

				setState(225);
				((PatternContext)_localctx).tail = base(disn);

				_localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_tuple, ((PatternContext)_localctx).head.combo, ((PatternContext)_localctx).tail.combo) 

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
		public Distillation disn;
		public PCombo combo;
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
		public Pattern_baseContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_pattern_base; }
	}

	public final Pattern_baseContext pattern_base(Distillation disn) throws RecognitionException {
		Pattern_baseContext _localctx = new Pattern_baseContext(_ctx, getState(), disn);
		enterRule(_localctx, 18, RULE_pattern_base);
		try {
			setState(247);
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
				setState(231);
				((Pattern_baseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_var, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(233);
				((Pattern_baseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_var, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(235);
				match(T__9);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_unit)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(237);
				match(T__10);

				self.guide_terminal('ID')

				setState(239);
				((Pattern_baseContext)_localctx).ID = match(ID);

				disn_body = self.guide_nonterm('pattern', PatternBaseAttr(self._solver, disn).distill_tag_body, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				setState(241);
				((Pattern_baseContext)_localctx).body = pattern(disn_body);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_tag, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null), ((Pattern_baseContext)_localctx).body.combo)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(244);
				((Pattern_baseContext)_localctx).pattern_record = pattern_record(disn);

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
		public Distillation disn;
		public PCombo combo;
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
		public Pattern_recordContext(ParserRuleContext parent, int invokingState, Distillation disn) {
			super(parent, invokingState);
			this.disn = disn;
		}
		@Override public int getRuleIndex() { return RULE_pattern_record; }
	}

	public final Pattern_recordContext pattern_record(Distillation disn) throws RecognitionException {
		Pattern_recordContext _localctx = new Pattern_recordContext(_ctx, getState(), disn);
		enterRule(_localctx, 20, RULE_pattern_record);
		try {
			setState(270);
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
				setState(250);
				match(T__10);

				self.guide_terminal('ID')

				setState(252);
				((Pattern_recordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(254);
				match(T__13);

				disn_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, disn).distill_single_body, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null))

				setState(256);
				((Pattern_recordContext)_localctx).body = pattern(disn_body);

				_localctx.combo = self.collect(PatternRecordAttr(self._solver, disn).combine_single, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(259);
				match(T__10);

				self.guide_terminal('ID')

				setState(261);
				((Pattern_recordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(263);
				match(T__13);

				disn_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, disn).distill_cons_body, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null))

				setState(265);
				((Pattern_recordContext)_localctx).body = pattern(disn_body);

				disn_tail = self.guide_nonterm('pattern_record', PatternRecordAttr(self._solver, disn).distill_cons_tail, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo)

				setState(267);
				((Pattern_recordContext)_localctx).tail = pattern_record(disn_tail);

				_localctx.combo = self.collect(PatternRecordAttr(self._solver, disn).combine_cons, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo, ((Pattern_recordContext)_localctx).tail.combo)

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
		"\u0004\u0001\u0013\u0111\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001"+
		"\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004"+
		"\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007"+
		"\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0003\u0000V\b\u0000\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0003\u0001q\b\u0001"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0003\u0002\u0088\b\u0002\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0003\u0003\u009f\b\u0003\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0003\u0004\u00b2\b\u0004\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0003\u0005\u00c1\b\u0005\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0003\u0006\u00cf\b\u0006\u0001\u0007\u0001\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0003\u0007\u00d7\b\u0007"+
		"\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0003\b\u00e5\b\b\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0003\t\u00f8\b\t\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001\n\u0001"+
		"\n\u0003\n\u010f\b\n\u0001\n\u0000\u0000\u000b\u0000\u0002\u0004\u0006"+
		"\b\n\f\u000e\u0010\u0012\u0014\u0000\u0000\u0127\u0000U\u0001\u0000\u0000"+
		"\u0000\u0002p\u0001\u0000\u0000\u0000\u0004\u0087\u0001\u0000\u0000\u0000"+
		"\u0006\u009e\u0001\u0000\u0000\u0000\b\u00b1\u0001\u0000\u0000\u0000\n"+
		"\u00c0\u0001\u0000\u0000\u0000\f\u00ce\u0001\u0000\u0000\u0000\u000e\u00d6"+
		"\u0001\u0000\u0000\u0000\u0010\u00e4\u0001\u0000\u0000\u0000\u0012\u00f7"+
		"\u0001\u0000\u0000\u0000\u0014\u010e\u0001\u0000\u0000\u0000\u0016V\u0001"+
		"\u0000\u0000\u0000\u0017\u0018\u0003\u0002\u0001\u0000\u0018\u0019\u0006"+
		"\u0000\uffff\uffff\u0000\u0019V\u0001\u0000\u0000\u0000\u001a\u001b\u0006"+
		"\u0000\uffff\uffff\u0000\u001b\u001c\u0003\u0002\u0001\u0000\u001c\u001d"+
		"\u0006\u0000\uffff\uffff\u0000\u001d\u001e\u0005\u0001\u0000\u0000\u001e"+
		"\u001f\u0006\u0000\uffff\uffff\u0000\u001f \u0003\u0002\u0001\u0000 !"+
		"\u0006\u0000\uffff\uffff\u0000!V\u0001\u0000\u0000\u0000\"#\u0005\u0002"+
		"\u0000\u0000#$\u0006\u0000\uffff\uffff\u0000$%\u0003\u0000\u0000\u0000"+
		"%&\u0006\u0000\uffff\uffff\u0000&\'\u0005\u0003\u0000\u0000\'(\u0006\u0000"+
		"\uffff\uffff\u0000()\u0003\u0000\u0000\u0000)*\u0006\u0000\uffff\uffff"+
		"\u0000*+\u0005\u0004\u0000\u0000+,\u0006\u0000\uffff\uffff\u0000,-\u0003"+
		"\u0000\u0000\u0000-.\u0006\u0000\uffff\uffff\u0000.V\u0001\u0000\u0000"+
		"\u0000/0\u0006\u0000\uffff\uffff\u000001\u0003\u0002\u0001\u000012\u0006"+
		"\u0000\uffff\uffff\u000023\u0003\f\u0006\u000034\u0006\u0000\uffff\uffff"+
		"\u00004V\u0001\u0000\u0000\u000056\u0006\u0000\uffff\uffff\u000067\u0003"+
		"\u0002\u0001\u000078\u0006\u0000\uffff\uffff\u000089\u0003\b\u0004\u0000"+
		"9:\u0006\u0000\uffff\uffff\u0000:V\u0001\u0000\u0000\u0000;<\u0006\u0000"+
		"\uffff\uffff\u0000<=\u0003\u0002\u0001\u0000=>\u0006\u0000\uffff\uffff"+
		"\u0000>?\u0003\n\u0005\u0000?@\u0006\u0000\uffff\uffff\u0000@V\u0001\u0000"+
		"\u0000\u0000AB\u0005\u0005\u0000\u0000BC\u0006\u0000\uffff\uffff\u0000"+
		"CD\u0005\u0011\u0000\u0000DE\u0006\u0000\uffff\uffff\u0000EF\u0003\u000e"+
		"\u0007\u0000FG\u0006\u0000\uffff\uffff\u0000GH\u0005\u0006\u0000\u0000"+
		"HI\u0006\u0000\uffff\uffff\u0000IJ\u0003\u0000\u0000\u0000JK\u0006\u0000"+
		"\uffff\uffff\u0000KV\u0001\u0000\u0000\u0000LM\u0005\u0007\u0000\u0000"+
		"MN\u0006\u0000\uffff\uffff\u0000NO\u0005\b\u0000\u0000OP\u0006\u0000\uffff"+
		"\uffff\u0000PQ\u0003\u0000\u0000\u0000QR\u0006\u0000\uffff\uffff\u0000"+
		"RS\u0005\t\u0000\u0000ST\u0006\u0000\uffff\uffff\u0000TV\u0001\u0000\u0000"+
		"\u0000U\u0016\u0001\u0000\u0000\u0000U\u0017\u0001\u0000\u0000\u0000U"+
		"\u001a\u0001\u0000\u0000\u0000U\"\u0001\u0000\u0000\u0000U/\u0001\u0000"+
		"\u0000\u0000U5\u0001\u0000\u0000\u0000U;\u0001\u0000\u0000\u0000UA\u0001"+
		"\u0000\u0000\u0000UL\u0001\u0000\u0000\u0000V\u0001\u0001\u0000\u0000"+
		"\u0000Wq\u0001\u0000\u0000\u0000XY\u0005\n\u0000\u0000Yq\u0006\u0001\uffff"+
		"\uffff\u0000Z[\u0005\u000b\u0000\u0000[\\\u0006\u0001\uffff\uffff\u0000"+
		"\\]\u0005\u0011\u0000\u0000]^\u0006\u0001\uffff\uffff\u0000^_\u0003\u0000"+
		"\u0000\u0000_`\u0006\u0001\uffff\uffff\u0000`q\u0001\u0000\u0000\u0000"+
		"ab\u0003\u0006\u0003\u0000bc\u0006\u0001\uffff\uffff\u0000cq\u0001\u0000"+
		"\u0000\u0000de\u0003\u0004\u0002\u0000ef\u0006\u0001\uffff\uffff\u0000"+
		"fq\u0001\u0000\u0000\u0000gh\u0005\u0011\u0000\u0000hq\u0006\u0001\uffff"+
		"\uffff\u0000ij\u0005\b\u0000\u0000jk\u0006\u0001\uffff\uffff\u0000kl\u0003"+
		"\u0000\u0000\u0000lm\u0006\u0001\uffff\uffff\u0000mn\u0005\t\u0000\u0000"+
		"no\u0006\u0001\uffff\uffff\u0000oq\u0001\u0000\u0000\u0000pW\u0001\u0000"+
		"\u0000\u0000pX\u0001\u0000\u0000\u0000pZ\u0001\u0000\u0000\u0000pa\u0001"+
		"\u0000\u0000\u0000pd\u0001\u0000\u0000\u0000pg\u0001\u0000\u0000\u0000"+
		"pi\u0001\u0000\u0000\u0000q\u0003\u0001\u0000\u0000\u0000r\u0088\u0001"+
		"\u0000\u0000\u0000st\u0005\f\u0000\u0000tu\u0006\u0002\uffff\uffff\u0000"+
		"uv\u0003\u0010\b\u0000vw\u0006\u0002\uffff\uffff\u0000wx\u0005\r\u0000"+
		"\u0000xy\u0006\u0002\uffff\uffff\u0000yz\u0003\u0000\u0000\u0000z{\u0006"+
		"\u0002\uffff\uffff\u0000{\u0088\u0001\u0000\u0000\u0000|}\u0005\f\u0000"+
		"\u0000}~\u0006\u0002\uffff\uffff\u0000~\u007f\u0003\u0010\b\u0000\u007f"+
		"\u0080\u0006\u0002\uffff\uffff\u0000\u0080\u0081\u0005\r\u0000\u0000\u0081"+
		"\u0082\u0006\u0002\uffff\uffff\u0000\u0082\u0083\u0003\u0000\u0000\u0000"+
		"\u0083\u0084\u0006\u0002\uffff\uffff\u0000\u0084\u0085\u0003\u0004\u0002"+
		"\u0000\u0085\u0086\u0006\u0002\uffff\uffff\u0000\u0086\u0088\u0001\u0000"+
		"\u0000\u0000\u0087r\u0001\u0000\u0000\u0000\u0087s\u0001\u0000\u0000\u0000"+
		"\u0087|\u0001\u0000\u0000\u0000\u0088\u0005\u0001\u0000\u0000\u0000\u0089"+
		"\u009f\u0001\u0000\u0000\u0000\u008a\u008b\u0005\u000b\u0000\u0000\u008b"+
		"\u008c\u0006\u0003\uffff\uffff\u0000\u008c\u008d\u0005\u0011\u0000\u0000"+
		"\u008d\u008e\u0006\u0003\uffff\uffff\u0000\u008e\u008f\u0005\u000e\u0000"+
		"\u0000\u008f\u0090\u0006\u0003\uffff\uffff\u0000\u0090\u0091\u0003\u0000"+
		"\u0000\u0000\u0091\u0092\u0006\u0003\uffff\uffff\u0000\u0092\u009f\u0001"+
		"\u0000\u0000\u0000\u0093\u0094\u0005\u000b\u0000\u0000\u0094\u0095\u0006"+
		"\u0003\uffff\uffff\u0000\u0095\u0096\u0005\u0011\u0000\u0000\u0096\u0097"+
		"\u0006\u0003\uffff\uffff\u0000\u0097\u0098\u0005\u000e\u0000\u0000\u0098"+
		"\u0099\u0006\u0003\uffff\uffff\u0000\u0099\u009a\u0003\u0000\u0000\u0000"+
		"\u009a\u009b\u0006\u0003\uffff\uffff\u0000\u009b\u009c\u0003\u0006\u0003"+
		"\u0000\u009c\u009d\u0006\u0003\uffff\uffff\u0000\u009d\u009f\u0001\u0000"+
		"\u0000\u0000\u009e\u0089\u0001\u0000\u0000\u0000\u009e\u008a\u0001\u0000"+
		"\u0000\u0000\u009e\u0093\u0001\u0000\u0000\u0000\u009f\u0007\u0001\u0000"+
		"\u0000\u0000\u00a0\u00b2\u0001\u0000\u0000\u0000\u00a1\u00a2\u0005\b\u0000"+
		"\u0000\u00a2\u00a3\u0006\u0004\uffff\uffff\u0000\u00a3\u00a4\u0003\u0000"+
		"\u0000\u0000\u00a4\u00a5\u0006\u0004\uffff\uffff\u0000\u00a5\u00a6\u0005"+
		"\t\u0000\u0000\u00a6\u00a7\u0006\u0004\uffff\uffff\u0000\u00a7\u00b2\u0001"+
		"\u0000\u0000\u0000\u00a8\u00a9\u0005\b\u0000\u0000\u00a9\u00aa\u0006\u0004"+
		"\uffff\uffff\u0000\u00aa\u00ab\u0003\u0000\u0000\u0000\u00ab\u00ac\u0006"+
		"\u0004\uffff\uffff\u0000\u00ac\u00ad\u0005\t\u0000\u0000\u00ad\u00ae\u0006"+
		"\u0004\uffff\uffff\u0000\u00ae\u00af\u0003\b\u0004\u0000\u00af\u00b0\u0006"+
		"\u0004\uffff\uffff\u0000\u00b0\u00b2\u0001\u0000\u0000\u0000\u00b1\u00a0"+
		"\u0001\u0000\u0000\u0000\u00b1\u00a1\u0001\u0000\u0000\u0000\u00b1\u00a8"+
		"\u0001\u0000\u0000\u0000\u00b2\t\u0001\u0000\u0000\u0000\u00b3\u00c1\u0001"+
		"\u0000\u0000\u0000\u00b4\u00b5\u0005\u000f\u0000\u0000\u00b5\u00b6\u0006"+
		"\u0005\uffff\uffff\u0000\u00b6\u00b7\u0003\u0000\u0000\u0000\u00b7\u00b8"+
		"\u0006\u0005\uffff\uffff\u0000\u00b8\u00c1\u0001\u0000\u0000\u0000\u00b9"+
		"\u00ba\u0005\u000f\u0000\u0000\u00ba\u00bb\u0006\u0005\uffff\uffff\u0000"+
		"\u00bb\u00bc\u0003\u0000\u0000\u0000\u00bc\u00bd\u0006\u0005\uffff\uffff"+
		"\u0000\u00bd\u00be\u0003\n\u0005\u0000\u00be\u00bf\u0006\u0005\uffff\uffff"+
		"\u0000\u00bf\u00c1\u0001\u0000\u0000\u0000\u00c0\u00b3\u0001\u0000\u0000"+
		"\u0000\u00c0\u00b4\u0001\u0000\u0000\u0000\u00c0\u00b9\u0001\u0000\u0000"+
		"\u0000\u00c1\u000b\u0001\u0000\u0000\u0000\u00c2\u00cf\u0001\u0000\u0000"+
		"\u0000\u00c3\u00c4\u0005\u0010\u0000\u0000\u00c4\u00c5\u0006\u0006\uffff"+
		"\uffff\u0000\u00c5\u00c6\u0005\u0011\u0000\u0000\u00c6\u00cf\u0006\u0006"+
		"\uffff\uffff\u0000\u00c7\u00c8\u0005\u0010\u0000\u0000\u00c8\u00c9\u0006"+
		"\u0006\uffff\uffff\u0000\u00c9\u00ca\u0005\u0011\u0000\u0000\u00ca\u00cb"+
		"\u0006\u0006\uffff\uffff\u0000\u00cb\u00cc\u0003\f\u0006\u0000\u00cc\u00cd"+
		"\u0006\u0006\uffff\uffff\u0000\u00cd\u00cf\u0001\u0000\u0000\u0000\u00ce"+
		"\u00c2\u0001\u0000\u0000\u0000\u00ce\u00c3\u0001\u0000\u0000\u0000\u00ce"+
		"\u00c7\u0001\u0000\u0000\u0000\u00cf\r\u0001\u0000\u0000\u0000\u00d0\u00d7"+
		"\u0001\u0000\u0000\u0000\u00d1\u00d2\u0005\u000e\u0000\u0000\u00d2\u00d3"+
		"\u0006\u0007\uffff\uffff\u0000\u00d3\u00d4\u0003\u0000\u0000\u0000\u00d4"+
		"\u00d5\u0006\u0007\uffff\uffff\u0000\u00d5\u00d7\u0001\u0000\u0000\u0000"+
		"\u00d6\u00d0\u0001\u0000\u0000\u0000\u00d6\u00d1\u0001\u0000\u0000\u0000"+
		"\u00d7\u000f\u0001\u0000\u0000\u0000\u00d8\u00e5\u0001\u0000\u0000\u0000"+
		"\u00d9\u00da\u0003\u0012\t\u0000\u00da\u00db\u0006\b\uffff\uffff\u0000"+
		"\u00db\u00e5\u0001\u0000\u0000\u0000\u00dc\u00dd\u0006\b\uffff\uffff\u0000"+
		"\u00dd\u00de\u0003\u0002\u0001\u0000\u00de\u00df\u0006\b\uffff\uffff\u0000"+
		"\u00df\u00e0\u0005\u0001\u0000\u0000\u00e0\u00e1\u0006\b\uffff\uffff\u0000"+
		"\u00e1\u00e2\u0003\u0002\u0001\u0000\u00e2\u00e3\u0006\b\uffff\uffff\u0000"+
		"\u00e3\u00e5\u0001\u0000\u0000\u0000\u00e4\u00d8\u0001\u0000\u0000\u0000"+
		"\u00e4\u00d9\u0001\u0000\u0000\u0000\u00e4\u00dc\u0001\u0000\u0000\u0000"+
		"\u00e5\u0011\u0001\u0000\u0000\u0000\u00e6\u00f8\u0001\u0000\u0000\u0000"+
		"\u00e7\u00e8\u0005\u0011\u0000\u0000\u00e8\u00f8\u0006\t\uffff\uffff\u0000"+
		"\u00e9\u00ea\u0005\u0011\u0000\u0000\u00ea\u00f8\u0006\t\uffff\uffff\u0000"+
		"\u00eb\u00ec\u0005\n\u0000\u0000\u00ec\u00f8\u0006\t\uffff\uffff\u0000"+
		"\u00ed\u00ee\u0005\u000b\u0000\u0000\u00ee\u00ef\u0006\t\uffff\uffff\u0000"+
		"\u00ef\u00f0\u0005\u0011\u0000\u0000\u00f0\u00f1\u0006\t\uffff\uffff\u0000"+
		"\u00f1\u00f2\u0003\u0010\b\u0000\u00f2\u00f3\u0006\t\uffff\uffff\u0000"+
		"\u00f3\u00f8\u0001\u0000\u0000\u0000\u00f4\u00f5\u0003\u0014\n\u0000\u00f5"+
		"\u00f6\u0006\t\uffff\uffff\u0000\u00f6\u00f8\u0001\u0000\u0000\u0000\u00f7"+
		"\u00e6\u0001\u0000\u0000\u0000\u00f7\u00e7\u0001\u0000\u0000\u0000\u00f7"+
		"\u00e9\u0001\u0000\u0000\u0000\u00f7\u00eb\u0001\u0000\u0000\u0000\u00f7"+
		"\u00ed\u0001\u0000\u0000\u0000\u00f7\u00f4\u0001\u0000\u0000\u0000\u00f8"+
		"\u0013\u0001\u0000\u0000\u0000\u00f9\u010f\u0001\u0000\u0000\u0000\u00fa"+
		"\u00fb\u0005\u000b\u0000\u0000\u00fb\u00fc\u0006\n\uffff\uffff\u0000\u00fc"+
		"\u00fd\u0005\u0011\u0000\u0000\u00fd\u00fe\u0006\n\uffff\uffff\u0000\u00fe"+
		"\u00ff\u0005\u000e\u0000\u0000\u00ff\u0100\u0006\n\uffff\uffff\u0000\u0100"+
		"\u0101\u0003\u0010\b\u0000\u0101\u0102\u0006\n\uffff\uffff\u0000\u0102"+
		"\u010f\u0001\u0000\u0000\u0000\u0103\u0104\u0005\u000b\u0000\u0000\u0104"+
		"\u0105\u0006\n\uffff\uffff\u0000\u0105\u0106\u0005\u0011\u0000\u0000\u0106"+
		"\u0107\u0006\n\uffff\uffff\u0000\u0107\u0108\u0005\u000e\u0000\u0000\u0108"+
		"\u0109\u0006\n\uffff\uffff\u0000\u0109\u010a\u0003\u0010\b\u0000\u010a"+
		"\u010b\u0006\n\uffff\uffff\u0000\u010b\u010c\u0003\u0014\n\u0000\u010c"+
		"\u010d\u0006\n\uffff\uffff\u0000\u010d\u010f\u0001\u0000\u0000\u0000\u010e"+
		"\u00f9\u0001\u0000\u0000\u0000\u010e\u00fa\u0001\u0000\u0000\u0000\u010e"+
		"\u0103\u0001\u0000\u0000\u0000\u010f\u0015\u0001\u0000\u0000\u0000\u000b"+
		"Up\u0087\u009e\u00b1\u00c0\u00ce\u00d6\u00e4\u00f7\u010e";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}