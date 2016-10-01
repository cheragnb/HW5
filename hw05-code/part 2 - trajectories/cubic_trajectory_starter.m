function q = cubic_trajectory_starter(t, tstart, tend, qstart, qend, qdotstart, qdotend)
% Cubic interpolation.

% By default, do linear interpolation.  You must replace this with the
% correct trajectory type.  Be sure to use the qdotstart and qdotend
% arguments (starting and ending velocities).
Q = [qstart qdotstart qend qdotend]';
T = [tstart^3 tstart^2 tstart^1 1; 
    3*tstart^2 2*tstart 1 0;
    tend^3 tend^2 tend^1 1; 
    3*tend^2 2*tend 1 0];
A = inv(T)*Q;
disp(A);

q = A(1)*t^3 + A(2)*t^2 + A(3)*t + A(4);

%q = qstart + (t - tstart) * (qend - qstart)^2 / (tend - tstart);
