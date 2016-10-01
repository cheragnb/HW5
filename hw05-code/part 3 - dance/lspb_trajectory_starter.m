function q = lspb_trajectory_starter(t, tstart, tend, qstart, qend, ~, ~)
% LSPB interpolation.

% By default, do linear interpolation.  You must replace this with the
% correct trajectory type.
q = qstart + (t - tstart) * (qend - qstart) / (tend - tstart);