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
		T__9=10, T__10=11, ID=12, INT=13, WS=14;
	public static final int
		RULE_expr = 0, RULE_pattern = 1, RULE_function = 2, RULE_recpat = 3, RULE_record = 4, 
		RULE_argchain = 5, RULE_keychain = 6;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "pattern", "function", "recpat", "record", "argchain", "keychain"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'@'", "':'", "'('", "')'", "'let'", "'='", "';'", "'fix'", "'case'", 
			"'=>'", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			"ID", "INT", "WS"
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
	    self._guidance = plate_default 
	    self._overflow = False  

	def reset(self): 
	    self._guidance = plate_default
	    self._overflow = False
	    # self.getCurrentToken()
	    # self.getTokenStream()



	def getGuidance(self):
	    return self._guidance

	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex

	def guide_nonterm(self, name : str, f : Callable, *args) -> Optional[Plate]:
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    plate_result = None
	    if not self._overflow:
	        plate_result = f(*args)
	        self._guidance = Nonterm(name, plate_result)

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 

	    return plate_result 



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
		public Plate plate;
		public ECombo combo;
		public Token ID;
		public ExprContext body;
		public RecordContext record;
		public ExprContext expr;
		public ExprContext cator;
		public KeychainContext keychain;
		public FunctionContext function;
		public ArgchainContext content;
		public ArgchainContext argchain;
		public ExprContext target;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public RecordContext record() {
			return getRuleContext(RecordContext.class,0);
		}
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public FunctionContext function() {
			return getRuleContext(FunctionContext.class,0);
		}
		public ArgchainContext argchain() {
			return getRuleContext(ArgchainContext.class,0);
		}
		public ExprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ExprContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(Plate plate) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), plate);
		enterRule(_localctx, 0, RULE_expr);
		try {
			setState(89);
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
				setState(15);
				((ExprContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_id, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(17);
				match(T__0);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_unit)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(19);
				match(T__1);


				setState(21);
				((ExprContext)_localctx).ID = match(ID);

				self.guide_terminal('ID')

				setState(23);
				((ExprContext)_localctx).body = expr(plate);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_tag, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.combo)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(26);
				((ExprContext)_localctx).record = record(plate);

				_localctx.combo = ((ExprContext)_localctx).record.combo

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(29);
				match(T__2);

				plate_expr = self.guide_nonterm('expr', lambda: plate)

				setState(31);
				((ExprContext)_localctx).expr = expr(plate_expr);

				self.guide_symbol(')')

				setState(33);
				match(T__3);

				_localctx.combo = ((ExprContext)_localctx).expr.combo

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(36);
				match(T__2);

				plate_cator = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_projmulti_cator)

				setState(38);
				((ExprContext)_localctx).cator = ((ExprContext)_localctx).expr = expr(plate_expr);

				self.guide_symbol(')')

				setState(40);
				match(T__3);

				plate_keychain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_projmulti_keychain, ((ExprContext)_localctx).expr.combo)

				setState(42);
				((ExprContext)_localctx).keychain = keychain(plate_keychain);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_projmulti, ((ExprContext)_localctx).expr.combo, ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(45);
				((ExprContext)_localctx).ID = match(ID);

				plate_keychain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_idprojmulti_keychain, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(47);
				((ExprContext)_localctx).keychain = keychain(plate_keychain);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_idprojmulti, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(50);
				((ExprContext)_localctx).function = function(plate);

				_localctx.combo = ((ExprContext)_localctx).function.combo

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(53);
				match(T__2);

				plate_cator = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_appmulti_cator)

				setState(55);
				((ExprContext)_localctx).cator = expr(plate_cator);

				self.guide_symbol(')')

				setState(57);
				match(T__3);

				plate_argchain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_appmulti_argchain, ((ExprContext)_localctx).cator.combo)

				setState(59);
				((ExprContext)_localctx).content = ((ExprContext)_localctx).argchain = argchain(plate_argchain);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_appmulti, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).argchain.combos)

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(62);
				((ExprContext)_localctx).ID = match(ID);

				plate_argchain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_idappmulti_argchain, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(64);
				((ExprContext)_localctx).argchain = argchain(plate_argchain);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_idappmulti, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).argchain.combos) 

				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(67);
				match(T__4);

				self.guide_terminal('ID')

				setState(69);
				((ExprContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(71);
				match(T__5);

				plate_target = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_let_target, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(73);
				((ExprContext)_localctx).target = expr(plate_target);

				self.guide_symbol(';')

				setState(75);
				match(T__6);

				plate_body = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_let_body, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.combo)

				setState(77);
				((ExprContext)_localctx).body = expr(plate_body);

				_localctx.combo = ((ExprContext)_localctx).body.combo

				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(80);
				match(T__7);

				self.guide_symbol('(')

				setState(82);
				match(T__2);

				plate_body = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_fix_body)

				setState(84);
				((ExprContext)_localctx).body = expr(plate_body);

				self.guide_symbol(')')

				setState(86);
				match(T__3);

				_localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_fix, ((ExprContext)_localctx).body.combo)

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
	public static class PatternContext extends ParserRuleContext {
		public Plate plate;
		public PCombo combo;
		public Token ID;
		public PatternContext body;
		public RecpatContext recpat;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public RecpatContext recpat() {
			return getRuleContext(RecpatContext.class,0);
		}
		public PatternContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public PatternContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
	}

	public final PatternContext pattern(Plate plate) throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState(), plate);
		enterRule(_localctx, 2, RULE_pattern);
		try {
			setState(106);
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
				setState(92);
				((PatternContext)_localctx).ID = match(ID);

				_localctx.combo = self.collect(PatternAttr(self._solver, plate).combine_id, (((PatternContext)_localctx).ID!=null?((PatternContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(94);
				match(T__0);

				_localctx.combo = self.collect(PatternAttr(self._solver, plate).combine_unit)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(96);
				match(T__1);

				self.guide_terminal('ID')

				setState(98);
				((PatternContext)_localctx).ID = match(ID);

				plate_body = self.guide_nonterm('pattern', PatternAttr(self._solver, plate).distill_tag_body, (((PatternContext)_localctx).ID!=null?((PatternContext)_localctx).ID.getText():null))

				setState(100);
				((PatternContext)_localctx).body = pattern(plate_body);

				_localctx.combo = self.collect(PatternAttr(self._solver, plate).combine_tag, ((PatternContext)_localctx).body.combo)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(103);
				((PatternContext)_localctx).recpat = recpat(plate);

				_localctx.combo = ((PatternContext)_localctx).recpat.combo

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
		public Plate plate;
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
		public FunctionContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function(Plate plate) throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState(), plate);
		enterRule(_localctx, 4, RULE_function);
		try {
			setState(129);
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
				setState(109);
				match(T__8);

				plate_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, plate).distill_single_pattern)

				setState(111);
				((FunctionContext)_localctx).pattern = pattern(plate_pattern);

				self.guide_symbol('=>')

				setState(113);
				match(T__9);

				plate_body = self.guide_nonterm('expr', FunctionAttr(self._solver, plate).distill_single_body, ((FunctionContext)_localctx).pattern.combo)

				setState(115);
				((FunctionContext)_localctx).body = expr(plate_body);

				_localctx.combo = self.collect(FunctionAttr(self._solver, plate).combine_single, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(118);
				match(T__8);

				plate_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, plate).distill_cons_pattern)

				setState(120);
				((FunctionContext)_localctx).pattern = pattern(plate_pattern);

				self.guide_symbol('=>')

				setState(122);
				match(T__9);

				plate_body = self.guide_nonterm('expr', FunctionAttr(self._solver, plate).distill_cons_body, ((FunctionContext)_localctx).pattern.combo)

				setState(124);
				((FunctionContext)_localctx).body = expr(plate_body);

				plate_tail = self.guide_nonterm('function', FunctionAttr(self._solver, plate).distill_cons_tail, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				setState(126);
				((FunctionContext)_localctx).tail = function(plate);

				_localctx.combo = self.collect(FunctionAttr(self._solver, plate).combine_cons, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo, ((FunctionContext)_localctx).tail.combo)

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
	public static class RecpatContext extends ParserRuleContext {
		public Plate plate;
		public PCombo combo;
		public Token ID;
		public PatternContext body;
		public RecpatContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public RecpatContext recpat() {
			return getRuleContext(RecpatContext.class,0);
		}
		public RecpatContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public RecpatContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_recpat; }
	}

	public final RecpatContext recpat(Plate plate) throws RecognitionException {
		RecpatContext _localctx = new RecpatContext(_ctx, getState(), plate);
		enterRule(_localctx, 6, RULE_recpat);
		try {
			setState(152);
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
				setState(132);
				match(T__1);

				self.guide_terminal('ID')

				setState(134);
				((RecpatContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(136);
				match(T__5);

				plate_body = self.guide_nonterm('pattern', RecpatAttr(self._solver, plate).distill_single_body, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null))

				setState(138);
				((RecpatContext)_localctx).body = pattern(plate_body);

				_localctx.combo = self.collect(RecpatAttr(self._solver, plate).combine_single, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null), ((RecpatContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(141);
				match(T__1);

				self.guide_terminal('ID')

				setState(143);
				((RecpatContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(145);
				match(T__5);

				plate_body = self.guide_nonterm('pattern', RecpatAttr(self._solver, plate).distill_cons_body, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null))

				setState(147);
				((RecpatContext)_localctx).body = pattern(plate_body);

				plate_tail = self.guide_nonterm('recpat', RecpatAttr(self._solver, plate).distill_cons_tail, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null), ((RecpatContext)_localctx).body.combo)

				setState(149);
				((RecpatContext)_localctx).tail = recpat(plate_tail);

				_localctx.combo = self.collect(RecpatAttr(self._solver, plate).combine_cons, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null), ((RecpatContext)_localctx).body.combo, ((RecpatContext)_localctx).tail.combo)

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
		public Plate plate;
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
		public RecordContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record(Plate plate) throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState(), plate);
		enterRule(_localctx, 8, RULE_record);
		try {
			setState(175);
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
				setState(155);
				match(T__1);

				self.guide_terminal('ID')

				setState(157);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(159);
				match(T__5);

				plate_body = self.guide_nonterm('expr', RecordAttr(self._solver, plate).distill_single_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(161);
				((RecordContext)_localctx).body = expr(plate_expr);

				_localctx.combo = self.collect(RecordAttr(self._solver, plate).combine_single, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(164);
				match(T__1);

				self.guide_terminal('ID')

				setState(166);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(168);
				match(T__5);

				plate_body = self.guide_nonterm('expr', RecordAttr(self._solver, plate).distill_cons_body, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null))

				setState(170);
				((RecordContext)_localctx).body = expr(plate);

				plate_tail = self.guide_nonterm('record', RecordAttr(self._solver, plate).distill_cons_tail, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo)

				setState(172);
				((RecordContext)_localctx).tail = record(plate);

				_localctx.combo = self.collect(RecordAttr(self._solver, plate).combine_cons, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).body.combo, ((RecordContext)_localctx).tail.combo)

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
		public Plate plate;
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
		public ArgchainContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_argchain; }
	}

	public final ArgchainContext argchain(Plate plate) throws RecognitionException {
		ArgchainContext _localctx = new ArgchainContext(_ctx, getState(), plate);
		enterRule(_localctx, 10, RULE_argchain);
		try {
			setState(194);
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
				setState(178);
				match(T__2);

				plate_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, plate).distill_single_content) 

				setState(180);
				((ArgchainContext)_localctx).content = expr(plate_content);

				self.guide_symbol(')')

				setState(182);
				match(T__3);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, plate).combine_single, ((ArgchainContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(185);
				match(T__2);

				plate_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, plate).distill_cons_head) 

				setState(187);
				((ArgchainContext)_localctx).head = expr(plate_head);

				self.guide_symbol(')')

				setState(189);
				match(T__3);

				plate_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, plate).distill_cons_tail, ((ArgchainContext)_localctx).head.combo) 

				setState(191);
				((ArgchainContext)_localctx).tail = argchain(plate_tail);

				_localctx.combos = self.collect(ArgchainAttr(self._solver, plate).combine_cons, ((ArgchainContext)_localctx).head.combo, ((ArgchainContext)_localctx).tail.combos)

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
		public Plate plate;
		public list[str] ids;
		public Token ID;
		public KeychainContext tail;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public KeychainContext keychain() {
			return getRuleContext(KeychainContext.class,0);
		}
		public KeychainContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public KeychainContext(ParserRuleContext parent, int invokingState, Plate plate) {
			super(parent, invokingState);
			this.plate = plate;
		}
		@Override public int getRuleIndex() { return RULE_keychain; }
	}

	public final KeychainContext keychain(Plate plate) throws RecognitionException {
		KeychainContext _localctx = new KeychainContext(_ctx, getState(), plate);
		enterRule(_localctx, 12, RULE_keychain);
		try {
			setState(208);
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
				setState(197);
				match(T__10);

				self.guide_terminal('ID')

				setState(199);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.ids = self.collect(KeychainAttr(self._solver, plate).combine_single, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(201);
				match(T__10);

				self.guide_terminal('ID')

				setState(203);
				((KeychainContext)_localctx).ID = match(ID);

				plate_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, plate).distill_cons_tail, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null)) 

				setState(205);
				((KeychainContext)_localctx).tail = keychain(plate_tail);

				_localctx.ids = self.collect(KeychainAttr(self._solver, plate).combine_cons, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.ids)

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
		"\u0004\u0001\u000e\u00d3\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001"+
		"\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004"+
		"\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0001\u0000\u0001\u0000"+
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
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0003\u0000Z\b\u0000\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0003\u0001k\b\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0003\u0002"+
		"\u0082\b\u0002\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0003\u0003\u0099\b\u0003"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0003\u0004\u00b0\b\u0004\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0003\u0005\u00c3\b\u0005"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0003\u0006\u00d1\b\u0006\u0001\u0006\u0000\u0000\u0007\u0000\u0002\u0004"+
		"\u0006\b\n\f\u0000\u0000\u00e5\u0000Y\u0001\u0000\u0000\u0000\u0002j\u0001"+
		"\u0000\u0000\u0000\u0004\u0081\u0001\u0000\u0000\u0000\u0006\u0098\u0001"+
		"\u0000\u0000\u0000\b\u00af\u0001\u0000\u0000\u0000\n\u00c2\u0001\u0000"+
		"\u0000\u0000\f\u00d0\u0001\u0000\u0000\u0000\u000eZ\u0001\u0000\u0000"+
		"\u0000\u000f\u0010\u0005\f\u0000\u0000\u0010Z\u0006\u0000\uffff\uffff"+
		"\u0000\u0011\u0012\u0005\u0001\u0000\u0000\u0012Z\u0006\u0000\uffff\uffff"+
		"\u0000\u0013\u0014\u0005\u0002\u0000\u0000\u0014\u0015\u0006\u0000\uffff"+
		"\uffff\u0000\u0015\u0016\u0005\f\u0000\u0000\u0016\u0017\u0006\u0000\uffff"+
		"\uffff\u0000\u0017\u0018\u0003\u0000\u0000\u0000\u0018\u0019\u0006\u0000"+
		"\uffff\uffff\u0000\u0019Z\u0001\u0000\u0000\u0000\u001a\u001b\u0003\b"+
		"\u0004\u0000\u001b\u001c\u0006\u0000\uffff\uffff\u0000\u001cZ\u0001\u0000"+
		"\u0000\u0000\u001d\u001e\u0005\u0003\u0000\u0000\u001e\u001f\u0006\u0000"+
		"\uffff\uffff\u0000\u001f \u0003\u0000\u0000\u0000 !\u0006\u0000\uffff"+
		"\uffff\u0000!\"\u0005\u0004\u0000\u0000\"#\u0006\u0000\uffff\uffff\u0000"+
		"#Z\u0001\u0000\u0000\u0000$%\u0005\u0003\u0000\u0000%&\u0006\u0000\uffff"+
		"\uffff\u0000&\'\u0003\u0000\u0000\u0000\'(\u0006\u0000\uffff\uffff\u0000"+
		"()\u0005\u0004\u0000\u0000)*\u0006\u0000\uffff\uffff\u0000*+\u0003\f\u0006"+
		"\u0000+,\u0006\u0000\uffff\uffff\u0000,Z\u0001\u0000\u0000\u0000-.\u0005"+
		"\f\u0000\u0000./\u0006\u0000\uffff\uffff\u0000/0\u0003\f\u0006\u00000"+
		"1\u0006\u0000\uffff\uffff\u00001Z\u0001\u0000\u0000\u000023\u0003\u0004"+
		"\u0002\u000034\u0006\u0000\uffff\uffff\u00004Z\u0001\u0000\u0000\u0000"+
		"56\u0005\u0003\u0000\u000067\u0006\u0000\uffff\uffff\u000078\u0003\u0000"+
		"\u0000\u000089\u0006\u0000\uffff\uffff\u00009:\u0005\u0004\u0000\u0000"+
		":;\u0006\u0000\uffff\uffff\u0000;<\u0003\n\u0005\u0000<=\u0006\u0000\uffff"+
		"\uffff\u0000=Z\u0001\u0000\u0000\u0000>?\u0005\f\u0000\u0000?@\u0006\u0000"+
		"\uffff\uffff\u0000@A\u0003\n\u0005\u0000AB\u0006\u0000\uffff\uffff\u0000"+
		"BZ\u0001\u0000\u0000\u0000CD\u0005\u0005\u0000\u0000DE\u0006\u0000\uffff"+
		"\uffff\u0000EF\u0005\f\u0000\u0000FG\u0006\u0000\uffff\uffff\u0000GH\u0005"+
		"\u0006\u0000\u0000HI\u0006\u0000\uffff\uffff\u0000IJ\u0003\u0000\u0000"+
		"\u0000JK\u0006\u0000\uffff\uffff\u0000KL\u0005\u0007\u0000\u0000LM\u0006"+
		"\u0000\uffff\uffff\u0000MN\u0003\u0000\u0000\u0000NO\u0006\u0000\uffff"+
		"\uffff\u0000OZ\u0001\u0000\u0000\u0000PQ\u0005\b\u0000\u0000QR\u0006\u0000"+
		"\uffff\uffff\u0000RS\u0005\u0003\u0000\u0000ST\u0006\u0000\uffff\uffff"+
		"\u0000TU\u0003\u0000\u0000\u0000UV\u0006\u0000\uffff\uffff\u0000VW\u0005"+
		"\u0004\u0000\u0000WX\u0006\u0000\uffff\uffff\u0000XZ\u0001\u0000\u0000"+
		"\u0000Y\u000e\u0001\u0000\u0000\u0000Y\u000f\u0001\u0000\u0000\u0000Y"+
		"\u0011\u0001\u0000\u0000\u0000Y\u0013\u0001\u0000\u0000\u0000Y\u001a\u0001"+
		"\u0000\u0000\u0000Y\u001d\u0001\u0000\u0000\u0000Y$\u0001\u0000\u0000"+
		"\u0000Y-\u0001\u0000\u0000\u0000Y2\u0001\u0000\u0000\u0000Y5\u0001\u0000"+
		"\u0000\u0000Y>\u0001\u0000\u0000\u0000YC\u0001\u0000\u0000\u0000YP\u0001"+
		"\u0000\u0000\u0000Z\u0001\u0001\u0000\u0000\u0000[k\u0001\u0000\u0000"+
		"\u0000\\]\u0005\f\u0000\u0000]k\u0006\u0001\uffff\uffff\u0000^_\u0005"+
		"\u0001\u0000\u0000_k\u0006\u0001\uffff\uffff\u0000`a\u0005\u0002\u0000"+
		"\u0000ab\u0006\u0001\uffff\uffff\u0000bc\u0005\f\u0000\u0000cd\u0006\u0001"+
		"\uffff\uffff\u0000de\u0003\u0002\u0001\u0000ef\u0006\u0001\uffff\uffff"+
		"\u0000fk\u0001\u0000\u0000\u0000gh\u0003\u0006\u0003\u0000hi\u0006\u0001"+
		"\uffff\uffff\u0000ik\u0001\u0000\u0000\u0000j[\u0001\u0000\u0000\u0000"+
		"j\\\u0001\u0000\u0000\u0000j^\u0001\u0000\u0000\u0000j`\u0001\u0000\u0000"+
		"\u0000jg\u0001\u0000\u0000\u0000k\u0003\u0001\u0000\u0000\u0000l\u0082"+
		"\u0001\u0000\u0000\u0000mn\u0005\t\u0000\u0000no\u0006\u0002\uffff\uffff"+
		"\u0000op\u0003\u0002\u0001\u0000pq\u0006\u0002\uffff\uffff\u0000qr\u0005"+
		"\n\u0000\u0000rs\u0006\u0002\uffff\uffff\u0000st\u0003\u0000\u0000\u0000"+
		"tu\u0006\u0002\uffff\uffff\u0000u\u0082\u0001\u0000\u0000\u0000vw\u0005"+
		"\t\u0000\u0000wx\u0006\u0002\uffff\uffff\u0000xy\u0003\u0002\u0001\u0000"+
		"yz\u0006\u0002\uffff\uffff\u0000z{\u0005\n\u0000\u0000{|\u0006\u0002\uffff"+
		"\uffff\u0000|}\u0003\u0000\u0000\u0000}~\u0006\u0002\uffff\uffff\u0000"+
		"~\u007f\u0003\u0004\u0002\u0000\u007f\u0080\u0006\u0002\uffff\uffff\u0000"+
		"\u0080\u0082\u0001\u0000\u0000\u0000\u0081l\u0001\u0000\u0000\u0000\u0081"+
		"m\u0001\u0000\u0000\u0000\u0081v\u0001\u0000\u0000\u0000\u0082\u0005\u0001"+
		"\u0000\u0000\u0000\u0083\u0099\u0001\u0000\u0000\u0000\u0084\u0085\u0005"+
		"\u0002\u0000\u0000\u0085\u0086\u0006\u0003\uffff\uffff\u0000\u0086\u0087"+
		"\u0005\f\u0000\u0000\u0087\u0088\u0006\u0003\uffff\uffff\u0000\u0088\u0089"+
		"\u0005\u0006\u0000\u0000\u0089\u008a\u0006\u0003\uffff\uffff\u0000\u008a"+
		"\u008b\u0003\u0002\u0001\u0000\u008b\u008c\u0006\u0003\uffff\uffff\u0000"+
		"\u008c\u0099\u0001\u0000\u0000\u0000\u008d\u008e\u0005\u0002\u0000\u0000"+
		"\u008e\u008f\u0006\u0003\uffff\uffff\u0000\u008f\u0090\u0005\f\u0000\u0000"+
		"\u0090\u0091\u0006\u0003\uffff\uffff\u0000\u0091\u0092\u0005\u0006\u0000"+
		"\u0000\u0092\u0093\u0006\u0003\uffff\uffff\u0000\u0093\u0094\u0003\u0002"+
		"\u0001\u0000\u0094\u0095\u0006\u0003\uffff\uffff\u0000\u0095\u0096\u0003"+
		"\u0006\u0003\u0000\u0096\u0097\u0006\u0003\uffff\uffff\u0000\u0097\u0099"+
		"\u0001\u0000\u0000\u0000\u0098\u0083\u0001\u0000\u0000\u0000\u0098\u0084"+
		"\u0001\u0000\u0000\u0000\u0098\u008d\u0001\u0000\u0000\u0000\u0099\u0007"+
		"\u0001\u0000\u0000\u0000\u009a\u00b0\u0001\u0000\u0000\u0000\u009b\u009c"+
		"\u0005\u0002\u0000\u0000\u009c\u009d\u0006\u0004\uffff\uffff\u0000\u009d"+
		"\u009e\u0005\f\u0000\u0000\u009e\u009f\u0006\u0004\uffff\uffff\u0000\u009f"+
		"\u00a0\u0005\u0006\u0000\u0000\u00a0\u00a1\u0006\u0004\uffff\uffff\u0000"+
		"\u00a1\u00a2\u0003\u0000\u0000\u0000\u00a2\u00a3\u0006\u0004\uffff\uffff"+
		"\u0000\u00a3\u00b0\u0001\u0000\u0000\u0000\u00a4\u00a5\u0005\u0002\u0000"+
		"\u0000\u00a5\u00a6\u0006\u0004\uffff\uffff\u0000\u00a6\u00a7\u0005\f\u0000"+
		"\u0000\u00a7\u00a8\u0006\u0004\uffff\uffff\u0000\u00a8\u00a9\u0005\u0006"+
		"\u0000\u0000\u00a9\u00aa\u0006\u0004\uffff\uffff\u0000\u00aa\u00ab\u0003"+
		"\u0000\u0000\u0000\u00ab\u00ac\u0006\u0004\uffff\uffff\u0000\u00ac\u00ad"+
		"\u0003\b\u0004\u0000\u00ad\u00ae\u0006\u0004\uffff\uffff\u0000\u00ae\u00b0"+
		"\u0001\u0000\u0000\u0000\u00af\u009a\u0001\u0000\u0000\u0000\u00af\u009b"+
		"\u0001\u0000\u0000\u0000\u00af\u00a4\u0001\u0000\u0000\u0000\u00b0\t\u0001"+
		"\u0000\u0000\u0000\u00b1\u00c3\u0001\u0000\u0000\u0000\u00b2\u00b3\u0005"+
		"\u0003\u0000\u0000\u00b3\u00b4\u0006\u0005\uffff\uffff\u0000\u00b4\u00b5"+
		"\u0003\u0000\u0000\u0000\u00b5\u00b6\u0006\u0005\uffff\uffff\u0000\u00b6"+
		"\u00b7\u0005\u0004\u0000\u0000\u00b7\u00b8\u0006\u0005\uffff\uffff\u0000"+
		"\u00b8\u00c3\u0001\u0000\u0000\u0000\u00b9\u00ba\u0005\u0003\u0000\u0000"+
		"\u00ba\u00bb\u0006\u0005\uffff\uffff\u0000\u00bb\u00bc\u0003\u0000\u0000"+
		"\u0000\u00bc\u00bd\u0006\u0005\uffff\uffff\u0000\u00bd\u00be\u0005\u0004"+
		"\u0000\u0000\u00be\u00bf\u0006\u0005\uffff\uffff\u0000\u00bf\u00c0\u0003"+
		"\n\u0005\u0000\u00c0\u00c1\u0006\u0005\uffff\uffff\u0000\u00c1\u00c3\u0001"+
		"\u0000\u0000\u0000\u00c2\u00b1\u0001\u0000\u0000\u0000\u00c2\u00b2\u0001"+
		"\u0000\u0000\u0000\u00c2\u00b9\u0001\u0000\u0000\u0000\u00c3\u000b\u0001"+
		"\u0000\u0000\u0000\u00c4\u00d1\u0001\u0000\u0000\u0000\u00c5\u00c6\u0005"+
		"\u000b\u0000\u0000\u00c6\u00c7\u0006\u0006\uffff\uffff\u0000\u00c7\u00c8"+
		"\u0005\f\u0000\u0000\u00c8\u00d1\u0006\u0006\uffff\uffff\u0000\u00c9\u00ca"+
		"\u0005\u000b\u0000\u0000\u00ca\u00cb\u0006\u0006\uffff\uffff\u0000\u00cb"+
		"\u00cc\u0005\f\u0000\u0000\u00cc\u00cd\u0006\u0006\uffff\uffff\u0000\u00cd"+
		"\u00ce\u0003\f\u0006\u0000\u00ce\u00cf\u0006\u0006\uffff\uffff\u0000\u00cf"+
		"\u00d1\u0001\u0000\u0000\u0000\u00d0\u00c4\u0001\u0000\u0000\u0000\u00d0"+
		"\u00c5\u0001\u0000\u0000\u0000\u00d0\u00c9\u0001\u0000\u0000\u0000\u00d1"+
		"\r\u0001\u0000\u0000\u0000\u0007Yj\u0081\u0098\u00af\u00c2\u00d0";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}