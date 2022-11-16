% This function calulates the projective matrix H given 4 source points:
%
% (xSource(1),ySource(1)) ... (xSource(4),ySource(4))
%
% and four destination points:
%
% (xDest(1),yDest(1)) ... (xDest(4),yDest(4))
%
% __________________________________________
% Source: Adam Czajka, February 2016
% Modified: AB, October 2020


function H = getHmatrix(xSource,ySource,xDest,yDest)

% In a projective transformation we have to solve a set of 8 linear equations
% providing 4 source points (xSource(1),ySource(1)),...(xSource(4),ySource(4))
% and four destination points (xDest(1),yDest(1)),...,(xDest(4),yDest(4)):
%
% xDest(1) = (c(1)*xSource(1) + c(2)*ySource(1) + c(3)) / (c(7)*xSource(1) + c(8)*ySource(1) + 1)
% yDest(1) = (c(4)*xSource(1) + c(5)*ySource(1) + c(6)) / (c(7)*xSource(1) + c(8)*ySource(1) + 1)
% xDest(2) = (c(1)*xSource(2) + c(2)*ySource(2) + c(3)) / (c(7)*xSource(2) + c(8)*ySource(2) + 1)
% yDest(2) = (c(4)*xSource(2) + c(5)*ySource(2) + c(6)) / (c(7)*xSource(2) + c(8)*ySource(2) + 1)
% xDest(3) = (c(1)*xSource(3) + c(2)*ySource(3) + c(3)) / (c(7)*xSource(3) + c(8)*ySource(3) + 1)
% yDest(3) = (c(4)*xSource(3) + c(5)*ySource(3) + c(6)) / (c(7)*xSource(3) + c(8)*ySource(3) + 1)
% xDest(4) = (c(1)*xSource(4) + c(2)*ySource(4) + c(3)) / (c(7)*xSource(4) + c(8)*ySource(4) + 1)
% yDest(4) = (c(4)*xSource(4) + c(5)*ySource(4) + c(6)) / (c(7)*xSource(4) + c(8)*ySource(4) + 1)
%
% This can be written as a system of linear equations Ac = b, where:


A = [...
    xSource(1) ySource(1) 1 0 0 0 -xSource(1)*xDest(1) -ySource(1)*xDest(1);...
    0 0 0 xSource(1) ySource(1) 1 -xSource(1)*yDest(1) -ySource(1)*yDest(1);...
    xSource(2) ySource(2) 1 0 0 0 -xSource(2)*xDest(2) -ySource(2)*xDest(2);...
    0 0 0 xSource(2) ySource(2) 1 -xSource(2)*yDest(2) -ySource(2)*yDest(2);...
    xSource(3) ySource(3) 1 0 0 0 -xSource(3)*xDest(3) -ySource(3)*xDest(3);...
    0 0 0 xSource(3) ySource(3) 1 -xSource(3)*yDest(3) -ySource(3)*yDest(3);...
    xSource(4) ySource(4) 1 0 0 0 -xSource(4)*xDest(4) -ySource(4)*xDest(4);...
    0 0 0 xSource(4) ySource(4) 1 -xSource(4)*yDest(4) -ySource(4)*yDest(4)];

b = [xDest(1) yDest(1) xDest(2) yDest(2) xDest(3) yDest(3) xDest(4) yDest(4)].';

% We certainly are looking for 'c' which contains components of our H
% matrix, that is: c = [c(1) c(2) c(3) c(4) c(5) c(6) c(7) c(8)]

% So let's solve our task using 'linsolve' function:
c = linsolve(A,b);

% Our H matrix is here:
H = [c(1) c(2) c(3); c(4) c(5) c(6); c(7) c(8) 1];

% That's all!