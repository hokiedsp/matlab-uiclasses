function J = isonvertex(loc,pts,dx,dy)
%ISONVERTEX   Check pointer is on a vertex
%   ISONVERTEX(LOC,[x y],dx,dy)

% create a bounding box around each segment
% and check if loc falls in it
x = pts(:,1);
Ix = loc(1)+dx>=min(x,[],2) & loc(1)-dx<=max(x,[],2);
y = pts(:,2);
Iy = loc(2)+dy>min(y,[],2) & loc(2)-dy<=max(y,[],2);
J = find(Ix & Iy); % vertical and w/in range

% If more than 1 point found, pick the closest one
if numel(J)>1 
   % compute shortest distance between loc and the candidate segments
   dsq = sum(bsxfun(@minus,loc,pts(J,:)).^2,2);

   % pick the segment with the shortest distance
   [~,I] = min(dsq);
   J = J(I);
end
