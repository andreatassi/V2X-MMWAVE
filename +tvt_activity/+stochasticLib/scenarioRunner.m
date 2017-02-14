%% Init Simulation Pars.
seed       = 3; % General Seed
if ~getAssocProbs
    iterations = 5e4;
else
    iterations = 2e5;
end

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
        
try
    tmp = userYoff;
catch
    userYoff      = 0;
end

% Comms. Pars.
try
    tmp = alpha_los;
catch
    alpha_los      = 2.8;
    alpha_nlos     = 3.86;
end
C_los          = 1;
C_nlos         = 1;
Pt                 = 0.5;
BW                 = 100e6; % 100MHz
mNakagami 		   = 3;
thermal_Noise_dbm  = 10 * log10( 1.381 * 1e-23 * 290 * BW * 1e3 );
thermal_Noise      = tvt_activity.utils.db2Lin(thermal_Noise_dbm - 30); % in W
SINR_Max           = tvt_activity.utils.db2Lin(100);

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
norm_rx_pow = NaN * zeros(lambda_bs_len, iterations);
%% Generate Scenario Instances
if simSection
    rng(seed);
    served_los_count_sim = zeros(lambda_bs_len, iterations);
    SINR_outage_count = zeros(lambda_bs_len, theta_val_len, iterations);
    rate_coverage_count = zeros(lambda_bs_len, rate_val_len, iterations);
    % -------- %
    baseName = '+tvt_activity/data';
    try
        filename = strcat(baseName,'/kraussTrace_', num2str(road_len), '_', num2str(2*length(no_obs)), '_', num2str(1),'.mat');
        tt_ = matfile(filename);
        tt_.pos(1,1);
    catch
        itK = 2e5;
        tvt_activity.utils.kraussGen(2*length(no_obs), [lambda_obs_top, lambda_obs_bottom], road_len, obs_footprint, ...
                                                                   maxSpeed, maxUserSpeed, userDes, userLen, maxAcceleration, maxDeceleration, driverReacationTime, ...
                                                                   itK, ...
                                                                   baseName);
    end
    for l = 1:2*length(no_obs)
        filename = strcat(baseName,'/kraussTrace_', num2str(road_len), '_', num2str(2*length(no_obs)), '_', num2str(l),'.mat');
        mHandler{l} = matfile(filename);
    end
    % -------- %
    parfor it = 1:iterations
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
            
            if ~getAssocProbs
                [ bs_antRxGain_top, bs_antRxGain_bottom ] = tvt_activity.stochasticLib.getRxGain( bs_lane_top, bs_lane_bottom, antenna_sector, ...
                    rxAntenna_maxGain, rxAntenna_minGain, ...
                    serving_bs_idx, bs_virtual_lane, false);
                bs_antRxGain = [ bs_antRxGain_top; bs_antRxGain_bottom ];
            end
            
            if ~isempty(bs_pl)
                if ~getAssocProbs
                    S = txAntenna_maxGain * rxAntenna_maxGain * gamrnd(mNakagami,1) * Pt * serving_pl;
                    if ~isempty( setdiff(1:no_bs_loop, serving_bs_idx) )
                        I = bs_antTxGain( setdiff(1:no_bs_loop, serving_bs_idx) ) .* ...
                            bs_antRxGain( setdiff(1:no_bs_loop, serving_bs_idx) ) .* ...
                            exprnd(1, no_bs_loop - 1, 1) * Pt .* (bs_pl( setdiff(1:no_bs_loop, serving_bs_idx) ))';
                    else
                        I = 0;
                    end
                    SINR = S / (sum(I) + thermal_Noise);
                    norm_rx_pow(lambda_idx, it) = 10*log10(1e3 * S/(txAntenna_maxGain * rxAntenna_maxGain));
                end
                
                if bs_pl_map(serving_bs_idx) == 0
                    served_los_count_sim(lambda_idx, it) = 1;
                end
            else
                SINR = 0;
            end
            
            if ~getAssocProbs
                % SINR outage CDFs simulation
                for cdf_outage_idx = 1:theta_val_len
                    if isnan(theta_val_loop(cdf_outage_idx))
                        continue;
                    end
                    if SINR <= theta_val_loop(cdf_outage_idx)
                        SINR_outage_count(lambda_idx, cdf_outage_idx, it) = 1;
                    end
                end
                % Rate coverage CDFs simulation
                rate = BW * log2( 1 + min( SINR, SINR_Max ) );
                for cdf_rate_idx = 1:rate_val_len
                    if rate >= rate_val_loop(cdf_rate_idx)
                        rate_coverage_count(lambda_idx, cdf_rate_idx, it) = 1;
                    end
                end
            end
        end
    end
