
% Open video file in grayscale
filename = 'video2.avi';

VideoSource = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity','VideoOutputDataType', 'double');
VideoOut = vision.VideoPlayer('Name', 'Video');

input = step(VideoSource);

imshow(input)
hold
% Get the target position 
Idx = round(ginput(1));

% Get search region
ROI = single(getrect());

%plot(Idx(1),Idx(2),'r.','MarkerSize',20)

% Get the SURF features around the target location

points = detectSURFFeatures(input,'ROI',ROI,'MetricThreshold',100);

% Search for the closest strong point and assign the target to it
lct = points.Location;
lct = [lct(:,1) - Idx(1) lct(:,2) - Idx(2)];
lct = sqrt(lct(:,1).^2 + lct (:,2).^2);
[~,min_idx] = min(lct);
Target_point = points(min_idx);
Idx = Target_point.Location;
plot(Idx(1),Idx(2),'r.','MarkerSize',20)

% Extract Features
[features,valid_points] = extractFeatures(input,Target_point);
 
 % Initialize Kalman filter
 kalmanFilter = configureKalmanFilter('ConstantAcceleration',...
               Idx, 0.001*ones(1, 3), [30, 30, 50], 10);
Kidx = Idx;
 %% Loop for all the video
 while ~isDone(VideoSource)
    input = step(VideoSource); 
	pause(0.016);
	
% Get SURF point from the new frame and match with target

   points1 = detectSURFFeatures(input,'ROI',ROI,'MetricThreshold',100);
   [features,valid_points] = extractFeatures(input,Target_point);
   [features1,valid_points1] = extractFeatures(input,points1);
   [indexPairs,matchmetric] = matchFeatures(features,features1,'MatchThreshold',3) ;
   
   if indexPairs
   
% If matched update the target to the matched point and update search area   

        Target_point = points1(indexPairs(1));
        Vector = Target_point.Location - Idx;
        Idx = Target_point.Location;
        ROI = [ ROI(1)+Vector(1) ROI(2)+Vector(2) ROI(3) ROI(4)];
		SURF = 1
% Step Kalman filter

        predict(kalmanFilter);
        k = correct(kalmanFilter, Idx);
   else
   Kalman = 1
% Predict new position

        Idx = predict(kalmanFilter);
		
% Get translation vector and update the search area (centralize on the predicted location)

	    Vector = Idx - Target_point.Location;
	    
		
% Repeat first steps to find the closest strong point to the target

	    points = detectSURFFeatures(input,'ROI',ROI,'MetricThreshold',100);
		if points.Count
			ROI = [ ROI(1)+Vector(1) ROI(2)+Vector(2) ROI(3) ROI(4)];
			lct = points.Location;
			lct = [lct(:,1) - Idx(1) lct(:,2) - Idx(2)];
			lct = sqrt(lct(:,1).^2 + lct (:,2).^2);
			[~,min_idx] = min(lct);
			Target_point = points(min_idx);
			Idx = Target_point.Location;
			[features,valid_points] = extractFeatures(input,Target_point);
		end
   end
   
   Kidx = [Kidx;k];
   imshow(input)
	hold on;
	plot(Idx(1),Idx(2),'r.','MarkerSize',20)
	rectangle('Position',ROI);
    %waitfor(msgbox('Continue'));
 end