close all,clear all,clc;
img=imread('lena_128_bw.bmp');%图片
for L=[128,32,16,8,4]
    maxpsnr=0;%最大PSNR
    maxans=zeros(2,L);
    maxRate=0;
    for tot=1:1
        %L=8;%区间个数
        [m,n]=size(img);
        img=reshape(img,1,m*n);
        img=[img(1,1:2:m*n);img(1,2:2:m*n)];

        C=floor(rand(2,L)*256);%两维
        %[0    84   138   164    99   208   189     0   145    91    39   153   198   107     0    63    47    71   114   132   121 216   127   224   159     0    54   174    77   170   181     0];
        %floor(rand(1,L)*256);%随机codebook
        %[101    76   180   206    49   140   123   157];
        %175   102   191   130    88   220   211   142   161   151    52    74   117    62   202    43
        %39.8321
        % 0    84   138   164    99   208   189     0   145    91    39   153   198   107     0    63    47    71   114   132   121
        % 
        % 
        %    216   127   224   159     0    54   174    77   170   181     0
        %    44.7596


        % 34.5729
        %    103    57   145   191
        %    103    56   145   191

        %    35.7251 
        %    102     0    51   132   160    77   199   143
        %    105     0    50   133   160    78   199    79

        while 1%不停迭代
            %获得样本集与聚类中心的距离；
            distance = euclidean_distance(img, C);
            [~, index] = sort(distance, 2, 'ascend');

            C_new = C;%更新codebook
            for k=1:L%每个聚类群
                oneclass=img(:,index(:,1)==k);%聚类
                if isempty(oneclass)
                    C_new(:,k)=[0;0];
                else
                    C_new(:,k) = mean(oneclass,2);
                end

            end
            C_new=round(C_new);
            if C_new==C
                newimg=img;%量化后的图像
                for k=1:L
                    newimg(1,index(:,1)==k)=C_new(1,k);
                    newimg(2,index(:,1)==k)=C_new(2,k);
                end

                MSE=sum(sum((newimg-img).^2));
                psnr=10*log10(255^2*m*n/MSE);
                %Rate=bitrate(newimg);
                %disp(psnr);
                %disp(Rate);
                newimg=reshape(newimg,128,128);
                %imwrite(newimg,'newimg.bmp')
                Rate=bitrate(newimg)*128*64;
                %disp(Rate*128*64);
                if maxpsnr<psnr
                    maxpsnr=psnr;
                    maxans=C_new;
                    maxRate=Rate;
                end
                break;
            end

            C=C_new;
            %disp(C);
        end
        %disp(C);
    end
    disp(maxpsnr);
    disp(maxans);
    disp(maxRate);
end


function  output  = euclidean_distance(data, center)
data_num =length(data);
center_num = length(center);
output = zeros(data_num, center_num);
    for i = 1:center_num
        difference = double(data) - repmat(center(:,i),1,data_num);    %求样本集与第i个聚类中心的差；
        sum_of_squares = difference(1,:).^2+difference(2,:).^2;        %求平方， 并对每一行求和；
        output(:, i) = sum_of_squares;             
    end
end
