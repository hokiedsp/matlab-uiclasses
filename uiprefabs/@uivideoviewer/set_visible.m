function set_visible(obj,val)
%UIVIDEOVIEWER/SET_VISIBLE
%   SET_VISIBLE(OBJ,VAL)

hgvis = 'off';
imvis = 'off';
txvis = 'off';

if val==1 % 'on'
   if obj.isopen() % video file is currently open
      imvis = 'on';
      if obj.txloc~=4 % counter shown
         txvis = 'on';
      end
   else % no video file is open
      hgvis = 'on';
   end
end
set(obj.hg,'Visible',hgvis);
set(obj.im,'Visible',imvis);
set(obj.tx,'Visible',txvis);
