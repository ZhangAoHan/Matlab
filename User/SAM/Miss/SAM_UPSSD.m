function UPSSD_Output= SAM_UPSSD(y,Fs)
%���룺ԭ�źš�����Ƶ�� 
y=y(:)'; %�������ź�ǿ�Ʊ�Ϊ������
y_num=length(y);
IMF_Num=floor(log2(y_num));  %�������źŵ������������������IMF����
res = y;  %��ʼ���в�
%��ʼ������
ampSin0=0.2; %����������Ӱ������
numPhase=16;

countMode = 1;
UPSSD_Output=zeros(IMF_Num,y_num);  %�������Ĵ�С
for times=1:IMF_Num-1
    ampSin = ampSin0*std(res);
    numShift = 2^(times);
    if (numPhase > numShift)
        numPhase = min(numPhase,numShift);
    end
    ds = numShift/numPhase;
    mediaArray=Noise_Singer(2*y_num,ampSin,numShift/2); %�������������ź�
    sumWrk = zeros(1,y_num);
    countShift = 0;
    for i=1:ds:numShift
        media =  mediaArray(i:i+y_num-1) ;
        countShift = countShift + 1;
        sy = res + media;  %�ϳɴ��ֽ��ź�
        subImf = SAM_SSD(sy,Fs);
        [m,n]=size(subImf);
        if m>n        %ǿ��ת��Ϊ��������Ϊ��Ч�����ľ���
            subImf=subImf';
        end
        subImf(1,:) = subImf(1,:) - media;
        sumWrk = sumWrk +subImf(1,:);
    end
    UPSSD_Output(countMode,:) = sumWrk/countShift;
    res = res - UPSSD_Output(countMode,:);
    countMode = countMode + 1;
end
UPSSD_Output(countMode,:) = res;  %����IMF_Num�����    ���һ��Ϊ�������
end

function fy=Noise_Singer(ndata,a,hp)

t=0:2*hp-1;  %0-�������ڳ���
f = 0.5/hp;  %�����������ڵĵ���  ��Ƶ
yt = cos(2*pi*f*t);
yt = a*yt;

nyt = length(yt);
no = ceil(ndata/nyt); %����������

fy = repmat(yt,1,no);
fy = fy(1:ndata);
end
