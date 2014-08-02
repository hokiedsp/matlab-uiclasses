function format_buttonbox(obj)
%DIALOGEX/FORMAT_BUTTONBOX
%   FORMAT_BUTTONBOX(OBJ)

if obj.isattached()
   
   set(obj.hBtns, {'Visible' 'Enable' 'String'},[obj.btnvis obj.btnena obj.btnlabels]);
   
   if all(strcmp(obj.btnvis,'off')) % no button visible
      set(obj.pnButtonBox,'Visible','off');
   else
      pos = max(cell2mat(get(obj.hBtns,'Extent')));
      
      obj.pnButtonBox.Margins = [1 0.75 1 0.45]*pos(4);
      obj.pnButtonBox.ElementSpacings = 0.8*pos(4);
      
      pos(3) = 2*pos(3);
      pos(4) = 1.2*pos(4);
      set(obj.hBtns,'Position',pos);
      
      I = strcmp(obj.btnvis,'on');
      obj.pnButtonBox.setElement(obj.hBtns(I),'WidthLimits',pos([3 3]),'HeightLimits',pos([4 4]));
      obj.pnButtonBox.setElement(obj.hBtns(~I),'WidthLimits',[eps eps],'HeightLimits',[eps eps]);

      % set the ElementsLocation
      subs = obj.pnButtonBox.ElementsLocation;
      switch obj.btnorder % 1'okcancelapply'},2'okapplycancel',3'applyokcancel']
         case 1, subs(:,2) = [1 2 3];
         case 2, subs(:,2) = [1 3 2];
         otherwise, subs(:,2) = [2 3 1];
      end
      obj.pnButtonBox.ElementsLocation = subs;
      
      obj.pnButtonBox.layout();
      set(obj.pnButtonBox,'Visible','on','Position',obj.pnButtonBox.Extent);
   end
end
