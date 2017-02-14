function [ ] = getFigRate( in, fileName )
    % Plotter of SINR outage as a function of the th.
    X_len = length(0:20:1000); % Mbps
    load( strcat(in{1}) );
    Y_sim(1:X_len,1) = P_rate_coverage_sim(20, :);
    Y_th(1:X_len,1) = P_rate_coverage_lb(20, :);
    load( strcat(in{2}) );
    Y_sim(1:X_len,2) = P_rate_coverage_sim(20, :);
    Y_th(1:X_len,2) = P_rate_coverage_lb(20, :);
    Y = [];
    for idx = 1:2
        Y = [Y, Y_sim(:, idx), Y_th(:, idx)];
    end
    
    X = [];
    for x = 1:2*2
        X = [ X, (0:20:1000)' ];
    end
  
    ActX = X(:,1) >= 0 & X(:,1) <= 900;
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
        'XTick',0:100:1000,... 
        'YTick', [0:0.05:1],...
        'YMinorGrid','on',...
        'YGrid','on',...
        'XGrid','on',...
        'LineWidth',0.5,...
        'FontSize',24,...
        'FontName','Times');
    xlim(AX,[0 900]);
    ylim(AX,[0.7 1]);
    box(AX,'on');
    hold(AX,'all');

    CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];

    MRK = {'o','o', 'square','square'};
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-','LineWidth',1.5);
    
    PL = plot(X,Y,...
        'MarkerSize',15,...
        'LineWidth',1);

    xlabel('$\kappa$ (Mbps)','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('$\mathrm{R}_\mathrm{C}(\kappa)$','FontSize',27,'FontName','Times','Interpreter','latex');
    
    set(PL(1),'Color',CL(1,:), 'MarkerSize',10,'Marker','none','LineStyle', '--','LineWidth',1.5);
    set(PL(2),'Color',CL(1,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
    set(PL(3),'Color',CL(2,:), 'MarkerSize',10,'Marker','none','LineStyle', '--','LineWidth',1.5);
    set(PL(4),'Color',CL(2,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
    
    tvt_activity.helpers.plotTickLatex2D();

    LG = legend(AX,'$G_{\mathrm{TX}} = 10$dB, Simulation', ...
                   '$G_{\mathrm{TX}} = 10$dB, Theory', ...
                   '$G_{\mathrm{TX}} = 20$dB, Simulation', ...
                   '$G_{\mathrm{TX}} = 20$dB, Theory');
    set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    tvt_activity.utils.plotsparsemarkers(PL,LG,{'o','o','square','square'},50, true, [10,10,10,10],true);
    T = get(gca,'position');
    set(gca,'position',[0.096875 0.11875 0.884374999999999 0.8625]);
    
    set(LG,'position',[0.102870730262202 0.13125 0.269476381937663 0.246688520158346]);

    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') - [0 -0.007 0]);

    ylabh = get(gca,'YLabel');
    set(ylabh,'Position',get(ylabh,'Position') - [-0.01 0 0]);

     name = strcat('+tvt_activity/doc/Img/eps/', fileName, '.eps');
     export_fig(name);
     name = strcat('+tvt_activity/doc/Img/pdf/', fileName, '.pdf');
     export_fig(name);
end
