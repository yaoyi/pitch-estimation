function nmax=find_maxn(r)
zer=find(r==0);
jiaocha=0;
ii=1;
while (jiaocha<=0)
if(r(ii)>0 && r(ii+1)<0 && (ii+1)<length(r))
jiaocha=ii;
end

ii=ii+1;
if ii==length(r) 
jiaocha=1;
end
end

if length(zer)>0
if zer(1)<jiaocha 
jiaocha=zer(1);
end
end

r(1:jiaocha)=0;
maxn=max(r);
temp=find(r==maxn);
nmax=temp(1); 
