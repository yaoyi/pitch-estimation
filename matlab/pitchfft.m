function [r] = pitchfft(signal, fs, shift,winSize)
 %% Initialization
 % if ~exist('maxlag', 'var') || isempty(maxlag)
%	       maxlag = fs/50; % F0 is greater than 50Hz => 20ms maxlag
% end
%	if ~exist('show', 'var') || isempty(show)
%		show = 0;
%	 end

 %shift N个采样点,需为整数
shift=round(fs*shift);  

%n1=fix(fs*0.1)+1 
n1=fix(fs*0.01)+1;     
%n1=1;           %从第一帧开始
n2=fix(fs*winSize)+n1; %窗口中的最后一帧
shift_count=fix((length(signal)-n1)/shift);%总共移动的次数
value =zeros(1,shift_count);
temval =zeros(1,shift_count);
for ii=1:shift_count 
    if n2<length(signal)    
      data=signal(n1:n2);
      N=n2-n1+1;
	 %% Auto-correlation
     r = xcorr(data, N,'coeff'); %coeff只是对输出的幅度进行标准化
    temp = r(N+2:2*N+1);
     value(ii)=find_maxn(temp);
     temval(ii)=1/(value(ii)/fs);
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
	legend('Auto-correlation');
	xlabel('Lag (s)');
	ylabel('Correlation coef');
	subplot(4,1,3);	
	stem(value);
  	value=value(value~=0);
  	aver=mean(value);
  
  %  index=find(abs((value-aver))>aver/5);
  %  value(index)=0;                    
  %  value=value(value>0);
  
  value=value(logical(abs(value-aver)<=aver/5));
  len= length(value);
  for jj=1:3:len/3                   
      average=(value(jj)+value(jj+1)+value(jj+2))/3;
      for kk=1:3
          if abs((value(jj-1+kk))-average)>average/4
              value(jj-1+kk)=0;     
  %              len=len-1;
          end
      end
  end
  value=value(value~=0);
   len=length(value);
  subplot(4,1,4);
  plot(temval);
  xlabel('shift count');
  ylabel('pitch (Hz)');
  %axis([0 length(value) 0 max(value)])
  pe=1/((sum(value)/len)/fs)

end
