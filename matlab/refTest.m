%this example need to be put into voicebox directory, it use: fxrapt.m and other .m, also the lin.wav
[signal,fs]=readwav('lin.wav');
fxrapt(signal,fs,'g');
