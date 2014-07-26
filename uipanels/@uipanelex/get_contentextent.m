function val = get_contentextent(obj,h)
%UIPANELEX/GET_CONTENTEXTENT   Returns size of panel content
%   POS = GET_CONTENTEXTENT(OBJ) returns a position rectangle indicating
%   the tightest rectangle encompassing panel's child objects. POS is a
%   four-element vector that defines the size and position, and has the
%   form:
%
%      [x0,y0,width,height]
%
%   (x0,y0) is the location of the lower-left-hand corner of the lowest and
%   left-most child. width and height are the dimensions of the rectangle.
%   All measurements are in units specified by the panel's Units property.
%
%   POS = GET_CONTENTEXTENT(OBJ,H) finds the tightest rectangle
%   encompassing the objects in H.

if strcmp(obj.hg.Type,'axes')
   val = obj.hg.Position;
   ti = obj.hg.TightInset;
   val([1 2]) = -ti([1 2]);
   val([3 4]) = val([3 4]) + ti([1 2]) + ti([3 4]);
else
   if nargin<2
      h = get(obj.hg,'Children');
   end
   
   if isempty(h)
      val = [];
      return;
   end
   
   % disable listeners
   set(obj.content_listeners,'Enabled','off');
   
   % save child units and set them to panel's units
   u = get(obj.hg,'Units');
   uc = get(h,{'Units'});
   set(h,'Units',u);
   
   % compute the extent
   pos = cell2mat(get(h,{'Position'}));
   llh = min(pos(:,[1 2]),[],1);
   urh = max(pos(:,[1 2]) + pos(:,[3 4]),[],1); % upper-right-hand corner
   val = [llh urh-llh];
   
   % rever the children's Units
   set(h,{'Units'},uc);
   
   % reenable listeners
   set(obj.content_listeners,'Enabled','on');
end
