clear; close all;


%doc file va nhung buoc xu ly co ban
path1='/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/TinHieuKiemThu/phone_M2.wav';
[x1,t1,Fs1]=normalizedAmplitude(path1);
[frame_F01,t01]=frame_F0(x1,Fs1);
frame_F01=medfilt(frame_F01,7);
[F0mean1,F0std1]=FindF0mean_F0std(frame_F01);
figure('Name','phone_Male');
uv1=x1(floor(1.06*Fs1):floor(1.09*Fs1));
v1=x1(floor(1.00*Fs1):floor(1.03*Fs1));
uv1=ACF(uv1);
v1= ACF(v1);
subplot(4,1,1); plot(uv1); xlabel('Sample'); ylabel('Autocorrect');title('Unvoice');
subplot(4,1,2); plot(v1); xlabel('Sample'); ylabel('Autocorrect');title('Voice');
subplot(4,1,3); plot(t1,x1); xlabel('Time(s)');ylabel('Amplitude'); title('F0mean:129 F0std:18.6');
subplot(4,1,4); stem(t01,frame_F01,'fill'); xlabel('Time(s)'); ylabel('F0');title(['F0mean:', num2str(F0mean1), ' F0std:', num2str(F0std1)]);


path2='/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/TinHieuKiemThu/phone_F2.wav';
[x2,t2,Fs2]=normalizedAmplitude(path2);
[frame_F02,t02]=frame_F0(x2,Fs2);
frame_F02=medfilt(frame_F02,7);
[F0mean2,F0std2]=FindF0mean_F0std(frame_F02);
figure('Name','phone_Female');
uv2=x2(floor(1.90*Fs2):floor(1.93*Fs2));
v2=x2(floor(1.50*Fs2):floor(1.53*Fs2));
uv2=ACF(uv2);
v2= ACF(v2);
subplot(4,1,1); plot(uv2); xlabel('Sample'); ylabel('Autocorrect');title('Unvoice');
subplot(4,1,2); plot(v2); xlabel('Sample'); ylabel('Autocorrect');title('Voice');
subplot(4,1,3); plot(t2,x2); xlabel('Time(s)');ylabel('Amplitude'); title('F0mean:145 F0std:33.7');
subplot(4,1,4); stem(t02,frame_F02,'fill'); xlabel('Time(s)'); ylabel('F0'); title(['F0mean:', num2str(F0mean2), ' F0std:', num2str(F0std2)]);


path3='/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/TinHieuKiemThu/studio_F2.wav';
[x3,t3,Fs3]=normalizedAmplitude(path3);
[frame_F03,t03]=frame_F0(x3,Fs3);
frame_F03=medfilt(frame_F03,7);
[F0mean3,F0std3]=FindF0mean_F0std(frame_F03);
figure('Name','studio_Female');
uv3=x3(floor(1.78*Fs3):floor(1.81*Fs3));
v3=x3(floor(0.90*Fs3):floor(0.93*Fs3));
uv3=ACF(uv3);
v3= ACF(v3);
subplot(4,1,1); plot(uv3); xlabel('Sample'); ylabel('Autocorrect');title('Unvoice');
subplot(4,1,2); plot(v3); xlabel('Sample'); ylabel('Autocorrect');title('Voice');
subplot(4,1,3); plot(t3,x3); xlabel('Time(s)');ylabel('Amplitude'); title('F0mean:200 F0std:46.1');
subplot(4,1,4); stem(t03,frame_F03,'fill'); xlabel('Time(s)'); ylabel('F0');title(['F0mean:', num2str(F0mean3), ' F0std:', num2str(F0std3)]);


path4='/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/TinHieuKiemThu/studio_M2.wav';
[x4,t4,Fs4]=normalizedAmplitude(path4);
[frame_F04,t04]=frame_F0(x4,Fs4);
frame_F04=medfilt(frame_F04,7);
[F0mean4,F0std4]=FindF0mean_F0std(frame_F04);
figure('Name','studio_Male');
uv4=x4(floor(0.45*Fs4):floor(0.48*Fs4));
v4=x4(floor(0.70*Fs4):floor(0.73*Fs4));
uv4=ACF(uv4);
v4= ACF(v4);
subplot(4,1,1); plot(uv4); xlabel('Sample'); ylabel('Autocorrect');title('Unvoice');
subplot(4,1,2); plot(v4); xlabel('Sample'); ylabel('Autocorrect');title('Voice');
subplot(4,1,3); plot(t4,x4); xlabel('Time(s)');ylabel('Amplitude'); title('F0mean:155 F0std:30.8');
subplot(4,1,4); stem(t04,frame_F04,'fill'); xlabel('Time(s)'); ylabel('F0');title(['F0mean:', num2str(F0mean4), ' F0std:', num2str(F0std4)]);



