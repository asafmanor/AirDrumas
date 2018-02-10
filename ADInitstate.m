function [state] = ADInitstate(frames ,params)
% this function initializing the state
%  
% OUTPUTS: 	state - this struct rember the previous state

[sticklocation] = ADLocationPerTimestep(frames, params);

for i = 1:params.numOfSticks
	if sticklocation{i}.found == false
		state.sticklocation{i}.shift = 0;
    	state.sticklocation{i}.x = 0;
    	state.sticklocation{i}.y = 0;
    	state.flag(i)=0;
    else
    	state.sticklocation{i}.shift=sticklocation{i}.shift;
    	state.sticklocation{i}.x=sticklocation{i}.x;
    	state.sticklocation{i}.y=sticklocation{i}.y;
    	state.flag(i)=0;
    end
end


end