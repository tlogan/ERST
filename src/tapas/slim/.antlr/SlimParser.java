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
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, ID=8, INT=9, WS=10;
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
			null, "'()'", "':'", "'let'", "'='", "'fix'", "'('", "')'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "ID", "INT", "WS"
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
	    self._guidance = NontermExpr(m(), Top())
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


	def guard_down(self, f : Callable, *args):
	    for arg in args:
	        if arg == None:
	            self._overflow = True

	    if not self.overflow():
	        self._guidance = f(*args)

	    self.updateOverflow()

	def guard_up(self, f : Callable, *args):
	    if self.overflow():
	        return None
	    else:

	        return f(*args)
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
		public PMap[str, Typ] env;
		public Typ typ;
		public Token ID;
		public ExprContext body;
		public ExprContext target;
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public ExprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ExprContext(ParserRuleContext parent, int invokingState, PMap[str, Typ] env) {
			super(parent, invokingState);
			this.env = env;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr(PMap[str, Typ] env) throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState(), env);
		enterRule(_localctx, 0, RULE_expr);
		try {
			setState(29);
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
				setState(3);
				((ExprContext)_localctx).ID = match(ID);

				print(f"OOGA ID !!!!: {(((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null)}")
				print(f"OOGA ENV !!!!: {env}")
				_localctx.typ = self.guard_up(gather_expr_id, env, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null))

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(5);
				match(T__0);

				_localctx.typ = self.guard_up(gather_expr_unit)

				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(7);
				match(T__1);
				setState(8);
				((ExprContext)_localctx).ID = match(ID);
				setState(9);
				((ExprContext)_localctx).body = expr(env);


				print(f"TAG body type: {((ExprContext)_localctx).body.typ}")
				_localctx.typ = self.guard_up(gather_expr_tag, env, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).body.typ)

				print(f"TAG $typ: {_localctx.typ}")

				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(12);
				match(T__2);
				setState(13);
				((ExprContext)_localctx).ID = match(ID);
				setState(14);
				match(T__3);
				setState(15);
				((ExprContext)_localctx).target = expr(env);

				self.guard_down(guide_expr_let_body, env, (((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null), ((ExprContext)_localctx).target.typ)
				if isinstance(self._guidance, NontermExpr):
				    env = self._guidance.env

				setState(17);
				((ExprContext)_localctx).body = expr(env);

				_localctx.typ = self.guard_up(gather_expr_let, env, ((ExprContext)_localctx).body.typ)

				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(20);
				match(T__4);
				 
				self.guard_down(lambda: Symbol("("))

				setState(22);
				match(T__5);

				self.guard_down(lambda: NontermExpr(env, Top()))

				setState(24);
				((ExprContext)_localctx).body = expr(env);

				self.guard_down(lambda: Symbol(')'))

				setState(26);
				match(T__6);

				_localctx.typ = self.guard_up(gather_expr_fix, ((ExprContext)_localctx).body.typ)

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
		"\u0004\u0001\n \u0002\u0000\u0007\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001"+
		"\u0000\u0003\u0000\u001e\b\u0000\u0001\u0000\u0000\u0000\u0001\u0000\u0000"+
		"\u0000#\u0000\u001d\u0001\u0000\u0000\u0000\u0002\u001e\u0001\u0000\u0000"+
		"\u0000\u0003\u0004\u0005\b\u0000\u0000\u0004\u001e\u0006\u0000\uffff\uffff"+
		"\u0000\u0005\u0006\u0005\u0001\u0000\u0000\u0006\u001e\u0006\u0000\uffff"+
		"\uffff\u0000\u0007\b\u0005\u0002\u0000\u0000\b\t\u0005\b\u0000\u0000\t"+
		"\n\u0003\u0000\u0000\u0000\n\u000b\u0006\u0000\uffff\uffff\u0000\u000b"+
		"\u001e\u0001\u0000\u0000\u0000\f\r\u0005\u0003\u0000\u0000\r\u000e\u0005"+
		"\b\u0000\u0000\u000e\u000f\u0005\u0004\u0000\u0000\u000f\u0010\u0003\u0000"+
		"\u0000\u0000\u0010\u0011\u0006\u0000\uffff\uffff\u0000\u0011\u0012\u0003"+
		"\u0000\u0000\u0000\u0012\u0013\u0006\u0000\uffff\uffff\u0000\u0013\u001e"+
		"\u0001\u0000\u0000\u0000\u0014\u0015\u0005\u0005\u0000\u0000\u0015\u0016"+
		"\u0006\u0000\uffff\uffff\u0000\u0016\u0017\u0005\u0006\u0000\u0000\u0017"+
		"\u0018\u0006\u0000\uffff\uffff\u0000\u0018\u0019\u0003\u0000\u0000\u0000"+
		"\u0019\u001a\u0006\u0000\uffff\uffff\u0000\u001a\u001b\u0005\u0007\u0000"+
		"\u0000\u001b\u001c\u0006\u0000\uffff\uffff\u0000\u001c\u001e\u0001\u0000"+
		"\u0000\u0000\u001d\u0002\u0001\u0000\u0000\u0000\u001d\u0003\u0001\u0000"+
		"\u0000\u0000\u001d\u0005\u0001\u0000\u0000\u0000\u001d\u0007\u0001\u0000"+
		"\u0000\u0000\u001d\f\u0001\u0000\u0000\u0000\u001d\u0014\u0001\u0000\u0000"+
		"\u0000\u001e\u0001\u0001\u0000\u0000\u0000\u0001\u001d";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}