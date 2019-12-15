clear all;
close all;
clc;

num = 1;

for i = 1: num
    fid = fopen(['.\', num2str(i), '\bin.txt']);
    tmp = fgetl(fid);
    fclose(fid);
    data = (tmp == '1');
    
    data = main(data);
    
    fid = fopen(['.\', num2str(i), '\channel.txt'], 'w');
    for index = 1: length(data)
        fprintf(fid, '%d', data(index));
    end
    fclose(fid);
    
end