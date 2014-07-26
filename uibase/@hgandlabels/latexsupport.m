function latexsupport(obj,type,mode)
%HGANDLABELS/LATEXSUPPORT
%   LATEXSUPPORT(OBJ,TYPE,MODE)
%   TYPE: 1-leading, 2-trailing
%   MODE: 'tex','latex','none'

return % not enabled

obj.istex(type) = ~strcmp(mode,'none');

if ~any(obj.istex)
   % if no labels utilizes TeX/LaTeX, delete axes
   delete(obj.haxes);
   obj.haxes = [];
   obj.htexts = [];
elseif isempty(obj.haxes)
   % if needs TeX/LaTeX support, must have underlying axes object
   obj.haxes = axes('Parent',obj.hpanel,'Visible','off',...
      'ActivePositionProperty','position','Units','normalized','Position',[0 0 1 1]);
   obj.htexts = [
      text('Parent',obj.haxes,'Visible','off','Units','pixels',...
      'HorizontalAlignment','left','VerticalAlignment','bottom')
      text('Parent',obj.haxes,'Visible','off','Units','pixels',...
      'HorizontalAlignment','left','VerticalAlignment','bottom')];
end

if obj.istex(type)
   set(obj.hlabels(type),'Visible','off');
   set(obj.htexts(type),'Interpreter',mode,'Visible','on');
else
   set(obj.hlabels(type),'Visible','on');
   if ~isempty(obj.htexts)
      set(obj.htexts(type),'Visible','off');
   end
end

obj.update_gridlims();
