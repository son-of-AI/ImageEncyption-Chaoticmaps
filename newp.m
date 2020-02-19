clc;
clear all;
pkg load image;

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
 
 x=ceil(mod((x*100000),image_height));
 y=ceil(mod((y*100000),image_height));
 z=ceil(mod((z*100000),image_height));
 
rgb=imread('iiest.jpeg');
[row,col,ht]=size(rgb);
