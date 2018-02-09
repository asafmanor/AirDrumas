path = '.dataTryNew/'
for counter = [1:30]
    filename = ['image_' num2str(counter) '.png'];
    
    disp(['Iteration no.' num2str(counter) '. press any key to continue...']);
    pause(0.1);
    
    left_im = snapshot(camLeft);
    right_im = snapshot(camRight);
    leftImagesTwo{counter} = left_im;
    rightImagesTwo{counter} = right_im;
end
disp('acquisition ended');