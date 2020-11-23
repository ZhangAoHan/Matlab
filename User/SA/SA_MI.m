%% 计算二个时间序列的互信息
function MI=SA_MI(x,y)
    %互信息=H(x)+H(y)-H(x,y)
    x=x(:)';
    y=y(:)';
    H_x=SA_E(x)
    H_y=SA_E(y)
    H_xy=SA_COME(x,y);
    MI=H_x+H_y-H_xy;
end

