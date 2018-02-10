function [] = ADInitializeRecordingSession(camR, camL, params)

% debug struct
global debug;
% function body

disp('Please place one stick in front of the camera')
disp('Shoting image is 2 sec')
pause(2);
img = snapshot(camL);
pause(2);
LAB = rgb2lab(img);
A = LAB(:,:,2);
stop = 1
thr = params.xy.maskTh;

figure;
while(stop)
% for i=1:5
    mask = A > thr;
    subplot(1,2,1);imshow(A,[]);title('Orinigal A channel image');
    subplot(1,2,2);imshow(mask,[]);title(['Mask of A channel, threshold is: ',num2str(params.xy.maskTh)])
    prompt = 'Is the treshold ok (Y/N)?\n';
    ans = input(prompt,'s');
    if strcmp(ans,'Y');
        stop = 0;
    else
        prompt = 'Enter new threshold (0-255)\n';
        thr = input(prompt);
    end

end
disp(['The choosen treshold is: ', num2str(thr)]);
params.xy.maskTh = thr;
input('Press any key to continue');


numOfFrames = 5;
disp('Please place one stick at the lower drum plane')
pause(5);

tmpL=[];
for i=1:numOfFrames
    frames{2} = snapshot(camL);
    frames{1} = snapshot(camR);
    stickLoc = ADLocationPerTimestep(frames, params);
    tmpL=[tmpL,stickLoc{1}.shift];
end
params.hightL = mean(tmpL);
disp(['Low drum plane is ',num2str(params.hightL)])
pause(2);

input('Press any key to continue');
disp('Please place one stick at the higher drum plane')
pause(5);

tmpH=[];
for i=1:numOfFrames
    frames{2} = snapshot(camL);
    frames{1} = snapshot(camR);
    stickLoc = ADLocationPerTimestep(frames, params);
    tmpH=[tmpH,stickLoc{1}.shift];
end
params.hightH = mean(tmpH);
disp(['High drum plane is ',num2str(params.hightH)])
pause(2);

% debug dump
if debug.enable
	t = debug.timestep;
	% debug.some_parameter = some_parameter;
end

end