end
norm_rx_pow_sim = sum(norm_rx_pow, 2) / iterations;

%% Th. as a function lambda_bs
if getTh
    antRxGain = rxAntenna_maxGain;
    antTxGain = txAntenna_maxGain;
    antRxGain_I = rxAntenna_minGain;
    antTxGain_I = txAntenna_minGain;
    P_sinr_out_lb = zeros(length(lambda_bs), theta_val_len);
    served_los_count_th = zeros(1, length(lambda_bs));
    
    for lambda_bs_idx = 1:length(lambda_bs)
        if lambda_bs(lambda_bs_idx) == 0
            continue;
        end
        fprintf('[Th.] lambda_bs %i of %i\n', lambda_bs(lambda_bs_idx), lambda_bs(end));
        [ f_L, f_N, p_serving_LOS, p_serving_NLOS ] = tvt_activity.stochasticLib.pfF( R, lambda_bs(lambda_bs_idx), ...
            lambda_obs_top, obs_footprint, ...
            C_los, alpha_los, C_nlos, alpha_nlos );
        served_los_count_th(lambda_bs_idx) = p_serving_LOS;
        if ~getAssocProbs
            parfor cdf_outage_idx = 1:theta_val_len
                if isnan(theta_val(cdf_outage_idx))
                    continue;
                end
                cdf_outage_idx
                lambda_bs_loop = lambda_bs;
                lambda_bs_loop_val = lambda_bs_loop(lambda_bs_idx);
                [ ~, ~, ...
                    P_sinr_out_lb(lambda_bs_idx, cdf_outage_idx) ] = tvt_activity.stochasticLib.outageSINR( R, theta_val(cdf_outage_idx), thermal_Noise, alpha_los, alpha_nlos, C_los, C_nlos, ...
                                        txAntenna_minGain, txAntenna_maxGain, rxAntenna_minGain, rxAntenna_maxGain, antenna_sector, ...
                                        Pt, lambda_bs_loop_val, lambda_obs_top, obs_footprint, p_serving_LOS, p_serving_NLOS, mNakagami);
            end
        end
    end
end

if recoverRate
    antRxGain = rxAntenna_maxGain;
    antTxGain = txAntenna_maxGain;
    antRxGain_I = rxAntenna_minGain;
    antTxGain_I = txAntenna_minGain;
    P_rate_coverage_lb = zeros(length(lambda_bs), rate_val_len);
    P_rate_coverage_sim = zeros(length(lambda_bs), rate_val_len);
    
    load(dataFile);
    for lambda_bs_idx = 1:length(lambda_bs)
        x_r = (2.^(rate_val/BW)) - 1;
        P_rate_coverage_lb(lambda_bs_idx, :) = 1-interp1(theta_val, squeeze(P_sinr_out_lb(lambda_bs_idx, :)), x_r, 'spline');
        P_sinr_out_sim = sum(squeeze(SINR_outage_count(lambda_bs_idx, :, :)),2) / iterations;
        P_rate_coverage_sim(lambda_bs_idx, :) = 1-interp1(theta_val, squeeze(P_sinr_out_sim), x_r, 'spline');
    end
    
end
