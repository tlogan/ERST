// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.9.2

from asyncio import Queue

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




	@property
	def output(self):
	    return self._output

	@output.setter
	def output(self, value : Queue):
	    self._output = value


	public SlimParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

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
			setState(45);
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
				self.output.put_nowait(_localctx.result);

				}
				break;
			case 3:
				{
				setState(7);
				match(T__0);

				((ExprContext)_localctx).result =  f'(unit)'
				self.output.put_nowait(_localctx.result);

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

				((ExprContext)_localctx).result =  f'(tag {(((ExprContext)_localctx).ID!=null?((ExprContext)_localctx).ID.getText():null)} {((ExprContext)_localctx).expr.result})'
				self.output.put_nowait(_localctx.result);

				}
				break;
			case 5:
				{
				setState(14);
				((ExprContext)_localctx).record = record();

				((ExprContext)_localctx).result =  ((ExprContext)_localctx).record.result
				self.output.put_nowait(_localctx.result);

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
				setState(37);
				match(T__3);
				setState(38);
				((ExprContext)_localctx).body = ((ExprContext)_localctx).expr = expr(0);
				setState(39);
				match(T__4);
				}
				break;
			case 10:
				{
				setState(41);
				match(T__3);
				setState(42);
				((ExprContext)_localctx).body = ((ExprContext)_localctx).expr = expr(0);
				setState(43);
				match(T__4);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(54);
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
					setState(47);
					if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
					setState(48);
					match(T__3);
					setState(49);
					((ExprContext)_localctx).expr = expr(0);
					setState(50);
					match(T__4);
					}
					} 
				}
				setState(56);
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
			setState(71);
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
				setState(58);
				match(T__10);
				setState(59);
				((RecordContext)_localctx).ID = match(ID);
				setState(60);
				match(T__11);
				setState(61);
				((RecordContext)_localctx).expr = expr(0);

				_localctx.result = f'(field {(((RecordContext)_localctx).ID!=null?((RecordContext)_localctx).ID.getText():null)} {((RecordContext)_localctx).expr.result})'

				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(64);
				match(T__10);
				setState(65);
				((RecordContext)_localctx).ID = match(ID);
				setState(66);
				match(T__11);
				setState(67);
				((RecordContext)_localctx).expr = expr(0);
				setState(68);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\21L\4\2\t\2\4\3\t"+
		"\3\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\6\2\34\n\2\r\2\16\2\35\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3"+
		"\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\5\2\60\n\2\3\2\3\2\3\2\3\2\3\2\7\2"+
		"\67\n\2\f\2\16\2:\13\2\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3"+
		"\3\3\3\3\5\3J\n\3\3\3\2\3\2\4\2\4\2\2\2V\2/\3\2\2\2\4I\3\2\2\2\6\60\b"+
		"\2\1\2\7\b\7\17\2\2\b\60\b\2\1\2\t\n\7\3\2\2\n\60\b\2\1\2\13\f\7\4\2\2"+
		"\f\r\7\17\2\2\r\16\5\2\2\n\16\17\b\2\1\2\17\60\3\2\2\2\20\21\5\4\3\2\21"+
		"\22\b\2\1\2\22\60\3\2\2\2\23\24\7\17\2\2\24\25\7\5\2\2\25\60\5\2\2\b\26"+
		"\27\7\b\2\2\27\30\5\2\2\2\30\31\7\5\2\2\31\32\5\2\2\2\32\34\3\2\2\2\33"+
		"\26\3\2\2\2\34\35\3\2\2\2\35\33\3\2\2\2\35\36\3\2\2\2\36\60\3\2\2\2\37"+
		" \7\t\2\2 !\5\2\2\2!\"\7\n\2\2\"#\5\2\2\2#$\7\13\2\2$%\5\2\2\5%\60\3\2"+
		"\2\2&\'\7\f\2\2\'(\7\6\2\2()\5\2\2\2)*\7\7\2\2*\60\3\2\2\2+,\7\6\2\2,"+
		"-\5\2\2\2-.\7\7\2\2.\60\3\2\2\2/\6\3\2\2\2/\7\3\2\2\2/\t\3\2\2\2/\13\3"+
		"\2\2\2/\20\3\2\2\2/\23\3\2\2\2/\33\3\2\2\2/\37\3\2\2\2/&\3\2\2\2/+\3\2"+
		"\2\2\608\3\2\2\2\61\62\f\7\2\2\62\63\7\6\2\2\63\64\5\2\2\2\64\65\7\7\2"+
		"\2\65\67\3\2\2\2\66\61\3\2\2\2\67:\3\2\2\28\66\3\2\2\289\3\2\2\29\3\3"+
		"\2\2\2:8\3\2\2\2;J\3\2\2\2<=\7\r\2\2=>\7\17\2\2>?\7\16\2\2?@\5\2\2\2@"+
		"A\b\3\1\2AJ\3\2\2\2BC\7\r\2\2CD\7\17\2\2DE\7\16\2\2EF\5\2\2\2FG\5\4\3"+
		"\2GH\b\3\1\2HJ\3\2\2\2I;\3\2\2\2I<\3\2\2\2IB\3\2\2\2J\5\3\2\2\2\6\35/"+
		"8I";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}