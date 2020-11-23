function UPSSD_Output= SAM_UPSSD(y,Fs)
%输入：原信号、采样频率 
y=y(:)'; %将输入信号强制变为行向量
y_num=length(y);
IMF_Num=floor(log2(y_num));  %由输入信号的数量来决定输出多少IMF分量
res = y;  %初始化残差
%初始化参数
ampSin0=0.2; %辅助噪声的影响因子
numPhase=16;

countMode = 1;
UPSSD_Output=zeros(IMF_Num,y_num);  %输出矩阵的大小
for times=1:IMF_Num-1
    ampSin = ampSin0*std(res);
    numShift = 2^(times);
    if (numPhase > numShift)
        numPhase = min(numPhase,numShift);
    end
    ds = numShift/numPhase;
    mediaArray=Noise_Singer(2*y_num,ampSin,numShift/2); %参数辅助噪声信号
    sumWrk = zeros(1,y_num);
    countShift = 0;
    for i=1:ds:numShift
        media =  mediaArray(i:i+y_num-1) ;
        countShift = countShift + 1;
        sy = res + media;  %合成待分解信号
        subImf = SAM_SSD(sy,Fs);
        [m,n]=size(subImf);
        if m>n        %强制转换为以行向量为有效向量的矩阵
            subImf=subImf';
        end
        subImf(1,:) = subImf(1,:) - media;
        sumWrk = sumWrk +subImf(1,:);
    end
    UPSSD_Output(countMode,:) = sumWrk/countShift;
    res = res - UPSSD_Output(countMode,:);
    countMode = countMode + 1;
end
UPSSD_Output(countMode,:) = res;  %共有IMF_Num行输出    最后一行为残余分量
end

function fy=Noise_Singer(ndata,a,hp)

t=0:2*hp-1;  %0-索引周期长度
f = 0.5/hp;  %索引长度周期的导数  低频
yt = cos(2*pi*f*t);
yt = a*yt;

nyt = length(yt);
no = ceil(ndata/nyt); %朝无穷大近似

fy = repmat(yt,1,no);
fy = fy(1:ndata);
end
