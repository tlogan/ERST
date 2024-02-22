// Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.1

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 


import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link SlimParser}.
 */
public interface SlimListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link SlimParser#ids}.
	 * @param ctx the parse tree
	 */
	void enterIds(SlimParser.IdsContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#ids}.
	 * @param ctx the parse tree
	 */
	void exitIds(SlimParser.IdsContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#typ_base}.
	 * @param ctx the parse tree
	 */
	void enterTyp_base(SlimParser.Typ_baseContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#typ_base}.
	 * @param ctx the parse tree
	 */
	void exitTyp_base(SlimParser.Typ_baseContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#typ}.
	 * @param ctx the parse tree
	 */
	void enterTyp(SlimParser.TypContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#typ}.
	 * @param ctx the parse tree
	 */
	void exitTyp(SlimParser.TypContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#negchain}.
	 * @param ctx the parse tree
	 */
	void enterNegchain(SlimParser.NegchainContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#negchain}.
	 * @param ctx the parse tree
	 */
	void exitNegchain(SlimParser.NegchainContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#qualification}.
	 * @param ctx the parse tree
	 */
	void enterQualification(SlimParser.QualificationContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#qualification}.
	 * @param ctx the parse tree
	 */
	void exitQualification(SlimParser.QualificationContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#subtyping}.
	 * @param ctx the parse tree
	 */
	void enterSubtyping(SlimParser.SubtypingContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#subtyping}.
	 * @param ctx the parse tree
	 */
	void exitSubtyping(SlimParser.SubtypingContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExpr(SlimParser.ExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExpr(SlimParser.ExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#base}.
	 * @param ctx the parse tree
	 */
	void enterBase(SlimParser.BaseContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#base}.
	 * @param ctx the parse tree
	 */
	void exitBase(SlimParser.BaseContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#function}.
	 * @param ctx the parse tree
	 */
	void enterFunction(SlimParser.FunctionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#function}.
	 * @param ctx the parse tree
	 */
	void exitFunction(SlimParser.FunctionContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#record}.
	 * @param ctx the parse tree
	 */
	void enterRecord(SlimParser.RecordContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#record}.
	 * @param ctx the parse tree
	 */
	void exitRecord(SlimParser.RecordContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#argchain}.
	 * @param ctx the parse tree
	 */
	void enterArgchain(SlimParser.ArgchainContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#argchain}.
	 * @param ctx the parse tree
	 */
	void exitArgchain(SlimParser.ArgchainContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#pipeline}.
	 * @param ctx the parse tree
	 */
	void enterPipeline(SlimParser.PipelineContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#pipeline}.
	 * @param ctx the parse tree
	 */
	void exitPipeline(SlimParser.PipelineContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#keychain}.
	 * @param ctx the parse tree
	 */
	void enterKeychain(SlimParser.KeychainContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#keychain}.
	 * @param ctx the parse tree
	 */
	void exitKeychain(SlimParser.KeychainContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#target}.
	 * @param ctx the parse tree
	 */
	void enterTarget(SlimParser.TargetContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#target}.
	 * @param ctx the parse tree
	 */
	void exitTarget(SlimParser.TargetContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#pattern}.
	 * @param ctx the parse tree
	 */
	void enterPattern(SlimParser.PatternContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#pattern}.
	 * @param ctx the parse tree
	 */
	void exitPattern(SlimParser.PatternContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#pattern_base}.
	 * @param ctx the parse tree
	 */
	void enterPattern_base(SlimParser.Pattern_baseContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#pattern_base}.
	 * @param ctx the parse tree
	 */
	void exitPattern_base(SlimParser.Pattern_baseContext ctx);
	/**
	 * Enter a parse tree produced by {@link SlimParser#pattern_record}.
	 * @param ctx the parse tree
	 */
	void enterPattern_record(SlimParser.Pattern_recordContext ctx);
	/**
	 * Exit a parse tree produced by {@link SlimParser#pattern_record}.
	 * @param ctx the parse tree
	 */
	void exitPattern_record(SlimParser.Pattern_recordContext ctx);
}