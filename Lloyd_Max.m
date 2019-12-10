img=imread('lena_128_bw.bmp');%图片
L=8;%区间个数
freq=zeros(1,256);%频率近似概率
[m,n]=size(img);
for x=1:m
    for y=1:n
        freq(img(x,y)+1)=freq(img(x,y)+1)+1;
    end
end
freq=freq/(m*n);
freq=freq+10^(-4)/(m*n);
r=floor(rand(1,L)*256);%初始重建电平
pre=r;
r=sort(r);%重建电平
d=zeros(1,L-1);%判决门限
%约定，区间量化为左闭右开
while 1
    %更新判决门限
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
