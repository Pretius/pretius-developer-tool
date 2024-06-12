pdt.pretiusToolbar = (function () {
    "use strict";

    const nav = apex.navigation,
        message = apex.message,
        BUILDER_WINDOW_NAME = 'APEX_BUILDER',
        DEVELOPER_TOOLBAR_NO_BUILDER = apex.lang.getMessage(
            'DEVELOPER_TOOLBAR_NO_BUILDER'
        ),
        BUILDER_REGEX = /f?p=4\d\d\d:/,
        FLOW_REGEX = /^4\d\d\d$/;
    function isBuilderWindow(wnd) {
        return wnd.name && wnd.name.match('^' + BUILDER_WINDOW_NAME);
    }
    function getBuilderInstance() {
        var builderWindow = getApexBuilderFromOpenerChain(window);
        if (builderWindow) {
            return builderWindow.document.getElementById('pInstance').value;
        }
        return null;
    }
    function getApexBuilderFromOpenerChain(wnd) {
        if (isBuilderWindow(wnd)) {
            return null;
        }
        try {
            if (
                wnd.opener &&
                !wnd.opener.closed &&
                wnd.opener.apex &&
                wnd.opener.apex.jQuery
            ) {
                if (
                    wnd.opener.location.href.match(/f?p=4\d\d\d:/) ||
                    wnd.opener.document.getElementById('pFlowId').value.match(/^4\d\d\d$/)
                ) {
                    return wnd.opener;
                } else {
                    return getApexBuilderFromOpenerChain(wnd.opener);
                }
            }
        } catch (ex) {
            return null;
        }
        return null;
    }
    function navigateInPageDesigner(appId, pageId, typeId, componentId, errorFn) {
        var builderWindow = getApexBuilderFromOpenerChain(window);
        if (builderWindow && builderWindow.pageDesigner) {
            builderWindow.pageDesigner.setPageSelection(
                appId,
                pageId,
                typeId,
                componentId,
                function (result) {
                    if (result !== 'OK' && result !== 'PAGE_CHANGE_ABORTED') {
                        errorFn();
                    }
                }
            );
            nav.openInNewWindow('', BUILDER_WINDOW_NAME, {
                altSuffix: getBuilderInstance(),
            });
        } else {
            errorFn();
        }
    }
    function findBuilderWindow(w) {
        if (w.name && w.name.match('^' + BUILDER_WINDOW_NAME)) {
            return null;
        }
        try {
            if (
                w.opener &&
                !w.opener.closed &&
                w.opener.apex &&
                w.opener.apex.jQuery
            ) {
                if (
                    BUILDER_REGEX.test(w.opener.location.href) ||
                    FLOW_REGEX.test(w.opener.document.getElementById('pFlowId').value)
                ) {
                    return w.opener;
                } else {
                    return findBuilderWindow(w.opener);
                }
            }
        } catch (ex) {
            return null;
        }
        return null;
    }
    function getBuilderInstanceId() {
        var builder = findBuilderWindow(window);
        return builder ? builder.document.getElementById('pInstance').value : null;
    }
    function openBuilderWindow(url) {
        if (window.name === BUILDER_WINDOW_NAME) {
            nav.redirect(url);
        } else if (!getBuilderInstanceId()) {
            message.confirm(DEVELOPER_TOOLBAR_NO_BUILDER, (ok) => {
                if (ok) {
                    window.name = '';
                    nav.redirect(url);
                }
            });
        } else {
            nav.openInNewWindow(url, BUILDER_WINDOW_NAME, {
                altSuffix: getBuilderInstanceId(),
            });
        }
    }
    function openBuilder(pAppID, pPageID, pWindow) {
        var url = $('#apexDevToolbarPage').attr('data-link');

        // Replace the f values with pAppID and pPageID
        url = url.replace(/(fb_flow_id=)[^&]*/, '$1' + pAppID);
        url = url.replace(/(fb_flow_page_id=)[^&]*/, '$1' + pPageID);
        url = url.replace(/(f4000_p1_flow=)[^&]*/, '$1' + pAppID);
        url = url.replace(/(f4000_p1_page=)[^&]*/, '$1' + pPageID);

        if (pWindow) {
            nav.openInNewWindow(url);
        } else {
            navigateInPageDesigner(pAppID, pPageID, null, null, function () {
                openBuilderWindow(url);
            });
        }
    }

    function getBuilderSessionid() {
        var url = window.$('#apexDevToolbarPage').attr('data-link');

        // Extract session ID from the URL using regular expression
        const sessionId = url.match(/[?&]session=(\d+)/)?.[1];

        return sessionId;
    }


    function openSharedComponents(pWindow) {
        // Get the URL from the data attribute of an element with the ID 'apexDevToolbarPage'
        var url = $('#apexDevToolbarPage').attr('data-link');
        const sessionId = getBuilderSessionid();

        // Replace everything after '/page-designer' with '/shared-components' in the URL
        // and append the session ID to the modified URL
        url = url.replace(/\/page-designer[\s\S]*/, '/shared-components') + `?session=${sessionId}` + 
             '&FB_FLOW_ID=' + pdt.opt.env.APP_ID +
             '&FB_FLOW_PAGE_ID=' + pdt.opt.env.APP_PAGE_ID;

        if (pWindow) {
            nav.openInNewWindow(url);
        } else {
            openBuilderWindow(url);
        }

    }
    return {
        openBuilder: openBuilder,
        openSharedComponents: openSharedComponents,
        getBuilderSessionid: getBuilderSessionid
    };
})();
