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
		T__9=10, ID=11, INT=12, WS=13;
	public static final int
		RULE_expr = 0, RULE_record = 1, RULE_argchain = 2, RULE_keychain = 3;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "record", "argchain", "keychain"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'@'", "':'", "'('", "')'", "'=>'", "'let'", "'='", "';'", "'fix'", 
			"'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, "ID", 
			"INT", "WS"
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
		public Typ typ;
		public Token ID;
		public ExprContext body;
		public RecordContext record;
		public ExprContext expr;
		public ExprContext cator;
		public KeychainContext keychain;
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
			setState(84);
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
				setState(9);
				((ExprContext)_localctx).ID = match(ID);

				_localctx.typ = self.mem(self._analyzer.combine_expr_id, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(11);
				match(T__0);

				_localctx.typ = self.mem(self._analyzer.combine_expr_unit, plate)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(13);
				match(T__1);
				setState(14);
				((ExprContext)_localctx).ID = match(ID);
				setState(15);
				((ExprContext)_localctx).body = expr(plate);

				_localctx.typ = self.mem(self._analyzer.combine_expr_tag, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.typ)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(18);
				((ExprContext)_localctx).record = record(plate);

				_localctx.typ = ((ExprContext)_localctx).record.typ

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(21);
				match(T__2);


				setState(23);
				((ExprContext)_localctx).expr = expr(plate);

				self.guide_symbol(')')

				setState(25);
				match(T__3);

				_localctx.typ = ((ExprContext)_localctx).expr.typ

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(28);
				match(T__2);

				plate_cator = self.guide_choice(self._analyzer.distill_expr_projmulti_cator, plate)

				setState(30);
				((ExprContext)_localctx).cator = ((ExprContext)_localctx).expr = expr(plate_expr);

				self.guide_symbol(')')

				setState(32);
				match(T__3);

				plate_keychain = self.guide_choice(self._analyzer.distill_expr_projmulti_keychain, plate, ((ExprContext)_localctx).expr.typ)

				setState(34);
				((ExprContext)_localctx).keychain = keychain(plate_keychain);

				_localctx.typ = self.mem(self._analyzer.combine_expr_projmulti, plate, ((ExprContext)_localctx).expr.typ, ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(37);
				((ExprContext)_localctx).ID = match(ID);

				plate_keychain = self.guide_choice(self._analyzer.distill_expr_idprojmulti_keychain, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(39);
				((ExprContext)_localctx).keychain = keychain(plate_keychain);

				_localctx.typ = self.mem(self._analyzer.combine_expr_idprojmulti, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).keychain.ids) 

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(42);
				((ExprContext)_localctx).ID = match(ID);

				self.guide_symbol('=>')

				setState(44);
				match(T__4);

				plate_body = self.guide_choice(self._analyzer.distill_expr_function_body, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(46);
				((ExprContext)_localctx).body = expr(plate_body);

				plate = plate_body
				_localctx.typ = self.mem(self._analyzer.combine_expr_function, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.typ)

				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(49);
				match(T__2);

				plate_cator = self.guide_choice(self._analyzer.distill_expr_appmulti_cator, plate)

				setState(51);
				((ExprContext)_localctx).cator = expr(plate_cator);

				self.guide_symbol(')')

				setState(53);
				match(T__3);

				plate_argchain = self.guide_choice(self._analyzer.distill_expr_appmulti_argchain, plate, ((ExprContext)_localctx).cator.typ)

				setState(55);
				((ExprContext)_localctx).content = ((ExprContext)_localctx).argchain = argchain(plate_argchain);

				_localctx.typ = self.mem(self._analyzer.combine_expr_appmulti, plate, ((ExprContext)_localctx).cator.typ, ((ExprContext)_localctx).argchain.typs)

				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(58);
				((ExprContext)_localctx).ID = match(ID);

				plate_argchain = self.guide_choice(self._analyzer.distill_expr_idappmulti_argchain, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(60);
				((ExprContext)_localctx).argchain = argchain(plate_argchain);

				_localctx.typ = self.mem(self._analyzer.combine_expr_idappmulti, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).argchain.typs) 

				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(63);
				match(T__5);
				setState(64);
				((ExprContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(66);
				match(T__6);

				plate_target = plate #TODO

				setState(68);
				((ExprContext)_localctx).target = expr(plate_target);

				self.guide_symbol(';')

				setState(70);
				match(T__7);

				plate_body = self.guide_choice(self._analyzer.distill_expr_let_body, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.typ)

				setState(72);
				((ExprContext)_localctx).body = expr(plate_body);

				_localctx.typ = ((ExprContext)_localctx).body.typ

				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(75);
				match(T__8);

				self.guide_symbol('(')

				setState(77);
				match(T__2);

				plate_body = self.guide_choice(self._analyzer.distill_expr_fix_body, plate)

				setState(79);
				((ExprContext)_localctx).body = expr(plate_body);

				self.guide_symbol(')')

				setState(81);
				match(T__3);

				_localctx.typ = self.mem(self._analyzer.combine_expr_fix, plate, ((ExprContext)_localctx).body.typ)

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
		public Typ typ;
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
		enterRule(_localctx, 2, RULE_record);
		try {
			setState(107);
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
				setState(87);
				match(T__1);

				self.guide_terminal('ID')

				setState(89);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(91);
				match(T__6);

				plate_expr = plate # TODO

				setState(93);
				((RecordContext)_localctx).expr = expr(plate_expr);

				_localctx.typ = self.mem(self._analyzer.combine_record_single, plate, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).expr.typ)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(96);
				match(T__1);

				self.guide_terminal('ID')

				setState(98);
				((RecordContext)_localctx).ID = match(ID);

				self.guide_symbol('=')

				setState(100);
				match(T__6);

				plate_expr = plate # TODO

				setState(102);
				((RecordContext)_localctx).expr = expr(plate);

				plate_record = plate # TODO

				setState(104);
				((RecordContext)_localctx).record = record(plate);

				_localctx.typ = self.mem(self._analyzer.combine_record_cons, plate, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).expr.typ, ((RecordContext)_localctx).record.typ)

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
		public list[Typ] typs;
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
		enterRule(_localctx, 4, RULE_argchain);
		try {
			setState(126);
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
				setState(110);
				match(T__2);

				plate_content = self.guide_choice(self._analyzer.distill_argchain_single_content, plate) 

				setState(112);
				((ArgchainContext)_localctx).content = expr(plate_content);

				self.guide_symbol(')')

				setState(114);
				match(T__3);

				_localctx.typs = self.mem(self._analyzer.combine_argchain_single, plate, ((ArgchainContext)_localctx).content.typ)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(117);
				match(T__2);

				plate_head = self.guide_choice(self._analyzer.distill_argchain_cons_head, plate) 

				setState(119);
				((ArgchainContext)_localctx).head = expr(plate_head);

				self.guide_symbol(')')

				setState(121);
				match(T__3);

				plate_tail = self.guide_choice(self._analyzer.distill_argchain_cons_tail, plate, ((ArgchainContext)_localctx).head.typ) 

				setState(123);
				((ArgchainContext)_localctx).tail = argchain(plate_tail);

				_localctx.typs = self.mem(self._analyzer.combine_argchain_cons, plate, ((ArgchainContext)_localctx).head.typ, ((ArgchainContext)_localctx).tail.typs)

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
		enterRule(_localctx, 6, RULE_keychain);
		try {
			setState(138);
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
				setState(129);
				match(T__9);
				setState(130);
				((KeychainContext)_localctx).ID = match(ID);

				_localctx.ids = self.mem(self._analyzer.combine_keychain_single, plate, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(132);
				match(T__9);
				setState(133);
				((KeychainContext)_localctx).ID = match(ID);

				plate_tail = self.guide_choice(self._analyzer.distill_keychain_cons_tail, plate, (((KeychainContext)_localctx).ID!=null?((KeychainContext)_localctx).ID.getText():null)) 

				setState(135);
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
		"\u0004\u0001\r\u008d\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0003\u0000U\b\u0000\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0003\u0001l\b\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0003\u0002\u007f\b\u0002\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001"+
		"\u0003\u0001\u0003\u0003\u0003\u008b\b\u0003\u0001\u0003\u0000\u0000\u0004"+
		"\u0000\u0002\u0004\u0006\u0000\u0000\u009a\u0000T\u0001\u0000\u0000\u0000"+
		"\u0002k\u0001\u0000\u0000\u0000\u0004~\u0001\u0000\u0000\u0000\u0006\u008a"+
		"\u0001\u0000\u0000\u0000\bU\u0001\u0000\u0000\u0000\t\n\u0005\u000b\u0000"+
		"\u0000\nU\u0006\u0000\uffff\uffff\u0000\u000b\f\u0005\u0001\u0000\u0000"+
		"\fU\u0006\u0000\uffff\uffff\u0000\r\u000e\u0005\u0002\u0000\u0000\u000e"+
		"\u000f\u0005\u000b\u0000\u0000\u000f\u0010\u0003\u0000\u0000\u0000\u0010"+
		"\u0011\u0006\u0000\uffff\uffff\u0000\u0011U\u0001\u0000\u0000\u0000\u0012"+
		"\u0013\u0003\u0002\u0001\u0000\u0013\u0014\u0006\u0000\uffff\uffff\u0000"+
		"\u0014U\u0001\u0000\u0000\u0000\u0015\u0016\u0005\u0003\u0000\u0000\u0016"+
		"\u0017\u0006\u0000\uffff\uffff\u0000\u0017\u0018\u0003\u0000\u0000\u0000"+
		"\u0018\u0019\u0006\u0000\uffff\uffff\u0000\u0019\u001a\u0005\u0004\u0000"+
		"\u0000\u001a\u001b\u0006\u0000\uffff\uffff\u0000\u001bU\u0001\u0000\u0000"+
		"\u0000\u001c\u001d\u0005\u0003\u0000\u0000\u001d\u001e\u0006\u0000\uffff"+
		"\uffff\u0000\u001e\u001f\u0003\u0000\u0000\u0000\u001f \u0006\u0000\uffff"+
		"\uffff\u0000 !\u0005\u0004\u0000\u0000!\"\u0006\u0000\uffff\uffff\u0000"+
		"\"#\u0003\u0006\u0003\u0000#$\u0006\u0000\uffff\uffff\u0000$U\u0001\u0000"+
		"\u0000\u0000%&\u0005\u000b\u0000\u0000&\'\u0006\u0000\uffff\uffff\u0000"+
		"\'(\u0003\u0006\u0003\u0000()\u0006\u0000\uffff\uffff\u0000)U\u0001\u0000"+
		"\u0000\u0000*+\u0005\u000b\u0000\u0000+,\u0006\u0000\uffff\uffff\u0000"+
		",-\u0005\u0005\u0000\u0000-.\u0006\u0000\uffff\uffff\u0000./\u0003\u0000"+
		"\u0000\u0000/0\u0006\u0000\uffff\uffff\u00000U\u0001\u0000\u0000\u0000"+
		"12\u0005\u0003\u0000\u000023\u0006\u0000\uffff\uffff\u000034\u0003\u0000"+
		"\u0000\u000045\u0006\u0000\uffff\uffff\u000056\u0005\u0004\u0000\u0000"+
		"67\u0006\u0000\uffff\uffff\u000078\u0003\u0004\u0002\u000089\u0006\u0000"+
		"\uffff\uffff\u00009U\u0001\u0000\u0000\u0000:;\u0005\u000b\u0000\u0000"+
		";<\u0006\u0000\uffff\uffff\u0000<=\u0003\u0004\u0002\u0000=>\u0006\u0000"+
		"\uffff\uffff\u0000>U\u0001\u0000\u0000\u0000?@\u0005\u0006\u0000\u0000"+
		"@A\u0005\u000b\u0000\u0000AB\u0006\u0000\uffff\uffff\u0000BC\u0005\u0007"+
		"\u0000\u0000CD\u0006\u0000\uffff\uffff\u0000DE\u0003\u0000\u0000\u0000"+
		"EF\u0006\u0000\uffff\uffff\u0000FG\u0005\b\u0000\u0000GH\u0006\u0000\uffff"+
		"\uffff\u0000HI\u0003\u0000\u0000\u0000IJ\u0006\u0000\uffff\uffff\u0000"+
		"JU\u0001\u0000\u0000\u0000KL\u0005\t\u0000\u0000LM\u0006\u0000\uffff\uffff"+
		"\u0000MN\u0005\u0003\u0000\u0000NO\u0006\u0000\uffff\uffff\u0000OP\u0003"+
		"\u0000\u0000\u0000PQ\u0006\u0000\uffff\uffff\u0000QR\u0005\u0004\u0000"+
		"\u0000RS\u0006\u0000\uffff\uffff\u0000SU\u0001\u0000\u0000\u0000T\b\u0001"+
		"\u0000\u0000\u0000T\t\u0001\u0000\u0000\u0000T\u000b\u0001\u0000\u0000"+
		"\u0000T\r\u0001\u0000\u0000\u0000T\u0012\u0001\u0000\u0000\u0000T\u0015"+
		"\u0001\u0000\u0000\u0000T\u001c\u0001\u0000\u0000\u0000T%\u0001\u0000"+
		"\u0000\u0000T*\u0001\u0000\u0000\u0000T1\u0001\u0000\u0000\u0000T:\u0001"+
		"\u0000\u0000\u0000T?\u0001\u0000\u0000\u0000TK\u0001\u0000\u0000\u0000"+
		"U\u0001\u0001\u0000\u0000\u0000Vl\u0001\u0000\u0000\u0000WX\u0005\u0002"+
		"\u0000\u0000XY\u0006\u0001\uffff\uffff\u0000YZ\u0005\u000b\u0000\u0000"+
		"Z[\u0006\u0001\uffff\uffff\u0000[\\\u0005\u0007\u0000\u0000\\]\u0006\u0001"+
		"\uffff\uffff\u0000]^\u0003\u0000\u0000\u0000^_\u0006\u0001\uffff\uffff"+
		"\u0000_l\u0001\u0000\u0000\u0000`a\u0005\u0002\u0000\u0000ab\u0006\u0001"+
		"\uffff\uffff\u0000bc\u0005\u000b\u0000\u0000cd\u0006\u0001\uffff\uffff"+
		"\u0000de\u0005\u0007\u0000\u0000ef\u0006\u0001\uffff\uffff\u0000fg\u0003"+
		"\u0000\u0000\u0000gh\u0006\u0001\uffff\uffff\u0000hi\u0003\u0002\u0001"+
		"\u0000ij\u0006\u0001\uffff\uffff\u0000jl\u0001\u0000\u0000\u0000kV\u0001"+
		"\u0000\u0000\u0000kW\u0001\u0000\u0000\u0000k`\u0001\u0000\u0000\u0000"+
		"l\u0003\u0001\u0000\u0000\u0000m\u007f\u0001\u0000\u0000\u0000no\u0005"+
		"\u0003\u0000\u0000op\u0006\u0002\uffff\uffff\u0000pq\u0003\u0000\u0000"+
		"\u0000qr\u0006\u0002\uffff\uffff\u0000rs\u0005\u0004\u0000\u0000st\u0006"+
		"\u0002\uffff\uffff\u0000t\u007f\u0001\u0000\u0000\u0000uv\u0005\u0003"+
		"\u0000\u0000vw\u0006\u0002\uffff\uffff\u0000wx\u0003\u0000\u0000\u0000"+
		"xy\u0006\u0002\uffff\uffff\u0000yz\u0005\u0004\u0000\u0000z{\u0006\u0002"+
		"\uffff\uffff\u0000{|\u0003\u0004\u0002\u0000|}\u0006\u0002\uffff\uffff"+
		"\u0000}\u007f\u0001\u0000\u0000\u0000~m\u0001\u0000\u0000\u0000~n\u0001"+
		"\u0000\u0000\u0000~u\u0001\u0000\u0000\u0000\u007f\u0005\u0001\u0000\u0000"+
		"\u0000\u0080\u008b\u0001\u0000\u0000\u0000\u0081\u0082\u0005\n\u0000\u0000"+
		"\u0082\u0083\u0005\u000b\u0000\u0000\u0083\u008b\u0006\u0003\uffff\uffff"+
		"\u0000\u0084\u0085\u0005\n\u0000\u0000\u0085\u0086\u0005\u000b\u0000\u0000"+
		"\u0086\u0087\u0006\u0003\uffff\uffff\u0000\u0087\u0088\u0003\u0006\u0003"+
		"\u0000\u0088\u0089\u0006\u0003\uffff\uffff\u0000\u0089\u008b\u0001\u0000"+
		"\u0000\u0000\u008a\u0080\u0001\u0000\u0000\u0000\u008a\u0081\u0001\u0000"+
		"\u0000\u0000\u008a\u0084\u0001\u0000\u0000\u0000\u008b\u0007\u0001\u0000"+
		"\u0000\u0000\u0004Tk~\u008a";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}