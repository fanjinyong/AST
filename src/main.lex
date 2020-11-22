%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
int scope=0;
int flag=0;
NodeScope* stree=new NodeScope(0);
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

LBRACE "{"
RBRACE "}"

INTEGER [0-9]+

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%


{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" {flag=1;return T_INT;}
"bool" return T_BOOL;
"char" return T_CHAR;

"=" return LOP_ASSIGN;

";" {flag=0;return  SEMICOLON;}


{LBRACE} {scope++;stree=stree->addScopeL(scope);}
{RBRACE} {stree=stree->addScopeR();}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}

{IDENTIFIER} {
	if(flag==1)
		stree->addDel(string(yytext));
	else{
		stree->addVal(string(yytext));
	}
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
node->scope=stree->findScope(string(yytext));
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%
