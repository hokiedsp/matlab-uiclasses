function [axpos0,x2px,y2px,xlim,ylim] = data2pxratio(ax)
%DATA2PXRATIO   Get pixel to axis data unit conversion factors
%   [AxPos0,X2Px,Y2Px,XLim,YLim] = DATA2PXRATIO(AX) computes the location
%   of the lower left hand corner of the axis in pixels with respect to the
%   lower left hand corner of the figure, ratio of unit x-coordinate length
%   to number of pixels, X2Px, ratio fo the unit y-coodinate length to
%   number of pixels, Y2Px, and the axes position of AX. In addition, the
%   limits of x and y axes are returned in XLim and YLim.

if nargin<1, ax = gca; end

% get the axes position in pixels
units_bak = get(ax,'Units');  % save the original Units mode
set(ax,'Units','pixels');
axloc_px = get(ax,'Position');
set(ax,'Units',units_bak);    % reset to the original Units mode

% get axes location w.r.t. the figure (in case axes is not a direct child
% of figure)
axloc_px(1:2) = get_axoffset(get(ax,'Parent'),axloc_px(1:2));

darIsManual  = strcmp(get(ax, 'DataAspectRatioMode'),'manual');
pbarIsManual = strcmp(get(ax, 'PlotBoxAspectRatioMode'),'manual');
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
dx = diff(xlim);
dy = diff(ylim);

if darIsManual || pbarIsManual
   axisRatio = axloc_px(3)/axloc_px(4);
   
   if darIsManual
      dar = get(ax, 'DataAspectRatio');
      limDarRatio = (dx/dar(1))/(dy/dar(2));
      if limDarRatio > axisRatio
         ht = axloc_px(3)/limDarRatio;
         axloc_px(2) = (axloc_px(4) - ht)/2 + axloc_px(2);
         axloc_px(4) = ht;
      else
         wd = axloc_px(4) * limDarRatio;
         axloc_px(1) = (axloc_px(3) - wd)/2 + axloc_px(1);
         axloc_px(3) = wd;
      end
   else%if pbarIsManual
      pbar = get(ax, 'PlotBoxAspectRatio');
      pbarRatio = pbar(1)/pbar(2);
      if pbarRatio > axisRatio
         ht = axloc_px(3)/pbarRatio;
         axloc_px(2) = (axloc_px(4) - ht)/2 + axloc_px(2);
         axloc_px(4) = ht;
      else
         wd = axloc_px(4) * pbarRatio;
         axloc_px(1) = (axloc_px(3) - wd)/2 + axloc_px(1);
         axloc_px(3) = wd;
      end
   end
end

% origin of the axes in pixels
axpos0 = axloc_px(1:2);

% convert to data unit
x2px = dx/axloc_px(3);
y2px = dy/axloc_px(4);

end

function offset = get_axoffset(h,offset)

if strcmp(get(h,'Type'),'figure')
   return;
end

units_bak = get(h,'Units');  % save the original Units mode
set(h,'Units','pixels');
pos = get(h,'Position');
set(h,'Units',units_bak);    % reset to the original Units mode

offset = offset + pos([1 2]);

offset = get_axoffset(get(h,'Parent'),offset);

end

% Copyright (c) 2011, Takeshi Ikuma
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   * Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer.
%   * Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%   * Neither the names of its contributors may be used to endorse or
%     promote products derived from this software without specific prior
%     written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
