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

    function activateGlowDebug() {

        var vDevelopersOnly = 'Y';

        // Dont activate for non-developers
        if (!((vDevelopersOnly == 'Y' && $('#apexDevToolbar').length != 0) || vDevelopersOnly == 'N')) {
            return;
        }

        // obtain Debug seting from pdebug page variable
        var pdebug = apex.item('pdebug').getValue();

        var isDebug = (['', 'NO'].indexOf(pdebug) == -1);
        if (isDebug) {
            $('#apexDevToolbar').find('.a-Icon.icon-debug').addClass('pdt-glowDebug');
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
        activateHomeReplace: activateHomeReplace
    }

})();