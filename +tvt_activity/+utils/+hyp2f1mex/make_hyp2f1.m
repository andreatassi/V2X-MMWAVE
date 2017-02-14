% Make the mexhyp2f1 mex file;

% Siyi Deng; 10-10-2013;

mex -v -I. -largeArrayDims -c +tvt_activity/+utils/+hyp2f1mex/round.c
mex -v -I. -largeArrayDims -c +tvt_activity/+utils/+hyp2f1mex/gamma.c
mex -v -I. -largeArrayDims -c +tvt_activity/+utils/+hyp2f1mex/polevl.c
mex -v -I. -largeArrayDims -c +tvt_activity/+utils/+hyp2f1mex/psi.c
mex -v -I. -largeArrayDims -c +tvt_activity/+utils/+hyp2f1mex/hyp2f1.c

mex -v -I. -largeArrayDims +tvt_activity/+utils/+hyp2f1mex/mexhyp2f1.c gamma.o hyp2f1.o polevl.o psi.o round.o
delete gamma.o hyp2f1.o polevl.o psi.o round.o
movefile mexhyp2f1.* +tvt_activity/+utils/+hyp2f1mex
