function val = get_btnclose(obj,I)
%DIALOGEX/GET_BTNCLOSE   Get XxxBtnCloseDlg value index
%   VAL = GET_BTNCLOSE(OBJ,I)
%      I: 1-OK, 2-Cancel, 3-Apply

val = 2-obj.btnclose(I);
