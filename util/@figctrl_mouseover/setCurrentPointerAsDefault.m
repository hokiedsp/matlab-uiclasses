function setCurrentPointerAsDefault(obj)
%FIGCTRL_MOUSEOVER/SETCURRENTPOINTERASDEFAULT   Set current mouse pointer as default
%   SETCURRENTPOINTERASDEFAULT(OBJ) saves the current pointer
%   properties of the attached figure to be used when mouse
%   pointer is over the figure. If a mouse over callback modifies
%   the mouse pointer, the pointer reverts to the default mouse
%   pointer when mouse is off of the object.
%
%   See also: FIGCTRL_MOUSEOVER, FIGCTRL_MOUSEOVER/ADDMOUSEOVERCALLBACK,
%   FIGCTRL_MOUSEOVER/REMOVEMOUSEOVERCALLBAC.

propnames = {'Pointer','PointerShapeCData','PointerShapeHotSpot'};
for k = 1:numel(obj)
   fig = obj(k).wbmf_mode.GraphicsHandle;
   if strcmp(get(fig,'Pointer'),'custom')
      I = 1:3;
   else
      I = [1 3];
   end
   obj(k).ptrstyle = [propnames(I);get(fig,propnames(I))];
end
