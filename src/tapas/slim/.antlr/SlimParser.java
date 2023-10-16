// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *


@dataclass(frozen=True, eq=True)
class Symbol:
    content : str

@dataclass(frozen=True, eq=True)
class Terminal:
    content : str

@dataclass(frozen=True, eq=True)
class Nonterm: 
    content : str


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
		RULE_expr = 0, RULE_record = 1;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "record"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'()'", "':'", "'=>'", "'('", "')'", "'fun'", "'if'", "'then'", 
			"'else'", "'fix'", "'.'", "'='"
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



	guidance : Union[Symbol, Terminal, Nonterm]
	cache : dict[int, str] 
	_overflow = False  

	 

	# _guidance : Union[Symbol, Terminal, Nonterm]
	# @property
	# def guidance(self) -> Union[Symbol, Terminal, Nonterm]:
	#     return self._guidance
	# 
	# @guidance.setter
	# def guidance(self, value : Union[Symbol, Terminal, Nonterm]):
	#     self._guidance = value

	#def getAllText(self):  # include hidden channel
	#    # token_stream = ctx.parser.getTokenStream()
	#    token_stream = self.getTokenStream()
	#    lexer = token_stream.tokenSource
	#    input_stream = lexer.inputStream
	#    # start = ctx.start.start
	#    start = 0
	#    # stop = ctx.stop.stop
	#
	#    # TODO: increment token position in attributes
	#    # TODO: map token position to result 
	#    # TODO: figure out a way to get the current position of the parser
	#    stop = self.getRuleIndex()
	#    # return input_stream.getText(start, stop)
	#    print(f"start: {start}")
	#    print(f"stoppy poop: {stop}")
	#    return "<<not yet implemented>>"
	#    # return input_stream.getText(start, stop)[start:stop]


	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex

	def updateOverflow(self):
	    tok = self.getCurrentToken()
	    print(f"TOK (updateOverflow): {tok}")
	    print(f"_overflow: : {self._overflow}")
	    if not self._overflow and tok.type == self.EOF :
	        self._overflow = True 

	def overflow(self) -> bool: 
	    return self._overflow


	public SlimParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ExprContext extends ParserRuleContext {
		public str result;
		public Token ID;
		public ExprContext expr;
		public RecordContext record;
		public ExprContext param;
		public ExprContext body;
		public ExprContext cond;
		public ExprContext t;
		public ExprContext f;
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
		public ExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr() throws RecognitionException {
		return expr(0);
	}

	private ExprContext expr(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExprContext _localctx = new ExprContext(_ctx, _parentState);
		ExprContext _prevctx = _localctx;
		int _startState = 0;
		enterRecursionRule(_localctx, 0, RULE_expr, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(49);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				{
				}
				break;
			case 2:
				{
				setState(5);
				((ExprContext)_localctx).ID = match(ID);

				((ExprContext)_localctx).result =  f'(id {(((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null)})';

				}
				break;
			case 3:
				{
				setState(7);
				match(T__0);

				if self.cache.get(self.tokenIndex()):
				    print("CACHE HIT")
				    _localctx.result = self.cache[self.tokenIndex()]
				else:
				    print("COMPUTATION")
				    _localctx.result = f'(unit)'
				    self.cache[self.tokenIndex()] = _localctx.result

				}
				break;
			case 4:
				{
				setState(9);
				match(T__1);
				setState(10);
				((ExprContext)_localctx).ID = match(ID);
				setState(11);
				((ExprContext)_localctx).expr = expr(8);

				_localctx.result = f'(tag {(((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null)} {((ExprContext)_localctx).expr.result})'

				}
				break;
			case 5:
				{
				setState(14);
				((ExprContext)_localctx).record = record();

				_localctx.result = ((ExprContext)_localctx).record.result

				}
				break;
			case 6:
				{
				setState(17);
				((ExprContext)_localctx).ID = match(ID);
				setState(18);
				match(T__2);
				setState(19);
				((ExprContext)_localctx).expr = expr(6);
				}
				break;
			case 7:
				{
				setState(25); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(20);
						match(T__5);
						setState(21);
						((ExprContext)_localctx).param = ((ExprContext)_localctx).expr = expr(0);
						setState(22);
						match(T__2);
						setState(23);
						((ExprContext)_localctx).body = ((ExprContext)_localctx).expr = expr(0);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(27); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,0,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 8:
				{
				setState(29);
				match(T__6);
				setState(30);
				((ExprContext)_localctx).cond = ((ExprContext)_localctx).expr = expr(0);
				setState(31);
				match(T__7);
				setState(32);
				((ExprContext)_localctx).t = ((ExprContext)_localctx).expr = expr(0);
				setState(33);
				match(T__8);
				setState(34);
				((ExprContext)_localctx).f = ((ExprContext)_localctx).expr = expr(3);
				}
				break;
			case 9:
				{
				setState(36);
				match(T__9);
				 
				self.guidance = Symbol("(")
				self.updateOverflow()

				setState(38);
				match(T__3);

				if not self.overflow(): 
				    self.guidance = Nonterm("expr")
				    # print(f"GUIDANCE: {self.guidance}")

				self.updateOverflow()

				setState(40);
				((ExprContext)_localctx).body = ((ExprContext)_localctx).expr = expr(0);

				# TODO: need to detect that token index has not changed 
				# lack of change indicates outofbounds  
				# set token_index to -1 when out of bounds
				print("REACHED HERE")
				print(f"REACHED HERE overflow: {self.overflow()}")

				if not self.overflow(): 
				    self.guidance = Symbol(")")
				    # print(f"GUIDANCE: {self.guidance}")

				self.updateOverflow()

				setState(42);
				match(T__4);

				_localctx.result = f'(fix {((ExprContext)_localctx).body.result})'

				}
				break;
			case 10:
				{
				setState(45);
				match(T__3);
				setState(46);
				((ExprContext)_localctx).body = ((ExprContext)_localctx).expr = expr(0);
				setState(47);
				match(T__4);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(58);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,2,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new ExprContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_expr);
					setState(51);
					if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
					setState(52);
					match(T__3);
					setState(53);
					((ExprContext)_localctx).expr = expr(0);
					setState(54);
					match(T__4);
					}
					} 
				}
				setState(60);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,2,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class RecordContext extends ParserRuleContext {
		public str result;
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
		public RecordContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_record; }
	}

	public final RecordContext record() throws RecognitionException {
		RecordContext _localctx = new RecordContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_record);
		try {
			setState(75);
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
				setState(62);
				match(T__10);
				setState(63);
				((RecordContext)_localctx).ID = match(ID);
				setState(64);
				match(T__11);
				setState(65);
				((RecordContext)_localctx).expr = expr(0);

				_localctx.result = f'(field {(((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null)} {((RecordContext)_localctx).expr.result})'

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(68);
				match(T__10);
				setState(69);
				((RecordContext)_localctx).ID = match(ID);
				setState(70);
				match(T__11);
				setState(71);
				((RecordContext)_localctx).expr = expr(0);
				setState(72);
				((RecordContext)_localctx).record = record();

				_localctx.result = f'(field {(((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null)} {((RecordContext)_localctx).expr.result})' + ' ' + ((RecordContext)_localctx).record.result 

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

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 0:
			return expr_sempred((ExprContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 5);
		}
		return true;
	}

	public static final String _serializedATN =
		"\u0004\u0001\u000fN\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0004\u0000\u001a\b\u0000\u000b\u0000\f"+
		"\u0000\u001b\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u00002\b\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0005\u00009\b\u0000"+
		"\n\u0000\f\u0000<\t\u0000\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0003\u0001L\b\u0001"+
		"\u0001\u0001\u0000\u0001\u0000\u0002\u0000\u0002\u0000\u0000X\u00001\u0001"+
		"\u0000\u0000\u0000\u0002K\u0001\u0000\u0000\u0000\u00042\u0006\u0000\uffff"+
		"\uffff\u0000\u0005\u0006\u0005\r\u0000\u0000\u00062\u0006\u0000\uffff"+
		"\uffff\u0000\u0007\b\u0005\u0001\u0000\u0000\b2\u0006\u0000\uffff\uffff"+
		"\u0000\t\n\u0005\u0002\u0000\u0000\n\u000b\u0005\r\u0000\u0000\u000b\f"+
		"\u0003\u0000\u0000\b\f\r\u0006\u0000\uffff\uffff\u0000\r2\u0001\u0000"+
		"\u0000\u0000\u000e\u000f\u0003\u0002\u0001\u0000\u000f\u0010\u0006\u0000"+
		"\uffff\uffff\u0000\u00102\u0001\u0000\u0000\u0000\u0011\u0012\u0005\r"+
		"\u0000\u0000\u0012\u0013\u0005\u0003\u0000\u0000\u00132\u0003\u0000\u0000"+
		"\u0006\u0014\u0015\u0005\u0006\u0000\u0000\u0015\u0016\u0003\u0000\u0000"+
		"\u0000\u0016\u0017\u0005\u0003\u0000\u0000\u0017\u0018\u0003\u0000\u0000"+
		"\u0000\u0018\u001a\u0001\u0000\u0000\u0000\u0019\u0014\u0001\u0000\u0000"+
		"\u0000\u001a\u001b\u0001\u0000\u0000\u0000\u001b\u0019\u0001\u0000\u0000"+
		"\u0000\u001b\u001c\u0001\u0000\u0000\u0000\u001c2\u0001\u0000\u0000\u0000"+
		"\u001d\u001e\u0005\u0007\u0000\u0000\u001e\u001f\u0003\u0000\u0000\u0000"+
		"\u001f \u0005\b\u0000\u0000 !\u0003\u0000\u0000\u0000!\"\u0005\t\u0000"+
		"\u0000\"#\u0003\u0000\u0000\u0003#2\u0001\u0000\u0000\u0000$%\u0005\n"+
		"\u0000\u0000%&\u0006\u0000\uffff\uffff\u0000&\'\u0005\u0004\u0000\u0000"+
		"\'(\u0006\u0000\uffff\uffff\u0000()\u0003\u0000\u0000\u0000)*\u0006\u0000"+
		"\uffff\uffff\u0000*+\u0005\u0005\u0000\u0000+,\u0006\u0000\uffff\uffff"+
		"\u0000,2\u0001\u0000\u0000\u0000-.\u0005\u0004\u0000\u0000./\u0003\u0000"+
		"\u0000\u0000/0\u0005\u0005\u0000\u000002\u0001\u0000\u0000\u00001\u0004"+
		"\u0001\u0000\u0000\u00001\u0005\u0001\u0000\u0000\u00001\u0007\u0001\u0000"+
		"\u0000\u00001\t\u0001\u0000\u0000\u00001\u000e\u0001\u0000\u0000\u0000"+
		"1\u0011\u0001\u0000\u0000\u00001\u0019\u0001\u0000\u0000\u00001\u001d"+
		"\u0001\u0000\u0000\u00001$\u0001\u0000\u0000\u00001-\u0001\u0000\u0000"+
		"\u00002:\u0001\u0000\u0000\u000034\n\u0005\u0000\u000045\u0005\u0004\u0000"+
		"\u000056\u0003\u0000\u0000\u000067\u0005\u0005\u0000\u000079\u0001\u0000"+
		"\u0000\u000083\u0001\u0000\u0000\u00009<\u0001\u0000\u0000\u0000:8\u0001"+
		"\u0000\u0000\u0000:;\u0001\u0000\u0000\u0000;\u0001\u0001\u0000\u0000"+
		"\u0000<:\u0001\u0000\u0000\u0000=L\u0001\u0000\u0000\u0000>?\u0005\u000b"+
		"\u0000\u0000?@\u0005\r\u0000\u0000@A\u0005\f\u0000\u0000AB\u0003\u0000"+
		"\u0000\u0000BC\u0006\u0001\uffff\uffff\u0000CL\u0001\u0000\u0000\u0000"+
		"DE\u0005\u000b\u0000\u0000EF\u0005\r\u0000\u0000FG\u0005\f\u0000\u0000"+
		"GH\u0003\u0000\u0000\u0000HI\u0003\u0002\u0001\u0000IJ\u0006\u0001\uffff"+
		"\uffff\u0000JL\u0001\u0000\u0000\u0000K=\u0001\u0000\u0000\u0000K>\u0001"+
		"\u0000\u0000\u0000KD\u0001\u0000\u0000\u0000L\u0003\u0001\u0000\u0000"+
		"\u0000\u0004\u001b1:K";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}