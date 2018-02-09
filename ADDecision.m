function [drumSound,state] = ADDecision(sticklocation,params,state)
% 
% INPUTS: 	sticklocation-the location of the sticks
%           params-parameters for calculations
%           state-previous location etc.
% OUTPUTS:  sounds-the sounds to be played
%           state-state information

%unpack location
locationL=[sticklocation{1}.x,sticklocation{1}.y,sticklocation{1}.shift];
locationR=[sticklocation{2}.x,sticklocation{2}.y,sticklocation{2}.shift];
location=[locationL;locationR];
%coefficients
hightH=params.hightH;
hightL=params.hightL;
hightM=params.hightM;
gridsizex=1280*params.pp.resize.resizeFactor;
gridsizey=720*params.pp.resize.resizeFactor;
n=params.numOfSticks;
%main code
%clear flags if the stick is rising
for i=1:n
rise=state.sticklocation{i}.shift-locationL(3);
    if rise<=0
        state.flag(i)=0;
    end
end
for i =1:n
    if state.flag(i)==0
        state.flag(i)=1;
        %hat check
        if (location(i,2) > gridsizey/2) && (location(i)>hightH-hightM)&& (location(i)<hightH+hightM)
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
                state.flag(i)=0;
            end
        elseif (location(i)>hightL-hightM)&& (location(i)<hightL+hightM)
            %snar check
            if (location(i,1)>(gridsizex/4))&& (location(i,1)<(gridsizex/2))
                sound(i)=0;
            %floor check
            elseif (location(i,1)>(gridsizex/2))
                sound(i)=1;
            else
                sound(i)=9;
                state.flag(i)=0;
            end 
        else
            sound(i)=9;
            state.flag(i)=0;            
        end
    end
state.sticklocation=sticklocation;
end
end