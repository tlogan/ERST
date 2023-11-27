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
		T__9=10, T__10=11, T__11=12, ID=13, INT=14, WS=15;
	public static final int
		RULE_expr = 0, RULE_base = 1, RULE_function = 2, RULE_record = 3, RULE_argchain = 4, 
		RULE_keychain = 5, RULE_target = 6, RULE_pattern = 7, RULE_pattern_base = 8, 
		RULE_pattern_record = 9;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "base", "function", "record", "argchain", "keychain", "target", 
			"pattern", "pattern_base", "pattern_record"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "','", "'let'", "';'", "'fix'", "'('", "')'", "'@'", "':'", "'case'", 
			"'=>'", "'='", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, "ID", "INT", "WS"
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
	    self._guidance = distillation_default 
	    self._overflow = False  

	def reset(self): 
	    self._guidance = distillation_default
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

	    distillation_result = None
	    if not self._overflow:
	        distillation_result = f(*args)
	        self._guidance = Nonterm(name, distillation_result)

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 

	    return distillation_result 



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
		public Distillation distillation;
		public ECombo combo;
		public BaseContext base;
		public BaseContext left;
		public BaseContext right;
		public BaseContext cator;
		public KeychainContext keychain;
		public ArgchainContext content;
		public ArgchainContext argchain;
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
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public ArgchainContext argchain() {
			return getRuleContext(ArgchainContext.class,0);
		}
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public TargetContext target() {
			return getRuleContext(TargetContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ExprContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(Distillation distillation) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), distillation);
		enterRule(_localctx, 0, RULE_expr);
		try {
			setState(64);
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
				setState(21);
				((ExprContext)_localctx).base = base(distillation);

				_localctx.combo = ((ExprContext)_localctx).base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_tuple_left)

				setState(25);
				((ExprContext)_localctx).left = base(distillation);

				self.guide_symbol(',')

				setState(27);
				match(T__0);

				distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_tuple_right, ((ExprContext)_localctx).left.combo)

				setState(29);
				((ExprContext)_localctx).right = base(distillation);

				_localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_tuple, ((ExprContext)_localctx).left.combo, ((ExprContext)_localctx).right.combo) 

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{

				distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_projection_cator)

				setState(33);
				((ExprContext)_localctx).cator = base(distillation_cator);

				distillation_keychain = self.guide_nonterm('keychain', ExprAttr(self._solver, distillation).distill_projection_keychain, ((ExprContext)_localctx).cator.combo)

				setState(35);
				((ExprContext)_localctx).keychain = keychain(distillation_keychain);

				_localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_projection, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{

				distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_application_cator)

				setState(39);
				((ExprContext)_localctx).cator = base(distillation_cator);

				distillation_argchain = self.guide_nonterm('argchain', ExprAttr(self._solver, distillation).distill_application_argchain, ((ExprContext)_localctx).cator.combo)

				setState(41);
				((ExprContext)_localctx).content = ((ExprContext)_localctx).argchain = argchain(distillation_argchain);

				_localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_application, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).argchain.combos)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(44);
				match(T__1);

				self.guide_terminal('ID')

				setState(46);
				((ExprContext)_localctx).ID = match(ID);

				distillation_target = self.guide_nonterm('target', ExprAttr(self._solver, distillation).distill_let_target, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(48);
				((ExprContext)_localctx).target = target(distillation_target);

				self.guide_symbol(';')

				setState(50);
				match(T__2);

				distillation_contin = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_let_contin, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.combo)

				setState(52);
				((ExprContext)_localctx).contin = expr(distillation_contin);

				_localctx.combo = ((ExprContext)_localctx).contin.combo

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(55);
				match(T__3);

				self.guide_symbol('(')

				setState(57);
				match(T__4);

				distillation_body = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_fix_body)

				setState(59);
				((ExprContext)_localctx).body = expr(distillation_body);

				self.guide_symbol(')')

				setState(61);
				match(T__5);

				_localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_fix, ((ExprContext)_localctx).body.combo)

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
		public Distillation distillation;
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
		public BaseContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_base; }
	}

	public final BaseContext base(Distillation distillation) throws RecognitionException {
		BaseContext _localctx = new BaseContext(_ctx, getState(), distillation);
		enterRule(_localctx, 2, RULE_base);
		try {
			setState(91);
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
				setState(67);
				match(T__6);

				_localctx.combo = self.collect(BaseAttr(self._solver, distillation).combine_unit)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(69);
				match(T__7);

				self.guide_terminal('ID')

				setState(71);
				((BaseContext)_localctx).ID = match(ID);

				distillation_body = self.guide_nonterm('expr', BaseAttr(self._solver, distillation).distill_tag_body, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				setState(73);
				((BaseContext)_localctx).body = expr(distillation_body);

				_localctx.combo = self.collect(BaseAttr(self._solver, distillation).combine_tag, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null), ((BaseContext)_localctx).body.combo)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(76);
				((BaseContext)_localctx).record = record(distillation);

				_localctx.combo = ((BaseContext)_localctx).record.combo

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(79);
				((BaseContext)_localctx).function = function(distillation);

				_localctx.combo = ((BaseContext)_localctx).function.combo

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(82);
				((BaseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(BaseAttr(self._solver, distillation).combine_var, (((BaseContext)_localctx).ID!=null?((BaseContext)_localctx).ID.getText():null))

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(84);
				match(T__4);

				distillation_expr = self.guide_nonterm('expr', lambda: distillation)

				setState(86);
				((BaseContext)_localctx).expr = expr(distillation_expr);

				self.guide_symbol(')')

				setState(88);
				match(T__5);

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
		public Distillation distillation;
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
		public FunctionContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function(Distillation distillation) throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState(), distillation);
		enterRule(_localctx, 4, RULE_function);
		try {
			setState(114);
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
				setState(94);
				match(T__8);

				distillation_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, distillation).distill_single_pattern)

				setState(96);
				((FunctionContext)_localctx).pattern = pattern(distillation_pattern);

				self.guide_symbol('=>')

				setState(98);
				match(T__9);

				distillation_body = self.guide_nonterm('expr', FunctionAttr(self._solver, distillation).distill_single_body, ((FunctionContext)_localctx).pattern.combo)

				setState(100);
				((FunctionContext)_localctx).body = expr(distillation_body);

				_localctx.combo = self.collect(FunctionAttr(self._solver, distillation).combine_single, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(103);
				match(T__8);

				distillation_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, distillation).distill_cons_pattern)

				setState(105);
				((FunctionContext)_localctx).pattern = pattern(distillation_pattern);

				self.guide_symbol('=>')

				setState(107);
				match(T__9);

				distillation_body = self.guide_nonterm('expr', FunctionAttr(self._solver, distillation).distill_cons_body, ((FunctionContext)_localctx).pattern.combo)

				setState(109);
				((FunctionContext)_localctx).body = expr(distillation_body);

				distillation_tail = self.guide_nonterm('function', FunctionAttr(self._solver, distillation).distill_cons_tail, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				setState(111);
				((FunctionContext)_localctx).tail = function(distillation);

				_localctx.combo = self.collect(FunctionAttr(self._solver, distillation).combine_cons, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo, ((FunctionContext)_localctx).tail.combo)

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
		public Distillation distillation;
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
		public RecordContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record(Distillation distillation) throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState(), distillation);
		enterRule(_localctx, 6, RULE_record);
		try {
			setState(137);
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
				setState(117);
				match(T__7);

				self.guide_terminal('ID')

				setState(119);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(121);
				match(T__10);

				distillation_body = self.guide_nonterm('expr', RecordAttr(self._solver, distillation).distill_single_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(123);
				((RecordContext)_localctx).body = expr(distillation_body);

				_localctx.combo = self.collect(RecordAttr(self._solver, distillation).combine_single, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(126);
				match(T__7);

				self.guide_terminal('ID')

				setState(128);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(130);
				match(T__10);

				distillation_body = self.guide_nonterm('expr', RecordAttr(self._solver, distillation).distill_cons_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(132);
				((RecordContext)_localctx).body = expr(distillation);

				distillation_tail = self.guide_nonterm('record', RecordAttr(self._solver, distillation).distill_cons_tail, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				setState(134);
				((RecordContext)_localctx).tail = record(distillation);

				_localctx.combo = self.collect(RecordAttr(self._solver, distillation).combine_cons, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo, ((RecordContext)_localctx).tail.combo)

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
		public Distillation distillation;
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
		public ArgchainContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_argchain; }
	}

	public final ArgchainContext argchain(Distillation distillation) throws RecognitionException {
		ArgchainContext _localctx = new ArgchainContext(_ctx, getState(), distillation);
		enterRule(_localctx, 8, RULE_argchain);
		try {
			setState(156);
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
				setState(140);
				match(T__4);

				distillation_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, distillation).distill_single_content) 

				setState(142);
				((ArgchainContext)_localctx).content = expr(distillation_content);

				self.guide_symbol(')')

				setState(144);
				match(T__5);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, distillation).combine_single, ((ArgchainContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(147);
				match(T__4);

				distillation_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, distillation).distill_cons_head) 

				setState(149);
				((ArgchainContext)_localctx).head = expr(distillation_head);

				self.guide_symbol(')')

				setState(151);
				match(T__5);

				distillation_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, distillation).distill_cons_tail, ((ArgchainContext)_localctx).head.combo) 

				setState(153);
				((ArgchainContext)_localctx).tail = argchain(distillation_tail);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, distillation).combine_cons, ((ArgchainContext)_localctx).head.combo, ((ArgchainContext)_localctx).tail.combos)

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
		public Distillation distillation;
		public list[str] ids;
		public Token ID;
		public KeychainContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public KeychainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public KeychainContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_keychain; }
	}

	public final KeychainContext keychain(Distillation distillation) throws RecognitionException {
		KeychainContext _localctx = new KeychainContext(_ctx, getState(), distillation);
		enterRule(_localctx, 10, RULE_keychain);
		try {
			setState(170);
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
				setState(159);
				match(T__11);

				self.guide_terminal('ID')

				setState(161);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.ids = self.collect(KeychainAttr(self._solver, distillation).combine_single, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(163);
				match(T__11);

				self.guide_terminal('ID')

				setState(165);
				((KeychainContext)_localctx).ID = match(ID);

				distillation_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, distillation).distill_cons_tail, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null)) 

				setState(167);
				((KeychainContext)_localctx).tail = keychain(distillation_tail);

				_localctx.ids = self.collect(KeychainAttr(self._solver, distillation).combine_cons, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.ids)

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
		public Distillation distillation;
		public ECombo combo;
		public ExprContext expr;
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TargetContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public TargetContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_target; }
	}

	public final TargetContext target(Distillation distillation) throws RecognitionException {
		TargetContext _localctx = new TargetContext(_ctx, getState(), distillation);
		enterRule(_localctx, 12, RULE_target);
		try {
			setState(178);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__2:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__10:
				enterOuterAlt(_localctx, 2);
				{
				setState(173);
				match(T__10);

				distillation_expr = self.guide_nonterm('expr', lambda: distillation)

				setState(175);
				((TargetContext)_localctx).expr = expr(distillation_expr);

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
		public Distillation distillation;
		public PCombo combo;
		public Pattern_baseContext pattern_base;
		public BaseContext left;
		public BaseContext right;
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
		public PatternContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
	}

	public final PatternContext pattern(Distillation distillation) throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState(), distillation);
		enterRule(_localctx, 14, RULE_pattern);
		try {
			setState(192);
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
				setState(181);
				((PatternContext)_localctx).pattern_base = pattern_base(distillation);

				_localctx.combo = ((PatternContext)_localctx).pattern_base.combo

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{

				distillation_cator = self.guide_nonterm('expr', PatternAttr(self._solver, distillation).distill_tuple_left)

				setState(185);
				((PatternContext)_localctx).left = base(distillation);

				self.guide_symbol(',')

				setState(187);
				match(T__0);

				distillation_cator = self.guide_nonterm('expr', PatternAttr(self._solver, distillation).distill_tuple_right, ((PatternContext)_localctx).left.combo)

				setState(189);
				((PatternContext)_localctx).right = base(distillation);

				_localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_tuple, ((PatternContext)_localctx).left.combo, ((PatternContext)_localctx).right.combo) 

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
		public Distillation distillation;
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
		public Pattern_baseContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_pattern_base; }
	}

	public final Pattern_baseContext pattern_base(Distillation distillation) throws RecognitionException {
		Pattern_baseContext _localctx = new Pattern_baseContext(_ctx, getState(), distillation);
		enterRule(_localctx, 16, RULE_pattern_base);
		try {
			setState(211);
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
				setState(195);
				((Pattern_baseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_var, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(197);
				((Pattern_baseContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_var, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(199);
				match(T__6);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_unit)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(201);
				match(T__7);

				self.guide_terminal('ID')

				setState(203);
				((Pattern_baseContext)_localctx).ID = match(ID);

				distillation_body = self.guide_nonterm('pattern', PatternBaseAttr(self._solver, distillation).distill_tag_body, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null))

				setState(205);
				((Pattern_baseContext)_localctx).body = pattern(distillation_body);

				_localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_tag, (((Pattern_baseContext)_localctx).ID!=null?((Pattern_baseContext)_localctx).ID.getText():null), ((Pattern_baseContext)_localctx).body.combo)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(208);
				((Pattern_baseContext)_localctx).pattern_record = pattern_record(distillation);

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
		public Distillation distillation;
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
		public Pattern_recordContext(ParserRuleContext parent, int invokingState, Distillation distillation) {
			super(parent, invokingState);
			this.distillation = distillation;
		}
		@Override public int getRuleIndex() { return RULE_pattern_record; }
	}

	public final Pattern_recordContext pattern_record(Distillation distillation) throws RecognitionException {
		Pattern_recordContext _localctx = new Pattern_recordContext(_ctx, getState(), distillation);
		enterRule(_localctx, 18, RULE_pattern_record);
		try {
			setState(234);
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
				setState(214);
				match(T__7);

				self.guide_terminal('ID')

				setState(216);
				((Pattern_recordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(218);
				match(T__10);

				distillation_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, distillation).distill_single_body, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null))

				setState(220);
				((Pattern_recordContext)_localctx).body = pattern(distillation_body);

				_localctx.combo = self.collect(PatternRecordAttr(self._solver, distillation).combine_single, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(223);
				match(T__7);

				self.guide_terminal('ID')

				setState(225);
				((Pattern_recordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(227);
				match(T__10);

				distillation_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, distillation).distill_cons_body, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null))

				setState(229);
				((Pattern_recordContext)_localctx).body = pattern(distillation_body);

				distillation_tail = self.guide_nonterm('pattern_record', PatternRecordAttr(self._solver, distillation).distill_cons_tail, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo)

				setState(231);
				((Pattern_recordContext)_localctx).tail = pattern_record(distillation_tail);

				_localctx.combo = self.collect(PatternRecordAttr(self._solver, distillation).combine_cons, (((Pattern_recordContext)_localctx).ID!=null?((Pattern_recordContext)_localctx).ID.getText():null), ((Pattern_recordContext)_localctx).body.combo, ((Pattern_recordContext)_localctx).tail.combo)

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
		"\u0004\u0001\u000f\u00ed\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001"+
		"\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004"+
		"\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007"+
		"\u0002\b\u0007\b\u0002\t\u0007\t\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u0000A\b"+
		"\u0000\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0003\u0001\\\b\u0001\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0003\u0002s\b\u0002\u0001\u0003\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0003"+
		"\u0003\u008a\b\u0003\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001"+
		"\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001"+
		"\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001"+
		"\u0004\u0003\u0004\u009d\b\u0004\u0001\u0005\u0001\u0005\u0001\u0005\u0001"+
		"\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001"+
		"\u0005\u0001\u0005\u0001\u0005\u0003\u0005\u00ab\b\u0005\u0001\u0006\u0001"+
		"\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0003\u0006\u00b3"+
		"\b\u0006\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001"+
		"\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001"+
		"\u0007\u0003\u0007\u00c1\b\u0007\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001\b\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0003\b\u00d4\b\b\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0001\t\u0003"+
		"\t\u00eb\b\t\u0001\t\u0000\u0000\n\u0000\u0002\u0004\u0006\b\n\f\u000e"+
		"\u0010\u0012\u0000\u0000\u0100\u0000@\u0001\u0000\u0000\u0000\u0002[\u0001"+
		"\u0000\u0000\u0000\u0004r\u0001\u0000\u0000\u0000\u0006\u0089\u0001\u0000"+
		"\u0000\u0000\b\u009c\u0001\u0000\u0000\u0000\n\u00aa\u0001\u0000\u0000"+
		"\u0000\f\u00b2\u0001\u0000\u0000\u0000\u000e\u00c0\u0001\u0000\u0000\u0000"+
		"\u0010\u00d3\u0001\u0000\u0000\u0000\u0012\u00ea\u0001\u0000\u0000\u0000"+
		"\u0014A\u0001\u0000\u0000\u0000\u0015\u0016\u0003\u0002\u0001\u0000\u0016"+
		"\u0017\u0006\u0000\uffff\uffff\u0000\u0017A\u0001\u0000\u0000\u0000\u0018"+
		"\u0019\u0006\u0000\uffff\uffff\u0000\u0019\u001a\u0003\u0002\u0001\u0000"+
		"\u001a\u001b\u0006\u0000\uffff\uffff\u0000\u001b\u001c\u0005\u0001\u0000"+
		"\u0000\u001c\u001d\u0006\u0000\uffff\uffff\u0000\u001d\u001e\u0003\u0002"+
		"\u0001\u0000\u001e\u001f\u0006\u0000\uffff\uffff\u0000\u001fA\u0001\u0000"+
		"\u0000\u0000 !\u0006\u0000\uffff\uffff\u0000!\"\u0003\u0002\u0001\u0000"+
		"\"#\u0006\u0000\uffff\uffff\u0000#$\u0003\n\u0005\u0000$%\u0006\u0000"+
		"\uffff\uffff\u0000%A\u0001\u0000\u0000\u0000&\'\u0006\u0000\uffff\uffff"+
		"\u0000\'(\u0003\u0002\u0001\u0000()\u0006\u0000\uffff\uffff\u0000)*\u0003"+
		"\b\u0004\u0000*+\u0006\u0000\uffff\uffff\u0000+A\u0001\u0000\u0000\u0000"+
		",-\u0005\u0002\u0000\u0000-.\u0006\u0000\uffff\uffff\u0000./\u0005\r\u0000"+
		"\u0000/0\u0006\u0000\uffff\uffff\u000001\u0003\f\u0006\u000012\u0006\u0000"+
		"\uffff\uffff\u000023\u0005\u0003\u0000\u000034\u0006\u0000\uffff\uffff"+
		"\u000045\u0003\u0000\u0000\u000056\u0006\u0000\uffff\uffff\u00006A\u0001"+
		"\u0000\u0000\u000078\u0005\u0004\u0000\u000089\u0006\u0000\uffff\uffff"+
		"\u00009:\u0005\u0005\u0000\u0000:;\u0006\u0000\uffff\uffff\u0000;<\u0003"+
		"\u0000\u0000\u0000<=\u0006\u0000\uffff\uffff\u0000=>\u0005\u0006\u0000"+
		"\u0000>?\u0006\u0000\uffff\uffff\u0000?A\u0001\u0000\u0000\u0000@\u0014"+
		"\u0001\u0000\u0000\u0000@\u0015\u0001\u0000\u0000\u0000@\u0018\u0001\u0000"+
		"\u0000\u0000@ \u0001\u0000\u0000\u0000@&\u0001\u0000\u0000\u0000@,\u0001"+
		"\u0000\u0000\u0000@7\u0001\u0000\u0000\u0000A\u0001\u0001\u0000\u0000"+
		"\u0000B\\\u0001\u0000\u0000\u0000CD\u0005\u0007\u0000\u0000D\\\u0006\u0001"+
		"\uffff\uffff\u0000EF\u0005\b\u0000\u0000FG\u0006\u0001\uffff\uffff\u0000"+
		"GH\u0005\r\u0000\u0000HI\u0006\u0001\uffff\uffff\u0000IJ\u0003\u0000\u0000"+
		"\u0000JK\u0006\u0001\uffff\uffff\u0000K\\\u0001\u0000\u0000\u0000LM\u0003"+
		"\u0006\u0003\u0000MN\u0006\u0001\uffff\uffff\u0000N\\\u0001\u0000\u0000"+
		"\u0000OP\u0003\u0004\u0002\u0000PQ\u0006\u0001\uffff\uffff\u0000Q\\\u0001"+
		"\u0000\u0000\u0000RS\u0005\r\u0000\u0000S\\\u0006\u0001\uffff\uffff\u0000"+
		"TU\u0005\u0005\u0000\u0000UV\u0006\u0001\uffff\uffff\u0000VW\u0003\u0000"+
		"\u0000\u0000WX\u0006\u0001\uffff\uffff\u0000XY\u0005\u0006\u0000\u0000"+
		"YZ\u0006\u0001\uffff\uffff\u0000Z\\\u0001\u0000\u0000\u0000[B\u0001\u0000"+
		"\u0000\u0000[C\u0001\u0000\u0000\u0000[E\u0001\u0000\u0000\u0000[L\u0001"+
		"\u0000\u0000\u0000[O\u0001\u0000\u0000\u0000[R\u0001\u0000\u0000\u0000"+
		"[T\u0001\u0000\u0000\u0000\\\u0003\u0001\u0000\u0000\u0000]s\u0001\u0000"+
		"\u0000\u0000^_\u0005\t\u0000\u0000_`\u0006\u0002\uffff\uffff\u0000`a\u0003"+
		"\u000e\u0007\u0000ab\u0006\u0002\uffff\uffff\u0000bc\u0005\n\u0000\u0000"+
		"cd\u0006\u0002\uffff\uffff\u0000de\u0003\u0000\u0000\u0000ef\u0006\u0002"+
		"\uffff\uffff\u0000fs\u0001\u0000\u0000\u0000gh\u0005\t\u0000\u0000hi\u0006"+
		"\u0002\uffff\uffff\u0000ij\u0003\u000e\u0007\u0000jk\u0006\u0002\uffff"+
		"\uffff\u0000kl\u0005\n\u0000\u0000lm\u0006\u0002\uffff\uffff\u0000mn\u0003"+
		"\u0000\u0000\u0000no\u0006\u0002\uffff\uffff\u0000op\u0003\u0004\u0002"+
		"\u0000pq\u0006\u0002\uffff\uffff\u0000qs\u0001\u0000\u0000\u0000r]\u0001"+
		"\u0000\u0000\u0000r^\u0001\u0000\u0000\u0000rg\u0001\u0000\u0000\u0000"+
		"s\u0005\u0001\u0000\u0000\u0000t\u008a\u0001\u0000\u0000\u0000uv\u0005"+
		"\b\u0000\u0000vw\u0006\u0003\uffff\uffff\u0000wx\u0005\r\u0000\u0000x"+
		"y\u0006\u0003\uffff\uffff\u0000yz\u0005\u000b\u0000\u0000z{\u0006\u0003"+
		"\uffff\uffff\u0000{|\u0003\u0000\u0000\u0000|}\u0006\u0003\uffff\uffff"+
		"\u0000}\u008a\u0001\u0000\u0000\u0000~\u007f\u0005\b\u0000\u0000\u007f"+
		"\u0080\u0006\u0003\uffff\uffff\u0000\u0080\u0081\u0005\r\u0000\u0000\u0081"+
		"\u0082\u0006\u0003\uffff\uffff\u0000\u0082\u0083\u0005\u000b\u0000\u0000"+
		"\u0083\u0084\u0006\u0003\uffff\uffff\u0000\u0084\u0085\u0003\u0000\u0000"+
		"\u0000\u0085\u0086\u0006\u0003\uffff\uffff\u0000\u0086\u0087\u0003\u0006"+
		"\u0003\u0000\u0087\u0088\u0006\u0003\uffff\uffff\u0000\u0088\u008a\u0001"+
		"\u0000\u0000\u0000\u0089t\u0001\u0000\u0000\u0000\u0089u\u0001\u0000\u0000"+
		"\u0000\u0089~\u0001\u0000\u0000\u0000\u008a\u0007\u0001\u0000\u0000\u0000"+
		"\u008b\u009d\u0001\u0000\u0000\u0000\u008c\u008d\u0005\u0005\u0000\u0000"+
		"\u008d\u008e\u0006\u0004\uffff\uffff\u0000\u008e\u008f\u0003\u0000\u0000"+
		"\u0000\u008f\u0090\u0006\u0004\uffff\uffff\u0000\u0090\u0091\u0005\u0006"+
		"\u0000\u0000\u0091\u0092\u0006\u0004\uffff\uffff\u0000\u0092\u009d\u0001"+
		"\u0000\u0000\u0000\u0093\u0094\u0005\u0005\u0000\u0000\u0094\u0095\u0006"+
		"\u0004\uffff\uffff\u0000\u0095\u0096\u0003\u0000\u0000\u0000\u0096\u0097"+
		"\u0006\u0004\uffff\uffff\u0000\u0097\u0098\u0005\u0006\u0000\u0000\u0098"+
		"\u0099\u0006\u0004\uffff\uffff\u0000\u0099\u009a\u0003\b\u0004\u0000\u009a"+
		"\u009b\u0006\u0004\uffff\uffff\u0000\u009b\u009d\u0001\u0000\u0000\u0000"+
		"\u009c\u008b\u0001\u0000\u0000\u0000\u009c\u008c\u0001\u0000\u0000\u0000"+
		"\u009c\u0093\u0001\u0000\u0000\u0000\u009d\t\u0001\u0000\u0000\u0000\u009e"+
		"\u00ab\u0001\u0000\u0000\u0000\u009f\u00a0\u0005\f\u0000\u0000\u00a0\u00a1"+
		"\u0006\u0005\uffff\uffff\u0000\u00a1\u00a2\u0005\r\u0000\u0000\u00a2\u00ab"+
		"\u0006\u0005\uffff\uffff\u0000\u00a3\u00a4\u0005\f\u0000\u0000\u00a4\u00a5"+
		"\u0006\u0005\uffff\uffff\u0000\u00a5\u00a6\u0005\r\u0000\u0000\u00a6\u00a7"+
		"\u0006\u0005\uffff\uffff\u0000\u00a7\u00a8\u0003\n\u0005\u0000\u00a8\u00a9"+
		"\u0006\u0005\uffff\uffff\u0000\u00a9\u00ab\u0001\u0000\u0000\u0000\u00aa"+
		"\u009e\u0001\u0000\u0000\u0000\u00aa\u009f\u0001\u0000\u0000\u0000\u00aa"+
		"\u00a3\u0001\u0000\u0000\u0000\u00ab\u000b\u0001\u0000\u0000\u0000\u00ac"+
		"\u00b3\u0001\u0000\u0000\u0000\u00ad\u00ae\u0005\u000b\u0000\u0000\u00ae"+
		"\u00af\u0006\u0006\uffff\uffff\u0000\u00af\u00b0\u0003\u0000\u0000\u0000"+
		"\u00b0\u00b1\u0006\u0006\uffff\uffff\u0000\u00b1\u00b3\u0001\u0000\u0000"+
		"\u0000\u00b2\u00ac\u0001\u0000\u0000\u0000\u00b2\u00ad\u0001\u0000\u0000"+
		"\u0000\u00b3\r\u0001\u0000\u0000\u0000\u00b4\u00c1\u0001\u0000\u0000\u0000"+
		"\u00b5\u00b6\u0003\u0010\b\u0000\u00b6\u00b7\u0006\u0007\uffff\uffff\u0000"+
		"\u00b7\u00c1\u0001\u0000\u0000\u0000\u00b8\u00b9\u0006\u0007\uffff\uffff"+
		"\u0000\u00b9\u00ba\u0003\u0002\u0001\u0000\u00ba\u00bb\u0006\u0007\uffff"+
		"\uffff\u0000\u00bb\u00bc\u0005\u0001\u0000\u0000\u00bc\u00bd\u0006\u0007"+
		"\uffff\uffff\u0000\u00bd\u00be\u0003\u0002\u0001\u0000\u00be\u00bf\u0006"+
		"\u0007\uffff\uffff\u0000\u00bf\u00c1\u0001\u0000\u0000\u0000\u00c0\u00b4"+
		"\u0001\u0000\u0000\u0000\u00c0\u00b5\u0001\u0000\u0000\u0000\u00c0\u00b8"+
		"\u0001\u0000\u0000\u0000\u00c1\u000f\u0001\u0000\u0000\u0000\u00c2\u00d4"+
		"\u0001\u0000\u0000\u0000\u00c3\u00c4\u0005\r\u0000\u0000\u00c4\u00d4\u0006"+
		"\b\uffff\uffff\u0000\u00c5\u00c6\u0005\r\u0000\u0000\u00c6\u00d4\u0006"+
		"\b\uffff\uffff\u0000\u00c7\u00c8\u0005\u0007\u0000\u0000\u00c8\u00d4\u0006"+
		"\b\uffff\uffff\u0000\u00c9\u00ca\u0005\b\u0000\u0000\u00ca\u00cb\u0006"+
		"\b\uffff\uffff\u0000\u00cb\u00cc\u0005\r\u0000\u0000\u00cc\u00cd\u0006"+
		"\b\uffff\uffff\u0000\u00cd\u00ce\u0003\u000e\u0007\u0000\u00ce\u00cf\u0006"+
		"\b\uffff\uffff\u0000\u00cf\u00d4\u0001\u0000\u0000\u0000\u00d0\u00d1\u0003"+
		"\u0012\t\u0000\u00d1\u00d2\u0006\b\uffff\uffff\u0000\u00d2\u00d4\u0001"+
		"\u0000\u0000\u0000\u00d3\u00c2\u0001\u0000\u0000\u0000\u00d3\u00c3\u0001"+
		"\u0000\u0000\u0000\u00d3\u00c5\u0001\u0000\u0000\u0000\u00d3\u00c7\u0001"+
		"\u0000\u0000\u0000\u00d3\u00c9\u0001\u0000\u0000\u0000\u00d3\u00d0\u0001"+
		"\u0000\u0000\u0000\u00d4\u0011\u0001\u0000\u0000\u0000\u00d5\u00eb\u0001"+
		"\u0000\u0000\u0000\u00d6\u00d7\u0005\b\u0000\u0000\u00d7\u00d8\u0006\t"+
		"\uffff\uffff\u0000\u00d8\u00d9\u0005\r\u0000\u0000\u00d9\u00da\u0006\t"+
		"\uffff\uffff\u0000\u00da\u00db\u0005\u000b\u0000\u0000\u00db\u00dc\u0006"+
		"\t\uffff\uffff\u0000\u00dc\u00dd\u0003\u000e\u0007\u0000\u00dd\u00de\u0006"+
		"\t\uffff\uffff\u0000\u00de\u00eb\u0001\u0000\u0000\u0000\u00df\u00e0\u0005"+
		"\b\u0000\u0000\u00e0\u00e1\u0006\t\uffff\uffff\u0000\u00e1\u00e2\u0005"+
		"\r\u0000\u0000\u00e2\u00e3\u0006\t\uffff\uffff\u0000\u00e3\u00e4\u0005"+
		"\u000b\u0000\u0000\u00e4\u00e5\u0006\t\uffff\uffff\u0000\u00e5\u00e6\u0003"+
		"\u000e\u0007\u0000\u00e6\u00e7\u0006\t\uffff\uffff\u0000\u00e7\u00e8\u0003"+
		"\u0012\t\u0000\u00e8\u00e9\u0006\t\uffff\uffff\u0000\u00e9\u00eb\u0001"+
		"\u0000\u0000\u0000\u00ea\u00d5\u0001\u0000\u0000\u0000\u00ea\u00d6\u0001"+
		"\u0000\u0000\u0000\u00ea\u00df\u0001\u0000\u0000\u0000\u00eb\u0013\u0001"+
		"\u0000\u0000\u0000\n@[r\u0089\u009c\u00aa\u00b2\u00c0\u00d3\u00ea";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}