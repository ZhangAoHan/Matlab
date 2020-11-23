function out_data=SA_K_Mean(data)
%% K均值聚类方法 分2类（用来去除噪声数据）
%data:向量
[~,n]=size(data);
out_data=zeros(2,n);
Z(1)=min(data);
Z(2)=max(data);
for i=1:n
    
end