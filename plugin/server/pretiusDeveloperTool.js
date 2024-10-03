/*
* Plugin:   Pretius Reload Frame
* Version:  1.0.0
*
* License:  MIT License Copyright 2022 Pretius Sp. z o.o. Sp. K.
* Homepage: 
* Mail:     apex-plugins@pretius.com
* Issues:   https://github.com/Pretius/reload-frame/issues
*
* Author:   Matt Mulvaney
* Mail:     mmulvaney@pretius.com
* Twitter:  Matt_Mulvaney
*
*/

var pdt = (function () {
    "use strict";

    var da;
    var opt;
    var JSONsettings;
    var pageDebugLevel;

    function nvl(value1, value2) {
        if (value1 == null || value1 == "")
            return value2;
        return value1;
    };

    function getSetting(pPath) {
        // https://stackoverflow.com/a/45322101
        function resolve(path, obj) {
            return path.split('.').reduce(function (prev, curr) {
                return prev ? prev[curr] : null
            }, obj || self)
        }

        return resolve('settings.' + pPath,
            pdt.JSONsettings);
    }


    function fixToolbarWidth() {

        function getWindowWidth() {
            return document.documentElement.clientWidth;
        }

        var o, tbWidth, windowWidth,
            dtb$ = $("#apexDevToolbar"),
            direction = dtb$.css("direction") === "rtl" ? "right" : "left"; // when in RTL mode, the left CSS property

        o = {
            width: ""
        };
        if (dtb$.hasClass("a-DevToolbar--top") || dtb$.hasClass("a-DevToolbar--bottom")) {
            windowWidth = getWindowWidth();
            o.whiteSpace = "nowrap";  // clear element width to get desired width of ul content
            dtb$.css(o);
            // using width assuming no margin etc.
            tbWidth = dtb$.children("ul")[0].clientWidth + 4; // IE wants just a little extra to keep the buttons from wrapping
            if (tbWidth > windowWidth) {
                tbWidth = windowWidth;
            }
            o.whiteSpace = "wrap";
            o.width = tbWidth;
            o[direction] = (windowWidth - tbWidth) / 2; // position the offset in the center.
        } else {
            o[direction] = ""; // clear the offset and width
        }
        dtb$.css(o);
    }

    function addPretiusOptions() {

        var cIsToolbarPresent = $("#apexDevToolbar").length > 0;
        if (cIsToolbarPresent) {

            if ($('#apexDevToolbarOptions').length > 0 && $('#apexDevToolbarPretiusDeveloperToolOptions').length == 0) {

                var revealerIconHtml = '<span class="a-Icon fa fa-filter fam-x fam-is-danger" aria-hidden="true"></span>'

                if (pdt.opt.configurationTest == "true") {
                    revealerIconHtml = revealerIconHtml.replace('fam-x fam-is-danger', '');
                }

                $('#apexDevToolbarOptions').parent().after(
                    apex.lang.formatNoEscape(
                        '<li><button id="apexDevToolbarPretiusDeveloperToolOptions" type="button" class="a-Button a-Button--devToolbar" title="View Page Information [ctrl+alt+%0]" aria-label="Vars" data-link=""> ' +
                        '%1 ' +
                        '</button></li>',
                        'Pretius Developer Tool Options',
                        revealerIconHtml
                    )
                );

                var h = document.getElementById("apexDevToolbarPretiusDeveloperToolOptions");
                if (h) {
                    h.addEventListener("click", function (event) {
                        apexDevToolbarPretiusDeveloperToolOptions();

                    }, true);
                }

                transplantInlineDialog();

                fixToolbarWidth();
                // Custom APEX 5.0 width fix
                $('#apexDevToolbar').width($('.a-DevToolbar-list').width() + 'px');

                function pdtOptionsSave() {
                    var JsonSettings = {
                        "settings": {
                            "optout": {
                                "status": apex.item("R0_OPT_OUT").getValue()
                            },
                            "revealer": {
                                "enable": apex.item("R0_REVEALER_ENABLE").getValue(),
                                "tablockdeactivate": apex.item("R0_REVEALER_CRIPPLE_TABLOCK").getValue(),
                                "kb": apex.item("R0_REVEALER_KB_SHORTCUT").getValue(),
                                "dkb": apex.item("R0_REVEALER_DEBUG_KB_SHORTCUT").getValue(),
                                "debugrows": apex.item("R0_REVEALER_DEBUG_ROWS").getValue()
                            },
                            "reloadframe": {
                                "enable": apex.item("R0_RELOAD_ENABLE").getValue(),
                                "developersonly": apex.item("R0_RELOAD_DEVELOPERS_ONLY").getValue(),
                                "bypasswarnonunsaved": apex.item("R0_RELOAD_BYPASS_UNCHANGED").getValue(),
                                "kb": apex.item("R0_RELOAD_KB_SHORTCUT").getValue()
                            }
                            ,
                            "buildoptionhightlight": {
                                "enable": apex.item("R0_BUILD_OPTION_ENABLE").getValue(),
                                "duration": apex.item("R0_BUILD_OPTION_DURATION").getValue()
                            },
                            "devbar": {
                                "glowdebugenable": apex.item("R0_GLOW_DEBUG_ICON").getValue(),
                                "autoviewdebugenable": apex.item("R0_AUTO_VIEW_DEBUG").getValue(),
                                "masterdetaildebugenable": apex.item("R0_MASTER_DETAIL_DEBUG").getValue(),
                                "openbuilderenable": apex.item("R0_OPEN_BUILDER_ENABLE").getValue(),
                                "openbuildercache": apex.item("R0_OPEN_BUILDER_CACHE").getValue(),
                                "openbuilderapplimit": apex.item("R0_OPEN_BUILDER_APP_LIMIT").getValue(),
                                "openbuilderkb": apex.item("R0_OPEN_BUILDER_KB_SHORTCUT").getValue(),
                                "homereplacelink": apex.item("R0_HOME_REPLACE_LINK").getValue()
                            }
                        }
                    };

                    localStorage.setItem("pretiusDeveloperTool", JSON.stringify(JsonSettings));
                    pdt.JSONsettings = JsonSettings;
                    apex.theme.closeRegion($('#pretiusRevealerInline'));
                    apex.message.showPageSuccess("Settings saved. Refresh your browser.");
                }

                $("#pretiusRevealerInline").on("click", ".optOutLink", function () {
                    apex.message.confirm("By Opting-Out of Pretius Developer Tool, you will no long have access to the plug-in features or this settings page.\n\nYou can regain access by typing the following in to the Browser Console \n\npdt.optIn();\n\nYou can find this command again on our GitHub Plugin Page\n\nAre you sure you wish to continue?", function (okPressed) {
                        if (okPressed) {
                            apex.item("R0_OPT_OUT").setValue("Y");
                            pdtOptionsSave();
                        }
                    });
                });

                $("#pretiusRevealerInline").on("click", ".pdt-enable-all", function () {
                    apex.item('R0_REVEALER_ENABLE').setValue('Y');
                    apex.item('R0_RELOAD_ENABLE').setValue('Y');
                    apex.item('R0_BUILD_OPTION_ENABLE').setValue('Y');
                    apex.item('R0_OPEN_BUILDER_ENABLE').setValue('Y');
                    apex.item('R0_GLOW_DEBUG_ICON').setValue('Y');
                    apex.item('R0_AUTO_VIEW_DEBUG').setValue('Y');
                    apex.item('R0_MASTER_DETAIL_DEBUG').setValue('Y');
                    apex.item('R0_HOME_REPLACE_LINK').setValue('Y');
                });

                $("#pretiusRevealerInline").on("click", "#R0_SAVE", function () {
                    pdtOptionsSave();
                });

                $("#pretiusRevealerInline").on("click", "#R0_CANCEL", function () {
                    apex.theme.closeRegion($('#pretiusRevealerInline'));
                });

                $("#pretiusRevealerInline").on("change", "#R0_REVEALER_ENABLE", function () {

                    if (nvl(apex.item('R0_REVEALER_ENABLE').getValue(), 'N') == 'N') {
                        apex.item('R0_REVEALER_CRIPPLE_TABLOCK_CONTAINER').disable();
                        apex.item('R0_REVEALER_KB_SHORTCUT_CONTAINER').disable();
                        apex.item('R0_REVEALER_DEBUG_KB_SHORTCUT_CONTAINER').disable();
                        apex.item('R0_REVEALER_DEBUG_ROWS_CONTAINER').disable();
                    } else {
                        apex.item('R0_REVEALER_CRIPPLE_TABLOCK_CONTAINER').enable();
                        apex.item('R0_REVEALER_KB_SHORTCUT_CONTAINER').enable();
                        apex.item('R0_REVEALER_DEBUG_KB_SHORTCUT_CONTAINER').enable();
                        apex.item('R0_REVEALER_DEBUG_ROWS_CONTAINER').enable();
                    }
                });

                $("#pretiusRevealerInline").on("change", "#R0_RELOAD_ENABLE", function () {

                    if (nvl(apex.item('R0_RELOAD_ENABLE').getValue(), 'N') == 'N') {
                        apex.item('R0_RELOAD_DEVELOPERS_ONLY_CONTAINER').disable();
                        apex.item('R0_RELOAD_BYPASS_UNCHANGED_CONTAINER').disable();
                        apex.item('R0_RELOAD_KB_SHORTCUT_CONTAINER').disable();
                    } else {
                        apex.item('R0_RELOAD_DEVELOPERS_ONLY_CONTAINER').enable();
                        apex.item('R0_RELOAD_BYPASS_UNCHANGED_CONTAINER').enable();
                        apex.item('R0_RELOAD_KB_SHORTCUT_CONTAINER').enable();
                    }
                });

                $("#pretiusRevealerInline").on("change", "#R0_BUILD_OPTION_ENABLE", function () {

                    if (nvl(apex.item('R0_BUILD_OPTION_ENABLE').getValue(), 'N') == 'N') {
                        apex.item('R0_BUILD_OPTION_DURATION_CONTAINER').disable();
                    } else {
                        apex.item('R0_BUILD_OPTION_DURATION_CONTAINER').enable();
                    }
                });

                $("#pretiusRevealerInline").on("change", "#R0_OPEN_BUILDER_ENABLE", function () {

                    if (nvl(apex.item('R0_OPEN_BUILDER_ENABLE').getValue(), 'N') == 'N') {
                        apex.item('R0_OPEN_BUILDER_KB_SHORTCUT_CONTAINER').disable();
                        apex.item('R0_OPEN_BUILDER_CACHE_CONTAINER').disable();
                        apex.item('R0_OPEN_BUILDER_APP_LIMIT_CONTAINER').disable();
                    } else {
                        apex.item('R0_OPEN_BUILDER_KB_SHORTCUT_CONTAINER').enable();
                        apex.item('R0_OPEN_BUILDER_CACHE_CONTAINER').enable();
                        apex.item('R0_OPEN_BUILDER_APP_LIMIT_CONTAINER').enable();
                    }
                });

            }
        }
    }

    function optionsJS() {

        apex.widget.yesNo("R0_REVEALER_ENABLE", "SWITCH_CB");
        apex.widget.yesNo("R0_REVEALER_CRIPPLE_TABLOCK", "SWITCH_CB");
        apex.widget.yesNo("R0_RELOAD_ENABLE", "SWITCH_CB");
        apex.widget.yesNo("R0_RELOAD_DEVELOPERS_ONLY", "SWITCH_CB");
        apex.widget.yesNo("R0_RELOAD_BYPASS_UNCHANGED", "SWITCH_CB");
        apex.widget.yesNo("R0_BUILD_OPTION_ENABLE", "SWITCH_CB");
        apex.widget.yesNo("R0_OPEN_BUILDER_ENABLE", "SWITCH_CB");
        apex.widget.yesNo("R0_GLOW_DEBUG_ICON", "SWITCH_CB");
        apex.widget.yesNo("R0_AUTO_VIEW_DEBUG", "SWITCH_CB");   
        apex.widget.yesNo("R0_MASTER_DETAIL_DEBUG", "SWITCH_CB");   
        apex.widget.yesNo("R0_OPEN_BUILDER_CACHE", "SWITCH_CB");
        apex.widget.yesNo("R0_OPEN_BUILDER_APP_LIMIT", "SWITCH_CB");
        apex.widget.yesNo("R0_HOME_REPLACE_LINK", "SWITCH_CB");

        $('.pretiusRevealerInlineToTheTop .t-ButtonRegion-col--right .t-ButtonRegion-buttons').empty();
        $('.pretiusRevealerInlineToTheTop .t-ButtonRegion-col--left .t-ButtonRegion-buttons').empty();
        $('#pretiusRevealerInline #R0_SAVE').appendTo($('.t-ButtonRegion-col--right .t-ButtonRegion-buttons'));
        $('#pretiusRevealerInline #R0_CANCEL').appendTo($('.t-ButtonRegion-col--left .t-ButtonRegion-buttons'));
        $('.pretiusRevealerInlineToTheTop #pretiusRevealerButtonRegion').show();

        var JSONsettings = pdt.JSONsettings;

        if (!$.isEmptyObject(JSONsettings)) {
            apex.item("R0_REVEALER_ENABLE").setValue(pdt.getSetting('revealer.enable'));
            apex.item("R0_REVEALER_CRIPPLE_TABLOCK").setValue(pdt.nvl(pdt.getSetting('revealer.tablockdeactivate'), 'Y'));
            apex.item("R0_REVEALER_KB_SHORTCUT").setValue(pdt.nvl(pdt.getSetting('revealer.kb'), 'Q'));
            apex.item("R0_REVEALER_DEBUG_KB_SHORTCUT").setValue(pdt.nvl(pdt.getSetting('revealer.dkb'), 'D'));
            apex.item("R0_REVEALER_DEBUG_ROWS").setValue(pdt.nvl(pdt.getSetting('revealer.debugrows'), '10'));
            
            apex.item("R0_RELOAD_ENABLE").setValue(pdt.getSetting('reloadframe.enable'));
            apex.item("R0_RELOAD_DEVELOPERS_ONLY").setValue(pdt.getSetting('reloadframe.bypasswarnonunsaved'));
            apex.item("R0_RELOAD_BYPASS_UNCHANGED").setValue(pdt.nvl(pdt.getSetting('reloadframe.bypasswarnonunsaved'), 'Y'));
            apex.item("R0_RELOAD_KB_SHORTCUT").setValue(pdt.nvl(pdt.getSetting('reloadframe.kb'), 'R'));

            apex.item("R0_BUILD_OPTION_ENABLE").setValue(pdt.getSetting('buildoptionhightlight.enable'));
            apex.item("R0_BUILD_OPTION_DURATION").setValue(pdt.nvl(pdt.getSetting('buildoptionhightlight.duration'), '6'));

            apex.item("R0_OPEN_BUILDER_ENABLE").setValue(pdt.getSetting('devbar.openbuilderenable'));
            apex.item("R0_OPEN_BUILDER_CACHE").setValue(pdt.getSetting('devbar.openbuildercache'));
            apex.item("R0_OPEN_BUILDER_APP_LIMIT").setValue(pdt.getSetting('devbar.openbuilderapplimit'));
            apex.item("R0_OPEN_BUILDER_KB_SHORTCUT").setValue(pdt.nvl(pdt.getSetting('devbar.openbuilderkb'), 'W'));
            apex.item("R0_GLOW_DEBUG_ICON").setValue(pdt.getSetting('devbar.glowdebugenable'));
            apex.item("R0_AUTO_VIEW_DEBUG").setValue(pdt.getSetting('devbar.autoviewdebugenable'));
            apex.item("R0_MASTER_DETAIL_DEBUG").setValue(pdt.getSetting('devbar.masterdetaildebugenable'));
            apex.item("R0_HOME_REPLACE_LINK").setValue(pdt.getSetting('devbar.homereplacelink'));

        }

        $("#pretiusRevealerInline #R0_REVEALER_ENABLE").trigger("change");
        $("#pretiusRevealerInline #R0_RELOAD_ENABLE").trigger("change");
        $("#pretiusRevealerInline #R0_BUILD_OPTION_ENABLE").trigger("change");
        $("#pretiusRevealerInline #R0_OPEN_BUILDER_ENABLE").trigger("change");
        $("#pretiusRevealerInline #R0_GLOW_DEBUG_ICON").trigger("change");
        $("#pretiusRevealerInline #R0_AUTO_VIEW_DEBUG").trigger("change");
        $("#pretiusRevealerInline #R0_MASTER_DETAIL_DEBUG").trigger("change");
        $("#pretiusRevealerInline #R0_HOME_REPLACE_LINK").trigger("change");

        if (pdt.opt.configurationTest == "false") {
            $('#pretiusDeveloperToolWarning').show();
        }

        if (navigator.userAgent.indexOf("Mac") !== -1) {
            // running on a Mac
            var vMacKbText = 'Keyboard Shortcut control+option+...';
            $('#R0_REVEALER_KB_SHORTCUT_LABEL').text(vMacKbText);
            $('#R0_REVEALER_DEBUG_KB_SHORTCUT_LABEL').text(vMacKbText);
            $('#R0_RELOAD_KB_SHORTCUT_LABEL').text(vMacKbText);
            $('#R0_ROPEN_BUILDER_KB_SHORTCUT_LABEL').text(vMacKbText);
        }
    }

    function apexDevToolbarPretiusDeveloperToolOptions(pMode) {

        apex.theme.openRegion($('#pretiusRevealerInline'));
        $("#pretiusRevealerInline .t-DialogRegion-body").load(pdt.opt.filePrefix + "pretiusDeveloperTool.html", function () {
            optionsJS();
        });

        $('#pretiusRevealerInline #pretiusContent').empty();
        $('.pretiusRevealerInlineToTheTop .ui-dialog-title').text(' Pretius Developer Tool: Options');
        // sendModalMessage();

    }

    function transplantInlineDialog() {

        var pretiusRevealerFooter =
            '<div class="pretiusRevealerFooter">' +
            '<a class="pretiusRevealerLink pretiusFooterOptions" href="https://pretius.com/main/" target="_blank">Pretius</a>' +
            '<a class="pretiusRevealerLink" href="https://twitter.com/Matt_Mulvaney" target="_blank">@Matt_Mulvaney </a>' +
            '<a class="pretiusRevealerLink" href="https://twitter.com/PretiusSoftware" target="_blank">@PretiusSoftware</a>' +
            '<div class="pretiusTablockVersion"></div>' +
            '</div>';

        // If the page Template Doesnt support Inline Dialogs, like page 9999, add a cheeky div
        if ($('.t-Body-inlineDialogs').length == 0) {
            $('#apexDevToolbar').prepend('<div class="t-Body-inlineDialogs"></div>');
        }

        // Only create a container if there are no other inline dialogs on the page
        if ($('.t-Body-inlineDialogs .container').length == 0) {
            $('.t-Body-inlineDialogs').append('<div class="container"></div>');
        }

        // Whack a wad of HTML in the container
        $('.t-Body-inlineDialogs .container').append(
            '    <div class="row"> ' +
            '    <div class="col col-12 apex-col-auto"> ' +
            '        <div id="pretiusRevealerInline_parent"> ' +
            '            <div id="pretiusRevealerInline" ' +
            '                class="t-DialogRegion js-modal js-dialog-noOverlay js-draggable js-resizable js-dialog-autoheight js-dialog-size600x400 js-regionDialog" ' +
            '                style="display:none" title=" Pretius Developer Tool: Revealer"> ' +
            '                <div class="t-DialogRegion-wrap"> ' +
            '                    <div class="t-DialogRegion-bodyWrapperOut"> ' +
            '                        <div class="t-DialogRegion-bodyWrapperIn"> ' +
            '                            <div class="t-DialogRegion-body"></div> ' +
            '                        </div> ' +
            '                    </div> ' +
            '                    <div class="t-DialogRegion-buttons"> ' +
            '                        <div id="pretiusRevealerButtonRegion" class="t-ButtonRegion t-ButtonRegion--dialogRegion" style="display:none"> ' +
            '                            <div class="t-ButtonRegion-wrap"> ' +
            '                                <div class="t-ButtonRegion-col t-ButtonRegion-col--left"> ' +
            '                                    <div class="t-ButtonRegion-buttons"></div> ' +
            '                                </div> ' +
            '                                <div class="t-ButtonRegion-col t-ButtonRegion-col--right"> ' +
            '                                    <div class="t-ButtonRegion-buttons"></div> ' +
            '                                </div> ' +
            '                            </div> ' +
            '                        </div> ' +
            '                    </div> ' +
            '                </div> ' +
            '            </div> ' +
            '        </div> ' +
            '    </div> ' +
            '</div> '
        );

        var viewportWidth = window.innerWidth - 20;
        var viewportHeight = window.innerHeight - 20;
        if (viewportWidth > 1000) viewportWidth = 1000;
        if (viewportHeight > 650) viewportHeight = 650;

        $("#pretiusRevealerInline").each(function () {
            var inst$ = $(this),
                isPopup = inst$.hasClass("js-regionPopup"),
                size =  ["js-dialog-size600x400", viewportWidth, viewportHeight ],
                relPos = /js-popup-pos-(\w+)/.exec(this.className),
                parent = inst$.attr("data-parent-element"),
                options = {
                    autoOpen: false,
                    collapseEnabled: true,
                    noOverlay: inst$.hasClass("js-popup-noOverlay"),
                    closeText: apex.lang.getMessage("APEX.DIALOG.CLOSE"),
                    modal: isPopup || inst$.hasClass("js-modal"),
                    resizable: isPopup ? false : inst$.hasClass("js-resizable"),
                    draggable: isPopup ? false : inst$.hasClass("js-draggable"),
                    dialogClass: 'ui-dialog--inline pretiusRevealerInlineToTheTop',
                    open: function (d) {
                        $('.pretiusRevealerInlineToTheTop .pretiusCompressBtn').show();
                        $('.pretiusRevealerInlineToTheTop .pretiusExpandBtn').hide();
                        $('.pretiusRevealerInlineToTheTop #pretiusRevealerButtonRegion').hide();

                        // Log and remove the overlays z-index to allow the developer bar to enable
                        var overlayZindex = $('.ui-widget-overlay.ui-front').css("z-index");
                        $(d.target).dialog("option", "overlay-z-index", overlayZindex);
                        $('.ui-widget-overlay.ui-front').css("z-index", "");
                    },
                    close: function (d) {
                        // Restore the overlays z-index
                        var overlayZindex = $(d.target).dialog("option", "overlay-z-index");
                        $('.ui-widget-overlay.ui-front').css("z-index", overlayZindex);
                    },
                    create: function () {
                        // don't scroll the dialog with the page
                        $(this).closest(".ui-dialog").css("position", "fixed");
                        $('#pretiusRevealerInline').parent().append(pretiusRevealerFooter);
                        $('.pretiusRevealerFooter .pretiusTablockVersion').text(pdt.opt.version);
                    }
                },
                widget = isPopup ? "popup" : "dialog";

            if (size) {
                options.width = size[1];
                options.height = size[2];
            }
            if (parent && isPopup) {
                options.parentElement = parent;
                if (inst$.hasClass("js-popup-callout")) {
                    options.callout = true; // don't explicitly set to false
                }
                if (relPos) {
                    options.relativePosition = relPos[1];
                }
            }
            $.each(["width", "height", "minWidth", "minHeight", "maxWidth", "maxHeight"], function (i, prop) {
                var attrValue = parseInt(inst$.attr("data-" + prop.toLowerCase()), 10);
                if (!isNaN(attrValue)) {
                    options[prop] = attrValue;
                }
            });
            $.each(["appendTo", "dialogClass"], function (i, prop) {
                var attrValue = inst$.attr("data-" + prop.toLowerCase());
                if (attrValue) {
                    options[prop] = attrValue;
                }
            });
            if (options.appendTo && options.appendTo.substring(0, 1) === "#" && $(options.appendTo).length === 0) {
                $("#wwvFlowForm").after('<div id="' + util.escapeHTML(options.appendTo.substring(1)) + '"></div>');
            }
            inst$[widget](options)
                .on(widget + "open", function () {
                    if (options.modal) {
                        apex.navigation.beginFreezeScroll();
                    }
                    apex.widget.util.visibilityChange(inst$[0], true);
                })
                .on(widget + "resize", function () {
                    // resize sets position to absolute so fix what resizable broke
                    $(this).closest(".ui-dialog").css("position", "fixed");
                })
                .on(widget + "close", function () {
                    if (options.modal) {
                        apex.navigation.endFreezeScroll();
                    }
                    $("#pretiusRevealerInline .t-DialogRegion-body").empty();
                    apex.widget.util.visibilityChange(inst$[0], false);
                });
        });

        var revealerIconHtml = '<img src="' + pdt.opt.filePrefix + 'revealer/fontApexHipster.svg' + '" class="tablockHipsterIcon margin-right-sm"/>';
        $("#pretiusRevealerInline").parent().find(".ui-dialog-title").addClass('fa').before(revealerIconHtml);

    }

    var render = function render(options) {

        pdt.da = options.da;
        pdt.opt = options.opt;
        pdt.JSONsettings = JSON.parse(localStorage.getItem("pretiusDeveloperTool"));

        apex.debug.info(options.opt.debugPrefix + 'render', options);


        if (pdt.getSetting('optout.status') != 'Y') {

            addPretiusOptions();

            if (!$.isEmptyObject(pdt.JSONsettings)) {

                // Revealer
                if (getSetting('revealer.enable') == 'Y') {
                    pdt.pretiusContentRevealer.addHipster();
                }

                // Reload Frame
                if (getSetting('reloadframe.enable') == 'Y') {
                    pdt.pretiusContentReloadFrame.activate();
                }

                // Build Option Highlight
                if (getSetting('buildoptionhightlight.enable') == 'Y') {
                    pdt.contentBuildOptionHighlight.activate();
                }

                // OpenBuilder
                if (getSetting('devbar.openbuilderenable') == 'Y') {
                    pdt.pretiusContentDevBar.activateOpenBuilder();
                }

                // GlowDebug
                if (getSetting('devbar.glowdebugenable') == 'Y') {
                    pdt.pretiusContentDevBar.activateGlowDebug();
                }

                // HomeReplace
                if (getSetting('devbar.homereplacelink') == 'Y') {
                    pdt.pretiusContentDevBar.activateHomeReplace();
                }

                // Master Detail Debug
                if (getSetting('devbar.masterdetaildebugenable') == 'Y') {
                    pdt.debugControl.activateDebugControl();
                }                

                // Auto View Debug
                if (getSetting('devbar.autoviewdebugenable') == 'Y') {
                    pdt.pretiusContentDevBar.activateAutoViewDebug();
                }

            }
        }

        pdt.fixToolbarWidth();

    };

    var cloakDebugLevel = function cloakDebugLevel() {

        pdt.pageDebugLevel = apex.item('pdebug').getValue();
        apex.item('pdebug').setValue('LEVEL2');

    }

    var unCloakDebugLevel = function unCloakDebugLevel() {
        if (pdt.pageDebugLevel != undefined) {
            apex.item('pdebug').setValue(pdt.pageDebugLevel);
        }
    }

    var ajaxErrorHandler = function ajaxErrorHandler(pData, pErr, pErrorMessage) {

        pdt.unCloakDebugLevel();

        apex.message.clearErrors();
        apex.message.showErrors([{
            type: "error",
            location: ["page"],
            message: pErrorMessage + '<br>Please check browser console.',
            unsafe: false
        }]);

        apex.debug.info(pData, pErr, pErrorMessage);
    }

    var optIn = function optIn() {
        var j = JSON.parse(localStorage.getItem("pretiusDeveloperTool"));
        if (j != null) {
            j.settings.optout.status = 'N';
            localStorage.setItem("pretiusDeveloperTool", JSON.stringify(j));
            apex.message.showPageSuccess("Opted In to Pretius Developer Tool. Refresh your browser.");
        }
    }

    return {
        render: render,
        da: da,
        opt: opt,
        JSONsettings: JSONsettings,
        nvl: nvl,
        fixToolbarWidth: fixToolbarWidth,
        getSetting: getSetting,
        pageDebugLevel: pageDebugLevel,
        cloakDebugLevel: cloakDebugLevel,
        unCloakDebugLevel: unCloakDebugLevel,
        ajaxErrorHandler: ajaxErrorHandler,
        optIn: optIn
    }

})();