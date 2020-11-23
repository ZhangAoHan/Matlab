%% �������ʱ�����е�������z=H(x|y)=H��y,x��-H(y)    H(y|x)=H(x,y)-H(x)
function H_x_y=SA_CE(x,y)
    n=length(x);
    %�ȼ���H(y,x)=H(x,y)
    H_xy=SA_COME(x,y);
    %�ټ���H(y)
    k=max(max(x),max(y));
    My = sparse(1:n,y,1,n,k,n)/n;
    Py = nonzeros(mean(My,1));
    H_y=-dot(Py,log2(Py));
    
    H_x_y=H_xy-H_y;
    H_x_y=max(0,H_x_y);
end