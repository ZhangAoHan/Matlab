function [ output_args ] = getdata2( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
alldata = zeros(25,200);                  %����һ�������ڴ�����������
u = 1;                                    %����alldataָ��λ��ʹ��
for i=0:9
     for j=0:19;
        n1 = 'E:\ѧϰ\ģʽʶ��\��ҵ5\demo\';
        n2 = num2str(i);                   %i
        n3 = '\';
        n4 = num2str(j);                   %������ת�����ַ���
        n5 = '.jpg';
        s1 = strcat(n1,n2,n3,n4,n5);    %����ַ���ļ�������ƴ��һ��
   
        Demoimg = imread(s1);
        Demoimg = rgb2gray(Demoimg);      %ת��Ϊ�Ҷ�ͼ��
        Demoimg = im2bw(Demoimg);         %ת��Ϊ2ֵͼ��
      %  figure(2);
      % imshow(Demoimg)
        
        rs = size(Demoimg);
        rows = rs(1);                      %ͼ������
        columns = rs(2);                   %ͼ������
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %����ͼ��������ͼ�����ұ߽�Ļ�ȡ
        s = 1;                             % s���ھ�������д��
        for x=1:columns
             rows_sum= 0;
            
            for y=1:rows
                rows_sum = rows_sum+Demoimg(y,x);
            end
            if(rows_sum ~= rows)                %�жϵ����ֺ�ɫ��ʱ���Ӧ����
                xc(s) = x;
                s = s+1;
            end
        end
        xc = xc';
        Left = min(xc) ;                     %LΪ��߽��Ӧ����
        Right = max(xc)  ;                     %RΪ�ұ߽��Ӧ����
        xc = 0;                                 %���xc�е�����
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%����ͼ��������ͼ�����±߽�Ļ�ȡ
        s = 1;                             % s���ھ�������д��
        for y=1:rows
            columns_sum = 0;
            
            for x=1:columns
                columns_sum = columns_sum+Demoimg(y,x);
            end
            if(columns_sum ~= columns)                %�жϵ����ֺ�ɫ��ʱ���Ӧ����
                yc(s) = y;
                s = s+1;
            end
        end
        yc = yc';
        Up = min(yc);                  %UpΪ�ϱ߽��Ӧ����
        Down = max(yc);                  %DownΪ�±߽��Ӧ����
        yc = 0;                        %���yc�е�����
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %����ͼ���и�
        image = imcrop(Demoimg,[Left Up Right-Left+1  Down-Up+1  ]);
        %image Ϊ�����������ֵ���Сͼ��
        %figure(3);
        %imshow(image)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %��image�ֳ�5x5������
        xspace = floor((Right-Left+1)/5); %�����ķָ�ȣ���ǰȡ��
        yspace = floor((Down-Up+1)/5);     %����ߵķָ�ȣ���ǰȡ��
        
        %��¼ÿ�������е�����
        %%%��¼˳��ÿһ�е�5С������Ҽ�¼���ٻ�����һ�е�5С������Ҽ�¼
        everytote = xspace * yspace;  %ÿһ������ļ�¼������
        
        for m=0:4
            for n=0:4
                r1 = m*yspace+1;
                r2 = (m+1)*yspace;     %r1Ϊ�е���㣬r2Ϊ�е��յ�
                c1 = n*xspace+1;
                c2 = (n+1)*xspace;     %c1Ϊ�е���㣬c2Ϊ�е��յ�
        T = image(r1:r2,c1:c2);
        whitesum = sum(sum(T)) ;        %ͳ��ÿ�������а�ɫ����ռ�ĸ���
        blackper = 1-(whitesum/everytote);  %�����ɫ��ռ�ٷֱ�
        alldata(u) = blackper;          %�ļ���ͷ�����˸þ����u����
        u = u+1;
            end
        end
     end
    
   
end

        newalldata = alldata';
        newalldata(1:200,26:29) = 0;
        newalldata(21:40,29) = 1;
        newalldata(41:80,28) = 1;
        newalldata(61:80,29) = 1;
        newalldata(81:160,27) = 1;
        newalldata(121:160,28) = 1;
        newalldata(101:120,29) = 1;
        newalldata(141:160,29) = 1;
        newalldata(161:200,26) = 1;
        newalldata(181:200,29) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����Ƕ����ݿ����������������ȡ
 for k=1:10
         kbegin = 20*(k-1)+1;
         kend = 20*k;
         pattern(k).feature = newalldata(kbegin:kend,1:29);
     end
     save('Data2.mat','pattern');




end

