function h = hyp2f1(a,b,c,z)
%HYP2F1 Gauss hypergeometric function.
%   h = HYP2F1(a,b,c,z) evaluates the Gauss hypergeometric function 
%   2F1(a,b;c;z) for real value parameters a,b,c and argument z.
%
%   a,b,c can be 1 x 1 or n x 1 vectors;
%   z is a n x 1 vector.
%   h is a n x 1 vector.

% Siyi Deng; 10-10-2013;

if ~isnumeric(a) || ~isnumeric(b) || ~isnumeric(c) || ~isnumeric(z)
    error('HYP2F1:BadInput','Inputs must be numeric arrays.');
end

h = tvt_activity.utils.hyp2f1mex.mexhyp2f1(double(a(:)),double(b(:)),double(c(:)),double(z(:)));
h = reshape(h,size(z));

end % HYP2F1;