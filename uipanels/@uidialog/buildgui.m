function vis = buildgui(obj,argin)



[tf,Ivis] = ismember('visible',argin(1,:));
if tf
   vis = argin{2,Ivis};
   argin(2,Ivis) = 'off';
else
   vis = 'on';
end

obj.fig = dialog(argin{:},'Visible','off');

warn('MATLAB:hg:ColorSpec_None','off');
obj.pnCtrlPanel = uipanel('Parent',obj.fig,'Units','pixels','BorderType','none','BackgroundColor','none');
obj.pnButtonBox = uipanel('Parent',obj.fig,'Units','pixels','BorderType','none','BackgroundColor','none');
warn('MATLAB:hg:ColorSpec_None','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create OK & Cancel Buttons

obj.hOK = uicontrol(obj.pnButtonBox,'Style','pushbutton','String',obj.btnlabels{1});
setappdata(obj.hOK,'QuestDlgReturnName','OK');

obj.hApply = uicontrol(obj.pnButtonBox,'Style','pushbutton','String',obj.btnlabels{2});

obj.hCancel = uicontrol(obj.pnButtonBox,'Style','pushbutton','String',obj.btnlabels{3});
setappdata(obj.hCancel,'QuestDlgReturnName','Cancel');

btnsz = [85 24];
btnsep = 16;
x0 = SepV; y0 = SepV;

set(handles.hOK,'Position',[x0 y0 btnsz]);
x0 = x0 + btnsz(1) + btnsep;
set(handles.hCancel,'Position',[x0 y0 btnsz]);

x0 = x0 + btnsz(1) + SepV;
y0 = y0 + btnsz(2) + SepV;
set(handles.pnButtonBox,'Position',[SepV+100 SepV x0 y0]);

pos = cell2mat(get(get(handles.pnButtonBox,'Children'),'Position'));
psize = max(pos(:,1:2)+pos(:,3:4))+SepV;
set(handles.pnButtonBox,'Position',[SepV 200 psize],'UserData',psize); % 'UserData' to remember it as the minimum size allowed

y0 = uiutil.horizontal_layout(obj.hCopyVideo,SepV,SepV,[0 0],'middle');
