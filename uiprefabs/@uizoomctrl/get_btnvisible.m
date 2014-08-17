function val = get_btnvisible(obj,type)
%UIZOOMCTRL/GET_BTNVISIBLE   Gets a button's visible property
%   VAL = GET_BTNVISIBLE(OBJ,TYPE)

pname = {'PointVisible','ZoomInVisible','ZoomOutVisible','PanVisible'};

if ~isempty(obj.btns) && strcmp(get(obj.btns(type),'Visible'),'on');
   val = get(obj.jbtns(type),'Enabled');
   if val
      val = 1;
   else
      val = 3;
   end
else
   val = 4;
end

val = obj.propopts.(pname{type}).StringOptions{val};
