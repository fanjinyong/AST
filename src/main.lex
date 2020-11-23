%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
int scope=0;
int flag=0;
NodeScope* stree=new NodeScope(0);
int char2Int(char* yyt){
int i=0;
int fu=0;
int hex;
int num=0;

if(yyt[i]=='-'){
    fu=1;
    i++;
}
if(yyt[i]=='+'){
    fu=0;
    i++;
}
if(yyt[i]=='0'){
    i++;
    if(yyt[i]=='x'||yyt[i]=='X'){
        i++;
        hex=16;
    }
    else
    hex=8;
}
else
    hex=10;

int len=strlen(yyt);
while(i<len){
switch(yyt[i]){
case '0':
case '1':
case '2':
case '3':
case '4':
case '5':
case '6':
case '7':
case '8':
case '9':
{num=num*hex+(yyt[i]-'0');break;}
case 'a':
case 'A':
{num=num*hex+10;break;}
case 'b':
case 'B':
{num=num*hex+11;break;}
case 'c':
case 'C':
{num=num*hex+12;break;}
case 'd':
case 'D':
{num=num*hex+13;break;}
case 'e':
case 'E':
{num=num*hex+14;break;}
case 'f':
case 'F':
{num=num*hex+15;break;}
}
i++;
}

if(fu)
num=0-num;
return num;
}
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

LBRACE "{"
RBRACE "}"

INTEGER (\+|-)?(((0x|0X)[0-9a-fA-F]+)|(0[0-7]+)|([0-9]+))

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%


{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" {flag=1;return T_INT;}
"bool" return T_BOOL;
"char" return T_CHAR;
"string" return T_STRING;

"=" return LOP_ASSIGN;

";" {flag=0;return SEMICOLON;}


{LBRACE} {scope++;stree=stree->addScopeL(scope);}
{RBRACE} {stree=stree->addScopeR();}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = char2Int(yytext);
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
