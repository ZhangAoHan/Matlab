function [ output_args ] = identify( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%对输入图片进行特征提取
  %input_args = imread('imgtest.jpg');
  newimg = rgb2gray(input_args);      %把输入图像转换为灰度图像
  newimg = im2bw(newimg);         %转换为2值图像
  
  rs = size(newimg);
  rows = rs(1);                      %图像行数
  columns = rs(2);                   %图像列数
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %进行图像中数字图形左右边界的获取
  s = 1;                             % s用于矩阵数据写入
  for x=1:columns
      rows_sum= 0;
            
      for y=1:rows
          rows_sum = rows_sum+newimg(y,x);
      end
      if(rows_sum ~= rows)                %判断当出现黑色的时候对应的列
           xc(s) = x;
           s = s+1;
      end
   end
   xc = xc';
   Left = min(xc) ;                     %L为左边界对应的列
   Right = max(xc)  ;                     %R为右边界对应的列
   xc = 0;                                 %清空xc中的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%进行图像中数字图形上下边界的获取
   s = 1;                             % s用于矩阵数据写入
   for y=1:rows
       columns_sum = 0;
            
       for x=1:columns
           columns_sum = columns_sum+newimg(y,x);
       end
       if(columns_sum ~= columns)                %判断当出现黑色的时候对应的行
            yc(s) = y;
            s = s+1;
        end
    end
    yc = yc';
    Up = min(yc);                  %Up为上边界对应的行
    Down = max(yc);                  %Down为下边界对应的行
    yc = 0;                        %清空yc中的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%进行图像切割
    image = imcrop(newimg,[Left Up Right-Left+1  Down-Up+1  ]);
 %image 为包含完整数字的最小图像
 %figure(3);
 %imshow(image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将image分成5x5的网格
    xspace = floor((Right-Left+1)/5); %计算宽的分割长度，向前取整
    yspace = floor((Down-Up+1)/5);     %计算高的分割长度，向前取整
        
%记录每个网格中的像素
%%%记录顺序按每一行的5小格从左到右记录，再换到下一行的5小格从左到右记录
    everytote = xspace * yspace;  %每一个网格的记录点总数
    newdata = zeros(25,1);
    ns = 1;                           
    for m=0:4
        for n=0:4
            r1 = m*yspace+1;
            r2 = (m+1)*yspace;     %r1为行的起点，r2为行的终点
            c1 = n*xspace+1;
            c2 = (n+1)*xspace;     %c1为列的起点，c2为列的终点
        T = image(r1:r2,c1:c2);
        whitesum = sum(sum(T)) ;        %统计每个网格中白色点所占的个数
        blackper = 1-(whitesum/everytote);  %求出黑色所占百分比
        newdata(ns) = blackper;             %记录新写入数字的特征数据
        ns = ns+1;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_args = newdata;


end

