%ʵ�ֵ����Ż���������
clear;
clc;
I=imread('untitle.bmp');
I=double(I);
%I=im2double(I);
  tbl=tabulate(I(:));%ͳ�Ƹ������ŵ�Ƶ��
  value0=[];%�Ҷ�ֵ
  counts=[];%����
  %num0=100;%�������
  for i=1:length(tbl(:,1))%��ȥ��δʹ�ù��ĻҶ�ֵ
      if(tbl(i,2)>0)
          value0=[value0,tbl(i,1)];
          counts=[counts,tbl(i,2)];
      end
  end
  freq=counts/128/128;%����Ƶ��
data=[freq;value0].';
sdata0=sortrows(data,1);%����Ƶ��������������
num=length(value0);
sdata=sdata0(length(value0)-num+1:length(value0),:);
value=sdata(:,2);%���ճ���Ƶ���������еĻҶ�ֵ
%%
code=zeros(length(value),length(value));%����������
huff=zeros(length(value),length(value));%�������������
huff(:,2)=sdata(:,1);
huff(:,3)=1:length(value);
huff(:,1)=huff(:,1)+1;
while length(huff(:,1))>1%ѭ���ϲ�
    for i=1:huff(2,1)%д�����
        code(huff(2,2+i),2+code(huff(2,2+i),1))=1;
        code(huff(2,2+i),1)=code(huff(2,2+i),1)+1;
    end
     for i=1:huff(1,1)
        code(huff(1,2+i),2+code(huff(1,2+i),1))=0;
        code(huff(1,2+i),1)=code(huff(1,2+i),1)+1;
    end
    huff(2,2)=huff(2,2)+huff(1,2);%������С�������ϲ�
    huff(2,3+huff(2,1):2+huff(2,1)+huff(1,1))=huff(1,3:2+huff(1,1));
    huff(2,1)=huff(2,1)+huff(1,1);
    huff=huff(2:length(huff(:,1)),:);
     huff=sortrows( huff,2);%��������
end
    %%
fid=fopen(['A.txt'],'w');%��������д��txt��
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
al=(code(:,1)+a).'*sdata(:,1)%ƽ�����볤��
p=sdata0(:,1);
H=0;
for i=1:length(p)
    H=H+p(i)*log2(p(i));
end
H=-H
    

