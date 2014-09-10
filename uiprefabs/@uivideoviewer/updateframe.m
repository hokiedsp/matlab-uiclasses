function frm = updateframe(obj,frm0)
%UIVIDEOVIEWER/UPDATEFRAME   Update view to specified frame
%   UPDATEFRAME(OBJ,I) displays the I-th video frame of the video file. I
%   is a valid 1-based index. UPDATEFRAME also returns the frame index.

% get the frame range
if obj.isplaying() && obj.Qdec>1 % during playback with downsampling
   frm = [frm0 (frm0+obj.Qdec-1)];
else % single frame
   frm = frm0([1 1]);
end

% Read new data frames
if frm(1)>=obj.nbuf(1) && frm(end)<=obj.nbuf(end)
   % if the entire data is already available, no need to read
   frmdata = obj.framedata(:,:,:,frm-obj.nbuf(1)+1);
elseif frm(1)<obj.nbuf(1) || frm(end)>obj.nbuf(end)+obj.Nreadmax
   % requested earlier frames than the last read (slow)
   % or requested is way further out, just start over
   frmdata = obj.vr.read(frm);
   obj.nbuf = frm;
   obj.framedata = frmdata;
else
   % new frames w/in a reach of previous read
   nnew = [obj.nbuf(end)+1 frm(end)];
   frmdata = obj.vr.read(nnew);
   if frm(1)>obj.nbuf(end) % no overlap
      obj.framedata = frmdata;
      frmdata(:,:,:,1:(frm(1)-obj.nbuf(end)-1)) = [];
      obj.nbuf = nnew;
   else % overlapped
      % shift newly read frames to make room for the previously loaded frames
      k = nnew-(frm(1)-1);
      frmdata(:,:,:,k(1):k(2)) = frmdata;

      % copy previously loaded frames to the new buffer
      Nkeep = obj.nbuf(end)-frm(1)+1;
      src = [frm(1) obj.nbuf(end)] - (obj.nbuf(1)-1);
      frmdata(:,:,:,1:Nkeep) = obj.framedata(:,:,:,src(1):src(2));
      obj.framedata = frmdata;
      obj.nbuf = frm;
   end
end

% consolidate frames
if obj.isplaying() && ~obj.dsonly % decimate
   I = cast(mean(double(frmdata),4),class(frmdata));%#ok
else % downsampling only or is a still image
   I = frmdata(:,:,:,frm0(1)-frm(1)+1);
end
obj.n = frm0;

% display the frame
if size(I,3)==1 % if grayscale
   set(obj.im,'CData',I(:,:,[1 1 1]));
else
   set(obj.im,'CData',I);
end

% display the frame counter
f = frm0+obj.txoffset; % display zero based frame index
s = 0; m = 0; h = 0; 
if obj.txmode>1 % include seconds
   if obj.txfs>0
      s = f/obj.txfs;
   else
      s = f/obj.vr.FrameRate;
   end
   if obj.txmode>2 % include minutes
      m = floor(s/60);
      s = s-60*m;
      if obj.txmode>3 % include hours
         h = floor(m/60);
         m = m-60*h;
      end
   end      
end
set(obj.tx,'String',obj.txfmtfcn({f,s,m,h}));
