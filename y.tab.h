/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LETTER = 258,
    DIGIT = 259,
    REAL_NUMBER = 260,
    L_PAREN = 261,
    R_PAREN = 262,
    COMMA = 263,
    ADD = 264,
    SUB = 265,
    MULTIPLY = 266,
    MULSTRASSEN = 267,
    NORM = 268,
    TRANSPOSE = 269,
    ADJOINT = 270,
    INVERT = 271,
    DET = 272,
    LU_TOKEN = 273,
    QR_TOKEN = 274,
    RECTANGLE_METHOD = 275,
    SIMPSON_METHOD = 276,
    TRAPEZOID_METHOD = 277,
    GAUSS_METHOD = 278,
    SEIDEL_METHOD = 279,
    JACOBI_METHOD = 280,
    THOMAS_METHOD = 281,
    MUL = 282,
    DIV = 283,
    PLUS = 284,
    MINUS = 285,
    LEFT_PAR = 286,
    RIGHT_PAR = 287
  };
#endif
/* Tokens.  */
#define LETTER 258
#define DIGIT 259
#define REAL_NUMBER 260
#define L_PAREN 261
#define R_PAREN 262
#define COMMA 263
#define ADD 264
#define SUB 265
#define MULTIPLY 266
#define MULSTRASSEN 267
#define NORM 268
#define TRANSPOSE 269
#define ADJOINT 270
#define INVERT 271
#define DET 272
#define LU_TOKEN 273
#define QR_TOKEN 274
#define RECTANGLE_METHOD 275
#define SIMPSON_METHOD 276
#define TRAPEZOID_METHOD 277
#define GAUSS_METHOD 278
#define SEIDEL_METHOD 279
#define JACOBI_METHOD 280
#define THOMAS_METHOD 281
#define MUL 282
#define DIV 283
#define PLUS 284
#define MINUS 285
#define LEFT_PAR 286
#define RIGHT_PAR 287

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
