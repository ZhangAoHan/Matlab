function [varargout]=SPT_ST(x)
%xΪ�������  yλת�ú�����ľ���
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

