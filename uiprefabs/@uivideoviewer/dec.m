function dec(obj,dec)

if nargin<2
   dec = 1;
elseif ~(isnumeric(dec)&&isscalar(dec)&&~isinf(dec)&&~isnan(dec)&&inc==floor(dec))
   error('DEC must be an integer.');
end

% video file must be open
if isempty(obj.vr)
   error('Video file is not open.');
end

% momentarily stop if running
if obj.isplaying()
   stop(obj.tmr);
end

% set frame
try
   obj.setcurrentframe(max(obj.n-dec,1))
catch ME
   % momentarily stop if running
   if obj.isplaying()
      start(obj.tmr);
   end
   ME.rethrow();
end

% momentarily stop if running
if obj.isplaying()
   start(obj.tmr);
end
