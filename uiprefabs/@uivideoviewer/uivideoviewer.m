classdef uivideoviewer < uipanelex
%UIVIDEOVIEWER   Interactive axes to playback video
%   UIVIDEOVIEWER turns an axes HG object into a video playback screen.
%
%   UIVIDEOVIEWER inherits and extends Enable property from its superclass,
%   HGENABLE. It adds a mechanism to control Enable properties of all child
%   objects. When UIVIDEOVIEWER's Enable is 'on', its child objects own Enable
%   property value is reflected in their appearances. If UIVIDEOVIEWER's Enable
%   is either 'off' or 'inactive', the child object appearance follows the
%   panel's Enable value; however, its actual Enable value remains that of
%   itself.
%
%   UIVIDEOVIEWER properties.
%      AutoDetach       - Simultaneous deletion of HG object
%      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
%                         if panel content has changed.
%      Enable           - Enable or disable the panel and its contents
%      EnableMonitoring - [{'on'}|'off'] to enable monitoring of panel
%                         descendents
%      Extent           - (Read-only) tightest position rectangel encompassing all Children
%      HGDetachable     - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle   - Attached HG object handle
%
%   UIVIDEOVIEWER methods:
%   UIVIDEOVIEWER object construction:
%      @UIVIDEOVIEWER/UIVIDEOVIEWER   - Construct UIVIDEOVIEWER object.
%      delete                 - Delete UIVIDEOVIEWER object.
%
%   HG Object Association:
%      attach                 - Attach HG panel-type object.
%      detach                 - Detach HG object.
%      isattached             - True if HG object is attached.
%
%   HG Object Control:
%      enable               - Enable the panel content
%      disable              - Disable the panel content
%      inactivate           - Inactivate (visually on, functionally off)
%                             the panel content.
%
%   Getting and setting parameters:
%      get              - Get value of UIVIDEOVIEWER object property.
%      set              - Set value of UIVIDEOVIEWER object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by UIVIDEOVIEWER


   methods (Static=true,Access=protected)
      function types = supportedtypes % supported HG object types
         types = {'axes'};
      end
   end
   events
      FrameChanged  % notified when displayed frame is changed during playback
      EndOfVideo    % notified when playback reached the end of the video
   end

   properties
      PlaybackRange % 'all'|[start end]   1-base frame indices to specify playback frame range
   end
   properties (Constant,Access=protected)
      Nreadmax = 256 % maximum number of frames to read at once
   end
   properties (Dependent=true, GetAccess=public, SetAccess=private)
      % VideoReader properties
      VideoReader
      VideoDuration
      VideoName
      VideoPath
      Visible
      BitsPerPixel
      Height
      NumberOfFrames
      VideoFormat
      Width
   end
   properties (Dependent=true)
      CurrentFrame
      FrameRate
      FrameRateMode % {'auto'}|'manual'
      Repeat      % 'on'|'off'
      AutoPlay    % 'on'|{'off'}
      AutoRewind  % 'on'|'off'
      AutoUnloadVideoReader  % 'on'|'off' Destroys its VideoReader object when video file is closed
      
      % Frame Counter Text Property
      CounterLocation % [none|north|south|east|west|northeast|northwest|{southeast}|southwest]
      CounterFormat % '%f' (%f-placeholder for frame #, %s-second, %m-minutes, %h-hours)
      CounterFrameRate % ['video'|positive scalar]
      CounterColor
      CounterFontName
      CounterFontSize
      CounterFontWeight
   end
   properties (Dependent=true, SetAccess=private, GetAccess=public)
      Running % 'on'|'off'
   end
   properties (Access=protected)
      autoplay
      autounload
      fsauto % FrameRateMode: true to set according to the video framerate
      pbrng % actual PlaybackRange
      txoffset % frame counter offset (1=zero-base frame index, maybe altered in a derived class)
   end
   properties (Access=private)
      repeat
      rewind

      Tmin   % minimum frame period allowed
      Qdec   % frame downsampling factor
      dsonly % true to downsample only (no averaging of frames)
      
      txloc %0:northeast 1:north 2:northwest 3:east 4:none 5:west
            %6:southeast 7:south 8:southwest
      txformat
      txmode % 0:f, 1:f&s, 2:f,s,&m, 3:all 4 fields
      txfmtfcn
      txfs
      
      vr  % video reader object
      tmr % timer object
      tmr_skp % true to skip timer function

      im % image handle
      tx % text handle (for frame counter)
   end
   properties (SetAccess=private,GetAccess=protected)
      n   % frame index
      nbuf % [start end] frame indices of loaded frames
      framedata % saved image of the n-th frame
   end
   methods
      open(obj,filename)
      close(obj)
      play(obj)
      stop(obj)
      
      goto(obj,frm)
      
      inc(obj,inc)
      dec(obj,dec)

      function tf = isopen(obj)
         tf = ~isempty(obj.vr);
      end
      function tf = isplaying(obj)
         val = obj.tmr.Running;
         tf = val(2)=='n'; % running if 'on'
      end
      
      function obj = uivideoviewer(varargin)
         %UIVIDEOVIEWER/UIVIDEOVIEWER   Construct UIVIDEOVIEWER object.
         %
         %   UIVIDEOVIEWER creates a scalar UIVIDEOVIEWER object. A new
         %   uicontainer object is also created on the current figure and attached
         %   to the UIVIDEOVIEWER object.
         %
         %   UIVIDEOVIEWER(N) creates an N-by-N matrix of UIVIDEOVIEWER
         %   objects
         %
         %   UIVIDEOVIEWER(M,N) creeates an M-by-N matrix of UIVIDEOVIEWER
         %   objects
         %
         %   UIVIDEOVIEWER(M,N,P,...) or UIVIDEOVIEWER([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UIVIDEOVIEWER objects.
         %
         %   UIVIDEOVIEWER(SIZE(A)) creates UIVIDEOVIEWER objects with the
         %   same size as A.
         %
         %   UIVIDEOVIEWER(...,TYPE) uses a different type of container. TYPE may
         %   be 'detached' if not desired to have an HG object pre-attached or a
         %   name of any valid function which return an HG object with a "Children"
         %   property; for instance, it could be 'figure', 'uipanel', 'uicontainer',
         %   'uiflowcontainer', 'uigridcontainer', 'uitabgroup', and 'uitab'.
         %
         %   UIVIDEOVIEWER(H) creates UIVIDEOVIEWER objects for the
         %   uipanel objects given in H and the created object has the same
         %   dimension as H.
         %
         %   UIVIDEOVIEWER(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIVIDEOVIEWER objects. All
         %   objects are set to the same property values.
         %
         %   UIVIDEOVIEWER(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = uivideoviewer.autoattach(mfilename,@axes,{'axes'},varargin);
         obj = obj@uipanelex(varargin{:});
         
      end
      
      function delete(obj) % close database connection and delete the panel
         try
            close(obj);
            delete(obj.tmr);
         catch
         end
      end
      
   end
   methods (Access=protected)
      init(obj)
      populate_panel(obj,h)
      
      openvideo(obj,filename)
      closevideo(obj)

      n = updateframe(obj,frm) % update displayed frame
      setframerate(obj,fs) % set playback framerate
      setplaybackrange(obj,val) % set playback range
      
      set_txloc(obj,newtxloc) % set CounterLocation property
      setcounterformat(obj,val) % set CounterFormat property
      
      val = getcurrentframe(obj)
      setcurrentframe(obj,varargin) % display specific frame

      % overriding methods
      mode = enable_action(obj)
      
      val = get_visible(obj)  % get HG visibility (known attached) 
      set_visible(obj,val)    % set HG visibility (known attached)
   end
   methods (Access=private)
      timerfcn(obj) % timer callback
   end
   
   methods
      %--------------------------------------------------------------------
      function val = get.FrameRateMode(obj)
         val = obj.propopts.FrameRateMode.StringOptions{2-obj.fsauto};
      end
      function set.FrameRateMode(obj,val)
         [~,val] = obj.validateproperty('FrameRateMode',val);
         obj.setframerate(logical(2-val));
      end
      %--------------------------------------------------------------------
      function val = get.FrameRate(obj)
         if obj.fsauto && ~obj.isopen(), val = [];
         else                            val = obj.Qdec/obj.tmr.Period;
         end
      end
      function set.FrameRate(obj,val)
         if isempty(val) % if empty, change FrameRateMode back to 'auto'
            obj.setframerate(true);
         else
            obj.validateproperty('FrameRate',val);
            obj.setframerate(val);
         end
      end
      %--------------------------------------------------------------------
      function set.PlaybackRange(obj,val)
         obj.validateproperty('PlaybackRange',val);
         obj.PlaybackRange = val;
         setplaybackrange(obj,val);
      end
      %--------------------------------------------------------------------
      function val = get.CurrentFrame(obj)
         if isempty(obj.vr)
            val = [];
         else
            val = obj.getcurrentframe();
         end
      end
      function set.CurrentFrame(obj,val)
         if isempty(obj.vr)
            error('CurrentFrame cannot set when no video is loaded.');
         end
         obj.validateproperty('CurrentFrame',val);
         
         % if playback range is specified, CurrentFrame must be within
         obj.setcurrentframe(val);
      end
      %--------------------------------------------------------------------
      function val = get.Repeat(obj)
         val = obj.propopts.Repeat.StringOptions{2-obj.repeat};
      end
      function set.Repeat(obj,val)
         [~,val] = obj.validateproperty('Repeat',val);
         obj.repeat = logical(2-val);
      end
      %--------------------------------------------------------------------
      function val =get.AutoPlay(obj)
         val = obj.propopts.AutoPlay.StringOptions{2-obj.autoplay};
      end
      function set.AutoPlay(obj,val)
         [~,val] = obj.validateproperty('AutoPlay',val);
         obj.autoplay = logical(2-val);
      end
      %--------------------------------------------------------------------
      function val = get.AutoRewind(obj)
         val = obj.propopts.AutoRewind.StringOptions{2-obj.rewind};
      end
      function set.AutoRewind(obj,val)
         [~,val] = obj.validateproperty('AutoRewind',val);
         obj.rewind = logical(2-val);
      end
      %--------------------------------------------------------------------
      % Timer state
      function val = get.Running(obj)
         val = obj.tmr.Running;
      end
      %--------------------------------------------------------------------
      % Video Info
      function val = get.BitsPerPixel(obj)
         if isempty(obj.vr)
            val = [];
         else
            val = obj.vr.BitsPerPixel;
         end
      end
      function val = get.VideoDuration(obj)
         if isempty(obj.vr)
            val = [];
         else
            val = obj.vr.Duration;
         end
      end
      function val = get.Height(obj)
         if isempty(obj.vr)
            val = [];
         else
            val = obj.vr.Height;
         end
      end
      function val = get.VideoName(obj)
         if isempty(obj.vr)
            val = '';
         else
            val = obj.vr.Name;
         end
      end
      function val = get.NumberOfFrames(obj)
         if isempty(obj.vr)
            val = [];
         else
            val = obj.vr.NumberOfFrames;
         end
      end
      
      function val = get.VideoReader(obj)
         val = obj.vr;
      end
      function set.VideoReader(obj,val)
         obj.open(val);
      end
      
      function val = get.VideoPath(obj)
         if isempty(obj.vr)
            val = '';
         else
            val = get(obj.vr,'Path');
         end
      end
      function val = get.Width(obj)
         if isempty(obj.vr)
            val = [];
         else
            val = get(obj.vr,'Width');
         end
      end
      function val = get.VideoFormat(obj)
         if isempty(obj.vr)
            val = '';
         else
            val = get(obj.vr,'VideoFormat');
         end
      end
      %--------------------------------------------------------------------
      
      %%%%%%%%%%%%%%%%%%
      %%% COUNTER Text Propertes
      function val = get.CounterLocation(obj)
         index = obj.propopts.CounterLocation.ToIndex(obj.txloc+1);
         val = obj.propopts.CounterLocation.StringOptions{index};
      end
      function set.CounterLocation(obj,val)
         [~,val] = obj.validateproperty('CounterLocation',val);
         obj.set_txloc(obj.propopts.CounterLocation.ToCode(val));
      end
      %--------------------------------------------------------------------
      function val = get.CounterFormat(obj)
         % '%f' (%f-placeholder for frame #, %s-second, %m-minutes, %h-hours)
         val = obj.txformat;
      end
      function set.CounterFormat(obj,val)
         obj.validateproperty('CounterFormat',val);
         obj.setcounterformat(val);
      end
      %--------------------------------------------------------------------
      function val = get.CounterFrameRate(obj)
         % ['video'|positive scalar]
         if obj.txfs>0
            val = obj.txfs;
         else
            val = obj.propopts.CounterFrameRate.StringOptions{1};
         end
      end
      function set.CounterFrameRate(obj,val)
         obj.validateproperty('CounterFrameRate',val);
         if ischar(val)
            obj.txfs = 0;
         else
            obj.txfs = val;
         end
         
         % update frame
         if obj.isopen()
            obj.setcurrentframe();
         end
      end
      %--------------------------------------------------------------------
      function val = get.CounterColor(obj)
         val = get(obj.tx,'Color');
      end
      function set.CounterColor(obj,val)
         try
            set(obj.tx,'Color',val);
         catch ME
            ME.throwAsCaller();
         end
      end
      %--------------------------------------------------------------------
      function val = get.CounterFontName(obj)
         val = get(obj.tx,'FontName');
      end
      function set.CounterFontName(obj,val)
         try
            set(obj.tx,'FontName',val);
         catch ME
            ME.throwAsCaller();
         end
      end
      %--------------------------------------------------------------------
      function val = get.CounterFontSize(obj)
         val = get(obj.tx,'FontSize');
      end
      function set.CounterFontSize(obj,val)
         try
            set(obj.tx,'FontSize',val);
         catch ME
            ME.throwAsCaller();
         end
      end
      %--------------------------------------------------------------------
      function val = get.CounterFontWeight(obj)
         val = get(obj.tx,'FontWeight');
      end
      function set.CounterFontWeight(obj,val)
         try
            set(obj.tx,'FontWeight',val);
         catch ME
            ME.throwAsCaller();
         end
      end
      %--------------------------------------------------------------------
      function val = get.AutoUnloadVideoReader(obj)
         val = obj.propopts.AutoUnloadVideoReader.StringOptions{obj.autounload+1};
      end
      function set.AutoUnloadVideoReader(obj,val)
         [~,val] = obj.validateproperty('AutoUnloadVideoReader',val);
         obj.autounload = logical(val-1);
      end
      %--------------------------------------------------------------------
      function val = get.Visible(obj)
         if obj.isattached()
            val = obj.get_visible();
         else
            val = '';
         end
      end
      function set.Visible(obj,val)
         if obj.isattached()
            [~,val] = obj.validateproperty('Visible',val);
            obj.set_visible(val);
         elseif ~isemtpy(val)
            error('Visible property cannot be set if OBJ is not attached.');
         end
      end
   end
end
