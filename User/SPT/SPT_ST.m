function [varargout]=SPT_ST(x)
%x为输入矩阵  y位转置后输出的矩阵
[m,n]=size(x);
if m>n
varargout{1}=x';
else
varargout{1}=x;
end
[m,n]=size(varargout{1});
if nargout==3
   varargout{2}=m;
   varargout{3}=n;
end

