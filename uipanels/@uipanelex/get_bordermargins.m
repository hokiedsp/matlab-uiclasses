function bmargin = get_bordermargins(h)
%UIPANELEX.GET_BORDERMARGINS   return the panel border margins
%   MARGIN GET_BORDERMARGINS(H) is a static utility function, returning the
%   margins [left right bottom top] of the panel border. If H is not
%   uipanel-based object, all margins are 0. If H is a uipanel-based
%   object, margins are computed from its BorderWidth, BorderType, 'Title',
%   and 'TitlePosition'.

bmargin = zeros(1,4);

try % get border properties if defined
   bt = get(h,'BorderType');
   if ~strcmp(bt,'none')
      bw = get(h,'BorderWidth');
      if any(strcmp(bt,{'etchedin','etchedout'}))
         bw = 2*bw;
      end
   end
   bmargin(:) = bw;
catch
end

% get the title uicontrol position
try
   s = warning('query','MATLAB:Uipanel:HiddenImplementation');
   warning('off','MATLAB:Uipanel:HiddenImplementation');
   ht = get(h,'TitleHandle');
   warning(s);
   str = get(ht,'String');
   if ~(isempty(str)||all(isspace(str)))
      ut = get(ht,'Units');
      set(ht,'Units','pixels');
      pt = get(ht,'Position');
      set(ht,'Units',ut);
      
      tp = get(h,'TitlePosition');
      if tp(end)=='p' % 'top'
         bmargin(4) = pt(4);
      else % 'bottom'
         bmargin(3) = pt(4);
      end
      
   end
catch % not uipanel based HG object
end
