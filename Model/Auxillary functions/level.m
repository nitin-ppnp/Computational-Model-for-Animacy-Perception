function [result] = level(array, lbound, divisor)
% level(array, lbound, divisor);
%          returns 'result' computed from 'array' having the same dimension
%          where all values bigger than 'lbound' are divided by 'divisor'
%          and all other values are set to zero.
% Author: Leonid Fedorov ; Nitin Saini
% Last modified: 12/12/2017

result = array;
result(result<lbound)=0;
result(result>lbound) = result(result>lbound)/divisor;

return
