pdt.pretiusContentReloadFrame = (function () {
    "use strict";

    function activate() {

        var JSONsettings = pdt.JSONsettings;
        var vDevelopersOnly = 'Y'; //JSONsettings.settings.reloadframe.developersonly;
        var vBypassWarnOnUnsavedChanges = pdt.getSetting( 'reloadframe.bypasswarnonunsaved' );
        var vKeyboardShortcut = pdt.getSetting( 'reloadframe.kb' );

        $(document).on("dialogopen", function (event) {
            // Dont activate for iframes that are'nt modal dialgos
            if (!($(event.target).parent().hasClass('ui-dialog--apex'))) {
                return;
            }

            // Dont activate for non-developers
            if (!((vDevelopersOnly == 'Y' && $('#apexDevToolbar').length != 0) || vDevelopersOnly == 'N')) {
                return;
            }

            //  Add refresh button
            var vEventTarget = $(event.target),
                rBtnTitle = 'Reload Frame',
                rBtn =
                    '<button type="button" title="%0" aria-label="Reload Frame" ' +
                    '    style="margin-right:%1px;" ' +
                    '    class="pretiusReloadFrame t-Button t-Button--noLabel t-Button--icon t-Button--small"><span aria-hidden="true" ' +
                    '        class="pretiusReloadFrameIcon t-Icon fa fa-refresh"></span></button>',
                vParent = $(vEventTarget).parent(),
                vTitle = $(vParent).find('.ui-dialog-title'),
                vDialogCloseBtn = $(vParent).find('.ui-dialog-titlebar-close'),
                vMargin = 0,
                vDialog = $(vEventTarget).closest("div.ui-dialog--apex"),
                viFrame = $(vDialog).find('iframe');

            // if close button already has a margin then pad out
            if ($(vDialogCloseBtn).length > 0 && $(vDialogCloseBtn).css('margin-left').replace('px', '') == '0') {
                vMargin = 30;
            }

            if (vKeyboardShortcut != null) {
                // Format Button title/tooltip
                rBtnTitle = rBtnTitle + apex.lang.format(' (Ctrl+Alt+%0)', vKeyboardShortcut);
            }

            // Set Button title/tooltip and add Button
            rBtn = apex.lang.format(rBtn, rBtnTitle, vMargin);
            $(vTitle).after(rBtn);

        });
        

        $('body').on('click', 'button.pretiusReloadFrame', function (event) {
            var vEventTarget = $(event.target),
                vDialog = $(vEventTarget).closest("div.ui-dialog--apex"),
                viFrame = $(vDialog).find('iframe'),
                vRotateTimeout = 1000;

            if (viFrame[0].contentWindow.apex.page.isChanged() == false || vBypassWarnOnUnsavedChanges == 'Y') {
                viFrame[0].contentWindow.apex.page.cancelWarnOnUnsavedChanges();
                $(vEventTarget).parent().find('.pretiusReloadFrameIcon').addClass('fa-anim-spin');

                setTimeout(function () {
                    $(vEventTarget).parent().find('.pretiusReloadFrameIcon').removeClass('fa-anim-spin');
                }, vRotateTimeout);
            }

            viFrame[0].contentDocument.location.reload();
        });

        // Bind keyboard shortcuts
        Mousetrap.bindGlobal('ctrl+alt+' + vKeyboardShortcut.toLowerCase(), function (e) {
            parent.$('button.pretiusReloadFrame:last').trigger('click');
        });

    }

    return {
        activate: activate
    }

})();