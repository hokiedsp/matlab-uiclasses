function timerfcn(obj)
%UIVIDEOVIEWER/TIMERFCN   Timer object callback
%   TIMERFCN(OBJ)

if obj.tmr_skp, return; end
obj.tmr_skp = true;

try
   % the next frame index
   n_next = obj.n + obj.Qdec;
   
   if n_next>obj.pbrng(2) % reached the end of playback range
      % if end-of-playback-range is reached, stop/rewind/loop
      n0 = max(obj.pbrng(1),1);
      if obj.repeat
         % loop back to the first frame
         n_next = n0;
      else
         % stop the timer
         stop(obj.tmr);
         notify(obj,'EndOfVideo');
         
         % rewind if AutoRewind='on'
         if obj.rewind
            obj.n = n0;
         end
         
         n_next = obj.pbrng(2);
      end
   end
   
   % load the new frame
   obj.updateframe(n_next);
   
   % execute user callback if set
   %obj.framechangedfcn(obj,obj.n);
   notify(obj,'FrameChanged');
   obj.tmr_skp = false;
catch ME
   obj.tmr_skp = false;
   ME.rethrow();
end
