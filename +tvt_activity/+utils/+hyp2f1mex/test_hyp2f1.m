% Test script, compare with funciton hypergeom from symbolic math toolbox.

% Siyi Deng; 10-10-2013;

if exist('hypergeom','file') ~= 2
    error('Requires the function HYPERGEOM from symbolic math toolbox.');
end


numTest = 100;
a = randn(numTest,1);
b = randn(numTest,1);
c = randn(numTest,1);
x = randn(numTest,1)-1;
i = x > 1-eps;
x(i) = -x(i);

foo1 = hypergeom([0.5,0.5],0.5,0.5);
foo2 = hyp2f1(0.5,0.5,0.5,0.5);

tic
g0 = zeros(numTest,1);
for k = 1:numTest
    g0(k) = hypergeom([a(k),b(k)],c(k),x(k));
end
fprintf('Computing %d values using HYPERGEOM finished in %f sec.\n',...
    numTest,toc);

tic
g1 = hyp2f1(a,b,c,x);
fprintf('Computing %d values using HYP2F1 finished in %f sec.\n',...
    numTest,toc);

r2 = abs(g0-g1);
[v,i] = max(abs(r2));

fprintf('Mean difference: %f\n',mean(r2));
fprintf('Max difference: %f\n',v);
fprintf('Parameters that produce max difference:\n');
fprintf('\ta = %f; b = %f; c = %f; x = %f; \n\n',a(i),b(i),c(i),x(i));

tic
g0 = hypergeom([a(1),b(1)],c(1),x);
fprintf('Computing %d x 1 vector using HYPERGEOM finished in %f sec.\n',...
    numTest,toc);

tic
g1 = hyp2f1(a(1),b(1),c(1),x);

fprintf('Computing %d x 1 vector using HYP2F1 finished in %f sec.\n',...
    numTest,toc);
r2 = max(abs(g1-g0));
fprintf('Max difference: %f\n',r2);

