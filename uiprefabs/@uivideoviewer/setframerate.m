function setframerate(obj,fs)
%VIDEOVIEWER/SETFRAMERATE  (protected)
%   SETFRAMERATE(OBJ,FS) sets the playback frame rate to FS. FS must be
%   prescreened for its finite positiveness.
%
%   SETFRAMERATE(OBJ,AUTO) sets FrameRateMode according to logical AUTO
%   flag. AUTO=true: FrameRateMode='auto'; false: FrameRateMode='manual'
%
%   SETFRAMERATE(OBJ) sets FrameRateMode loaded video IF
%   FrameRateMode='auto'.

if nargin>1
   if islogical(fs) % given new AUTO flag
      obj.fsauto = fs;
      if ~fs, return; end
   else % given new FrameRate
      obj.fsauto = false; %
   end
end

if nargin==1 || obj.fsauto
   if obj.isopen()
      fs = obj.vr.FrameRate;
   else % if video file is not open, nothing to do
      return;
   end
end

% pause playback
isplaying = obj.isplaying();
stop(obj.tmr);

% if frame is too high, decimate the video during playback
obj.Qdec = ceil(max(obj.Tmin,1.5*test_speed(obj))*fs);
T = obj.Qdec/fs;

% round the frame period to the nearest ms (MATLAB timer object constraint)
T = round(T*1e3)*1e-3;

% set Timer's period (stop the playback if running and resume once changed)
obj.tmr.Period = T;
if isplaying, start(obj.tmr); end

end

function Tmax = test_speed(obj)

Ntest = 10;
T = zeros(Ntest,1);
frm0 = obj.n;
frm = frm0;
Nfrms = obj.vr.NumberOfFrames;
for n = 1:10
   frm = mod(frm+obj.Qdec-1,Nfrms)+1;
   tic;
   obj.updateframe(frm);
   T(n) = toc;
end
obj.updateframe(frm0);
Tmax = max(T);
end
