function [ ] = getFigLOS( in, filename )
    % Plotter of SINR outage as a function of the th.
    lamb_range = (2:2:200);
    lamb_range_len = length(lamb_range);
    iterations = 2e5;
    len = 2;
    for idx = 1:len
        load( strcat(in{idx}) );
        Y_sim(1:lamb_range_len,idx) = (sum(served_los_count_sim,2) / iterations)';
        Y_th(1:lamb_range_len,idx) = served_los_count_th;
    end
    Y = [];
    for idx = 1:len
        Y = [Y, Y_sim(:, idx), Y_th(:, idx)];
    end
    
    X = [];
    for x = 1:2*len
        X = [ X, lamb_range' ];
    end
  
    Figure = figure('position',[100 0 16*60 8*60],...
        'paperpositionmode','auto',...
        'InvertHardcopy','off',...
        'Color',[1 1 1]);
    AX = axes('Parent',Figure, ... 
        'YMinorTick','on',...
        'XTick',[2, 20:20:200],... 
        'YTick', 0.8:0.05:1,...
        'YMinorGrid','on',...
        'YGrid','on',...
        'XGrid','on',...
        'LineWidth',0.5,...
        'FontSize',24,...
        'FontName','Times');
    xlim(AX,[2 200]);
    ylim(AX,[0.85 1]);
    box(AX,'on');
    hold(AX,'all');
    
    ActX = X(:,1) >= 2 & X(:,1) <= 200;
    for xSet = 1:(size(X,2)/2)
        col = (xSet - 1) * 2 + 1;
        MSE(xSet) = sum((Y(ActX,col) - Y(ActX,col+1)).^2) / sum(ActX);
    end
    fprintf('---------> Max MSE: %f\n', max(MSE));

    CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];
    MRK = {'o', 'o', 'square', 'square'};
    
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

    xlabel('$\lambda_{\mathrm{BS}} \cdot 10^4$','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('$\mathrm{P}_{\mathrm{L}}$','FontSize',27,'FontName','Times','Interpreter','latex');
    
       
    for idx = 1:2:2*len
      tmp = mod((idx+1)/2,2);
      if tmp == 0
          tmp = 2;
      end
      tmp
      set(PL(idx),'Color',CL(tmp,:), 'MarkerSize',10,'LineStyle', '--','LineWidth',1.5);
    end
    for idx = 2:2:2*len
      tmp = mod(idx/2,2);
      if tmp == 0
          tmp = 2;
      end
      tmp
      set(PL(idx),'Color',CL(tmp,:), 'MarkerSize',10,'LineStyle', '-','LineWidth',1.5);
    end
    
    tvt_activity.helpers.plotTickLatex2D();

    LG = legend(AX,'$N_o = 1$, Simulation', ...
                   '$N_o = 1$, Theory', ...
                   '$N_o = 2$, Simulation', ...
                   '$N_o = 2$, Theory');
    set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    tvt_activity.utils.plotsparsemarkers(PL,LG,{'o','o','square','square'},25, true, [10,10,10,10],true);
    T = get(gca,'position');
    set(gca,'position',[0.0885416666666667 0.110416666666667 0.892708333333333 0.86875]);
    
    set(LG,'position',[0.113759509128733 0.118749999999999 0.2351988242046 0.246688520158346]);

    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') - [0 -0.005 0]);

    ylabh = get(gca,'YLabel');
    set(ylabh,'Position',get(ylabh,'Position') - [-1.5 0 0]);

    name = strcat('+tvt_activity/doc/Img/eps/', filename, '.eps');
    export_fig(name);
    name = strcat('+tvt_activity/doc/Img/pdf/', filename, '.pdf');
    export_fig(name);
end
