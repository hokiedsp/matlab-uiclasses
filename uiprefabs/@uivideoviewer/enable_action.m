function mode = enable_action(obj)
%UIVIDEOVIEWER/ENABLE_ACTION   (protected) Set controls according to the new Enable state
%   MODE = UIVIDEOVIEWER(OBJ) is called when OBJ.Enable is changed. The
%   function returns the uint8 MODE indicating the new state:
%
%      0 - 'on'
%      1 - 'off'
%      2 - 'inactive'
%
%   MODE may be useful for an overriding subclass ENABLE_ACTION
%   functions.

% call superclass' method
mode = obj.enable_action@uipanelex();

% stop video if disabled while it is playing
if mode>0 && obj.isplaying()
   obj.stop();
end

if mode==1
   % gray out image
   I = get(obj.im,'CData');
   if isempty(I)
      Igo = I;
   else
      Igo = repmat(0.5+0.5*double(rgb2gray(I))/255,[1 1 3]);
   end
   set(obj.im,'CData',Igo,'UserData',I);
   
   % gray out counter
   txtcolor = get(obj.tx,'Color');
   set(obj.tx,'Color',0.5+0.5*rgb2gray(txtcolor),'UserData',txtcolor);
else
   % restore image
   I = get(obj.im,'UserData');
   if ~isempty(I)
      set(obj.im,'CData',I,'UserData',[]);
   end
   
   % restore counter color
   txtcolor = get(obj.tx,'UserData');
   if ~isempty(txtcolor)
      set(obj.tx,'Color',txtcolor,'UserData',[]);
   end
end
