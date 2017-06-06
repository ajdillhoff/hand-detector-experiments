% Alex Dillhoff
% June 6, 2017
%
% Compute an error between the detected location and ground truth.

function err = detectionError(p1, p2)
    err = sqrt((p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
end
