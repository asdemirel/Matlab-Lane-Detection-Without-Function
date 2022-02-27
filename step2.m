
%Bu kod parçacýðý makalenin step 2 kýsmýný gerçekleþtiriyor.

%STEP 2 ADIMLARI :
% 1 ) ROI alaný belirlendi.
% 2 ) ROI alanýn transfer edileceði hedef noktalarý belirlendi.
% 3 ) Transformasyon matrisi oluþturuldu.
% 4 ) Interpolation uygulandý

clc;clear all; close all;

image = load('and_image');

and_image = image.and_image;

image2 = imread('road8.png');

% % road.jpeg için geçerli.
% x1 = 500 ; y1 = 650;
% x2 = 500 ; y2 = 1030;
% x3 = 830 ; y3 = 350;
% x4 = 830 ; y4 = 1540;

% %road2.jpeg için geçerli.
% x1 = 350 ; y1 = 350;
% x2 = 350 ; y2 = 600;
% x3 = 430 ; y3 = 210;
% x4 = 430 ; y4 = 700;

% % %road3.jpeg için geçerli.
% x1 = 160 ; y1 = 120;
% x2 = 160 ; y2 = 210;
% x3 = 210 ; y3 = 75;
% x4 = 210 ; y4 = 255;

% % road5.jpg için geçerli.
% x1 = 316; y1 = 300;
% x2 = 316 ; y2 = 570;
% x3 = 374 ; y3 = 160;
% x4 = 374 ; y4 = 630;

% % road6.jpg için geçerli.
% x1 = 205; y1 = 85;
% x2 = 205 ; y2 = 290;
% x3 = 275 ; y3 = 20;
% x4 = 275 ; y4 = 310;


% % road6.jpg için geçerli.
% x1 = 168; y1 = 172;
% x2 = 168 ; y2 = 365;
% x3 = 220 ; y3 = 220;
% x4 = 190 ; y4 = 459;


% % road7.jpg için geçerli.
% x1 = 330; y1 = 270;
% x2 = 330 ; y2 = 545;
% x3 = 420 ; y3 = 225;
% x4 = 420 ; y4 = 660;

% % road8.png için geçerli.
x1 = 230; y1 = 247;
x2 = 230 ; y2 = 387;
x3 = 296 ; y3 = 184;
x4 = 296 ; y4 = 434;



%HEDEF NOKTALAR
X1 = 0; Y1 = 0;     X2 = 0; Y2 = 300;
X3 = 300; Y3 = 0;   X4 = 300; Y4 = 300;

matrix_C = [X1;Y1;X2;Y2;X3;Y3;X4;Y4];

% TRANSFORMASYON MATRÝSÝ
matrix_B = [x1, y1, 1, 0, 0, 0, -X1*x1, -X1*y1;
            0, 0, 0, x1, y1, 1, -Y1*x1, -Y1*y1;
            x2, y2, 1, 0, 0, 0, -X2*x2, -X2*y2;
            0, 0, 0, x2, y2, 1, -Y2*x2, -Y2*y2;
            x3, y3, 1, 0, 0, 0, -X3*x3, -X3*y3;
            0, 0, 0, x3, y3, 1, -Y3*x3, -Y3*y3;
            x4, y4, 1, 0, 0, 0, -X4*x4, -X4*y4;
            0, 0, 0, x4, y4, 1, -Y4*x4, -Y4*y4];


matrix_A = matrix_B\matrix_C;
save('matrix_A','matrix_A');

perspective_image = uint8(zeros(300,300));
rgb_perspective = uint8(zeros(300,300,3));
[rows,cols,index] = size(and_image);

for i=1:rows
    for j=1:cols
        X = ceil((matrix_A(1)*i + matrix_A(2)*j + matrix_A(3))/(matrix_A(7)*i + matrix_A(8)*j + 1));
        Y = ceil((matrix_A(4)*i + matrix_A(5)*j + matrix_A(6))/(matrix_A(7)*i + matrix_A(8)*j + 1));
        if( X > X1 && X < X4 && Y > Y1 && Y < Y4)
            perspective_image(X,Y,:) = and_image(i,j,:);
            rgb_perspective(X,Y,:) = image2(i,j,:);
            
        end     
    end
end

perspective_not_interpolation = perspective_image;

%ÝNTERPOLATÝON
param = 8;
for x=1 : 300-param
    for y=1 : 300-param
        if perspective_image(x,y,1) == 0 
        perspective_image(x,y,1) = mean(mean(nonzeros(double(perspective_image(x:x+param ,y:y+param,1)))));
        if rgb_perspective(x,y,1) == 0
            rgb_perspective(x,y,1) = mean(mean(nonzeros(double(rgb_perspective(x:x+param ,y:y+param,1)))));
            rgb_perspective(x,y,2) = mean(mean(nonzeros(double(rgb_perspective(x:x+param ,y:y+param,2)))));
            rgb_perspective(x,y,3) = mean(mean(nonzeros(double(rgb_perspective(x:x+param ,y:y+param,3)))));
        end
        end
    end
end

pers_hist = sum(perspective_image(:,:))/255;

save('perspective','pers_hist','perspective_image','rgb_perspective');


figure;subplot(2,3,1);imshow(and_image);title('Neighbordhood AND Operator Result');
subplot(2,3,2);imshow(perspective_not_interpolation);title('Not Interpolation Perspective Image');
subplot(2,3,3);imshow(perspective_image);title('Bird Eye View Transform with Interpolation ');
subplot(2,3,4);plot(pers_hist);title('Binary Image Histogram ');
subplot(2,3,5);imshow(rgb_perspective);title('RGB Perspective Image');

