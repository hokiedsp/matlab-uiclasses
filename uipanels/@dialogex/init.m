function init(obj)
%DIALOGEX/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@uipanelautoresize();

obj.btnvis    = cell(3,1);
obj.btnena    = cell(3,1);
obj.btnlabels = cell(3,1); [obj.btnlabels{:}] = deal('');
obj.btnclose = false(3,1);

obj.crfmode = hgpropmode;
obj.wkpfmode = hgpropmode;
obj.propsync = hgpropsync([2 1]); % ['color';'buttondownfcn']

obj.pnButtonBox = uiflowgridcontainer([],'GridSize',[1 3],'AutoDetach','on',...
   'VerticalAlignment','bottom','EliminateEmptySpace','on');

obj.propopts.AutoLayout.default = 'on';
obj.propopts.DefaultBtn = struct(...
   'StringOptions',{{'none','ok','cancel','apply'}},...
   'Default','ok');
obj.propopts.CloseRequestFcnMode = struct(...
   'StringOptions',{{'auto' 'manual'}});
obj.propopts.WindowKeyPressFcnMode = struct(...
   'StringOptions',{{'auto' 'manual'}});
obj.propopts.ButtonBoxAlignment = struct(...
   'StringOptions',{{'left' 'center' 'right'}},...
   'Default','right');
obj.propopts.ButtonOrder = struct(...
   'StringOptions',{{'okcancelapply','okapplycancel','applyokcancel'}},...
   'Default','okcancelapply');
obj.propopts.OkBtn = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','on');
obj.propopts.OkBtnLabel = struct(...
   'OtherTypeValidator',{{{'char'},{'row'}}},...
   'Default','OK');
obj.propopts.OkBtnCloseDlg = struct(...
   'StringOptions',{{'on' 'off'}},...
   'Default','on');
obj.propopts.CancelBtn = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','on');
obj.propopts.CancelBtnLabel = struct(...
   'OtherTypeValidator',{{{'char'},{'row'}}},...
   'Default','Cancel');
obj.propopts.CancelBtnCloseDlg = struct(...
   'StringOptions',{{'on' 'off'}},...
   'Default','on');
obj.propopts.ApplyBtn = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','off');
obj.propopts.ApplyBtnLabel = struct(...
   'OtherTypeValidator',{{{'char'},{'row'}}},...
   'Default','Apply');
obj.propopts.ApplyBtnCloseDlg = struct(...
   'StringOptions',{{'on' 'off'}},...
   'Default','off');
obj.propopts.ContentPanel = struct();
obj.propopts.BeingClosed = struct(...
   'StringOptions',{{'on' 'off'}});

obj.sortpropopts([],false,false,true,true);
