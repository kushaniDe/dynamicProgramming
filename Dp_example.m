% Nov 21-2017
% Author: Kushani De Silva

% % LP Example problem
    % max z = 3x1+5x2
    % s.t.
    % x1         <=4
    %       2x2  <=12
    % 3x1 + 2x2  <=18 
    % x1>=0
    % x2>=0

% standard form
    % max z = 3x1+5x2
    % s.t.
    % x1         +s1 = 4
    %       2x2  +s2 = 12
    % 3x1 + 2x2  +s3 = 18 
    % x1>=0
    % x2>=0
    % s1,s2,s3>=0
%%
clc
clear all
%%
% stage 2: solving for x2 variable

    % max 5x2
    % s.t.
    % 2x2  +s2 = 12
    % 2x2  +s3 = 18
%% Stage 2
func1 = @(x) -5*x(1) + 0*x(2) + 0*x(3);
stage2Var = 3;
x0=zeros(stage2Var,1);
Aeq = [2 1 0;2 0 1];
beq = [12 18];
lb  = zeros(stage2Var,1);
ub  = ones(stage2Var,1)*inf;
options = optimset('Algorithm','active-set','TolFun', 1e-6 );
[stage2_X,stage2_Z] = fmincon(func1,x0,[],[],Aeq,beq,lb,ub,[],options)
x2 = stage2_X(1);
s2 = stage2_X(2);
s3 = stage2_X(3);

%%
% stage 1
% max z = 3x1
% s.t.
% x1       +s1   = 4 
%       2x2  +s2 = 12 : fully satisfied
% 3x1 +s3  = 18 - 2x2 -s3 = 18-12=6
% therefore new constraints
% x1 +s1 = 4
% 3x1 + s3 =6
% x1>=0
% x2>=0
% s1,s2,s3>=0
func2 = @(x) -5*x2 -3*x(1) + 0*x(2)+ 0*x(3);
stage2Var=3;
x0=zeros(stage2Var,1);
Aeq2 = [1 1 0;3 0 1];
beq2 = [4 6];
lb2 = zeros(stage2Var,1);
ub2 = ones(stage2Var,1)*inf;
options = optimset('Algorithm','active-set','TolFun', 1e-6 );
[stage1_x,stage1_Z] = fmincon(func2,x0,[],[],Aeq2,beq2,lb2,ub2,[],options)

%%
fprintf('x1 = %f\n',stage1_x(1))
fprintf('x2 = %f\n',x2)
fprintf('Z  = %f\n',stage1_Z)

