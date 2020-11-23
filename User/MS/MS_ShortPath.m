function [varargout]=MS_ShortPath(a,varargin)
%�����·���ĳ��÷�����Floyd,Dijkstra
%aΪԭʼ��Ϣ����start_pointΪ��ʼ�㣬end_pointΪ�ս��(���߱���Ϊ���֣������ִ����)
%������������ֹһ������������뷽�����ƣ�Floyd��Dijkstra
    if nargin==1
        methon_string='Floyd'; %Ĭ�Ϸ���
    elseif nargin==2
        methon_string=varargin{end};
        if ~ischar(methon_string)
            error("������ʹ�õķ���");
            return 
        end
    elseif nargin==3
        methon_string=varargin{end};
         if ~strcmpi(methon_string,'Dijkstra')
            error("3������ֻ������Dijkstra�㷨");
            return ;
        end
        varargin{end}='';
    elseif nargin==4
        methon_string=varargin{end};
         if ~strcmpi(methon_string,'Dijkstra')
            error("4������ֻ������Floyd�㷨");
            return ;
        end
        varargin{end}='';
    else
        error("Ŀǰ��֧�ֳ���4������");
        return ;
    end
    if strcmpi(methon_string,'Floyd')
        [D,R,d_se,path_n]=Floyd(a,varargin{:}); %��� D RΪ����
        varargout{1}=D;
        varargout{2}=R;
        if nargout>2
            varargout{3}=d_se;
            varargout{4}=path_n;
        end       
    elseif strcmpi(methon_string,'Dijkstra') %��� D RΪ������
        [D,R,d_se,path_n]=Dijkstra(a,varargin{:});
        varargout{1}=D;
        varargout{2}=R;
        if nargout>2
            varargout{3}=d_se;
            varargout{4}=path_n;
        end
    end
    
end
%% Floyd�������·��
%�������a����Ҳ�ǶԳƾ���
%ע�ͣ����DΪһ���Գƾ��󣬼�D(i,j)=D(j,i)����D(i,j)��ʾ��i����j����̾���ֵ
%ԭ��d(i,j)=min(d(i,k)+d(k,j),d(i,j))�����Ӷȣ�����.^3=n.^3,������n���㣬��Ҫ����n.^3��
function [D,R,d_se,path_n]=Floyd(a,varargin)
    d_se=0;
    n=size(a,1);
    path_n=zeros(1,n);%�����Զ�Ķ�����Ҫ�������е�
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
    if nargin>2 %��Ҫ����ָ����ľ���·���;���
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
        path_n=path_n(1:ii_n); %�������ڵ�0
%         varargout{3}=d_se; %����ָ����������С����
%         varargout{4}=path_n;%����ָ����������С�����·��
    end
end
%% Dijkstra�㷨�������һ���ڵ㵽�������нڵ����̾����·��������ڵ�Ϊ1��λ�ã�
%�������a�ĸ�ʽ��Floyd��һ��  varargin{1}=end_point
function [D,R,d_se,path_n]=Dijkstra(a,varargin)   
    d_se=0;
    n=size(a,1);
    path_n=zeros(1,n);%�����Զ�Ķ�����Ҫ�������е�
    pb(1:length(a))=0;                                 %pb  ��¼�Ƿ���     
    pb(1)=1;   
    index1=1;                                           %index1  ��¼���˳��
    R=ones(1,length(a));                           %index2  ��¼��ŵ�ǰһ���ţ�  �������¼��·��     
    D(1:length(a))=inf;                                             %d  �г�ʼΪ  inf  �������  11  ���еĽ���滻     
    D(1)=0;                                                                     %  ��һ�����㵽����ľ�����Ȼ��  0   
    temp=1;                                                                     %  ��ʼ�ɵ�һ�㿪ʼ¼��     
    while sum(pb)<size(a,2)         %  ��ֹ����Ϊ  pb  �еĵ�ȫ����ţ���  1  ��ʾ�ѱ�ţ�  0  ��ʾ  δ��ţ�                 
        tb=find(pb==0);                                                         %  �ҳ�δ��ŵĵ�����                 
        D(tb)=min(D(tb),D(temp)+a(temp,tb));      %  �滻����Ĭ��  1  �ŵ�Ϊʼ����                 
        tmpb=find(D(tb)==min(D(tb)));                        %  �ҳ���С�ľ�����б��                 
        temp=tb(tmpb(1));                           %  ͬ�Ͽ����ж�����Ȩֵ�ﵽ��С��  ��ȡ  1  �ŵ��Ӧ  �ĵ��                 
        pb(temp)=1;                                                                     %  ��ʽ���                 
        index1=[index1,temp];         %  ����ŵĵ����  index1  �У�  ���´�������ʧȥ��ѡ�ʸ�                 
        index=index1(find(D(index1)==D(temp)-a(temp,index1)));%  ���³���ȫΪ�ҵ�·�ɵ�����                 
        if length(index)>=2                     
            index=index(1);            
        end
        R(temp)=index;   
    end
    %����ص�������С���뼰·��
    if nargin>2 %��Ҫ������㵽ָ����ľ���·���;���
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
        path_n=path_n(ii_n:n); %�������ڵ�0
    end
end
