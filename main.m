% Building of the required MEX files
try
    tvt_activity.utils.hyp2f1mex.make_hyp2f1
catch
    error('MEX files cannot be generated')
end   

% Generation of results as per Figs. 3-7 (of the manuscript)
tvt_activity.batch_sInf;

% Generation of results as per Figs. 8-9 (of the manuscript) and Figs. A-B (of the response to the reviewers)
tvt_activity.batch_s0_off;

% Figure generation
tvt_activity.genFigValidation;
tvt_activity.genFigSim;
