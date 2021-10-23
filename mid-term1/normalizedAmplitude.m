function [x,t,Fs] = normalizedAmplitude(path)
    [x,Fs] = audioread(path);%doc tin hieu tu file
    n=0:length(x)-1; %vecto thgian roi rac (chi so mau) k co don vi.
    T=1/Fs; %T chu ki lay mau
    t=n*T; %thoi gian roi rac (thgian thuc) (giay) 
    
    max_value = max(abs(x)); %tim bien do lon nhat cua tin hieu duoc doc
    x= x/max_value; %dua bien do cua tin hieu ve vecto co tin hieu cao nhat 
end