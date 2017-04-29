%% One Obstacle Lane per-Driving Direction (SINR outage)
clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 1;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_30_180_1_A.mat'));

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs([20, 50]) = [40, 100];
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 1;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_30_180_1_B.mat'));

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs([20, 50]) = [40, 100];
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 1;
antenna_sector = deg2rad(90);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_90_180_1_A.mat'));

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs([20, 50]) = [40, 100];
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 1;
antenna_sector = deg2rad(90);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_90_180_1_B.mat'));


%% Two Obstacle Lanes per-Driving Direction (SINR outage)
clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_30_180_2_A.mat'));

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs([20, 50]) = [40, 100];
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_30_180_2_B.mat'));

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs([20, 50]) = [40, 100];
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 2;
antenna_sector = deg2rad(90);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_90_180_2_A.mat'));

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs([20, 50]) = [40, 100];
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 2;
antenna_sector = deg2rad(90);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/data_Validation_90_180_2_B.mat'));


%% One Obstacle Lane per-Driving Direction (Rate Coverage)
clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs(20) = 40;
simSection = false;
getTh = false;
recoverRate = true;
getAssocProbs = false;
dataFile = '+tvt_activity/data/s_0_off/data_Validation_30_180_1_A.mat';
no_obs_lanes   = 1;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/rate_Validation_30_180_1_A.mat'), 'P_rate_coverage_lb', 'P_rate_coverage_sim');

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs(20) = 40;
simSection = false;
getTh = false;
recoverRate = true;
getAssocProbs = false;
dataFile = '+tvt_activity/data/s_0_off/data_Validation_30_180_1_B.mat';
no_obs_lanes   = 1;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/rate_Validation_30_180_1_B.mat'), 'P_rate_coverage_lb', 'P_rate_coverage_sim');


%% Two Obstacle Lanes per-Driving Direction (Rate Coverage)
clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs(20) = 40;
simSection = false;
getTh = false;
recoverRate = true;
getAssocProbs = false;
dataFile = '+tvt_activity/data/s_0_off/data_Validation_30_180_2_A.mat';
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/rate_Validation_30_180_2_A.mat'), 'P_rate_coverage_lb', 'P_rate_coverage_sim');

clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
no_bs = zeros(1,length(2:2:200));
no_bs(20) = 40;
simSection = false;
getTh = false;
recoverRate = true;
getAssocProbs = false;
dataFile = '+tvt_activity/data/s_0_off/data_Validation_30_180_2_B.mat';
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/rate_Validation_30_180_2_B.mat'), 'P_rate_coverage_lb', 'P_rate_coverage_sim');


%% Two Obstacle Lanes per-Driving Direction (Assoc. Prob)
clearvars;
alpha_nlos = 5.76;
userYoff = -3.7/2;
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = true;
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/assoc_Validation_30_180_2_A.mat'), 'served_los_count_sim', 'served_los_count_th');

%% ZOOM In
% Two Obstacle Lanes per-Driving Direction (Assoc. Prob)
clearvars;
alpha_nlos = 5.76;
no_bs    = 2:1:10;
userYoff = -3.7/2;
simSection = true;
getTh = true;
recoverRate = false;
getAssocProbs = true;
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner
baseName = '+tvt_activity/data/s_0_off';
save(strcat(baseName,'/assoc_Validation_30_180_2_A_zoom.mat'), 'served_los_count_sim', 'served_los_count_th');

%% One Obs. Lane (p_L)
clearvars;
simPl = true;
userYoff = -3.7/2;
alpha_nlos = 4;
simSection = true;
VrT = 0.1;
no_bs = 1;
getTh = true;
recoverRate = false;
getAssocProbs = true;
no_obs_lanes   = 1;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = 2e2;
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner_pL
baseName = '+tvt_activity/data/s_Inf';
save(strcat(baseName,'/pL_30_180_1_A.mat'));
%system('cp -r +tvt_activity/data /home/at15088/Dropbox/UoB')

% Two Obs. Lanes (p_L)
clearvars;
simPl = true;
userYoff = -3.7/2;
alpha_nlos = 4;
simSection = true;
VrT = 0.1;
no_bs = 1;
getTh = true;
recoverRate = false;
getAssocProbs = false;
no_obs_lanes   = 2;
antenna_sector = deg2rad(30);
b_span         = deg2rad(180);
no_obs         = [2e2, 1e2];
road_len       = 1e4;
txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
tvt_activity.stochasticLib.scenarioRunner_pL
baseName = '+tvt_activity/data/s_Inf';
save(strcat(baseName,'/pL_30_180_2_A.mat'));
%system('cp -r +tvt_activity/data /home/at15088/Dropbox/UoB')
