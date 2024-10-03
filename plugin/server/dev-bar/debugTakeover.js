function executeInIframe(frameId, script) {
    var iframe = document.getElementById(frameId);
    if (iframe && iframe.contentWindow) {
        iframe.contentWindow.eval(script);
    } else {
        console.error('Iframe not found or not accessible');
    }
}

function init() {
    const pdtDebugRevealerFooterHTML = `
        <div class="pdtDebugRevealerFooter" id="pdtDebugRevealerFooterStatic" style="display:none"></div>
        <div class="pdtDebugRevealerFooter pdtDebugRevealerFooter-Light" id="pdtDebugRevealerFooterLoadStatic">
            <span class="pdtDebugRevealerLink">
                If you still see this message after 10 seconds, check you have 
                <a href="https://chrome.google.com/webstore/detail/ignore-x-frame-headers/gleekbfjekiniecknbkamfmkohkpodhe" target="_blank">Ignore X-Frame headers</a> installed
            </span>
        </div>`;

    // Create and append the top iframe
    const iframeTop = document.createElement('iframe');
    iframeTop.src = document.pViewDebugURL;
    iframeTop.id = "iframeTop";
    
    document.querySelector('.first-row')?.appendChild(iframeTop) ||
    console.error('Container not found');

    // Function to handle iframe load and execute script
    function onIframeLoad(iframeId, script) {
        const iframe = document.getElementById(iframeId);
        iframe.addEventListener('load', () => executeInIframe(iframeId, script));
    }

    // Handle messages from the iframe
    window.addEventListener('message', (event) => {
        const data = event.data;
        switch (data.pMode) {
            case "pdtLoadDebugDetail":
                document.querySelector('.first-row')?.classList.remove('full-row');
                
                document.getElementById('pdtDebugRevealerFooterLoadStatic')?.remove();
                document.getElementById('iframeBottom')?.remove();

                const iframeBottom = document.createElement('iframe');
                iframeBottom.src = data.pHref;
                iframeBottom.frameBorder = 0;
                iframeBottom.id = "iframeBottom";
                document.querySelector('.second-row')?.appendChild(iframeBottom);

                onIframeLoad('iframeBottom', `
                    document.querySelector('.a-TabsContainer')?.remove();
                    $([document.documentElement, document.body]).animate({
                        scrollTop: $(".a-IRR-fullView").offset().top
                    }, 0);
                `);
                break;

            case "pIframeFull":
                document.getElementById('iframeBottom')?.remove();
                document.querySelector('.first-row')?.classList.add('full-row');
                break;
        }
    });

    // Determine the minified directory and file suffix based on debug mode
    const isDebugMode = document.pDebugMode === 'true';
    const vMinDir = isDebugMode ? '' : 'minified/';
    const vMin = isDebugMode ? '' : '.min';

    onIframeLoad('iframeTop', `
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = '${document.pLocation}dev-bar/${vMinDir}debugTakeoverMaster${vMin}.js';
        document.head.appendChild(script);
    `);

    // Add the footer
    const container = document.getElementById("row-div-seperator");
    if (container) {
        const footerElement = document.createElement('div');
        footerElement.innerHTML = pdtDebugRevealerFooterHTML;
        container.insertBefore(footerElement, container.firstChild);
    } else {
        console.error('Footer container not found');
    }
}

init();
