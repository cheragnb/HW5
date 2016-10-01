function q = cubic_trajectory_starter(t, tstart, tend, qstart, qend, qdotstart, qdotend)
% Cubic interpolation.

% By default, do linear interpolation.  You must replace this with the
% correct trajectory type.  Be sure to use the qdotstart and qdotend
% arguments (starting and ending velocities).
q = qstart + (t - tstart) * (qend - qstart) / (tend - tstart);