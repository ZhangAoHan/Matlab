function [ output_args ] = identify( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%������ͼƬ����������ȡ
  %input_args = imread('imgtest.jpg');
  newimg = rgb2gray(input_args);      %������ͼ��ת��Ϊ�Ҷ�ͼ��
  newimg = im2bw(newimg);         %ת��Ϊ2ֵͼ��
  
  rs = size(newimg);
  rows = rs(1);                      %ͼ������
  columns = rs(2);                   %ͼ������
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %����ͼ��������ͼ�����ұ߽�Ļ�ȡ
  s = 1;                             % s���ھ�������д��
  for x=1:columns
      rows_sum= 0;
            
      for y=1:rows
          rows_sum = rows_sum+newimg(y,x);
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
           columns_sum = columns_sum+newimg(y,x);
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
    image = imcrop(newimg,[Left Up Right-Left+1  Down-Up+1  ]);
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
    newdata = zeros(25,1);
    ns = 1;                           
    for m=0:4
        for n=0:4
            r1 = m*yspace+1;
            r2 = (m+1)*yspace;     %r1Ϊ�е���㣬r2Ϊ�е��յ�
            c1 = n*xspace+1;
            c2 = (n+1)*xspace;     %c1Ϊ�е���㣬c2Ϊ�е��յ�
        T = image(r1:r2,c1:c2);
        whitesum = sum(sum(T)) ;        %ͳ��ÿ�������а�ɫ����ռ�ĸ���
        blackper = 1-(whitesum/everytote);  %�����ɫ��ռ�ٷֱ�
        newdata(ns) = blackper;             %��¼��д�����ֵ���������
        ns = ns+1;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_args = newdata;


end

