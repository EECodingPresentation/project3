function decode_bit = main(data)
    %% 参数设定
    ifconv=1;%是否进行卷积编码
    datalen=length(data);%随机生成01序列的长度
    eff=2;%卷积编码效率，取值{2,3},2代表1/2编码，3代表1/3编码
    tail=1;%卷积编码发端是否收尾，取值{0,1}，0代表不收尾，1代表收尾
    bitmode=1;%电平映射模式，取值{1,2,3}，1代表1bit/符号，2代表2bit/符号，3代表3bit/符号
    sigma=0.35; %即σ
    hard = 0; %软硬解码
    holegap = 0; %打孔间隔

    %% 连接所有的模块，构成整个通信系统
    convres=data;
    %data=CRCCoding(data1,25,4);
     if ifconv
        convres=model_conv(data,eff,tail);  %卷积编码
     else
         eff=1;
     end

    mapres=model_map(convres,bitmode);  %电平映射
    [channelres, tmp]=channel3(mapres,sigma);  %信道传输

    hard_bitcode = hard_judge(channelres, bitmode, eff);

    if ifconv
        if hard
            %硬判决部分
            decode_bit = hard_viterbi(hard_bitcode, eff, tail, holegap);
            decode_bit = decode_bit(1:length(data));
        else
            % 软判决部分
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
