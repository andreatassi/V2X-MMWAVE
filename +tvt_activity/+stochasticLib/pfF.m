function [ f_L, f_N, p_serving_L, p_serving_N ] = pfF( R, lambda_bs, lambda_obs, obs_footprint,...
                                                            C_los, alpha_los, C_nlos, alpha_nlos )
%PFF This function calculates:
%   f_L          - PDF of the dist. to the closest LOS BS
%   f_N          - PDF of the dist. to the closest NLOS BS
%   p_serving_L  - Prob. of being served in LOS
%   p_serving_N  - Prob. of being served in NLOS

    syms d;
    
    f_N = f_NLOS( R, lambda_bs, lambda_obs, obs_footprint );
    f_L = f_LOS( R, lambda_bs, lambda_obs, obs_footprint );
    
    Al = ((C_nlos/C_los) * d^(-alpha_nlos))^(-1/alpha_los);
    tmp_prod = prod(exp(-lambda_obs * obs_footprint));
    lambda_L = lambda_bs * tmp_prod;
    lamb_eff = 2 * lambda_L;
    p_serving_NLOS_integrand = f_N * exp( -lamb_eff * sqrt( Al.^2 - R^2 ) );
    p_serving_NLOS_integrand = matlabFunction(p_serving_NLOS_integrand);
    p_serving_N = integral(p_serving_NLOS_integrand, R, inf);
    
    p_serving_L = 1 - p_serving_N;
end

function [ f_L ] = f_LOS( R, lambda_bs, lambda_obs, obs_footprint )
    syms d;
    
    b = (sqrt(d^2 - R^2));
    D1 = d / b;
    tmp_prod = prod(exp(-lambda_obs * obs_footprint));
    effective_lambda = 2*lambda_bs * tmp_prod;
    f_L = effective_lambda * exp(-effective_lambda * b) * D1;    
end

function [ f_N ] = f_NLOS( R, lambda_bs, lambda_obs, obs_footprint )
    syms d;
    
    b = (sqrt(d^2 - R^2));
    D1 = d / b;
    tmp_prod = 1 - prod(exp(-lambda_obs * obs_footprint));
    effective_lambda = 2*lambda_bs * tmp_prod;
    f_N = effective_lambda * exp(-effective_lambda * b) * D1;    
end
