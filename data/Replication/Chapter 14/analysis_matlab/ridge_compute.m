function [ b_ridge ] = ridge_compute_std(xreg,yreg,ridge_parm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Compute OLS after standardized data
br = ridge(yreg,xreg(:,1:end-1),ridge_parm,0);
b_ridge = [br(2:end);br(1)];  % First element of br is intercept
end

