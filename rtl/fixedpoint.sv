// creates variable-length constant with provided integer and fractional components
`define CREATE_CONSTANT_FIXED_POINT(INT_SZ, FRAC_SZ, INT_CONST, FRAC_CONST) \
{ INT_SZ'(INT_CONST), FRAC_CONST, {(FRAC_SZ - $bits(FRAC_CONST)){ 0 }}}

`define GET_FLOAT_REPRESENTATION_FIXED_POINT(FRAC_SIZE, FP_NUM) \
(real'(FP_NUM) / (2.0 ** (FRAC_SIZE)))