function c2 = mfccfunction (x,fs)

%Pre-emphasis
y = filter([1-0.9375],1,x);

%Mel filter
bank = melbankm(24,256,fs,0,0.5,'m');
bank = full(bank);
bank = bank/max(bank(:));

%DCT
for k = 1:12
    n = 0:23;
    dct(k,:)=cos((2*n+1)*k*pi/(2*24));
end

%normalized cepstrum window
ww = 1+6*sin(pi*[1:12]./12);
ww = ww/max(ww);

yizhen=256;
zhenyi=128;
fram=enframe(y,yizhen,zhenyi);

%windowing
w=0.54-0.46*cos((2*pi*(0:yizhen-1))/(yizhen-1));

for i=1:size(fram,1)
    framwindow(i,:)=fram(i,:).*w;
    framwindowfft(i,:)=fft(framwindow(i,:));
    t=abs(framwindowfft(i,:));
    t=t.^2;
    c1 = dct*log(bank*t(1:129)');
    c2 = c1.*ww';
    m(i,:)=c2';
    
end

%first order difference of MFCC
dtm = zeros(size(m));
for i = 3:size(m,1)-2
    dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
end
dtm = dtm/3;
%merge mfcc and first order difference
c = [m dtm];
%remove the first and last frames
c2 = c(3:size(m, 1)-2,:);

