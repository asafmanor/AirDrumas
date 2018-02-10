function ADSound2(drumSound,kit)
% This function plays drums sounds

% function body
soundL=drumSound(1);
soundR=drumSound(2);
drums='012345';
kits='012';
readR='00.wav';
readL='01.wav';
if soundL == 9 && soundR~=9%right stick only
    readR(2)=drums(soundR+1);
    readR(1)=kits(kit+1);
    [y1,Fs1] = audioread(readR);
    sound(y1,Fs1);
elseif soundR == 9 && soundL~=9 %left stick only
    readL(2)=drums(soundL+1);
    readL(1)=kits(kit+1);
    [y2,Fs2] = audioread(readL);
    sound(y2,Fs2);
elseif soundR ~= 9 && soundL~=9
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