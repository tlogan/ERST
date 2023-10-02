// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Syntax.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class SyntaxParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		ID=32, INT=33, WS=34;
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
			null, "'.'", "';'", "'='", "':'", "'('", "')'", "'match'", "'case'", 
			"'fun'", "'if'", "'then'", "'else'", "'fix'", "'let'", "'in'", "'unit'", 
			"'top'", "'bot'", "'//'", "'&'", "'*'", "'|'", "'->'", "'{'", "'<:'", 
			"'with'", "'#'", "'}'", "'['", "']'", "'least'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
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
	public String getGrammarFileName() { return "Syntax.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public SyntaxParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class ExprContext extends ParserRuleContext {
		public List<TerminalNode> ID() { return getTokens(SyntaxParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(SyntaxParser.ID, i);
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
			setState(68);
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
				match(ID);
				setState(8);
				match(T__1);
				setState(9);
				expr(10);
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
						match(T__0);
						setState(11);
						match(ID);
						setState(12);
						match(T__2);
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
				match(T__3);
				setState(20);
				expr(8);
				}
				break;
			case 7:
				{
				setState(21);
				match(T__6);
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
						match(T__7);
						setState(24);
						expr(0);
						setState(25);
						match(T__3);
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
						match(T__8);
						setState(33);
						expr(0);
						setState(34);
						match(T__3);
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
				match(T__9);
				setState(42);
				expr(0);
				setState(43);
				match(T__10);
				setState(44);
				expr(0);
				setState(45);
				match(T__11);
				setState(46);
				expr(4);
				}
				break;
			case 10:
				{
				setState(48);
				match(T__12);
				setState(49);
				match(T__4);
				setState(50);
				expr(0);
				setState(51);
				match(T__5);
				}
				break;
			case 11:
				{
				setState(53);
				match(T__13);
				setState(54);
				match(ID);
				setState(57);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__14) {
					{
					setState(55);
					match(T__14);
					setState(56);
					typ(0);
					}
				}

				setState(59);
				match(T__2);
				setState(60);
				expr(0);
				setState(61);
				match(T__3);
				setState(62);
				expr(2);
				}
				break;
			case 12:
				{
				setState(64);
				match(T__4);
				setState(65);
				expr(0);
				setState(66);
				match(T__5);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(77);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new ExprContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_expr);
					setState(70);
					if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
					setState(71);
					match(T__4);
					setState(72);
					expr(0);
					setState(73);
					match(T__5);
					}
					} 
				}
				setState(79);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
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
		public List<TerminalNode> ID() { return getTokens(SyntaxParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(SyntaxParser.ID, i);
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
			setState(127);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				{
				}
				break;
			case 2:
				{
				setState(81);
				match(T__15);
				}
				break;
			case 3:
				{
				setState(82);
				match(T__16);
				}
				break;
			case 4:
				{
				setState(83);
				match(T__17);
				}
				break;
			case 5:
				{
				setState(84);
				match(ID);
				setState(85);
				match(T__18);
				setState(86);
				typ(9);
				}
				break;
			case 6:
				{
				setState(87);
				match(ID);
				setState(88);
				match(T__14);
				setState(89);
				typ(8);
				}
				break;
			case 7:
				{
				setState(90);
				match(T__23);
				setState(91);
				match(ID);
				setState(94);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__24) {
					{
					setState(92);
					match(T__24);
					setState(93);
					typ(0);
					}
				}

				setState(103);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__25) {
					{
					{
					setState(96);
					match(T__25);
					setState(97);
					typ(0);
					setState(98);
					match(T__24);
					setState(99);
					typ(0);
					}
					}
					setState(105);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(112);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__26) {
					{
					setState(106);
					match(T__26);
					setState(108); 
					_errHandler.sync(this);
					_la = _input.LA(1);
					do {
						{
						{
						setState(107);
						match(ID);
						}
						}
						setState(110); 
						_errHandler.sync(this);
						_la = _input.LA(1);
					} while ( _la==ID );
					}
				}

				setState(114);
				match(T__27);
				}
				break;
			case 8:
				{
				setState(115);
				match(T__28);
				setState(116);
				match(ID);
				setState(119);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__24) {
					{
					setState(117);
					match(T__24);
					setState(118);
					typ(0);
					}
				}

				setState(121);
				match(T__29);
				setState(122);
				typ(2);
				}
				break;
			case 9:
				{
				setState(123);
				match(T__30);
				setState(124);
				match(ID);
				setState(125);
				match(T__3);
				setState(126);
				typ(1);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(143);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(141);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
					case 1:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(129);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(130);
						match(T__19);
						setState(131);
						typ(8);
						}
						break;
					case 2:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(132);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(133);
						match(T__20);
						setState(134);
						typ(7);
						}
						break;
					case 3:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(135);
						if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
						setState(136);
						match(T__21);
						setState(137);
						typ(6);
						}
						break;
					case 4:
						{
						_localctx = new TypContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_typ);
						setState(138);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(139);
						match(T__22);
						setState(140);
						typ(5);
						}
						break;
					}
					} 
				}
				setState(145);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
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
			return precpred(_ctx, 7);
		}
		return true;
	}
	private boolean typ_sempred(TypContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return precpred(_ctx, 7);
		case 2:
			return precpred(_ctx, 6);
		case 3:
			return precpred(_ctx, 5);
		case 4:
			return precpred(_ctx, 4);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3$\u0095\4\2\t\2\4"+
		"\3\t\3\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2\21\n\2\r\2\16\2\22"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2\37\n\2\r\2\16\2 \3\2\3\2"+
		"\3\2\3\2\3\2\6\2(\n\2\r\2\16\2)\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3"+
		"\2\3\2\3\2\3\2\3\2\3\2\3\2\5\2<\n\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3"+
		"\2\5\2G\n\2\3\2\3\2\3\2\3\2\3\2\7\2N\n\2\f\2\16\2Q\13\2\3\3\3\3\3\3\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3a\n\3\3\3\3\3\3\3\3\3\3"+
		"\3\7\3h\n\3\f\3\16\3k\13\3\3\3\3\3\6\3o\n\3\r\3\16\3p\5\3s\n\3\3\3\3\3"+
		"\3\3\3\3\3\3\5\3z\n\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3\u0082\n\3\3\3\3\3\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\7\3\u0090\n\3\f\3\16\3\u0093\13"+
		"\3\3\3\2\4\2\4\4\2\4\2\2\2\u00b3\2F\3\2\2\2\4\u0081\3\2\2\2\6G\b\2\1\2"+
		"\7G\7\"\2\2\bG\7\3\2\2\t\n\7\"\2\2\n\13\7\4\2\2\13G\5\2\2\f\f\r\7\3\2"+
		"\2\r\16\7\"\2\2\16\17\7\5\2\2\17\21\5\2\2\2\20\f\3\2\2\2\21\22\3\2\2\2"+
		"\22\20\3\2\2\2\22\23\3\2\2\2\23G\3\2\2\2\24\25\7\"\2\2\25\26\7\6\2\2\26"+
		"G\5\2\2\n\27\30\7\t\2\2\30\36\5\2\2\2\31\32\7\n\2\2\32\33\5\2\2\2\33\34"+
		"\7\6\2\2\34\35\5\2\2\2\35\37\3\2\2\2\36\31\3\2\2\2\37 \3\2\2\2 \36\3\2"+
		"\2\2 !\3\2\2\2!G\3\2\2\2\"#\7\13\2\2#$\5\2\2\2$%\7\6\2\2%&\5\2\2\2&(\3"+
		"\2\2\2\'\"\3\2\2\2()\3\2\2\2)\'\3\2\2\2)*\3\2\2\2*G\3\2\2\2+,\7\f\2\2"+
		",-\5\2\2\2-.\7\r\2\2./\5\2\2\2/\60\7\16\2\2\60\61\5\2\2\6\61G\3\2\2\2"+
		"\62\63\7\17\2\2\63\64\7\7\2\2\64\65\5\2\2\2\65\66\7\b\2\2\66G\3\2\2\2"+
		"\678\7\20\2\28;\7\"\2\29:\7\21\2\2:<\5\4\3\2;9\3\2\2\2;<\3\2\2\2<=\3\2"+
		"\2\2=>\7\5\2\2>?\5\2\2\2?@\7\6\2\2@A\5\2\2\4AG\3\2\2\2BC\7\7\2\2CD\5\2"+
		"\2\2DE\7\b\2\2EG\3\2\2\2F\6\3\2\2\2F\7\3\2\2\2F\b\3\2\2\2F\t\3\2\2\2F"+
		"\20\3\2\2\2F\24\3\2\2\2F\27\3\2\2\2F\'\3\2\2\2F+\3\2\2\2F\62\3\2\2\2F"+
		"\67\3\2\2\2FB\3\2\2\2GO\3\2\2\2HI\f\t\2\2IJ\7\7\2\2JK\5\2\2\2KL\7\b\2"+
		"\2LN\3\2\2\2MH\3\2\2\2NQ\3\2\2\2OM\3\2\2\2OP\3\2\2\2P\3\3\2\2\2QO\3\2"+
		"\2\2R\u0082\b\3\1\2S\u0082\7\22\2\2T\u0082\7\23\2\2U\u0082\7\24\2\2VW"+
		"\7\"\2\2WX\7\25\2\2X\u0082\5\4\3\13YZ\7\"\2\2Z[\7\21\2\2[\u0082\5\4\3"+
		"\n\\]\7\32\2\2]`\7\"\2\2^_\7\33\2\2_a\5\4\3\2`^\3\2\2\2`a\3\2\2\2ai\3"+
		"\2\2\2bc\7\34\2\2cd\5\4\3\2de\7\33\2\2ef\5\4\3\2fh\3\2\2\2gb\3\2\2\2h"+
		"k\3\2\2\2ig\3\2\2\2ij\3\2\2\2jr\3\2\2\2ki\3\2\2\2ln\7\35\2\2mo\7\"\2\2"+
		"nm\3\2\2\2op\3\2\2\2pn\3\2\2\2pq\3\2\2\2qs\3\2\2\2rl\3\2\2\2rs\3\2\2\2"+
		"st\3\2\2\2t\u0082\7\36\2\2uv\7\37\2\2vy\7\"\2\2wx\7\33\2\2xz\5\4\3\2y"+
		"w\3\2\2\2yz\3\2\2\2z{\3\2\2\2{|\7 \2\2|\u0082\5\4\3\4}~\7!\2\2~\177\7"+
		"\"\2\2\177\u0080\7\6\2\2\u0080\u0082\5\4\3\3\u0081R\3\2\2\2\u0081S\3\2"+
		"\2\2\u0081T\3\2\2\2\u0081U\3\2\2\2\u0081V\3\2\2\2\u0081Y\3\2\2\2\u0081"+
		"\\\3\2\2\2\u0081u\3\2\2\2\u0081}\3\2\2\2\u0082\u0091\3\2\2\2\u0083\u0084"+
		"\f\t\2\2\u0084\u0085\7\26\2\2\u0085\u0090\5\4\3\n\u0086\u0087\f\b\2\2"+
		"\u0087\u0088\7\27\2\2\u0088\u0090\5\4\3\t\u0089\u008a\f\7\2\2\u008a\u008b"+
		"\7\30\2\2\u008b\u0090\5\4\3\b\u008c\u008d\f\6\2\2\u008d\u008e\7\31\2\2"+
		"\u008e\u0090\5\4\3\7\u008f\u0083\3\2\2\2\u008f\u0086\3\2\2\2\u008f\u0089"+
		"\3\2\2\2\u008f\u008c\3\2\2\2\u0090\u0093\3\2\2\2\u0091\u008f\3\2\2\2\u0091"+
		"\u0092\3\2\2\2\u0092\5\3\2\2\2\u0093\u0091\3\2\2\2\20\22 );FO`ipry\u0081"+
		"\u008f\u0091";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}