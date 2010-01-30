function pe=pitchNor(signal,fs,shift,winSize)
%基音周期是在一个窗口中估计得到的，窗口中最大的两个峰值之间的距离，就是基音周期。对于正弦信号而言，信号是平稳的，所以其实不加窗也是可以估计出基音周期，但是一般的语音信号，是非平稳过程，所以就有了短时傅立叶分析，其实就是加一个小窗，在一个很短的时间内，我们认为信号是平稳的，就可以进行分析。然后不断的移动窗口，从而实现对整个信号的分析。我们要知道，对于一段语音信号而言，基音其实是缓慢变化的，再加上估计方法带有误差，所以每个窗口得到的基音周期会有差别，通常的做法就是平滑，这个程序是利用中值滤波来实现平滑，然后得出近似的基音周期，当然也可以利用动态规划的方法。
%winSize is the window size, should be larger than twice of pitch period
%normally, minmum of  pitch period of speech is 60Hz, so 36ms is okay,but if for singing, we shoud check it later.窗口的大小,即进行处理的区间,语音的最低频率是60Hz,必须取至少两倍于基音周期的窗口,所以大概是36ms的窗口
%shift,每次窗口移动经过的时间(或者理解成要跃过多少个采样点).

%画出输入信号
subplot(4,1,1);
plot(signal);
%legend('WaveForm');
xlabel('Time (s)');
ylabel('Amplitude');

%shift N个采样点,需为整数
shift=round(fs*shift);  

%n1=fix(fs*0.1)+1 
%n1=fix(fs*0.01)+1     
n1=1;           %从第一帧开始
n2=fix(fs*winSize)+n1 %窗口中的最后一帧
shift_count=fix((length(signal)-n1)/shift)%总共移动的次数
value =zeros(1,shift_count);
 for ii=1:shift_count 
    if n2<length(signal)    
      data=signal(n1:n2);
      N=n2-n1+1;
     R=zeros(1,N-1);
     for k=1:N-1   
       for jj=1:N-k
       %for jj=1:N-1
         R(k)=R(k)+data(jj)*data(jj+k);
       end
     end
     value(ii)=find_maxn(R);
     n1=n1+shift;            
     n2=n2+shift;
   end
 end
subplot(4,1,2);
R=R/max(R);
d=(0:N-2)/fs;
plot(d,R);   %autocorrelation function in one window
%legend('Autocorrelation');
xlabel('lag(time)');
ylabel('Amplitude');
%axis([0,1000 -300 300])
subplot(4,1,3);
stem(value);
xlabel('shift count');
ylabel('pitch period');

% axis([0 length(value) 0 20]);
  % len =length(value);               
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
  plot(value);
  xlabel('shift count');
  ylabel('pitch period(ms)');
  %axis([0 length(value) 0 max(value)])
  pe=1/(sum(value)/len/fs)
  % zhouqi=sum(value)/len;
