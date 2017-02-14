# V2X-MMWAVE

License
-------
At this stage, the code is made available only to the reviewers of the manuscript. The code will be made publicly available when the manuscript will be published. As such, at this stage, the code cannot be redistributed.

Please note that the code contained in
    - ./src/export_fig
    - ./src/+tvt_activity/+utils/plotsparsemarkers.m
    - ./src/+tvt_activity/+utils/+hyp2f1mex
    - ./src/+tvt_activity/plotTickLatex2D.m
have been developed by third parties. These pieces of software can be downloaded from MATLAB Central File Exchange (https://uk.mathworks.com/matlabcentral/fileexchange/), for free.


Requirements
------------
The code is compatible with Linux (Ubuntu 14.04 LTS) and OS X 10.11.6. The figure generation process is only compatible with OS X 10.11.6.

Furthermore, the code requires what follows:
    - MATLAB R2015a (including the Parallel Computing Toolbox) with the capability of building MEX files by means of g++. Please be aware that our MEX files are compiled by using the g++ compiler flag --std=c++11.


To Replicate the results and the figures reported in the manuscript and in the reply to the reviewers:
-------------------------------------------------------------
    0. Add to the MATLAB path the folder ./src/export_fig
    1. Change the MATLAB folder to ./src
    2. Run in MATLAB the script main.m - This will both generate the results (in ./src/data) and all the figures included both in the manuscript and in the reply to the reviewers (in ./src/doc/Img). 

**Please note that both the results and figures have been already included in the aforementioned folders.**
