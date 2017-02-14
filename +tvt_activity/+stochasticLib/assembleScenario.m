function [ obs_lanes_top, bs_lane_top, obs_lanes_bottom, bs_lane_bottom ] = assembleScenario( lambda_bs, lambda_obs, road_len, road_width, lane_width, road_x_start, plotInstance, mHandler, simSec )
    % Generate top part of the road
    lambda_obs_top = lambda_obs{1, 1};
    no_obstacle_lanes_top = length(lambda_obs_top);
    y_obs_ref_top = (lane_width : lane_width : (lane_width * no_obstacle_lanes_top));
    [ obs_lanes_top, bs_lane_top ] = tvt_activity.stochasticLib.generateScenario( lambda_bs, lambda_obs_top, road_len, road_x_start, y_obs_ref_top, road_width/2, false, mHandler(1:no_obstacle_lanes_top), simSec);
    
    % Generate bottom part of the road
    lambda_obs_bottom = lambda_obs{1, 2};
    no_obstacle_lanes_bottom = length(lambda_obs_bottom);
    y_obs_ref_bottom = ( -(lane_width * no_obstacle_lanes_bottom) : lane_width : -lane_width );
    [ obs_lanes_bottom, ~ ] = tvt_activity.stochasticLib.generateScenario( lambda_bs, lambda_obs_bottom, road_len, road_x_start, y_obs_ref_bottom, -road_width/2, true, mHandler(no_obstacle_lanes_top + (1:no_obstacle_lanes_bottom)), simSec);

    relocated_bs_idx = unifrnd(0, 1, size(bs_lane_top, 1), 1) >= 0.5;
    bs_lane_bottom = bs_lane_top(relocated_bs_idx,:);
    bs_lane_bottom(:, 2) = -road_width/2;
    bs_lane_top = bs_lane_top(~relocated_bs_idx,:);
    
    % Plotter (Outdated)
    if plotInstance
        scatter( bs_lane_top(:,1), bs_lane_top(:,2), '*r' );
        hold on; scatter( bs_lane_bottom(:,1), bs_lane_bottom(:,2), '*r' );
        for obs_lane_id = 1:no_obstacle_lanes_top
            tmp = obs_lanes_top{obs_lane_id};
            scatter( tmp(:,1), tmp(:,2), '.k' );
        end
        for obs_lane_id = 1:no_obstacle_lanes_bottom
            tmp = obs_lanes_bottom{obs_lane_id};
            scatter( tmp(:,1), tmp(:,2), '.k' );
        end
        X_lanes = repmat([0; road_len], 1, 2 + no_obstacle_lanes_top + no_obstacle_lanes_bottom);
        Y_lanes = [ road_width/2, -road_width/2, y_obs_ref_top - lane_width/2, y_obs_ref_bottom + lane_width/2;
                    road_width/2, -road_width/2, y_obs_ref_top - lane_width/2, y_obs_ref_bottom + lane_width/2];
        plot(X_lanes, Y_lanes, '--g');
        scatter(0, 0, 'dm');
    end
end

