var pretiusRevealer = (function () {
    "use strict";

    var _table_ = document.createElement('table'),
        _tr_ = document.createElement('tr'),
        _th_ = document.createElement('th'),
        _td_ = document.createElement('td');

    _table_.className = 'tableTablockVars';
    _tr_.className = 'dataRow';
    _th_.className = 't-Report-colHead';
    _td_.className = 'tdTablockVars';

    // Builds the HTML Table out of myList json data.
    function buildHtmlTable(arr) {
        var table = _table_.cloneNode(false),
            columns = addAllColumnHeaders(arr, table);
        for (var i = 0, maxi = arr.length; i < maxi; ++i) {
            var tr = _tr_.cloneNode(false);
            for (var j = 0, maxj = columns.length; j < maxj; ++j) {
                var td = _td_.cloneNode(false);
                var cellValue = arr[i][columns[j]];
                td.appendChild(document.createTextNode(arr[i][columns[j]] || ''));
                tr.appendChild(td);
            }
            table.appendChild(tr);
        }
        return table;
    }

    // Adds a header row to the table and returns the set of columns.
    // Need to do union of keys from all records as some records may not contain
    // all records
    function addAllColumnHeaders(arr, table) {
        var columnSet = [],
            tr = _tr_.cloneNode(false);
        for (var i = 0, l = arr.length; i < l; i++) {
            for (var key in arr[i]) {
                if (arr[i].hasOwnProperty(key) && columnSet.indexOf(key) === -1) {
                    columnSet.push(key);
                    var th = _th_.cloneNode(false);
                    th.appendChild(document.createTextNode(key));
                    tr.appendChild(th);
                }
            }
        }
        table.appendChild(tr);
        return columnSet;
    }

    function distinctPages(arr) {
        // Gets Distinct Pages
        var lookup = {};
        var items = arr;
        var result = [];
        for (var item, i = 0; item = items[i++];) {
            var name = item.Page;

            if (!(name in lookup)) {
                lookup[name] = 1;
                result.push(name);
            }
        }
        return result.reverse();
    }

    function customiseTable() {

        $("#pretiusRevealerInline tr.dataRow").each(function () {

            var $this = $(this);
            var cName = $this.find("td:nth-child(2)");
            var cCategory = $this.find("td:nth-child(3)");
            var cCategoryH = $this.find("td:nth-child(3)").html();
            var lastChildH = $this.find("td:last-child").html();

            // Hidden = Bold
            if ((!cName.hasClass("pretiusRevealerAttention")) && (typeof (cCategoryH) != 'undefined' && cCategoryH.toString().startsWith("HIDDEN"))) {
                cName.addClass("pretiusRevealerAttention");
            }

            // Non Rendered = Bold
            if ((!cName.hasClass("pretiusRevealerNonRendered")) && (typeof (lastChildH) != 'undefined' && lastChildH.toString().includes("NR"))) {
                cName.addClass("pretiusRevealerNonRendered");
                cName.attr('title', 'Non-Rendered Item');
            }

        });

    }

    function distinctGroups(pPage) {
        var result = [];
        var categoryArray = ["PX", "PI", "P0", "PO", "IR", "IG", "AI", "SB", "CX", "FW", "AP", "ALL"];
        var chkSBox = $('#pretiusRevealerInline #rSearchBox').val().toUpperCase();

        $("#pretiusRevealerInline .notification-counter").text('');
        $("#pretiusRevealerInline .notification-counter").removeClass("notification-counter");

        function getCount(pCate) {
            var totalCate = 0;
            $("#pretiusRevealerInline tr.dataRow").each(function () {

                var $this = $(this);
                var tdPage = $this.find("td:first").html();
                var tdCate = $this.find("td:last").html();
                var tdNameValues = $this.find("td:nth-child(2)").html() + ' ' +
                    $this.find("td:nth-child(3)").html() + ' ' +
                    $this.find("td:nth-child(4)").html() + ' ' +
                    $this.find("td:nth-child(5)").html();
                tdNameValues = tdNameValues.toString().toUpperCase();

                if (([pPage, '*'].indexOf(tdPage) > -1 || pPage == 'All') &&
                    typeof (tdCate) != 'undefined' &&
                    tdCate.split(",").indexOf(pCate) >= 0 &&
                    (tdNameValues.indexOf(chkSBox) !== -1)
                ) {
                    totalCate = totalCate + 1;
                }

                if (([pPage, '*'].indexOf(tdPage) > -1 || pPage == 'All')
                    && pCate == 'ALL' &&
                    typeof (tdCate) != 'undefined' &&
                    tdCate != 'Category' &&
                    (tdNameValues.indexOf(chkSBox) !== -1)
                ) {
                    totalCate = totalCate + 1;
                }
            });

            return totalCate;
        }

        for (var i = 0; i < categoryArray.length; i++) {
            var c = categoryArray[i];
            var cateCount = getCount(c);
            if (cateCount > 0) {
                $("#pretiusRevealerInline #" + c + "counter").addClass("notification-counter").text(cateCount);
            }
        }

        return result;
    }

    function pageDelimeted() {
        var pageDelimeted = $("#pretiusRevealerInline input[type=radio][name=pFlowStepId]:checked").val();
        if (pageDelimeted == 'All') {
            pageDelimeted = $('#pretiusRevealerInline #pretiusPageControls').attr('justPages');
        }
        else {
            pageDelimeted = ':' + pageDelimeted + ':';
        }
        return pageDelimeted;
    }

    function getDebugViewContent() {

        // deactivate debug when revealer getting data
        $('#pretiusRevealerInline #rSearchBox').val('');
        pdt.cloakDebugLevel();

        apex.server.plugin(pdt.opt.ajaxIdentifier, {
            x01: 'DEBUG_VIEW',
            x02: pageDelimeted()
        }, {
            success: function (data) {
                pdt.unCloakDebugLevel();
                $('#pretiusRevealerInline #pretiusDebugContent').empty();
                $('#pretiusRevealerInline #pretiusDebugContent').append(pretiusRevealer.buildHtmlTable(data.items));
                rowStrokes();

                // https://stackoverflow.com/a/6155322
                // Get first column
                $("#pretiusRevealerInline #pretiusDebugContent .tdTablockVars:first-child").each(function (eIdx) {

                    var a = $(this);
                    $(a).addClass('linkLike');

                    if (a) {
                        a.on("click", function (event) {
                            getDebugViewDetail($(a).text());
                        });
                    }

                });

                performFilter();

            },
            error: function (jqXHR, textStatus, errorThrown) {
                // handle error
                pdt.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
            }
        });

    }


    function getDebugViewDetail(pViewIdentifier) {

        $('#pretiusRevealerInline #rSearchBox').val('');
        pdt.cloakDebugLevel();

        apex.server.plugin(pdt.opt.ajaxIdentifier, {
            x01: 'DEBUG_DETAIL',
            x02: pViewIdentifier
        }, {
            success: function (data) {
                pdt.unCloakDebugLevel();
                $('#pretiusRevealerInline #pretiusDebugContent').empty();
                $('#pretiusRevealerInline #pretiusDebugContent').append(pretiusRevealer.buildHtmlTable(data.items));
                rowStrokes(); 
            },
            error: function (jqXHR, textStatus, errorThrown) {
                // handle error
                pdt.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
            }
        });

    }

    function rowStrokes() {
        // Add Alternate Row strokes
        $('#pretiusRevealerInline .alternate-rows-tl').removeClass('alternate-rows-tl');
        $('#pretiusRevealerInline .tableTablockVars tr').filter(function () {
            return $(this).css('visibility') == 'visible';
        }).filter(':odd').addClass('alternate-rows-tl');
    }

    function performFilter() {

        var hidePageValueFor = ["SB", "CX", "AI", "AP"];
        var hideSessionValueFor = ["FW", "IR", "IG"];
        var jqPrefex = '';

        var chkPage = $("#pretiusRevealerInline input[type=radio][name=pFlowStepId]:checked").val();
        var chkCate = $("#pretiusRevealerInline input[type=radio][name=pCategory]:checked").val();
        var chkSBox = $('#pretiusRevealerInline #rSearchBox').val().toUpperCase();

        var PageSelectedAbove = $("label[for='PageSelectedAbove']");
        PageSelectedAbove.html("P" + chkPage.split("_")[0] + '<span id="PXcounter"></span>');
        PageSelectedAbove.removeClass('switch-display-none');

        $('#pretiusRevealerInline table.tableTablockVars tr th').show();
        $('#pretiusRevealerInline table.tableTablockVars tr td').show();

        if (chkCate == 'DebugPage') {
            jqPrefex = '#pretiusRevealerInline #pretiusDebugContent';
            $('#pretiusRevealerInline #pretiusContent').hide();
            $(jqPrefex).show();
        } else {
            jqPrefex = '#pretiusRevealerInline #pretiusContent';
            $(jqPrefex).show();
            $('#pretiusRevealerInline #pretiusDebugContent').hide();
        }


        if (chkPage == 'All') {
            PageSelectedAbove.addClass('switch-display-none');
            if (chkCate == 'PX') {
                $("#pretiusRevealerInline input[type=radio][name=pCategory]:first").trigger("click");
                return;
            }
        }

        if (hidePageValueFor.includes(chkCate)) {
            $('#pretiusRevealerInline table.tableTablockVars tr th:nth-child(4)').hide();
            $('#pretiusRevealerInline table.tableTablockVars tr td:nth-child(4)').hide();
        }

        if (hideSessionValueFor.includes(chkCate)) {
            $('#pretiusRevealerInline table.tableTablockVars tr th:nth-child(5)').hide();
            $('#pretiusRevealerInline table.tableTablockVars tr td:nth-child(5)').hide();
        }

        $(jqPrefex + " tr.dataRow:not(:first)").css("visibility", "collapse");
        $(jqPrefex + " tr.dataRow").each(function () {

            var $this = $(this);
            var tdPage = $this.find("td:first").html();
            var tdCate = $this.find("td:last").html();

            var fieldSelector = 'td';

            if (chkCate != 'DebugPage') {
                fieldSelector = 'td:not(:first, :last)';
            }

            var tdNameValues = $this.find(fieldSelector).map(function () {
                return $(this).text();
            }).get().join(' ').toUpperCase();

            if (chkCate == 'DebugPage') {
                if (
                    (chkSBox == '' || tdNameValues.indexOf(chkSBox) !== -1)
                ) {
                    $this.css("visibility", "visible");
                }
            } else {
                if (([chkPage, '*'].indexOf(tdPage) > -1 || chkPage == 'All') &&
                    (typeof (tdCate) == 'undefined' ||
                        tdCate.split(",").indexOf(chkCate) >= 0 ||
                        chkCate == 'All') &&
                    (tdNameValues.indexOf(chkSBox) !== -1)
                ) {
                    $this.css("visibility", "visible");
                }
            }

        });

        // Add Totals
        distinctGroups(chkPage);
        rowStrokes();

    }

    return {
        performFilter: performFilter,
        distinctGroups: distinctGroups,
        buildHtmlTable: buildHtmlTable,
        customiseTable: customiseTable,
        distinctPages: distinctPages,
        getDebugViewContent: getDebugViewContent,
        pageDelimeted: pageDelimeted
    }

})();