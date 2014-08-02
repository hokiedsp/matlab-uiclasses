function set_btn(obj,I,val)
%DIALOGEX/SET_BTN   Set button visible/enable config
%   SET_BTN(OBJ,I,VAL)
%      I: 1-OK, 2-Cancel, 3-Apply
%      VAL: {'on' 'inactive' 'disable' 'off'}
%      vis   'on' 'on'       'on'      'off'
%      ena   'on' 'inactive' 'off'     'off'

if strcmp(val,'off')
   obj.btnvis{I} = val;
else
   obj.btnvis{I} = 'on';
end
if strcmp(val,'disable')
   obj.btnena{I} = 'off';
else
   obj.btnena{I} = val;
end

% apply the change if dialog is present
obj.format_buttonbox();
obj.layout();
