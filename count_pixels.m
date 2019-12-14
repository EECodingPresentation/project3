%实现单符号霍夫曼编码
clear;
clc;
I=imread('untitle.bmp');
I=double(I);
%I=im2double(I);
  tbl=tabulate(I(:));%统计各个符号的频次
  value0=[];%灰度值
  counts=[];%符号
  %num0=100;%编码个数
  for i=1:length(tbl(:,1))%除去从未使用过的灰度值
      if(tbl(i,2)>0)
          value0=[value0,tbl(i,1)];
          counts=[counts,tbl(i,2)];
      end
  end
  freq=counts/128/128;%计算频率
data=[freq;value0].';
sdata0=sortrows(data,1);%按照频率升序排列数据
num=length(value0);
sdata=sdata0(length(value0)-num+1:length(value0),:);
value=sdata(:,2);%按照出现频率升序排列的灰度值
%%
code=zeros(length(value),length(value));%编码结果矩阵
huff=zeros(length(value),length(value));%霍夫曼编码矩阵
huff(:,2)=sdata(:,1);
huff(:,3)=1:length(value);
huff(:,1)=huff(:,1)+1;
while length(huff(:,1))>1%循环合并
    for i=1:huff(2,1)%写入编码
        code(huff(2,2+i),2+code(huff(2,2+i),1))=1;
        code(huff(2,2+i),1)=code(huff(2,2+i),1)+1;
    end
     for i=1:huff(1,1)
        code(huff(1,2+i),2+code(huff(1,2+i),1))=0;
        code(huff(1,2+i),1)=code(huff(1,2+i),1)+1;
    end
    huff(2,2)=huff(2,2)+huff(1,2);%概率最小的两个合并
    huff(2,3+huff(2,1):2+huff(2,1)+huff(1,1))=huff(1,3:2+huff(1,1));
    huff(2,1)=huff(2,1)+huff(1,1);
    huff=huff(2:length(huff(:,1)),:);
     huff=sortrows( huff,2);%重新排序
end
    %%
fid=fopen(['A.txt'],'w');%将编码结果写入txt中
for i=1:length(value)
    fprintf(fid,'%d ',value(i));
    for j=1:code(i,1)
fprintf(fid,'%d',code(i,code(i,1)-j+2));  
    end
    if(i==1)
            fprintf(fid,'1');
    end
    fprintf(fid,'\n');  
end
 for j=1:code(1,1)
fprintf(fid,'%d',code(1,code(1,1)-j+2));  
 end
 fprintf(fid,'0');
fclose(fid);
a=zeros(length(value),1);
a(1)=1;
al=(code(:,1)+a).'*sdata(:,1)%平均编码长度
p=sdata0(:,1);
H=0;
for i=1:length(p)
    H=H+p(i)*log2(p(i));
end
H=-H
    

