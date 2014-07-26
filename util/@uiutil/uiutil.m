classdef uiutil < handle
   %UIUTIL   Static utility functions for UI programming
   
   methods(Access=public,Static=true)
      icon = getDefaultToolbarIcon(filename,alpha_th)
      [y0,x0] = horizontal_layout(h,x0,y0,spc,valign)
      [x0,y0] = vertical_layout(h,x0,y0,spc,halign)
      jtable = get_javatablehandle(htable)
      psize = fitpanel2children(h,pad,dns)
      setFigureFocus(hFig)
      tf = isvisible(h) % checks if HG object is visible
      
      function filename = iconpath(filename)
         if exist(filename,'file')~=2
            iconpath = fullfile(fileparts(which(mfilename)),'icons',filename);
            if exist(iconpath,'file')==2
               filename = iconpath;
            elseif ~isdeployed()
               iconsdir = fullfile(matlabroot,'toolbox','matlab','icons');
               filename = fullfile(iconsdir,filename);
               if exist(filename,'file')~=2
                  if isdeployed
                     disp(filename)
                     dir(iconsdir)
                  end
                  error('File does not exist');
               end
            end
         end
      end
      
      function nop(varargin), end % empty function for callbacks
      
   end
end
