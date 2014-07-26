function jtable = get_javatablehandle(htable)

hJScroll = findjobj(htable); % findjobj is from file exchange
jtable = hJScroll.getViewport.getView; % get the table component within the scroll object
