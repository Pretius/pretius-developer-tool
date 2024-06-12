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

        var debugrows = pdt.nvl(pdt.getSetting('revealer.debugrows'), 10);

        apex.server.plugin(pdt.opt.ajaxIdentifier, {
            x01: 'DEBUG_VIEW',
            x02: pageDelimeted(),
            x03: JSON.stringify(extractPluginsFromScripts()),
            x04: debugrows
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
                            var pWindow = event.ctrlKey || event.metaKey;
                            getDebugViewDetail($(a).text(), pWindow);
                        });
                    }

                });

                performFilter();

                // Add tool tip to top-left cell, i.e View ID Header
                $('#pretiusRevealerInline #pretiusDebugContent .tableTablockVars th:first')
                    .attr('title', 'Ctrl+Click on View ID to open in a new tab');

                addClassToColumns(["View ID"], "u-pullLeft");
                addClassToColumns(["Seconds", "Entries"], "u-pullRight");
                addClassToColumns(["Component"], "w20p");

                addClassToColumns(["Path Info"], "u-danger-text", 
                    function(cellValue) {
                        // Filter condition: Check if cell value starts with '[PDT-BUG]'
                        return cellValue.startsWith('[PDT-BUG]');
                    },
                        // Function to remove text
                        function($cellElement, cellValue) {
                            cellValue = cellValue.replace('[PDT-BUG]', '');
                            return $cellElement.replaceWith(
                            '<td class="tdTablockVars">'
                            + '<span class="t-Badge u-danger pdt-revealer-badge" role="status" aria-label="Status ' 
                            + cellValue + '"> <span class="t-Badge-value">' 
                            + cellValue + '</span></span>'
                            + '</td>');
                        }
                    );            

                setdebugborders();

            },
            error: function (jqXHR, textStatus, errorThrown) {
                // handle error
                pdt.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
            }
        });

    }

    function getDebugViewDetail(pViewIdentifier, pWindow) {

        if (pWindow) {
            // APEX Viewer
            var url = $('#apexDevToolbarPage').attr('data-link');
            const sessionId = pdt.pretiusToolbar.getBuilderSessionid();
    
            // Replace everything after '/page-designer' in the URL
            // and append the session ID to the modified URL
            url = url.replace(/\/page-designer[\s\S]*/, '/debug-message-data2') + `?session=${sessionId}` + 
                 '&p939_page_view_id=' + pViewIdentifier +
                 '&clear=RP,939';
    
            apex.navigation.openInNewWindow(url);

        } else {
            // Revealer Debugger
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
                    addClassToColumns(["Message"], "w95p");
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    // handle error
                    pdt.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
                }
            });
        }

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

    function extractPluginsFromScripts() {
        const scriptTags = document.querySelectorAll('script[type="text/javascript"]');
        const data = [];
        const page = apex.env.APP_PAGE_ID;
    
        // Jet Charts
        const jetChartRegex = /apex\.widget\.jetChart\.init\s*\(\s*["']([^"']+)["'].*["']([^"']+)["']\s*\)/g;
    
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
    
            let match;
            while ((match = jetChartRegex.exec(scriptContent)) !== null) {
                const id = match[1];
                const name = JSON.parse('"' + match[2] + '"');
                data.push({ page , id, name });
            }
        });
    
        // Interactive Reports
        const interactiveReportRegex = /apex\.jQuery\('#([^']+)'\)\.interactiveReport\s*\(\s*({(?:.|\n)*?})\s*\)/g;
    
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
    
            let match;
            while ((match = interactiveReportRegex.exec(scriptContent)) !== null) {
                const id = match[1].split('_')[0]; // Extracting ID part before underscore
                const attributes = JSON.parse(match[2]);
                const name = attributes.ajaxIdentifier; // Corrected attribute name
                data.push({ page , id, name });
            }
        });
    
        // Classic Reports
        const reportInitRegex = /apex\.widget\.report\.init\s*\(\s*['"]([^'"]+)['"](?:[^'"]*['"]([^'"]+)['"])?/g;
    
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
    
            let match;
            while ((match = reportInitRegex.exec(scriptContent)) !== null) {
                const id = match[1];
                const name = match[2] ? JSON.parse('"' + match[2] + '"') : null; // Parse JSON string if available
                data.push({ id, name });
            }
        });


       // Facets
        const facetsregex = /apex\.jQuery\('#([^']+)'\)\.facets\((.*?)\)/g;

        scriptTags.forEach(scriptTag => {
          const scriptContent = scriptTag.textContent || scriptTag.innerText;
        
          let match;
          while ((match = facetsregex.exec(scriptContent)) !== null) {
            //const id = match[1]; // Directly capture the ID without splitting
            const attributes = JSON.parse(match[2]);
            const id = attributes.regionStaticId;
            const name = attributes.ajaxIdentifier; // No changes needed here
        
            data.push({ page, id, name });
          }
        });

        // Serach Region
        const searchRegex = /apex\.jQuery\('#([^']+)_search'\),.*?"regionStaticId":"([^"]+)",.*?"ajaxIdentifier":"([^"]+)"/g;
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
            
            let match;
            while ((match = searchRegex.exec(scriptContent)) !== null) {
                const id = match[2];
                const name = JSON.parse('{"value": "' + match[3] + '"}').value;
                data.push({ page, id, name });
            }
        });    
        
        // Tree Region
        const regex = /apex\.widget\.tree\.init\s*\(\s*'R([^']+)_tree',.*?"regionStaticId":"([^"]+)",.*?"ajaxIdentifier":"([^"]+)"/g;
        
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
            
            let match;
            while ((match = regex.exec(scriptContent)) !== null) {
                const id = match[2];
                const name = JSON.parse('{"value": "' + match[3] + '"}').value;
                data.push({ page, id, name });
            }
        });

        // Calendar
        const calendarRegex = /apex\.widget\.fullCalendar\s*\(\s*{"regionId":"([^"]+)",.*?"ajaxIdentifier":"([^"]+)"/g;
        
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
            
            let match;
            while ((match = calendarRegex.exec(scriptContent)) !== null) {
                const id = match[1];
                const name = JSON.parse('{"value": "' + match[2] + '"}').value;
                data.push({ page, id, name });
            }
        });

        // Maps
        const mapRegex = /apex\.jQuery\('#([^']+)_map_region'\)\.spatialMap\s*\(\s*{"regionStaticId":"([^"]+)",.*?"ajaxIdentifier":"([^"]+)"/g;
        
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
        
            let match;
            while ((match = mapRegex.exec(scriptContent)) !== null) {
                const id = match[2];
                const name = JSON.parse('{"value": "' + match[3] + '"}').value;
                data.push({ page, id, name });
            }
        });

        // Region Display Selector
        const rdsRegex = /apex\.widget\.regionDisplaySelector\s*\(\s*"([^"]+)",\s*{[^}]*"ajaxIdentifier":"([^"]+)"}/g;
    
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
          
            let match;
            while ((match = rdsRegex.exec(scriptContent)) !== null) {
    
                var closestRegionElement = apex.region.findClosest($('#' + match[1] + '_RDS'));
                if (closestRegionElement) {
                    const id= closestRegionElement.element.attr("id"); 
                    const name = JSON.parse('{"value": "' + match[2] + '"}').value;
                    data.push({ page, id, name });
                }    
            }
        });

        // Support data-apex-ajax-identifier attribute
        // Supports: Column Toggle Report
        $('[data-apex-ajax-identifier]').each(function() {
            var ajaxIdentifier = $(this).data("apex-ajax-identifier");
            var closestRegionElement = apex.region.findClosest($(this)).element;
            if (closestRegionElement) {
                var closestRegion = closestRegionElement.attr("id");
                data.push({ id: closestRegion, name: ajaxIdentifier });
            }
        });

        // Support ajax-identifier identifier attribute
        // Supports: Combobox
        $('[ajax-identifier]').each(function() {
            var ajaxIdentifier = $(this).attr("ajax-identifier");
            var closestRegionElement = $(this);
            if (closestRegionElement) {
                var closestId = closestRegionElement.attr("id");
                data.push({ id: closestId, name: ajaxIdentifier });
            }
        });

        // Checkbox and Radio
        const checkboxAndRadioRegex = /apex\.widget\.checkboxAndRadio\s*\(\s*['"]([^'"]+)['"],\s*[^,]+,\s*{[^}]*"ajaxIdentifier"\s*:\s*"([^"]+)"/g;

        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
            
            let match;
            while ((match = checkboxAndRadioRegex.exec(scriptContent)) !== null) {
                const id = match[1];
                const ajaxIdentifier = JSON.parse('{"value": "' + match[2] + '"}').value;
                data.push({ id: id, name: ajaxIdentifier });
            }
        });

        // Add Pretius Developer tool
        data.push({ id: pdt.opt.debugPrefix.split(":")[0].trim(), 
                    name: pdt.opt.ajaxIdentifier });
                
        // Dynamic Actions
        for (const event of apex.da.gEventList) {
            const actions = event.actionList;
            for (const action of actions) {
                if (action.ajaxIdentifier) {
                    const name = action.ajaxIdentifier;
                    const parentName = event.name;
                    const actionName = action.action === 'NATIVE_EXECUTE_PLSQL_CODE' ? 'PL/SQL' : action.action;
                    const id = `${parentName ? `${parentName}>` : ""}${action.name || actionName}`; // Prepend "DA > " and handle missing names
                    data.push({ id, name });
                }
            }
        }
          
        // Catch-all try to scrape any ajaxIdentifiers that havent been scraped
        // This is intended to catch Region Plugins, since there is no standard method of wrtiting the render function
        // This simply assumes the first parameter is the ID
        //
        // Confirmed Supported : Select List Refresh
        const catchAllregex = /\(\s*["']([^"']+)["']\s*,\s*({[^}]*"ajaxIdentifier":"([^"]+)"[^}]*})\s*\)/g;
        
        scriptTags.forEach(scriptTag => {
            const scriptContent = scriptTag.textContent || scriptTag.innerText;
            
            let match;
            while ((match = catchAllregex.exec(scriptContent)) !== null) {
                const id = match[1];
                const name = JSON.parse('{"value": "' + match[3] + '"}').value;
                
                // Check if an entry with the same name already exists in the data array
                const existingEntry = data.find(entry => entry.name === name);
                
                // Push a new entry only if no entry with the same name exists
                if (!existingEntry) {
                    data.push({ page, id, name });
                }
            }
        });

        return data;
    }

    // Adds a CSS class to all cells in specified columns of a table, optionally applying a filter and a pre-selector function.
    function addClassToColumns(headerLabels, className, filterFunction, preSelector) {
        // Find all header elements matching the given labels
        var headerElements = $('#pretiusRevealerInline #pretiusDebugContent')
            .find(".tableTablockVars th.t-Report-colHead")
            .filter(function() {
                return headerLabels.includes($(this).text().trim());
            });
    
        // Iterate over each header element
        headerElements.each(function() {
            var columnIndex = $(this).index() + 1; // Get the column index (1-based)
    
            // Find all td elements in the corresponding column (excluding header row)
            $(".tableTablockVars tr.dataRow td:nth-child(" + columnIndex + ")").each(function() {
                var $cell = $(this);
                var cellValue = $cell.text().trim();
    
                // Apply filter function if provided
                var filterPassed = !filterFunction || filterFunction(cellValue);
    
                // Apply pre-selector if provided and filter passed
                var newValue = cellValue;
                if (preSelector && filterPassed) {
                    newValue = preSelector($cell, cellValue);
                }
    
                // Add class and update cell value if filter passed
                if (filterPassed) {
                    $cell.text(newValue); // Update cell value if necessary
                    $cell.addClass(className); // Add class
                }
            });
        });
    }
    
    function setdebugborders() {
        var rows = $('#pretiusRevealerInline .tableTablockVars tr.dataRow:visible'); // Select only visible data rows
        var row, pathInfoCell, pathInfo;
    
        rows.each(function(index, row) {
            row = $(this);
            // Extract Path Info
            pathInfoCell = row.children('td:nth-child(5)');
            pathInfo = $.trim(pathInfoCell.text());
    
            // Add class based on Path Info
            if (pathInfo.toLowerCase() === "show") {
                row.addClass('tbrvd-bottom');
            }
        });
    }
    
    return {
        performFilter: performFilter,
        distinctGroups: distinctGroups,
        buildHtmlTable: buildHtmlTable,
        customiseTable: customiseTable,
        distinctPages: distinctPages,
        getDebugViewContent: getDebugViewContent,
        pageDelimeted: pageDelimeted,
        extractPluginsFromScripts: extractPluginsFromScripts
    }

})();