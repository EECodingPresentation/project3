img=imread('lena_128_bw.bmp');%ͼƬ
L=8;%�������
freq=zeros(1,256);%Ƶ�ʽ��Ƹ���
[m,n]=size(img);
for x=1:m
    for y=1:n
        freq(img(x,y)+1)=freq(img(x,y)+1)+1;
    end
end
freq=freq/(m*n);
freq=freq+10^(-4)/(m*n);
r=floor(rand(1,L)*256);%��ʼ�ؽ���ƽ
pre=r;
r=sort(r);%�ؽ���ƽ
d=zeros(1,L-1);%�о�����
%Լ������������Ϊ����ҿ�
while 1
    %�����о�����
    for l=1:L-1
       d(l)=round((r(l)+r(l+1))/2);
    end
    pre=r;
    for l=1:L
       if l==1
           r(1)=sum((0:d(l)).*freq(1:d(l)+1))/sum(freq(1:d(l)+1));
       elseif l==L
           r(L)=sum((d(l-1):255).*freq(d(l-1)+1:256))/sum(freq(d(l-1)+1:256));
       else
           r(l)=sum((d(l-1):d(l)).*freq(d(l-1)+1:d(l)+1))/sum(freq(d(l-1)+1:d(l)+1));
       end
    end
    r=round(r);
    if(pre==r)
        disp(round(d));
        break;
    end 
end
