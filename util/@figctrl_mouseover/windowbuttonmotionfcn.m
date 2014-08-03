function windowbuttonmotionfcn(obj,fig)
%FIGCTRL_MOUSEOVER/WINDOWBUTTONMOTIONFCN   Callback function
%   WINDOWBUTTONMOTIONFCN(OBJ) check if any of the HG object has been hit
%   by mouse pointer. If hit, the function fires the assigned callback of
%   the HG object.
%
%   This function is automatically attached to the figure when OBJ is
%   constructed if the windows window button motion callback is available.
%
%   See also FIGCTRL_MOUSEOVER.

% check if any of uiaxobj is hit

h = hittest(fig);

miss = isempty(h);
if ~miss
   I = find(obj.h==h,1); % only 1 can be hit at a time
end

if miss || isempty(I) % nothing hit
   if obj.hit>0 % previously hit
      obj.hit = 0;
      set(obj.hg,obj.ptrstyle{:}); % revert pointer style to the default
   end
else % obj.h(I) hit
   % set pointer style
   obj.hit = I; % record that

   % fire the callback function with current point
   obj.cbfcns{I}();
end
