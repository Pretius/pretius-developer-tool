pdt.pretiusContentRevealer = (function () {
    "use strict";

    var debugMode;
    var revealerIconHtml;

    var apexItemTypes = ["TEXT",
        "CHECKBOX_GROUP",
        "DISPLAY_SAVES_STATE",
        "DISPLAY_ONLY",
        "HIDDEN",
        "SHUTTLE",
        "RADIO_GROUP",
        "SELECT",
        "POPUP_KEY_LOV",
        "POPUP_LOV",
        "SWITCH",
        "TEXTAREA",
        "CKEDITOR3",
        "AUTO_COMPLETE"];

    // not .apex-item-group 
    var itemString = "input:not('[data-for],.js-tabTrap,.a-GV-rowSelect'), " +
        ".selectlist, " +
        ".textarea, " +
        ".listmanager:not(fieldset), " +
        ".apex-item-radio, " +
        ".apex-item-checkbox, " +
        ".apex-item-display-only, " +
        ".apex-item-group--shuttle, " +
        ".apex-item-shuttle, " +
        ".apex-item-group--switch, " +
        ".apex-item-group--auto-complete, " +
        ".apex-item-yes-no, " +
        "textarea, " +
        ".shuttle:not(table), " +
        ".shuttle_left, " +
        ".shuttle_right, " +
        ".checkbox_group:not('div,table'), " +
        ".yes_no";

    var revealerIgnoreClass = 'pdt-revealer-ignore';

    // https://stackoverflow.com/a/1912522
    function htmlDecode(input) {
        var e = document.createElement('textarea');
        e.innerHTML = input;
        // handle case of empty input
        return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
    }

    var frameworkArray = ['pContext', 'pFlowId', 'pFlowStepId', 'pInstance', 'pPageSubmissionId', 'pRequest', 'pReloadOnSubmit', 'pSalt', 'pPageItemsRowVersion', 'pPageItemsProtected', 'pdebug', 'apexCBMDummySelection', 'pPageChecksum', 'p_md5_checksum', 'pPageFormRegionChecksums'];

    function injectScript(yourCustomJavaScriptCode, persist) {
        var script = document.createElement('script');
        script.id = 'tmpScript';
        var code = document.createTextNode('(function() {' + yourCustomJavaScriptCode + '})();');
        script.appendChild(code);
        if ($(document.body || document.head).length > 0) {
            (document.body || document.head).appendChild(script);
        }
        $("#tmpScript").remove();
    }

    function crippleTabLockRevealer() {
        // Select the node that will be observed for mutations
        const targetNode = document.getElementById('apexDevToolbar');

        // Options for the observer (which mutations to observe)
        const config = { attributes: true, childList: true, subtree: true };

        // Callback function to execute when mutations are observed
        const callbackToolbar = function (mutationsList, observer) {
            if ($('#apexDevToolbarVars').length > 0) {
                $('#apexDevToolbarVars').closest('li').replaceWith();
                observerToolbar.disconnect();
            }
        };

        const callbackIframe = function (mutationsList, observer) {
            if ($('body iframe[id="tablockRevealerFrame"]').length > 0) {
                $('body iframe[id="tablockRevealerFrame"]').replaceWith();
                observerIframe.disconnect();
            }
        };

        // Create an observer instance linked to the callback function
        const observerToolbar = new MutationObserver(callbackToolbar);
        const observerIframe = new MutationObserver(callbackIframe);

        // Start observing the target node for configured mutations
        observerToolbar.observe(targetNode, config);
        observerIframe.observe($('body')[0], config);
    }

    function clog(p) {
        if (pdt.pretiusContentRevealer.debugMode) {
            console.log(p);
        }
    }
    function sendModalMessage() {
        var j = [];
        var discoveredPages = ':';

        function addItemToJson(pSelector, pIframeSelector = '') {
            var a = {};
            var i = 0;

            // Get Page number
            var yourCustomJavaScriptCode = "$('body').attr('tmp_x', " + pIframeSelector + "apex.item('pFlowStepId').getValue());";
            injectScript(yourCustomJavaScriptCode);
            var xpFlowStepId = $("body").attr("tmp_x");
            $("body").removeAttr("tmp_x");

            clog(pSelector);

            var truePageId = xpFlowStepId.split("_")[0];

            a.Page = xpFlowStepId;
            a.Name = pSelector.id;

            var yourCustomJavaScriptCode = htmlDecode(apex.lang.format(
                "var revealerItem = %0apex.item('%1'); " +
                "var revealerValueItem = revealerItem.getValue(); " +
                "var revealerType = revealerItem.item_type; " +
                "var revealerValueItemString; " +
                "if ( revealerValueItem instanceof Array) " +
                "{ " +
                "    revealerValueItemString = revealerValueItem.join(':'); " +
                "} " +
                "else " +
                "{ " +
                "    revealerValueItemString = revealerValueItem; " +
                "} " +
                "$('body').attr('tmp_tabLockCaseValue', revealerValueItemString); " +
                "$('body').attr('tmp_tabLockCaseType',  revealerType); ",
                pIframeSelector,
                a.Name));

            injectScript(yourCustomJavaScriptCode);
            a.Type = $("body").attr("tmp_tabLockCaseType");
            a.Value = $("body").attr("tmp_tabLockCaseValue");
            $("body").removeAttr("tmp_tabLockCaseValue");
            $("body").removeAttr("tmp_tabLockCaseType");

            // If no APEX item, try via node
            if (a.Value == '') {
                a.Value = pSelector.value;
            }

            if (a.Type) {
                a.Type = a.Type.toUpperCase();
            }

            // If no name, try to grab an alternative
            //Color picker fix
            if (a.Name == '') {
                var divClassNames = $(pSelector).closest('div').attr('class');
                if (divClassNames && divClassNames.startsWith('colorpicker')) {
                    var cpID = $(pSelector).closest('.colorpicker').attr('id');

                    a.Name = cpID + ' > ' + divClassNames.split(' ')[0].replace('colorpicker_', '');
                    a.Type = 'INPUT (assoc. with COLOR_PICKER)';
                }
            }

            if ($(pSelector).hasClass('oj-component-initnode')) {
                a.Type += ' (assoc. with AUTO_COMPLETE)';
            }

            if (a.Type == 'FALSE') {
                //Second chance

                // for switches
                if ($(pSelector).hasClass('apex-item-group--switch') ||
                    $(pSelector).hasClass('apex-item-yes-no')) { a.Type = 'SWITCH'; }
                // Text Field with auto complete
                if ($(pSelector).hasClass('apex-item-group--auto-complete')) { a.Type = 'AUTO_COMPLETE'; }

                if ($(pSelector).hasClass('a-Button--listManager')) {
                    a.Name = '> ' + a.Value;
                    a.Type = '(assoc. with LIST_MANAGER)';
                }
                // Text area fieldset
                if ($(pSelector).is('fieldset') && $(pSelector).children('.apex-item-textarea:first').length > 0) {
                    a.Type = '(assoc. with TEXTAREA)';
                }
                /* APEX 5.0 and unnamed */
                if (a.Name == '') {
                    a.Name = $(pSelector).attr('name'); // Replace name with name attribute
                    var origType = $(pSelector).attr('type'); // Replace FALSE type with type attribute
                    if (origType) {
                        a.Type = origType.toUpperCase();
                    }
                }

            }

            if (a.Type == 'HIDDEN' && frameworkArray.indexOf(a.Name) == -1) {
                if ($(pSelector).next().find('.apex-item-popup-lov, .popup_lov').length > 0) {
                    a.Type += ' (assoc. with POPUP_LOV)';
                }
            }

            if (a.Type == 'SELECT') {
                if ($(pSelector).hasClass('shuttle_left') || $(pSelector).hasClass('shuttle_right')) {
                    a.Type += ' (assoc. with SHUTTLE)';
                }
            }

            if (a.Type == 'POPUP_LOV') {
                if ($(pSelector).closest('fieldset').parent().closest('fieldset').hasClass('apex-item-list-manager')) {
                    a.Type += ' (assoc. with SELECT/LIST_MANAGER)';
                }
                if ($(pSelector).attr('title') == 'Add Entry' &&
                    $(pSelector).is('input') &&
                    $(pSelector).is('[id$="ADD"]')) {
                    a.Type += ' (assoc. with LIST_MANAGER)';
                }
            }

            if (a.Type == 'DISPLAY_ONLY') {
                var do_id = $(pSelector).siblings('input[type="hidden"]:first').attr("id");
                if (do_id && $('#' + do_id.replace('_DISPLAY', ''))) {
                    a.Type += ' (assoc. with DISPLAY_ONLY)';
                }
            }

            var typeInArryPos = $.inArray(a.Type, apexItemTypes);

            if (pSelector.closest("[class^='a-IRR']")) {
                a.Category = 'IR';
            }
            else if (pSelector.closest("[class^='a-IG']")) {
                a.Category = 'IG';
            }
            else if (frameworkArray.indexOf(a.Name) >= 0) {
                a.Category = 'FW';
            }
            else {
                // Page items
                if (a.Name && a.Name.startsWith("P" + truePageId) && typeInArryPos > -1) {
                    a.Category = 'PI,PX';
                }
                else if (a.Name && a.Name.startsWith("P0") && typeInArryPos > -1) {
                    a.Category = 'PI,P0';
                }
                else {
                    a.Category = 'PI,PO';
                }
            }

            j.push(a);
        }

        var yourCustomJavaScriptCode = "$('body').attr('tmp_x', apex.item('pFlowStepId').getValue());";
        injectScript(yourCustomJavaScriptCode);
        var xpFlowStepId = $("body").attr("tmp_x");
        $("body").removeAttr("tmp_x");

        discoveredPages = discoveredPages + xpFlowStepId + ':';

        var itemSelector = $(itemString).filter(function() {
            return !( $(this).hasClass(revealerIgnoreClass) || $(this).parents().hasClass(revealerIgnoreClass));
          });

        $(itemSelector).each(function () {
            if ($(this).closest('#pretiusRevealerInline').length == 0 && $(this)[0].hasAttribute("id")) {
                addItemToJson(this);
            }
        });

        var iframeCtr = 0;
        var iframeSelectorString = "iframe:not([id=tablockRevealerFrame])";
        $(iframeSelectorString).filter(function () { return $(this).parents('.ui-dialog--apex').length > 0; }).each(function () {
            var injectSelectorString =
                htmlDecode(apex.lang.format(' $("%0").filter(function() {return $(this).parents(".ui-dialog--apex").length > 0;})[%1].contentWindow.',
                    iframeSelectorString,
                    iframeCtr));

            iframeCtr = iframeCtr + 1;
            var iframeSelector = this;
            xpFlowStepId = this.contentWindow.pFlowStepId.value + '_' + iframeCtr;
            discoveredPages = discoveredPages + this.contentWindow.pFlowStepId.value + ':';
            $(this).contents().find(itemString)
            .filter(function( index ) {
                return $(this)[0].hasAttribute("id");
              })
              .each(function () {
                addItemToJson(this, injectSelectorString);
            });
        });

        pdt.cloakDebugLevel();

        apex.server.plugin(pdt.opt.ajaxIdentifier, {
            x01: 'REVEALER',
            x02: discoveredPages, //pretiusRevealer.pageDelimeted(),
            p_clob_01: JSON.stringify(j)
        }, {
            success: function (data) {
                pdt.unCloakDebugLevel();
                clog(data);
                sparkUpRevealer({ data: data.items });
            },
            error: function (jqXHR, textStatus, errorThrown) {
                // handle error
                pdt.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
            }
        });

    }

    function sparkUpRevealer(e) {

        var myStringArray = pretiusRevealer.distinctPages(e.data);
        var justPages = '';
        var arrayLength = myStringArray.length;
        for (var i = 0; i < arrayLength; i++) {
            if (myStringArray[i] != '*') {
                $('#pretiusRevealerInline #pretiusPageControls').append('<input type="radio" name="pFlowStepId" value="' + myStringArray[i] + '" id="pageFilter' + myStringArray[i] + '" />');
                $('#pretiusRevealerInline #pretiusPageControls').append('<label for="pageFilter' + myStringArray[i] + '">Page ' + myStringArray[i].split("_")[0] + '</label>');
                justPages = justPages + myStringArray[i] + ':';
            }
        }

        $('#pretiusRevealerInline #pretiusPageControls').attr('justPages', ':' + justPages);

        $('#pretiusRevealerInline #pretiusPageControls').append('<input type="radio" name="pFlowStepId" id="pageFilterAll" value="All" />'); 
        $('#pretiusRevealerInline #pretiusPageControls').append('<label for="pageFilterAll">All</label>');

        // Add Results
        $('#pretiusRevealerInline #pretiusContent').empty();
        $('#pretiusRevealerInline #pretiusContent').append(pretiusRevealer.buildHtmlTable(e.data));

        // Add any customisations
        pretiusRevealer.customiseTable();

        // Add Binds
        $('#pretiusRevealerInline #rSearchBox').keyup(function (e) { pretiusRevealer.performFilter(); });
        $('#pretiusRevealerInline #rSearchBox').on('search', function () { pretiusRevealer.performFilter(); });
        $('#pretiusRevealerInline #rClearSearchBox').on('click', function () {
            apex.item('rSearchBox').setValue();
            pretiusRevealer.performFilter();
        });

        $("#pretiusRevealerInline input[type=radio]").click(function () {
            if ($("#pretiusRevealerInline input[type=radio][name=pCategory]:checked").val() == "DebugPage") {
                pretiusRevealer.getDebugViewContent();
            } else {
                pretiusRevealer.performFilter();
            }
        });
     
        // Default Clicks
        $("#pretiusRevealerInline input[type=radio][name=pFlowStepId]:first").trigger("click");
        $("#pretiusRevealerInline input[type=radio][name=pCategory]:first").next().next().trigger("click");

        // Loading off / filters on
        $('#pretiusRevealerInline .revealer-loading').addClass('switch-display-none');
        $('#pretiusRevealerInline .revealer-header').removeClass('switch-display-none');

        //Focus
        $('#pretiusRevealerInline #rSearchBox').focus();

        if ( window.location.host == 'apex.oracle.com' ){ 
            $('#pretiusRevealerInline label[for="DebugPage"]').addClass('apex_disabled');
            $('#pretiusRevealerInline #DebugPage').parent().attr('title','Disabled on apex.oracle.com due to ORA-00040');
        }

    };

    function apexDevToolbarRevealer(pMode) {

        apex.theme.openRegion($('#pretiusRevealerInline'));
        $("#pretiusRevealerInline .t-DialogRegion-body").load(pdt.opt.filePrefix + "revealer/revealer.html");

        $('#pretiusRevealerInline #pretiusContent').empty();
        $('.pretiusRevealerInlineToTheTop .ui-dialog-title').text(' Pretius Developer Tool: Revealer');
        sendModalMessage();

    }

    function addHipster() {

        var cIsToolbarPresent = $("#apexDevToolbar").length > 0;
        if (cIsToolbarPresent) {

            if ($('#apexDevToolbarQuickEdit').length > 0 && $('#apexDevToolbarRevealer').length == 0) {

                // revealerIconHtml = '<span class="a-Icon fa fa-hipster" aria-hidden="true"></span>'
                revealerIconHtml = '<img src="' + pdt.opt.filePrefix + 'revealer/fontApexHipster-o.svg' + '"' +
                ' onload="pdt.fixToolbarWidth();" ' +
                ' class="tablockHipsterIcon" />';

                var kb = pdt.getSetting('revealer.kb').toLowerCase();
                $('#apexDevToolbarQuickEdit').parent().before(
                    htmlDecode(apex.lang.formatNoEscape(
                        '<li><button id="apexDevToolbarRevealer" type="button" class="a-Button a-Button--devToolbar" title="View Page Information [ctrl+alt+%0]" aria-label="Vars" data-link=""> ' +
                        '%1 <span class="a-DevToolbar-buttonLabel">Revealer</span> ' +
                        '</button></li>',
                        kb,
                        revealerIconHtml
                    ))
                );

                var h = document.getElementById("apexDevToolbarRevealer");
                if (h) {
                    h.addEventListener("click", function (event) {
                        apexDevToolbarRevealer();

                    }, true);
                }

                pdt.fixToolbarWidth();
                // Custom APEX 5.0 width fix
                $('#apexDevToolbar').width($('.a-DevToolbar-list').width() + 'px');

                if (pdt.getSetting('revealer.kb') != '') {

                    if (kb != "") {
                        // Bind keyboard shortcuts
                        Mousetrap.bindGlobal('ctrl+alt+' + kb, function (e) {
                            parent.$(':focus').blur();
                            parent.pdt.pretiusContentRevealer.debugMode = false;
                            parent.$("#apexDevToolbarRevealer").trigger('click');
                        });
                        Mousetrap.bindGlobal('ctrl+alt+shift+' + kb, function (e) {
                            if (parent.$("#apexDevToolbarRevealer").length > 0) {
                                parent.$(':focus').blur();
                                apex.message.showPageSuccess("Opening Revealer in Debug Mode");
                                parent.pdt.pretiusContentRevealer.debugMode = true;
                                parent.$("#apexDevToolbarRevealer").trigger('click');
                            }
                        });
                    }
                }


                // cripple Tablock Revealer
                if (pdt.getSetting('revealer.tablockdeactivate') == 'Y') {
                    crippleTabLockRevealer();
                }

            }
        }
    }


    return {
        addHipster: addHipster,
        injectScript: injectScript,
        debugMode: debugMode
    }

})();