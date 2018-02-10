function [params] = ADInitializeRecordingSession(camR, camL, params)

% ++++++++++++++ record red threshold +++++++++++++++
disp('Please place the two sticks in front of the camera');
disp('Shoting image in 2 sec')
pause(2);
img = snapshot(camL);
LAB = rgb2lab(img);
A = LAB(:,:,2);
stop = 1;

disp('Determine red stick threshold')
thr = params.xy.redMaskTh;
fig=figure;
while(stop)
    mask = A < thr;
    subplot(1,2,1);imagesc(A);title('Orinigal A channel image');
    subplot(1,2,2);imagesc(mask);title(['Mask of A channel, threshold is: ',num2str(thr)])
    prompt = 'Is the treshold ok (Y/N)?\n';
    ans = input(prompt,'s');
    if strcmp(ans,'Y');
        stop = 0;
    else
        prompt = 'Enter new threshold (-128:128)\n';
        thr = input(prompt);
    end

end
disp(['The choosen treshold is: ', num2str(thr)]);
params.xy.redMaskTh = thr;
input('Press any key to continue');
close(fig);

% ++++++++++++++ record blue threshold +++++++++++++++
disp('Determine blue stick threshold')
pause(2);
B = LAB(:,:,3);
stop = 1;
thr = params.xy.blueMaskTh;

fig=figure;
while(stop)
    mask = B > thr;
    subplot(1,2,1);imagesc(B);title('Orinigal B channel image');
    subplot(1,2,2);imagesc(mask);title(['Mask of B channel, threshold is: ',num2str(thr)])
    prompt = 'Is the treshold ok (Y/N)?\n';
    ans = input(prompt,'s');
    if strcmp(ans,'Y');
        stop = 0;
    else
        prompt = 'Enter new threshold (-127:127)\n';
        thr = input(prompt);
    end

end
disp(['The choosen treshold is: ', num2str(thr)]);
params.xy.redMaskTh = thr;
input('Press any key to continue');
close(fig);

% ++++++++++++++ location of drums +++++++++++++++

numOfFrames = 5;
for drum=1:6
    disp(['Please place one stick at the locaion of drum nunmber ',num2str(drum)]);
    input('Press any key to continue');
    
    tmp.x=[];
    tmp.y=[];
    tmp.shift=[];
    tmp.found = 0;
    for i=1:numOfFrames
        pause(0.1);
        frames{2} = snapshot(camL);
        frames{1} = snapshot(camR);
        stickLoc = ADLocationPerTimestep(frames, params);
        tmp=[tmp,stickLoc{1}];
    end
    params.drums{drum}.x = mean(tmp.x);
    params.drums{drum}.y = mean(tmp.y);
    params.drums{drum}.shift = mean(tmp.shift);
    disp(['Drum number ',num2str(drum), 'params are: (x,y) ',...
        num2str(params.drums{drum}.x, params.drums{drum}.y),...
        ' shift: ', num2str(params.drums{drum}.shift)])
end
disp('All drums locations recorded successfully !')

end