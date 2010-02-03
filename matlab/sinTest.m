t=0:0.001:0.5;   %fs=1000
signal=sin(20*pi*t)+sin(80*pi*t)+sin(120*pi*t);
fs=1000;
shift=0.01; %0.01*fs=10ms
winSize=0.2; %0.2*fs=200ms
%pitchNor(signal,fs,shift,winSize);
pitchfft(signal,fs,shift,winSize);
