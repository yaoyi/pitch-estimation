function pe = pitchfft(signal, fs, shift,winSize,filMethod)
%input para: 
%signal: raw data.
%fs: sampling rate
%shift: indicate how many samples the window should shift every time
%winSize: indicate how many samples will be processed every time
%filMethod: indicate the filter method, now optios: normal,median
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%output para:
%pe: pitch estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize the shift interval
shift=round(fs*shift);  

%n1=fix(fs*0.1)+1 
n1=fix(fs*0.01)+1;   %initialize the start point   
%n1=1;          
n2=fix(fs*winSize)+n1; %initialize the  window size
shift_count=fix((length(signal)-n1)/shift);%the total shift count
value =zeros(1,shift_count); %initialize the pitch of each window
%temval =zeros(1,shift_count); %this variable is for plotting

%start processing
for ii=1:shift_count 
    if n2<length(signal)    
      data=signal(n1:n2); %take a window of the original data
      N=n2-n1+1; 
	 %% Auto-correlation
     r = xcorr(data, N,'coeff'); %this is the function given by matlab,so you could type "help xcorr to know more"
    temp = r(N+2:2*N+1);   %r is symmetric,we only need half of it. 
     value(ii)=find_maxn(temp); %find the pitch, which is the first peak of the window. 
 %    temval(ii)=1/(value(ii)/fs);%prepare for plotting later.
     n1=n1+shift;            
     n2=n2+shift;
   end
 end
	%% plot waveform
	t=(0:length(signal)-1)/fs;        % times of sampling instants
	figure;
	subplot(4,1,1);
	plot(t,signal);
	axis([1 length(signal) -1 1]);
	%legend('Waveform');	
	xlabel('Time (s)');
        ylabel('Amplitude');
	xlim([t(1) t(end)]);
		
	% plot autocorrelation
	d=(-N:N)/fs;
	subplot(4,1,2);
	plot(d,r);
	%legend('Auto-correlation');
	xlabel('Lag (s)');
	ylabel('Correlation coef');
	subplot(4,1,3);	
	stem(value);
	xlabel('shift count');
	ylabel('pitch period');

%start filtering
if filMethod=='median' %median filter
  value=medfilt2(value,[1 3])
else    %normal filter
% filtering to make the pitches more smooth.
  value=value(value~=0);
  aver=mean(value);
  value=value(logical(abs(value-aver)<=aver/5));
  len= length(value);
  for jj=1:3:len/3   %using size 3 windows to filtering.                
      average=(value(jj)+value(jj+1)+value(jj+2))/3;%calculate the mean value
      for kk=1:3
          if abs((value(jj-1+kk))-average)>average/4%get rid of the large magnitude point.
              value(jj-1+kk)=0;     
          end
      end
  end
end

%  subplot(4,1,4);
%  plot(temval);
%  xlabel('shift count');
%  ylabel('pitch (Hz)');
  value=value(value~=0);
  %plot the pitch after smoothing
  subplot(4,1,4);
  plot(value);
  xlabel('shift count');
  ylabel('pitch period(ms)');
  len=length(value);

  %axis([0 length(value) 0 max(value)])
  pe=1/((sum(value)/len)/fs)

end
