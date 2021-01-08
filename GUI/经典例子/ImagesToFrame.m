function   ImagesToFrame 


% ������дbmp�ļ������λ�ã����ɵ�ImageData.mat�ļ�Ҳ�����������·���¡�
thePath = 'd:\matlab6.1\work\BMP' ;

% ����bmp�ļ��������б����Ҫ�����ļ�������ֱ�ӽ����ӵ�ͼƬ�ļ�����ӵ�����б���������ˡ�
% ͼƬ�ļ�����չ��Ҳ����Ϊjpg��
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

% ��ImageData.mat�ļ�������bmp�Ǹ�·���¡�
save ImageData ImageData ;



