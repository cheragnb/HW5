function q = quintic_trajectory_starter(t, tstart, tend, qstart, qend, qdotstart, qdotend)
disp('start code');
% Quintic interpolation.


% By default, do linear interpolation.  You must replace this with the
% correct trajectory type.  Be sure to use the qdotstart and qdotend
% arguments (starting and ending velocities).  Use zero for the
% starting and ending accelerations.
accln_start= 0;
accln_end = 0;
Q = [qstart qdotstart qend qdotend accln_start accln_end]';

T = [tstart^5 tstart^4 tstart^3 tstart^2 tstart^1 1;
    5*tstart^4 4*tstart^3 3*tstart^2 2*tstart 1 0;
    tend^5 tend^4 tend^3 tend^2 tend^1 1;
    5*tend^4 4*tend^3 3*tend^2 2*tend 1 0;
    20*tstart^3 12*tstart^2 6*tstart 2 0 0;
    20*tend^3 12*tend^2 6*tend 2 0 0];
    
A = inv(T)*Q;
%disp(A);

q = A(1)*t^5 + A(2)*t^4 + A(3)*t^3 + A(4)*t^2 + A(5)*t +A(6);

