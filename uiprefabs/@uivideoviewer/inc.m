function inc(obj,inc)

if nargin<2
   inc = 1;
elseif ~(isnumeric(inc)&&isscalar(inc)&&~isinf(inc)&&~isnan(inc)&&inc==floor(inc))
   error('INC must be an integer.');
end

% video file must be open
if isempty(obj.vr)
   error('Video file is not open.');
end

% must not be playing
if strcmp(obj.tmr.Running,'on')
   error('Video cannot be playing.');
end

obj.setcurrentframe(obj.n+inc);

end
