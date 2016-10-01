function updateq(~,info)
% This is the function that executes when you press a key and have the
% Lynx figure window highlighted.  It updates the robot's joint angles
% according to the key the user pressed.

% Define the small increment by which to change the joint variables.
% This is in radians for the revolute joints and inches for the grip.
smallIncrement = 0.1;

% Declare the global variables that we're updating.
global q weAreDone

% Get the key that the user pressed.
k = info.Key;

% Set the consequences of the detected key hit.  For numbers 1 through
% 6, we increment the joint (positive direction), and for letters q
% through y, we decrement it.  We also provide a simple way to send
% the robot to the zero pose, and a way to be done.
switch k
    case {'1' '!'}
        i = 1;
        dir = 1;
    case {'q' 'Q'}
        i = 1;
        dir = -1;
    case {'2' '@'}
        i = 2;
        dir = 1;
    case {'w' 'W'}
        i = 2;
        dir = -1;
    case {'3' '#'}
        i = 3;
        dir = 1;
    case {'e' 'E'}
        i = 3;
        dir = -1;
    case {'4' '$'}
        i = 4;
        dir = 1;
    case {'r' 'R'}
        i = 4;
        dir = -1;
    case {'5' '%'}
        i = 5;
        dir = 1;
    case {'t' 'T'}
        i = 5;
        dir = -1;
    case {'6' '^'}
        i = 6;
        dir = 1;
    case {'y' 'Y'}
        i = 6;
        dir = -1;
    case {'z' 'Z'}
        q = zeros(6,1);
        return
    case {'x' 'X'}
        weAreDone = true;
        return
    otherwise
        % It is some other key, so do nothing.
        return
end

% Handle the key press by updating the specified joint variable by a
% small increment.
q(i) = q(i) + dir * smallIncrement;