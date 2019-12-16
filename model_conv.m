function output=model_conv(input,eff,tail)
   %% ��������淶:
    % ����:
    %      1.���޳�01����input
    %      2.�������Ч��eff: 2����1/2,3����1/3
    %      3.��βtail  1������β��0������β:
    % ���:���޳�01����output
    
   %% ʾ��:
    % output=model_conv([1,1,1,1],2,0);
    
   %% ˼·:
    % input=[1,1,0];
    % G=[1,0,1;1,1,1];
    % ��inputд��[1,1,0;0,1,1;0,0,1;]����ʽ
    % G*input=[1,1,1;1,0,0];
    % ����������ϵõ����
    
   %% ����:
    
    input=[input,zeros(1,3*(tail==1))];
  
    len=length(input);
    if eff==2
        G=[1,1,0,1;1,1,1,1;];%1/2Ч��
    elseif eff==3
        G=[1,0,1,1;1,1,0,1;1,1,1,1;];%1/3Ч��
    end
    input_s=zeros(4,len);%��չ����
    for k=1:4 %��λ��չ
        input_s(k,1:len)=[zeros(1,k-1),input(1:len-k+1)];
    end
    output=mod(G*input_s,2);%mod2��
    output=reshape(output,1,len*eff);
end