clear;close all;
[x,Fs] = audioread('./giabao.wav');
L=length(x);
plot(x);
xlabel('Time(samples');
ylabel('Signal amplitude');
sound(x,Fs);
%dung toan tu vecto
E=sum(x.^2);
power=E/L;