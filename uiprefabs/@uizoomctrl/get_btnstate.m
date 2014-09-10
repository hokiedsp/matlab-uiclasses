function state = get_btnstate(obj,name)
%UIZOOMCTRL/GET_BTNSTATE
%   STATE = GET_BTNSTATE(OBJ,NAME)

state = obj.jbtns.name.isSelected();
