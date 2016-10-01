function q = linear_trajectory(t, tstart, tend, qstart, qend, ~, ~)
% Calculate the next step in a trajectory using linear interpolation.

% The variable q must have a value of qstart at tstart and a value of
% qent at tend.  We are calculating its value at t.
q = qstart + (t - tstart) * (qend - qstart) / (tend - tstart);