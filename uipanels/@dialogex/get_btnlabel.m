function val = get_btnlabel(obj,I)
%DIALOGEX/GET_BTNLABEL   Get dialog button label
%   VAL = GET_BTNLABEL(OBJ,I)
%      I: 1-OK, 2-Cancel, 3-Apply

val = obj.btnlabels{I};
