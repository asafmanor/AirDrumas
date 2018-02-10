function [drumSound,state] = ADDecision(sticklocation,params,state,n)
% 
% INPUTS: 	sticklocation-the location of the sticks
%           params-parameters for calculations
%           state-previous location etc.
% OUTPUTS:  sounds-the sounds to be played
%           state-state information
location=[];
%unpack location
drumSound=[9,9];
if n>=1
    for i =1:n
    loc=[sticklocation{i}.x,sticklocation{i}.y,sticklocation{i}.shift];
    location=[location;loc];
    end
    %coefficients
    hightH=params.hightH;
    hightL=params.hightL;
    hightM=params.hightM;
    gridsizex=1280*params.pp.resize.resizeFactor;
    gridsizey=720*params.pp.resize.resizeFactor;
    %main code
    %clear flags if the stick is rising
    for i=1:n
    rise=state.sticklocation{i}.shift+params.margin-location(i,3);
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
                    drumSound(i)=4;
                %tam1 check
                elseif (location(i,1)>(gridsizex/4))&& (location(i,1)<(gridsizex/2))&& (location(i,2) > gridsizey/2)
                    drumSound(i)=2;
                %tam2 check
                elseif (location(i,1)>(gridsizex/2))&& (location(i,1)<(3*gridsizex/4))&& (location(i,2) > gridsizey/2)
                    drumSound(i)=3;
                %crash check
                elseif (location(i,1)>(3*gridsizex/4))&& (location(i,2) > gridsizey/2)
                    drumSound(i)=5;
                else 
                    drumSound(i)=9;
                    state.flag(i)=0;
                end
            elseif (location(i)>hightL-hightM)&& (location(i)<hightL+hightM)
                %snar check
                if (location(i,1)>(gridsizex/4))&& (location(i,1)<(gridsizex/2))
                    drumSound(i)=0;
                %floor check
                elseif (location(i,1)>(gridsizex/2))
                    drumSound(i)=1;
                else
                    drumSound(i)=9;
                    state.flag(i)=0;
                end 
            else
                drumSound(i)=9;
                state.flag(i)=0;            
            end
        end
    state.sticklocation=sticklocation;
    end
end
end