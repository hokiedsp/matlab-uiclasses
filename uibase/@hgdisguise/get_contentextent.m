function val = get_contentextent(obj,varargin)
%HGDISGUISE/GET_CONTENTEXTENT   Returns size of panel content
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

hg = obj.hg;
obj.hg = obj.hpanel;
val = obj.get_contentextent@uipanelex(varargin{:});
obj.hg = hg;
