%% lynx_animation_starter.m
%
% This Matlab script provides the starter code for animating the Lynx
% robot on Homework 5 in MEAM 520 at the University of Pennsylvania.
% The original was written by Professor Katherine J. Kuchenbecker
% (kuchenbe@seas.upenn.edu). Students will modify this code to create
% their own script.
%
% Change the name of this file to replace "starter" with your PennKey.
% For example, Professor Kuchenbecker's script would be
% puma_animation_kuchenbe.m


%% SETUP

% Home the console, so we can more easily find any errors that may occur.
home

% Set student names.
studentNames = 'PUT YOUR NAMES HERE';

% Declare global variables.  These are global variables so that the
% key press function updateq can change their values.
global q weAreDone

% Initialize the global variable that says when we are finished.
weAreDone = false;

% Initialize the global q variable to hold all zeros for the joint
% angles (the first five elements) and 1 inch for the grip distance
% (the sixth element).  This is a column vector.
q = [0 0 0 0 0 1]';

% Delay time after showing the robot.  Increase this reduce
% computational load, and decrease it to make the motion appear
% smoother.
animation_delay = 0.2; % s


%% SET UP PLOT

% Select figure 1 and clear it.
f = figure(1);
clf

% Choose the left two thirds of the figure to plot the robot.
subplot(1,3,1:2)

% Plot something simple in a style suitable for a robot.
x = [0 0 0];
    y= [10 10 10];
    z = [12 12 12];

   plot3(x,y,z,'-r');

hold on
hrobot = plot3([0 0 10], [0 0 0], [0 6 6],'k.-','linewidth',5,'markersize',30);
xaxis = plot3([0 0 10], [0 0 0], [0 6 6],'r :','linewidth',5,'markersize',30);
yaxis = plot3([0 0 10], [0 0 0], [0 6 6],'r :','linewidth',5,'markersize',30);
zaxis = plot3([0 0 10], [0 0 0], [0 6 6],'r :','linewidth',5,'markersize',30);


% Set the axis limits to reasonable values for the Lynx and force one
% unit to be displayed the same in all directions.
axis equal vis3d
axis([-5 15 -15 15 -10 20])

% Set the viewing angle and turn on the grid
view(70,10)
grid on

% Add a title including the student names.
title(['Lynx Robot by ' studentNames ]);

% Add axis labels.
xlabel('X (in.)')
ylabel('Y (in.)')
zlabel('Z (in.)')

% Attach the key press function to the figure window, so that the
% joint variables change when you press keys.
set(f,'keypressfcn',@updateq)

% Write text to show the values of the variables in a subplot the
% right of the subplot of the robot.  We have to handle the last value
% differently because it is the grip distance, not a joint angle.
subplot(1,3,3)
t = zeros(length(q),1);
for i = 1:(length(q)-1)
    t(i) = text(0,-i,['\theta_' num2str(i,'%d') '^* = ' num2str(q(i),'%.1f')],'fontsize',20);
    hold on
end
t(length(q)) = text(0,-length(q),['g^* = ' num2str(q(length(q)),'%.1f in.')],'fontsize',20);
ylim([-length(q) 0])
axis off

% Give some instructions.
title({'1-6 increase joints, and q-y decrease joints.' 'Zero with z. Press x to exit.'})


%% ROBOT PARAMETERS

% This problem is about the Lynx robot, a 5-dof manipulator with a
% parallel-jaw gripper.

% Define the robot's measurements, in inches.  These correspond to the
% diagram in the homework and are constant.
d1 = 3;
a2 = 5.75;
a3 = 7.375;
d5 = 4.125;
lg = 1.125;

% Length of coordinate frame axes, to display, in inches.
b = 6;


%% ANIMATION LOOP

