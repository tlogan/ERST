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
		RULE_expr = 0, RULE_record = 1;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "record"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'()'", "':'", "'=>'", "'@'", "'('", "')'", "'let'", "'='", "'fix'", 
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

	def guard_down(self, f : Callable, plate : Plate, *args) -> Optional[Plate]:
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    result = None
	    if not self._overflow:
	        result = f(plate, *args)
	        self._guidance = result

	        # tok = self.getCurrentToken()
	        # if tok.type == self.EOF :
	        #     self._overflow = True 

	    return result


	def shift(self, guidance : Union[Symbol, Terminal]):   
	    if not self._overflow:
	        self._guidance = guidance 

	        tok = self.getCurrentToken()
	        if tok.type == self.EOF :
	            self._overflow = True 



	def guard_up(self, f : Callable, plate : Plate, *args):

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
		public ExprContext rator;
		public ExprContext rand;
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
			setState(50);
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
				setState(5);
				((ExprContext)_localctx).ID = match(ID);

				_localctx.typ = self.guard_up(self._analyzer.combine_expr_id, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(7);
				match(T__0);

				_localctx.typ = self.guard_up(self._analyzer.combine_expr_unit, plate)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(9);
				match(T__1);
				setState(10);
				((ExprContext)_localctx).ID = match(ID);
				setState(11);
				((ExprContext)_localctx).body = expr(plate);

				_localctx.typ = self.guard_up(self._analyzer.combine_expr_tag, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.typ)

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(14);
				((ExprContext)_localctx).record = record(plate);

				_localctx.typ = ((ExprContext)_localctx).record.typ

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(17);
				((ExprContext)_localctx).ID = match(ID);
				setState(18);
				match(T__2);

				plate_body = self.guard_down(self._analyzer.distill_expr_function_body, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				setState(20);
				((ExprContext)_localctx).body = expr(plate_body);

				plate = plate_body
				_localctx.typ = self.guard_up(self._analyzer.combine_expr_function, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.typ)

				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(23);
				match(T__3);

				# TODO
				plate_rator = plate

				setState(25);
				((ExprContext)_localctx).rator = expr(plate_rator);
				setState(26);
				match(T__4);
				 \
				plate_rand = self.guard_down(self._analyzer.distill_expr_application_rand, plate, ((ExprContext)_localctx).rator.typ)

				setState(28);
				((ExprContext)_localctx).rand = expr(plate_rand);
				setState(29);
				match(T__5);
				 \
				_localctx.typ = self.guard_up(self._analyzer.combine_expr_application, plate, ((ExprContext)_localctx).rator.typ, ((ExprContext)_localctx).rand.typ) 

				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(32);
				match(T__6);
				setState(33);
				((ExprContext)_localctx).ID = match(ID);
				setState(34);
				match(T__7);

				# TODO
				plate_target = plate 

				setState(36);
				((ExprContext)_localctx).target = expr(plate_target);

				plate_body = self.guard_down(self._analyzer.distill_expr_let_body, plate, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.typ)

				setState(38);
				((ExprContext)_localctx).body = expr(plate_body);

				_localctx.typ = ((ExprContext)_localctx).body.typ

				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(41);
				match(T__8);
				 
				self.shift(Symbol("("))

				setState(43);
				match(T__4);

				plate_body = self.guard_down(self._analyzer.distill_expr_fix_body, plate)

				setState(45);
				((ExprContext)_localctx).body = expr(plate_body);

				self.shift(Symbol(')'))

				setState(47);
				match(T__5);

				_localctx.typ = self.guard_up(self._analyzer.combine_expr_fix, plate, ((ExprContext)_localctx).body.typ)

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
			setState(66);
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
				setState(53);
				match(T__9);
				setState(54);
				((RecordContext)_localctx).ID = match(ID);
				setState(55);
				match(T__7);
				setState(56);
				((RecordContext)_localctx).expr = expr(plate);

				_localctx.typ = self.guard_up(self._analyzer.combine_record_single, plate, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).expr.typ)

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(59);
				match(T__9);
				setState(60);
				((RecordContext)_localctx).ID = match(ID);
				setState(61);
				match(T__7);
				setState(62);
				((RecordContext)_localctx).expr = expr(plate);
				setState(63);
				((RecordContext)_localctx).record = record(plate);

				_localctx.typ = self.guard_up(self._analyzer.combine_record_cons, plate, (((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null), ((RecordContext)_localctx).expr.typ, ((RecordContext)_localctx).record.typ)

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
		"\u0004\u0001\rE\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u00003\b\u0000\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0003\u0001C\b\u0001\u0001\u0001\u0000\u0000\u0002"+
		"\u0000\u0002\u0000\u0000L\u00002\u0001\u0000\u0000\u0000\u0002B\u0001"+
		"\u0000\u0000\u0000\u00043\u0001\u0000\u0000\u0000\u0005\u0006\u0005\u000b"+
		"\u0000\u0000\u00063\u0006\u0000\uffff\uffff\u0000\u0007\b\u0005\u0001"+
		"\u0000\u0000\b3\u0006\u0000\uffff\uffff\u0000\t\n\u0005\u0002\u0000\u0000"+
		"\n\u000b\u0005\u000b\u0000\u0000\u000b\f\u0003\u0000\u0000\u0000\f\r\u0006"+
		"\u0000\uffff\uffff\u0000\r3\u0001\u0000\u0000\u0000\u000e\u000f\u0003"+
		"\u0002\u0001\u0000\u000f\u0010\u0006\u0000\uffff\uffff\u0000\u00103\u0001"+
		"\u0000\u0000\u0000\u0011\u0012\u0005\u000b\u0000\u0000\u0012\u0013\u0005"+
		"\u0003\u0000\u0000\u0013\u0014\u0006\u0000\uffff\uffff\u0000\u0014\u0015"+
		"\u0003\u0000\u0000\u0000\u0015\u0016\u0006\u0000\uffff\uffff\u0000\u0016"+
		"3\u0001\u0000\u0000\u0000\u0017\u0018\u0005\u0004\u0000\u0000\u0018\u0019"+
		"\u0006\u0000\uffff\uffff\u0000\u0019\u001a\u0003\u0000\u0000\u0000\u001a"+
		"\u001b\u0005\u0005\u0000\u0000\u001b\u001c\u0006\u0000\uffff\uffff\u0000"+
		"\u001c\u001d\u0003\u0000\u0000\u0000\u001d\u001e\u0005\u0006\u0000\u0000"+
		"\u001e\u001f\u0006\u0000\uffff\uffff\u0000\u001f3\u0001\u0000\u0000\u0000"+
		" !\u0005\u0007\u0000\u0000!\"\u0005\u000b\u0000\u0000\"#\u0005\b\u0000"+
		"\u0000#$\u0006\u0000\uffff\uffff\u0000$%\u0003\u0000\u0000\u0000%&\u0006"+
		"\u0000\uffff\uffff\u0000&\'\u0003\u0000\u0000\u0000\'(\u0006\u0000\uffff"+
		"\uffff\u0000(3\u0001\u0000\u0000\u0000)*\u0005\t\u0000\u0000*+\u0006\u0000"+
		"\uffff\uffff\u0000+,\u0005\u0005\u0000\u0000,-\u0006\u0000\uffff\uffff"+
		"\u0000-.\u0003\u0000\u0000\u0000./\u0006\u0000\uffff\uffff\u0000/0\u0005"+
		"\u0006\u0000\u000001\u0006\u0000\uffff\uffff\u000013\u0001\u0000\u0000"+
		"\u00002\u0004\u0001\u0000\u0000\u00002\u0005\u0001\u0000\u0000\u00002"+
		"\u0007\u0001\u0000\u0000\u00002\t\u0001\u0000\u0000\u00002\u000e\u0001"+
		"\u0000\u0000\u00002\u0011\u0001\u0000\u0000\u00002\u0017\u0001\u0000\u0000"+
		"\u00002 \u0001\u0000\u0000\u00002)\u0001\u0000\u0000\u00003\u0001\u0001"+
		"\u0000\u0000\u00004C\u0001\u0000\u0000\u000056\u0005\n\u0000\u000067\u0005"+
		"\u000b\u0000\u000078\u0005\b\u0000\u000089\u0003\u0000\u0000\u00009:\u0006"+
		"\u0001\uffff\uffff\u0000:C\u0001\u0000\u0000\u0000;<\u0005\n\u0000\u0000"+
		"<=\u0005\u000b\u0000\u0000=>\u0005\b\u0000\u0000>?\u0003\u0000\u0000\u0000"+
		"?@\u0003\u0002\u0001\u0000@A\u0006\u0001\uffff\uffff\u0000AC\u0001\u0000"+
		"\u0000\u0000B4\u0001\u0000\u0000\u0000B5\u0001\u0000\u0000\u0000B;\u0001"+
		"\u0000\u0000\u0000C\u0003\u0001\u0000\u0000\u0000\u00022B";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}