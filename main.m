% Building of the required MEX files
try
    tvt_activity.utils.hyp2f1mex.make_hyp2f1
catch
    error('MEX files cannot be generated')
end   

% Generation of results as per Figs. 2-6 (of the manuscript)
tvt_activity.batch_sInf;

% Generation of results as per Fig. 7 (of the manuscript) and Figs. E and F (of the response to the Reviewers)
tvt_activity.batch_s0_off;

% Figure generation
tvt_activity.genFigValidation;
tvt_activity.genFigSim;
