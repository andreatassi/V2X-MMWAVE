function [ ] = getFig( in, bxIdx, fileName )
    % Plotter of SINR outage as a function of the th.
    len = size(in, 2);
    load( strcat(in{1}) );
    X_len = length(theta_val_db);
    for idx = 1:len
        load( strcat(in{idx}) );
        Y_sim(1:X_len,idx) = sum(squeeze(SINR_outage_count(bxIdx, :, :)),2) / iterations;
        Y_th(1:X_len,idx) = squeeze(P_sinr_out_lb(bxIdx, :));
    end
    Y = [];
    for idx = 1:len
        Y = [Y, Y_sim(:, idx), Y_th(:, idx)];
    end
    
    X = [];
    for x = 1:2*len
        X = [ X, theta_val_db' ];
    end
    
    ActX = X(:,1) >= -5 & X(:,1) <= 45;
    for xSet = 1:(size(X,2)/2)
        col = (xSet - 1) * 2 + 1;
        MSE(xSet) = sum((Y(ActX,col) - Y(ActX,col+1)).^2) / sum(ActX);
    end
    fprintf('---------> Max MSE: %f\n', max(MSE));
  
    Figure = figure('position',[100 0 16*60 8*60],...
        'paperpositionmode','auto',...
        'InvertHardcopy','off',...
        'Color',[1 1 1]);
    AX = axes('Parent',Figure, ... 
        'YMinorTick','on',...
        'XTick',-5:10:45,... 
        'YTick', [0:0.1:1],...
        'YMinorGrid','on',...
        'YGrid','on',...
        'XGrid','on',...
        'LineWidth',0.5,...
        'FontSize',24,...
        'FontName','Times');
    xlim(AX,[-5 45]);
    ylim(AX,[0 0.7]);
    box(AX,'on');
    hold(AX,'all');

    CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];

    MRK = {'square','+', 'v','o'};
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', 'none','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', 'none','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(end,:), 'MarkerSize',20,'Marker','none','LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(end,:), 'MarkerSize',20,'Marker','none','LineStyle', '-','LineWidth',1.5);
    
    PL = plot(X,Y,...
        'MarkerSize',15,...
        'LineWidth',1);

    xlabel('$\theta$ (dB)','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('$\mathrm{P}_\mathrm{T}(\theta)$','FontSize',27,'FontName','Times','Interpreter','latex');
    
    for idx = 1:2:2*len
      tmp = mod((idx+1)/2,2);
      if tmp == 0
          tmp = 2;
      end
      tmp
      set(PL(idx),'Color',CL(tmp,:), 'MarkerSize',10,'Marker','none','LineStyle', '--','LineWidth',1.5);
    end
    for idx = 2:2:2*len
      tmp = mod(idx/2,2);
      if tmp == 0
          tmp = 2;
      end
      tmp
      set(PL(idx),'Color',CL(tmp,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
    end
    
    tvt_activity.helpers.plotTickLatex2D();

    LG = legend(AX,'$\psi = 30^\circ$, $G_{\mathrm{TX}} = 10$dB', ...
                   '$\psi = 90^\circ$, $G_{\mathrm{TX}} = 10$dB', ...
                   '$\psi = 30^\circ$, $G_{\mathrm{TX}} = 20$dB', ...
                   '$\psi = 90^\circ$, $G_{\mathrm{TX}} = 20$dB', ...
                   'Simulation', 'Theory');
    set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    tvt_activity.utils.plotsparsemarkers(PL,LG,{'square','square','+','+','v','v','o','o'},50, true, [8,8,8,8,8,8,8,8],true);
    T = get(gca,'position');
    set(gca,'position',[0.0833333333333333 0.09375 0.904166666666667 0.885416666666666]);
    
    set(LG,'position',[0.0895776388061066 0.633333333333334 0.242937564849854 0.334188520158345]);

    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') - [0 -0.04 0]);

    ylabh = get(gca,'YLabel');
    set(ylabh,'Position',get(ylabh,'Position') - [-0.04 0 0]);

     name = strcat('+tvt_activity/doc/Img/eps/', fileName, '.eps');
     export_fig(name);
     name = strcat('+tvt_activity/doc/Img/pdf/', fileName, '.pdf');
     export_fig(name);
end
