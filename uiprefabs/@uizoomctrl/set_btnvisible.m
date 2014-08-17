function set_btnvisible(obj,type,val)
%UIZOOMCTRL/SET_BTNVISIBLE   Gets a button's visible property
%   SET_BTNVISIBLE(OBJ,TYPE,VAL)
%
% {1'on' 2'inactive' 3'disable' 4'off'}

pname = {'PointVisible','ZoomInVisible','ZoomOutVisible','PanVisible'};
[~,val] = obj.validateproperty(pname{type},val);


if val<4
   vis = 'on';
   ena = false;
   
   switch obj.mode
      case 2 % 'disable'
         ena = false;
      case 3 % 'inactive'
         %ena = 'inactive';
         ena = false;
      case 4 % 'on'
         ena = true;
   end
else
   vis = 'off';
   ena = false;
end

if isempty(obj.btns), return; end % not drawn yet

% save current visibility condition
vis_pre = get(obj.btns(type),'Visible');

set(obj.btns(type),'Visible',vis);
obj.jbtns(type).setEnabled(ena);

% if visibility changed, re-layout buttons
if ~strcmp(vis_pre,vis)
   obj.layout_panel();
end

% if enable is not on, check mode to be on enabled one
if obj.mode==idx && ~ena %~strcmp(ena,'on')
   if obj.unsel
      newmode = 0;
   else
      I = find(arrayfun(@(j)j.getEnabled));%   find(strcmp(get(obj.btns,'Enable'),'on'));
      if isempty(I)
         newmode = 0;
      else
         [~,i] = min(abs(I-idx));
         newmode = I(i);
      end
   end
   obj.modechange(newmode);
end
