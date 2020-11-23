function [varargout]=MS_ShortPath(a,varargin)
%求最短路径的常用方法：Floyd,Dijkstra
%a为原始信息矩阵，start_point为起始点，end_point为终结点(二者必须为数字，用数字代替点)
%如果输入参数不止一个，则必须输入方法名称：Floyd或Dijkstra
    if nargin==1
        methon_string='Floyd'; %默认方法
    elseif nargin==2
        methon_string=varargin{end};
        if ~ischar(methon_string)
            error("请输入使用的方法");
            return 
        end
    elseif nargin==3
        methon_string=varargin{end};
         if ~strcmpi(methon_string,'Dijkstra')
            error("3个参数只适用于Dijkstra算法");
            return ;
        end
        varargin{end}='';
    elseif nargin==4
        methon_string=varargin{end};
         if ~strcmpi(methon_string,'Dijkstra')
            error("4个参数只适用于Floyd算法");
            return ;
        end
        varargin{end}='';
    else
        error("目前不支持超过4个参数");
        return ;
    end
    if strcmpi(methon_string,'Floyd')
        [D,R,d_se,path_n]=Floyd(a,varargin{:}); %输出 D R为矩阵
        varargout{1}=D;
        varargout{2}=R;
        if nargout>2
            varargout{3}=d_se;
            varargout{4}=path_n;
        end       
    elseif strcmpi(methon_string,'Dijkstra') %输出 D R为行向量
        [D,R,d_se,path_n]=Dijkstra(a,varargin{:});
        varargout{1}=D;
        varargout{2}=R;
        if nargout>2
            varargout{3}=d_se;
            varargout{4}=path_n;
        end
    end
    
end
%% Floyd法求最短路径
%输入矩阵a必须也是对称矩阵
%注释：结果D为一个对称矩阵，即D(i,j)=D(j,i)。而D(i,j)表示点i到点j的最短距离值
%原理：d(i,j)=min(d(i,k)+d(k,j),d(i,j))。复杂度：点数.^3=n.^3,即，有n个点，就要运行n.^3次
function [D,R,d_se,path_n]=Floyd(a,varargin)
    d_se=0;
    n=size(a,1);
    path_n=zeros(1,n);%相距最远的二点需要遍历所有点
    D=a;
    for i=1:n
       for j=1:n
         R(i,j)=j;
       end
    end
    for k=1:n
       for i=1:n
          for j=1:n
             if D(i,k)+D(k,j)<D(i,j)
                D(i,j)=D(i,k)+D(k,j);
                R(i,j)=R(i,k);
             end
          end
       end
    end
%     varargout{1}=D;
%     varargout{2}=R;
    if nargin>2 %需要给出指定点的具体路径和距离
        start_point=varargin{1};
        end_point=varargin{2};
        d_se=D(start_point,end_point);
        ii_n=2;
        path_n(1)=start_point;
        while 1
            path_n(ii_n)=R(start_point,end_point);
            if path_n(ii_n)==end_point;
                break;
            else
                start_point=path_n(ii_n);
                ii_n=ii_n+1;
            end
        end 
        path_n=path_n(1:ii_n); %减掉多于的0
%         varargout{3}=d_se; %给出指定二点间的最小距离
%         varargout{4}=path_n;%给出指定二点间的最小距离的路径
    end
end
%% Dijkstra算法计算的是一个节点到其它所有节点的最短距离和路径（这个节点为1号位置）
%输入矩阵a的格式与Floyd法一样  varargin{1}=end_point
function [D,R,d_se,path_n]=Dijkstra(a,varargin)   
    d_se=0;
    n=size(a,1);
    path_n=zeros(1,n);%相距最远的二点需要遍历所有点
    pb(1:length(a))=0;                                 %pb  记录是否标号     
    pb(1)=1;   
    index1=1;                                           %index1  记录标号顺序
    R=ones(1,length(a));                           %index2  记录标号的前一结点号，  便于最后录找路径     
    D(1:length(a))=inf;                                             %d  中初始为  inf  ，最后用  11  步中的结果替换     
    D(1)=0;                                                                     %  第一个顶点到自身的距离自然是  0   
    temp=1;                                                                     %  初始由第一点开始录找     
    while sum(pb)<size(a,2)         %  终止条件为  pb  中的点全部标号（用  1  表示已标号，  0  表示  未标号）                 
        tb=find(pb==0);                                                         %  找出未标号的点向量                 
        D(tb)=min(D(tb),D(temp)+a(temp,tb));      %  替换过程默认  1  号点为始发点                 
        tmpb=find(D(tb)==min(D(tb)));                        %  找出最小的距离进行标号                 
        temp=tb(tmpb(1));                           %  同上可能有多个点的权值达到最小，  故取  1  号点对应  的点号                 
        pb(temp)=1;                                                                     %  正式标号                 
        index1=[index1,temp];         %  将标号的点归入  index1  中，  在下次搜索中失去候选资格                 
        index=index1(find(D(index1)==D(temp)-a(temp,index1)));%  以下程序全为找到路由的向量                 
        if length(index)>=2                     
            index=index(1);            
        end
        R(temp)=index;   
    end
    %求解特点二点的最小距离及路径
    if nargin>2 %需要给出起点到指定点的具体路径和距离
        start_point=1;
        end_point=varargin{1};
        d_se=D(1,end_point);
        ii_n=n-1;
        path_n(end)=end_point;
        while 1
            path_n(ii_n)=R(start_point,end_point);
            if path_n(ii_n)==1
                break;
            else
                end_point=path_n(ii_n);
                ii_n=ii_n-1;
            end
        end 
        path_n=path_n(ii_n:n); %减掉多于的0
    end
end
