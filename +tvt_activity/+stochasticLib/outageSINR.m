function [ P_sinr_out_LOS, ...
           P_sinr_out_NLOS, ...
           P_sinr_out ] = outageSINR( R, theta, W, alpha_l, alpha_n, C_l, C_n, G_tx_m, G_tx_M, G_rx_m, G_rx_M, psi, ...
                                      Ps, lambda_bs, lambda_obs, obs_footprint, P_L, P_N, m )
                 
    W = W / Ps;
    
    tmp_prod = prod(exp(-lambda_obs * obs_footprint));
    lambda_L = lambda_bs * tmp_prod;
    lambda_N = lambda_bs * (1-tmp_prod);
    
    G = G_rx_M * G_tx_M;
    
    lamb_eff = 2 * lambda_N;
    fcorr_LOS_ = @(d) fcorr_LOS( d, C_l, C_n, alpha_l, alpha_n, lamb_eff, R );
    A = m * (factorial(m))^(-1/m);
    tmp = 0;
    for e = 0:(m-1)
        integrand_los = @(d) nchoosek(m,e) * (-1)^(m-e) * exp( (-theta * W * d.^alpha_l*(m-e)*A) / (G*C_l) ) .* ...
                             lI_composite(0, theta * d.^alpha_l *(m-e)*A/ (G*C_l), d, 2*R, psi, lambda_L, lambda_N,...
                                          alpha_l, alpha_n, G_tx_m, G_tx_M, G_rx_m, G_rx_M ) .* ...
                             f_LOS( d, R, lambda_bs, lambda_obs, obs_footprint ) .* fcorr_LOS_(d);
        tmp = tmp + integral(integrand_los, R, Inf);
    end
    P_sinr_out_LOS = -tmp;
    if P_sinr_out_LOS < 0 || P_sinr_out_LOS > 1
        error('P_sinr_out_LOS!');
    end
    
    lamb_eff = 2 * lambda_L;
    Al = @(d) ((C_n/C_l) * d.^(-alpha_n)).^(-1/alpha_l);
    fcorr_NLOS = @(d) exp( -lamb_eff * sqrt( (Al(d)).^2 - R^2 ) );
    tmp = 0;
    for e = 0:(m-1)
        integrand_nlos = @(d) nchoosek(m,e) * (-1)^(m-e) * exp( (-theta * W * d.^alpha_n*(m-e)*A) / (G*C_n) ) .* ...
                              lI_composite(1, theta * d.^alpha_n *(m-e)*A / (G*C_n), d, 2*R, psi, lambda_L, lambda_N,...
                                           alpha_l, alpha_n, G_tx_m, G_tx_M, G_rx_m, G_rx_M ) .* ...
                              f_NLOS( d, R, lambda_bs, lambda_obs, obs_footprint ) .* fcorr_NLOS(d);
        tmp = tmp + integral(integrand_nlos, R, Inf);
    end
    P_sinr_out_NLOS = - tmp;
    if P_sinr_out_NLOS < 0 || P_sinr_out_NLOS > 1
        error('P_sinr_out_NLOS!');
    end
    
    P_sinr_out = P_L - P_sinr_out_LOS + ...
                 P_N - P_sinr_out_NLOS;    
end

function [ o ] = fcorr_LOS( d, C_l, C_n, alpha_l, alpha_n, lamb_eff, R )
    An = @(t) ((C_l/C_n) * t.^(-alpha_l)).^(-1/alpha_n);
    o = exp( -lamb_eff * sqrt( (An(d)).^2 - R^2 ) );
    o( An(d) < R ) = 1;
end

function [ L_I ] = lI( s, lambda, alpha, G_tx, G_rx )
    g = G_tx * G_rx;
    delta = alpha^(-1);
    L_I = exp( -2*lambda * (s * g).^delta * gamma(1 + delta) * gamma(1 - delta) );
end

function [ o ] = subInt( a, b, s, lambda, alpha, G_tx, G_rx, R )
    %a = a + R;
    %b = b + R;
    g = G_tx * G_rx;
    delta = alpha^(-1);
    
    I_p = @(x) (x.^-delta) .* ( 1 - (1./(s.*g.*x + 1)) );    
    I_p_a = I_p(a.^-alpha);
    if length(a) == 1 && (a == 0 || isinf(a))
        I_p_a = 0;
    end
    I_p_b = I_p(b.^-alpha);
    if length(b) == 1 && (b == 0 || isinf(b))
        I_p_b = 0;
    end
    
    tmp_1 = 2*lambda * (I_p_b - I_p_a);
    II_p = @(t) t .* (-1./t).^(-delta) .* (delta + 1)^(-1) .* tvt_activity.utils.hyp2f1mex.hyp2f1(delta, delta+1, delta+2, -t); %hypergeom([delta, delta+1], delta+2, -t);
    I = -(s.*g.*(a.^-alpha) + 1).^-1;
    II = -(s.*g.*(b.^-alpha) + 1).^-1;
    
    tmp_2 = -2*lambda * (s.*g).^delta .* ( II_p(II) - II_p(I) );
    o = tmp_1 + tmp_2;
    o( a == b ) = 0;
    o( isnan(G_rx) ) = 0;
