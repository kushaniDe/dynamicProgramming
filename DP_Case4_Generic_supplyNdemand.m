function DP_Case4_Generic_supplyNdemand

% Last Modified: 11/28/2017
% Author: Kushani De Silva
% Example : instance 1 in table 1 (on paper)
clear 
clc

%%



%%
% Global variables
% cost coefficient vector
c = [17,12,100,25,20,42];
% lower bound of demands
dlb = [45,30,60];
% upper bounds of demands
dub = [90,60,120];
% lower bounds of yi(dual) variables
ylb =[-inf , 60, 0  , 75 ,0];
% upper bounds of yi(dual) variables
yub =[inf ,120,inf ,150 ,inf];
% coefficient matrix of dual
A   = [0 1  0 -1  0  0
       0 1  0  0  0 -1
       1 0 -1  0 -1  0];
NoVar = length(c);
% initial search point
y0  = zeros(1,NoVar);
Aeq = [];
beq = [];
options= optimset('Algorithm','interior-point','TolFun',1e-10);
func = @(y) -y(1)*y(2) + y(3)*y(4) + y(5)*y(6) ;

di= [];
yi= [];
%%
% The order of demand satisfaction
% % d2>> d1>>d3
% combinations (di,yi): (2,4) , (1,3) , (3,5)
% stages indices
s1 = [3,5];
s2 = [2,4];
s3 = [1,3];

[dk1,yk1,zk1] = diyi(s1,di,yi);
[dk2,yk2,zk2] = diyi(s2,dk1,yk1);
diii = [dk1 dk2];
yiii = [yk1 yk2];
[dk3,yk3,zk3] = diyi(s3,diii,yiii);

%% printing the outputs
fprintf('Demands: \n')
fprintf('d%1.0f at stage 1 = %2.1f\n',s1(1),dk1)
fprintf('d%1.0f at stage 2 = %2.1f\n',s2(1),dk2)
fprintf('d%1.0f at stage 3 = %2.1f\n',s3(1),dk3)
fprintf('Objective values at each stage: \n')
fprintf('stage 3: %6.3f\n',-zk1)
fprintf('stage 2: %6.3f\n',-zk2)
fprintf('stage 1: %6.3f\n',-zk3)
%%
% The function diyi solves any sub problem of the original nonlinear
% constrained problem
% inputs:
% s = stage indices
% di = demand vector (initial/previous optimal depending on the stage)
% yi = yi values (initial/previous optimal depending on the stage)
    function [dj,yj,z] = diyi(s,di,yi)
        if isempty(di)
            supply = 0;
        else
            supply = -sum(di);
        end
            ir = s(1);
            b  = [c(ir); c(ir+3);supply];
            lb = [dlb(ir) ylb];
            ub = [dub(ir) yub];
            [y,z_temp] = fmincon(func,y0,A,b,Aeq,beq,lb,ub,[],options);
            z = z_temp - sum(di.*yi);
            dj = y(1);
            yj = y(2);
    end




end


