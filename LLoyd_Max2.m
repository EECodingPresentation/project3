close all,clear all,clc;
img=imread('lena_128_bw.bmp');%图片
L=8;%区间个数
[m,n]=size(img);
img=reshape(img,1,m*n);

C=floor(rand(1,L)*256);%随机codebook

while 1%不停迭代
    %获得样本集与聚类中心的距离；
    distance = euclidean_distance(img, C);
    [~, index] = sort(distance, 2, 'ascend');
    
    C_new = C;%更新codebook
    for k=1:L%每个聚类群
        oneclass=img(index(:,1)==k);%聚类
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
        difference = double(data) - repmat(center(i),1,data_num);    %求样本集与第i个聚类中心的差；
        sum_of_squares = sum(difference .* difference, 2);        %求平方， 并对每一行求和；
        output(:, i) = sum_of_squares;             
    end
end
