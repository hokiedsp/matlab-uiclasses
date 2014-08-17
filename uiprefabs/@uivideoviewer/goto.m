function goto(obj,frm)

if ischar(frm)
   if ~isrow(frm)
      error('Invalid frame.');
   end
   switch lower(frm)
      case 'first'
         frm = 1;
      case 'prev'
         frm = max(obj.n-1,1);
      case 'next'
         frm = min(obj.n+1,obj.vr.NumberOfFrames);
      case 'last'
         frm = obj.vr.NumberOfFrames;
      otherwise
         error('Invalid frame.');
   end
end

if ~(isnumeric(frm) && isscalar(frm) && frm==floor(frm))
   error('Invalid frame.');
end

isrunning = obj.isplaying();
stop(obj.tmr)
obj.setcurrentframe(frm);
if isrunning, start(obj.tmr); end
   
end
