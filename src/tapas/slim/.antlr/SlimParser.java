// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class SlimParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, ID=13, INT=14, WS=15;
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
			null, "'()'", "':'", "'.'", "'='", "'=>'", "'('", "')'", "'fun'", "'if'", 
			"'then'", "'else'", "'fix'"
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

	public SlimParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class ExprContext extends ParserRuleContext {
		public str $ result;
		public ExprContext param;
		public ExprContext body;
		public ExprContext cond;
		public ExprContext t;
		public ExprContext f;
		public List<TerminalNode> ID() { return getTokens(SlimParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(SlimParser.ID, i);
		}
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
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
			setState(57);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				{
				}
				break;
			case 2:
				{
				setState(3);
				match(ID);

				    
				}
				break;
			case 3:
				{
				setState(5);
				match(T__0);

				    
				}
				break;
			case 4:
				{
				setState(7);
				match(T__1);
				setState(8);
				match(ID);
				setState(9);
				expr(8);

				    
				}
				break;
			case 5:
				{
				setState(16); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(12);
						match(T__2);
						setState(13);
						match(ID);
						setState(14);
						match(T__3);
						setState(15);
						expr(0);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(18); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,0,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );

				    
				}
				break;
			case 6:
				{
				setState(22);
				match(ID);
				setState(23);
				match(T__4);
				setState(24);
				expr(6);

				    
				}
				break;
			case 7:
				{
				setState(32); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(27);
						match(T__7);
						setState(28);
						((ExprContext)_localctx).param = expr(0);
						setState(29);
						match(T__4);
						setState(30);
						((ExprContext)_localctx).body = expr(0);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(34); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,1,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );

				    
				}
				break;
			case 8:
				{
				setState(38);
				match(T__8);
				setState(39);
				((ExprContext)_localctx).cond = expr(0);
				setState(40);
				match(T__9);
				setState(41);
				((ExprContext)_localctx).t = expr(0);
				setState(42);
				match(T__10);
				setState(43);
				((ExprContext)_localctx).f = expr(3);

				    
				}
				break;
			case 9:
				{
				setState(46);
				match(T__11);
				setState(47);
				match(T__5);
				setState(48);
				((ExprContext)_localctx).body = expr(0);
				setState(49);
				match(T__6);

				    
				}
				break;
			case 10:
				{
				setState(52);
				match(T__5);
				setState(53);
				((ExprContext)_localctx).body = expr(0);
				setState(54);
				match(T__6);

				    
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(67);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,3,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new ExprContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_expr);
					setState(59);
					if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
					setState(60);
					match(T__5);
					setState(61);
					expr(0);
					setState(62);
					match(T__6);

					              
					}
					} 
				}
				setState(69);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,3,_ctx);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\21I\4\2\t\2\3\2\3"+
		"\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2\23\n\2\r\2\16\2"+
		"\24\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2#\n\2\r\2\16\2"+
		"$\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\5\2<\n\2\3\2\3\2\3\2\3\2\3\2\3\2\7\2D\n\2\f\2\16\2G\13"+
		"\2\3\2\2\3\2\3\2\2\2\2S\2;\3\2\2\2\4<\b\2\1\2\5\6\7\17\2\2\6<\b\2\1\2"+
		"\7\b\7\3\2\2\b<\b\2\1\2\t\n\7\4\2\2\n\13\7\17\2\2\13\f\5\2\2\n\f\r\b\2"+
		"\1\2\r<\3\2\2\2\16\17\7\5\2\2\17\20\7\17\2\2\20\21\7\6\2\2\21\23\5\2\2"+
		"\2\22\16\3\2\2\2\23\24\3\2\2\2\24\22\3\2\2\2\24\25\3\2\2\2\25\26\3\2\2"+
		"\2\26\27\b\2\1\2\27<\3\2\2\2\30\31\7\17\2\2\31\32\7\7\2\2\32\33\5\2\2"+
		"\b\33\34\b\2\1\2\34<\3\2\2\2\35\36\7\n\2\2\36\37\5\2\2\2\37 \7\7\2\2 "+
		"!\5\2\2\2!#\3\2\2\2\"\35\3\2\2\2#$\3\2\2\2$\"\3\2\2\2$%\3\2\2\2%&\3\2"+
		"\2\2&\'\b\2\1\2\'<\3\2\2\2()\7\13\2\2)*\5\2\2\2*+\7\f\2\2+,\5\2\2\2,-"+
		"\7\r\2\2-.\5\2\2\5./\b\2\1\2/<\3\2\2\2\60\61\7\16\2\2\61\62\7\b\2\2\62"+
		"\63\5\2\2\2\63\64\7\t\2\2\64\65\b\2\1\2\65<\3\2\2\2\66\67\7\b\2\2\678"+
		"\5\2\2\289\7\t\2\29:\b\2\1\2:<\3\2\2\2;\4\3\2\2\2;\5\3\2\2\2;\7\3\2\2"+
		"\2;\t\3\2\2\2;\22\3\2\2\2;\30\3\2\2\2;\"\3\2\2\2;(\3\2\2\2;\60\3\2\2\2"+
		";\66\3\2\2\2<E\3\2\2\2=>\f\7\2\2>?\7\b\2\2?@\5\2\2\2@A\7\t\2\2AB\b\2\1"+
		"\2BD\3\2\2\2C=\3\2\2\2DG\3\2\2\2EC\3\2\2\2EF\3\2\2\2F\3\3\2\2\2GE\3\2"+
		"\2\2\6\24$;E";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}