end

function [ L_I ] = lI_composite( sLos, s, r, R, psi, lambda_LOS, lambda_NLOS, alpha_LOS, alpha_NLOS, G_tx_m, G_tx_M, G_rx_m, G_rx_M )
        x_b_servingBS = sqrt(r.^2 - (R/2)^2);
        
        debug_pi = false;
        if ~debug_pi
            lambda_LOS = lambda_LOS / 2;
            lambda_NLOS = lambda_NLOS / 2;
        end
        
        tet = asin( R ./ (2.*r) );
        tet( tet < psi/2 ) = psi/2;
        tet( tet > pi - psi/2 ) = pi - psi/2;
        a = R ./ ( 2 * tan(tet + psi/2) );
        b = R ./ ( 2 * tan(tet - psi/2) );
        if sum(isinf(a)) > 0
            error('Matlab version issues!');
        end
        b( isinf(b) ) = -R / ( 2 * tan(pi) );
        
        nIt = length(s);
        G_rx_C = NaN * zeros(1,nIt);
        G_rx_D = NaN * zeros(1,nIt);
        G_rx_E = NaN * zeros(1,nIt);
        G_rx_F = NaN * zeros(1,nIt);
        G_rx_G = NaN * zeros(1,nIt);
        G_rx_H = NaN * zeros(1,nIt);
        G_rx_I = NaN * zeros(1,nIt);
        G_rx_L = NaN * zeros(1,nIt);
        
        G_rx_C( a < 0 & b > 0 )    = G_rx_M;
        G_rx_D( a < 0 & b > 0 )    = G_rx_m;
        G_rx_E( a < 0 & b > 0 )    = G_rx_m;
        G_rx_F( a < 0 & b > 0 )    = G_rx_M;        
        G_rx_G( (a > 0 & b > 0) | (a < 0 & b < 0) )    = G_rx_m;
        G_rx_H( (a > 0 & b > 0) | (a < 0 & b < 0) )    = G_rx_M;
        G_rx_I( (a > 0 & b > 0) | (a < 0 & b < 0) )    = G_rx_m;
        G_rx_L( (a > 0 & b > 0) | (a < 0 & b < 0) )    = G_rx_m;
        
        G_rx_AA = NaN * zeros(1,nIt);
        G_rx_BB = NaN * zeros(1,nIt);
        G_rx_CC = NaN * zeros(1,nIt);
        G_rx_DD = NaN * zeros(1,nIt);
        G_rx_EE = NaN * zeros(1,nIt);
        G_rx_FF = NaN * zeros(1,nIt);
        G_rx_GG = NaN * zeros(1,nIt);
        G_rx_HH = NaN * zeros(1,nIt);
        G_rx_II = NaN * zeros(1,nIt);
        
        G_rx_STD__   = NaN * zeros(1,nIt);
        G_rx_CC__ = NaN * zeros(1,nIt);
        G_rx_DD__ = NaN * zeros(1,nIt);
        G_rx_EE__ = NaN * zeros(1,nIt);
        
        G_rx_AA( x_b_servingBS == 0 ) = G_rx_M;
        G_rx_BB( x_b_servingBS == 0 ) = G_rx_m;
        G_rx_CC( x_b_servingBS ~= 0 & -x_b_servingBS <= -abs(a) )    = G_rx_M;
        G_rx_DD( x_b_servingBS ~= 0 & -x_b_servingBS <= -abs(a) )    = G_rx_m;
        G_rx_EE( x_b_servingBS ~= 0 & -x_b_servingBS <= -abs(a) )    = G_rx_m;
        G_rx_FF( x_b_servingBS ~= 0 & -x_b_servingBS > a & a < 0 )    = G_rx_M;        
        G_rx_GG( x_b_servingBS ~= 0 & -x_b_servingBS > a & a < 0 )    = G_rx_m;
        G_rx_HH( x_b_servingBS ~= 0 & -x_b_servingBS > a & a < 0 )    = G_rx_M;
        G_rx_II( x_b_servingBS ~= 0 & -x_b_servingBS > a & a < 0 )    = G_rx_m;
        
        Al = @(d) (d.^(-alpha_NLOS)).^(-1/alpha_LOS);
        if psi == pi
            if sLos == 0     % Served in LOS
                tmp = subInt( x_b_servingBS, Inf, s, lambda_LOS, alpha_LOS, G_tx_M, G_rx_M, R/2 );
                tmp_los = exp(-tmp);
                
                tmp = subInt( 0, Inf, s, lambda_NLOS, alpha_NLOS, G_tx_M, G_rx_M, R/2 );
                tmp_nlos = exp(-tmp);
            elseif sLos == 1 % Served in NLOS
                vv = sqrt(Al(r).^2 - (R/2)^2);
                tmp = subInt( vv, Inf, s, lambda_LOS, alpha_LOS, G_tx_M, G_rx_M, R/2 );
                tmp_los = exp(-tmp);

                tmp = subInt( x_b_servingBS, Inf, s, lambda_NLOS, alpha_NLOS, G_tx_M, G_rx_M, R/2 );
                tmp_nlos = exp(-tmp);
            else
                error('Fn input error!');
            end
        elseif psi < pi
            if sLos == 0     % Served in LOS
                tmp_los =  subInt( 0, abs(b), s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_AA, R/2 ) + ...
                           subInt( abs(b), Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_BB, R/2) + ...
                           0.5 * subInt( x_b_servingBS, abs(b), s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_CC, R/2 ) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_DD, R/2) + ...
                           0.5 * subInt( x_b_servingBS, Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_EE, R/2) + ...
                           0.5 * subInt( x_b_servingBS, abs(b), s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_FF, R/2) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_GG, R/2) + ...
                           0.5 * subInt( x_b_servingBS, abs(a), s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_HH, R/2) + ...
                           0.5 * subInt( abs(a), Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_II, R/2);
                tmp_los = exp(-tmp_los);
                
                tmp_nlos = 0.5 * subInt( abs(0), abs(b), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_C, R/2 ) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_D, R/2) + ...
                           0.5 * subInt( abs(a), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_E, R/2) + ...
                           0.5 * subInt( 0, abs(a), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_F, R/2) + ...
                           0.5 * subInt( 0, abs(a), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_G, R/2) + ...
                           0.5 * subInt( abs(a), abs(b), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_H, R/2) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_I, R/2) + ...
                           0.5 * subInt( 0, Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_L, R/2);
                tmp_nlos = exp(-tmp_nlos);
            elseif sLos == 1 % Served in NLOS
                vv = sqrt(Al(r).^2 - (R/2)^2);
                G_rx_STD__( b < vv ) = G_rx_m;
                G_rx_CC__( b >= vv ) = G_rx_M;
                G_rx_DD__( b >= vv ) = G_rx_m;
                G_rx_EE__( b >= vv ) = G_rx_m;
                tmp_los =  subInt( vv, Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_STD__, R/2 ) + ...
                           0.5 * subInt( x_b_servingBS, abs(b), s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_CC__, R/2 ) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_DD__, R/2) + ...
                           0.5 * subInt( x_b_servingBS, Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_EE__, R/2);
                tmp_los = exp(-tmp_los);
                
                tmp_nlos = subInt( 0, abs(b), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_AA, R/2 ) + ...
                           subInt( abs(b), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_BB, R/2) + ...
                           0.5 * subInt( x_b_servingBS, abs(b), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_CC, R/2 ) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_DD, R/2) + ...
                           0.5 * subInt( x_b_servingBS, Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_EE, R/2) + ...
                           0.5 * subInt( x_b_servingBS, abs(b), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_FF, R/2) + ...
                           0.5 * subInt( abs(b), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_GG, R/2) + ...
                           0.5 * subInt( x_b_servingBS, abs(a), s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_HH, R/2) + ...
                           0.5 * subInt( abs(a), Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_II, R/2);
                tmp_nlos = exp(-tmp_nlos);
            else
                error('Fn input error!');
            end
        else
            error('Fn input error!');
        end
        
        if sLos == 0     % Served in LOS
            tmp = subInt( x_b_servingBS, Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_m, R/2 );
            tmp_los_o = exp(-tmp);
            
            tmp = subInt( 0, Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_m, R/2 );
            tmp_nlos_o = exp(-tmp);
        elseif sLos == 1 % Served in NLOS
            vv = sqrt(Al(r).^2 - (R/2)^2);
            tmp = subInt( vv, Inf, s, lambda_LOS, alpha_LOS, G_tx_m, G_rx_m, R/2 );
            tmp_los_o = exp(-tmp);
            
            tmp = subInt( x_b_servingBS, Inf, s, lambda_NLOS, alpha_NLOS, G_tx_m, G_rx_m, R/2 );
            tmp_nlos_o = exp(-tmp);
        end
        
        if debug_pi
            L_I = tmp_los .* tmp_nlos;
        else
            L_I = tmp_los_o .* tmp_nlos_o .* tmp_los .* tmp_nlos;
        end
end

function [ f_L ] = f_LOS( d, R, lambda_bs, lambda_obs, obs_footprint )
    b = (sqrt(d.^2 - R^2));
    D1 = d ./ b;
    tmp_prod = prod(exp(-lambda_obs * obs_footprint));
    effective_lambda = 2*lambda_bs * tmp_prod;
    f_L = effective_lambda * exp(-effective_lambda * b) .* D1;    
end

function [ f_N ] = f_NLOS( d, R, lambda_bs, lambda_obs, obs_footprint )
    b = (sqrt(d.^2 - R^2));
    D1 = d ./ b;
    tmp_prod = 1 - prod(exp(-lambda_obs * obs_footprint));
    effective_lambda = 2*lambda_bs * tmp_prod;
    f_N = effective_lambda * exp(-effective_lambda * b) .* D1;    
end
