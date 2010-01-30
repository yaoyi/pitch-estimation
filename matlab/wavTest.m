%this function is to test pitch estimation with .wav file
[signal,fs]=readwav('data/lin.wav');
fs
[x1,x2]=voiDetect(signal); %detect the start point speech as well as the  end point 
if(fs==8000)
	shift=0.003; %0.003*8000=24ms
	winSize=0.02; %0.02*8000=160ms
end
if(fs==22050)
	shift=0.001; %0.003*22050=22ms
	winSize=0.005; %0.005*22050=110ms
end
if(fs==44100)
	shift=0.0005; %0.0005*44100=22ms
	winSize=0.005; %0.005*44100=220ms
end
%pitchNor(signal,fs,shift,winSize);
pitchfft(signal(x1:x2),fs,shift,winSize);
