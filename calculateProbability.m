%������յ��ķ��Ŷ�Ӧ�ڸ�����׼���ŵ���Ը���
%����channelres���յ��ķ��ţ�bitmode����/��������theta
function probability=calculateProbability(channelres, bitmode)
    switch bitmode
            case 1
                x=[1,-1];
            case 2
                x=[1,1j,-1,-1j];
            case 3
                x=[1,sqrt(0.5)*(1+1j),1j,sqrt(0.5)*(-1+1j),...
                    -1,sqrt(0.5)*(-1-1j),-1j,sqrt(0.5)*(1-1j)];
            otherwise
                error('invalid bitmode!');
    end
    probability=zeros(length(channelres),length(x));
    for i = 1: length(channelres)
        for k=1:length(x)
            %probability(i, k) = exp(-abs(x(k)-channelres(1, i)).^2); 
            probability(i, k) = exp(-abs(x(k)-channelres(1, i)).^2); 
       end
    end
 probability = probability ./ sum(probability(i, : ));
end