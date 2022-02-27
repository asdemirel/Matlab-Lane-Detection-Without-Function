
clc; clear all; close all;

perspective = load('perspective.mat');      
pers_hist = perspective.pers_hist;
max_left = max(max(pers_hist(1:150)));
max_right = max(max(pers_hist(150:300)));
t = 5;

left_deviation = MSE(pers_hist,'left');
right_deviation = MSE(pers_hist,'right');

if ( t*max_left - left_deviation) > (t*max_right - right_deviation)
    
    reliable_lane = 'left';
    [x,right_cordinate] = find(pers_hist(150:300)==max_right);   %buranýn ters olmasýnýn mantýðý
    right_cordinate = right_cordinate + 150;
    save('right_cordinate','right_cordinate');
else                                                      %düþük güvenirlikte olanýn koordinatýna yansýtmak.
    reliable_lane = 'right';
    [x,left_cordinate] = find(pers_hist(1:150)==max_left);
    save('left_cordinate','left_cordinate');
end

save('reliable_lane','reliable_lane');


function [deviation] = MSE(image,region)

left = 'left';

mean = 0;
sigma = 0;
[M,N] = size(image);

if strcmp(region,left)
    start = 1;
    stop = N/2;
else
    start = N/2;
    stop = N;
end
    
for j=start : stop
    for i=1 : M
        mean = mean + j * image(i,j);
        mean = (2/N) * mean;
        
    end
end


for j=start : stop
    for i=1 : M
        sigma = sigma + ( image(i,j) * ((j - mean) * (j - mean)));
        sigma = (2/N) * sigma;
    end
end

deviation = sqrt(sigma);

end

