function decode_bit = main(data)
    %% �����趨
    ifconv=1;%�Ƿ���о������
    datalen=length(data);%�������01���еĳ���
    eff=2;%�������Ч�ʣ�ȡֵ{2,3},2����1/2���룬3����1/3����
    tail=1;%������뷢���Ƿ���β��ȡֵ{0,1}��0������β��1������β
    bitmode=1;%��ƽӳ��ģʽ��ȡֵ{1,2,3}��1����1bit/���ţ�2����2bit/���ţ�3����3bit/����
    sigma=0.35; %����
    hard = 0; %��Ӳ����
    holegap = 0; %��׼��

    %% �������е�ģ�飬��������ͨ��ϵͳ
    convres=data;
    %data=CRCCoding(data1,25,4);
     if ifconv
        convres=model_conv(data,eff,tail);  %�������
     else
         eff=1;
     end

    mapres=model_map(convres,bitmode);  %��ƽӳ��
    [channelres, tmp]=channel3(mapres,sigma);  %�ŵ�����

    hard_bitcode = hard_judge(channelres, bitmode, eff);

    if ifconv
        if hard
            %Ӳ�о�����
            decode_bit = hard_viterbi(hard_bitcode, eff, tail, holegap);
            decode_bit = decode_bit(1:length(data));
        else
            % ���о�����
            bitProb = soft_judge(channelres, bitmode, eff);
            decode_bit = soft_viterbi(bitProb, eff, tail, holegap);
            decode_bit = decode_bit(1:length(data));
        end
    else
        decode_bit = hard_bitcode(1:length(data));
    end
    Res=decode_bit~=data;
    sum(abs(Res))

end
