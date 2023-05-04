%{
#include <stdio.h>
extern FILE *yyin;

int yylex();

void yyerror(const char *s);

extern int tb;
extern int reverseStrokeFlag;
extern int text_flag;
extern int state_after_close_flag;
extern int open_tag_count;
extern int close_tag_count;
%}

%start Op
%token LETTER DIGIT REAL_NUMBER L_PAREN R_PAREN COMMA
%token ADD SUB MULTIPLY MULSTRASSEN
%token NORM TRANSPOSE ADJOINT INVERT DET LU_TOKEN QR_TOKEN
%token RECTANGLE_METHOD SIMPSON_METHOD TRAPEZOID_METHOD
%token GAUSS_METHOD SEIDEL_METHOD JACOBI_METHOD THOMAS_METHOD
%token MUL DIV PLUS MINUS LEFT_PAR RIGHT_PAR

%%

//возможные выражения
Op :
    AddExpr | SubExpr | MulExpr | NormExpr | MatrixExpr | IntegralExpr | SystemSolvingExpr;

AddExpr :
    ADD Vector Vector | ADD Matrix Matrix;

SubExpr :
    SUB Vector Vector | SUB Matrix Matrix;

MulExpr :
    MULTIPLY Vector RealNumber | MULTIPLY Matrix RealNumber | MULTIPLY Vector Vector | MULTIPLY Matrix Vector | MULTIPLY Matrix Matrix | MULSTRASSEN Matrix Matrix;

NormExpr :
    NORM Vector | NORM Matrix;

MatrixExpr :
    TRANSPOSE Matrix | ADJOINT Matrix | INVERT Matrix | DET Matrix | LU_TOKEN Matrix | QR_TOKEN Matrix;

IntegralExpr :
    RECTANGLE_METHOD Expr
    | SIMPSON_METHOD Expr
    | TRAPEZOID_METHOD Expr;

SystemSolvingExpr :
    GAUSS_METHOD Matrix Vector
    | GAUSS_METHOD Vector Matrix
    | SEIDEL_METHOD Matrix Vector
    | SEIDEL_METHOD Vector Matrix
    | JACOBI_METHOD Matrix Vector
    | JACOBI_METHOD Vector Matrix
    | THOMAS_METHOD Matrix Vector
    | THOMAS_METHOD Vector Matrix;

Matrix :
    L_PAREN VectorList R_PAREN;

VectorList :
    Vector COMMA VectorList | Vector;

Vector :
    L_PAREN NumberList R_PAREN;

NumberList :
    RealNumber COMMA NumberList | RealNumber;

RealNumber :
    REAL_NUMBER
    | '-' DoubleNumber
    | DoubleNumber ;

DoubleNumber :
    Number '.' Number
    | Number ;

Number :
    Number DIGIT
    | DIGIT ;

Expr :
    Expr AddOp Term
    | AddOp Term
    | Term ;

Term :
    Term MulOp Factor
    | Factor ;

Factor :
    LEFT_PAR Expr RIGHT_PAR
    | Var
    | RealNumber ;

MulOp :
    MUL | DIV ;

AddOp :
    PLUS | MINUS ;

Var :
    LETTER
    | Var LETTER
    | REAL_NUMBER Var ;

%%

int main(int argc, char *argv[])
{
	//printf("\n# check file %s:\n\n", argv[1]);
	yyin = fopen(argv[1], "r");
	yyparse();
}