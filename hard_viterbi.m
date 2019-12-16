function decode_bit = hard_viterbi(bitcode, eff, tail, holegap)
    %% ��ʼ��
    len=length(bitcode);
    decode_bit = zeros(1, len);
    num = 8;
    if eff==2
        G=[1,1,0,1;1,1,1,1;];%1/2Ч��
    elseif eff==3
        G=[1,0,1,1;1,1,0,1;1,1,1,1;];%1/3Ч��
    end
    G = fliplr(G);
    P = [4; 2; 1];
    if holegap > 2
        holes = ceil((len-1)/(holegap-1));
        dis = zeros(num, len + holes + 1);  % ��¼����
        pos = zeros(num, len + holes + 1);  % ��¼·��
    else
        dis = zeros(num, len + 1);  % ��¼����
        pos = zeros(num, len + 1);  % ��¼·��
    end
    
    dis(2: end, 1) = Inf;
    dis(: , 2: end) = Inf;
    
    Status = [0, 0, 0; 0, 0, 1; 0, 1, 0; 0, 1, 1; ...
        1, 0, 0; 1, 0, 1; 1, 1, 0; 1, 1, 1];
    trans = cell(num, 2);  % ״̬ת�Ƶ��������
    for i = 1: num
        s = Status(i, : )';
        for branch = 0: 1
            stmp = [s; branch];
            trans{i, branch + 1} = mod(G * stmp, 2);
        end
    end
    
    cnt = 0;
    %% viterbi����
    for i = 1: length(pos) - 1
        if holegap > 2 && mod(i, holegap) == 2
            cnt = cnt + 1;
            for sNowNum = 1: num
                statusNow = Status(sNowNum, : );
                for branch = 0: 1
                    statusNext = [statusNow(2: 3), branch];
                    sNextNum = statusNext * P + 1;
                    if dis(sNowNum, i) < dis(sNextNum, i + 1)
                        dis(sNextNum, i + 1) = dis(sNowNum, i);
                        pos(sNextNum, i + 1) = sNowNum;
                    end
                end
            end
        else
            for sNowNum = 1: num
                statusNow = Status(sNowNum, : );

                for branch = 0: 1
                    statusNext = [statusNow(2: 3), branch];
                    sNextNum = statusNext * P + 1;
                    hamming = sum(trans{sNowNum, branch + 1} ~= bitcode(:, i - cnt));
                    if dis(sNowNum, i) + hamming < dis(sNextNum, i + 1)
                        dis(sNextNum, i + 1) = dis(sNowNum, i) + hamming;
                        pos(sNextNum, i + 1) = sNowNum;
                    end
                end
            end
        end
    end
    
    %% �����������·��
    if (tail)
        posEnd = 1;
    else
        [~, posEnd] = min(dis(: , end));
    end
    for i = length(pos): -1: 2
        decode_bit(i-1) = mod(posEnd - 1, 2);
        posEnd = pos(posEnd, i);
    end
    
end