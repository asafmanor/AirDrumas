function [drumSound,state] = ADDecision(sticklocation,params,state)
% 
% INPUTS: 	sticklocation-the location of the sticks
%           params-parameters for calculations
%           state-previous location etc.
% OUTPUTS:  sounds-the sounds to be played
%           state-state information

%unpack location
drumSound=[9,9];
n=params.numOfSticks;
if n>=1
    %main code
    for i =1:n
        if sticklocation{i}.found ==1
            for j=1:6
               if params.drums{j}.x+params.xmargin>sticklocation{i}.x && sticklocation{i}.x>params.drums{j}.x-params.xmargin
                   if params.drums{j}.y+params.ymargin>sticklocation{i}.y && sticklocation{i}.y>params.drums{j}.y-params.ymargin
                        if params.drums{j}.shift+params.zmargin<state.sticklocation{i}.shift && sticklocation{i}.shift<params.drums{j}.shift-params.zmargin
                        drumSound(i)=j-1;
                        break;
                        end
                   end
               end
            end
            state.sticklocation{i}=sticklocation{i};
        end
    end
end
end