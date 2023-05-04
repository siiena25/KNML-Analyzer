%{
#include "y.tab.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int yyerror();

enum Op { DEFAULT_OP, ADD_EXPR, SUB_EXPR, MUL_EXPR, NORM_EXPR, MATRIX_EXPR, INTEGRAL_EXPR, SYSTEM_SOLVING_EXPR, MULSTRASSEN_EXPR };
enum MatrixExpr { DEFAULT_MATRIX_EXPR, TRANSPOSE_EXPR, ADJOINT_EXPR, INVERT_EXPR, DET_EXPR, LU_EXPR, QR_EXPR };
enum IntegralExpr { DEFAULT_INTEGRAL_EXPR, RECTANGLE_METHOD_EXPR, SIMPSON_METHOD_EXPR, TRAPEZOID_METHOD_EXPR };
enum SystemSolvingExpr { DEFAULT_SYSTEM_SOLVING_EXPR, GAUSS_METHOD_EXPR, SEIDEL_METHOD_EXPR, JACOBI_METHOD_EXPR, THOMAS_METHOD_EXPR };

enum Op currentOp;
enum MatrixExpr currentMatrixExpr;
enum IntegralExpr currentIntegralExpr;
enum SystemSolvingExpr currentSystemSolvingExpr;

#define FUNCTION_STRING_LEN 1000
#define LEN 100
#define OUTPUT_LEN 5000
#define IS_DEBUG false

struct Vector
{
    char** elements;
    int N;
};

struct Vector tmp_vector = { NULL, 0 };
struct Vector vector1 = { NULL, 0 };
struct Vector vector2 = { NULL, 0 };

struct Matrix
{
    char*** elements;
    int N;
    int M;
};

struct Matrix tmp_matrix = { NULL, 0, 0 };
struct Matrix matrix1 = { NULL, 0, 0 };
struct Matrix matrix2 = { NULL, 0, 0 };

char* number;

bool is_vector = false;
bool is_matrix = false;

char* function_string;

void clear_vector(struct Vector *tmp_vector) {
    for(int i = 0; i < LEN; i++) {
        free(tmp_vector->elements[i]);
    }
    free(tmp_vector->elements);
    tmp_vector->N = 0;
}

void clear_matrix(struct Matrix *tmp_matrix) {
    for(int i = 0; i < tmp_matrix->N; i++) {
        for (int j = 0; j < tmp_matrix->M; j++) {
            free(tmp_matrix->elements[i][j]);
        }
    }
    free(tmp_matrix->elements);
    tmp_matrix->N = 0;
    tmp_matrix->M = 0;
}

void clear_string(char* *output) {
    for(int i = 0; i < sizeof(output); i++) {
        free(output[i]);
    }
    free(output);
}

char* append(char* function_string, char* text) {
    if (function_string == NULL) {
        function_string = (char*) malloc (FUNCTION_STRING_LEN * sizeof(char));
    }
    strcat(function_string, yytext);
    return function_string;
}

int getLengthOfArray(char** array) {
    int len = 0;
    for (int i = 0; i < sizeof(array); i++) {
        len += strlen(array[i]);
    }
    return len;
}

int getLengthOfMatrix(struct Matrix *m) {
    int len = 0;
    for (int i = 0; i < m->N; i++) {
        for (int j = 0; j < m->M; j++) {
            len += strlen(m->elements[i][j]);
        }
    }
    return len;
}

void fullOutputStringForVector(struct Vector v1, char* v1_elems_str) {
    for (int i = 0; i < v1.N; i++) {
        strcat(v1_elems_str, v1.elements[i]);
        if (i != v1.N - 1) {
            strcat(v1_elems_str, ", ");
        }
    }
}

void fullOutputStringForMatrix(struct Matrix *m1, char* *m1_elems_str) {
    for (int i = 0; i < m1->N; i++) {
        strcat(*m1_elems_str, "arrayOf(");
        for (int j = 0; j < m1->M; j++) {
            strcat(*m1_elems_str, m1->elements[i][j]);
            if (j != m1->M - 1) {
                strcat(*m1_elems_str, ", ");
            }
        }
        if (i != m1->N - 1) {
            strcat(*m1_elems_str, "), ");
        } else {
            strcat(*m1_elems_str, ")");
        }
    }
}

void libAddMatrices(struct Matrix m1, struct Matrix m2) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* m2_elems_str = (char*) malloc ((getLengthOfMatrix(&m2) + 2*(m2.M - 1) + 12 * m2.N) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForMatrix(&m2, &m2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val m2 = Matrix(arrayOf(");
    strcat(output, m2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return m1.add(m2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(m2_elems_str, 0, sizeof m2_elems_str);
}

void libSubMatrices(struct Matrix m1, struct Matrix m2) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* m2_elems_str = (char*) malloc ((getLengthOfMatrix(&m2) + 2*(m2.M - 1) + 12 * m2.N) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForMatrix(&m2, &m2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val m2 = Matrix(arrayOf(");
    strcat(output, m2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return m1.sub(m2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(m2_elems_str, 0, sizeof m2_elems_str);
}

void libAddVectors(struct Vector v1, struct Vector v2) {
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));
    char* v2_elems_str = (char*) malloc ((getLengthOfArray(v2.elements) + 2*(v2.N - 1)) * sizeof(char));

    fullOutputStringForVector(v1, v1_elems_str);
    fullOutputStringForVector(v2, v2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Vector {\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v2 = Vector(arrayOf(");
    strcat(output, v2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return v1.add(v2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
    memset(v2_elems_str, 0, sizeof v2_elems_str);
}

void libSubVectors(struct Vector v1, struct Vector v2) {
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));
    char* v2_elems_str = (char*) malloc ((getLengthOfArray(v2.elements) + 2*(v2.N - 1)) * sizeof(char));

    fullOutputStringForVector(v1, v1_elems_str);
    fullOutputStringForVector(v2, v2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Vector {\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v2 = Vector(arrayOf(");
    strcat(output, v2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return v1.sub(v2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
    memset(v2_elems_str, 0, sizeof v2_elems_str);
}

void libMulVectors(struct Vector v1, struct Vector v2) {
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));
    char* v2_elems_str = (char*) malloc ((getLengthOfArray(v2.elements) + 2*(v2.N - 1)) * sizeof(char));

    fullOutputStringForVector(v1, v1_elems_str);
    fullOutputStringForVector(v2, v2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Vector {\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v2 = Vector(arrayOf(");
    strcat(output, v2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return v1.multiply(v2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
    memset(v2_elems_str, 0, sizeof v2_elems_str);
}

void libMulMatrices(struct Matrix m1, struct Matrix m2) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* m2_elems_str = (char*) malloc ((getLengthOfMatrix(&m2) + 2*(m2.M - 1) + 12 * m2.N) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForMatrix(&m2, &m2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val m2 = Matrix(arrayOf(");
    strcat(output, m2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return m1.multiply(m2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(m2_elems_str, 0, sizeof m2_elems_str);
}

void libMulstrassenMatrices(struct Matrix m1, struct Matrix m2) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* m2_elems_str = (char*) malloc ((getLengthOfMatrix(&m2) + 2*(m2.M - 1) + 12 * m2.N) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForMatrix(&m2, &m2_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.StrassenAlgorithm\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val m2 = Matrix(arrayOf(");
    strcat(output, m2_elems_str);
    strcat(output, "))\n");
    strcat(output, "\n");
    strcat(output, "        return StrassenAlgorithm().multiply(m1, m2)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(m2_elems_str, 0, sizeof m2_elems_str);
}

void libMulVecNum(struct Vector v1, char* number) {
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));

    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Vector {\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val n = ");
    strcat(output, number);
    strcat(output, "\n");
    strcat(output, "        return v1.multiply(n)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
    memset(number, 0, sizeof number);
}

void libMulMatNum(struct Matrix m1, char* number) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val n = ");
    strcat(output, number);
    strcat(output, "\n");
    strcat(output, "        return m1.multiply(n)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(number, 0, sizeof number);
}

void libMulMatVec(struct Matrix m1, struct Vector v1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Vector {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return m1.multiply(v1)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
}

void libNormVector(struct Vector v1) {
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));
    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Double {\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return v1.norm()\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
}

void libNormMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Double {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return m1.norm()\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libTransposeMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return m1.transpose()\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libInvertMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Matrix {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return m1.invertible()\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libDetMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Double {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return m1.determinant(m1.getN())\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libAdjointMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): Double {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return m1.adjoint()\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libLUMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.LUDecomposition\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): LUDecomposition {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return LUDecomposition(m1)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libQRMatrix(struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    fullOutputStringForMatrix(&m1, &m1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.QRDecomposition\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): QRDecomposition {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return QRDecomposition(m1)\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
}

void libRectangleMethod(char* function_string) {
    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.integralmethods.RectangleMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.DoubleResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): DoubleResultWithStatus {\n");
    strcat(output, "        val result: DoubleResultWithStatus = RectangleMethod().solveIntegralByRectangleMethod(\n");
    strcat(output, "            0.0,\n");
    strcat(output, "            1.0,\n");
    strcat(output, "            eps = 0.00000001,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        ) { x -> ");
    strcat(output, function_string);
    strcat(output, "\n");
    strcat(output, "        }\n");
    strcat(output, "        return result\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(function_string, 0, sizeof function_string);
}

void libSimpsonMethod(char* function_string) {
    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.integralmethods.SimpsonMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.DoubleResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): DoubleResultWithStatus {\n");
    strcat(output, "        val result: DoubleResultWithStatus = SimpsonMethod().solveIntegralBySimpsonMethod(\n");
    strcat(output, "            0.0,\n");
    strcat(output, "            1.0,\n");
    strcat(output, "            eps = 0.00000001,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        ) { x -> ");
    strcat(output, function_string);
    strcat(output, "\n");
    strcat(output, "        }\n");
    strcat(output, "        return result\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(function_string, 0, sizeof function_string);
}

void libTrapezoidMethod(char* function_string) {
    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.integralmethods.TrapezoidMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.DoubleResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): DoubleResultWithStatus {\n");
    strcat(output, "        val result: DoubleResultWithStatus = TrapezoidMethod().solveIntegralByTrapezoidMethod(\n");
    strcat(output, "            0.0,\n");
    strcat(output, "            1.0,\n");
    strcat(output, "            eps = 0.00000001,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        ) { x -> ");
    strcat(output, function_string);
    strcat(output, "\n");
    strcat(output, "        }\n");
    strcat(output, "        return result\n");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(function_string, 0, sizeof function_string);
}

void libGaussMethod(struct Vector v1, struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.systemsolvingmethods.GaussMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.VectorResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): VectorResultWithStatus {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return GaussMethod().solveSystemByGaussClassicMethod(\n");
    strcat(output, "            m1,\n");
    strcat(output, "            v1,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        )");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
}

void libJacobiMethod(struct Vector v1, struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.systemsolvingmethods.JacobiMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.VectorResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): VectorResultWithStatus {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return JacobiMethod().solveSystemByJacobiMethod(\n");
    strcat(output, "            m1,\n");
    strcat(output, "            v1,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        )");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
}

void libThomasMethod(struct Vector v1, struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.systemsolvingmethods.ThomasMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.VectorResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): VectorResultWithStatus {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return ThomasMethod().solveSystemByThomasMethod(\n");
    strcat(output, "            m1,\n");
    strcat(output, "            v1,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        )");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
}

void libSeidelMethod(struct Vector v1, struct Matrix m1) {
    char* m1_elems_str = (char*) malloc ((getLengthOfMatrix(&m1) + 2*(m1.M - 1) + 12 * m1.N) * sizeof(char));
    char* v1_elems_str = (char*) malloc ((getLengthOfArray(v1.elements) + 2*(v1.N - 1)) * sizeof(char));

    fullOutputStringForMatrix(&m1, &m1_elems_str);
    fullOutputStringForVector(v1, v1_elems_str);

    char* output = (char*) malloc (OUTPUT_LEN * sizeof(char));

    strcat(output, "package com.github.varenytsiamykhailo.knml.util.analyzer.util\n");
    strcat(output, "\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.systemsolvingmethods.SeidelMethod\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Matrix\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.Vector\n");
    strcat(output, "import com.github.varenytsiamykhailo.knml.util.results.VectorResultWithStatus\n");
    strcat(output, "\n");
    strcat(output, "class Output {\n");
    strcat(output, "    fun call(): VectorResultWithStatus {\n");
    strcat(output, "        val m1 = Matrix(arrayOf(");
    strcat(output, m1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        val v1 = Vector(arrayOf(");
    strcat(output, v1_elems_str);
    strcat(output, "))\n");
    strcat(output, "        return SeidelMethod().solveSystemBySeidelMethod(\n");
    strcat(output, "            m1,\n");
    strcat(output, "            v1,\n");
    strcat(output, "            formSolution = true\n");
    strcat(output, "        )");
    strcat(output, "    }\n");
    strcat(output, "}");

    printf("%s", output);

    memset(output, 0, OUTPUT_LEN);
    memset(m1_elems_str, 0, sizeof m1_elems_str);
    memset(v1_elems_str, 0, sizeof v1_elems_str);
}

%}

letter								[A-Za-z]
digit								[0-9]

%%

["A"|"a"]"dd"|["A"|"a"]"ddition"    {
                                        currentOp = ADD_EXPR;
                                        return ADD;
                                    }
["S"|"s"]"ub"|["S"|"s"]"ubstitution" {
                                        currentOp = SUB_EXPR;
                                        return SUB;
                                    }
["M"|"m"]"ul"|["M"|"m"]"ultiplication" {
                                        if (IS_DEBUG) {
                                            printf("MULTIPLY: %s\n", yytext);
                                        }
                                        currentOp = MUL_EXPR;
                                        return MULTIPLY;
                                    }
["M"|"m"]"ulstrassen" {
                                        currentOp = MULSTRASSEN_EXPR;
                                        return MULSTRASSEN;
                                    }
["N"|"n"]"orm"                      {
                                        currentOp = NORM_EXPR;
                                        return NORM;
                                    }
["T"|"t"]"ranspose"                 {
                                        currentOp = MATRIX_EXPR;
                                        currentMatrixExpr = TRANSPOSE_EXPR;
                                        return TRANSPOSE;
                                    }
["A"|"a"]"djoint"                   {
                                        currentOp = MATRIX_EXPR;
                                        currentMatrixExpr = ADJOINT_EXPR;
                                        return ADJOINT;
                                    }
["I"|"i"]"nvert"                    {
                                        currentOp = MATRIX_EXPR;
                                        currentMatrixExpr = INVERT_EXPR;
                                        return INVERT;
                                    }
["D"|"d"]"et"|["D"|"d"]"eterminant" {
                                        currentOp = MATRIX_EXPR;
                                        currentMatrixExpr = DET_EXPR;
                                        return DET;
                                    }
["L"|"l"]["U"|"u"]                  {
                                        currentOp = MATRIX_EXPR;
                                        currentMatrixExpr = LU_EXPR;
                                        return LU_TOKEN;
                                    }
["Q"|"q"]["R"|"r"]                  {
                                        currentOp = MATRIX_EXPR;
                                        currentMatrixExpr = QR_EXPR;
                                        return QR_TOKEN;
                                    }
["R"|"r"]"ectangle"[ ]*["M"|"m"]"ethod" {
                                        currentOp = INTEGRAL_EXPR;
                                        currentIntegralExpr = RECTANGLE_METHOD_EXPR;
                                        return RECTANGLE_METHOD;
                                    }
["S"|"s"]"impson"[ ]*["M"|"m"]"ethod" {
                                        currentOp = INTEGRAL_EXPR;
                                        currentIntegralExpr = SIMPSON_METHOD_EXPR;
                                        return SIMPSON_METHOD;
                                    }
["T"|"t"]"rapezoid"[ ]*["M"|"m"]"ethod" {
                                        currentOp = INTEGRAL_EXPR;
                                        currentIntegralExpr = TRAPEZOID_METHOD_EXPR;
                                        return TRAPEZOID_METHOD;
                                    }
["G"|"g"]"auss"[ ]*["M"|"m"]"ethod" {
                                        currentOp = SYSTEM_SOLVING_EXPR;
                                        currentSystemSolvingExpr = GAUSS_METHOD_EXPR;
                                        return GAUSS_METHOD;
                                    }
["S"|"s"]"eidel"[ ]*["M"|"m"]"ethod" {
                                        currentOp = SYSTEM_SOLVING_EXPR;
                                        currentSystemSolvingExpr = SEIDEL_METHOD_EXPR;
                                        return SEIDEL_METHOD;
                                    }
["J"|"j"]"acobi"[ ]*["M"|"m"]"ethod" {
                                        currentOp = SYSTEM_SOLVING_EXPR;
                                        currentSystemSolvingExpr = JACOBI_METHOD_EXPR;
                                        return JACOBI_METHOD;
                                    }
["T"|"t"]"homas"[ ]*["M"|"m"]"ethod" {
                                        currentOp = SYSTEM_SOLVING_EXPR;
                                        currentSystemSolvingExpr = THOMAS_METHOD_EXPR;
                                        return THOMAS_METHOD;
                                    }
"-"?[0-9]+("."[0-9]+)?              {
                                        if (IS_DEBUG) {
                                            printf("REAL_NUMBER: %s\n", yytext);
                                        }

                                        if (currentOp == INTEGRAL_EXPR) {
                                            function_string = append(function_string, yytext);
                                        } else if (is_vector == false && is_matrix == false) {
                                            number = (char*) malloc (sizeof(yytext) * sizeof(char));
                                            strcpy(number, yytext);
                                        } else {
                                            if (tmp_vector.N == 0) {
                                                tmp_vector.elements = (char**) malloc (LEN * sizeof(char*));
                                                for (int i = 0; i < LEN; i++) {
                                                    tmp_vector.elements[i] = (char*) malloc (LEN * sizeof(char));
                                                }
                                            }
                                            strcpy(tmp_vector.elements[tmp_vector.N], yytext);
                                            tmp_vector.N++;
                                        }
                                        return REAL_NUMBER;
                                    }
"{"                                 {
                                        if (IS_DEBUG) {
                                            printf("L_PAREN: %s\n", yytext);
                                        }
                                        if (is_vector == true) {
                                            is_matrix = true;
                                        } else if (is_vector == false) {
                                            is_vector = true;
                                        }
                                        return L_PAREN;
                                    }
"}"                                 {
                                        if (IS_DEBUG) {
                                            printf("R_PAREN: %s\n", yytext);
                                        }
                                        if (is_vector == true) {
                                            if (is_matrix == true) { //закончили читать вектор матрицы
                                                if (tmp_matrix.N == 0) { //если это первый вектор, инициализируем массив векторов для матрицы
                                                    tmp_matrix.elements = (char***) malloc (sizeof (char**) * LEN);
                                                    for (int i = 0; i < LEN; i++) {
                                                        tmp_matrix.elements[i] = (char**) malloc (sizeof (char*) * LEN);
                                                        for (int j = 0; j < LEN; j++) {
                                                            tmp_matrix.elements[i][j] = (char*) malloc (sizeof (char) * LEN);
                                                        }
                                                    }
                                                }
                                                for (int i = 0; i <= tmp_matrix.N; i++) {
                                                    for (int j = 0; j < tmp_vector.N; j++) {
                                                        strcpy(tmp_matrix.elements[tmp_matrix.N][j], tmp_vector.elements[j]);
                                                    }
                                                }
                                                tmp_matrix.N++;

                                                if (matrix1.N == 0) {
                                                    matrix1.M = tmp_vector.N;
                                                } else {
                                                    matrix2.M = tmp_vector.N;
                                                }

                                                is_vector = false;
                                            } else {
                                                if (vector1.N == 0) {
                                                    vector1.elements = (char**) malloc (LEN * sizeof(char*));
                                                    for (int i = 0; i < LEN; i++) {
                                                        vector1.elements[i] = (char*) malloc (LEN * sizeof(char));
                                                        strcpy(vector1.elements[i], tmp_vector.elements[i]);
                                                    }
                                                    vector1.N = tmp_vector.N;
                                                } else if (vector2.N == 0) {
                                                    vector2.elements = (char**) malloc (LEN * sizeof(char*));
                                                    for (int i = 0; i < LEN; i++) {
                                                        vector2.elements[i] = (char*) malloc (LEN * sizeof(char));
                                                        strcpy(vector2.elements[i], tmp_vector.elements[i]);
                                                    }
                                                    vector2.N = tmp_vector.N;
                                                }
                                            }
                                            clear_vector(&tmp_vector);
                                            is_vector = false;
                                        } else if (is_matrix == true) { //закончили читать матрицу
                                            if (matrix1.N == 0) {
                                                matrix1.elements = (char***) malloc (sizeof (char**) * LEN);
                                                for (int i = 0; i < tmp_matrix.N; i++) {
                                                    matrix1.elements[i] = (char**) malloc (sizeof (char*) * LEN);
                                                    for (int j = 0; j < LEN; j++) {
                                                        matrix1.elements[i][j] = (char*) malloc (sizeof (char) * LEN);
                                                        strcpy(matrix1.elements[i][j], tmp_matrix.elements[i][j]);
                                                    }
                                                }
                                                matrix1.N = tmp_matrix.N;
                                            } else if (matrix2.N == 0) {
                                                matrix2.elements = (char***) malloc (sizeof (char**) * LEN);
                                                for (int i = 0; i < tmp_matrix.N; i++) {
                                                    matrix2.elements[i] = (char**) malloc (sizeof (char*) * LEN);
                                                    for (int j = 0; j < LEN; j++) {
                                                        matrix2.elements[i][j] = (char*) malloc (sizeof (char) * LEN);
                                                        strcpy(matrix2.elements[i][j], tmp_matrix.elements[i][j]);
                                                    }
                                                }
                                                matrix2.N = tmp_matrix.N;
                                            }
                                            clear_matrix(&tmp_matrix);
                                            is_matrix = false;
                                        }
                                        return R_PAREN;
                                    }
","                                 {
                                        if (IS_DEBUG) {
                                            printf("COMMA: %s\n", yytext);
                                        }
                                        return COMMA;
                                    }
[ ]+                                {}
"*"                                 {
                                        if (IS_DEBUG) {
                                            printf("MUL: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return MUL;
                                    }
"/"                                 {
                                        if (IS_DEBUG) {
                                            printf("DIV: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return DIV;
                                    }
"+"                                 {
                                        if (IS_DEBUG) {
                                            printf("PLUS: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return PLUS;
                                    }
"-"                                 {
                                        if (IS_DEBUG) {
                                            printf("MINUS: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return MINUS;
                                    }
"("                                 {
                                        if (IS_DEBUG) {
                                            printf("LEFT_PAR: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return LEFT_PAR;
                                    }
")"                                 {
                                        if (IS_DEBUG) {
                                            printf("RIGHT_PAR: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return RIGHT_PAR;
                                    }
[A-Za-z]                              {
                                        if (IS_DEBUG) {
                                            printf("LETTER: %s\n", yytext);
                                        }
                                        function_string = append(function_string, yytext);
                                        return LETTER;
                                    }
.                                   { }

%%


int yyerror()
{
    printf("\n\nerror!\n\n");
    exit(1);
}

const void getCurrentIntegralExpr(enum IntegralExpr currentIntegralExpr)
{
    switch (currentIntegralExpr)
    {
        case DEFAULT_INTEGRAL_EXPR: {
            break;
        }
        case RECTANGLE_METHOD_EXPR: {
            libRectangleMethod(function_string);
            break;
        }
        case SIMPSON_METHOD_EXPR: {
            libSimpsonMethod(function_string);
            break;
        }
        case TRAPEZOID_METHOD_EXPR: {
            libTrapezoidMethod(function_string);
            break;
        }
    }
}

const void getCurrentSystemSolvingExpr(enum SystemSolvingExpr currentSystemSolvingExpr)
{
    switch (currentSystemSolvingExpr)
    {
        case DEFAULT_SYSTEM_SOLVING_EXPR: {
            break;
        }
        case GAUSS_METHOD_EXPR: {
            libGaussMethod(vector1, matrix1);
            break;
        }
        case SEIDEL_METHOD_EXPR: {
            libSeidelMethod(vector1, matrix1);
            break;
        }
        case JACOBI_METHOD_EXPR: {
            libJacobiMethod(vector1, matrix1);
            break;
        }
        case THOMAS_METHOD_EXPR: {
            libThomasMethod(vector1, matrix1);
            break;
        }
    }
}

const void getCurrentMatrixExpr(enum MatrixExpr currentMatrixExpr)
{
    switch (currentMatrixExpr)
    {
        case DEFAULT_MATRIX_EXPR: {
            break;
        }
        case TRANSPOSE_EXPR: {
            libTransposeMatrix(matrix1);
            break;
        }
        case ADJOINT_EXPR: {
            libAdjointMatrix(matrix1);
            break;
        }
        case INVERT_EXPR: {
            libInvertMatrix(matrix1);
            break;
        }
        case DET_EXPR: {
            libDetMatrix(matrix1);
            break;
        }
        case LU_EXPR: {
            libLUMatrix(matrix1);
            break;
        }
        case QR_EXPR: {
            libQRMatrix(matrix1);
            break;
        }
    }
}

const void getCurrentOp(enum Op currentOp)
{
    switch (currentOp)
    {
        case DEFAULT_OP: {
            break;
        };
        case ADD_EXPR: {
            if (vector1.N != 0 && vector2.N != 0 && matrix1.N == 0 && matrix2.N == 0) {
                libAddVectors(vector1, vector2);
            } else if (vector1.N == 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N != 0) {
                libAddMatrices(matrix1, matrix2);
            }
            break;
        }
        case SUB_EXPR: {
            if (vector1.N != 0 && vector2.N != 0 && matrix1.N == 0 && matrix2.N == 0) {
                libSubVectors(vector1, vector2);
            } else if (vector1.N == 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N != 0) {
                libSubMatrices(matrix1, matrix2);
            }
            break;
        };
        case MUL_EXPR: {
            if (vector1.N != 0 && vector2.N != 0 && matrix1.N == 0 && matrix2.N == 0) {
                libMulVectors(vector1, vector2);
            } else if (vector1.N == 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N != 0) {
                libMulMatrices(matrix1, matrix2);
            } else if (vector1.N != 0 && number != NULL) {
                libMulVecNum(vector1, number);
            } else if (matrix1.N != 0 && number != NULL) {
                libMulMatNum(matrix1, number);
            } else if (matrix1.N != 0 && vector1.N != 0) {
                libMulMatVec(matrix1, vector1);
            }
            break;
        };
        case MULSTRASSEN_EXPR: {
            if (vector1.N == 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N != 0) {
                libMulstrassenMatrices(matrix1, matrix2);
            }
            break;
        };
        case NORM_EXPR: {
            if (vector1.N != 0 && vector2.N == 0 && matrix1.N == 0 && matrix2.N == 0) {
                libNormVector(vector1);
            } else if (vector1.N == 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N == 0) {
                libNormMatrix(matrix1);
            }
            break;
        };
        case MATRIX_EXPR: {
            if (vector1.N == 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N == 0) {
                getCurrentMatrixExpr(currentMatrixExpr);
            }
            break;
        };
        case INTEGRAL_EXPR: {
            if (vector1.N == 0 && vector2.N == 0 && matrix1.N == 0 && matrix2.N == 0 && function_string != NULL) {
                getCurrentIntegralExpr(currentIntegralExpr);
            }
            break;
        };
        case SYSTEM_SOLVING_EXPR: {
            if (vector1.N != 0 && vector2.N == 0 && matrix1.N != 0 && matrix2.N == 0) {
                getCurrentSystemSolvingExpr(currentSystemSolvingExpr);
            }
            break;
        };
    }
}

int yywrap()
{
    getCurrentOp(currentOp);

    if (IS_DEBUG) {
        if (vector1.N != 0) {
            printf("\nvector1.N: %d\n", vector1.N);
            printf("Vector1: ");
            for (int i = 0; i < vector1.N; i++) {
                printf("%s, ", vector1.elements[i]);
            }
            printf("\n");
            clear_vector(&vector1);
        }

        if (vector2.N != 0) {
            printf("\nvector2.N: %d\n", vector2.N);
            printf("Vector2: ");
            for (int i = 0; i < vector2.N; i++) {
                printf("%s, ", vector2.elements[i]);
            }
            printf("\n");
            clear_vector(&vector2);
        }

        if (matrix1.N != 0) {
            printf("\nmatrix1.N: %d\n", matrix1.N);
            printf("matrix1.M: %d\n", matrix1.M);
            printf("Matrix1: ");
            for (int i = 0; i < matrix1.N; i++) {
                for (int j = 0; j < matrix1.M; j++) {
                    printf("%s, ", matrix1.elements[i][j]);
                }
            }
            printf("\n");
            clear_matrix(&matrix1);
        }

        if (matrix2.N != 0) {
            printf("\nmatrix2.N: %d\n", matrix2.N);
            printf("matrix2.M: %d\n", matrix2.M);
            printf("Matrix2: ");
            for (int i = 0; i < matrix2.N; i++) {
                for (int j = 0; j < matrix2.M; j++) {
                    printf("%s, ", matrix2.elements[i][j]);
                }
            }
            printf("\n");
            clear_matrix(&matrix2);
        }

        if (function_string != NULL) {
            printf("\nFunction string: %s\n", function_string);
            free(function_string);
        }
        printf("\n\n# correct!\n\n");
    } else {

        if (vector1.N != 0) { clear_vector(&vector1); }
        if (vector2.N != 0) { clear_vector(&vector2); }
        if (matrix1.N != 0) { clear_matrix(&matrix1); }
        if (matrix2.N != 0) { clear_matrix(&matrix2); }
        if (function_string != NULL) { free(function_string); }
    }

    exit(1);
}