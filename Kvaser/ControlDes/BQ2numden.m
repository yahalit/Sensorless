function [n,d]=BQ2numden(Sys)

[n,d] = tfdata(Sys,'v');
n = n/d(1);
d = d/d(1);