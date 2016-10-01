function thetas = get_angles(t)

% Define the student PennKeys variable to be global.
global studentPennKeys

% Define dance and all other variables needed multiple times to be persistent.
persistent tvia thetavia thetadotvia trajectorytypevia

% This function is initialized by calling it with no argument.
if (nargin == 0)
    
    % Load the team's dance file from disk.  It contains the variable dance.
    load(['dance_' studentPennKeys],'dance')
    
    % Pull the list of via point times out of the dance matrix.
    tvia = dance(:,1);
    
    % Pull the list of joint angles out of the dance matrix.
    thetavia = dance(:,2:7);
    
    % Pull the list of joint angle velocities out of the dance matrix.
    thetadotvia = dance(:,8:13);
    
    % Pull the list of trajectory types out of the dance matrix.
    trajectorytypevia = dance(:,14);
    
    % Return from initialization.
    return
    
end

% Initialize the thetas variable.
thetas = zeros(6,1);

% Determine which trajectory we should be executing.  Assuming the via
% point times are monotonically increasing, we look for the first via point
% time that is greater than the current time.  Subtract 1 to get to the
% index of the via point that starts this trajectory.
traj = find(t < tvia,1) - 1;

% Select the correct trajectory types.
switch (trajectorytypevia(traj))
    case 0
        % Linearly interpolate between the via points.
        thetas = linear_trajectory(t,tvia(traj),tvia(traj+1),thetavia(traj,:)',thetavia(traj+1,:)');
    case 1
        cubic_trajectory = str2func(['cubic_trajectory_' studentPennKeys]);
        % Interpolate each joint separately with a cubic polynomial.
        for i = 1:6
            thetas(i,1) = cubic_trajectory(t,tvia(traj),tvia(traj+1),thetavia(traj,i),thetavia(traj+1,i),thetadotvia(traj,i),thetadotvia(traj+1,i));
        end
    case 2
        quintic_trajectory = str2func(['quintic_trajectory_' studentPennKeys]);
        % Interpolate each joint separately with a quintic polynomial.
        for i = 1:6
            thetas(i,1) = quintic_trajectory(t,tvia(traj),tvia(traj+1),thetavia(traj,i),thetavia(traj+1,i),thetadotvia(traj,i),thetadotvia(traj+1,i));
        end
    case 3
        lspb_trajectory = str2func(['lspb_trajectory_' studentPennKeys]);
        % Interpolate each joint separately with an LSPB.
        % We ignore the velocities because the LSPB always starts and
        % ends from rest; instead we send zeros for both those values.
        for i = 1:6
            thetas(i,1) = lspb_trajectory(t,tvia(traj),tvia(traj+1),thetavia(traj,i),thetavia(traj+1,i),0,0);
        end
    otherwise
        error(['Unknown trajectory type: ' num2str(trajectorytypevia(traj))])
end