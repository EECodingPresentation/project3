function al=bitrate(I0)
I0=double(I0);
I=zeros(128,64);
for i=1:64
    I(:,i)=I0(:,2*i-1)+I0(:,2*i)/1000;%将第二个符号变成小数部分，实现用一个实数表示两个符号
end
%其余代码和单符号霍夫曼编码count_pixels.m一致，注释就不写了。。。
%I=im2double(I);
  tbl=tabulate(I(:));
  value0=[];
  counts=[];
  %num0=1000;%编码个数
  for i=1:length(tbl(:,1))
      if(tbl(i,2)>0)
          value0=[value0,tbl(i,1)];
          counts=[counts,tbl(i,2)];
      end
  end
  freq=counts/64/128;
data=[freq;value0].';
sdata0=sortrows(data,1);
num=length(value0);
sdata=sdata0(length(value0)-num+1:length(value0),:);
value=sdata(:,2);
%%
code=zeros(length(value),length(value));
huff=zeros(length(value),length(value));
huff(:,2)=sdata(:,1);
huff(:,3)=1:length(value);
huff(:,1)=huff(:,1)+1;
while length(huff(:,1))>1
    for i=1:huff(2,1)
        code(huff(2,2+i),2+code(huff(2,2+i),1))=1;
        code(huff(2,2+i),1)=code(huff(2,2+i),1)+1;
    end
     for i=1:huff(1,1)
        code(huff(1,2+i),2+code(huff(1,2+i),1))=0;
        code(huff(1,2+i),1)=code(huff(1,2+i),1)+1;
    end
    huff(2,2)=huff(2,2)+huff(1,2);
    huff(2,3+huff(2,1):2+huff(2,1)+huff(1,1))=huff(1,3:2+huff(1,1));
    huff(2,1)=huff(2,1)+huff(1,1);
    huff=huff(2:length(huff(:,1)),:);
     huff=sortrows( huff,2);
end
    %%
fid=fopen('A.txt','w');
for i=1:length(value)
    fprintf(fid,'%d ',floor(value(i)));
    fprintf(fid,'%d ',round(1000*(value(i)-floor(value(i)))));
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
al=code(:,1).'*sdata(:,1);
p=sdata0(:,1);
H=0;
for i=1:length(p)
    H=H+p(i)*log2(p(i));
end
H=-H;
end

