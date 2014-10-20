%====================================================================
%
% Author: Cristhian Aguilera,  Department of Electrical and Electronics 
% Engineering, Collao 1202, University of Bío-Bío, 
% 4051381 Concepción, Chile,
% Email: cristhia@ubiobio.cl
%
% Title: Multispectral Image Feature Points
% Place of publication: Barcelona, Spain
%
% Available from: URL
% http://www.mathworks.com/matlabcentral/fileexchange
%
%% EOH-SIFT
% The piece of code here in shows an illustration
% of the a feature point descriptor for the multispectral 
% image case: Far-Infrared and Visible Spectrum images. It allows 
% matching interest points on images of the same scene but acquired 
% in different spectral bands. Initially, points of interest are 
% detected on both images through a SIFT-like based scale space 
% representation. Then, these points are characterized using an 
% Edge Oriented Histogram (EOH) descriptor. Finally, points of 
% interest from multispectral images are matched by finding nearest 
% couples using the information from the descriptor.
%
%Most of the code is build on top of Andreas Veldaldi SIFT Code.
%
%
% When using this software, PLEASE ACKNOWLEDGE the effort that went 
% into development BY REFERRING THE PAPER:
%
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
%
% Aguilera C., Barrera F., Lumbreras F., Sappa A., and Toledo R., 
% "Multispectral Image Feature Points", Sensors, Vol 12, No. 9, 
% September 2012, pp. 12661-12672.
% 
% Article url: http://www.mdpi.com/1424-8220/12/9/12661
% Github code: https://github.com/ngunsu/matlab-eoh-sift
%
%
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 


%% Clean
clc;
clear;
close all;

%%Conf
window_size = 50; % real size = window *2
%% Images

vis_filename = 'images/0000033_VSRRTC.bmp';
ir_filename  = 'images/0000033_IR1CTC.bmp';

I1=imreadbw(ir_filename);
I2=imreadbw(vis_filename);

I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;
        

%% Compile mex

% Linux
compile('GLNX86');

% Mac
%compile('MACI64');

%% Multiprocessor
%matlabpool 4

%% SIFT
fprintf(' Getting SIFT Keypoints and descriptors ....\n');

[frames1SIFT,descr1SIFT,gss1SIFT,dogss1SIFT]=sift( I1, 'Verbosity', 0 ) ;
[frames2SIFT,descr2SIFT,gss2SIFT,dogss2SIFT]=sift( I2, 'Verbosity', 0 ) ;

%scaling
descr1SIFT=uint8(512*descr1SIFT) ;
descr2SIFT=uint8(512*descr2SIFT) ;

tamFrames1SIFT=size(frames1SIFT);
tamFrames2SIFT=size(frames2SIFT); 
fprintf(' Getting SIFT Matches ....\n')
matchesSIFT=siftmatch( descr1SIFT, descr2SIFT ) ;

%Plot
figure(1) ; clf ;
plotmatches(I1,I2,frames1SIFT(1:2,:),frames2SIFT(1:2,:),matchesSIFT) ;
text=sprintf(' SIFT, (window_size=%d)',window_size); 
title(text);
drawnow ;

%% EOH-SIFT
fprintf(' Getting EOH-SIFT Keypoints and descriptors ....\n');

[frames1EOHSIFT,~]=sift( I1, 'Verbosity', 0,'Sigma0',1.2,'EdgeThreshold',40) ;
[frames2EOHSIFT,~]=sift( I2, 'Verbosity', 0,'Sigma0',1.2,'EdgeThreshold',40) ;

descr1EOHSIFT = getEOHDescriptors(frames1EOHSIFT,I1,window_size);
descr2EOHSIFT = getEOHDescriptors(frames2EOHSIFT,I2,window_size);

% Scaling
descr1EOHSIFT=uint8(512*descr1EOHSIFT) ;
descr2EOHSIFT=uint8(512*descr2EOHSIFT) ; 

matchesEOHSIFT=eohsiftmatch( descr1EOHSIFT, descr2EOHSIFT );

%Plot
figure(2) ; clf ;
plotmatches(I1,I2,frames1EOHSIFT(1:2,:),frames2EOHSIFT(1:2,:),matchesEOHSIFT) ;
text=sprintf(' EOH-SIFT, (window_size=%d)',window_size); 
title(text);
drawnow ;
