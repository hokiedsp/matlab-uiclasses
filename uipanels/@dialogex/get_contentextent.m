function val = get_contentextent(obj,~)
%DIALOGEX/GET_CONTENTEXTENT   Returns size of panel content
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

if ~obj.isattached(), val = []; return; end

u = get(obj.hg,'Units');
bbext = obj.pnButtonBox.Extent;

hgw = hgwrapper.findobj(obj.ContentPanel);
if isempty(hgw) || ~isa(hgw,'uipanelex')

   h = get(obj.ContentPanel,'Children');
   
   if isempty(h)
      cbext = [0 0 0 0];
   else
      % save child units and set them to panel's units
      uc = get(h,{'Units'});
      set(h,'Units',u);
      
      % compute the extent
      pos = cell2mat(get(h,{'Position'}));
      llh = min(pos(:,[1 2]),[],1);
      urh = max(pos(:,[1 2]) + pos(:,[3 4]),[],1); % upper-right-hand corner
      cbext = [1 1 urh-llh];
      
      % rever the children's Units
      set(h,{'Units'},uc);
   end
else
   cbext = hgw.Extent;
end

val = [0 0 max(bbext(3),cbext(3)) bbext(4)+cbext(4)];
if u(1)=='p' % if units is pixels, set x0 and y0 to 1
   val([1 2]) = 1;
end
