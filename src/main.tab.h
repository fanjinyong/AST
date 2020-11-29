/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_SRC_MAIN_TAB_H_INCLUDED
# define YY_YY_SRC_MAIN_TAB_H_INCLUDED
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
    COMMA = 258,
    SEMICOLON = 259,
    LBRACE = 260,
    RBRACE = 261,
    ASS = 262,
    ADDASS = 263,
    SUBASS = 264,
    MULASS = 265,
    DIVASS = 266,
    REMASS = 267,
    L_OR = 268,
    L_AND = 269,
    R_EE = 270,
    R_NE = 271,
    R_GT = 272,
    R_GE = 273,
    R_LT = 274,
    R_LE = 275,
    A_ADD = 276,
    A_SUB = 277,
    A_MUL = 278,
    A_DIV = 279,
    A_REM = 280,
    ADDADD = 281,
    SUBSUB = 282,
    L_NO = 283,
    LBRACKET = 284,
    RBRACKET = 285,
    POINT = 286,
    WHILE = 287,
    BREAK = 288,
    RETURN = 289,
    CONTINUE = 290,
    IF = 291,
    ELSE = 292,
    FOR = 293,
    CONST = 294,
    VOID = 295,
    MAIN = 296,
    SCAN = 297,
    PRINT = 298,
    ID = 299,
    CHAR = 300,
    INT = 301,
    BOOL = 302,
    STRING = 303,
    INTEGER = 304,
    VCHAR = 305,
    VSTRING = 306,
    SP = 307
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_MAIN_TAB_H_INCLUDED  */
