close all,clear all,clc;
img=imread('lena_128_bw.bmp');%ͼƬ
L=8;%�������
[m,n]=size(img);
img=reshape(img,1,m*n);

C=floor(rand(1,L)*256);%���codebook

while 1%��ͣ����
    %�����������������ĵľ��룻
    distance = euclidean_distance(img, C);
    [~, index] = sort(distance, 2, 'ascend');
    
    C_new = C;%����codebook
    for k=1:L%ÿ������Ⱥ
        oneclass=img(index(:,1)==k);%����
        C_new(k) = mean(oneclass);
    end
    
    if C_new==C
        break;
    end
    
    C=C_new;
    disp(C);
end


function  output  = euclidean_distance(data, center)
data_num =length(data);
center_num = length(center);
output = zeros(data_num, center_num);
    for i = 1:center_num
        difference = double(data) - repmat(center(i),1,data_num);    %�����������i���������ĵĲ
        sum_of_squares = sum(difference .* difference, 2);        %��ƽ���� ����ÿһ����ͣ�
        output(:, i) = sum_of_squares;             
    end
end
