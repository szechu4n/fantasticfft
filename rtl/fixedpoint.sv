// creates variable-length constant with provided integer and fractional components
`define CREATE_CONSTANT_FIXED_POINT(INT_SZ, FRAC_SZ, INT_CONST, FRAC_CONST) \
{ INT_SZ'(INT_CONST), FRAC_CONST, {(FRAC_SZ - $bits(FRAC_CONST)){ 0 }}}
