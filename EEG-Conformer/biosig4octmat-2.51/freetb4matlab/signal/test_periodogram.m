
% test_periodogram



x=mod(1:10,3)'-1;
periodogram(x)
Pxx=periodogram(x)
size(Pxx)

Pxx=periodogram(x,[],10)   
[Pxx,w]=periodogram(x,[],10)   
[Pxx,f]=periodogram(x,[],10,[])   
[Pxx,f]=periodogram(x,[],10,100)   
[Pxx,f]=periodogram(x,[],'twosided',10,100)   


 x=mod(1:1001,3)'-1;
 periodogram(x)
 Pxx=periodogram(x)
 size(Pxx)

 x=mod(1:1024,3)'-1;
 periodogram(x)
 Pxx=periodogram(x)
 size(Pxx)


