function trajectory_type = get_trajectory_type()

% Define trajectory options.
trajectory_options = {'Linear', 'Cubic', 'Quintic', 'LSPB'};

% Ask the user to get the type of trajectory to use.
[selection,ok] = listdlg('PromptString','Which trajectory type?','SelectionMode','single', 'ListString', trajectory_options);

if ~ok
    trajectory_type = 'Cancel';
else
    trajectory_type = trajectory_options{selection};
end