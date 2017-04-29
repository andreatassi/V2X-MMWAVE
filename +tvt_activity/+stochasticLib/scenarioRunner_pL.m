%% Init Simulation Pars.
%clearvars;

seed       = 3; % General Seed
iterations = 1e5;

% Road Layout
try
    tmp = road_len;
catch
    road_len      = 5e4;
end
road_len_sampled  = 1e4;
road_x_start      =  -road_len;
try
    tmp = no_bs;
catch
    no_bs             = 2:2:200;
end
%no_obs            = 2e2;
%no_obs_lanes      = 1;
lambda_bs         = no_bs ./ road_len_sampled;

lambda_obs_top    = (no_obs./road_len_sampled) .* ones(1, no_obs_lanes);
lambda_obs_bottom = (fliplr(no_obs)./road_len_sampled) .* ones(1, no_obs_lanes);

lambda_obs        = { lambda_obs_top, lambda_obs_bottom };
lane_width        = 3.7;
road_width        = lane_width * ( length(lambda_obs_top) + length(lambda_obs_bottom) + 2 );
obs_footprint     = 11.1;
obs_vert_footprint= 2.52;
maxSpeed = 96 * 1000 / (60 * 60); % 96 Km/h (UK law)
driverReacationTime = 1; % [s]
maxAcceleration = 5.3; % m/s^2
maxDeceleration = 5.3; % m/s^2
maxUserSpeed = 112 * 1000 / (60 * 60); % 112 Km/h (UK law)
userLen = 4; % m
userDes = 2e-3;

% Comms. Pars.
freqSim        = 2.8e10;
alpha_los      = 2.8;
try
    tmp = alpha_nlos;
catch
    alpha_nlos     = 3.86;
end
C_los          = 1; % This value is NOT equal to 1! Please, refer to the definition of thermal_Noise
C_nlos         = 1; % This value is NOT equal to 1! Please, refer to the definition of thermal_Noise
%antenna_sector = deg2rad(60);
%b_span         = deg2rad(90);
% txAntenna_maxGain  = tvt_activity.utils.db2Lin(20);
% txAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
% rxAntenna_maxGain  = tvt_activity.utils.db2Lin(10);
% rxAntenna_minGain  = tvt_activity.utils.db2Lin(-10);
Pt                 = 0.5;
BW                 = 100e6; % 100MHz
thermal_Noise_dbm  = 10 * log10( 1.381 * 1e-23 * 290 * BW * 1e3 );
thermal_Noise      = tvt_activity.utils.db2Lin(thermal_Noise_dbm - 30) / tvt_activity.utils.getFSPL(freqSim);
SINR_Max           = tvt_activity.utils.db2Lin(100);

mNakagami = 3;

% Investigated Pars.
R = road_width/2;
try
    tmp = theta_val_db;
catch
    theta_val_db = -5:2:45;
