function set_btnclose(obj,I,val)
%DIALOGEX/SET_BTNCLOSE   Get XxxBtnCloseDlg value index
%   SET_BTNCLOSE(OBJ,I,VAL)
%      I: 1-OK, 2-Cancel, 3-Apply

obj.btnclose(I) = 2-val;
