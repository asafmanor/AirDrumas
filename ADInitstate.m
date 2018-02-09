function [state] = ADInitstate(frame,params)
% this function initializing the state
%  
% OUTPUTS: 	state - this struct rember the previous stage
sticklocation=ADFindLocationsXY(frame,params);
n=params.numOfSticks;
for i =1:n
    state.sticklocation{i}.shift=sticklocation.shift;
    state.sticklocation{i}.x=sticklocation{i}.x;
    state.sticklocation{i}.y=sticklocation{i}.y;
    state.flag(i)=0;
end


end