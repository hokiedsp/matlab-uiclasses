classdef hgwrapperlink < hgsetgetex
%HGWRAPPERLINK   To link HGWRAPPER objects
%   HGWRAPPERLINK implements a mechanism to link multiple HGWRAPPER
%   objects. HGWRAPPERLINK is intended to be inherited along with HGWRAPPER
%   (or its derived class):
%
%      classdef MyClass < HGWRAPPER & HGWRAPPERLINK
%
%   Otherwise, the linking mechanism will not function properly.
%
%   Only public entity of HGWRAPPERLINK is link() method and LinkedObjects
%   property. 
%
%
%   HGWRAPPERLINK properties.
%      LinkedObjects      - Simultaneous deletion of HG object [{'on'}|'off']
%
%   HGWRAPPERLINK methods:
%   HGWRAPPERLINK object construction:
%      @HGWRAPPERLINK/HGWRAPPERLINK - Construct HGWRAPPERLINK object.
%      delete                       - Delete HGWRAPPERLINK object.
%
%   Object Linking:
%      link - Link HG object.
%
%   Getting and setting parameters:
%      get              - Get value of HGWRAPPERLINK object property.
%      set              - Set value of HGWRAPPERLINK object property.
%
%   See also: hgwrapperlink/hgwrapperlink, hgwrapperlink/link, hgwrapper,
%   hgsetgetex, handle


   properties
      LinkedObjects % Array of linked objects (empty double if not linked)
   end
   properties (Access=protected)
      links       % array of linked objects (empty hgwrapper if not linked)
   end
   properties (Access=private)
      link_master % true if the object can lead or is leading the change 
                  % among linked objects
   end
   methods
      link(obj,opt) % link HGWRAPPER-based objects
      
      function obj = hgwrapperlink(varargin)
         %HGWRAPPERLINK/HGWRAPPERLINK   HGWRAPPERLINK constructor
         %   HGWRAPPERLINK - scalar object
         %
         %   HGWRAPPERLINK(H) creates HGWRAPPERLINK objects for the HG handle
         %   objects given in H and the created object has the same dimension as H.
         %
         %   HGWRAPPERLINK(N) creates an N-by-N matrix of detached HGWRAPPERLINK
         %   objects
         %
         %   HGWRAPPERLINK(M,N) creeates an M-by-N matrix of detached HGWRAPPERLINK
         %   objects
         %
         %   HGWRAPPERLINK(M,N,P,...) or HGWRAPPERLINK([M N P ....]) creates an
         %   M-by-N-by-P-by-... array of detached HGWRAPPERLINK objects.
         %
         %   HGWRAPPERLINK(SIZE(A)) creates detached HGWRAPPERLINK objects with the
         %   same size as A.
         %
         %   HGWRAPPERLINK(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created HGWRAPPERLINK objects. All objects
         %   are set to the same property values.
         %
         %   HGWRAPPERLINK(...,pn,pv) sets the named properties specified in the
         %   cell array of strings pn to the corresponding values in the cell array
         %   pv for all objects created .  The cell array pn must be 1-by-N, but the
         %   cell array pv can be M-by-N where M is equal to numel(OBJ) so that each
         %   object will be updated with a different set of values for the list of
         %   property names contained in pn.

         obj = obj@hgsetgetex(varargin{:});
      end
      
      function val = get.LinkedObjects(obj)
         if isempty(obj.links)
            val = [];
         else
            val = obj.links;
         end
      end
      
      function set.LinkedObjects(obj,val)
         obj.validatepropery('LinkedObjects',val);
         link([obj;val(:)]);
      end
   end
   
   methods (Access=protected)
      init(obj)
      tf = set_master_se(obj) % obj must be scalar (unchecked)
      clr_master_se(obj) % obj must be scalar (unchecked)
      tf = isslave_se(obj)    % true if obj is a slave
   end
end
