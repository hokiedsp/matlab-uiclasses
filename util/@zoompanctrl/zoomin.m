function zoomin(obj,varargin)
%UIZOOMCTRL/ZOOMIN   Zoom in an axes
%   ZOOMIN(OBJ,FACTOR) zooms the current axis by FACTOR.
%   ZOOMIN(OBJ,AXES,FACTOR) zooms AXES by FACTOR.

narginchk(2,3);

if ~isscalar(obj)
   error('OBJ must be a scalar UIZOOMCTRL object.');
end

cax = get(obj.fig,'CurrentAxes');
if nargin>2 % axes specified
   ax = varargin{2};
   if ~(ishghandle(ax) && isscalar(ax) && isa(handle(ax),'axes'))
      error('AXES must be a single AXES handle.');
   end
   set(obj.fig,'CurrentAxes',ax);
end

factor = varargin{end};
if ~(isnumeric(factor)&&isscalar(factor)&&factor>0&&~isinf(factor))
   error('FACTOR must be a positive scalar.');
end

% perform the zoom
zoom(obj.fig,factor);

% revert the current axes
if nargin>2
   set(obj.fig,'CurrentAxes',cax);
end
