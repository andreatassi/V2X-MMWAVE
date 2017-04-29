function [ ] = getFigH( in, xL, yL, isTop, fl )
    load(in);
    Figure = figure('position',[100 0 16*60 16*60],...
        'paperpositionmode','auto',...
        'InvertHardcopy','off',...
        'Color',[1 1 1]);
    AX = axes('Parent',Figure, ...
        'YMinorTick','on',...        'XTick',[2, 20:20:200],...        'YTick', 0.8:0.02:1,...
        'YMinorGrid','on',...
        'YGrid','on',...
        'XGrid','on',...
        'LineWidth',0.5,...
        'FontSize',24,...
        'FontName','Times');
    xlim(AX,xL);
    ylim(AX,yL);

    box(AX,'on');
    hold(AX,'all');
    
    if isTop
        hist(countTimers_top)
    else
        hist(countTimers_bottom)
    end
    
    xlabel('Blockage Duration (s)','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('Number of Samples','FontSize',27,'FontName','Times','Interpreter','latex');

    tvt_activity.helpers.plotTickLatex2D();

    name = strcat('+tvt_activity/doc/Img/eps/', fl, '.eps');
    export_fig(name);
    name = strcat('+tvt_activity/doc/Img/pdf/', fl, '.pdf');
    export_fig(name);
end
