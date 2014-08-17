function stop(obj)

% must not be playing
% if strcmp(obj.tmr.Running,'off')
%    error('Already stopped.');
% end

% stop the timer
stop(obj.tmr);

end
