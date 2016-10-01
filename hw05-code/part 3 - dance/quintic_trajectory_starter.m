function q = quintic_trajectory_starter(t, tstart, tend, qstart, qend, qdotstart, qdotend)
% Quintic interpolation.

% By default, do linear interpolation.  You must replace this with the
% correct trajectory type.  Be sure to use the qdotstart and qdotend
% arguments (starting and ending velocities).  Use zero for the
% starting and ending accelerations.
q = qstart + (t - tstart) * (qend - qstart) / (tend - tstart);