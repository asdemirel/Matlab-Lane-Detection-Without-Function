clc; clear all; close all;

perspective = load('perspective.mat'); image = perspective.perspective_image;
rgb_image = perspective.rgb_perspective;
reliable_lane = load('reliable_lane.mat'); reliable_lane = reliable_lane.reliable_lane;

region_left = 'left'; region_right = 'right';

left = zeros(300,300); right = zeros(300,300);
 
[rows,cols]= size(image);

start_left = 1;
stop_left = rows/2;

start_right = rows/2;
stop_right = rows;

if strcmp(reliable_lane , region_left)
 
    right_cordinate = load('right_cordinate.mat');
    right_cordinate = right_cordinate.right_cordinate;
    
    [left,rgb_image] = lse(image,start_left,stop_left,rows,rgb_image,right_cordinate);
else
    left_cordinate = load('left_cordinate.mat');
    left_cordinate = left_cordinate.left_cordinate;
    
    [right,rgb_image] = lse(image,start_right,stop_right,rows,rgb_image,left_cordinate);
  
end


result_matris = left+right;

subplot(1,3,1);imshow(image); title('Perspective And Image');
subplot(1,3,2);imshow(result_matris);title('Binary Lane');
subplot(1,3,3);imshow(rgb_image);title('Rgb Perspective Lane');
figure ; imshow('road3.jpg');title('orijinal image')
save('binary_lane','result_matris');

function [lane_matris,rgb_image] = lse(image,start,stop,rows,rgb_image,cordinate)

counter = 1 ;
white_number =sum(sum(image(:,start:stop)))/255 ;


matrisA  = zeros(white_number,3);
matrisB  = zeros(white_number,1);
x_lambda = zeros(3,1) ;

for i = 1 : rows
    for j = start : stop
        if image(i,j) ==255
           
            matrisA(counter,1) = i*i ;
            matrisA(counter,2) = i ;
            matrisA(counter,3) = 1 ;
            
            matrisB(counter,1) = j ;
            
            counter = counter +1;
            
        end
    end
end

transposeA = matrisA' ;
temp = transposeA*matrisA;
temp2 = inv(temp);

x_lambda = temp2*transposeA*matrisB;


lane_matris = zeros(300,300);
counter=1;
for i = 1 : rows
    
    j = round(i^2*x_lambda(1) + i*x_lambda(2) + x_lambda(3));
    counter = counter +1;
    if counter ==2                 % yansýtma iþlemi için mesafeyi buluyoruz.
        distance = j-cordinate;  
    end
    
    lane_matris(i,j-5:j+5) = 255;
    lane_matris(i,j-distance:j-distance+10) = 255;  % yansýtma iþlemi
    
    
    rgb_image(i,j-5:j+5,2) = 255;
    rgb_image(i,j-distance+5:j-distance+10,1) = 255;  %rgb yansýtma
  
end
end
                                                               

        