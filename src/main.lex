%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
int scope=0;
NodeScope* stree=new NodeScope(0);
map<pair<string,int>,int> m;
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

INTEGER (\+|-)?(((0x|0X)[0-9a-fA-F]+)|(0[0-7]+)|([0-9]+))

VCHAR \'.?\'
VSTRING \".+\"

ID [[:alpha:]_][[:alpha:][:digit:]_]*
%%


{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" return INT;
"char" return CHAR;
"string" return STRING;
"continue" return CONTINUE;
"if" return IF;
"else" return ELSE;
"while" return WHILE;
"break" return BREAK;
"return" return RETURN;
"for" return FOR;
"const" return CONST;

"void" return VOID;
"main" return MAIN;
"printf" return PRINT;
"scanf" return SCAN;
"&" return SP;



"*" return A_MUL;
"/" return A_DIV;
"%" return A_REM;
"+" return A_ADD;
"-" return A_SUB;

">" return R_GT;
">=" return R_GE;
"<" return R_LT;
"<=" return R_LE;
"==" return R_EE;
"!=" return R_NE;

"!" return L_NO;
"&&" return L_AND;
"||" return L_OR;

"++" return ADDADD;
"--" return SUBSUB;
"="  return ASS;
"+=" return ADDASS;
"-=" return SUBASS;
"*=" return MULASS;
"/=" return DIVASS;
"%=" return REMASS;

";" return SEMICOLON;
"{" {stree=stree->addScopeL(++scope);
return LBRACE;}
"}" {stree=stree->addScopeR();
return RBRACE;}
"(" return LBRACKET;
")" return RBRACKET;
"," return COMMA;
"." return POINT;


{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = char2Int(yytext);
    yylval = node;
    return INTEGER;
}

{VCHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1];
    yylval = node;
    return VCHAR;
}

{VSTRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = yytext;
    yylval = node;
    return VSTRING;
}

{ID} {
	stree->addVal(string(yytext));
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
   node->scope=stree->findScope(string(yytext));
	node->type = TYPE_INT;
if(m.count(make_pair(string(yytext),node->scope)))
		node->int_val=m[make_pair(string(yytext),node->scope)];
	else
		m.insert(make_pair(make_pair(string(yytext),node->scope),0));
    yylval = node;
    return ID;
}

{WHILTESPACE} 
{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%
