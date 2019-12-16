clear all;
close all;
clc;

num = 1;

picLen = 131072;
bit_rate = zeros(num, 1, 'double');

for i = 1: 1
    fid = fopen('..\Coding\bin.txt');
    tmp = fgetl(fid);
    fclose(fid);
    data = (tmp == '1');
    bit_rate(i) = length(data);
%     data = [data, 0];
    
    data = main(data);
    
    fid = fopen('..\Coding\channel.txt', 'w');
    for index = 1: length(data)
        fprintf(fid, '%d', data(index));
    end
    fclose(fid);
    
    disp(['file', num2str(i), 'finish!']);
end

fid = fopen('..\Coding\bitLen.txt', 'w');
for index = 1: num
    fprintf(fid, '%f\n', bit_rate(index));
end
fclose(fid);
