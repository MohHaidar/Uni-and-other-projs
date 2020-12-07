function [result,M]=tmp(image1,image2,ROI)
%
% By Alaa Eleyan Nov,2005
%*********************************************************

if size(image1,3)==3
    image1=rgb2gray(image1);
end
if size(image2,3)==3
    image2=rgb2gray(image2);
end

% check which one is target and which one is template using their size

if size(image1)>size(image2)
    Target=image1;
    Template=image2;
else
    Target=image2;
    Template=image1;
end
% get region of interest
background = Target;
Target = Target(ROI(2):ROI(2)+ROI(4),ROI(1):ROI(1)+ROI(3));

% find both images sizes
[Target_rows,Target_cols]=size(Target);
[Template_rows,Template_cols]=size(Template);

% mean of the template
%image22=Template-mean(mean(Template));

%correlate both images
M=zeros(Target_rows-Template_rows+1,Target_cols-Template_cols+1);

for i=1:(Target_rows-Template_rows+1)
    for j=1:(Target_cols-Template_cols+1)
        Nimage=Target(i:i+Template_rows-1,j:j+Template_cols-1);
        %Nimage=Nimage-mean(mean(Nimage));  % mean of image part under mask
        %corr=sum(sum(Nimage.*image22));
        %warning off
        %M(i,j)=corr/sqrt(sum(sum(Nimage.^2)));
		M(i,j)=corr2(Nimage,Template);
    end 
end


% Pad a black space to the corr matrix to the size of image
% making it easy to get the position
N = zeros(size(background));
N(ROI(2):ROI(2)+Target_rows-Template_rows,ROI(1):ROI(1)+Target_cols-Template_cols) = M;
M=N;
% plot box on the target image
result=plotbox(background,Template,M);