%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
    extern map<pair<string,int>,int> m;
%}
%token ID CHAR INT BOOL STRING INTEGER  VCHAR VSTRING
%token COMMA SEMICOLON LBRACE RBRACE
%left ASS ADDASS SUBASS MULASS DIVASS REMASS
%token L_OR
%token L_AND
%token R_EE R_NE
%token R_GT R_GE R_LT R_LE
%left A_ADD A_SUB
%left A_MUL A_DIV A_REM
%right ADDADD SUBSUB L_NO
%token LBRACKET RBRACKET POINT
%token WHILE BREAK RETURN CONTINUE IF ELSE FOR CONST

%%

program//
: stmts {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

stmts//
:  stmt {$$=$1;}
|  stmts stmt {$$=$1; $$->addSibling($2);}
;

stmt
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->sp = "skip";}
| decl SEMICOLON {$$=$1;}
| assign SEMICOLON
{$$=new TreeNode(lineno, NODE_STMT);$$->sp="assign"; $$->addChild($1);}
| block{$$ = new TreeNode(lineno, NODE_BLOCK); $$->sp = "block";}
| WHILE LBRACKET cond RBRACKET stmt {
	$$ = new TreeNode(lineno, NODE_STMT); $$->sp = "while";
	$$->addChild($3);$$->addChild($5);	
	}
/*| IF LBRACKET cond RBRACKET stmt {
	$$ = new TreeNode(lineno, NODE_STMT); $$->sp = "if";
	$$->addChild($3);$$->addChild($5);
	}
/*
| BREAK SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT);$$->sp="break";}
| CONTINUE SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT);$$->sp="continue";}
| FOR LBRACKET stmt SEMICOLON cond SEMICOLON stmt RBRACKET stmt {
	$$ = new TreeNode(lineno, NODE_STMT); $$->sp = "for";
	$$->addChild($3);$$->addChild($5);	
	$$->addChild($7);$$->addChild($9);	
	}*/
;

block//
: LBRACE stmts RBRACE {$$->addChild($2);}
;

decl//
: type assigns{ 
	$$ = new TreeNode(lineno, NODE_STMT); $$->sp="decl_val"; 
	$$->addChild($1);$$->addChild($2); 
	} 
| CONST type assigns{ 
	$$ = new TreeNode(lineno, NODE_STMT); $$->sp="decl_const"; 
	$$->addChild($2);$$->addChild($3);  
} 
;

assigns//
: assigns COMMA assign{$$=$1;$$->addSibling($3);}
| assigns COMMA ID{$$=$1;$$->addSibling($3);}
| assign{$$=$1;}
| ID{$$=$1;}
;

assign
:ID ASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="ass";
	$1->type=$3->type;
	$1->ch_val=$3->ch_val;
	$1->int_val=$3->int_val;
	$1->str_val=$3->str_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID ADDASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="ass";
	$1->type=$3->type;
	$1->int_val+=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID SUBASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="ass";
	$1->type=$3->type;
	$1->int_val-=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID MULASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="ass";
	$1->type=$3->type;
	$1->int_val*=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID DIVASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="ass";
	$1->type=$3->type;
	$1->int_val/=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID REMASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="ass";
	$1->type=$3->type;
	$1->int_val%=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
;

expr
: ID {$$ = $1;}
| INTEGER {$$ = $1;}
| VCHAR {$$ = $1;}
| VSTRING {$$ = $1;}
| expr A_ADD expr {
	$$ = new TreeNode(lineno, NODE_EXPR); 
	$$->type = TYPE_INT;$$->sp="add";
	$$->int_val=$1->int_val+$3->int_val;
	$$->addChild($1);$$->addChild($3);}
| expr A_SUB expr {
	$$ = new TreeNode(lineno, NODE_EXPR); 
	$$->type = TYPE_INT;$$->sp="sub";
	$$->int_val=$1->int_val-$3->int_val;
	$$->addChild($1);$$->addChild($3);}
| expr A_MUL expr {
	$$ = new TreeNode(lineno, NODE_EXPR); 
	$$->type = TYPE_INT;$$->sp="mul";
	$$->int_val=$1->int_val*$3->int_val;
	$$->addChild($1);$$->addChild($3);}
| expr A_DIV expr {
	$$ = new TreeNode(lineno, NODE_EXPR); 
	$$->type = TYPE_INT;$$->sp="div";
	$$->int_val=$1->int_val/$3->int_val;
	$$->addChild($1);$$->addChild($3);}
| expr A_REM expr {
	$$ = new TreeNode(lineno, NODE_EXPR); 
	$$->type = TYPE_INT;$$->sp="rem";
	$$->int_val=$1->int_val%$3->int_val;
	$$->addChild($1);$$->addChild($3);}
| LBRACKET expr RBRACKET {$$=$2;}
;

cond
: L_NO cond {}
| expr {}
| LBRACKET cond RBRACKET {}
| cond L_AND cond {}
| cond L_OR cond {}
| cond R_GT expr {}
| cond R_GE expr {}
| cond R_LT expr {}
| cond R_LE expr {}
| cond R_EE expr {}
| cond R_NE expr {}
;

type: INT {$$ = new TreeNode(lineno, NODE_TYPE); 
	$$->type = TYPE_INT;$$->sp="int";} 
| CHAR {$$ = new TreeNode(lineno, NODE_TYPE); 
	$$->type = TYPE_CHAR;$$->sp="char";}
| BOOL {$$ = new TreeNode(lineno, NODE_TYPE);
	 $$->type = TYPE_BOOL;$$->sp="bool";}
| STRING {$$ = new TreeNode(lineno, NODE_TYPE); 
	$$->type = TYPE_STRING;$$->sp="string";}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
