function output=model_map(input,mode) %��ƽӳ��
    %% ��������淶
    % ����:
        %1.���������01����input
        %2.��ƽӳ��ģʽmode: 1:1bit/����   2bit:����     3bit:����
    % ���:ӳ��ĵ�ƽ��������output������output����λ
    
    %% ʾ��:
    % output=model_map([1,1,0,1,1,1],3);
    
    %% ˼·:
    % G�����0��2^bit-1��Ӧ��ŵ���λ�������������ÿmode��bit�������������Ҷ�Ӧ��G��
    % ��ƽ�����Ķ�Ӧ��ϵ������ͼ.png
    
    %% ����:
    if mode==1
        G=[pi,0];
        output=G(input+1);
    elseif mode==2
        input=[input,zeros(1,mod(length(input),2))];
        len=length(input);
        angle=pi/2;
        G=[0,angle,3*angle,angle*2];
        input=input(1:2:len)*2+input(2:2:len);%ÿ2bit����
        output=G(input+1);
    elseif mode==3
        input=[input,zeros(1,mod(3-mod(length(input),3),3))];
        len=length(input);
        angle=pi/4;
        G=[0,angle,angle*3,angle*2,angle*7,angle*6,angle*4,angle*5];
        input=input(1:3:len)*4+input(2:3:len)*2+input(3:3:len);%ÿ3bit����
        output=G(input+1);
    end
    
end