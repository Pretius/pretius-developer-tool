pdt.contentBuildOptionHighlight = (function () {
    "use strict";

    var fadeOutDuration;

    function fadeInFadeOut(itemName, pStatus, pSuffix) {

        var colourCode = 194;

        if (pStatus == 'Exclude') {
            colourCode = 0;
        }

        $('#' + itemName + pSuffix).addClass('pretiusDeveloperToolRegionPadding');
        var d = 0;
        for (var i = 100; i >= 50; i = i - 0.1) { //i represents the lightness
            d += 3;
            (function (ii, dd) {
                setTimeout(function () {
                    $('#' + itemName + pSuffix).css('filter', 'drop-shadow( 1px 1px 6px hsl(' + colourCode + ',100%,' + ii + '%)');
                }, dd);
            })(i, d);
        }

        var d = fadeOutDuration;  

        if (d > 0) {
            for (var i = 50; i <= 100; i = i + 0.1) { //i represents the lightness
                d += 3;
                (function (ii, dd) {
                    setTimeout(function () {
                        $('#' + itemName + pSuffix).css('filter', 'drop-shadow( 1px 1px 6px hsl(' + colourCode + ',100%,' + ii + '%)');
                        if (ii >= 99) {
                            $('#' + itemName + pSuffix).removeClass('pretiusDeveloperToolRegionPadding');
                        }
                    }, dd);
                })(i, d);
            }
        }
    }

    function activate() {

        fadeOutDuration = pdt.getSetting('buildoptionhightlight.duration');
        if ( !isNaN(fadeOutDuration) ){
            // number
            fadeOutDuration = Number( fadeOutDuration ) * 1000;
        } else {
            // Not a number
            fadeOutDuration = 6000; // Default
        };

        pdt.cloakDebugLevel();

        apex.server.plugin(pdt.opt.ajaxIdentifier, {
            x01: 'BUILD_OPTION_EXCLUDED'
        }, {
            success: function (data) {
                pdt.unCloakDebugLevel();
                highlight(data.items);
            }
            ,
            error: function (jqXHR, textStatus, errorThrown) {
                // handle error
                pdt.unCloakDebugLevel();
                pdt.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
            }
        });

    }

    function highlight(pSelectors) {
        for (var i = 0; i < pSelectors.length; i++) {
            var itemName = pSelectors[i].ITEM_NAME;
            var itemStatus = pSelectors[i].STATUS;
            var itemType = pSelectors[i].PAGE_ITEM_TYPE;
            var suffix = '';

            if (itemType == 'ITEM') {
                suffix = '_CONTAINER';
            }

            fadeInFadeOut(itemName, itemStatus, suffix);

        }
    }

    return {
        activate: activate
    }

})();