end
theta_val = tvt_activity.utils.db2Lin(theta_val_db);
theta_val_len = length(theta_val);
rate_val = (0:20:1000) * 1e6; % bps
rate_val_len = length(rate_val);
lambda_bs_len = length(lambda_bs);
t_ = 0;
norm_rx_pow = NaN * zeros(lambda_bs_len, iterations); % dBm - txAntenna_maxGain_dB - rxAntenna_maxGain_dB
%% Generate Scenario Instances
if simSection
    rng(seed);
    served_los_count_sim = zeros(lambda_bs_len, iterations);
    SINR_outage_count = zeros(lambda_bs_len, theta_val_len, iterations);
    rate_coverage_count = zeros(lambda_bs_len, rate_val_len, iterations);
    % -------- %
    baseName = '+tvt_activity/data';
    try
        filename = strcat(baseName,'/kraussTrace_pL_', num2str(road_len), '_', num2str(2*length(no_obs)), '_', num2str(1),'.mat');
        tt_ = matfile(filename);
        tt_.pos(1,1);
    catch
        itK = iterations;
        tvt_activity.utils.kraussGen(2*length(no_obs), [lambda_obs_top, lambda_obs_bottom], road_len, obs_footprint, ...
            maxSpeed, maxUserSpeed, userDes, userLen, maxAcceleration, maxDeceleration, driverReacationTime, ...
            itK, ...
            baseName, VrT);
    end
    for l = 1:2*length(no_obs)
        filename = strcat(baseName,'/kraussTrace_pL_', num2str(road_len), '_', num2str(2*length(no_obs)), '_', num2str(l),'.mat');
        mHandler{l} = matfile(filename);
    end
    % -------- %
    timerBlock_top = 0;
    countTimers_top = [];
    timerBlock_bottom = 0;
    countTimers_bottom = [];
    cNt = 0;
    cNb = 0;
    for it = 1:iterations
        fprintf('[Sim.] It no. %i of %i\n', it, iterations);
        theta_val_loop = theta_val;
        rate_val_loop = rate_val;
        lambda_bs_loop_val = lambda_bs;
        SINR = NaN;
        for lambda_idx = 1:lambda_bs_len
            if lambda_bs_loop_val(lambda_idx) == 0
                continue;
            end
            [ obs_lanes_top, bs_lane_top, ...
                obs_lanes_bottom, bs_lane_bottom ] = tvt_activity.stochasticLib.assembleScenario( lambda_bs_loop_val(lambda_idx), lambda_obs, ...
                road_len, road_width, lane_width, road_x_start, ...
                false, mHandler, it );
            [ bs_pl_map_top, bs_pl_map_bottom, bs_antTxGain_top, bs_antTxGain_bottom, ...
                bs_pl_top, bs_pl_bottom ] = tvt_activity.stochasticLib.assembleRf( obs_lanes_top, bs_lane_top, obs_lanes_bottom, bs_lane_bottom, antenna_sector, b_span, obs_footprint, obs_vert_footprint, ...
                C_los, alpha_los, C_nlos, alpha_nlos, ...
                txAntenna_maxGain, txAntenna_minGain, userYoff, false);
            
            bs_virtual_lane = [ bs_lane_top; bs_lane_bottom];
            bs_antTxGain = [ bs_antTxGain_top; bs_antTxGain_bottom ];
            bs_pl_map = [ bs_pl_map_top, bs_pl_map_bottom ];
            bs_pl = [ bs_pl_top, bs_pl_bottom ];
            x_bs = bs_virtual_lane(:, 1);
            no_bs_loop = length(x_bs);
            dist_to_closest_los_bs = min( x_bs( bs_pl_map == 0 ) );
            dist_to_closest_nlos_bs = min( x_bs( bs_pl_map == 1 ) );
            [ serving_pl, serving_bs_idx ] = max( bs_pl );
            
            sim_pL(it) = sum(bs_pl_map == 1) / length(bs_pl_map);
            
            [ bs_pl_map_top_, bs_pl_map_bottom_, ~, ~, ~, ~ ] = tvt_activity.stochasticLib.assembleRf( obs_lanes_top, [0 (length(no_obs) + 1) * lane_width], obs_lanes_bottom, [0 -(length(no_obs) + 1) * lane_width], antenna_sector, b_span, obs_footprint, obs_vert_footprint, ...
                C_los, alpha_los, C_nlos, alpha_nlos, ...
                txAntenna_maxGain, txAntenna_minGain, userYoff, false);
             if bs_pl_map_top_ == 1
                 timerBlock_top = timerBlock_top + VrT;
                 cNt = cNt + 1;
             elseif bs_pl_map_top_ == 0 && timerBlock_top ~= 0
                 countTimers_top = [countTimers_top, timerBlock_top];
                 timerBlock_top = 0;
             end
             if bs_pl_map_bottom_ == 1
                 timerBlock_bottom = timerBlock_bottom + VrT;
                 cNb = cNb + 1;
             elseif bs_pl_map_bottom_ == 0 && timerBlock_bottom ~= 0
                 countTimers_bottom = [countTimers_bottom, timerBlock_bottom];
                 timerBlock_bottom = 0;
             end
        end
    end
end
