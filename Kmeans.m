close all,clear all,clc;
img=imread('lena_128_bw.bmp');%ͼƬ
L=32;%�������
[m,n]=size(img);
img=reshape(img,1,m*n);

C=[0    84   138   164    99   208   189     0   145    91    39   153   198   107     0    63    47    71   114   132   121 216   127   224   159     0    54   174    77   170   181     0];
%floor(rand(1,L)*256);%���codebook
%[101    76   180   206    49   140   123   157];
%175   102   191   130    88   220   211   142   161   151    52    74   117    62   202    43
%39.8321
% 0    84   138   164    99   208   189     0   145    91    39   153   198   107     0    63    47    71   114   132   121
% 
% 
%    216   127   224   159     0    54   174    77   170   181     0
%    44.7596

while 1%��ͣ����
    %�����������������ĵľ��룻
    distance = euclidean_distance(img, C);
    [~, index] = sort(distance, 2, 'ascend');
    
    C_new = C;%����codebook
    for k=1:L%ÿ������Ⱥ
        oneclass=img(index(:,1)==k);%����
        if isempty(oneclass)
            C_new(k)=0;
        else
            C_new(k) = mean(oneclass);
        end
        
    end
    C_new=round(C_new);
    if C_new==C
        newimg=img;%�������ͼ��
        for k=1:L
            newimg(index(:,1)==k)=C_new(k);
        end
        imwrite(newimg,'newimg.bmp')
        MSE=sum(sum((newimg-img).^2));
        psnr=10*log10(255^2*m*n/MSE);
        disp(psnr);
        break;
    end
    
    C=C_new;
    %disp(C);
end
disp(C);



function  output  = euclidean_distance(data, center)
data_num =length(data);
center_num = length(center);
output = zeros(data_num, center_num);
    for i = 1:center_num
        difference = double(data) - repmat(center(i),1,data_num);    %�����������i���������ĵĲ
        sum_of_squares = abs(difference);        %��ƽ���� ����ÿһ����ͣ�
        output(:, i) = sum_of_squares;             
    end
end
