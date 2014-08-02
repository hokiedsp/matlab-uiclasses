function set_btnlabel(obj,I,val)
%DIALOGEX/SET_BTNLABEL   Set dialog button label
%   SET_BTNLABEL(OBJ,I,VAL)
%      I: 1-OK, 2-Cancel, 3-Apply

obj.btnlabels{I} = val;

if obj.isattached()
   set(hBtns(I),'String',val);
end

obj.format_buttonbox();
obj.layout_panel();
