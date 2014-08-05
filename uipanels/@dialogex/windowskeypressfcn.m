function windowskeypressfcn(obj,h,event)

if isempty(event.Key), return; end

switch(event.Key)
   case {'return','space'}
      % if current focus is on a edit uicontrol, ignore space key and also
      % return key if multi-line edit
      I = obj.default_mode-1;
      o = get(h,'CurrentObject');
      if obj.default_mode==0 || ~isempty(o) && strcmp(get(o,'Type'),'uicontrol') ...
            && strcmp(get(o,'Style'),'edit') ...
            && (event.Key(1)=='s' || (event.Key(1)=='r' && (get(o,'Max')-get(o,'Min'))>1))
         return;
      end
      
      % perform button callback only if the actual button is visible and enabled
      if ~(strcmp(obj.btnvis{I},'on') && strcmp(obj.btnena{I},'on'))
         return;
      end
      
      % perform the callback of the default button
      obj.btncallback();
      
   case {'escape'}
      closereq % cancel
   otherwise
      if isequal(event.Key,'c') && strcmp(event.Modifier,'control')
         closereq;
%       elseif ~ismcc() && ~strcmp(get(h,'WindowStyle'),'modal') ...
%             && ~any(strcmp(event.Key,{'tab','alt','control','shift'}))
%          % focus back to the commandwindow if current focus is not on a uicontrol
%          o = get(h,'CurrentObject');
%          if isempty(event.Modifier) && (isempty(o)||~strcmp(get(o,'Type'),'uicontrol'))
%             commandwindow 
%          end
      end
end
