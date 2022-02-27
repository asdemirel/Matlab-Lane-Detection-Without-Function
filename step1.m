
%Bu kod par�ac��� makalenin step 1 k�sm�n� ger�ekle�tiriyor.

%STEP 1 ADIMLARI :
% 1 ) RGB formattaki frame'i grayscale'e �evir.
% 2 ) Grayscale g�r�nt�den IB1 ve IB2 ad�nda binary g�r�nt� olu�tur.
% 3 ) IB1 global threshold uygulanm�� binary g�r�nt�d�r(logical tipine sahiptir).
% 4 ) IB2 sobel filtresi uygulanm�� binary g�r�nt�d�r.
% 5 ) IB1 ve IB2 Neighborhood AND operatoru uyguland�. k filtre boyutunu
%     belirleyen parametredir. 

% NOTLAR/EKS�KLER: Sobel filtresinden sonra g�r�nt� binary(0 ve 1) formatta olmuyor.Bundan
%                  dolay� Neighbord And operatoru uygulad���mda siyah olmas�n�
%                  bekledi�im yerlerde g�r�lt�ye benzer beyazl�klar al�yorum.
%
% �NER�M : Sobel filtresinden sonra olu�an g�r�nt�ye global threshold uygulamak.
         

clc;clear all; close all;
% image = imread('road.jpeg');
% image = imread('road2.jpeg');
% image = imread('road3.jpg');
% image = imread('road4.jpg');
% image = imread('road5.jpg');
% image = imread('road6.jpg');
% image = imread('road7.jpg');
 image = imread('road8.png');

gray = 0.299 * image(:,:,1) + 0.587 *image(:,:,2)+ 0.114*image(:,:,3);

[rows,cols] = size(gray);

and_image = uint8(zeros(rows,cols));

thresh = graythresh(gray);          %global threshold.
IB1 = imbinarize(gray,thresh);

IB2 = uint8(zeros(rows,cols));

A=double(gray); % uint8 format�nda g�nderdi�imde undefined function 'sqrt' hatas� ald�m.

% SOBEL F�LTRELEME ��LEM� = IB2 
for i=1:size(A,1)-2
    for j=1:size(A,2)-2
    %Yatay sobel kernel matrisi
    Gx=((2*A(i+2,j+1)+A(i+2,j)+A(i+2,j+2))-(2*A(i,j+1)+A(i,j)+A(i,j+2)));
    %Dikey sobel kernel matrisi
    Gy=((2*A(i+1,j+2)+A(i,j+2)+A(i+2,j+2))-(2*A(i+1,j)+A(i,j)+A(i+2,j)));
    IB2(i,j)=sqrt(Gx.^2+Gy.^2);
    end
end

thresh2 = graythresh(IB2);
IB2 = imbinarize(IB2,thresh2);


% NE�GHBORHOOD AND ��LEM�

and_kernel=2;  %and_kernel *2 + 1'lik filtre gezdiriyorum. 

for i = 1 + and_kernel : rows-and_kernel
    for j = 1+and_kernel : cols-and_kernel
        
       temp1 = IB1(i-and_kernel:i+and_kernel,j-and_kernel:j+and_kernel);
       temp2 = IB2(i-and_kernel:i+and_kernel,j-and_kernel:j+and_kernel);
       
       temp1 = sum(sum(temp1));
       temp2 = sum(sum(temp2));
       
       if temp1*temp2 ==0
           and_image(i-and_kernel,j-and_kernel)=0;
       else
           and_image(i-and_kernel,j-and_kernel)=255;
       end
       
    end
end

save('and_image','and_image');

figure;
subplot(1,3,1);imshow(IB1);title('IB1 --> GLOBAL THRESHOLD');
subplot(1,3,2);imshow(IB2);title('IB2 --> SOBEL FILTER');
subplot(1,3,3);imshow(and_image);title('AND �MAGE  --> NEIGHBORHOOD AND OPERATOR');

