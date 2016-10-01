%% lynx_trajectories_starter.m
% 
% This Matlab script provides the starter code for testing
% trajectories between pairs of random configurations on the Lynx
% robot on Homework 5 in MEAM 520 at the University of Pennsylvania.
% The original was written by Professor Katherine J. Kuchenbecker
% (kuchenbe@seas.upenn.edu). Students will modify this code to create
% their own script.
%
% Change the name of this file to replace "starter" with your PennKey.
% For example, Professor Kuchenbecker's script would be
% lynx_trajectories_kuchenbe.m


%% SETUP

% Clear the workspace.
clearvars -except configuration_initial configuration_final

% Home the console, so we can more easily find any errors that may occur.
home

% Set student names and PennKeys.
studentNames = 'PUT YOUR NAMES HERE';
studentPennKeys = 'starter'; % Replace with yourpennkey or pennkey1_pennkey2

% Define the starting, duration, and ending times.
ti = 2; % initial time, in seconds
duration = 5; % duration, in seconds
tf = ti + duration; % final time, in seconds

% Delay time after showing the robot.  Increase this reduce
% computational load, and decrease it to make the motion appear
% smoother.
animation_delay = 0.05; % s


%% GET INITIAL AND FINAL CONFIGURATIONS

% Check whether the initial and final configuration variables exist.
if (exist('configuration_initial','var') && exist('configuration_final','var'))
    % They exist, so ask the user if we should use them, or if we
    % should generate random new initial and final joint angles.
    button = questdlg('Which initial and final configurations do you want to use?', ...
        '','Existing', 'Random', 'Random');
else
    % They don't exist, so we need to choose random new angles.
    button = 'Random';
end

% Check whether we need to pick random new angles.
if strcmp(button, 'Random')
    % Obtain a random configuration at which the Puma should start.
    configuration_initial = get_random_lynx_configuration;

    % Obtain a random configuration at which the Puma should end.
    configuration_final = get_random_lynx_configuration;
end

% Store the number of degrees of freedom for this robot.
n = length(configuration_initial);


%% GET TRAJECTORY TYPE AND STARTING AND ENDING VELOCITIES

% Ask the user which type of trajectory should be used.
trajectory = get_trajectory_type;

if (strcmpi(trajectory,'cancel'))
    return
elseif (strcmpi(trajectory,'linear'))
    trajectory_function = str2func([lower(trajectory) '_trajectory']);    
else
    trajectory_function = str2func([lower(trajectory) '_trajectory_' studentPennKeys]);
end

% For cubic and quintic trajectories, ask the user which the starting
% and ending velocities should be.
if (strcmpi(trajectory,'cubic') || strcmpi(trajectory,'quintic'))
    velocities = get_velocities;
    
    % Set the initial and final velocity vectors to non-zero or zero
    % values, depending on what the user chose.
    if (strcmpi(velocities,'Non-zero'))
        velocity_initial = ones(n,1);
        velocity_final = ones(n,1);
    else
        velocity_initial = zeros(n,1);
        velocity_final = zeros(n,1);
    end        
else
    % Other trajectory types don't allow us to specify non-zero
    % starting and ending velocities, so just set the initial and
    % final velocity vectors to zero.
    velocity_initial = zeros(n,1);
    velocity_final = zeros(n,1);
end

% Don't add code or modify code above here.


%% SET UP FOR SIMULATION

% Guess the number of time steps we will simulate, to enable us to
% pre-allocate the history arrays.  We add 2 to the duration divided
% by the loop delay to ensure we have space for the initial and final
% configurations.
nsamples_guess = 2 + ((tf - ti) / animation_delay);

% Initialize the time history variable to hold zeros with the initial
% time in the first slot.  At the end of the simulation, this variable
% will have only one column and one row for every step in time.
time_history = zeros(nsamples_guess,1);
time_history(1) = ti;

% Initialize the configuration history variable to hold zeros with the
% initial configuration of the robot in the first row.  At the end of
% the simulation, this variable will have n columns and one row for
% every step in time.
configuration_history = zeros(nsamples_guess,n);
configuration_history(1,:) = configuration_initial';

% Initialize the configuration variable with the initial
% configuration.  This is a column vector with n rows.
configuration = configuration_initial;


%% START LYNX ROBOT

% Open figure 1 and clear it.
figure(1)
clf

% Initialize the Lynx simulation.  This code uses lynxMove, which
% teleports the robot; it was not designed to be run with the actual
% hardware, but it works well with the simulator.
lynxStart()

% Call lynxServo once to send the Lynx to the zero pose and initialize
% the timers.
lynxServo(zeros(6,1));


%% SIMULATE

% Initialize a counter to start at 1, for filling the histories.
counter = 1;

% Initialize our time value to be the starting time.
t = ti;

% Start the Matlab timer.
tic

% Execute the code until we have reached the final time.
while (true)

    % Store the current value of time.
    t = ti + toc;

    % Increment the counter.
    counter = counter + 1;
    
    % Check whether we have passed the end of the simulation; if we
    % have, exit the while loop.
    if (t > tf)
        break
    end
    
    % Calculate the new value for each joint in the configuration.
    for i = 1:n
        configuration(i) = trajectory_function(t, ti, tf, ...
            configuration_initial(i), configuration_final(i), ...
            velocity_initial(i), velocity_final(i));
    end
    
    % Move the simulated robot to the desired configuration.  This
    % command does not work on the actual robot, since this code was
    % not designed to be run on the real robot.
    lynxMove(configuration);
    
    % Store this configuration in the configuration history.
    configuration_history(counter,:) = configuration';
    
    % Store this time in the time history.
    time_history(counter,1) = t;

    % Pause for a moment.
    pause(animation_delay)
end

% Store the final values in the history arrays.
configuration_history(counter,:) = configuration_final';
time_history(counter,1) = tf;

% Remove the rest of the zeros at the end of the preallocated history
% arrays.
if (counter < nsamples_guess)
    configuration_history = configuration_history(1:counter,:);
    time_history = time_history(1:counter,1);
end

% Stop the robot.
lynxStop


%% PLOT CONFIGURATION VALUE TRAJECTORIES

% Plot all the configuration values over time.
figure(2)
clf
plot(time_history, configuration_history, 'o-')
xlabel('Time (s)')
ylabel('Joint Angle (rad) or Gripper Distance (in.)')
legend('theta1', 'theta2', 'theta3', 'theta4', 'theta5', 'g','location','best')
title([trajectory ' Trajectories by ' studentNames ]);