% Loop until we are done, which is triggered by pressing the d key on
% the keyboard.
while(~weAreDone)

    % Pull the joint angles and grip distance out of the global
    % variable.  The values in q are changed when you press keys.
    theta1 = q(1);
    theta2 = q(2);
    theta3 = q(3);
    theta4 = q(4);
    theta5 = q(5);
    g = q(6);

    % ***************************************************************

    % Write your code between the two lines of stars.

    % Your first objective is to plot a simple line drawing of the
    % Lynx robot in its current pose.  Calculate the x, y, and z
    % coordinates of all the necessary points along the robot arm.

    % Set the xdata, ydata, and zdata for the line drawing handle
    % hrobot to be the x, y, and z coordinates of the points you want
    % to plot.  As a simple demonstration, we simply set these
    % coordinates to be ten times the different joint coordinates, so
    % you can see a 3D line segment move around.  You will need to
    % change this.

    %A = dh_kuchenbe(a, alpha, d, theta)
    syms pi;

    A1 = dh_kuchenbe(0, -pi/2, 3, theta1);
    A2 = dh_kuchenbe(5.75, 0, 0, theta2-(pi/2));
    A3 = dh_kuchenbe(7.375, 0, 0, theta3+(pi/2));
    A4 = dh_kuchenbe(0, -pi/2, 0, theta4-pi/2);
    A5 = dh_kuchenbe(0, 0, 4.125, theta5);

    o = [0 0 0 1]';

    o0 = o;
    o1 = A1*o;
    o2 = A1*A2*o;
    o3 = A1*A2*A3*o;
    o4 = A1*A2*A3*A4*o;
    o5 = A1*A2*A3*A4*A5*o;

    endEffector = A1*A2*A3*A4*A5;

    o6 = endEffector*[g/2 0 0 1]';
    o8 = endEffector*[g/2 0 lg 1]';
    o7 = endEffector*[-g/2 0 0 1]';
    o9 = endEffector*[-g/2 0 lg 1]';

    xFrame = endEffector*[b 0 0 1]';
    yFrame = endEffector*[0 b 0 1]';
    zFrame = endEffector*[0 0 b 1]';

   set(hrobot,'xdata',[o0(1) o1(1) o2(1) o3(1) o4(1) o5(1) o6(1) o8(1) o6(1) o5(1) o7(1) o9(1) o7(1) o5(1) ]',...
        'ydata',[o0(2) o1(2) o2(2) o3(2) o4(2) o5(2) o6(2) o8(2) o6(2) o5(2) o7(2) o9(2) o7(2) o5(2) ]',...
        'zdata',[o0(3) o1(3) o2(3) o3(3) o4(3) o5(3) o6(3) o8(3) o6(3) o5(3) o7(3) o9(3) o7(3) o5(3)]');
    
   set(xaxis,'xdata',[o5(1) xFrame(1) ]',...
        'ydata',[o5(2) xFrame(2) ]',...
        'zdata',[o5(3) xFrame(3)  ]');
  set(yaxis,'xdata',[o5(1) yFrame(1) ]',...
        'ydata',[o5(2) yFrame(2) ]',...
        'zdata',[o5(3) yFrame(3)  ]');
  set(zaxis,'xdata',[o5(1) zFrame(1) ]',...
        'ydata',[o5(2) zFrame(2) ]',...
        'zdata',[o5(3) zFrame(3)  ]');
  
    %hold off


    % Your second objective is to add the gripper to the end of the
    % robot drawing, so you can see it opening and closing.  It should
    % have the same visual style as the Lynx robot itself.

    % Your third objective is to plot the end-effector coordinate
    % frame in its current pose, displaying each unit vector as having
    % the length b, defined above.  Make the unit vectors colored
    % dashed line segments with no markers and no arrowheads.

    % ***************************************************************

    % Update the text in the subplot to the right of the robot.
    for i = 1:(length(q)-1)
        set(t(i),'string',['\theta_' num2str(i,'%d') '^* = ' num2str(q(i),'%.1f')]);
    end
    set(t(end),'string',['g^* = ' num2str(q(end),'%.1f in.')])

    % Pause for a short time.
    pause(animation_delay)
end


%% CLEAN UP

% Tell the user we are done by setting the title of the subplot.
subplot(1,3,3)
title('Done')

% Remove the key press function from the figure window to avoid
% triggering errors with further key presses.
set(f,'keypressfcn',[])