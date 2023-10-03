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
		ID=10, INT=11, WS=12;
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
			null, "'()'", "'fun'", "'=>'", "'if'", "'then'", "'else'", "'fix'", "'('", 
			"')'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, "ID", "INT", 
			"WS"
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
		public TerminalNode ID() { return getToken(SlimParser.ID, 0); }
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
		ExprContext _localctx = new ExprContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_expr);
		try {
			int _alt;
			setState(37);
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
				setState(3);
				match(ID);

				        _localctx.result = f'(id)'
				    
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(5);
				match(T__0);

				        _localctx.result = f'(unit)'
				    
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(12); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(7);
						match(T__1);
						setState(8);
						((ExprContext)_localctx).param = expr();
						setState(9);
						match(T__2);
						setState(10);
						((ExprContext)_localctx).body = expr();
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(14); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,0,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );

				        prefix = '['
				        content = ''.join([
				            '(fun ' + p + ' ' + b + ')'  
				            for p, b in zip(((ExprContext)_localctx).param.result, ((ExprContext)_localctx).body.result)
				        ])
				        suffix = ']'
				        _localctx.result = prefix + content + suffix
				    
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(18);
				match(T__3);
				setState(19);
				((ExprContext)_localctx).cond = expr();
				setState(20);
				match(T__4);
				setState(21);
				((ExprContext)_localctx).t = expr();
				setState(22);
				match(T__5);
				setState(23);
				((ExprContext)_localctx).f = expr();

				        _localctx.result = f'(ite {((ExprContext)_localctx).cond.result} {((ExprContext)_localctx).t.result} {((ExprContext)_localctx).f.result})'
				    
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(26);
				match(T__6);
				setState(27);
				match(T__7);
				setState(28);
				((ExprContext)_localctx).body = expr();
				setState(29);
				match(T__8);

				        _localctx.result = f'(fix {((ExprContext)_localctx).body.result})'
				    
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(32);
				match(T__7);
				setState(33);
				((ExprContext)_localctx).body = expr();
				setState(34);
				match(T__8);

				        _localctx.result = f'(paren {((ExprContext)_localctx).body.result})' 
				    
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\16*\4\2\t\2\3\2\3"+
		"\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\6\2\17\n\2\r\2\16\2\20\3\2\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3"+
		"\2\5\2(\n\2\3\2\2\2\3\2\2\2\2/\2\'\3\2\2\2\4(\3\2\2\2\5\6\7\f\2\2\6(\b"+
		"\2\1\2\7\b\7\3\2\2\b(\b\2\1\2\t\n\7\4\2\2\n\13\5\2\2\2\13\f\7\5\2\2\f"+
		"\r\5\2\2\2\r\17\3\2\2\2\16\t\3\2\2\2\17\20\3\2\2\2\20\16\3\2\2\2\20\21"+
		"\3\2\2\2\21\22\3\2\2\2\22\23\b\2\1\2\23(\3\2\2\2\24\25\7\6\2\2\25\26\5"+
		"\2\2\2\26\27\7\7\2\2\27\30\5\2\2\2\30\31\7\b\2\2\31\32\5\2\2\2\32\33\b"+
		"\2\1\2\33(\3\2\2\2\34\35\7\t\2\2\35\36\7\n\2\2\36\37\5\2\2\2\37 \7\13"+
		"\2\2 !\b\2\1\2!(\3\2\2\2\"#\7\n\2\2#$\5\2\2\2$%\7\13\2\2%&\b\2\1\2&(\3"+
		"\2\2\2\'\4\3\2\2\2\'\5\3\2\2\2\'\7\3\2\2\2\'\16\3\2\2\2\'\24\3\2\2\2\'"+
		"\34\3\2\2\2\'\"\3\2\2\2(\3\3\2\2\2\4\20\'";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}