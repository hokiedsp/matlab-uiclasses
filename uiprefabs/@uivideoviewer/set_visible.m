function set_visible(obj,val)
%UIVIDEOVIEWER/SET_VISIBLE
%   SET_VISIBLE(OBJ,VAL)

if val==1 % 'on'
   if obj.isopen() % video file is currently open
      set(obj.im,'Visible','on');
      if obj.txloc~=4 % counter shown
         set(obj.tx,'Visible','on');
      end
   else % no video file is open
      set(obj.hg,'Visible','on');
   end
else % 'off'
   set([obj.hg obj.im obj.tx],'Visible','off');
end
