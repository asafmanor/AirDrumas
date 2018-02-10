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
        if sticklocation{i}.found ==1
            loc=[sticklocation{i}.x,sticklocation{i}.y,sticklocation{i}.shift];
            location=[location;loc];
        else
            n=n-1;
        end
            
  end
end
if n>=1
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
            for j=1:6
               if params.drums{j}.x+params.xmargin>location(i,1) && location(i,1)>params.drums{j}.x-params.xmargin
                   if params.drums{j}.y+params.ymargin>location(i,2) && location(i,2)>params.drums{j}.y-params.ymargin
                        if params.drums{j}.shift+params.zmargin>location(i,3) && location(i,3)>params.drums{j}.shift-params.zmargin
                        state.flag(i)=1;
                        drumSound(i)=j;
                        end
                   end
               end
            end
        end
    state.sticklocation=sticklocation;
    end
end
end