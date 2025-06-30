// Generated from /Users/thomas/tlogan@github.com/ERST/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset


import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue", "this-escape"})
public class SlimLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.13.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, ID=35, INT=36, WS=37;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
			"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
			"T__17", "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", "T__24", 
			"T__25", "T__26", "T__27", "T__28", "T__29", "T__30", "T__31", "T__32", 
			"T__33", "ID", "INT", "WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'alias'", "'='", "'TOP'", "'BOT'", "'@'", "'<'", "'>'", "'('", 
			"')'", "'|'", "'&'", "'->'", "'*'", "'EXI'", "'['", "']'", "'ALL'", "'LFP'", 
			"'\\'", "':'", "'<:'", "','", "'if'", "'then'", "'else'", "'let'", "'in'", 
			"'loop'", "';'", "'{'", "'=>'", "'}'", "'.'", "'|>'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
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


	public SlimLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Slim.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\u0004\u0000%\u00c1\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002\u0001"+
		"\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004"+
		"\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007"+
		"\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b"+
		"\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0002"+
		"\u000f\u0007\u000f\u0002\u0010\u0007\u0010\u0002\u0011\u0007\u0011\u0002"+
		"\u0012\u0007\u0012\u0002\u0013\u0007\u0013\u0002\u0014\u0007\u0014\u0002"+
		"\u0015\u0007\u0015\u0002\u0016\u0007\u0016\u0002\u0017\u0007\u0017\u0002"+
		"\u0018\u0007\u0018\u0002\u0019\u0007\u0019\u0002\u001a\u0007\u001a\u0002"+
		"\u001b\u0007\u001b\u0002\u001c\u0007\u001c\u0002\u001d\u0007\u001d\u0002"+
		"\u001e\u0007\u001e\u0002\u001f\u0007\u001f\u0002 \u0007 \u0002!\u0007"+
		"!\u0002\"\u0007\"\u0002#\u0007#\u0002$\u0007$\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0001\u0001\u0001"+
		"\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001\u0005\u0001\u0005"+
		"\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007\u0001\b\u0001\b\u0001"+
		"\t\u0001\t\u0001\n\u0001\n\u0001\u000b\u0001\u000b\u0001\u000b\u0001\f"+
		"\u0001\f\u0001\r\u0001\r\u0001\r\u0001\r\u0001\u000e\u0001\u000e\u0001"+
		"\u000f\u0001\u000f\u0001\u0010\u0001\u0010\u0001\u0010\u0001\u0010\u0001"+
		"\u0011\u0001\u0011\u0001\u0011\u0001\u0011\u0001\u0012\u0001\u0012\u0001"+
		"\u0013\u0001\u0013\u0001\u0014\u0001\u0014\u0001\u0014\u0001\u0015\u0001"+
		"\u0015\u0001\u0016\u0001\u0016\u0001\u0016\u0001\u0017\u0001\u0017\u0001"+
		"\u0017\u0001\u0017\u0001\u0017\u0001\u0018\u0001\u0018\u0001\u0018\u0001"+
		"\u0018\u0001\u0018\u0001\u0019\u0001\u0019\u0001\u0019\u0001\u0019\u0001"+
		"\u001a\u0001\u001a\u0001\u001a\u0001\u001b\u0001\u001b\u0001\u001b\u0001"+
		"\u001b\u0001\u001b\u0001\u001c\u0001\u001c\u0001\u001d\u0001\u001d\u0001"+
		"\u001e\u0001\u001e\u0001\u001e\u0001\u001f\u0001\u001f\u0001 \u0001 \u0001"+
		"!\u0001!\u0001!\u0001\"\u0001\"\u0005\"\u00b1\b\"\n\"\f\"\u00b4\t\"\u0001"+
		"#\u0004#\u00b7\b#\u000b#\f#\u00b8\u0001$\u0004$\u00bc\b$\u000b$\f$\u00bd"+
		"\u0001$\u0001$\u0000\u0000%\u0001\u0001\u0003\u0002\u0005\u0003\u0007"+
		"\u0004\t\u0005\u000b\u0006\r\u0007\u000f\b\u0011\t\u0013\n\u0015\u000b"+
		"\u0017\f\u0019\r\u001b\u000e\u001d\u000f\u001f\u0010!\u0011#\u0012%\u0013"+
		"\'\u0014)\u0015+\u0016-\u0017/\u00181\u00193\u001a5\u001b7\u001c9\u001d"+
		";\u001e=\u001f? A!C\"E#G$I%\u0001\u0000\u0004\u0002\u0000AZaz\u0004\u0000"+
		"09AZ__az\u0001\u000009\u0003\u0000\t\n\r\r  \u00c3\u0000\u0001\u0001\u0000"+
		"\u0000\u0000\u0000\u0003\u0001\u0000\u0000\u0000\u0000\u0005\u0001\u0000"+
		"\u0000\u0000\u0000\u0007\u0001\u0000\u0000\u0000\u0000\t\u0001\u0000\u0000"+
		"\u0000\u0000\u000b\u0001\u0000\u0000\u0000\u0000\r\u0001\u0000\u0000\u0000"+
		"\u0000\u000f\u0001\u0000\u0000\u0000\u0000\u0011\u0001\u0000\u0000\u0000"+
		"\u0000\u0013\u0001\u0000\u0000\u0000\u0000\u0015\u0001\u0000\u0000\u0000"+
		"\u0000\u0017\u0001\u0000\u0000\u0000\u0000\u0019\u0001\u0000\u0000\u0000"+
		"\u0000\u001b\u0001\u0000\u0000\u0000\u0000\u001d\u0001\u0000\u0000\u0000"+
		"\u0000\u001f\u0001\u0000\u0000\u0000\u0000!\u0001\u0000\u0000\u0000\u0000"+
		"#\u0001\u0000\u0000\u0000\u0000%\u0001\u0000\u0000\u0000\u0000\'\u0001"+
		"\u0000\u0000\u0000\u0000)\u0001\u0000\u0000\u0000\u0000+\u0001\u0000\u0000"+
		"\u0000\u0000-\u0001\u0000\u0000\u0000\u0000/\u0001\u0000\u0000\u0000\u0000"+
		"1\u0001\u0000\u0000\u0000\u00003\u0001\u0000\u0000\u0000\u00005\u0001"+
		"\u0000\u0000\u0000\u00007\u0001\u0000\u0000\u0000\u00009\u0001\u0000\u0000"+
		"\u0000\u0000;\u0001\u0000\u0000\u0000\u0000=\u0001\u0000\u0000\u0000\u0000"+
		"?\u0001\u0000\u0000\u0000\u0000A\u0001\u0000\u0000\u0000\u0000C\u0001"+
		"\u0000\u0000\u0000\u0000E\u0001\u0000\u0000\u0000\u0000G\u0001\u0000\u0000"+
		"\u0000\u0000I\u0001\u0000\u0000\u0000\u0001K\u0001\u0000\u0000\u0000\u0003"+
		"Q\u0001\u0000\u0000\u0000\u0005S\u0001\u0000\u0000\u0000\u0007W\u0001"+
		"\u0000\u0000\u0000\t[\u0001\u0000\u0000\u0000\u000b]\u0001\u0000\u0000"+
		"\u0000\r_\u0001\u0000\u0000\u0000\u000fa\u0001\u0000\u0000\u0000\u0011"+
		"c\u0001\u0000\u0000\u0000\u0013e\u0001\u0000\u0000\u0000\u0015g\u0001"+
		"\u0000\u0000\u0000\u0017i\u0001\u0000\u0000\u0000\u0019l\u0001\u0000\u0000"+
		"\u0000\u001bn\u0001\u0000\u0000\u0000\u001dr\u0001\u0000\u0000\u0000\u001f"+
		"t\u0001\u0000\u0000\u0000!v\u0001\u0000\u0000\u0000#z\u0001\u0000\u0000"+
		"\u0000%~\u0001\u0000\u0000\u0000\'\u0080\u0001\u0000\u0000\u0000)\u0082"+
		"\u0001\u0000\u0000\u0000+\u0085\u0001\u0000\u0000\u0000-\u0087\u0001\u0000"+
		"\u0000\u0000/\u008a\u0001\u0000\u0000\u00001\u008f\u0001\u0000\u0000\u0000"+
		"3\u0094\u0001\u0000\u0000\u00005\u0098\u0001\u0000\u0000\u00007\u009b"+
		"\u0001\u0000\u0000\u00009\u00a0\u0001\u0000\u0000\u0000;\u00a2\u0001\u0000"+
		"\u0000\u0000=\u00a4\u0001\u0000\u0000\u0000?\u00a7\u0001\u0000\u0000\u0000"+
		"A\u00a9\u0001\u0000\u0000\u0000C\u00ab\u0001\u0000\u0000\u0000E\u00ae"+
		"\u0001\u0000\u0000\u0000G\u00b6\u0001\u0000\u0000\u0000I\u00bb\u0001\u0000"+
		"\u0000\u0000KL\u0005a\u0000\u0000LM\u0005l\u0000\u0000MN\u0005i\u0000"+
		"\u0000NO\u0005a\u0000\u0000OP\u0005s\u0000\u0000P\u0002\u0001\u0000\u0000"+
		"\u0000QR\u0005=\u0000\u0000R\u0004\u0001\u0000\u0000\u0000ST\u0005T\u0000"+
		"\u0000TU\u0005O\u0000\u0000UV\u0005P\u0000\u0000V\u0006\u0001\u0000\u0000"+
		"\u0000WX\u0005B\u0000\u0000XY\u0005O\u0000\u0000YZ\u0005T\u0000\u0000"+
		"Z\b\u0001\u0000\u0000\u0000[\\\u0005@\u0000\u0000\\\n\u0001\u0000\u0000"+
		"\u0000]^\u0005<\u0000\u0000^\f\u0001\u0000\u0000\u0000_`\u0005>\u0000"+
		"\u0000`\u000e\u0001\u0000\u0000\u0000ab\u0005(\u0000\u0000b\u0010\u0001"+
		"\u0000\u0000\u0000cd\u0005)\u0000\u0000d\u0012\u0001\u0000\u0000\u0000"+
		"ef\u0005|\u0000\u0000f\u0014\u0001\u0000\u0000\u0000gh\u0005&\u0000\u0000"+
		"h\u0016\u0001\u0000\u0000\u0000ij\u0005-\u0000\u0000jk\u0005>\u0000\u0000"+
		"k\u0018\u0001\u0000\u0000\u0000lm\u0005*\u0000\u0000m\u001a\u0001\u0000"+
		"\u0000\u0000no\u0005E\u0000\u0000op\u0005X\u0000\u0000pq\u0005I\u0000"+
		"\u0000q\u001c\u0001\u0000\u0000\u0000rs\u0005[\u0000\u0000s\u001e\u0001"+
		"\u0000\u0000\u0000tu\u0005]\u0000\u0000u \u0001\u0000\u0000\u0000vw\u0005"+
		"A\u0000\u0000wx\u0005L\u0000\u0000xy\u0005L\u0000\u0000y\"\u0001\u0000"+
		"\u0000\u0000z{\u0005L\u0000\u0000{|\u0005F\u0000\u0000|}\u0005P\u0000"+
		"\u0000}$\u0001\u0000\u0000\u0000~\u007f\u0005\\\u0000\u0000\u007f&\u0001"+
		"\u0000\u0000\u0000\u0080\u0081\u0005:\u0000\u0000\u0081(\u0001\u0000\u0000"+
		"\u0000\u0082\u0083\u0005<\u0000\u0000\u0083\u0084\u0005:\u0000\u0000\u0084"+
		"*\u0001\u0000\u0000\u0000\u0085\u0086\u0005,\u0000\u0000\u0086,\u0001"+
		"\u0000\u0000\u0000\u0087\u0088\u0005i\u0000\u0000\u0088\u0089\u0005f\u0000"+
		"\u0000\u0089.\u0001\u0000\u0000\u0000\u008a\u008b\u0005t\u0000\u0000\u008b"+
		"\u008c\u0005h\u0000\u0000\u008c\u008d\u0005e\u0000\u0000\u008d\u008e\u0005"+
		"n\u0000\u0000\u008e0\u0001\u0000\u0000\u0000\u008f\u0090\u0005e\u0000"+
		"\u0000\u0090\u0091\u0005l\u0000\u0000\u0091\u0092\u0005s\u0000\u0000\u0092"+
		"\u0093\u0005e\u0000\u0000\u00932\u0001\u0000\u0000\u0000\u0094\u0095\u0005"+
		"l\u0000\u0000\u0095\u0096\u0005e\u0000\u0000\u0096\u0097\u0005t\u0000"+
		"\u0000\u00974\u0001\u0000\u0000\u0000\u0098\u0099\u0005i\u0000\u0000\u0099"+
		"\u009a\u0005n\u0000\u0000\u009a6\u0001\u0000\u0000\u0000\u009b\u009c\u0005"+
		"l\u0000\u0000\u009c\u009d\u0005o\u0000\u0000\u009d\u009e\u0005o\u0000"+
		"\u0000\u009e\u009f\u0005p\u0000\u0000\u009f8\u0001\u0000\u0000\u0000\u00a0"+
		"\u00a1\u0005;\u0000\u0000\u00a1:\u0001\u0000\u0000\u0000\u00a2\u00a3\u0005"+
		"{\u0000\u0000\u00a3<\u0001\u0000\u0000\u0000\u00a4\u00a5\u0005=\u0000"+
		"\u0000\u00a5\u00a6\u0005>\u0000\u0000\u00a6>\u0001\u0000\u0000\u0000\u00a7"+
		"\u00a8\u0005}\u0000\u0000\u00a8@\u0001\u0000\u0000\u0000\u00a9\u00aa\u0005"+
		".\u0000\u0000\u00aaB\u0001\u0000\u0000\u0000\u00ab\u00ac\u0005|\u0000"+
		"\u0000\u00ac\u00ad\u0005>\u0000\u0000\u00adD\u0001\u0000\u0000\u0000\u00ae"+
		"\u00b2\u0007\u0000\u0000\u0000\u00af\u00b1\u0007\u0001\u0000\u0000\u00b0"+
		"\u00af\u0001\u0000\u0000\u0000\u00b1\u00b4\u0001\u0000\u0000\u0000\u00b2"+
		"\u00b0\u0001\u0000\u0000\u0000\u00b2\u00b3\u0001\u0000\u0000\u0000\u00b3"+
		"F\u0001\u0000\u0000\u0000\u00b4\u00b2\u0001\u0000\u0000\u0000\u00b5\u00b7"+
		"\u0007\u0002\u0000\u0000\u00b6\u00b5\u0001\u0000\u0000\u0000\u00b7\u00b8"+
		"\u0001\u0000\u0000\u0000\u00b8\u00b6\u0001\u0000\u0000\u0000\u00b8\u00b9"+
		"\u0001\u0000\u0000\u0000\u00b9H\u0001\u0000\u0000\u0000\u00ba\u00bc\u0007"+
		"\u0003\u0000\u0000\u00bb\u00ba\u0001\u0000\u0000\u0000\u00bc\u00bd\u0001"+
		"\u0000\u0000\u0000\u00bd\u00bb\u0001\u0000\u0000\u0000\u00bd\u00be\u0001"+
		"\u0000\u0000\u0000\u00be\u00bf\u0001\u0000\u0000\u0000\u00bf\u00c0\u0006"+
		"$\u0000\u0000\u00c0J\u0001\u0000\u0000\u0000\u0004\u0000\u00b2\u00b8\u00bd"+
		"\u0001\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}