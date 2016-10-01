%% lynx_dance_starter.m
% 
% This Matlab script provides the starter code for making a Lynx robot
% dance on Homework 5 in MEAM 520 at the University of Pennsylvania.
% The original was written by Professor Katherine J. Kuchenbecker
% (kuchenbe@seas.upenn.edu). Students will modify this code to create
% their own script.
%
% Change the name of this file to replace "starter" with your PennKey.
% For example, Professor Kuchenbecker's script would be
% lynx_trajectories_kuchenbe.m


%% Definitions

% Clear all variables and functions.
clear

% Home the console, so we can easily find any errors that may occur.
home

% Set this hardware variable to 'off' to use the simulator. Set it to
% be the name of the robot to run your code on a physical Lynx robot;
% this works only on the dedicated lab computers.
hardware = 'off';

% When using a real robot, you need to set the name of the port being
% used to communicate with the Lynx. To find the correct value, go to
% Device Manager, hit OK, and and click the drop-down arrow next to
% "Ports (COM & LPT)" to see the USB devices connected to the
% computer. The robot is usually on 'com3' but might change to a
% different COM port.
port = 'com3';

% Declare the student PennKeys variable to be global to that
% get_angles can access this string.
global studentPennKeys

% Set student names and PennKeys.
studentNames = 'PUT YOUR NAMES HERE';
studentPennKeys = 'starter'; % Replace with yourpennkey or pennkey1_pennkey2

% Load the dance file; its name includes the student PennKeys.
load(['dance_' studentPennKeys],'dance')

% Pull the list of via point times out of the dance matrix.
tvia = dance(:,1);

% Initialize the function that calculates angles.
get_angles();

% Define music filename.  You need to change this to your song.
musicfilename = 'Three Pointer G';


%% Music

% Load the piece of music for the robot to dance to.
[y,Fs] = audioread([musicfilename '.wav']);

% Calculate the duration of the music.
musicduration = (length(y)-1)/Fs;

% Calculate the duration of silence at the start of the dance.
silenceduration = abs(min(tvia));

% Create a time vector for the entire piece of music, for plotting.
t = ((min(tvia):(1/Fs):musicduration))';

% Pad the start of the music file with zeros for the silence.
y = [zeros(length(t)-length(y),2); y];


%% Choose duration

% Set the start and stop times of the segment we want to test.
% To play the entire dance, set tstart = t(1) and tstop = t(end).
tstart = t(1);
tstop = t(5);

% Select only the part of the music that we want to play right now,
% from tstart to tstop.
yplay = y(1+round(Fs*(tstart - t(1))):round(Fs*(tstop-t(1))),:);

% Put this snippet into an audio player so we can listen to it.
music = audioplayer(yplay,Fs);


%% Plot music

% Pull first audio channel and downsample it for easier display.
factordown = 30;
ydown = downsample(y(:,1),factordown);

% Downsample the time vector too.
tdown = downsample(t,factordown);

% Open figure and clear it.
figure(2)
clf

% Plot one of the sound channels to look at.
plot(tdown,ydown,'Color',[.2 .4 0.8]);
xlim([floor(t(1)) ceil(t(end))])

% Turn on hold to allow us to plot more things on this graph.
hold on

% Plot a vertical line at the time of each of the via points.
for i = 1:length(tvia)
    plot(tvia(i)*[1 1],ylim,'k--')
end

% Plot vertical lines at the start and stop times.
plot(tstart*[1 1],ylim,'k:')
plot(tstop*[1 1],ylim,'k:')

% Add a vertical line to show where we are in the music.
hline = plot(tstart*[1 1],ylim,'r-');

% Turn off hold.
hold off

% Set the title to show the student names and the name of the song.
title([studentNames ': ' musicfilename])


%% Start robot

% Open figure 1 and clear it.
figure(1)
clf

% Initialize the Lynx simulation or the physical robot.
lynxStart('Hardware',hardware,'Port',port)

% Set the home pose to be the zero pose.
thetahome = zeros(6,1);

% Call lynxServo once to initialize timers.
lynxServo(thetahome);

% Set the title to show the student names.
title(['Lynx Dance by ' studentNames])



%% Initialize dance

% Calculate the joint angles where the robot should start.
thetastart = get_angles(tstart);

% Calculate time needed to get from home pose to starting pose moving at
% angular speed of 0.5 radians per second on the joint that has the
% farthest to go.
tprep = abs(max(thetastart - thetahome)) / .5;

% Start the built-in MATLAB timer.
tic

% Slowly servo the robot to its starting position, in case we're
% not starting at the beginning of the dance.
while(true)
    % Get the current time for preparation move.
    tnow = toc;
    
    % Check to see whether preparation move is done.
    if (tnow > tprep)
        
        % Servo the robot to the starting pose.
        lynxServo(thetastart)
        
        % Break out of the infinite while loop.
        break

    end
    
    % Calculate joint angles.
    thetanow = linear_trajectory(tnow,0,tprep,thetahome,thetastart);

    % Servo the robot to this pose to prepare to dance.
    lynxServo(thetanow);
end

% Initialize history vectors for holding time and angles.  We preallocate
% these for speed, making them much larger than we will need.
thistory = zeros(10000,1);
thetahistory = zeros(10000,6);

% Initialize our counter at zero.
i = 0;


%% Start music and timer

% Start the zero-padded music so we hear it.
play(music);

% Start the built-in MATLAB timer so we can keep track of where we are in
% the song.
tic


%% Dance

% Enter an infinite loop.
while(true)
    % Increment our counter.
    i = i+1;
    
    % Get the current time elapsed and add it to the time where we're
    % starting in the song. Store this value in the thistory vector.   
    thistory(i) = toc + tstart;
    
    % Check if we have passed the end of the performance.
    if (thistory(i) > tstop)
        
        % Break out of the infinite while loop.
        break

    end
    
    % Calculate the joint angles for the robot at this point in time and
    % store in our thetahistory matrix.
    thetahistory(i,:) = get_angles(thistory(i));

    % Servo the robot to these new joint angles.
    lynxServo(thetahistory(i,:));
        
    % Move the line on the music plot.
    set(hline,'xdata',thistory(i)*[1 1]);
end
        
% Remove the unused ends of the history vector and matrix, which we
% preallocated for speed.
thistory(i:end) = [];
thetahistory(i:end,:) = [];


%% Plot output

% Open figure 3 and clear it.
figure(3)
clf

% Plot robot configuration over time throughout the dance.
plot(thistory, thetahistory)
xlabel('Time (s)')
ylabel('Joint Angle (rad) or Gripper Distance (in.)')
legend('theta1', 'theta2', 'theta3', 'theta4', 'theta5', 'g','location','best')
title(['Lynx Trajectories by ' studentNames ]);
