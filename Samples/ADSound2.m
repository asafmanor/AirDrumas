function ADSound2(drumSound, params)
    drums = params.drums;
    soundR = drumSound(1);
    soundL = drumSound(2);
    
    % synchronize to 120 BPM - activate only if function runs in parallel using parfeval
%     while(true)
%         c = clock;
%         if mod(c(6),0.5) == 0
%             break;
%         end
%     end
        
    if soundR ~= 9
        sound(drums{soundR}.Sound, drums{soundR}.fs);
    end
    if soundL ~= 9
        sound(drums{soundL}.Sound, drums{soundL}.fs);
    end
end