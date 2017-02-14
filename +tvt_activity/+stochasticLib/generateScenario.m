function [ obs_lanes, bs_lane ] = generateScenario( lambda_bs, lambda_obs, road_len, road_x_start, y_obs_ref, y_bs_ref, noBSs, mHandler, simSec)
    no_obstacle_lanes = length(lambda_obs);
    no_obs = zeros(1, no_obstacle_lanes);
    obs_lanes = cell(1, no_obstacle_lanes);
    for obs_lane_id = 1:no_obstacle_lanes
        tmpTrace = mHandler{obs_lane_id}.pos(simSec,:);
        no_obs(obs_lane_id) = size(tmpTrace, 2); %poissrnd(lambda_obs(obs_lane_id) * (road_len - road_x_start), 1, 1);
        tmpPos = tmpTrace' + road_x_start; %unifrnd(road_x_start, road_len, no_obs(obs_lane_id), 1);
        obs_lanes{1, obs_lane_id} = [tmpPos, y_obs_ref(obs_lane_id) * ones(no_obs(obs_lane_id), 1)];
    end
    
    if ~noBSs
        no_bs = poissrnd(lambda_bs * (road_len - road_x_start), 1, 1);
        bs_lane = [ unifrnd(road_x_start, road_len, no_bs, 1), y_bs_ref * ones(no_bs, 1) ];
    else
        bs_lane = [];
    end
end
