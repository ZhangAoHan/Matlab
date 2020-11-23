%% 计算二个时间序列的联合熵z=H(x,y)=H(y,x)
%以x,y的序列排序  序号为运算序列
function H_xy=SA_COME(x,y)
    x=x(:)';
    y=y(:)';
    n=length(x);
    x_xl = unique(x);  
    y_xl = unique(y);
    %计算P(x,y)
    H_xy=0;
    for i=x_xl    
        for j=y_xl
            x_num=find(x==i)
            y_num=find(y==j)
            xy_num=intersect(x_num,y_num);
            p_xy=length(xy_num)/n
            H_xy=H_xy-p_xy*log2(p_xy+eps)
        end
    end
 
end