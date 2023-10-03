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
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, ID=33, INT=34, WS=35;
	public static final int
		RULE_expr = 0, RULE_typ = 1;
	private static String[] makeRuleNames() {
		return new String[] {
			"expr", "typ"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'()'", "':'", "'.'", "'='", "'=>'", "'('", "')'", "'match'", "'case'", 
			"'fun'", "'if'", "'then'", "'else'", "'fix'", "'let'", "'in'", "'unit'", 
			"'top'", "'bot'", "'//'", "'&'", "'*'", "'|'", "'->'", "'{'", "'<:'", 
			"'with'", "'#'", "'}'", "'['", "']'", "'@'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, "ID", "INT", "WS"
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
		public TypContext typ() {
			return getRuleContext(TypContext.class,0);
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
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(67);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
			case 1:
				{
				}
				break;
			case 2:
				{
				setState(5);
				match(ID);
				}
				break;
			case 3:
				{
				setState(6);
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
				expr(11);
				}
				break;
			case 5:
				{
				setState(14); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(10);
						match(T__2);
						setState(11);
						match(ID);
						setState(12);
						match(T__3);
						setState(13);
						expr(0);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(16); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,0,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 6:
				{
				setState(18);
				match(ID);
				setState(19);
				match(T__4);
				setState(20);
				expr(9);
				}
				break;
			case 7:
				{
				setState(21);
				match(T__7);
				setState(22);
				expr(0);
				setState(28); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(23);
						match(T__8);
						setState(24);
						expr(0);
						setState(25);
						match(T__4);
						setState(26);
						expr(0);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(30); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,1,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 8:
				{
				setState(37); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(32);
						match(T__9);
						setState(33);
						expr(0);
						setState(34);
						match(T__4);
						setState(35);
						expr(0);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(39); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,2,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 9:
				{
				setState(41);
				match(T__10);
				setState(42);
				expr(0);
				setState(43);
				match(T__11);
				setState(44);
				expr(0);
				setState(45);
				match(T__12);
				setState(46);
				expr(4);
				}
				break;
			case 10:
				{
				setState(48);
				match(T__13);
				setState(49);
				match(T__5);
				setState(50);
				expr(0);
				setState(51);
				match(T__6);
				}
				break;
			case 11:
				{
				setState(53);
				match(T__14);
				setState(54);
				match(ID);
				setState(57);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__15) {
					{
					setState(55);
					match(T__15);
					setState(56);
					typ(0);
					}
				}

				setState(59);
				match(T__3);
				setState(60);
				expr(0);
				setState(61);
				expr(2);
				}
				break;
			case 12:
				{
				setState(63);
				match(T__5);
				setState(64);
				expr(0);
				setState(65);
				match(T__6);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(79);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(77);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
					case 1:
						{
						_localctx = new ExprContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(69);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(70);
						match(T__2);
						setState(71);
						expr(9);
						}
						break;
					case 2:
						{
						_localctx = new ExprContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(72);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(73);
						match(T__5);
						setState(74);
						expr(0);
						setState(75);
						match(T__6);
						}
						break;
					}
					} 
				}
				setState(81);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
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

	public static class TypContext extends ParserRuleContext {
		public List<TerminalNode> ID() { return getTokens(SlimParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(SlimParser.ID, i);
		}
		public List<TypContext> typ() {
			return getRuleContexts(TypContext.class);
		}
		public TypContext typ(int i) {
			return getRuleContext(TypContext.class,i);
		}
		public TypContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typ; }
	}

	public final TypContext typ() throws RecognitionException {
		return typ(0);
	}

	private TypContext typ(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		TypContext _localctx = new TypContext(_ctx, _parentState);
		TypContext _prevctx = _localctx;
		int _startState = 2;
		enterRecursionRule(_localctx, 2, RULE_typ, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(128);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				{
				}
				break;
			case 2:
				{
				setState(83);
				match(T__16);
				}
				break;
			case 3:
				{
				setState(84);
				match(T__17);
				}
				break;
			case 4:
				{
				setState(85);
				match(T__18);
				}
				break;
			case 5:
				{
				setState(86);
				match(ID);
				setState(87);
				match(T__19);
				setState(88);
				typ(9);
				}
				break;
			case 6:
				{
				setState(89);
				match(ID);
				setState(90);
				match(T__15);
				setState(91);
				typ(8);
				}
				break;
			case 7:
				{
				setState(92);
				match(T__24);
				setState(93);
				match(ID);
				setState(96);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__25) {
					{
					setState(94);
					match(T__25);
					setState(95);
					typ(0);
					}
				}

				setState(105);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__26) {
					{
					{
					setState(98);
					match(T__26);
					setState(99);
					typ(0);
					setState(100);
					match(T__25);
					setState(101);
					typ(0);
					}
					}
					setState(107);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(114);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__27) {
					{
					setState(108);
					match(T__27);
					setState(110); 
					_errHandler.sync(this);
					_la = _input.LA(1);
					do {
						{
						{
						setState(109);
						match(ID);
						}
						}
						setState(112); 
						_errHandler.sync(this);
						_la = _input.LA(1);
					} while ( _la==ID );
					}
				}

				setState(116);
				match(T__28);
				}
				break;
			case 8:
				{
				setState(117);
				match(T__29);
				setState(118);
				match(ID);
				setState(121);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__25) {
					{
					setState(119);
					match(T__25);
					setState(120);
					typ(0);
					}
				}

				setState(123);
				match(T__30);
				setState(124);
				typ(2);
				}
				break;
			case 9:
				{
				setState(125);
				match(ID);
				setState(126);
				match(T__31);
				setState(127);
				typ(1);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(144);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,14,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(142);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
					case 1:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(130);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(131);
						match(T__20);
						setState(132);
						typ(8);
						}
						break;
					case 2:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(133);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(134);
						match(T__21);
						setState(135);
						typ(7);
						}
						break;
					case 3:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(136);
						if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
						setState(137);
						match(T__22);
						setState(138);
						typ(6);
						}
						break;
					case 4:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(139);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(140);
						match(T__23);
						setState(141);
						typ(5);
						}
						break;
					}
					} 
				}
				setState(146);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,14,_ctx);
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
		case 1:
			return typ_sempred((TypContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 8);
		case 1:
			return precpred(_ctx, 7);
		}
		return true;
	}
	private boolean typ_sempred(TypContext _localctx, int predIndex) {
		switch (predIndex) {
		case 2:
			return precpred(_ctx, 7);
		case 3:
			return precpred(_ctx, 6);
		case 4:
			return precpred(_ctx, 5);
		case 5:
			return precpred(_ctx, 4);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3%\u0096\4\2\t\2\4"+
		"\3\t\3\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2\21\n\2\r\2\16\2\22"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2\37\n\2\r\2\16\2 \3\2\3\2"+
		"\3\2\3\2\3\2\6\2(\n\2\r\2\16\2)\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3"+
		"\2\3\2\3\2\3\2\3\2\3\2\3\2\5\2<\n\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\5"+
		"\2F\n\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\7\2P\n\2\f\2\16\2S\13\2\3\3\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3c\n\3\3\3\3\3\3"+
		"\3\3\3\3\3\7\3j\n\3\f\3\16\3m\13\3\3\3\3\3\6\3q\n\3\r\3\16\3r\5\3u\n\3"+
		"\3\3\3\3\3\3\3\3\3\3\5\3|\n\3\3\3\3\3\3\3\3\3\3\3\5\3\u0083\n\3\3\3\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\7\3\u0091\n\3\f\3\16\3\u0094"+
		"\13\3\3\3\2\4\2\4\4\2\4\2\2\2\u00b5\2E\3\2\2\2\4\u0082\3\2\2\2\6F\b\2"+
		"\1\2\7F\7#\2\2\bF\7\3\2\2\t\n\7\4\2\2\n\13\7#\2\2\13F\5\2\2\r\f\r\7\5"+
		"\2\2\r\16\7#\2\2\16\17\7\6\2\2\17\21\5\2\2\2\20\f\3\2\2\2\21\22\3\2\2"+
		"\2\22\20\3\2\2\2\22\23\3\2\2\2\23F\3\2\2\2\24\25\7#\2\2\25\26\7\7\2\2"+
		"\26F\5\2\2\13\27\30\7\n\2\2\30\36\5\2\2\2\31\32\7\13\2\2\32\33\5\2\2\2"+
		"\33\34\7\7\2\2\34\35\5\2\2\2\35\37\3\2\2\2\36\31\3\2\2\2\37 \3\2\2\2 "+
		"\36\3\2\2\2 !\3\2\2\2!F\3\2\2\2\"#\7\f\2\2#$\5\2\2\2$%\7\7\2\2%&\5\2\2"+
		"\2&(\3\2\2\2\'\"\3\2\2\2()\3\2\2\2)\'\3\2\2\2)*\3\2\2\2*F\3\2\2\2+,\7"+
		"\r\2\2,-\5\2\2\2-.\7\16\2\2./\5\2\2\2/\60\7\17\2\2\60\61\5\2\2\6\61F\3"+
		"\2\2\2\62\63\7\20\2\2\63\64\7\b\2\2\64\65\5\2\2\2\65\66\7\t\2\2\66F\3"+
		"\2\2\2\678\7\21\2\28;\7#\2\29:\7\22\2\2:<\5\4\3\2;9\3\2\2\2;<\3\2\2\2"+
		"<=\3\2\2\2=>\7\6\2\2>?\5\2\2\2?@\5\2\2\4@F\3\2\2\2AB\7\b\2\2BC\5\2\2\2"+
		"CD\7\t\2\2DF\3\2\2\2E\6\3\2\2\2E\7\3\2\2\2E\b\3\2\2\2E\t\3\2\2\2E\20\3"+
		"\2\2\2E\24\3\2\2\2E\27\3\2\2\2E\'\3\2\2\2E+\3\2\2\2E\62\3\2\2\2E\67\3"+
		"\2\2\2EA\3\2\2\2FQ\3\2\2\2GH\f\n\2\2HI\7\5\2\2IP\5\2\2\13JK\f\t\2\2KL"+
		"\7\b\2\2LM\5\2\2\2MN\7\t\2\2NP\3\2\2\2OG\3\2\2\2OJ\3\2\2\2PS\3\2\2\2Q"+
		"O\3\2\2\2QR\3\2\2\2R\3\3\2\2\2SQ\3\2\2\2T\u0083\b\3\1\2U\u0083\7\23\2"+
		"\2V\u0083\7\24\2\2W\u0083\7\25\2\2XY\7#\2\2YZ\7\26\2\2Z\u0083\5\4\3\13"+
		"[\\\7#\2\2\\]\7\22\2\2]\u0083\5\4\3\n^_\7\33\2\2_b\7#\2\2`a\7\34\2\2a"+
		"c\5\4\3\2b`\3\2\2\2bc\3\2\2\2ck\3\2\2\2de\7\35\2\2ef\5\4\3\2fg\7\34\2"+
		"\2gh\5\4\3\2hj\3\2\2\2id\3\2\2\2jm\3\2\2\2ki\3\2\2\2kl\3\2\2\2lt\3\2\2"+
		"\2mk\3\2\2\2np\7\36\2\2oq\7#\2\2po\3\2\2\2qr\3\2\2\2rp\3\2\2\2rs\3\2\2"+
		"\2su\3\2\2\2tn\3\2\2\2tu\3\2\2\2uv\3\2\2\2v\u0083\7\37\2\2wx\7 \2\2x{"+
		"\7#\2\2yz\7\34\2\2z|\5\4\3\2{y\3\2\2\2{|\3\2\2\2|}\3\2\2\2}~\7!\2\2~\u0083"+
		"\5\4\3\4\177\u0080\7#\2\2\u0080\u0081\7\"\2\2\u0081\u0083\5\4\3\3\u0082"+
		"T\3\2\2\2\u0082U\3\2\2\2\u0082V\3\2\2\2\u0082W\3\2\2\2\u0082X\3\2\2\2"+
		"\u0082[\3\2\2\2\u0082^\3\2\2\2\u0082w\3\2\2\2\u0082\177\3\2\2\2\u0083"+
		"\u0092\3\2\2\2\u0084\u0085\f\t\2\2\u0085\u0086\7\27\2\2\u0086\u0091\5"+
		"\4\3\n\u0087\u0088\f\b\2\2\u0088\u0089\7\30\2\2\u0089\u0091\5\4\3\t\u008a"+
		"\u008b\f\7\2\2\u008b\u008c\7\31\2\2\u008c\u0091\5\4\3\b\u008d\u008e\f"+
		"\6\2\2\u008e\u008f\7\32\2\2\u008f\u0091\5\4\3\7\u0090\u0084\3\2\2\2\u0090"+
		"\u0087\3\2\2\2\u0090\u008a\3\2\2\2\u0090\u008d\3\2\2\2\u0091\u0094\3\2"+
		"\2\2\u0092\u0090\3\2\2\2\u0092\u0093\3\2\2\2\u0093\5\3\2\2\2\u0094\u0092"+
		"\3\2\2\2\21\22 );EOQbkrt{\u0082\u0090\u0092";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}