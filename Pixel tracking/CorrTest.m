% Open video file in grayscale
filename = 'video2.avi';

VideoSource = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity','VideoOutputDataType', 'double');
VideoOut = vision.VideoPlayer('Name', 'Video');

% Get first frame
input = step(VideoSource);

imshow(input)
Target_rect = single(getrect());
pos.template_orig = Target_rect(1:2);
pos.template_size = Target_rect(3:4);
%msgbox('Specify search area');
Search_rect = single(getrect());
pos.search_border = [round((Search_rect(3)-Target_rect(3))/2) round((Search_rect(4)-Target_rect(4))/2)];
%fileInfo = info(VideoSource);
%sz = fileInfo.VideoSize;

%% Initiate the search parameters

%position of the first template
%pos.template_orig = [194 79]; % [x y] upper left corner
%pos.template_size = [50 69];   % [width height]
%pos.search_border = [30 20];   % max horizontal and vertical displacement
pos.template_center = floor((pos.template_size - 1)/2);   % radius
pos.template_center_pos = (pos.template_orig + pos.template_center -1 );   % center
SearchRegion = pos.template_orig - pos.search_border - 1;   % search region
TargetRowIndices = pos.template_orig(2)-1:pos.template_orig(2)+pos.template_size(2)-2; % Target indexes
TargetColIndices = pos.template_orig(1)-1:pos.template_orig(1)+pos.template_size(1)-2;
Idx = pos.template_center_pos; % position of the center of target
Midx = Idx; % Cumulative measured indexes
Kidx = Idx; % Cumulative Kalman indexes
CMC = 0;

% Initiate Kalman filter
kalmanFilter = configureKalmanFilter('ConstantAcceleration',...
               Idx, ones(1, 3), [100, 100, 10], 25);
			   
% Get first frame
input = step(VideoSource);

Target = input(TargetRowIndices,TargetColIndices); % Target image
kalman = 0;  
frame= 0;
         
%% Loop on all the video
while ~isDone(VideoSource)
    input = step(VideoSource); 
	frame = frame + 1;
	% Calculate Region of interest
    ROI = [SearchRegion, pos.template_size+2*pos.search_border];
	
	% Correlate the target with frame
	
	[result,M] = tmp(Target,input,ROI);
	
	% Find the index for max correlation (use if on threshold here, if Max_corr is 
	% small the object is missing and we use Kalman prediction for new index and 
	% to update target.
	
	Max_Corr = max(M(:));
    CMC = [CMC Max_Corr];
	
	
	    [row_pos,col_pos] = find(M==Max_Corr);
	    pos.template_orig = [col_pos row_pos];
	    pos.template_center_pos = (pos.template_orig + pos.template_center -1 ); 
	    Idx = pos.template_center_pos;
    
    % Update Midx
	    Midx = [Midx;Idx]; %#ok<AGROW>
		
	if Max_Corr >= 0.1
	
        Found = 1
    % Step Kalman filter 	
		predict(kalmanFilter);
        k = correct(kalmanFilter, Idx);
		
	% Update search region
	    SearchRegion = pos.template_orig - pos.search_border - 1;
	    
    else
		kalman = kalman + 1
        frame
        
    % Kalman filter correction
        k = round(predict(kalmanFilter));
	    Idx = k;
	
	% Update Target
	    pos.template_orig = Idx - pos.template_center +1;
        TargetRowIndices = pos.template_orig(2)-1:pos.template_orig(2)+pos.template_size(2)-2; 
        TargetColIndices = pos.template_orig(1)-1:pos.template_orig(1)+pos.template_size(1)-2;
	    Target = input(TargetRowIndices,TargetColIndices);
	
	% Update search region
	    SearchRegion = pos.template_orig - pos.search_border - 1;
	end
	
	Kidx = [Kidx;k]; %#ok<AGROW>
	
    %% show the results
    imshow(input)
	hold on;
	plot(Idx(1),Idx(2),'r.','MarkerSize',20)

    step(VideoOut,result);


end

