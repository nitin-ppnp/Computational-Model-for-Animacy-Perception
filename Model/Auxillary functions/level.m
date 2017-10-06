function [result] = level(array, lbound, divisor)
% level(array, lbound, divisor);
%          returns 'result' computed from 'array' having the same dimension
%          where all values bigger than 'lbound' are divided by 'divisor'
%          and all other values are set to zero.
% 
% % % 
% URL to see the formula: http://mathurl.com/pm4xz8s
% TeX to see the formula: 
%  b_i= \begin{cases}
%   & \dfrac{a_i}{\beta}\;{if }\; a_i > \lambda\\
%   & 0 \;{if }\; a_i\leq \lambda  
% \end{cases}
% % % 

%%
% result = (array - lbound).*(array > lbound / divisor);          %%% Nitin

%% Nitin
result = array;
result(result<lbound)=0;
result(result>lbound) = result(result>lbound)/divisor;

return
