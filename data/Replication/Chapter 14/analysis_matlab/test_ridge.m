% Check Ridge normalizations, etc.
n = 200;
k = 30;
xreg = randn(n,k);
b = randn(k,1);
yreg = xreg*b + randn(n,1);
yreg_m = yreg - mean(yreg);
lam_ridge = 10;
xm = mean(xreg)';
xs = std(xreg)';
x = (xreg-repmat(xm',size(xreg,1),1))./repmat(xs',size(xreg,1),1);
bridge_std = inv(x'*x + lam_ridge*eye(k))*(x'*yreg);
br = ridge(yreg,xreg,lam_ridge,1);
sum(abs(bridge_std-br))