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
o = dec2bin(rgb, 8);
o = [o(:)];
N=size(o,1);
o=reshape(o,N/8,8);
r=bin2dec(o);

size(r);
%c = uint8(reshape(r,256,256,1));
%size(c);
%imshow(c)
%n=500;
%p=600;
%q=700;




