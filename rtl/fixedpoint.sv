// creates variable-length constant with provided integer and fractional components
`define CREATE_CONSTANT_FIXED_POINT(INT_SZ, FRAC_SZ, INT_CONST, FRAC_CONST) \
{ INT_SZ'(INT_CONST), FRAC_CONST, {(FRAC_SZ - $bits(FRAC_CONST)){ 0 }}}

`define GET_FIXED_POINT_DECIMAL_FORM(INT_SZ, FRAC_SZ, VECTOR_NAME) \
``VECTOR_NAME[INT_SZ - 1 : 0], (2 ** FRAC_SZ) - ``VECTOR_NAME[-1 : -FRAC_SZ]