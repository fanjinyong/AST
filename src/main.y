%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
    extern map<pair<string,int>,int> m;
%}

%token COMMA SEMICOLON 
%token LBRACE RBRACE
%left ASS ADDASS SUBASS MULASS DIVASS REMASS
%token L_OR
%token L_AND
%token R_EE R_NE
%token R_GT R_GE R_LT R_LE
%left A_ADD A_SUB
%left A_MUL A_DIV A_REM
%right ADDADD SUBSUB L_NO
%token LBRACKET RBRACKET POINT
%token WHILE BREAK RETURN CONTINUE IF ELSE FOR CONST VOID MAIN SCAN PRINT
%token ID CHAR INT BOOL STRING INTEGER  VCHAR VSTRING SP
%%

program//
: VOID MAIN LBRACKET RBRACKET LBRACE stmts RBRACE{root = new TreeNode(0, NODE_PROG); root->addChild($6);};

stmts//
:  stmt {$$=$1;}
|  stmts stmt {$$=$1; $$->addSibling($2);}
;

stmt
: LBRACE SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->sp = "skip";}
| decl SEMICOLON {$$=$1;}
| assign SEMICOLON
{$$=new TreeNode(lineno, NODE_STMT);$$->sp="assign"; $$->addChild($1);}
| LBRACE stmts RBRACE{$$=new TreeNode($2->lineno, NODE_BLOCK); $$->addChild($2);}
| WHILE LBRACKET cond RBRACKET stmt {
	$$ = new TreeNode($3->lineno, NODE_STMT); $$->sp = "while";
	$$->addChild($3);$$->addChild($5);	
	}
| IF LBRACKET cond RBRACKET stmt {
	$$ = new TreeNode($3->lineno, NODE_STMT); $$->sp = "if";
	$$->addChild($3);$$->addChild($5);
	}
/*
| BREAK SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT);$$->sp="break";}
| CONTINUE SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT);$$->sp="continue";}
*/
| FOR LBRACKET stmt cond SEMICOLON for3 RBRACKET stmt {
	$$ = new TreeNode($3->lineno, NODE_STMT); $$->sp = "for";
	$$->addChild($3);
	$$->addChild($4);
	$$->addChild($6);
$$->addChild($8);
//$$->addChild($5);	$$->addChild($7);$$->addChild($9);	
	}
| RETURN expr SEMICOLON {
	$$ = new TreeNode(lineno, NODE_STMT); 
	$$->sp = "return";
	$$->addChild($2);
	}
| RETURN SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->sp = "return";}
| PRINT LBRACKET ids RBRACKET SEMICOLON{
	$$ = new TreeNode(lineno, NODE_STMT); 
	$$->sp = "print";
	$$->addChild($3);
	}
| SCAN LBRACKET ids RBRACKET SEMICOLON{
$$ = new TreeNode(lineno, NODE_STMT); 
	$$->sp = "scan";
	$$->addChild($3);
}
;

ids
: ids COMMA expr {$$=$1;$$->addSibling($3);}
| expr {$$=$1;}
| ids COMMA SP expr {$$=$1;$$->addSibling($4);}
;

for3//
: assigns{$$ = new TreeNode(lineno, NODE_STMT); $$->sp="for3"; 
	$$->addChild($1);}

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
	node->sp="addass";
	$1->type=$3->type;
	$1->int_val+=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID SUBASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="subass";
	$1->type=$3->type;
	$1->int_val-=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID MULASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="mulass";
	$1->type=$3->type;
	$1->int_val*=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID DIVASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="divass";
	$1->type=$3->type;
	$1->int_val/=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID REMASS expr{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="remass";
	$1->type=$3->type;
	$1->int_val%=$3->int_val;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);node->addChild($3);
	$$=node;}
|ID ADDADD{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="addadd";
	$1->type=TYPE_INT;
	$1->int_val++;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);
	$$=node;}
|ID SUBSUB{
	TreeNode* node = new TreeNode(lineno, NODE_ASSIGN);
	node->sp="subsub";
	$1->type=TYPE_INT;
	$1->int_val++;
	m[make_pair($1->var_name,$1->scope)]=$1->int_val;
	node->addChild($1);
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
: condand L_OR condand{
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="L_or";
	$$->addChild($1);
	$$->addChild($3);
	} 
|condand{$$=$1;};


condand
: condno L_AND condno {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="L_and";
	$$->addChild($1);
	$$->addChild($3);
	} 
| condno {$$=$1;}
;

condno
: L_NO condition {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="L_no";
	$$->addChild($2);
	} 
| condition {$$=$1;}
;


condition
: expr R_GT expr {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="R_gt";
	$$->addChild($1);$$->addChild($3);
	}
| expr R_GE expr {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="R_ge";
	$$->addChild($1);$$->addChild($3);	
	}
| expr R_LT expr {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="R_lt";
	$$->addChild($1);$$->addChild($3);	
	}
| expr R_LE expr {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="R_le";
	$$->addChild($1);$$->addChild($3);	
	}
| expr R_EE expr {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="R_ee";
	$$->addChild($1);$$->addChild($3);}	
| expr R_NE expr {
	$$=new TreeNode(lineno, NODE_COND);
	$$->sp="R_ne";
	$$->addChild($1);$$->addChild($3);	
	}
| LBRACKET cond RBRACKET {$$=$1;}
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
