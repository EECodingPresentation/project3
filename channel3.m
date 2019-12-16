%����Eb/n0�������ʹ�ϵ�ع����ŵ��������һ��Eb/n0
%�ŵ�ģ�飬���뷢�͵ĽǶ�phi_input(2bit/symbol��
%������յĽǶ�phi_output��-�е���)
function [output,Eb_n0]=channel3(phi_input,sigma)
close all;
    if exist("phi_input")~=1
        phi_input=2*pi*rand(1,4096)-pi; %��������
    end
    L=length(phi_input); %4096(2bit/symbol)
    A=1;%����
    if exist("sigma")~=1
        sigma=0;%�����źŵ�sigma
    end
    delay=5;%��ʱ��ʵ�����
    rate=10;%������
    rs=2000;
    Ts=1/rs;
    ttrans=L/rs;%����ʱ��2.048s
    fs=rs*rate;%����Ƶ�� 20000Hz  
    w=rs*3/4;%����1500Hz
    %wc=2;%�ز���Ƶ�ʣ����ȡֵ��������
    f0=1850;%(300+3400)/2
    phi_I=A*cos(phi_input);%I·cos
    phi_Q=A*sin(phi_input);%Q·sin
    phi_pulse_I=reshape([phi_I;zeros(rate-1,L)],1,L*rate);%��0�м����ɳ����
    phi_pulse_I_delay=[zeros(1,2*rate*delay),phi_pulse_I];
    phi_pulse_I=[phi_pulse_I,zeros(1,2*rate*delay)];%��0ʹ�ú��˲�������һ��
    phi_trans_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_I);%�����˲�
    phi_pulse_Q=reshape([phi_Q;zeros(rate-1,L)],1,L*rate);%���ɳ����
    phi_pulse_Q=[phi_pulse_Q,zeros(1,2*rate*delay)];%��0��ʱ�ĳ���
     t=1:length(phi_trans_I);
     t=t/fs;
    phi_trans_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_Q);%�����˲�   
   % phi_trans=phi_trans_I.*cos(wc*t)+phi_trans_Q.*sin(wc*t);%��·�����ز������
   phi_trans=phi_trans_I.*cos(2*pi*f0*t)+phi_trans_Q.*sin(2*pi*f0*t);%��·�����ز������
  %%
%   figure;
%   plot(phi_trans(1:200));
%   title("���䲨��");
%     figure;%���Ʒ��书����
%     tff=1:length(phi_trans);
%     p1=abs(fft((phi_trans))).^2;
%     p1=5*log(p1);
%     mn=50;
%     for i=1+mn:length(phi_trans)/4
%         p1(i)=sum(p1(i-mn:i+mn))/(2*mn+1);
%     end
%     plot(tff(1:length(phi_trans)/4)/length(phi_trans)*fs,p1(1:length(phi_trans)/4));
%     title("���书����");
%     xlabel("Hz");
%     ylabel("dB");
    %%
    n=normrnd(0,sigma,1,length(phi_trans));
    phi_trans_noisy=phi_trans+n;
    Eb_n0=phi_trans*phi_trans.'/(n*n.')/4;
    %%
%     figure;%���ƽ��չ�����
%   plot(phi_trans_noisy(1:200));
%   title("���ղ���");
%     figure;%���Ʒ��书����
%     tff=1:length(phi_trans_noisy);
%     p2=abs(fft((phi_trans_noisy))).^2;
%     p2=5*log(p2);
%     mn=50;
%     for i=1+mn:length(phi_trans)/4
%         p2(i)=sum(p2(i-mn:i+mn))/(2*mn+1);
%     end
%     plot(tff(1:length(phi_trans)/4)/length(phi_trans)*fs,p2(1:length(phi_trans)/4));
%     title("���չ�����");
%     xlabel("Hz");
%     ylabel("dB");
    %%
    phi_received_I=2*phi_trans_noisy.*cos(2*pi*f0*t);%I·���
    phi_matched_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_I);%I·ƥ���˲�
    %%
%     figure;
%    plot(phi_matched_I(1:500));
%    hold on;
%    stem(phi_pulse_I_delay(1:500));
%    title("I· ��="+sigma);
%    hold off;
%%
    cosphi=phi_matched_I(2*rate*delay+1:rate:length(phi_matched_I));%�����õ�cos��
  
    phi_received_Q=2*phi_trans_noisy.*sin(2*pi*f0*t);%Q·���
    phi_matched_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_Q);%Q·ƥ���˲�
    sinphi=phi_matched_Q(2*rate*delay+1:rate:length(phi_matched_Q));%�����õ�sin��
    output=1/A*(cosphi+1j*sinphi);%��ԭ����
    phi_output=angle(output);%������ǲ����
   % loss=(mean(abs(phi_output-phi_input)))%ƽ�����
    
end