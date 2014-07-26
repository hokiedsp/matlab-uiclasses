function d_update(obj,I,ishg)
%UIPANELEX/D_UPDATE   descendent Enable property listener callback
%   D_UPDATE(OBJ,N,ISHG)

if ishg
   obj.d_hg_states{I} = get(obj.d_hgs(I),'Enable');
   obj.d_hg_listeners(I).Enabled = 'off';
   set(obj.d_hgs(I),'Enable',obj.Enable);
   obj.d_hg_listeners(I).Enabled = 'on';
else
   obj.d_hgw_states{I} = obj.d_hgws(I).Enable;
   obj.d_hgw_listeners(I).Enabled = false;
   obj.d_hgws(I).Enable = obj.Enable;
   obj.d_hgw_listeners(I).Enabled = true;
end
