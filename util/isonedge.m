function J = isonedge(loc,pts,dx,dy)
%ISONEDGE   Check pointer is on an edge
%   ISONEDGE([x y],[x0 y0 x1 y1],dx,dy) returns the row index to the edge
%   definition matrix [x0 y0 x1 y1] on which the point [x y] is located on.
%   If the point [x y] is not on any of the edges, ISONEDGE returns empty.
%   dx and dy defines the "slack" allowed in x and y direction

% create a bounding box around each segment
% and check if loc falls in it
x = pts(:,[1 3]);
Ix = loc(1)+dx>=min(x,[],2) & loc(1)-dx<=max(x,[],2);
y = pts(:,[2 4]);
Iy = loc(2)+dy>min(y,[],2) & loc(2)-dy<=max(y,[],2);
J = find(Ix & Iy); % vertical and w/in range

if numel(J)>1 % more than 1 candidate found, 
   % compute shortest distance between loc and the candidate segments

   P0 = pts(J,[1 2]);
   P1 = pts(J,[3 4]);
   v = P1-P0;
   w = bsxfun(@minus,loc,pts(J,[1 2]));

   c1 = dot(w,v,2);
   c2 = dot(v,v,2);
   
   idx0 = c1<=0; % outside of pts(:,[1 2])
   idx1 = c2<=c1; % outside of pts(:,[3 4])
   
   dsq = zeros(size(c1));
   dsq(idx0) = sum(bsxfun(@minus,loc,P0(idx0,:)).^2,2);
   dsq(idx1) = sum(bsxfun(@minus,loc,P1(idx1,:)).^2,2);
   
   idx2 = ~(idx0|idx1);
   b = c1(idx2)./c2(idx2);
   Pb = P0(idx2,:) + bsxfun(@times,b,v(idx2,:));
   dsq(idx2) = sum(bsxfun(@minus,loc,Pb).^2,2);

   % pick the segment with the shortest distance
   [~,I] = min(dsq);
   J = J(I);
end
