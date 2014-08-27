function stop(obj)
%UIVIDEOVIEWER/STOP   Stops video playback
%   STOP(OBJ) stops ongoing video playback. If video is not playing,
%   no action is taken.

% must not be playing
% if strcmp(obj.tmr.Running,'off')
%    error('Already stopped.');
% end

% stop the timer
stop(obj.tmr);
