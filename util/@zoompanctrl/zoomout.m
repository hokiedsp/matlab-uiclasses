function zoomout(obj,varargin)
%UIZOOMCTRL/ZOOMOUT   Zooms axes out
%   ZOOMOUT(OBJ) zooms out the current axes to the zoom out point
%   ZOOMOUT(OBJ,AXES) zooms out AXES to the zoom out point
%   ZOOMIN(OBJ,FACTOR) zooms out the current axes by FACTOR.
%   ZOOMIN(OBJ,AXES,FACTOR) zooms out AXES by FACTOR.

narginchk(1,3);

if ~isscalar(obj)
   error('OBJ must be a scalar UIZOOMCTRL object.');
end

cax = get(obj.fig,'CurrentAxes');

if nargin<2
   ax = [];
   factor = [];
elseif nargin<3
   val = varargin{1};
   if ~(isnumeric(val)&&isscalar(val)&&val>0&&~isinf(val))
      error('FACTOR must be a positive scalar.');
   end
   if ishghandle(val) && isscalar(val) && isa(handle(val),'axes')
      ax = val;
      factor = [];
   else
      ax = [];
      factor = val;
   end
else
   [ax,factor] = deal(varargin{:});
   if ~(ishghandle(ax) && isscalar(ax) && isa(handle(ax),'axes'))
      error('AXES must be a single AXES handle.');
   end
   if ~(isnumeric(factor)&&isscalar(factor)&&factor>0&&~isinf(factor))
      error('FACTOR must be a positive scalar.');
   end
end

if ~isempty(ax)
   % set specified AXES as the current axes
   set(obj.fig,'CurrentAxes',ax);
end
if isempty(factor) % out to zoom out point
   zoom(obj.fig,'out');
else % out by factor
   % perform the zoom
   zoom(obj.fig,1/factor);
end

% revert the current axes
if ~isempty(ax)
   set(obj.fig,'CurrentAxes',cax);
end

