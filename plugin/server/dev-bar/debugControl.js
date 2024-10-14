pdt.debugControl = (function () {
    "use strict";

    function getViewDebugLink() {
        var lPath = pdt.getApexPath();

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

    function activateOldSchoolDebug() {

        var toggleDebugPdtIcon = 'icon-toggle-off';
        var debugToggleOption = 'YES';
        if ( pdt.pretiusContentDevBar.isDebugMode() ) {
            debugToggleOption = 'NO';
            toggleDebugPdtIcon = 'icon-toggle-on';
        }

        // Add View Debug
        $('#apexDevToolbarSession').parent().after(
            pdt.htmlDecode(apex.lang.formatNoEscape(
                '<li><button id="apexDevViewDebugPdt" type="button" class="a-Button a-Button--devToolbar" title="View Debug" aria-label="Vars" data-link=""> ' +
                '%0 <span class="a-DevToolbar-buttonLabel">View Debug</span> ' +
                '</button></li>',
                '<span class="fa fa-box-arrow-in-ne" aria-hidden="true"></span>'
            ))
        );

        var h = document.getElementById("apexDevViewDebugPdt");
        if (h) {
            h.addEventListener("click", function (event) {
                // parent.$("#apexDevToolbarDebugMenu").menu("instance").options.items[1].action();
                parent.$("#apexDevToolbarDebugMenu")?.menu("instance")?.options?.items?.[1]?.action?.();
            }, true);
        }

        // Add Debug
        $('#apexDevViewDebugPdt').parent().after(
            pdt.htmlDecode(apex.lang.formatNoEscape(
                '<li><button id="apexDevDebugPdt" type="button" class="a-Button a-Button--devToolbar" title="Debug" aria-label="Vars" data-link=""> ' +
                '%0 <span class="a-DevToolbar-buttonLabel">Debug</span><span class="a-DevToolbar-buttonToggle a-Icon %1" aria-hidden="true"></span>' +
                '</button></li>',
                '<span class="fa fa-bug" aria-hidden="true"></span>',
                toggleDebugPdtIcon
            ))
        );

        var h = document.getElementById("apexDevDebugPdt");
        if (h) {
            h.addEventListener("click", function (event) {
                parent.$("#apexDevToolbarDebugMenu")?.menu("instance")?.options?.items?.[0]?.menu?.items?.[0]?.set?.(debugToggleOption);
            }, true);
        }

       // Hide Devbar Debug
       $('#apexDevToolbarDebug').closest('li').addClass('u-hidden');       

    }

    return {
        activateOldSchoolDebug: activateOldSchoolDebug,
        activateDebugControl: activateDebugControl,
        getViewDebugLink: getViewDebugLink
    };
})();
