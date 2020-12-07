%% Initialization

% Import variables
global avrg;

Q = 0.00005;                    %Process variance (controls the change in the filtered signal, how much the process model is trusted) 
R = 0.000379;                   %Measurement variance 
H = zeros(1,length(avrg));      %Accumulated error (a posteriori)
H_ = zeros(1,length(avrg));     %Predicted errror (a priori)
P = zeros(1,length(avrg));      %Power corrected (a posteriori)
P_ = zeros(1,length(avrg));     %Predicted Power (a priori)
K = zeros(1,length(avrg));      %Kalman gain

%% first smaple
P(1) = avrg(1);                 %Initial state is the first measurement
H(1) = 0.0003;                  %The error margin on estimation of first measurement as initial state

%% Kalman process
for i=2:length(avrg)
    
    %predict
    P_(i) = P(i-1);                      %  x_[k+1] = A.x[k] + B.u[k]  (A = 1, B = 0)    Predicted (a priori) state estimate 
    H_(i) = H(i-1) + Q;                  %  H_[k+1] = A.H[k].A'+Q                        Predicted (a priori) estimate covariance 
    
    %update
    K(i) = H_(i)/(H_(i)+R);              %  K[k] = H_[k].C'.(R + C.H_[k].C')^-1  (C = 1) Optimal Kalman gain
    P(i) = P_(i) + K(i)*(avrg(i)-P_(i)); %  x[k] = P_[k] + K[k].(z[k] - C.x_[k])         Updated (a posteriori) state estimate
    H(i) = (1-K(i))*H_(i);               %  H[k] = (I - K[k].C).H_[k]                    Updated (a posteriori) estimate covariance
    
end

%% Plot 
global time;
global m_avg;

plot(time,avrg)
hold
%plot(time,m4_avg)
plot(time,P)

%Annotation for standard deviation
srt = {['P data std: ',num2str(std(avrg))],...
    ['3 samples averaged std: ',num2str(std(m_avg(3:length(m_avg))))],...
    ['Kalman filter std: ',num2str(std(P(2:length(P))))]};
%annotation('textbox',[.4 .2 .5 .5],'String',srt,'FitBoxToText','on');