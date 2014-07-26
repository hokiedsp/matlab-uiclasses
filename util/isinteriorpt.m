function tf = isinteriorpt(polygon,p)
%ISINTERIORPOINT   true if a point resides within a polygon
%   ISINTERIORPOINT(POLYGON,[x y]) returns true if the point (x,y) is
%   within a polygon with N vertices given by the N-by-2 matrix POLYGON.

% p1 & p2: edge dpoints
x = [polygon(:,1) polygon([2:end 1],1)];
y = [polygon(:,2) polygon([2:end 1],2)];

% find min & max
ys = sort(y,2);
maxx = max(x,[],2);

% find which edges are clearly ruled out
I = p(2) <= ys(:,1) | p(2) > ys(:,2) ... % y not within edge extent
   | p(1) > maxx ... % point not to the left side of the edge
   | ys(:,1) == ys(:,2); % edge is horizontal

% remove unqualified edges
x(I,:) = [];
y(I,:) = [];

% find intersection of p1-p2 line and inc horizontal line from p
xinters = (p(2)-y(:,1)).*diff(x,[],2)./diff(y,[],2) + x(:,1);

% count number of edge intersections
counter = sum(x(:,1) == x(:,2) | p(1) <= xinters);

% if intersects odd # of times, p is an interior point
tf = counter>0 && mod(counter,2) ~= 0;
