[v,fs]=audioread('./giabao.wav'); %layaudio vao vecto
e=sum(v.^2); %nang luong
p=e/length(v); 

 
