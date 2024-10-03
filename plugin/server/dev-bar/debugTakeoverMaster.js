// Dispatch a custom event with optional focus prevention
function dispatchCustomEvent(preventFocus) {
    const event = new CustomEvent('pdtInlineEventForSwitch', { detail: { preventFocus } });
    document.dispatchEvent(event);
}

// Send a message to the parent window
function sendMessageToParent(pHref) {
    window.parent.postMessage({ pMode: "pdtLoadDebugDetail", pHref }, '*');
}

// Handle link click and focus logic
function handleLinkClick(event, href, selectedClass) {
    document.querySelectorAll('.pdtViewIdentifer').forEach(el => {
        el.classList.remove(selectedClass, 'pdtViewIdentifer');
    });

    event.target.classList.add('pdtViewIdentifer', selectedClass);
    sendMessageToParent(href);
}

// Initialize the links and click handlers
function initializeLinks(preventFocus) {
    const selectedClass = 'u-color-1-text';
    const viewIdentifierHeader = Array.from(document.querySelectorAll('.a-IRR-headerLink'))
        .find(el => el.textContent.trim() === 'View Identifier')
        ?.getAttribute('data-column');

    if (!viewIdentifierHeader) return;

    document.querySelectorAll(`td[headers="C${viewIdentifierHeader}"]`).forEach((cell, index) => {
        const link = cell.querySelector('a');
        if (!link) return;

        const href = link.getAttribute('href');
        cell.setAttribute('takeoverHref', href);
        link.removeAttribute('href');
        link.style.cursor = 'pointer';

        link.addEventListener('click', event => handleLinkClick(event, href, selectedClass));

        if (index === 0 && !preventFocus) {
            document.querySelectorAll('.pdtViewIdentifer').forEach(el => {
                el.classList.remove(selectedClass, 'pdtViewIdentifer');
            });
            link.classList.add('pdtViewIdentifer', selectedClass);
            sendMessageToParent(href);
        }
    });
}

// Initialize the page only if on the Master Detail page
function init() {
    if (apex.env.APP_PAGE_ID !== '19') return;

    document.addEventListener('pdtInlineEventForSwitch', event => {
        initializeLinks(event.detail.preventFocus);
    });

    // Scroll to the top
    $([document.documentElement, document.body]).animate({
        scrollTop: $(".a-IRR-tableContainer").offset().top - 1
    }, 0);
    

    // Extend NodeList prototype to get text content only
    NodeList.prototype.justtext = function() {
        return Array.from(this).map(el => el.cloneNode(true).textContent.trim()).join('');
    };

    document.querySelectorAll('ul.a-Tabs li').forEach(tab => {
        tab.addEventListener('click', () => {
            window.parent.postMessage({ pMode: "pIframeFull" }, '*');
        });
    });

    // Reapply links on refresh
    $(".a-IRR-region").on("apexafterrefresh", function () {
        dispatchCustomEvent(true);
    });
        

    // Apply links on initial load
    dispatchCustomEvent();
}

// Initialize the script
init();
