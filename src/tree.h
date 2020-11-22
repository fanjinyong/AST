#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,

    NODE_STMT,
    NODE_PROG,

	NODE_KEYWORD,
};

enum OperatorType
{
	OP_EQ,  // ==
};

enum StmtType {
    STMT_SKIP,
    STMT_DECL,
}
;
struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId();

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
    int scope=-1;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
};

struct NodeScope{
public:
	NodeScope*parent=nullptr;
	int scope;
	map<string,int> m;
	

	NodeScope(int scope){
		this->scope=scope;	
	}

	NodeScope* addScopeL(int s){
		NodeScope* node=new NodeScope(s);
		node->parent=this;
		return node;		
	}

	NodeScope* addScopeR(){
		return this->parent;		
	}

	void addVal(string val){
		NodeScope* temp=this;
		do{
			if(temp->m.count(val)){
				temp->m.insert(pair<string,int>(val,temp->m[val]));
				return;			
			}
		}while(temp->parent!=nullptr);
	}

	void addDel(string val){
		this->m.insert(pair<string,int>(val,this->scope));
	}

	int findScope(string val){
		return this->m[val];
	}
};

#endif
