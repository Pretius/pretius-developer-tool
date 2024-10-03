pdt.debugControl = (function () {
    "use strict";

    function getViewDebugLink() {
        var lPath;
  
        if ( pdt.opt.friendlyUrl === 'Yes') {
            lPath = apex.gPageContext$[0].baseURI;
        } else {
            lPath = new URL('.', window.location).href;
        }

        var url = lPath +
        'r/apex/app-builder/debug-message-data?' +
        'ir_application_id=[APP_ID]&' +
        'ir_page_id=[APP_PAGE_ID]&' +
        'f4000_flow_session=[SESSION_ID]&' +
        'fb_flow_id=[APP_ID]&' +
        'f4000_p34_page=[APP_PAGE_ID]&' +
        'clear=RIR,19&' +
        'session=[BUILDER_SESSION_ID]';
    
        // Get values from apex.env and other sources
        var appId = apex.env.APP_ID;
        var sessionId = apex.env.APP_SESSION;
        var pageId = apex.env.APP_PAGE_ID;
        var builderSessionId = pdt.pretiusToolbar.getBuilderSessionid();

        // Replace placeholders in URL
        var updatedUrl = url
            .replace(/\[APP_ID\]/g, appId)
            .replace(/\[SESSION_ID\]/g, sessionId)
            .replace(/\[APP_PAGE_ID\]/g, pageId)
            .replace(/\[BUILDER_SESSION_ID\]/g, builderSessionId);

        return updatedUrl;
    }
 
    function activateDebugControl() {        
        
        var menuItems = parent.$("#apexDevToolbarDebugMenu").menu("instance").options.items;
            
        // Find the first item with the label 'View Debug'
        var viewDebugItem = menuItems.find(function(item) {
            return item.label === 'View Debug';
        });

        var url = pdt.opt.debugPluginFiles +
                  'dev-bar/debugTakover.html?' + 
                  'pLocation=' + encodeURIComponent(pdt.opt.filePrefix ) + '&' +
                  'pViewDebugURL=' + encodeURIComponent( getViewDebugLink() )  + '&' +
                  'pDebugMode=' + pdt.pretiusContentDevBar.isDebugMode()
                  ;
        
        viewDebugItem.action = 
            function() {
                apex.navigation.popup({
                    url:    url,
                    name:   "view_debug", // allows to reuse same popup
                    width:  1024,
                    height: 768
                });
            };
        
    }

    return {
        activateDebugControl: activateDebugControl,
        getViewDebugLink: getViewDebugLink
    };
})();
