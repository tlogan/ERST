// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analysis import * 


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
		T__0=1, T__1=2, T__2=3, T__3=4, ID=5, INT=6, WS=7;
	public static final int
		RULE_expr = 0;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'()'", "'fix'", "'('", "')'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
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



	_guidance : Guidance 
	_cache : dict[int, str] = {}
	_overflow = False  

	def reset(self): 
	    # self.setInputStream(token_stream)
	    self._guidance = NontermExpr(Top)
	    self._overflow = False
	    # self.getCurrentToken()
	    # self.getTokenStream()



	def getGuidance(self):
	    return self._guidance

	def tokenIndex(self):
	    return self.getCurrentToken().tokenIndex

	def updateOverflow(self):
	    tok = self.getCurrentToken()
	    if not self._overflow and tok.type == self.EOF :
	        self._overflow = True 

	def overflow(self) -> bool: 
	    return self._overflow


	# @contextmanager
	# def manage_guidance(self):
	#     if not self.overflow():
	#         yield
	#     self.updateOverflow()

	def guard_down(self, f : Callable, *args):
	    if not self.overflow():
	        self._guidance = f(*args)
	    self.updateOverflow()

	def guard_up(self, f : Callable, *args):
	    if self.overflow():
	        return None
	    else:
	        index = self.tokenIndex()
	        cache_result = self._cache.get(index)
	        if cache_result:
	            return cache_result
	        else:
	            result = f(*args)
	            self._cache[index] = result
	            return result


	public SlimParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ExprContext extends ParserRuleContext {
		public str result;
		public ExprContext body;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr() throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_expr);
		try {
			setState(15);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__3:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case ID:
				enterOuterAlt(_localctx, 2);
				{
				setState(3);
				match(ID);
				}
				break;
			case T__0:
				enterOuterAlt(_localctx, 3);
				{
				setState(4);
				match(T__0);

				_localctx.result = self.guard_up(gather_expr_unit)

				}
				break;
			case T__1:
				enterOuterAlt(_localctx, 4);
				{
				setState(6);
				match(T__1);
				 
				self.guard_down(lambda: Symbol("("))

				setState(8);
				match(T__2);

				self.guard_down(lambda: NontermExpr(Top))

				setState(10);
				((ExprContext)_localctx).body = expr();

				self.guard_down(lambda: Symbol(')'))

				setState(12);
				match(T__3);

				_localctx.result = self.guard_up(gather_expr_fix, ((ExprContext)_localctx).body.result)

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

	public static final String _serializedATN =
		"\u0004\u0001\u0007\u0012\u0002\u0000\u0007\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0003\u0000"+
		"\u0010\b\u0000\u0001\u0000\u0000\u0000\u0001\u0000\u0000\u0000\u0013\u0000"+
		"\u000f\u0001\u0000\u0000\u0000\u0002\u0010\u0001\u0000\u0000\u0000\u0003"+
		"\u0010\u0005\u0005\u0000\u0000\u0004\u0005\u0005\u0001\u0000\u0000\u0005"+
		"\u0010\u0006\u0000\uffff\uffff\u0000\u0006\u0007\u0005\u0002\u0000\u0000"+
		"\u0007\b\u0006\u0000\uffff\uffff\u0000\b\t\u0005\u0003\u0000\u0000\t\n"+
		"\u0006\u0000\uffff\uffff\u0000\n\u000b\u0003\u0000\u0000\u0000\u000b\f"+
		"\u0006\u0000\uffff\uffff\u0000\f\r\u0005\u0004\u0000\u0000\r\u000e\u0006"+
		"\u0000\uffff\uffff\u0000\u000e\u0010\u0001\u0000\u0000\u0000\u000f\u0002"+
		"\u0001\u0000\u0000\u0000\u000f\u0003\u0001\u0000\u0000\u0000\u000f\u0004"+
		"\u0001\u0000\u0000\u0000\u000f\u0006\u0001\u0000\u0000\u0000\u0010\u0001"+
		"\u0001\u0000\u0000\u0000\u0001\u000f";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}