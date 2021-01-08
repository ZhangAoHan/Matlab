function   ImagesToFrame 


% 这里填写bmp文件保存的位置，生成的ImageData.mat文件也将保存在这个路径下。
thePath = 'd:\matlab6.1\work\BMP' ;

% 构造bmp文件的名称列表，如果要增加文件，可以直接将增加的图片文件名添加到这个列表里面就行了。
% 图片文件的扩展名也可以为jpg。
BMPFileNames = { '1.bmp'; '2.bmp'; '3.bmp'; ...
    '4.bmp'; '5.bmp'; '6.bmp';'7.bmp';...
    '8.bmp';'9.bmp';'10.bmp'; } ;

for num = 1: length( BMPFileNames ) 
    
    ReadImageName = BMPFileNames{num} ;
    
    ReadImageName = fullfile( thePath , ReadImageName  ) ;
    ReadImageData = imread( ReadImageName ) ;
    
    for num1 = 1:3
        ReadImageData(:,:,num1) = flipud( ReadImageData(:,:,num1) ) ;
    end
    ImageData(num) = im2frame(ReadImageData, []) ;
    
end

% 将ImageData.mat文件保存在bmp那个路径下。
save ImageData ImageData ;



