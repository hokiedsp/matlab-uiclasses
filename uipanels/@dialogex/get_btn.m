function val = get_btn(obj,I)
%DIALOGEX/GET_BTN   Get button visible/enable config
%   VAL = GET_BTN(OBJ,I)
%      I: 1-OK, 2-Cancel, 3-Apply
%      VAL: {'on' 'inactive' 'disable' 'off'}

val = obj.btnvis{I};
if val(2)=='n' % if 'on'
   val = obj.btnena{I};
end
