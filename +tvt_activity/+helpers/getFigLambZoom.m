function [ ] = getFigLambZoom( in, sinrIdx, fileName, upSample )
    % Plotter of SINR outage as a function of the th.
    len = size(in, 2);
    load( strcat(in{1}) );
    X_len = length(no_bs);
    if upSample
        X_len_sim = 1:100;
    else
        X_len_sim = 25:45;
    end
    z = (1-0.5*0.02);
    for idx = 1:len
        load( strcat(in{idx}) );
        Y_sim(X_len_sim,idx) = sum(squeeze(SINR_outage_count(X_len_sim, sinrIdx(1), :)),2) / iterations;
        e(X_len_sim,idx) = z * sqrt(Y_sim(1:X_len_sim,idx) .* (1-Y_sim(1:X_len_sim,idx)) ./ iterations);
        Y_th(1:X_len,idx) = squeeze(P_sinr_out_lb(:, sinrIdx(1)));
    end
    for idx = len+1:2*len
        load( strcat(in{idx-len}) );
        Y_sim(X_len_sim,idx) = sum(squeeze(SINR_outage_count(X_len_sim, sinrIdx(2), :)),2) / iterations;
        e(X_len_sim,idx) = z * sqrt(Y_sim(1:X_len_sim,idx) .* (1-Y_sim(1:X_len_sim,idx)) ./ iterations);
        Y_th(1:X_len,idx) = squeeze(P_sinr_out_lb(:, sinrIdx(2)));
    end
    %Y_sim(1,2) = Y_sim(1,1);
    %Y_sim(1,4) = Y_sim(1,3);
  
    Figure = figure('position',[100 0 7.5*60 5*60],...
        'paperpositionmode','auto',...
        'InvertHardcopy','off',...
        'Color',[1 1 1]);
    AX = axes('Parent',Figure, ... 
        'YMinorTick','on',...
        'XTick',[50:10:90],... 
        'YTick', [0:0.01:0.06],...
        'YMinorGrid','on',...
        'YGrid','on',...
        'XGrid','on',...
        'LineWidth',0.5,...
        'FontSize',24,...
        'FontName','Times');
    xlim(AX,[50 90]);
    ylim(AX,[0 0.06]);
    box(AX,'on');
    hold(AX,'all');

    CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];

    MRK = {'o','o', 'square','square', 'v', 'v', 'x', 'x'};
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{5},'LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{6},'LineStyle', '-','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{7},'LineStyle', '--','LineWidth',1.5);
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{8},'LineStyle', '-','LineWidth',1.5);
    
    rangeE = 1:5:100;
    
    aa = plot(no_bs(X_len_sim), Y_sim(X_len_sim,1));
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5);
    errorbar(no_bs(rangeE),Y_sim(rangeE,1),e(rangeE,1),'Color',[0 0 0],'LineStyle','none','LineWidth',0.5)
    bb = plot(no_bs, Y_th(:,1));
    set(bb(1),'Color',CL(1,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);    
    cc = plot(no_bs(X_len_sim), Y_sim(X_len_sim,2));
    set(cc(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '--','LineWidth',1.5);
    errorbar(no_bs(rangeE),Y_sim(rangeE,2),e(rangeE,2),'Color',[0 0 0],'LineStyle','none','LineWidth',0.5)
    dd = plot(no_bs, Y_th(:,2));
    set(dd(1),'Color',CL(2,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
    
    %---
    ee = plot(no_bs(X_len_sim), Y_sim(X_len_sim,3));
    set(ee(1),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{5},'LineStyle', '--','LineWidth',1.5);
    errorbar(no_bs(rangeE),Y_sim(rangeE,3),e(rangeE,3),'Color',[0 0 0],'LineStyle','none','LineWidth',0.5)
    ff = plot(no_bs, Y_th(:,3));
    set(ff(1),'Color',CL(3,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
    gg = plot(no_bs(X_len_sim), Y_sim(X_len_sim,4));
    set(gg(1),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{7},'LineStyle', '--','LineWidth',1.5);
    errorbar(no_bs(rangeE),Y_sim(rangeE,4),e(rangeE,4),'Color',[0 0 0],'LineStyle','none','LineWidth',0.5)
    hh = plot(no_bs, Y_th(:,4));
    set(hh(1),'Color',CL(4,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);    
    %---

    %xlabel('$\lambda_\mathrm{BS} \cdot 10^4$','FontSize',27,'FontName','Times','Interpreter','latex');
    %ylabel('$\mathrm{P}_\mathrm{T}(\theta)$','FontSize',27,'FontName','Times','Interpreter','latex');
    
    tvt_activity.helpers.plotTickLatex2D('xposfix', 0.05);

    LG = legend(AX,'$N_o = 1$, $\theta = 5$dB, Simulation', ...
                   '$N_o = 1$, $\theta = 5$dB, Theory', ...
                   '$N_o = 2$, $\theta = 5$dB, Simulation', ...
                   '$N_o = 2$, $\theta = 5$dB, Theory', ...
                   '$N_o = 1$, $\theta = 15$dB, Simulation', ...
                   '$N_o = 1$, $\theta = 15$dB, Theory', ...
                   '$N_o = 2$, $\theta = 15$dB, Simulation', ...
                   '$N_o = 2$, $\theta = 15$dB, Theory');
    set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    tvt_activity.utils.plotsparsemarkers(bb,LG,{'o'},25, false, [10],true);
    tvt_activity.utils.plotsparsemarkers(dd,LG,{'square'},25, false, [10],true);
    tvt_activity.utils.plotsparsemarkers(ff,LG,{'v'},25, false, [10],true);
    tvt_activity.utils.plotsparsemarkers(hh,LG,{'x'},25, false, [10],true);
    
    T = get(gca,'position');
    set(gca,'position',[0.106666666666667 0.0933333333333333 0.866666666666667 0.873333333333333]);
    
    set(LG,'position',[0.646248940329951 0.559281760079172 0.332719961802165 0.415625]);
    legend off;

%     xlabh = get(gca,'XLabel');
%     set(xlabh,'Position',get(xlabh,'Position') - [0 -0.007 0]);
% 
%     ylabh = get(gca,'YLabel');
%     set(ylabh,'Position',get(ylabh,'Position') - [-0.9 0 0]);

     name = strcat('+tvt_activity/doc/Img/eps/', fileName, '.eps');
     export_fig(name);
     name = strcat('+tvt_activity/doc/Img/pdf/', fileName, '.pdf');
     export_fig(name);
end
