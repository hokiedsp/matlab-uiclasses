function val = get_contentextent(obj,h)
%UISCROLLPANEL/GET_CONTENTEXTENT   Returns canvas content encompassing rectangle
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

if nargin==2
   val = obj.get_contentextent@uipanelex(h);
   return;
end

h = get(obj.hcanvas,'Children');

if isempty(h)
   val = [];
   return;
end

val = obj.get_contentextent@uipanelex(h);
if isempty(val)
   return;
end

% save Canvas' Units and set to main panel's
u = get(obj.hcanvas,'Units');
try
   origin = set(obj.hcanvas,get(obj.hwindow,'Units'));
catch
   val = [];%'unsupported';
   return;
end
val([1 2]) = val([1 2]) + origin;

% rever the Canvas' Units
set(obj.hcanvas,{'Units'},u);
