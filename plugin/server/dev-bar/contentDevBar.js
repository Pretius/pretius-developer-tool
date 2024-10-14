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

        const debugClass = isDebugMode()
            ? 'fa fa-bug fam-check fam-is-success'
            : 'fa fa-bug fam-x fam-is-disabled';

        $('#apexDevToolbar').find('.a-Icon.icon-debug').removeClass().addClass(debugClass);
        $('#apexDevDebugPdt').find('.fa.fa-bug').removeClass().addClass(debugClass);
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
                    beforeShow: function (pMsgType, pElement$) {
                        if (pMsgType === apex.message.TYPE.ERROR) {
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
        if (pdt.getSetting('devbar.autoviewdebugenable') !== 'Y') return;

        if (isDebugMode()) {
            // Get the array of items from the Debug Menu
            var menuItems = parent.$("#apexDevToolbarDebugMenu").menu("instance").options.items;

            // Find the first item with the label 'View Debug'
            var viewDebugItem = menuItems.find(function (item) {
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

            // pdt.fixToolbarWidth();

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
        builderMenuButton();
        $('#apexDevToolbarHome').closest('li').addClass('u-hidden');

    }

    function builderMenuButton() {

        // Add View Debug
        $('#apexDevToolbarHome').parent().before(
            '<li roles="none"><button type="button" class="a-Button a-Button--devToolbar" id="apexDevToolbarPdtStartMenu" title="PDT Start Menu" aria-label="PDT Start Menu" data-menu="pdtStartMenu"><span class="fa fa-bars" aria-hidden="true"></span></button></li>'
        );

        $('body').append('<div id="pdtStartMenu" class="a-DevToolbar-menu a-Menu" role="menu"></div>');


        var appBuilder = {
            type: "subMenu", icon: 'fa fa-database-application', label: 'App Builder',
            menu: {
                items: [
                    { type: "action", label: "App Builder", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/apps?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "separator" },
                    { type: "action", label: "Create", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/create-application?fb_flow_id=&fb_flow_page_id=&clear=56,103,104,106,130,131,35,227,3020,3000,3001&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "Import", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/import?p460_file_type=FLOW_EXPORT&clear=460&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "Export", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/exportapp?fb_flow_id=&fb_flow_page_id=&clear=4900&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    {
                        type: "subMenu", label: 'Workspace Utilities',
                        menu: {
                            items: [
                                { type: "action", label: "All Workspace Utilities", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/workspace-utilities?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "separator" },
                                { type: "action", label: "Workspace Themes", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/workspace-themes?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Groups", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/application-groups?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Oracle APEX Views", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/apex-views?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Cross Application Reports", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/cross-application-reports?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    { type: "separator" },
                    { type: "action", label: "Gallery", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/gallery/apps?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                ]
            }
        };

        var sqlWorkshop =
        {
            type: "subMenu", icon: 'fa fa-database', label: 'SQL Workshop',
            menu: {
                items: [
                    { type: "action", label: "SQL Workshop", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/sql-workshop?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "separator" },
                    { type: "action", label: "Object Browser", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/ob?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "SQL Commands", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/sqlcommandprocessor?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "SQL Scripts", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/sql-scripts?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    {
                        type: "subMenu", label: 'Utilities',
                        menu: {
                            items: [
                                { type: "action", label: "All Utilities", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/utilities?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "separator" },
                                { type: "action", label: "Data Workshop", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/data-workshop/data-load-unload?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Data Generator", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/blueprints?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Query Builder", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/querybuilder?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Quick SQL", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/quick-sql?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Sample Datasets", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/data-workshop/select-sample-dataset?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Generate DDL", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/generate-ddl?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "UI Defaults", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/ui-defaults?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Schema Comparison", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/schema-comparison?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Methods on Tables", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/create-package-on-a-table?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Recycle Bin", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/recycle-bin?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Object Reports", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/object-reports?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    { type: "action", label: "RESTful Services", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/restful-services?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "SQL Developer Web", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/sql-workshop/sql-developer-web?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                ]
            }
        };

        var teamDevelopment = {
            type: "subMenu", icon: 'fa fa-users', label: 'Team Development', menu: {
                items: [
                    { type: "action", label: "Team Development", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/team-development/welcome-page?clear=10&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "separator" },
                    { type: "action", label: "Labels", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/team-development/labels?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "Milestones", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/team-development/milestones?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "Templates", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/team-development/templates?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "action", label: "Utilities", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/team-development/utilities?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "separator" },
                    { type: "action", label: "Feedback", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/feedback/feedback-dashboard?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                ]
            }
        };

        var debugMenu =
        {
            type: "subMenu",
            icon: 'fa fa-bug',
            label: 'Debug',
            menu: {
                items: [
                    {
                        type: "subMenu",
                        label: "Current Debug Level",
                        menu: {
                            items: [{
                                type: "radioGroup",
                                get: function () {
                                    return pdt.nvl(apex.item('pdebug').getValue(), 'NO');
                                },
                                set: function (pValue) {
                                    parent.$("#apexDevToolbarDebugMenu")?.menu("instance")?.options?.items?.[0]?.menu?.items?.[0]?.set?.(pValue);
                                },
                                choices: [
                                    { label: 'No Debug', value: "NO" },
                                    { label: 'Info (default)', value: "YES" },
                                    { label: 'App Trace', value: "LEVEL6" },
                                    { label: 'Full Trace', value: "LEVEL9" }
                                ]
                            }]
                        }
                    },
                    {
                        type: "action",
                        label: "View Debug",
                        action: function () {
                            parent.$("#apexDevToolbarDebugMenu")?.menu("instance")?.options?.items?.[1]?.action?.();
                        }
                    }
                ],
                beforeOpen: function () {
                    menuOpen = true;
                }
            }
        };

        var administration =
        {
            type: "subMenu",
            icon: 'fa fa-cogs',
            label: "Administration",
            menu: {
                items: [
                    {
                        type: "action",
                        label: "Administration",
                        action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/administration?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                    },
                    { type: "separator" }, // Separator in the menu
                    {
                        type: "subMenu",
                        label: "Manage Service",
                        menu: {
                            items: [
                                {
                                    type: "action",
                                    label: "Manage Service",
                                    action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/manage-service?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                                },
                                { type: "separator" }, // Separator in the menu
                                {
                                    type: "action",
                                    label: "Set Workspace Preferences",
                                    action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/set-workspace-preferences?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                                },
                                {
                                    type: "action",
                                    label: "Define Workspace Message",
                                    disabled: true,
                                    action: function () { apex.navigation.dialog('/ords/r/apex/workspace-admin/workspace-message?session=' + pdt.pretiusToolbar.getBuilderSessionid(), { title: 'Workspace Message', height: '320', width: '500', maxWidth: '1200', modal: true }); }
                                },
                                {
                                    type: "action",
                                    label: "Define Environment Banner",
                                    disabled: true,
                                    action: function () { apex.navigation.dialog('/ords/r/apex/workspace-admin/environment-banner?session=' + pdt.pretiusToolbar.getBuilderSessionid(), { title: 'Workspace Environment Banner', height: '480', width: '640', maxWidth: '1200', modal: true }); }
                                },
                                {
                                    type: "action",
                                    label: "Workspace Utilization",
                                    action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/workspace-utilization?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                                },
                                {
                                    type: "action",
                                    label: "Manage Extension Links",
                                    action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/links?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                                }
                            ]
                        }
                    },
                    {
                        type: "action",
                        label: "Manage Users and Groups",
                        action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/manage-users?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                    },
                    {
                        type: "action",
                        label: "Monitor Activity",
                        action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/monitor-activity?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                    },
                    {
                        type: "action",
                        label: "Dashboards",
                        action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace-admin/workspace-dashboard?session=' + pdt.pretiusToolbar.getBuilderSessionid()); }
                    },
                    {
                        type: "action",
                        label: "Change My Password",
                        disabled: true,
                        action: function () { apex.navigation.dialog('/ords/r/apex/workspace-admin/edit-profile?clear=3&session=' + pdt.pretiusToolbar.getBuilderSessionid(), { title: 'Edit Profile', height: '550', width: '600', maxWidth: '1200', modal: true }); }
                    }
                ]
            }
        };

        var sharedComponents =
        {
            type: "subMenu", icon: 'fa fa-shapes', label: 'Shared Components',
            menu: {
                items: [
                    { type: "action", icon: 'fa fa-shapes', label: "Shared Components", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/shared-components?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                    { type: "separator" },
                    {
                        type: "subMenu", icon: 'fa fa-cogs', label: 'Application Logic',
                        menu: {
                            items: [
                                { type: "action", label: "Application Definition", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/edit-application-definition?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Items", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/application-items?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Processes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/application-processes?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Computations", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/application-computations?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Settings", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/application-settings?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Build Options", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/build-options?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-key', label: 'Security',
                        menu: {
                            items: [
                                { type: "action", label: "Security Attributes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/edit-security-attributes?fb_flow_id=' + pdt.opt.env.APP_ID + '&509_fb_upd_id=' + pdt.opt.env.APP_ID + '&clear=509&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Authentication Schemes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/authentication-schemes?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Authorization Schemes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/authorization-schemes?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Access Control", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/application-access-control?clear=RP,2300&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Session State Protection", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/session-state-protection?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-cubes', label: 'Other Components',
                        menu: {
                            items: [
                                { type: "action", label: "Lists of Values", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/lists-of-values?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Plug-ins", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/plug-ins?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Component Settings", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/component-settings?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Shortcuts", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/shortcuts?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Map Backgrounds", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/map-backgrounds?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Component Groups", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/component-groups?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-compass', label: 'Navigation and Search',
                        menu: {
                            items: [
                                { type: "action", label: "Lists", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/lists?clear=RIR&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Navigation Menu", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/lists?ir_is_navmenu=1&clear=RIR&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Breadcrumbs", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/breadcrumbs?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Navigation Bar List", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/lists?ir_is_navbar=1&clear=RIR&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Search Configurations", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/search-configuration?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-desktop', label: 'User Interface',
                        menu: {
                            items: [
                                { type: "action", label: "User Interface Attributes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/edit-user-interface?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Progressive Web App", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/edit-progressive-web-app?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Themes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/themes?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Templates", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/templates?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Email Templates", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/email-templates?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-file-text-o', label: 'Files and Reports',
                        menu: {
                            items: [
                                { type: "action", label: "Static Application Files", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/static-application-files?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Static Workspace Files", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/static-workspace-files?clear=RP&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Report Layouts", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/report-layouts?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Report Queries", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/report-queries?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-database', label: 'Data Sources',
                        menu: {
                            items: [
                                { type: "action", label: "Data Load Definitions", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/data-load-definitions?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "REST Enabled SQL", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/rest-enabled-sql?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "REST Data Sources", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/rest-data-sources?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "REST Synchronization", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/rest-synchronizations?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-cog', label: 'Workflows and Automations',
                        menu: {
                            items: [
                                { type: "action", label: "Task Definitions", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/task-definitions?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Automations", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/automations?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Workflows", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/app-builder/workflows?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", icon: 'fa fa-globe', label: 'Globalization',
                        menu: {
                            items: [
                                { type: "action", label: "Globalization Attributes", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/edit-globalization-attributes?fb_flow_id=' + pdt.opt.env.APP_ID + '&clear=506&session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Text Messages", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/text-messages?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
                                { type: "action", label: "Application Translations", action: function () { pdt.pretiusToolbar.openDevbarSCMenuEntry('r/apex/app-builder/translate-application?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } }
                            ]
                        }
                    }
                ]
            }
        };

        const shortcutsMenu = {
            type: "subMenu",
            label: "APEX Resources",
            icon: 'fa fa-external-link',
            menu: {
                items: [
                    {
                        type: "subMenu", label: "General", menu: {
                            items: [
                                { type: "action", label: "APEX Community Technical Discussion Forum", action: function () { window.open('https://apex.oracle.com/forum') } },
                                { type: "action", label: "APEX Events", action: function () { window.open('https://apex.oracle.com/go/events') } },
                                { type: "action", label: "APEX Ideas App", action: function () { window.open('https://apex.oracle.com/ideas') } },
                                { type: "action", label: "Accessibility", action: function () { window.open('https://apex.oracle.com/accessibility') } },
                                { type: "action", label: "Architecture", action: function () { window.open('https://apex.oracle.com/architecture') } },
                                { type: "action", label: "Autonomous Database", action: function () { window.open('https://apex.oracle.com/go/adb-updates') } },
                                { type: "action", label: "Blog", action: function () { window.open('https://apex.oracle.com/blog') } },
                                { type: "action", label: "Community", action: function () { window.open('https://apex.oracle.com/community') } },
                                { type: "action", label: "Download", action: function () { window.open('https://apex.oracle.com/download') } },
                                { type: "action", label: "Font APEX", action: function () { window.open('https://apex.oracle.com/fontapex') } },
                                { type: "action", label: "Graphics", action: function () { window.open('https://apex.oracle.com/go/graphics') } },
                                { type: "action", label: "Office Hours", action: function () { window.open('https://apex.oracle.com/officehours') } },
                                { type: "action", label: "Presentations", action: function () { window.open('https://apex.oracle.com/presentations') } },
                                { type: "action", label: "Quick SQL", action: function () { window.open('https://apex.oracle.com/quicksql') } },
                                { type: "action", label: "Quotes", action: function () { window.open('https://apex.oracle.com/quotes') } },
                                { type: "action", label: "Roadmap (Statement of Direction)", action: function () { window.open('https://apex.oracle.com/roadmap') } },
                                { type: "action", label: "Shortcuts", action: function () { window.open('https://apex.oracle.com/shortcuts') } },
                                { type: "action", label: "Success Stories", action: function () { window.open('https://apex.oracle.com/success') } },
                                { type: "action", label: "Universal Theme", action: function () { window.open('https://apex.oracle.com/ut') } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", label: "Documentation", menu: {
                            items: [
                                { type: "action", label: "JavaScript API Documentation", action: function () { window.open('https://apex.oracle.com/jsapi') } },
                                { type: "action", label: "Latest Release Documentation", action: function () { window.open('https://apex.oracle.com/doc') } },
                                { type: "action", label: "PL/SQL API Documentation", action: function () { window.open('https://apex.oracle.com/api') } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", label: "Learning", menu: {
                            items: [
                                { type: "action", label: "Books", action: function () { window.open('https://apex.oracle.com/books') } },
                                { type: "action", label: "Certification Exam", action: function () { window.open('https://apex.oracle.com/certification') } },
                                { type: "action", label: "Education", action: function () { window.open('https://apex.oracle.com/education') } },
                                { type: "action", label: "Hands On Labs", action: function () { window.open('https://apex.oracle.com/hols') } },
                                { type: "action", label: "Learn More", action: function () { window.open('https://apex.oracle.com/learnmore') } },
                                { type: "action", label: "Low Code", action: function () { window.open('https://apex.oracle.com/lowcode') } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", label: "Sample Apps", menu: {
                            items: [
                                { type: "action", label: "APEX to Go", action: function () { window.open('https://apex.oracle.com/go/apextogo') } },
                                { type: "action", label: "Cards", action: function () { window.open('https://apex.oracle.com/go/sample_cards') } },
                                { type: "action", label: "Charts", action: function () { window.open('https://apex.oracle.com/go/sample_charts') } },
                                { type: "action", label: "Maps", action: function () { window.open('https://apex.oracle.com/go/sample_maps') } },
                                { type: "action", label: "PWA", action: function () { window.open('https://apex.oracle.com/go/pwa') } }
                            ]
                        }
                    },
                    {
                        type: "subMenu", label: "Social Media", menu: {
                            items: [
                                { type: "action", label: "Facebook", action: function () { window.open('https://apex.oracle.com/facebook') } },
                                { type: "action", label: "LinkedIn", action: function () { window.open('https://apex.oracle.com/linkedin') } },
                                { type: "action", label: "Twitter", action: function () { window.open('https://apex.oracle.com/twitter') } },
                                { type: "action", label: "YouTube", action: function () { window.open('https://apex.oracle.com/youtube') } }
                            ]
                        }
                    }, 
                    { type: "separator" },
                    {
                        type: "subMenu",
                        label: 'Pretius',
                        menu: {
                            items: [
                                { type: "action", label: "Pretius", action: () => window.open('https://pretius.com', '_blank') },
                                { type: "separator" },
                                { type: "action", label: "Services", action: () => window.open('https://pretius.com/services/', '_blank') },
                                { type: "action", label: "Clients", action: () => window.open('https://pretius.com/clients/', '_blank') },
                                { type: "action", label: "About us", action: () => window.open('https://pretius.com/about-us/', '_blank') },
                                { type: "action", label: "Career", action: () => window.open('https://pretius.com/pl/praca/', '_blank') },
                                { type: "action", label: "Blog", action: () => window.open('https://pretius.com/blog/', '_blank') },
                                { type: "action", label: "Contact us", action: () => window.open('https://pretius.com/contact-us/', '_blank') }
                            ]
                        }
                    }
                ]
            }
        };

        const itemsArray = [
            { type: "action", label: "Oracle APEX Home", icon: "fa fa-home", action: function () { pdt.pretiusToolbar.openDevbarMenuEntry('r/apex/workspace/home?session=' + pdt.pretiusToolbar.getBuilderSessionid()) } },
            shortcutsMenu,
            appBuilder,
            sqlWorkshop,
            teamDevelopment,
            administration
        ];

        if (pdt.getSetting('devbar.oldschooldebugenable') == 'Y') {
            itemsArray.push(debugMenu);
        }  

       itemsArray.push(sharedComponents);

        $('#pdtStartMenu').menu({
            items: itemsArray
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