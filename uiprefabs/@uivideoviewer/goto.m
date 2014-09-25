function goto(obj,frm)
%UIVIDEOVIEWER/GOTO   Go to a specified video frame
%   GOTO(OBJ,FRM) sets the UIVIDEOVIEWER OBJ's CurrentFrame to FRM. If OBJ
%   is currently playing, the playback resumes from FRM.

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

obj.setcurrentframe(frm);
