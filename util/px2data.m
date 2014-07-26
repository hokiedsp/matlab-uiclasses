function varargout = px2data(varargin)
%PX2DATA   Unit conversion from screen px to x & y data units
%   [Dx,Dy] = PX2DATA(Dpx) converts pixel distances, given in length-N vector
%   Dpx, to the equivalent distances in the units of x and y axes of the
%   current axes.
%
%   Cxy = PX2DATA(Cpx) converts the N-by-2 pixel coordinate matrix Cxy to
%   the coordinate matrix Cxy in the data units of the current axes.
%
%   [X,Y] = PX2DATA(Xpx,Ypx) is an alternative syntax for the coordinate
%   conversion, where both input and output arguments are length-N vectors.
%
%   PX2DATA(AX,...) performs the conversion in the axes with handle AX.
%
%   See also: getptrloc.

narginchk(1,3);
[ax,data,mode,dims,msg] = parseinput(nargin,varargin);
error(msg);

% get axes conversion factors
[axpos0,x2px,y2px,xlim,ylim] = data2pxratio(ax);

if mode==1 % distance conversion
   % convert
   varargout{1} = data*x2px;
   if nargout>1, varargout{2} = data*y2px; end
else
   % move pointer coordinate origin from the screen origin to the axes origin
   data(:) = bsxfun(@minus,data,axpos0);
   
   % convert x to data unit
   data(:,1) = data(:,1)*x2px;
   
   % check for axes direction
   if strcmp(get(ax,'XDir'),'normal')
      data(:,1) = data(:,1) + xlim(1);
   else
      data(:,1) = xlim(2) - data(:,1);
   end
   
   if mode==2 || nargout>1
      % convert y to data unit
      data(:,2) = data(:,2)*y2px;
      if strcmp(get(ax,'YDir'),'normal')
         data(:,2) = data(:,2) + ylim(1);
      else
         data(:,2) = ylim(2) - data(:,2);
      end
   end
   
   if mode==3
      varargout{1} = reshape(data(:,1),dims);
      varargout{2} = reshape(data(:,2),dims);
   else
      varargout{1} = data;
   end
   
end


end

function [ax,data,mode,dims,msg] = parseinput(n,argin) % parse input arguments

ax = [];
data = [];
mode = 0;
dims = [];
msg = '';

I0 = 1;
if n==3
   if ~ishghandle(argin{1}) || ~strcmp(get(argin{1},'Type'),'axes')
      msg = 'AX is not a valid axes handle.';
      return;
   end
   ax = argin{1};
   I0 = 2;
   n = n - 1;
elseif (n>1 && ishghandle(argin{1}) && strcmp(get(argin{1},'Type'),'axes'))
   ax = argin{1};
   I0 = 2;
   n = n - 1;
else
   ax = gca;
end

switch n
   case 1
      data = argin{I0};
      dims = size(argin{I0});
      if ismatrix(argin{I0}) && size(argin{I0},2)==2 % coordinate conversion
         mode = 2;
         dims(2) = 1;
      else % distance conversion
         mode = 1;
      end
   case 2 % coordinate conversion
      dims = size(argin{I0}); % output dimension
      if ndims(argin{I0})~=ndims(argin{I0+1}) || any(dims~=size(argin{I0+1}))
         msg = 'Xpx and Ypx must have the same dimension.';
      end
      mode = 3;
      data = [argin{I0}(:) argin{I0+1}(:)]; % columnize + concatenate
end
end

% Copyright (c) 2011, Takeshi Ikuma {tikuma_at_hotmail_dot_com}
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
