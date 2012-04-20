#include <stdio.h>
#include <ruby.h>
#include "svd.h"

VALUE decompose(VALUE module, VALUE matrix_ruby, VALUE m_ruby, VALUE n_ruby) {
	int m = NUM2INT(m_ruby);
	int n = NUM2INT(n_ruby);
	float **u = matrix(1, m, 1, n);
	float **v = matrix(1, m, 1, n);
	float *w = vector(1, n);
	VALUE *matrix_values = RARRAY_PTR(matrix_ruby);
	int offset = 0;
	int i, j;
	
	/* output arrays */
	VALUE u_output = rb_ary_new();
	VALUE v_output = rb_ary_new();
	VALUE w_output = rb_ary_new();
	VALUE output = rb_ary_new();
	
	/* precondition */
	if((m*n) != RARRAY_LEN(matrix_ruby)) {
		rb_raise(rb_eRangeError, "Size of the array is not equal to m * n");
		return output;
	}
	
	/* convert to u matrix */
	for(i = 1; i <= m; i++) {
		for(j = 1; j <= n; j++) {
			offset = ((i-1)*n) + (j-1);
			u[i][j] = (float) NUM2DBL(matrix_values[offset]);
		}
	}

	/* perform SVD */
	svdcmp(u, m, n, w, v);
	
	/* create w output array */
	for(i = 1; i <= n; i++)
		rb_ary_push(w_output, rb_float_new(w[i]));
	
	/* create u arrays */
	for(i = 1; i <= m; i++) {
		for(j = 1; j <= n; j++) {
			rb_ary_push(u_output, rb_float_new(u[i][j]));
		}
	}
	
	/* create v arrays */
	for(i = 1; i <= n; i++) {
		for(j = 1; j <= n; j++) {
			rb_ary_push(v_output, rb_float_new(v[i][j]));
		}
	}
	
	rb_ary_push(output, u_output);
	rb_ary_push(output, w_output);
	rb_ary_push(output, v_output);
	return output;
}

void Init_svd()
{
	VALUE module = rb_define_module("SVD");
	rb_define_module_function(module, "decompose", decompose, 3);
}		
