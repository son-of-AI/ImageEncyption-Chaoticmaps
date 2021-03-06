clc;
clear all;
pkg load image;
%3D chaotic map for image encryption
%3.53<l<3.81
%0<b<0.022
%0<a<0.015

%modify the chaos by this equation furthure
%z(i+1)=l*z(i)*(1-z(i))+b*x(i)*x(i)*z(i)+a*y(i)*y(i)*y(i);
%initial conditions
%%%%%%%%%%%%%%%%%%%% 3D CHAOS GENERATION CODE%%%%%%%%%%%%%%%%%%%%%%

 x(1)=0.2350;
 y(1)=0.3500;
 z(1)=0.7350;
 a=0.0125;
 b=0.0157;
 l=3.7700;
 image_height=256;
 for i=1:1:70000
     x(i+1)=l*x(i)*(1-x(i))+b*y(i)*y(i)*x(i)+a*z(i)*z(i)*z(i);
     y(i+1)=l*y(i)*(1-y(i))+b*z(i)*z(i)*y(i)+a*x(i)*x(i)*x(i);
     z(i+1)=l*z(i)*(1-z(i))+b*x(i)*x(i)*z(i)+a*y(i)*y(i);
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%histogram equalization and preparation for use%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 x=ceil(mod((x*100000),image_height));
 y=ceil(mod((y*100000),image_height));
 z=ceil(mod((z*100000),image_height));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%IMAGE INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
original=imread('iiest.jpeg');
rgb=rgb2gray(original);
[row,col]=size(rgb);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%INITIALIZE THE VALUE OF ROTATION%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=500;
p=600;
q=700;
for j=1:1:row
    k(j)=x(j+n);
    l(j)=y(j+p);
end


for j=1:1:col*row
    m(j)=z(j+q);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF k is even right shift row else left shift row%%%%%%%%%%%%%%%%%
% If l is even shift up column else down shift column%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%ROTATION OPERATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:1:row
    for j=1:1:col
        if(mod(k(i),2)==0)
            if((j+k(i))<=col)   %shift right of row
               sh_row(i,j+k(i))=rgb(i,j);
               row_shift_even(i,j)=j+k(i);
            else
               sh_row(i,(j+k(i)-col))=rgb(i,j); 
               row_shift_even(i,j)=(j+k(i)-col);
            end
        else
            if((j-k(i))>=1)       %shift left of row
                sh_row(i,j-k(i))=rgb(i,j);
                row_shift_odd(i,j)=j-k(i);
            else
                sh_row(i,(col+j-k(i)))=rgb(i,j);
                row_shift_odd(i,j)=col+j-k(i);
            end
        end
    end
end
   

for j=1:1:col
    for i=1:1:row
        if(mod(l(j),2)==0)
           if((i-l(j))>=1)          %shift up of column
                sh_col(i-l(j),j)=sh_row(i,j);
                col_shift_even(i,j)=i-l(j);
            else
                sh_col((row+i-l(j)),j)=sh_row(i,j);
                col_shift_even(i,j)=row+i-l(j);
            end
        else
           if((i+l(j))<=row)           %shift down of column
               sh_col(i+l(j),j)=sh_row(i,j);
               col_shift_odd(i,j)=i+l(j);
               else
               sh_col((i+l(j)-row),j)=sh_row(i,j); 
               col_shift_odd(i,j)=(i+l(j)-row);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%XOR IMAGE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
total_length=row*col;
column_image=reshape(sh_col,1,total_length);
for i=1:1:total_length
xorr1(1,i)=bitxor(column_image(i),m(i));
end
y=reshape(xorr1,row,col);
imwrite(y, 'encypted_peppers.jpg', 'Quality', 100);
figure
subplot(3,2,1)
imshow(rgb)
title('Original Image');
subplot(3,2,2)
imhist(rgb)
title('Histogram of original Image');

subplot(3,2,3)
imshow(y)
title('Encrypted Image');
subplot(3,2,4)
imhist(y)
title('Histogram of Encrypted Image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%Decryption XOR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row,col]=size(y);
rgb=y;
total_length=row*col;
column_image=reshape(rgb,1,total_length);
for i=1:1:total_length
        xorr1(1,i)=bitxor(column_image(i),m(i));
end
shuffled_image=reshape(xorr1,row,col);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF k is even right shift row else left shift row%%%%%%%%%%%%%%%%%
% If l is even shift up column else down shift column%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%ROTATION OPERATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%ROW SHIFTING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:col
    for i=1:1:row
        if(mod(l(j),2)==0)
           if((i+l(j))<=row)           %shift down of column
               sh_col(i+l(j),j)=shuffled_image(i,j);
               col_shift_even(i,j)=i+l(j);
               else
               sh_col((i+l(j)-row),j)=shuffled_image(i,j); 
               col_shift_even(i,j)=(i+l(j)-row);
            end
        else
           if((i-l(j))>=1)          %shift up of column
                sh_col(i-l(j),j)=shuffled_image(i,j);
                col_shift_odd(i,j)=i-l(j);
            else
                sh_col((row+i-l(j)),j)=shuffled_image(i,j);
                col_shift_odd(i,j)=row+i-l(j);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i=1:1:row
    for j=1:1:col
        if(mod(k(i),2)==0)
            if((j-k(i))>=1)       %shift left of row
                sh_row(i,j-k(i))=sh_col(i,j);
                row_shift_even(i,j)=j-k(i);
            else
                sh_row(i,(col+j-k(i)))=sh_col(i,j);
                row_shift_even(i,j)=col+j-k(i);
            end
        else
            if((j+k(i))<=col)   %shift right of row
               sh_row(i,j+k(i))=sh_col(i,j);
               row_shift_even(i,j)=j+k(i);
            else
               sh_row(i,(j+k(i)-col))=sh_col(i,j); 
               row_shift_even(i,j)=(j+k(i)-col);
            end
        end
    end
end
   

subplot(3,2,5)
imshow (sh_row)
title('decrypted image');

subplot(3,2,6)
imhist(sh_row)
title('histogram decrypted image');

imwrite(sh_row, 'Decrypted_lena_v2.jpg', 'Quality', 100);
