function configuration = get_random_lynx_configuration()

% Define minimum and maximum angles for all joints, in radians, plus
% for the gripper, in inches.
theta1_min = -1.4;
theta1_max =  1.4;
theta2_min = -1.2;
theta2_max =  1.4;
theta3_min = -1.8;
theta3_max =  1.7;
theta4_min = -1.9;
theta4_max =  1.7;
theta5_min = -2.0;
theta5_max =  1.5;
g_min = -15/25.4;
g_max =  30/25.4;

% Calculate random configuration values, between the minimum and the
% maximum values specified above.
theta1 = theta1_min + (theta1_max - theta1_min) * rand;
theta2 = theta2_min + (theta2_max - theta2_min) * rand;
theta3 = theta3_min + (theta3_max - theta3_min) * rand;
theta4 = theta4_min + (theta4_max - theta4_min) * rand;
theta5 = theta5_min + (theta5_max - theta5_min) * rand;
g = g_min + (g_max - g_min) * rand;

% Assemble the six values into a column vector.
configuration = [theta1; theta2; theta3; theta4; theta5; g];