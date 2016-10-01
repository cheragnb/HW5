function q = lspb_trajectory_starter(t, tstart, tend, qstart, qend, ~, ~)
% LSPB interpolation.
disp ('enter lspb');
% two scenarios. linear and parabolic.
tb = (tend - tstart)*0.1;
tbs = tstart+tb ;
tbe = tend - tb ;
Q = [qstart 0 0 0 qend 0 0 0]';
%A = [a b c d e f g h ]';
T = [tstart^2 tstart 1 0 0 0 0 0 ;
    2*tstart 1 0 0 0 0 0 0 ;
    tbs^2 tbs 1 -tbs -1 0 0 0 ;
    2*tbs 1 0 -1 0 0 0 0 ;
    0 0 0 0 0 tend^2 tend 1;
    0 0 0 0 0 2*tend 1 0 ;
    0 0 0 -tbe -1 tbe^2 tbe 1 ;
    0 0 0 -1 0 2*tbe 1 0];

A = inv(T)*Q;

if (t < tbs)
    q = A(1)*t^2 + A(2)*t + A(3);

elseif (t >= tbs && t <= tbe)
    q = A(4)*t + A(5);
elseif (t>tbe)
    q = A(6)*t^2 + A(7)*t + A(8);
end 
        
% By default, do linear interpolation.  You must replace this with the
% correct trajectory type.
