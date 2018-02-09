function [state] = ADInitstate(frames ,params)
% this function initializing the state
%  
% OUTPUTS: 	state - this struct rember the previous state

sticklocation = ADLocationPerTimestep(frames, params);
n=params.numOfSticks;
for i =1:n
    state.sticklocation{i}.shift=sticklocation{i}.shift;
    state.sticklocation{i}.x=sticklocation{i}.x;
    state.sticklocation{i}.y=sticklocation{i}.y;
    state.flag(i)=0;
end


end