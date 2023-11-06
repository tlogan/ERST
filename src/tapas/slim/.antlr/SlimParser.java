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



	_analyzer : Analyzer
	_cache : dict[int, str] = {}

	_guidance : Guidance 
	_overflow = False  

	def init(self): 
	    self._analyzer = Analyzer() 
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

	def guide_choice(self, f : Callable, plate : Plate, *args) -> Optional[Plate]:
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    result = None
	    if not self._overflow:
	        result = f(plate, *args)
	        self._guidance = result

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 

	    return result



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



	def mem(self, f : Callable, plate : Plate, *args):

	    if self._overflow:
	        return None
	    else:

	        clean = next((
	            False
	            for arg in args
	            if arg == None
	        ), True)

	        if clean:
	            return f(plate, *args)
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
			setState(87);
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

				_localctx.combo = self.mem(self._analyzer.combine_expr_id, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(17);
				match(T__0);

				_localctx.combo = self.mem(self._analyzer.combine_expr_unit, plate)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(19);
				match(T__1);
				setState(20);
				((ExprContext)_localctx).ID = match(ID);
				setState(21);
				((ExprContext)_localctx).body = expr(plate);

				_localctx.combo = self.mem(self._analyzer.combine_expr_tag, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.combo)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(24);
				((ExprContext)_localctx).record = record(plate);

				_localctx.combo = ((ExprContext)_localctx).record.combo

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(27);
				match(T__2);


				setState(29);
				((ExprContext)_localctx).expr = expr(plate);

				self.guide_symbol(')')

				setState(31);
				match(T__3);

				_localctx.combo = ((ExprContext)_localctx).expr.combo

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(34);
				match(T__2);

				plate_cator = self.guide_choice(self._analyzer.distill_expr_projmulti_cator, plate)

				setState(36);
				((ExprContext)_localctx).cator = ((ExprContext)_localctx).expr = expr(plate_expr);

				self.guide_symbol(')')

				setState(38);
				match(T__3);

				plate_keychain = self.guide_choice(self._analyzer.distill_expr_projmulti_keychain, plate, ((ExprContext)_localctx).expr.combo)

				setState(40);
				((ExprContext)_localctx).keychain = keychain(plate_keychain);

				_localctx.combo = self.mem(self._analyzer.combine_expr_projmulti, plate, ((ExprContext)_localctx).expr.combo, ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(43);
				((ExprContext)_localctx).ID = match(ID);

				plate_keychain = self.guide_choice(self._analyzer.distill_expr_idprojmulti_keychain, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(45);
				((ExprContext)_localctx).keychain = keychain(plate_keychain);

				_localctx.combo = self.mem(self._analyzer.combine_expr_idprojmulti, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(48);
				((ExprContext)_localctx).function = function(plate);

				_localctx.combo = ((ExprContext)_localctx).function.combo

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(51);
				match(T__2);

				plate_cator = self.guide_choice(self._analyzer.distill_expr_appmulti_cator, plate)

				setState(53);
				((ExprContext)_localctx).cator = expr(plate_cator);

				self.guide_symbol(')')

				setState(55);
				match(T__3);

				plate_argchain = self.guide_choice(self._analyzer.distill_expr_appmulti_argchain, plate, ((ExprContext)_localctx).cator.combo)

				setState(57);
				((ExprContext)_localctx).content = ((ExprContext)_localctx).argchain = argchain(plate_argchain);

				_localctx.combo = self.mem(self._analyzer.combine_expr_appmulti, plate, ((ExprContext)_localctx).cator.combo, ((ExprContext)_localctx).argchain.combos)

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(60);
				((ExprContext)_localctx).ID = match(ID);

				plate_argchain = self.guide_choice(self._analyzer.distill_expr_idappmulti_argchain, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(62);
				((ExprContext)_localctx).argchain = argchain(plate_argchain);

				_localctx.combo = self.mem(self._analyzer.combine_expr_idappmulti, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).argchain.combos) 

				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(65);
				match(T__4);

				self.guide_terminal('ID')

				setState(67);
				((ExprContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(69);
				match(T__5);

				plate_target = plate #TODO

				setState(71);
				((ExprContext)_localctx).target = expr(plate_target);

				self.guide_symbol(';')

				setState(73);
				match(T__6);

				plate_body = self.guide_choice(self._analyzer.distill_expr_let_body, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.combo)

				setState(75);
				((ExprContext)_localctx).body = expr(plate_body);

				_localctx.combo = ((ExprContext)_localctx).body.combo

				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(78);
				match(T__7);

				self.guide_symbol('(')

				setState(80);
				match(T__2);

				plate_body = self.guide_choice(self._analyzer.distill_expr_fix_body, plate)

				setState(82);
				((ExprContext)_localctx).body = expr(plate_body);

				self.guide_symbol(')')

				setState(84);
				match(T__3);

				_localctx.combo = self.mem(self._analyzer.combine_expr_fix, plate, ((ExprContext)_localctx).body.combo)

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
			setState(104);
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
				setState(90);
				((PatternContext)_localctx).ID = match(ID);

				_localctx.combo = self.mem(self._analyzer.combine_pattern_id, plate, (((PatternContext)_localctx).ID!=null?((PatternContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(92);
				match(T__0);

				_localctx.combo = self.mem(self._analyzer.combine_pattern_unit, plate)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(94);
				match(T__1);


				setState(96);
				match(ID);

				plate_body = plate # TODO

				setState(98);
				((PatternContext)_localctx).body = pattern(plate_body);

				_localctx.combo = self.mem(self._analyzer.combine_pattern_tag, plate, ((PatternContext)_localctx).body.combo)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(101);
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
		public FunctionContext function;
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
			setState(127);
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
				setState(107);
				match(T__8);

				# TODO
				plate_pattern = self.guide_choice(self._analyzer.distill_function_single_pattern, plate)

				setState(109);
				((FunctionContext)_localctx).pattern = pattern(plate_pattern);

				self.guide_symbol('=>')

				setState(111);
				match(T__9);

				# TODO
				plate_body = self.guide_choice(self._analyzer.distill_function_single_body, plate, ((FunctionContext)_localctx).pattern.combo)

				setState(113);
				((FunctionContext)_localctx).body = expr(plate_body);

				_localctx.combo = self.mem(self._analyzer.combine_function_single, plate, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(116);
				match(T__8);

				# TODO
				plate_pattern = self.guide_choice(self._analyzer.distill_function_cons_pattern, plate)

				setState(118);
				((FunctionContext)_localctx).pattern = pattern(plate_pattern);

				self.guide_symbol('=>')

				setState(120);
				match(T__9);

				# TODO
				plate_body = self.guide_choice(self._analyzer.distill_function_cons_body, plate, ((FunctionContext)_localctx).pattern.combo)

				setState(122);
				((FunctionContext)_localctx).body = expr(plate_body);

				plate_function = plate # TODO

				setState(124);
				((FunctionContext)_localctx).function = function(plate);

				_localctx.combo = self.mem(self._analyzer.combine_function_cons, plate, ((FunctionContext)_localctx).pattern.combo, ((FunctionContext)_localctx).body.combo, ((FunctionContext)_localctx).function.combo)

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
			setState(150);
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
				setState(130);
				match(T__1);

				self.guide_terminal('ID')

				setState(132);
				((RecpatContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(134);
				match(T__5);

				plate_body = plate # TODO

				setState(136);
				((RecpatContext)_localctx).body = pattern(plate_body);

				_localctx.combo = self.mem(self._analyzer.combine_recpat_single, plate, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null), ((RecpatContext)_localctx).body.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(139);
				match(T__1);

				self.guide_terminal('ID')

				setState(141);
				((RecpatContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(143);
				match(T__5);

				plate_body = plate # TODO

				setState(145);
				((RecpatContext)_localctx).body = pattern(plate_body);

				plate_tail = plate # TODO

				setState(147);
				((RecpatContext)_localctx).tail = recpat(plate_tail);

				_localctx.combo = self.mem(self._analyzer.combine_recpat_cons, plate, (((RecpatContext)_localctx).ID!=null?((RecpatContext)_localctx).ID.getText():null), ((RecpatContext)_localctx).body.combo, ((RecpatContext)_localctx).tail.combo)

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
		public ExprContext expr;
		public RecordContext record;
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
			setState(173);
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
				setState(153);
				match(T__1);

				self.guide_terminal('ID')

				setState(155);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(157);
				match(T__5);

				plate_expr = plate # TODO

				setState(159);
				((RecordContext)_localctx).expr = expr(plate_expr);

				_localctx.combo = self.mem(self._analyzer.combine_record_single, plate, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).expr.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(162);
				match(T__1);

				self.guide_terminal('ID')

				setState(164);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(166);
				match(T__5);

				plate_expr = plate # TODO

				setState(168);
				((RecordContext)_localctx).expr = expr(plate);

				plate_record = plate # TODO

				setState(170);
				((RecordContext)_localctx).record = record(plate);

				_localctx.combo = self.mem(self._analyzer.combine_record_cons, plate, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).expr.combo, ((RecordContext)_localctx).record.combo)

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
				setState(176);
				match(T__2);

				plate_content = self.guide_choice(self._analyzer.distill_argchain_single_content, plate) 

				setState(178);
				((ArgchainContext)_localctx).content = expr(plate_content);

				self.guide_symbol(')')

				setState(180);
				match(T__3);

				_localctx.combos = self.mem(self._analyzer.combine_argchain_single, plate, ((ArgchainContext)_localctx).content.combo)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(183);
				match(T__2);

				plate_head = self.guide_choice(self._analyzer.distill_argchain_cons_head, plate) 

				setState(185);
				((ArgchainContext)_localctx).head = expr(plate_head);

				self.guide_symbol(')')

				setState(187);
				match(T__3);

				plate_tail = self.guide_choice(self._analyzer.distill_argchain_cons_tail, plate, ((ArgchainContext)_localctx).head.combo) 

				setState(189);
				((ArgchainContext)_localctx).tail = argchain(plate_tail);

				_localctx.combos = self.mem(self._analyzer.combine_argchain_cons, plate, ((ArgchainContext)_localctx).head.combo, ((ArgchainContext)_localctx).tail.combos)

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
				setState(195);
				match(T__10);
				setState(196);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.ids = self.mem(self._analyzer.combine_keychain_single, plate, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(198);
				match(T__10);
				setState(199);
				((KeychainContext)_localctx).ID = match(ID);

				plate_tail = self.guide_choice(self._analyzer.distill_keychain_cons_tail, plate, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null)) 

				setState(201);
				((KeychainContext)_localctx).tail = keychain(plate_tail);

				_localctx.ids = self.mem(self._analyzer.combine_keychain_cons, plate, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null), ((KeychainContext)_localctx).tail.ids)

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
		"\u0004\u0001\u000e\u00cf\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001"+
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
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u0000"+
		"X\b\u0000\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0003\u0001i\b\u0001"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0003\u0002\u0080\b\u0002\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0003\u0003\u0097\b\u0003\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0004\u0003\u0004\u00ae\b\u0004\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005\u0001\u0005"+
		"\u0001\u0005\u0001\u0005\u0003\u0005\u00c1\b\u0005\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0003\u0006\u00cd\b\u0006\u0001\u0006\u0000\u0000"+
		"\u0007\u0000\u0002\u0004\u0006\b\n\f\u0000\u0000\u00e1\u0000W\u0001\u0000"+
		"\u0000\u0000\u0002h\u0001\u0000\u0000\u0000\u0004\u007f\u0001\u0000\u0000"+
		"\u0000\u0006\u0096\u0001\u0000\u0000\u0000\b\u00ad\u0001\u0000\u0000\u0000"+
		"\n\u00c0\u0001\u0000\u0000\u0000\f\u00cc\u0001\u0000\u0000\u0000\u000e"+
		"X\u0001\u0000\u0000\u0000\u000f\u0010\u0005\f\u0000\u0000\u0010X\u0006"+
		"\u0000\uffff\uffff\u0000\u0011\u0012\u0005\u0001\u0000\u0000\u0012X\u0006"+
		"\u0000\uffff\uffff\u0000\u0013\u0014\u0005\u0002\u0000\u0000\u0014\u0015"+
		"\u0005\f\u0000\u0000\u0015\u0016\u0003\u0000\u0000\u0000\u0016\u0017\u0006"+
		"\u0000\uffff\uffff\u0000\u0017X\u0001\u0000\u0000\u0000\u0018\u0019\u0003"+
		"\b\u0004\u0000\u0019\u001a\u0006\u0000\uffff\uffff\u0000\u001aX\u0001"+
		"\u0000\u0000\u0000\u001b\u001c\u0005\u0003\u0000\u0000\u001c\u001d\u0006"+
		"\u0000\uffff\uffff\u0000\u001d\u001e\u0003\u0000\u0000\u0000\u001e\u001f"+
		"\u0006\u0000\uffff\uffff\u0000\u001f \u0005\u0004\u0000\u0000 !\u0006"+
		"\u0000\uffff\uffff\u0000!X\u0001\u0000\u0000\u0000\"#\u0005\u0003\u0000"+
		"\u0000#$\u0006\u0000\uffff\uffff\u0000$%\u0003\u0000\u0000\u0000%&\u0006"+
		"\u0000\uffff\uffff\u0000&\'\u0005\u0004\u0000\u0000\'(\u0006\u0000\uffff"+
		"\uffff\u0000()\u0003\f\u0006\u0000)*\u0006\u0000\uffff\uffff\u0000*X\u0001"+
		"\u0000\u0000\u0000+,\u0005\f\u0000\u0000,-\u0006\u0000\uffff\uffff\u0000"+
		"-.\u0003\f\u0006\u0000./\u0006\u0000\uffff\uffff\u0000/X\u0001\u0000\u0000"+
		"\u000001\u0003\u0004\u0002\u000012\u0006\u0000\uffff\uffff\u00002X\u0001"+
		"\u0000\u0000\u000034\u0005\u0003\u0000\u000045\u0006\u0000\uffff\uffff"+
		"\u000056\u0003\u0000\u0000\u000067\u0006\u0000\uffff\uffff\u000078\u0005"+
		"\u0004\u0000\u000089\u0006\u0000\uffff\uffff\u00009:\u0003\n\u0005\u0000"+
		":;\u0006\u0000\uffff\uffff\u0000;X\u0001\u0000\u0000\u0000<=\u0005\f\u0000"+
		"\u0000=>\u0006\u0000\uffff\uffff\u0000>?\u0003\n\u0005\u0000?@\u0006\u0000"+
		"\uffff\uffff\u0000@X\u0001\u0000\u0000\u0000AB\u0005\u0005\u0000\u0000"+
		"BC\u0006\u0000\uffff\uffff\u0000CD\u0005\f\u0000\u0000DE\u0006\u0000\uffff"+
		"\uffff\u0000EF\u0005\u0006\u0000\u0000FG\u0006\u0000\uffff\uffff\u0000"+
		"GH\u0003\u0000\u0000\u0000HI\u0006\u0000\uffff\uffff\u0000IJ\u0005\u0007"+
		"\u0000\u0000JK\u0006\u0000\uffff\uffff\u0000KL\u0003\u0000\u0000\u0000"+
		"LM\u0006\u0000\uffff\uffff\u0000MX\u0001\u0000\u0000\u0000NO\u0005\b\u0000"+
		"\u0000OP\u0006\u0000\uffff\uffff\u0000PQ\u0005\u0003\u0000\u0000QR\u0006"+
		"\u0000\uffff\uffff\u0000RS\u0003\u0000\u0000\u0000ST\u0006\u0000\uffff"+
		"\uffff\u0000TU\u0005\u0004\u0000\u0000UV\u0006\u0000\uffff\uffff\u0000"+
		"VX\u0001\u0000\u0000\u0000W\u000e\u0001\u0000\u0000\u0000W\u000f\u0001"+
		"\u0000\u0000\u0000W\u0011\u0001\u0000\u0000\u0000W\u0013\u0001\u0000\u0000"+
		"\u0000W\u0018\u0001\u0000\u0000\u0000W\u001b\u0001\u0000\u0000\u0000W"+
		"\"\u0001\u0000\u0000\u0000W+\u0001\u0000\u0000\u0000W0\u0001\u0000\u0000"+
		"\u0000W3\u0001\u0000\u0000\u0000W<\u0001\u0000\u0000\u0000WA\u0001\u0000"+
		"\u0000\u0000WN\u0001\u0000\u0000\u0000X\u0001\u0001\u0000\u0000\u0000"+
		"Yi\u0001\u0000\u0000\u0000Z[\u0005\f\u0000\u0000[i\u0006\u0001\uffff\uffff"+
		"\u0000\\]\u0005\u0001\u0000\u0000]i\u0006\u0001\uffff\uffff\u0000^_\u0005"+
		"\u0002\u0000\u0000_`\u0006\u0001\uffff\uffff\u0000`a\u0005\f\u0000\u0000"+
		"ab\u0006\u0001\uffff\uffff\u0000bc\u0003\u0002\u0001\u0000cd\u0006\u0001"+
		"\uffff\uffff\u0000di\u0001\u0000\u0000\u0000ef\u0003\u0006\u0003\u0000"+
		"fg\u0006\u0001\uffff\uffff\u0000gi\u0001\u0000\u0000\u0000hY\u0001\u0000"+
		"\u0000\u0000hZ\u0001\u0000\u0000\u0000h\\\u0001\u0000\u0000\u0000h^\u0001"+
		"\u0000\u0000\u0000he\u0001\u0000\u0000\u0000i\u0003\u0001\u0000\u0000"+
		"\u0000j\u0080\u0001\u0000\u0000\u0000kl\u0005\t\u0000\u0000lm\u0006\u0002"+
		"\uffff\uffff\u0000mn\u0003\u0002\u0001\u0000no\u0006\u0002\uffff\uffff"+
		"\u0000op\u0005\n\u0000\u0000pq\u0006\u0002\uffff\uffff\u0000qr\u0003\u0000"+
		"\u0000\u0000rs\u0006\u0002\uffff\uffff\u0000s\u0080\u0001\u0000\u0000"+
		"\u0000tu\u0005\t\u0000\u0000uv\u0006\u0002\uffff\uffff\u0000vw\u0003\u0002"+
		"\u0001\u0000wx\u0006\u0002\uffff\uffff\u0000xy\u0005\n\u0000\u0000yz\u0006"+
		"\u0002\uffff\uffff\u0000z{\u0003\u0000\u0000\u0000{|\u0006\u0002\uffff"+
		"\uffff\u0000|}\u0003\u0004\u0002\u0000}~\u0006\u0002\uffff\uffff\u0000"+
		"~\u0080\u0001\u0000\u0000\u0000\u007fj\u0001\u0000\u0000\u0000\u007fk"+
		"\u0001\u0000\u0000\u0000\u007ft\u0001\u0000\u0000\u0000\u0080\u0005\u0001"+
		"\u0000\u0000\u0000\u0081\u0097\u0001\u0000\u0000\u0000\u0082\u0083\u0005"+
		"\u0002\u0000\u0000\u0083\u0084\u0006\u0003\uffff\uffff\u0000\u0084\u0085"+
		"\u0005\f\u0000\u0000\u0085\u0086\u0006\u0003\uffff\uffff\u0000\u0086\u0087"+
		"\u0005\u0006\u0000\u0000\u0087\u0088\u0006\u0003\uffff\uffff\u0000\u0088"+
		"\u0089\u0003\u0002\u0001\u0000\u0089\u008a\u0006\u0003\uffff\uffff\u0000"+
		"\u008a\u0097\u0001\u0000\u0000\u0000\u008b\u008c\u0005\u0002\u0000\u0000"+
		"\u008c\u008d\u0006\u0003\uffff\uffff\u0000\u008d\u008e\u0005\f\u0000\u0000"+
		"\u008e\u008f\u0006\u0003\uffff\uffff\u0000\u008f\u0090\u0005\u0006\u0000"+
		"\u0000\u0090\u0091\u0006\u0003\uffff\uffff\u0000\u0091\u0092\u0003\u0002"+
		"\u0001\u0000\u0092\u0093\u0006\u0003\uffff\uffff\u0000\u0093\u0094\u0003"+
		"\u0006\u0003\u0000\u0094\u0095\u0006\u0003\uffff\uffff\u0000\u0095\u0097"+
		"\u0001\u0000\u0000\u0000\u0096\u0081\u0001\u0000\u0000\u0000\u0096\u0082"+
		"\u0001\u0000\u0000\u0000\u0096\u008b\u0001\u0000\u0000\u0000\u0097\u0007"+
		"\u0001\u0000\u0000\u0000\u0098\u00ae\u0001\u0000\u0000\u0000\u0099\u009a"+
		"\u0005\u0002\u0000\u0000\u009a\u009b\u0006\u0004\uffff\uffff\u0000\u009b"+
		"\u009c\u0005\f\u0000\u0000\u009c\u009d\u0006\u0004\uffff\uffff\u0000\u009d"+
		"\u009e\u0005\u0006\u0000\u0000\u009e\u009f\u0006\u0004\uffff\uffff\u0000"+
		"\u009f\u00a0\u0003\u0000\u0000\u0000\u00a0\u00a1\u0006\u0004\uffff\uffff"+
		"\u0000\u00a1\u00ae\u0001\u0000\u0000\u0000\u00a2\u00a3\u0005\u0002\u0000"+
		"\u0000\u00a3\u00a4\u0006\u0004\uffff\uffff\u0000\u00a4\u00a5\u0005\f\u0000"+
		"\u0000\u00a5\u00a6\u0006\u0004\uffff\uffff\u0000\u00a6\u00a7\u0005\u0006"+
		"\u0000\u0000\u00a7\u00a8\u0006\u0004\uffff\uffff\u0000\u00a8\u00a9\u0003"+
		"\u0000\u0000\u0000\u00a9\u00aa\u0006\u0004\uffff\uffff\u0000\u00aa\u00ab"+
		"\u0003\b\u0004\u0000\u00ab\u00ac\u0006\u0004\uffff\uffff\u0000\u00ac\u00ae"+
		"\u0001\u0000\u0000\u0000\u00ad\u0098\u0001\u0000\u0000\u0000\u00ad\u0099"+
		"\u0001\u0000\u0000\u0000\u00ad\u00a2\u0001\u0000\u0000\u0000\u00ae\t\u0001"+
		"\u0000\u0000\u0000\u00af\u00c1\u0001\u0000\u0000\u0000\u00b0\u00b1\u0005"+
		"\u0003\u0000\u0000\u00b1\u00b2\u0006\u0005\uffff\uffff\u0000\u00b2\u00b3"+
		"\u0003\u0000\u0000\u0000\u00b3\u00b4\u0006\u0005\uffff\uffff\u0000\u00b4"+
		"\u00b5\u0005\u0004\u0000\u0000\u00b5\u00b6\u0006\u0005\uffff\uffff\u0000"+
		"\u00b6\u00c1\u0001\u0000\u0000\u0000\u00b7\u00b8\u0005\u0003\u0000\u0000"+
		"\u00b8\u00b9\u0006\u0005\uffff\uffff\u0000\u00b9\u00ba\u0003\u0000\u0000"+
		"\u0000\u00ba\u00bb\u0006\u0005\uffff\uffff\u0000\u00bb\u00bc\u0005\u0004"+
		"\u0000\u0000\u00bc\u00bd\u0006\u0005\uffff\uffff\u0000\u00bd\u00be\u0003"+
		"\n\u0005\u0000\u00be\u00bf\u0006\u0005\uffff\uffff\u0000\u00bf\u00c1\u0001"+
		"\u0000\u0000\u0000\u00c0\u00af\u0001\u0000\u0000\u0000\u00c0\u00b0\u0001"+
		"\u0000\u0000\u0000\u00c0\u00b7\u0001\u0000\u0000\u0000\u00c1\u000b\u0001"+
		"\u0000\u0000\u0000\u00c2\u00cd\u0001\u0000\u0000\u0000\u00c3\u00c4\u0005"+
		"\u000b\u0000\u0000\u00c4\u00c5\u0005\f\u0000\u0000\u00c5\u00cd\u0006\u0006"+
		"\uffff\uffff\u0000\u00c6\u00c7\u0005\u000b\u0000\u0000\u00c7\u00c8\u0005"+
		"\f\u0000\u0000\u00c8\u00c9\u0006\u0006\uffff\uffff\u0000\u00c9\u00ca\u0003"+
		"\f\u0006\u0000\u00ca\u00cb\u0006\u0006\uffff\uffff\u0000\u00cb\u00cd\u0001"+
		"\u0000\u0000\u0000\u00cc\u00c2\u0001\u0000\u0000\u0000\u00cc\u00c3\u0001"+
		"\u0000\u0000\u0000\u00cc\u00c6\u0001\u0000\u0000\u0000\u00cd\r\u0001\u0000"+
		"\u0000\u0000\u0007Wh\u007f\u0096\u00ad\u00c0\u00cc";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}