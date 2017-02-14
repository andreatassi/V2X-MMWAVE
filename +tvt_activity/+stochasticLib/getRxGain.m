function [ bs_antRxGain_top, bs_antRxGain_bottom ] = getRxGain( bs_lane_top, bs_lane_bottom, antenna_sector, ...
                                                                rxAntenna_maxGain, rxAntenna_minGain, serving_bs_idx, bs_virtual_lane, plotInstance )
    served_from_the_top = false;
    if bs_virtual_lane(serving_bs_idx, 2) > 0
        served_from_the_top = true;
        bs_antRxGain_bottom = rxAntenna_minGain * ones(size(bs_lane_bottom,1), 1);
        serving_angle = atan(bs_virtual_lane(serving_bs_idx, 2) ./ bs_virtual_lane(serving_bs_idx, 1));
        if isnan(serving_angle)
            serving_angle = pi/2;
        end
        if serving_angle > pi - antenna_sector/2
            serving_angle = pi - antenna_sector/2;
        elseif serving_angle < antenna_sector/2
            serving_angle = antenna_sector/2;
        end
        beam_angle_top = atan(bs_lane_top(:, 2) ./ bs_lane_top(:, 1));
        tmp_idx = beam_angle_top < 0;
        beam_angle_top(tmp_idx) = pi + beam_angle_top(tmp_idx);
        serving_angle(isnan(serving_angle)) = pi/2;
        bs_antRxGain_top = ( (serving_angle - antenna_sector/2) <= beam_angle_top ) & ( (serving_angle + antenna_sector/2) >= beam_angle_top ); % Main ant. gain = 1 (side lobes = 0) %% FIXME
        bs_antRxGain_top = double(bs_antRxGain_top);
        for bs_idx = 1:size(bs_lane_top,1)
            if bs_antRxGain_top(bs_idx) == 1
                bs_antRxGain_top(bs_idx) = rxAntenna_maxGain;
            else
                bs_antRxGain_top(bs_idx) = rxAntenna_minGain;
            end
        end
    else
        bs_antRxGain_top = rxAntenna_minGain * ones(size(bs_lane_top,1), 1);
        serving_angle = -atan(bs_virtual_lane(serving_bs_idx, 2) ./ bs_virtual_lane(serving_bs_idx, 1));
        if isnan(serving_angle)
            serving_angle = pi/2;
        end
        if serving_angle < antenna_sector/2
            serving_angle = antenna_sector/2;
        elseif serving_angle > pi - antenna_sector/2
            serving_angle = pi - antenna_sector/2;
        end
        beam_angle_bottom = -atan(bs_lane_bottom(:, 2) ./ bs_lane_bottom(:, 1));
        tmp_idx = beam_angle_bottom < 0;
        beam_angle_bottom(tmp_idx) = pi + beam_angle_bottom(tmp_idx);
        serving_angle(isnan(serving_angle)) = pi/2;
        bs_antRxGain_bottom = ( (serving_angle - antenna_sector/2) <= beam_angle_bottom ) & ( (serving_angle + antenna_sector/2) >= beam_angle_bottom ); % Main ant. gain = 1 (side lobes = 0)
        bs_antRxGain_bottom = double(bs_antRxGain_bottom);
        for bs_idx = 1:size(bs_lane_bottom,1)
            if bs_antRxGain_bottom(bs_idx) == 1
                bs_antRxGain_bottom(bs_idx) = rxAntenna_maxGain;
            else
                bs_antRxGain_bottom(bs_idx) = rxAntenna_minGain;
            end
        end
    end
    
    % Plotter (Outdated)
    if plotInstance
        % RX antenna pattern
        for bs = 1:size(bs_virtual_lane,1)-1
            X = 0:0.01:5000;
            if ~served_from_the_top
                serving_angle = -serving_angle;
            end
            plot(X, tan(serving_angle - antenna_sector/2) * X, 'r--');
            plot(X, tan(serving_angle + antenna_sector/2) * X, 'r-');
        end
    end 
    
end

