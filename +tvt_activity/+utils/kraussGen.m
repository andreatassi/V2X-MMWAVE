function [ ] = kraussGen( noObsLanes, obsDensity, roadLen, vehicleLen, ...
                          maxSpeed, refSpeed, refDens, refLen, maxAcceleration, maxDeceleration, ...
                          driverReacationTime, simDuration, baseName, VrT )
    try 
        VrT;
        nF = '/kraussTrace_pL_';
    catch
        VrT = 1;
        nF = '/kraussTrace_';
    end
    for l = 1:noObsLanes
        pos = [];
        speed = [];
        speedFollowing = [];
        speedAhead = [];
        distAhead = [];
        filename = strcat(baseName,nF, num2str(roadLen), '_', num2str(noObsLanes), '_', num2str(l),'.mat');
        save(filename, 'pos', 'speed', '-v7.3');
        m{l} = matfile(filename,'Writable',true);
    end
    %----
    pos_ = [];
    speed_ = [];
    speedFollowing_ = [];
    speedAhead_ = [];
    distAhead_ = [];
    speed_next = [];
    pos_next = [];
    no_obs = floor(refDens * 2 * roadLen);
    pos_(1:no_obs) = unifrnd(0, 2*roadLen - refLen, no_obs, 1);
    pos_(1:no_obs) = sort(pos_(1:no_obs), 'ascend');
    mS_ = refSpeed;
    speed_(1:no_obs) = mS_ * ones(no_obs,1);
    m{1}.ue_pos = pos_;
    m{1}.ue_speed = speed_;
    
    for t = 1:simDuration
        fprintf('[Krauss Traces - UE Part] It no. %i of %i\n', t, simDuration);
        speedAhead_(1) = speed_(no_obs);
        speedAhead_(2:no_obs) = speed_(1:(no_obs-1));
        speedFollowing_(no_obs) = speed_(1);
        speedFollowing_(1:(no_obs-1)) = speed_(2:no_obs);
        distAhead_(1:no_obs) = [ squeeze(sqrt((2*roadLen - pos_(no_obs)).^2) + pos_(1)); squeeze(sqrt((pos_(1:(no_obs-1)) - pos_(2:no_obs)).^2))' ] - refLen;
        tmp_speed = speedAhead_(1:no_obs) + ...
            2 * maxDeceleration * ( distAhead_(1:no_obs) - speedAhead_(1:no_obs) * driverReacationTime ) ./ ...
            ( speedAhead_(1:no_obs) + speedFollowing_(1:no_obs) + 2 * driverReacationTime * maxDeceleration );
        tmp_speed(tmp_speed < 0) = 0;
        speed_next(1:no_obs) = min( [mS_ * ones(no_obs,1), squeeze(tmp_speed)', squeeze(speedFollowing_(1:no_obs))' + maxAcceleration * driverReacationTime], [], 2 );
        pos_next(1:no_obs) = squeeze(pos_(1:no_obs) - speed_next(1:no_obs)) * VrT;
        idx = squeeze(pos_next(1:no_obs)) < 0;
        pos_next(idx) = mod(pos_next(idx),2*roadLen);
        m{1}.ue_pos(t+1,:) = pos_next(1:no_obs);
        m{1}.ue_speed(t+1,:) = speed_next(1:no_obs);
        speed_ = speed_next;
        pos_ = pos_next;
    end
    %----
    ue_seed_ = m{1}.ue_speed;
    parfor l = 1:noObsLanes
        pos_ = [];
        speed_ = [];
        speedFollowing_ = [];
        speedAhead_ = [];
        distAhead_ = [];
        speed_next = [];
        pos_next = [];
        no_obs = floor(obsDensity(l) * 2 * roadLen);
        pos_(1:no_obs) = unifrnd(0, 2*roadLen - vehicleLen, no_obs, 1);
        pos_(1:no_obs) = sort(pos_(1:no_obs), 'ascend');
        rS_ = ue_seed_(1,1);
        if l <= noObsLanes/2
            mS_ = rS_ + maxSpeed;
        else
            mS_ = rS_ - maxSpeed;
        end
        speed_(1:no_obs) = mS_ * ones(no_obs,1);
        m{l}.pos = pos_;
        m{l}.speed = speed_;

        for t = 1:simDuration
            fprintf('[Krauss Traces - Obs. Part] It no. %i of %i, lane %i\n', t, simDuration, l);
            if l <= noObsLanes/2
                speedFollowing_(1) = speed_(no_obs);
                speedFollowing_(2:no_obs) = speed_(1:(no_obs-1));
                speedAhead_(no_obs) = speed_(1);
                speedAhead_(1:(no_obs-1)) = speed_(2:no_obs);
                distAhead_(1:no_obs) = [ squeeze(sqrt((pos_(2:no_obs) - pos_(1:(no_obs-1))).^2))'; squeeze(sqrt((2*roadLen - pos_(no_obs)).^2) + pos_(1)) ] - vehicleLen;
            else
                speedAhead_(1) = speed_(no_obs);
                speedAhead_(2:no_obs) = speed_(1:(no_obs-1));
                speedFollowing_(no_obs) = speed_(1);
                speedFollowing_(1:(no_obs-1)) = speed_(2:no_obs);
                distAhead_(1:no_obs) = [ squeeze(sqrt((2*roadLen - pos_(no_obs)).^2) + pos_(1)); squeeze(sqrt((pos_(1:(no_obs-1)) - pos_(2:no_obs)).^2))' ] - vehicleLen;
            end
            tmp_speed = speedAhead_(1:no_obs) + ...
                2 * maxDeceleration * ( distAhead_(1:no_obs) - speedAhead_(1:no_obs) * driverReacationTime ) ./ ...
                ( speedAhead_(1:no_obs) + speedFollowing_(1:no_obs) + 2 * driverReacationTime * maxDeceleration );
            tmp_speed(tmp_speed < 0) = 0;            
            
            rS_ = ue_seed_(t,1);
            if l <= noObsLanes/2
                mS_ = rS_ + maxSpeed;
            else
                mS_ = rS_ - maxSpeed;
            end
            speed_next(1:no_obs) = min( [mS_ * ones(no_obs,1), squeeze(tmp_speed)', squeeze(speedFollowing_(1:no_obs))' + maxAcceleration * driverReacationTime], [], 2 );
            if l <= noObsLanes/2
                pos_next(1:no_obs) = squeeze(pos_(1:no_obs) + speed_next(1:no_obs) * VrT);
                idx = squeeze(pos_next(1:no_obs)) > 2*roadLen;
                pos_next(idx) = mod(pos_next(idx),2*roadLen);
            else
                pos_next(1:no_obs) = squeeze(pos_(1:no_obs) - speed_next(1:no_obs) * VrT);
                idx = squeeze(pos_next(1:no_obs)) < 0;
                pos_next(idx) = mod(pos_next(idx),2*roadLen);
            end
            m{l}.pos(t+1,:) = pos_next(1:no_obs);
            m{l}.speed(t+1,:) = speed_next(1:no_obs);
            speed_ = speed_next;
            pos_ = pos_next;
        end
    end
end
