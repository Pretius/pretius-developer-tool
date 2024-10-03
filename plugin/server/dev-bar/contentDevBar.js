pdt.pretiusContentDevBar = (function () {
    "use strict";

    function spotlightOptions(pEventName) {
        // Start Spotlight Harness
        var pdtSpotOpt = {
            "dynamicActionId": pdt.opt.dynamicActionId,
            "ajaxIdentifier": pdt.opt.ajaxIdentifier,
            "eventName": pEventName, //"keyboardShortcut", //"click",
            "fireOnInit": "N",
            "placeholderText": "Enter a Page Number or Name",
            "moreCharsText": "Please enter at least two letters to search",
            "noMatchText": "No match found",
            "oneMatchText": "1 match found",
            "multipleMatchesText": "matches found",
            "inPageSearchText": "Search on current Page",
            "searchHistoryDeleteText": "Clear Search History",
            "enableKeyboardShortcuts": "Y",
            "enableInPageSearch": "N",
            "maxNavResult": 9999,
            "width": "650",
            "enableDataCache": pdt.getSetting('devbar.openbuildercache'),
            "spotlightTheme": "STANDARD",
            "enablePrefillSelectedText": "N",
            "showProcessing": "Y",
            "placeHolderIcon": "DEFAULT",
            "enableSearchHistory": "N",
            "defaultText": pdt.opt.env.APP_PAGE_ID,
            "appLimit": pdt.getSetting('devbar.openbuilderapplimit')
        };
        return pdtSpotOpt;
    }

    function isDeveloper() {
        var vDevelopersOnly = 'Y';
        // Don't activate for non-developers
        return (vDevelopersOnly === 'Y' && $('#apexDevToolbar').length !== 0) || vDevelopersOnly === 'N';
    }
    
    function isDebugMode() {
        var pdebug = apex.item('pdebug').getValue();
        return ['', 'NO'].indexOf(pdebug) === -1;
    }
    
    function activateGlowDebug() {
        if (!isDeveloper()) return;
    
        if (isDebugMode()) {
            $('#apexDevToolbar').find('.a-Icon.icon-debug').removeClass().addClass('fa fa-bug fam-check fam-is-success');
        } else {
            $('#apexDevToolbar').find('.a-Icon.icon-debug').removeClass().addClass('fa fa-bug fam-x fam-is-disabled');
        }
    }
    
    function activateAutoViewDebug() {
        if (!isDeveloper()) return;
    
        if (isDebugMode()) {
            // Also Auto View Debug before Submit to view the accept
            // Define a flag to track whether the handler has been added
            if (typeof window.activateAutoViewDebugAdded === 'undefined') {
                window.activateAutoViewDebugAdded = false;
            }
            if (!window.activateAutoViewDebugAdded) {
                apex.message.setThemeHooks({
                    beforeShow: function( pMsgType, pElement$ ){
                        if ( pMsgType === apex.message.TYPE.ERROR ) {
                            // pdt.pretiusContentDevBar.activateAutoViewDebug();
                            openAutoViewDebug();
                        }
                    }
                });                
                // Set the flag to true so it's only added once
                window.activateAutoViewDebugAdded = true;
            }
            openAutoViewDebug();
        }
    }

    function openAutoViewDebug() {

        // Check PDT installed
        if (typeof pdt !== 'object') return;

        // Check Dev Bar active
        if (!isDeveloper()) return;

        // Check again if Auto View Debug is on
        if (pdt.getSetting('devbar.autoviewdebugenable') !== 'Y')  return;
    
        if (isDebugMode()) {
            // Get the array of items from the Debug Menu
            var menuItems = parent.$("#apexDevToolbarDebugMenu").menu("instance").options.items;
            
            // Find the first item with the label 'View Debug'
            var viewDebugItem = menuItems.find(function(item) {
                return item.label === 'View Debug';
            });
            
            // If action associated, run it
            if (viewDebugItem) {
                viewDebugItem.action();
            }
        }        
    }
    
    function activateOpenBuilder() {

        var vDevelopersOnly = 'Y';
        var vKeyboardShortcut = pdt.getSetting('devbar.openbuilderkb');

        // Dont activate for non-developers
        if (!((vDevelopersOnly == 'Y' && $('#apexDevToolbar').length != 0) || vDevelopersOnly == 'N')) {
            return;
        }

        // Bind keyboard shortcuts
        Mousetrap.bindGlobal('ctrl+alt+' + vKeyboardShortcut.toLowerCase(), function (e) {
            pdtSpotlight(spotlightOptions('keyboardShortcut'));
        });

        if ($('#apexDevToolbarPage').length > 0 && $('#apexDevToolbarPretiusDeveloperToolSpotlight').length == 0) {

            var iconHtml = '<span class="a-Icon fa pdt-spotlight-devbar-entry" aria-hidden="true"></span>'

            $('#apexDevToolbarPage').parent().after(
                apex.lang.formatNoEscape(
                    '<li><button id="apexDevToolbarPretiusDeveloperToolSpotlight" type="button" class="a-Button a-Button--devToolbar" title="Open Builder [ctrl+alt+%0]" aria-label="Vars" data-link=""> ' +
                    '%1 ' +
                    '</button></li>',
                    vKeyboardShortcut.toLowerCase(),
                    iconHtml
                )
            );

            pdt.fixToolbarWidth();

            var h = document.getElementById("apexDevToolbarPretiusDeveloperToolSpotlight");
            if (h) {
                h.addEventListener("click", function (event) {
                    pdtSpotlight(spotlightOptions('keyboardShortcut'));
                }, true);
            }
        }

        if (pdt.getSetting('devbar.openbuildercache') == 'Y') {
            // // PreFetch 
            pdtSpotlight(spotlightOptions('ready'));
            $('body').trigger('pdt-apexspotlight-prefetch-data');
        } else {
            $('.pdt-spotlight-devbar-entry').addClass('fa-window-arrow-up');
        }

    }

    function pdtSpotlight(opt) {
        if (pdt.opt.spotlightPrefetching) {
            apex.message.alert("PDT is currently caching Page Data. Please retry in a few moments.");
        } else {
            pdt.apexSpotlight.pluginHandler(opt);
        }

    }

    function activateHomeReplace() {
        // Change Title
        $('#apexDevToolbarHome').attr('title','Shared Components - Ctrl/Cmd+Click to open in a new tab');
        // Change Icon
        $('#apexDevToolbarHome span.a-Icon').removeClass().addClass( 'fa fa-shapes' );
        // Remove Label
        $('#apexDevToolbarHome .a-DevToolbar-buttonLabel').replaceWith();

        // Clicking Opens Shared Components
        $('#apexDevToolbarHome').off('click');
        $('#apexDevToolbarHome').on('click', function (event) {
            var pWindow = event.ctrlKey || event.metaKey;
            pdt.pretiusToolbar.openSharedComponents(pWindow);
        });
    }

    return {
        activateOpenBuilder: activateOpenBuilder,
        activateGlowDebug: activateGlowDebug,
        activateHomeReplace: activateHomeReplace,
        activateAutoViewDebug: activateAutoViewDebug,
        openAutoViewDebug: openAutoViewDebug,
        isDebugMode: isDebugMode
    }

})();