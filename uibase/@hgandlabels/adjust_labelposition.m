function adjust_labelposition(obj,type,adjustgrid)
%HGANDLABELS/ADJUST_LABELPOSITION   Adjust label position according to its extent
%   ADJUST_LABELPOSITION(OBJ,TYPE)

if adjustgrid
   obj.update_gridlims(); % adjust_labelposiiton will be called within
else
   if showlabels(1)
      if obj.loc_lead==1 % left
         posl(1) = 1;
         posl(3) = w(1,1);
         posl(4) = h(1,3);
         switch obj.valign_lead
            case 1 % bottom
               posl(2) = y0(2);
            case 2 % middle
               posl(2) = y0(2) + h(3)/2 - posl(4)/2;
            case 3 % right
               posl(2) = y0(2) + h(3) - posl(4);
         end
      else % top
         switch obj.halign_lead
            case 1 % left
               posl(1,1) = x0(2);
            case 2 % center
               posl(1,1) = x0(2) + w(3)/2 - posl(1,3)/2;
            case 3 % right
               posl(1,1) = x0(2) + w(3) - posl(1,3);
         end
         switch obj.valign_lead
            case 1 % bottom
               posl(1,2) = y0(4);
            case 2 % middle
               posl(1,2) = y0(4) - posl(1,4)/2;
            case 3 % top
               posl(1,2) = y0(4) - posl(1,4);
         end
      end
      obj.set_labelposition(1,posl);
   end
   
   
   pos = get(obj.hlabels(type),'Position');
   ext = obj.get_labelextent(type);
   
   obj.halign_lead
   
   pos([3 4]) = ext([3 4]);
   
   
   
   set(obj.hlabels(type),'Position',pos);
end
