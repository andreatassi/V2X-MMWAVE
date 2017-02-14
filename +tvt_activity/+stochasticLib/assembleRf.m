function [ bs_pl_map_top, bs_pl_map_bottom, bs_antGain_top, bs_antGain_bottom, ...
           bs_pl_top, bs_pl_bottom ] = assembleRf( obs_lanes_top, bs_lane_top, obs_lanes_bottom, bs_lane_bottom, ...
                                                   antenna_sector, b_span, obs_footprint, obs_vert_footprint, C_los, alpha_los, C_nlos, alpha_nlos, ...
                                                   txAntenna_maxGain, txAntenna_minGain, userYElevation, plotInstance )
    
    no_bs_top = size(bs_lane_top, 1);
    beam_angle_top = unifrnd( -pi + antenna_sector/2, -(pi - b_span) - antenna_sector/2, no_bs_top, 1 );
    tmp_ang = atan( (bs_lane_top(:, 2) - userYElevation) ./ bs_lane_top(:, 1));
    tmp_ang(isnan(tmp_ang)) = -pi/2;
    tmp_idx = tmp_ang >= 0;
    phi_top = tmp_ang;
    phi_top(tmp_idx) = - (pi - tmp_ang(tmp_idx));
    bs_antGain_top = ( phi_top >= (beam_angle_top - antenna_sector/2) ) & ( phi_top <= (beam_angle_top + antenna_sector/2) ); % Main ant. gain = 1 (side lobes = 0)
    bs_antGain_top = double(bs_antGain_top);
    for bs_idx = 1:no_bs_top
        if bs_antGain_top(bs_idx) == 1
            bs_antGain_top(bs_idx) = txAntenna_maxGain;
        else
            bs_antGain_top(bs_idx) = txAntenna_minGain;
        end
    end
    
    no_obs_lanes_top = length(obs_lanes_top);
    bs_pl_map_top = zeros(1, size(bs_lane_top, 1)); % Init to LOS = 0 (NLOS = 1)
    for obs = 1:no_obs_lanes_top
        tmp = obs_lanes_top{obs};
        if size(tmp, 1) > 0
            % A, B derivation
            x_intercept_A = (tmp(1,2)+obs_vert_footprint/2)./( (bs_lane_top(:, 2) - userYElevation) ./ bs_lane_top(:, 1));
            x_intercept_B = (tmp(1,2)-obs_vert_footprint/2)./( (bs_lane_top(:, 2) - userYElevation) ./ bs_lane_top(:, 1));
            x_intercept = tmp(1,2)./( (bs_lane_top(:, 2) - userYElevation) ./ bs_lane_top(:, 1));
            A = x_intercept - x_intercept_A;
            B = x_intercept_B - x_intercept;
            % ----
            for bs_idx = 1:length(x_intercept)
                if sum( (tmp(:,1) >= x_intercept_A(bs_idx)) & (tmp(:,1) - obs_footprint <= x_intercept_B(bs_idx))) > 0
                   bs_pl_map_top(bs_idx) = 1;
                end
            end
        end
    end
    tmp_bs_top = sqrt( bs_lane_top(:,1).^2 + bs_lane_top(:,2).^2 );
    bs_pl_top = NaN * ones(1, size(bs_lane_top,1));
    bs_pl_top(bs_pl_map_top == 0) = min(1, C_los * tmp_bs_top( bs_pl_map_top == 0 ).^-alpha_los);
    bs_pl_top(bs_pl_map_top == 1) = min(1, C_nlos * tmp_bs_top( bs_pl_map_top == 1 ).^-alpha_nlos);
    
    no_bs_bottom = size(bs_lane_bottom, 1);
    beam_angle_bottom = unifrnd( (pi - b_span) + antenna_sector/2, pi - antenna_sector/2, no_bs_bottom, 1 );
    tmp_ang = atan( (bs_lane_bottom(:, 2) - userYElevation ) ./ bs_lane_bottom(:, 1));
    tmp_ang(isnan(tmp_ang)) = pi/2;
    tmp_idx = tmp_ang <= 0;
    phi_bottom = tmp_ang;
    phi_bottom(tmp_idx) = pi + tmp_ang(tmp_idx);
    bs_antGain_bottom = ( phi_bottom >= (beam_angle_bottom - antenna_sector/2) ) & ( phi_bottom <= (beam_angle_bottom + antenna_sector/2) );
    bs_antGain_bottom = double(bs_antGain_bottom);
    for bs_idx = 1:no_bs_bottom
        if bs_antGain_bottom(bs_idx) == 1
            bs_antGain_bottom(bs_idx) = txAntenna_maxGain;
        else
            bs_antGain_bottom(bs_idx) = txAntenna_minGain;
        end
    end
    
    no_obs_lanes_bottom = length(obs_lanes_bottom);
    bs_pl_map_bottom = zeros(1, size(bs_lane_bottom, 1)); % Init to LOS
    for obs = 1:no_obs_lanes_bottom
        tmp = obs_lanes_bottom{obs};
        if size(tmp, 1) > 0
            x_intercept_A = (tmp(1,2)+obs_vert_footprint/2)./( (bs_lane_bottom(:, 2) - userYElevation) ./ bs_lane_bottom(:, 1));
            x_intercept_B = (tmp(1,2)-obs_vert_footprint/2)./( (bs_lane_bottom(:, 2) - userYElevation) ./ bs_lane_bottom(:, 1));
            x_intercept = tmp(1,2)./( (bs_lane_bottom(:, 2) - userYElevation) ./ bs_lane_bottom(:, 1));
            for bs_idx = 1:length(x_intercept)
                if sum(tmp(:,1) + obs_footprint >= x_intercept_B(bs_idx) & tmp(:,1) <= x_intercept_A(bs_idx)) > 0
                   bs_pl_map_bottom(bs_idx) = 1;
                end
            end
        end
    end
    
    tmp_bs_bottom = sqrt( bs_lane_bottom(:,1).^2 + bs_lane_bottom(:,2).^2 );
    bs_pl_bottom = NaN * ones(1, size(bs_lane_bottom,1));
    bs_pl_bottom(bs_pl_map_bottom == 0) = min(1, C_los * tmp_bs_bottom( bs_pl_map_bottom == 0 ).^-alpha_los);
    bs_pl_bottom(bs_pl_map_bottom == 1) = min(1, C_nlos * tmp_bs_bottom( bs_pl_map_bottom == 1 ).^-alpha_nlos);
    
    % Plotter (Outated)
    if plotInstance
        hold on;
        ylim([bs_lane_bottom(1,2), bs_lane_top(1,2)]);
        % LOS BSs
        scatter( bs_lane_top(bs_pl_map_top == 0,1), bs_lane_top(bs_pl_map_top == 0,2), 'xg' );
        scatter( bs_lane_bottom(bs_pl_map_bottom == 0,1), bs_lane_bottom(bs_pl_map_bottom == 0,2), 'xg' );
        % NLOS BSs
        scatter( bs_lane_top(bs_pl_map_top == 1,1), bs_lane_top(bs_pl_map_top == 1,2), '+b' );
        scatter( bs_lane_bottom(bs_pl_map_bottom == 1,1), bs_lane_bottom(bs_pl_map_bottom == 1,2), '+b' );
        
        scatter( bs_lane_top(bs_antGain_top == txAntenna_maxGain,1), bs_lane_top(bs_antGain_top == txAntenna_maxGain,2), 'xm' );
        scatter( bs_lane_bottom(bs_antGain_bottom == txAntenna_maxGain,1), bs_lane_bottom(bs_antGain_bottom == txAntenna_maxGain,2), 'xm' );
        
        for obs_lane_id = 1:no_obs_lanes_top
            tmp = obs_lanes_top{obs_lane_id};
            scatter( tmp(:,1), tmp(:,2), '.k' );
        end
        for obs_lane_id = 1:no_obs_lanes_bottom
            tmp = obs_lanes_bottom{obs_lane_id};
            scatter( tmp(:,1), tmp(:,2), '.k' );
        end
        road_len = max([bs_lane_top(:,1); bs_lane_bottom(:,1)]);
        road_width = 2 * bs_lane_top(1,2);
        tmp = obs_lanes_top{1};
        y_obs_ref_top = tmp(1,2);
        tmp = obs_lanes_bottom{end};
        y_obs_ref_bottom = tmp(1,2);
        lane_width = bs_lane_top(1,2) - y_obs_ref_top;
        X_lanes = repmat([0; road_len], 1, 2 + no_obs_lanes_top + no_obs_lanes_bottom);
        Y_lanes = [ road_width/2, -road_width/2, y_obs_ref_top - lane_width, y_obs_ref_bottom + lane_width;
                    road_width/2, -road_width/2, y_obs_ref_top - lane_width, y_obs_ref_bottom + lane_width];
        plot(X_lanes, Y_lanes, '--k');
        scatter(0, 0, 'dm');
        
        % Serving BS
        bs_pl = [ bs_pl_top, bs_pl_bottom ];
        bs_virtual_lane = [ bs_lane_top; bs_lane_bottom];
        [ ~, serving_bs_idx ] = max( bs_pl );
        scatter(bs_virtual_lane(serving_bs_idx,1), bs_virtual_lane(serving_bs_idx,2), 'dm');
        
        % TX antenna pattern
        m_top_m = tan(beam_angle_top - antenna_sector/2);
        m_top_M = tan(beam_angle_top + antenna_sector/2);
        q_top_m = bs_lane_top(:,2) - bs_lane_top(:,1) .* m_top_m;
        q_top_M = bs_lane_top(:,2) - bs_lane_top(:,1) .* m_top_M;
        m_bottom_m = tan(pi + beam_angle_bottom - antenna_sector/2);
        m_bottom_M = tan(pi + beam_angle_bottom + antenna_sector/2);
        q_bottom_m = bs_lane_bottom(:,2) - bs_lane_bottom(:,1) .* m_bottom_m;
        q_bottom_M = bs_lane_bottom(:,2) - bs_lane_bottom(:,1) .* m_bottom_M;
        q_m = [ q_top_m; q_bottom_m ];
        q_m = q_m( setdiff(1:size(bs_virtual_lane,1), serving_bs_idx) );
        q_M = [ q_top_M; q_bottom_M ];
        q_M = q_M( setdiff(1:size(bs_virtual_lane,1), serving_bs_idx) );
        m_m = [ m_top_m; m_bottom_m ];
        m_m = m_m( setdiff(1:size(bs_virtual_lane,1), serving_bs_idx) );
        m_M = [ m_top_M; m_bottom_M ];
        m_M = m_M( setdiff(1:size(bs_virtual_lane,1), serving_bs_idx) );
        bs_virtual_lane_tmp = bs_virtual_lane( setdiff(1:size(bs_virtual_lane,1), serving_bs_idx), : );
        for bs = 1:size(bs_virtual_lane,1)-1
            X = (bs_virtual_lane_tmp(bs, 1) - 5000) : 0.01 : (bs_virtual_lane_tmp(bs, 1) + 5000);
            plot(X, m_m(bs) * X + q_m(bs), 'r--');
            plot(X, m_M(bs) * X + q_M(bs), 'r-');
        end
    end 
    
  
    
end

