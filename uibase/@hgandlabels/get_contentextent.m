function val = get_contentextent(obj,h)
%HGANDLABELS/GET_CONTENTEXTENT   Returns size of panel content
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

if obj.isattached()
   
   % turn off the content listeners
   al = obj.autolayout;
   obj.autolayout = false;
   
   % set uiflowcontainer to the size and get the position
   props = get(obj.hpanel,{'Units','Position'});
   set(obj.hpanel,'Units','pixels','Position',[1 1 obj.totallims(1,:)],'Units',props{1});
   val = get(obj.hpanel,'Position');
   set(obj.hpanel,'Position',props{2});
   
   % reenable listeners
   obj.autolayout = al;
else
   val = [];
end