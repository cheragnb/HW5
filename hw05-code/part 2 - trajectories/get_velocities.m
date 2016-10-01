function velocities = get_velocities()

% Ask the user to specify whether starting and ending velocities
% should be zero.
velocities = questdlg('What should the initial and final velocities be?', ...
    'Velocities', 'Zero', 'Non-zero', 'Zero');