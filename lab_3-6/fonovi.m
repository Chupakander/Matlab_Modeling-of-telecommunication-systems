function [outputArg1,outputArg2] = fonovi(inputArg1,inputArg2)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
random_array = inputArg1;
r1r=zeros(inputArg2,6);
r2r=zeros(inputArg2,6);

i = inputArg2;

z=1;
for j=1:i
r1 = randi([1, 17]);
r2=r1;

while(r2==r1)
r2=randi([1,17]);
zer=r1-1;
zero=r1+1;
if(r2==r1 || r2==zer ||r2==zero ||r2==14||r2==10||r2==6||r2==2)
    r2=r1;
end
end
disp([' '])
disp(['Случайное целое число12: ', num2str(r1),' ',num2str(r2)]);
disp([' '])
r2r(z,1:5)=random_array(r2,:);
r1r(z,1:5)=random_array(r1,:);
r1r(z,6)=r1;
r2r(z,6)=r2;
z=z+1;
end
outputArg1=r1r;
outputArg2=r2r;
end
