for i=1:5
pause(0.2)
kit=1;
soundL=0;
soundR=5;
drums='012345';
kits='012';
readR='00.wav';
readL='01.wav';
if soundL == 9
    readR(2)=drums(soundR+1);
    readR(1)=kits(kit+1);
    [y1,Fs1] = audioread(readR);
    sound(y1,Fs1);
elseif soundR == 9
    readL(2)=drums(soundL+1);
    readL(1)=kits(kit+1);
    [y2,Fs2] = audioread(readL);
    sound(y2,Fs2);
else
    readR(2)=drums(soundR+1);
    readL(2)=drums(soundL+1);
    readR(1)=kits(kit+1);
    readL(1)=kits(kit+1);
    [y1,Fs1] = audioread(readR);
    [y2,Fs2] = audioread(readL);
    sound(y2,Fs2);
    sound(y1,Fs1);
end
end
%%
a=input('input');
b=int16(a+5);
c=zeros(1,b);
tic
parfor i=1:b
    c(i)=i+2;
end
toc

%%
tic
locationL=[40,60,560];
locationR=[100,450,90];
location=[locationL;locationR];
bias=7
gridsizex=1280
gridsizey=720
n=2
for i =1:n
    %hat check
    if (location(i,2) > gridsizey/2) 
        if (location(i,1)<(gridsizex/4))&& (location(i,2) > gridsizey/2) 
            sound(i)=4;
        %tam1 check
        elseif (location(i,1)>(gridsizex/4))&& (location(i,1)<(gridsizex/2))&& (location(i,2) > gridsizey/2)
            sound(i)=2;
        %tam2 check
        elseif (location(i,1)>(gridsizex/2))&& (location(i,1)<(3*gridsizex/4))&& (location(i,2) > gridsizey/2)
            sound(i)=3;
        %crash check
        elseif (location(i,1)>(3*gridsizex/4))&& (location(i,2) > gridsizey/2)
            sound(i)=5;
        else 
            sound(i)=9;
        end
    else
        %snar check
        if (location(i,1)>(gridsizex/4))&& (location(i,1)<(gridsizex/2))
            sound(i)=2;
        %floor check
        elseif (location(i,1)>(gridsizex/2))
            sound(i)=3;
        else
            sound(i)=9;
        end        
    end
end
toc
