/**
 * APEX Spotlight Search
 * Author: Matt Mulvaney 
 * Credits: Daniel Hochleitner: https://github.com/Dani3lSun/apex-plugin-spotlight 
 *          APEX Dev Team     : /i/apex_ui/js/spotlight.js
 * Version: 22.2.3
 */

/**
 * Extend pdt
 */
pdt.apexSpotlight = {
  /**
   * Init keyboard shortcuts on page load
   * @param {object} pOptions
   */
  initKeyboardShortcuts: function (pOptions) {
    // change default event
    pOptions.eventName = 'keyboardShortcut';

    // debug
    apex.debug.info('apexSpotlight.initKeyBoardShortcuts - pOptions', pOptions);

    var enableKeyboardShortcuts = pOptions.enableKeyboardShortcuts;
    var keyboardShortcuts = pOptions.keyboardShortcuts;
    var keyboardShortcutsArray = [];

    if (enableKeyboardShortcuts == 'Y') {
      keyboardShortcutsArray = keyboardShortcuts.split(',');

      // disable default behavior to not bind in input fields
      Mousetrap.stopCallback = function (e, element, combo) {
        return false;
      };
      Mousetrap.prototype.stopCallback = function (e, element, combo) {
        return false;
      };

      // bind moustrap to keyboard shortcut
      Mousetrap.bind(keyboardShortcutsArray, function (e) {
        // prevent default behavior
        if (e.preventDefault) {
          e.preventDefault();
        } else {
          // internet explorer
          e.returnValue = false;
        }
        // call main plugin handler
        pdt.apexSpotlight.pluginHandler(pOptions);
      });
    }
  },
  /**
   * Set spotlight search input to history value
   * @param {string} pSearchTerm
   */
  setHistorySearchValue: function (pSearchTerm) {
    $('.pdt-apx-Spotlight-input').val(pSearchTerm).trigger('input');
  },
  /**
   * Plugin handler - called from plugin render function
   * @param {object} pOptions
   */
  pluginHandler: function (pOptions) {
    /**
     * Main Namespace
     */
    var apexSpotlight = {
      /**
       * Constants
       */
      DOT: '.',
      SP_DIALOG: 'pdt-apx-Spotlight',
      SP_INPUT: 'pdt-apx-Spotlight-input',
      SP_RESULTS: 'pdt-apx-Spotlight-results',
      SP_ACTIVE: 'is-active',
      SP_SHORTCUT: 'pdt-apx-Spotlight-shortcut',
      SP_ACTION_SHORTCUT: 'spotlight-search',
      SP_RESULT_LABEL: 'pdt-apx-Spotlight-label',
      SP_LIVE_REGION: 'pdt-sp-aria-match-found',
      SP_LIST: 'pdt-sp-result-list',
      KEYS: $.ui.keyCode,
      URL_TYPES: {
        redirect: 'redirect',
        searchPage: 'search-page'
      },
      ICONS: {
        page: 'fa-window-search',
        search: 'icon-search'
      },
      /**
       * global vars
       */
      gMaxNavResult: 50,
      gWidth: 650,
      gHasDialogCreated: false,
      gSearchIndex: [],
      gStaticIndex: [],
      gKeywords: '',
      gAjaxIdentifier: null,
      gDynamicActionId: null,
      gPlaceholderText: null,
      gMoreCharsText: null,
      gNoMatchText: null,
      gOneMatchText: null,
      gMultipleMatchesText: null,
      gInPageSearchText: null,
      gSearchHistoryDeleteText: null,
      gEnableInPageSearch: true,
      gEnableDataCache: false,
      gEnablePrefillSelectedText: false,
      gEnableSearchHistory: false,
      gSubmitItemsArray: [],
      gResultListThemeClass: '',
      gIconThemeClass: '',
      gShowProcessing: false,
      gPlaceHolderIcon: 'a-Icon icon-search',
      gWaitSpinner$: null,
      gDefaultText: null,
      gDataChunked: [],
      gchunkSize: 50000,
      gAppLimit: null,
      vfetchStartTime: new Date(),
      /**
       */
      restoreOrigIcon: function () {
        $('.pdt-spotlight-devbar-entry')
          .removeClass('fa-refresh pdt-prefetching fa-anim-spin')
          .addClass('fa-window-arrow-up');
      },
      /**
       * Get JSON containing data for spotlight search entries from DB
       * @param {function} callback
       * @pFromRange {string} Start Row
       * @pToRange {string} End Row
       */
      getSpotlightDataChunked: function (callback, pFromRange, pToRange) {
        apex.server.plugin(apexSpotlight.gAjaxIdentifier, {
          pageItems: apexSpotlight.gSubmitItemsArray,
          x01: 'GET_DATA',
          x02: pdt.opt.applicationGroupName,
          x03: pFromRange,
          x04: pToRange,
          x05: apexSpotlight.gAppLimit
        }, {
          dataType: 'json',
          success: function (data) {
            var dLength = data.length;
            apex.debug.info('PDT: Fetched Page Range [' + pFromRange + '-' + (pFromRange + dLength - 1) + '] of ' + dLength + ' row(s)');
            apexSpotlight.gDataChunked.push(...data);

            if (dLength == apexSpotlight.gchunkSize) {

              apexSpotlight.getSpotlightDataChunked(
                callback,
                pFromRange + apexSpotlight.gchunkSize,
                pToRange + apexSpotlight.gchunkSize);
            } else {
              data = apexSpotlight.gDataChunked;
              pdt.unCloakDebugLevel();
              pdt.opt.spotlightPrefetching = false;
              apexSpotlight.restoreOrigIcon();
              apex.event.trigger('body', 'pdt-apexspotlight-ajax-success', data);
              // apex.debug.info("apexSpotlight.getSpotlightData AJAX Success", data);
              if (apexSpotlight.gEnableDataCache) {
                // MM : Changed mind on --> MM: Always store to replace any aged cache
                apexSpotlight.setSpotlightDataSessionStorage(JSON.stringify(data));
              }
              apexSpotlight.hideWaitSpinner();
              callback(data);
            }
          },
          error: function (jqXHR, textStatus, errorThrown) {
            pdt.unCloakDebugLevel();
            pdt.opt.spotlightPrefetching = false;
            apexSpotlight.restoreOrigIcon();
            apex.event.trigger('body', 'pdt-apexspotlight-ajax-error', {
              "message": errorThrown
            });
            apex.debug.info("apexSpotlight.getSpotlightData AJAX Error", errorThrown);
            apexSpotlight.hideWaitSpinner();
            callback([]);
          }
        });
      },
      /**
       * Get JSON containing data for spotlight search entries from DB
       * @param {function} callback
       */
      getSpotlightData: function (callback) {
        var cacheData;
        if (apexSpotlight.gEnableDataCache) {
          cacheData = apexSpotlight.getSpotlightDataSessionStorage();
          if (cacheData) {
            pdt.opt.spotlightPrefetching = false;
            apexSpotlight.restoreOrigIcon();
            callback(JSON.parse(cacheData));
            return;
          }
        }
        try {
          apexSpotlight.showWaitSpinner();
          pdt.cloakDebugLevel();
          apex.debug.info("PDT Fetching Data...");
          apexSpotlight.getSpotlightDataChunked(callback, 1, apexSpotlight.gchunkSize);
        } catch (err) {
          pdt.unCloakDebugLevel();
          pdt.opt.spotlightPrefetching = false;
          apexSpotlight.restoreOrigIcon();
          apex.event.trigger('body', 'pdt-apexspotlight-ajax-error', {
            "message": err
          });
          apex.debug.info("apexSpotlight.getSpotlightData AJAX Error", err);
          apexSpotlight.hideWaitSpinner();
          callback([]);
        }
      },
      /**
       * Get JSON containing SSP URL with replaced search keyword value (~SEARCH_VALUE~ substitution string)
       * @param {string} pUrl
       * @param {function} callback
       */
      getProperApexUrl: function (pUrl, callback) {
        try {
          pdt.cloakDebugLevel();
          apex.server.plugin(apexSpotlight.gAjaxIdentifier, {
            x01: 'GET_URL',
            x02: apexSpotlight.gKeywords,
            x03: pUrl
          }, {
            dataType: 'json',
            success: function (data) {
              pdt.unCloakDebugLevel();
              apex.debug.info("apexSpotlight.getProperApexUrl AJAX Success", data);
              callback(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
              pdt.unCloakDebugLevel();
              apex.debug.info("apexSpotlight.getProperApexUrl AJAX Error", errorThrown);
              callback({
                "url": pUrl
              });
            }
          });
        } catch (err) {
          pdt.unCloakDebugLevel();
          apex.debug.info("apexSpotlight.getProperApexUrl AJAX Error", err);
          callback({
            "url": pUrl
          });
        }
      },
      /**
       * Save JSON Data in local session storage of browser (apexSpotlight.<app_id>.<app_session>.<da-id>.data)
       * @param {object} pData
       */
      setSpotlightDataSessionStorage: function (pData) {
        var hasSessionStorageSupport = apex.storage.hasSessionStorageSupport();

        if (hasSessionStorageSupport) {

          // store new pData
          var apexSession = $v('pInstance');
          var sessionStorage = apex.storage.getScopedSessionStorage({
            prefix: 'pdtApexSpotlight',
            useAppId: true
          });

          // Remove any redundant storage
          for (let key in sessionStorage._store) {
            if (key.endsWith('pdtSpotlightData')) {
              key = key.replace(/^pdtApexSpotlight\./, '');
              sessionStorage.removeItem(key);
            }
          }

          // compress with pako
          const deflated = pako.deflate(JSON.stringify(pData));
          const CHUNK_SIZE = 46656; // this has to be a factor of six i.e 6^2 = 46656
          const encodedChunks = [];
          for (let i = 0; i < deflated.length; i += CHUNK_SIZE) {
            const chunk = deflated.slice(i, i + CHUNK_SIZE);
            const encodedChunk = btoa(String.fromCharCode.apply(null, chunk));
            encodedChunks.push(encodedChunk);
          }
          const encodedData = encodedChunks.join("");

          // sessionStorage.setItem(apexSession + '.' + apexSpotlight.gDynamicActionId + '.pdtSpotlightData', encodedData);
          sessionStorage.setItem(apexSession + '.pdtSpotlightData', encodedData);
        }
      },
      /**
       * Get JSON Data from local session storage of browser (apexSpotlight.<app_id>.<app_session>.<da-id>.data)
       */
      getSpotlightDataSessionStorage: function () {
        var hasSessionStorageSupport = apex.storage.hasSessionStorageSupport();

        var storageValue;
        if (hasSessionStorageSupport) {
          var apexSession = $v('pInstance');
          var sessionStorage = apex.storage.getScopedSessionStorage({
            prefix: 'pdtApexSpotlight',
            useAppId: true
          });
          // encStorageValue = sessionStorage.getItem(apexSession + '.' + apexSpotlight.gDynamicActionId + '.pdtSpotlightData');
          encStorageValue = sessionStorage.getItem(apexSession + '.pdtSpotlightData');

          if (encStorageValue) {
            // Uncompress with pako
            const decodedData = atob(encStorageValue);
            const charData = decodedData.split('').map(function (x) { return x.charCodeAt(0); });
            const binData = new Uint8Array(charData);
            storageValue = JSON.parse(pako.inflate(binData, { to: 'string' }));
          }

        }
        return storageValue;
      },
      /**
       * Save search term in local storage of browser (apexSpotlight.<app_id>.<da-id>.history)
       * @param {string} pSearchTerm
       */
      setSpotlightHistoryLocalStorage: function (pSearchTerm) {
        var hasLocalStorageSupport = apex.storage.hasLocalStorageSupport();
        var storageArray = [];

        var removeDupsFromArray = function (pArray) {
          var unique = {};
          pArray.forEach(function (i) {
            if (!unique[i]) {
              unique[i] = true;
            }
          });
          return Object.keys(unique);
        };

        var removeOldValuesFromArray = function (pArray) {
          for (var i = 0; i < pArray.length; i++) {
            if (i > 30) {
              pArray.splice(i, 1);
            }
          }
          return pArray;
        };
        // only add strings to first position of array
        if (isNaN(pSearchTerm)) {
          storageArray = apexSpotlight.getSpotlightHistoryLocalStorage();
          storageArray.unshift(pSearchTerm.trim());
          storageArray = removeDupsFromArray(storageArray);
          storageArray = removeOldValuesFromArray(storageArray);

          if (hasLocalStorageSupport) {
            var localStorage = apex.storage.getScopedLocalStorage({
              prefix: 'apexSpotlight',
              useAppId: true
            });
            localStorage.setItem(apexSpotlight.gDynamicActionId + '.history', JSON.stringify(storageArray));
          }
        }
      },
      /**
       * Get saved search terms from local storage of browser (apexSpotlight.<app_id>.<da-id>.history)
       */
      getSpotlightHistoryLocalStorage: function () {
        var hasLocalStorageSupport = apex.storage.hasLocalStorageSupport();

        var storageValue;
        var storageArray = [];
        if (hasLocalStorageSupport) {
          var localStorage = apex.storage.getScopedLocalStorage({
            prefix: 'apexSpotlight',
            useAppId: true
          });
          storageValue = localStorage.getItem(apexSpotlight.gDynamicActionId + '.history');
          if (storageValue) {
            storageArray = JSON.parse(storageValue);
          }
        }
        return storageArray;
      },
      /**
       * Remove saved search terms from local storage of browser (apexSpotlight.<app_id>.<app_session>.<da-id>.history)
       */
      removeSpotlightHistoryLocalStorage: function () {
        var hasLocalStorageSupport = apex.storage.hasLocalStorageSupport();

        if (hasLocalStorageSupport) {
          var localStorage = apex.storage.getScopedLocalStorage({
            prefix: 'apexSpotlight',
            useAppId: true
          });
          localStorage.removeItem(apexSpotlight.gDynamicActionId + '.history');
        }
      },
      /**
       * Show popover using tippy.js which contains saved history entries of local storage
       */
      showTippyHistoryPopover: function () {
        var historyArray = apexSpotlight.getSpotlightHistoryLocalStorage() || [];
        var content = '';
        var loopCount = 0;

        if (historyArray.length > 0) {

          apexSpotlight.destroyTippyHistoryPopover();
          $('div.pdt-apx-Spotlight-icon-main').css('cursor', 'pointer');

          content += '<ul class="spotlight-history-list">';
          for (var i = 0; i < historyArray.length; i++) {
            content += "<li><a class=\"spotlight-history-link\" href=\"javascript:pdt.apexSpotlight.setHistorySearchValue('" + apex.util.escapeHTML(historyArray[i]) + "');\">" + apex.util.escapeHTML(historyArray[i]) + "</a></li>";
            loopCount = loopCount + 1;
            if (loopCount >= 20) {
              break;
            }
          }
          content += "<li><a class=\"spotlight-history-delete\" href=\"javascript:void(0);\"><i>" + apexSpotlight.gSearchHistoryDeleteText + "</i></a></li>";
          content += '</ul>';

          tippy($('div.pdt-apx-Spotlight-icon-main')[0], {
            content: content,
            interactive: true,
            arrow: true,
            placement: 'right-end',
            animateFill: false
          });

          $('body').on('click', 'a.spotlight-history-link', function () {
            apexSpotlight.hideTippyHistoryPopover();
          });
          $('body').on('click', 'a.spotlight-history-delete', function () {
            apexSpotlight.destroyTippyHistoryPopover();
            apexSpotlight.removeSpotlightHistoryLocalStorage();
          });
        }
      },
      /**
       * Hide popover using tippy.js which contains saved history entries of local storage
       */
      hideTippyHistoryPopover: function () {
        var tippyElem = $('div.pdt-apx-Spotlight-icon-main')[0];
        if (tippyElem && tippyElem._tippy) {
          tippyElem._tippy.hide();
        }
      },
      /**
       * Destroy popover using tippy.js which contains saved history entries of local storage
       */
      destroyTippyHistoryPopover: function () {
        var tippyElem = $('div.pdt-apx-Spotlight-icon-main')[0];
        if (tippyElem && tippyElem._tippy) {
          tippyElem._tippy.destroy();
        }
        $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).focus();
      },
      /**
       * Show wait spinner to show progress of AJAX call
       */
      showWaitSpinner: function () {
        if (apexSpotlight.gShowProcessing) {
          $('div.pdt-apx-Spotlight-icon-main span').prop('className', '').addClass('fa fa-refresh fa-anim-spin');
        }
      },
      /**
       * Hide wait spinner and display default search icon
       */
      hideWaitSpinner: function () {
        if (apexSpotlight.gShowProcessing) {
          $('div.pdt-apx-Spotlight-icon-main span').prop('className', '').addClass(apexSpotlight.gPlaceHolderIcon);
        }
      },
      /**
       * Get text of selected text on document
       */
      getSelectedText: function () {
        var range;
        if (window.getSelection) {
          range = window.getSelection();
          return range.toString().trim();
        } else {
          if (document.selection.createRange) {
            range = document.selection.createRange();
            return range.text.trim();
          }
        }
      },
      /**
       * Fetch selected text and set it to spotlight search input
       */
      setSelectedText: function (pText) {
        // get selected text
        var selectedText;

        if (pText) {
          selectedText = pText;
        } else {
          selectedText = apexSpotlight.getSelectedText();
        }

        // set selected text to spotlight input
        if (selectedText) {
          // if dialog & data already there
          if (apexSpotlight.gHasDialogCreated) {
            $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val(selectedText).trigger('input');
            // dialog has to be opened & data must be fetched
          } else {
            // not until data has been in place
            $('body').on('pdt-apexspotlight-get-data', function () {
              $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val(selectedText).trigger('input');
            });
          }
        }
      },
      /**
       * Wrapper for apex.navigation.redirect to optionally show a waiting spinner before redirecting
       * @param {string} pWhere
       */
      redirect: function (pWhere) {
        if (apexSpotlight.gShowProcessing) {
          try {
            // no waiting spinner for javascript targets
            if (pWhere.startsWith('javascript:')) {
              apex.navigation.redirect(pWhere);
            } else {
              // only show spinner if not already present and if it´s an APEX target page and no client side validation errors occured and the page has not changed
              if ($('span.u-Processing').length == 0 &&
                pWhere.startsWith('f?p=') &&
                apex.page.validate() &&
                !apex.page.isChanged()) {
                apexSpotlight.gWaitSpinner$ = apex.util.showSpinner($('body'));
              }
              apex.navigation.redirect(pWhere);
            }
          } catch (err) {
            if (apexSpotlight.gWaitSpinner$) {
              apexSpotlight.gWaitSpinner$.remove();
            }
            apex.navigation.redirect(pWhere);
          }
        } else {
          apex.navigation.redirect(pWhere);
        }
      },
      /**
       * Handle aria attributes
       */
      handleAriaAttr: function () {
        var results$ = $(apexSpotlight.DOT + apexSpotlight.SP_RESULTS),
          input$ = $(apexSpotlight.DOT + apexSpotlight.SP_INPUT),
          activeId = results$.find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE).find(apexSpotlight.DOT + apexSpotlight.SP_RESULT_LABEL).attr('id'),
          activeElem$ = $('#' + activeId),
          activeText = activeElem$.text(),
          lis$ = results$.find('li'),
          isExpanded = lis$.length !== 0,
          liveText = '',
          resultsCount = lis$.filter(function () {
            // Exclude the global inserted <li>, which has shortcuts Ctrl + 1, 2, 3
            // such as "Search Workspace for x".
            return $(this).find(apexSpotlight.DOT + apexSpotlight.SP_SHORTCUT).length === 0;
          }).length;

        $(apexSpotlight.DOT + apexSpotlight.SP_RESULT_LABEL)
          .attr('aria-selected', 'false');

        activeElem$
          .attr('aria-selected', 'true');

        if (apexSpotlight.gKeywords === '') {
          liveText = apexSpotlight.gMoreCharsText;
        } else if (resultsCount === 0) {
          liveText = apexSpotlight.gNoMatchText;
        } else if (resultsCount === 1) {
          liveText = apexSpotlight.gOneMatchText;
        } else if (resultsCount > 1) {
          liveText = resultsCount + ' ' + apexSpotlight.gMultipleMatchesText;
        }

        liveText = activeText + ', ' + liveText;

        $('#' + apexSpotlight.SP_LIVE_REGION).text(liveText);

        input$
          // .parent()  // aria 1.1 pattern
          .attr('aria-activedescendant', activeId)
          .attr('aria-expanded', isExpanded);
      },
      /**
       * Close modal spotlight dialog
       */
      closeDialog: function () {
        $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).dialog('close');
      },
      /**
       * Reset spotlight
       */
      resetSpotlight: function () {
        $('#' + apexSpotlight.SP_LIST).empty();
        $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val(''); // removed ".focus();" from the tail as it was preventing it focusing a 2nd time
        apexSpotlight.gKeywords = '';
        apexSpotlight.handleAriaAttr();
      },
      /**
       * Navigation to target which is contained in elem$ (<a> link)
       * @param {object} elem$
       * @param {object} event
       */
      goTo: function (elem$, event) {
        var url = elem$.data('url'),
          type = elem$.data('type');

        switch (type) {
          case apexSpotlight.URL_TYPES.searchPage:
            apexSpotlight.inPageSearch();
            break;

          case apexSpotlight.URL_TYPES.redirect:
            // replace ~SEARCH_VALUE~ substitution string
            if (url.includes('~SEARCH_VALUE~')) {
              // escape some problematic chars :,"'
              apexSpotlight.gKeywords = apexSpotlight.gKeywords.replace(/:|,|"|'/g, ' ').trim();
              // server side if APEX URL is detected
              if (url.startsWith('f?p=')) {
                apexSpotlight.getProperApexUrl(url, function (data) {
                  apexSpotlight.redirect(data.url);
                });
                // client side for all other URLs
              } else {
                url = url.replace('~SEARCH_VALUE~', apexSpotlight.gKeywords);
                apexSpotlight.redirect(url);
              }
            }
            // replace ~SEARCH_VALUE~ substitution string
            else if (url.includes('~WINDOW~')) {
              if (event.ctrlKey || event.metaKey) {
                // Control key or command key is being held down
                url = url.replace('~WINDOW~', 'true');
              } else {
                url = url.replace('~WINDOW~', 'false');
              }
              apexSpotlight.redirect(url);
              // normal URL without substitution string
            } else {
              apexSpotlight.redirect(url);
            }
            break;
        }

        apexSpotlight.closeDialog();
      },
      /**
       * Get HTML markup
       * @param {object} data
       */
      getMarkup: function (data) {
        var title = data.title,
          desc = data.desc || '',
          url = data.url,
          type = data.type,
          icon = data.icon,
          iconColor = data.iconColor,
          shortcut = data.shortcut,
          static = data.static,
          shortcutMarkup = shortcut ? '<span class="' + apexSpotlight.SP_SHORTCUT + '" >' + shortcut + '</span>' : '',
          // shortcutMarkup = '<span class="' + apexSpotlight.SP_SHORTCUT + '" >' + 'shortcut' + '</span>',
          dataAttr = '',
          iconString = '',
          indexType = '',
          iconColorString = '',
          out;

        if (url === 0 || url) {
          dataAttr = 'data-url="' + url + '" ';
        }

        if (type) {
          dataAttr = dataAttr + ' data-type="' + type + '" ';
        }

        if (icon.startsWith('fa-')) {
          iconString = 'fa ' + icon;
        } else if (icon.startsWith('icon-')) {
          iconString = 'a-Icon ' + icon;
        } else {
          iconString = 'a-Icon icon-search';
        }

        // is it a static entry or a dynamic search result
        if (static) {
          indexType = 'STATIC';
        } else {
          indexType = 'DYNAMIC';
        }

        if (iconColor) {
          iconColorString = 'style="background-color:' + iconColor + '"';
        }

        out = '<li class="pdt-apx-Spotlight-result ' + apexSpotlight.gResultListThemeClass + ' pdt-apx-Spotlight-result--page pdt-apx-Spotlight-' + indexType + '">' +
          '<span class="pdt-apx-Spotlight-link" ' + dataAttr + '>' +
          '<span class="pdt-apx-Spotlight-icon ' + apexSpotlight.gIconThemeClass + '" ' + iconColorString + ' aria-hidden="true">' +
          '<span class="' + iconString + '"></span>' +
          '</span>' +
          '<span class="pdt-apx-Spotlight-info">' +
          '<span class="' + apexSpotlight.SP_RESULT_LABEL + '" role="option">' + title + '</span>' +
          '<span class="pdt-apx-Spotlight-desc margin-top-sm">' + desc + '</span>' +
          '</span>' +
          shortcutMarkup +
          '</span>' +
          '</li>';

        return out;

      },
      /**
       * Push static list entries to resultset
       * @param {array} results
       */
      resultsAddOns: function (results) {

        var shortcutCounter = 0;

        if (apexSpotlight.gEnableInPageSearch) {
          results.push({
            n: apexSpotlight.gInPageSearchText,
            u: '',
            i: apexSpotlight.ICONS.page,
            ic: null,
            t: apexSpotlight.URL_TYPES.searchPage,
            shortcut: 'Ctrl + 1',
            s: true
          });
          shortcutCounter = shortcutCounter + 1;
        }

        for (var i = 0; i < apexSpotlight.gStaticIndex.length; i++) {
          shortcutCounter = shortcutCounter + 1;
          if (shortcutCounter > 9) {
            results.push({
              n: apexSpotlight.gStaticIndex[i].n,
              d: apexSpotlight.gStaticIndex[i].d,
              u: apexSpotlight.gStaticIndex[i].u,
              i: apexSpotlight.gStaticIndex[i].i,
              ic: apexSpotlight.gStaticIndex[i].ic,
              t: apexSpotlight.gStaticIndex[i].t,
              s: apexSpotlight.gStaticIndex[i].s
            });
          } else {
            results.push({
              n: apexSpotlight.gStaticIndex[i].n,
              d: apexSpotlight.gStaticIndex[i].d,
              u: apexSpotlight.gStaticIndex[i].u,
              i: apexSpotlight.gStaticIndex[i].i,
              ic: apexSpotlight.gStaticIndex[i].ic,
              t: apexSpotlight.gStaticIndex[i].t,
              s: apexSpotlight.gStaticIndex[i].s,
              shortcut: 'Ctrl + ' + shortcutCounter
            });
          }
        }

        return results;
      },
      /**
       * Search Navigation
       * @param {array} patterns
       */
      searchNav: function (patterns) {
        var navResults = [],
          hasResults = false,
          pattern,
          patternLength = patterns.length,
          i,
          searchValue = $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val().trim(),
          appFilter = ':' + apex.item('R0_SPOTLIGHT_FILTER').getValue() + ':';

        var narrowedSet = function () {
          return hasResults ? navResults : apexSpotlight.gSearchIndex;
        };

        var getScore = function (pos, wordsCount, fullTxt) {
          var score = 100,
            spaces = wordsCount - 1,
            positionOfWholeKeywords;

          if (pos === 0 && spaces === 0) {
            // perfect match ( matched from the first letter with no space )
            return score;
          } else {
            // when search 'sql c', 'SQL Commands' should score higher than 'SQL Scripts'
            // when search 'script', 'Script Planner' should score higher than 'SQL Scripts'
            positionOfWholeKeywords = fullTxt.indexOf(apexSpotlight.gKeywords);
            if (positionOfWholeKeywords === -1) {
              score = score - pos - spaces - wordsCount;
            } else {
              score = score - positionOfWholeKeywords;
            }
          }

          return score;
        };

        for (i = 0; i < patterns.length; i++) {
          pattern = patterns[i];

          navResults = narrowedSet()
            .filter(function (elem, index) {
              var name = elem.n.toLowerCase(),
                category = elem.c,
                exact = elem.x,
                wordsCount = name.split(' ').length,
                position = name.search(pattern);

              if (searchValue == exact) {
                // User search for exact page
                return true;
              }

              if (patternLength > wordsCount) {
                // keywords contains more words than string to be searched
                return false;
              }

              // Check if page in correct category
              if (!category.includes(appFilter)) {
                return false;
              }

              if (position > -1) {
                elem.score = getScore(position, wordsCount, name);
                if (apex)
                  return true;
              } else if (elem.t) { // tokens (short description for nav entries.)
                if (elem.t.search(pattern) > -1) {
                  elem.score = 1;
                  return true;
                }
              }

            })
            .sort(function (a, b) {
              return b.score - a.score;
            });

          hasResults = true;
        }

        var formatNavResults = function (res) {
          var out = '',
            i,
            item,
            type,
            shortcut,
            icon,
            iconColor,
            static,
            entry = {};

          if (res.length > apexSpotlight.gMaxNavResult) {
            res.length = apexSpotlight.gMaxNavResult;
          }

          for (i = 0; i < res.length; i++) {
            item = res[i];

            shortcut = item.shortcutlink;  //item.shortcut;
            type = item.t || apexSpotlight.URL_TYPES.redirect;
            icon = item.i || apexSpotlight.ICONS.search;
            static = item.s || false;
            if (item.ic !== 'DEFAULT') {
              iconColor = item.ic;
            }

            entry = {
              title: item.n,
              desc: item.d,
              url: item.u,
              icon: icon,
              iconColor: iconColor,
              type: type,
              static: static
            };

            if (shortcut) {
              entry.shortcut = shortcut;
            }

            out = out + apexSpotlight.getMarkup(entry);
          }
          return out;
        };
        return formatNavResults(apexSpotlight.resultsAddOns(navResults));
      },
      /**
       * Search
       * @param {string} k
       */
      search: function (k) {
        var PREFIX_ENTRY = 'pdt-sp-result-';
        // store keywords
        apexSpotlight.gKeywords = k.trim();

        var words = apexSpotlight.gKeywords.split(' '),
          res$ = $(apexSpotlight.DOT + apexSpotlight.SP_RESULTS),
          patterns = [],
          navOuput,
          i;
        for (i = 0; i < words.length; i++) {
          // store keys in array to support space in keywords for navigation entries,
          // e.g. 'sta f' finds 'Static Application Files'
          // patterns.push(new RegExp(apex.util.escapeRegExp(words[i]), 'gi'));

          // MM : This code uses negative lookbehind (?<!...) 
          // and negative lookahead (?![^<]*?>) to exclude matches that occur inside HTML tags.
          patterns.push( new RegExp(
            "(?<!</?[a-z][^>]*?>)(" + apex.util.escapeRegExp(words[i]) + ")(?![^<]*?>)",
            "gi"
          ));
          
        }

        navOuput = apexSpotlight.searchNav(patterns);

        $('#' + apexSpotlight.SP_LIST)
          .html(navOuput)
          .find('li')
          .each(function (i) {
            var that$ = $(this);
            that$
              .find(apexSpotlight.DOT + apexSpotlight.SP_RESULT_LABEL)
              .attr('id', PREFIX_ENTRY + i); // for accessibility
          })
          .first()
          .addClass(apexSpotlight.SP_ACTIVE);
      },
      /**
       * Creates the spotlight dialog markup
       * @param {string} pPlaceHolder
       */
      createSpotlightDialog: function (pPlaceHolder) {
        var createDialog = function () {
          var viewHeight,
            lineHeight,
            viewTop,
            rowsPerView;

          var initHeights = function () {
            if ($(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).length > 0) {
              var viewTop$ = $('div.pdt-apx-Spotlight-results');
              viewHeight = viewTop$.outerHeight();
              lineHeight = $('li.pdt-apx-Spotlight-result').outerHeight();
              viewTop = viewTop$.offset().top;
              rowsPerView = (viewHeight / lineHeight);
            }
          };

          var scrolledDownOutOfView = function (elem$) {
            if (elem$[0]) {
              var top = elem$.offset().top;
              if (top < 0) {
                return true; // scroll bar was used to get active item out of view
              } else {
                return top > viewHeight;
              }
            }
          };

          var scrolledUpOutOfView = function (elem$) {
            if (elem$[0]) {
              var top = elem$.offset().top;
              if (top > viewHeight) {
                return true; // scroll bar was used to get active item out of view
              } else {
                return top <= viewTop;
              }
            }
          };

          // keyboard UP and DOWN support to go through results
          var getNext = function (res$) {
            var current$ = res$.find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE),
              sequence = current$.index(),
              next$;
            if (!rowsPerView) {
              initHeights();
            }

            if (!current$.length || current$.is(':last-child')) {
              // Hit bottom, scroll to top
              current$.removeClass(apexSpotlight.SP_ACTIVE);
              res$.find('li').first().addClass(apexSpotlight.SP_ACTIVE);
              res$.animate({
                scrollTop: 0
              });
            } else {
              next$ = current$.removeClass(apexSpotlight.SP_ACTIVE).next().addClass(apexSpotlight.SP_ACTIVE);
              if (scrolledDownOutOfView(next$)) {
                res$.animate({
                  scrollTop: (sequence - rowsPerView + 2) * lineHeight
                }, 0);
              }
            }
          };

          var getPrev = function (res$) {
            var current$ = res$.find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE),
              sequence = current$.index(),
              prev$;

            if (!rowsPerView) {
              initHeights();
            }

            if (!res$.length || current$.is(':first-child')) {
              // Hit top, scroll to bottom
              current$.removeClass(apexSpotlight.SP_ACTIVE);
              res$.find('li').last().addClass(apexSpotlight.SP_ACTIVE);
              res$.animate({
                scrollTop: res$.find('li').length * lineHeight
              });
            } else {
              prev$ = current$.removeClass(apexSpotlight.SP_ACTIVE).prev().addClass(apexSpotlight.SP_ACTIVE);
              if (scrolledUpOutOfView(prev$)) {
                res$.animate({
                  scrollTop: (sequence - 1) * lineHeight
                }, 0);
              }
            }
          };

          $(window).on('apexwindowresized', function () {
            initHeights();
          });


          var spotlightRadioFilter =
            '<div class="container">' +
            '<div class="row ">' +
            '<div class="col col-12 apex-col-auto col-start col-end"><div class="t-Form-fieldContainer t-Form-fieldContainer--floatingLabel t-Form-fieldContainer--stretchInputs t-Form-fieldContainer--radioButtonGroup apex-item-wrapper apex-item-wrapper--radiogroup " id="R0_SPOTLIGHT_FILTER_CONTAINER"><div class="t-Form-labelContainer">' +
            '</div><div class="t-Form-inputContainer padding-none"><div class="t-Form-itemWrapper"><div tabindex="-1" id="R0_SPOTLIGHT_FILTER" aria-labelledby="R0_SPOTLIGHT_FILTER_LABEL" class="radio_group apex-item-group apex-item-group--rc apex-item-radio margin-top-none pdt-revealer-ignore" role="group">' +
            '<div class="apex-item-grid radio_group">' +
            '<div class="apex-item-grid-row">' +
            '<div class="apex-item-option"><input type="radio" id="R0_SPOTLIGHT_FILTER_0" name="R0_SPOTLIGHT_FILTER" data-display="This App" value="APP" checked="checked"><label class="u-radio padding-top-none padding-bottom-none pdt-spt-lbl" for="R0_SPOTLIGHT_FILTER_0">This App</label></div>' +
            '<div class="apex-item-option"><input type="radio" id="R0_SPOTLIGHT_FILTER_1" name="R0_SPOTLIGHT_FILTER" data-display="Workspace Apps" value="WS"><label class="u-radio padding-top-none padding-bottom-none pdt-spt-lbl" for="R0_SPOTLIGHT_FILTER_1">Workspace Apps</label></div>' +
            '<div class="apex-item-option"><input type="radio" id="R0_SPOTLIGHT_FILTER_2" name="R0_SPOTLIGHT_FILTER" data-display="Application Group" value="AG"><label class="u-radio padding-top-none padding-bottom-none pdt-spt-lbl" for="R0_SPOTLIGHT_FILTER_2">Group: %0</label></div>' +
            '</div></div></div>' +
            '</div><span id="R0_SPOTLIGHT_FILTER_error_placeholder" class="a-Form-error" data-template-id=""></span></div></div></div>' +
            '</div>' +
            '</div>';

          function ellispsesTrim(str, limit) {
            if (str.length <= limit) {
              return str;
            } else {
              return str.substr(0, limit - 3) + '...';
            }
          }
          spotlightRadioFilter = apex.lang.formatNoEscape(spotlightRadioFilter, ellispsesTrim(pdt.opt.applicationGroupName, 40));

          $('body')
            .append(
              '<div class="' + apexSpotlight.SP_DIALOG + '" data-id="' + apexSpotlight.gDynamicActionId + '">' +
              '<div class="pdt-apx-Spotlight-body">' +
              '<div class="pdt-apx-Spotlight-header">' + spotlightRadioFilter + '</div>' +
              '<div class="pdt-apx-Spotlight-search">' +
              '<div class="pdt-apx-Spotlight-icon pdt-apx-Spotlight-icon-main">' +
              '<span class="' + apexSpotlight.gPlaceHolderIcon + '" aria-hidden="true"></span>' +
              '</div>' +
              '<div class="pdt-apx-Spotlight-field">' +
              '<input type="text" role="combobox" aria-expanded="false" aria-autocomplete="none" aria-haspopup="true" aria-label="Spotlight Search" aria-owns="' + apexSpotlight.SP_LIST + '" autocomplete="off" autocorrect="off" spellcheck="false" class="' + apexSpotlight.SP_INPUT + '" placeholder="' + pPlaceHolder + '">' +
              '</div>' +
              '<div role="region" class="u-VisuallyHidden" aria-live="polite" id="' + apexSpotlight.SP_LIVE_REGION + '"></div>' +
              '</div>' +
              '<div class="' + apexSpotlight.SP_RESULTS + '">' +
              '<ul class="pdt-apx-Spotlight-resultsList" id="' + apexSpotlight.SP_LIST + '" tabindex="-1" role="listbox"></ul>' +
              '</div>' +
              '</div>' +
              '</div>'
            )
            .on('input', apexSpotlight.DOT + apexSpotlight.SP_INPUT, function () {
              var v = $(this).val().trim(),
                len = v.length;

              if (len === 0) {
                apexSpotlight.resetSpotlight(); // clears everything when keyword is removed.
              } else if (len >= 1 || !isNaN(v)) {
                // search requires more than 0 character, or it is a number.
                if (v !== apexSpotlight.gKeywords) {
                  apexSpotlight.search(v);
                }
              }
            })
            .on('change', '#R0_SPOTLIGHT_FILTER', function (e) {
              apexSpotlight.search($(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val().trim());
              $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).trigger('input');
            })
            .on('keydown', apexSpotlight.DOT + apexSpotlight.SP_DIALOG, function (e) {
              var results$ = $(apexSpotlight.DOT + apexSpotlight.SP_RESULTS),
                last9Results,
                shortcutNumber;

              // up/down arrows
              switch (e.which) {
                case apexSpotlight.KEYS.DOWN:
                  e.preventDefault();
                  getNext(results$);
                  break;

                case apexSpotlight.KEYS.UP:
                  e.preventDefault();
                  getPrev(results$);
                  break;

                case apexSpotlight.KEYS.ENTER:
                  e.preventDefault(); // don't submit on enter
                  if (apexSpotlight.gEnableSearchHistory) {
                    apexSpotlight.setSpotlightHistoryLocalStorage($(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val());
                  }
                  apexSpotlight.goTo(results$.find('li.is-active span'), e);
                  break;
                case apexSpotlight.KEYS.TAB:
                  apexSpotlight.closeDialog();
                  break;
              }

              if (e.ctrlKey) {
                // supports Ctrl + 1, 2, 3, 4, 5, 6, 7, 8, 9 shortcuts
                last9Results = results$.find(apexSpotlight.DOT + apexSpotlight.SP_SHORTCUT).parent().get();
                switch (e.which) {
                  case 49: // Ctrl + 1
                    shortcutNumber = 1;
                    break;
                  case 50: // Ctrl + 2
                    shortcutNumber = 2;
                    break;

                  case 51: // Ctrl + 3
                    shortcutNumber = 3;
                    break;

                  case 52: // Ctrl + 4
                    shortcutNumber = 4;
                    break;

                  case 53: // Ctrl + 5
                    shortcutNumber = 5;
                    break;

                  case 54: // Ctrl + 6
                    shortcutNumber = 6;
                    break;

                  case 55: // Ctrl + 7
                    shortcutNumber = 7;
                    break;

                  case 56: // Ctrl + 8
                    shortcutNumber = 8;
                    break;

                  case 57: // Ctrl + 9
                    shortcutNumber = 9;
                    break;
                }

                if (shortcutNumber) {
                  apexSpotlight.goTo($(last9Results[shortcutNumber - 1]), e);
                }
              }

              // Shift + Tab to close and focus goes back to where it was.
              if (e.shiftKey) {
                if (e.which === apexSpotlight.KEYS.TAB) {
                  apexSpotlight.closeDialog();
                }
              }

              apexSpotlight.handleAriaAttr();

            })
            .on('click', 'span.pdt-apx-Spotlight-link', function (e) {
              if (apexSpotlight.gEnableSearchHistory) {
                apexSpotlight.setSpotlightHistoryLocalStorage($(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val());
              }
              apexSpotlight.goTo($(this), e);
            })
            .on('mousemove', 'li.pdt-apx-Spotlight-result', function () {
              var highlight$ = $(this);
              highlight$
                .parent()
                .find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE)
                .removeClass(apexSpotlight.SP_ACTIVE);

              highlight$.addClass(apexSpotlight.SP_ACTIVE);
              // handleAriaAttr();
            })
            .on('blur', apexSpotlight.DOT + apexSpotlight.SP_DIALOG, function (e) {
              // don't do this if dialog is closed/closing
              if ($(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).dialog("isOpen")) {
                // input takes focus dialog loses focus to scroll bar
                $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).focus();
              }
            })
            .on('click', '.pdt-apx-Spotlight-inline-link', function (e) {
              // Thanks ChatGPT
              const url = this.getAttribute('pdt-Spotlink-url');
              pdt.cloakDebugLevel();
              apex.server.plugin(apexSpotlight.gAjaxIdentifier, {
                x01: 'GET_URL',
                x02: url
              }, {
                dataType: 'json',
                success: function (data) {
                  pdt.unCloakDebugLevel();
                  if (data) {
                    var preparedUrl = data.url;
                    if (preparedUrl.startsWith('javascript:')) {
                      apexSpotlight.closeDialog();
                      const code = preparedUrl.slice(11); // Remove 'javascript:' prefix
                      eval(code);
                    } else {
                      window.location.href = preparedUrl;
                    }
                  }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                  pdt.unCloakDebugLevel();
                  apex.debug.info("pdt apexSpotlight GET_URL", errorThrown);

                }
              });

              return false;
            });

          // Escape key pressed once, clear field, twice, close dialog.
          $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).on('keydown', function (e) {
            var input$ = $(apexSpotlight.DOT + apexSpotlight.SP_INPUT);
            if (e.which === apexSpotlight.KEYS.ESCAPE) {
              if (input$.val()) {
                apexSpotlight.resetSpotlight();
                e.stopPropagation();
              } else {
                apexSpotlight.closeDialog();
              }
            }
          });

          apexSpotlight.gHasDialogCreated = true;
        };
        createDialog();
      },
      /**
       * Open Spotlight Dialog
       * @param {object} pFocusElement
       */
      openSpotlightDialog: function (pFocusElement) {
        // Disable Spotlight for Modal Dialog
        if ((window.self !== window.top)) {
          return false;
        }

        apexSpotlight.gHasDialogCreated = $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).length > 0;

        // if already created dialog is from another DA --> destroy existing dialog
        if (apexSpotlight.gHasDialogCreated) {
          if ($(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).attr('data-id') != apexSpotlight.gDynamicActionId) {
            apexSpotlight.resetSpotlight();
            $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).remove();
            apexSpotlight.gHasDialogCreated = false;
          }
        }

        // set selected text to spotlight input
        if (apexSpotlight.gEnablePrefillSelectedText) {
          apexSpotlight.setSelectedText();
        }

        if (apexSpotlight.gEnableDefaultText) {
          apexSpotlight.setSelectedText(apexSpotlight.defaultText);
          $('body').trigger('pdt-apexspotlight-get-data'); // MM : fixes when search input, but no results 
        }

        var openDialog = function () {
          var dlg$ = $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG),
            scrollY = window.scrollY || window.pageYOffset;
          if (!dlg$.hasClass('ui-dialog-content') || !dlg$.dialog("isOpen")) {
            dlg$.dialog({
              width: apexSpotlight.gWidth,
              height: 'auto',
              modal: true,
              position: {
                my: "center top",
                at: "center top+" + (scrollY + 64),
                of: $('body')
              },
              dialogClass: 'ui-dialog--pdt-apexspotlight',
              open: function () {
                apex.event.trigger('body', 'pdt-apexspotlight-open-dialog');

                var dlg$ = $(this);

                dlg$
                  .css('min-height', 'auto')
                  .prev('.ui-dialog-titlebar')
                  .remove();

                apex.navigation.beginFreezeScroll();

                // show history popover
                if (apexSpotlight.gEnableSearchHistory) {
                  apexSpotlight.showTippyHistoryPopover();
                }

                $('.ui-widget-overlay').on('click', function () {
                  apexSpotlight.closeDialog();
                });
                $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).focus();
              },
              create: function () {
              },
              close: function () {
                apex.event.trigger('body', 'pdt-apexspotlight-close-dialog');
                apexSpotlight.resetSpotlight();
                apex.navigation.endFreezeScroll();
                // distroy history popover
                if (apexSpotlight.gEnableSearchHistory) {
                  apexSpotlight.destroyTippyHistoryPopover();
                }
              }
            });
          }
        };

        if (apexSpotlight.gHasDialogCreated) {
          openDialog();
        } else {
          apexSpotlight.createSpotlightDialog(apexSpotlight.gPlaceholderText);
          openDialog();
          apexSpotlight.getSpotlightData(function (data) {
            apexSpotlight.gSearchIndex = $.grep(data, function (e) {
              return e.s == false;
            });
            apexSpotlight.gStaticIndex = $.grep(data, function (e) {
              return e.s == true;
            });
            apex.event.trigger('body', 'pdt-apexspotlight-get-data')//, data);
          });
        }

        focusElement = pFocusElement; // could be useful for shortcuts added by apex.action
      },
      /**
       * In-Page search using mark.js
       * @param {string} pKeyword
       */
      inPageSearch: function (pKeyword) {
        var keyword = pKeyword || apexSpotlight.gKeywords;
        $('body').unmark({
          done: function () {
            apexSpotlight.closeDialog();
            apexSpotlight.resetSpotlight();
            $('body').mark(keyword, {});
            apex.event.trigger('body', 'apexspotlight-inpage-search', {
              "keyword": keyword
            });
          }
        });
      },
      /**
       * Check if resultset markup has dynamic list entries (not static)
       * @return {boolean}
       */
      hasSearchResultsDynamicEntries: function () {
        var hasDynamicEntries = $('li.pdt-apx-Spotlight-result').hasClass('pdt-apx-Spotlight-DYNAMIC') || false;
        return hasDynamicEntries;
      },
      /**
       * Real Plugin handler - called from outer pluginHandler function
       * @param {object} pOptions
       */
      pluginHandler: function (pOptions) {
        // plugin attributes
        var dynamicActionId = apexSpotlight.gDynamicActionId = pOptions.dynamicActionId;
        var ajaxIdentifier = apexSpotlight.gAjaxIdentifier = pOptions.ajaxIdentifier;
        var eventName = pOptions.eventName;
        var fireOnInit = pOptions.fireOnInit;

        var placeholderText = apexSpotlight.gPlaceholderText = pOptions.placeholderText;
        var moreCharsText = apexSpotlight.gMoreCharsText = pOptions.moreCharsText;
        var noMatchText = apexSpotlight.gNoMatchText = pOptions.noMatchText;
        var oneMatchText = apexSpotlight.gOneMatchText = pOptions.oneMatchText;
        var multipleMatchesText = apexSpotlight.gMultipleMatchesText = pOptions.multipleMatchesText;
        var inPageSearchText = apexSpotlight.gInPageSearchText = pOptions.inPageSearchText;
        var searchHistoryDeleteText = apexSpotlight.gSearchHistoryDeleteText = pOptions.searchHistoryDeleteText;

        var enableKeyboardShortcuts = pOptions.enableKeyboardShortcuts;
        var keyboardShortcuts = pOptions.keyboardShortcuts;
        var submitItems = pOptions.submitItems;
        var enableInPageSearch = pOptions.enableInPageSearch;
        var maxNavResult = apexSpotlight.gMaxNavResult = pOptions.maxNavResult;
        var width = apexSpotlight.gWidth = pOptions.width;
        var enableDataCache = pOptions.enableDataCache;
        var spotlightTheme = pOptions.spotlightTheme;
        var enablePrefillSelectedText = pOptions.enablePrefillSelectedText;
        var showProcessing = pOptions.showProcessing;
        var placeHolderIcon = pOptions.placeHolderIcon;
        var enableSearchHistory = pOptions.enableSearchHistory;

        var defaultText = apexSpotlight.gDefaultText = pOptions.defaultText;
        var appLimit = apexSpotlight.gAppLimit = pOptions.appLimit;

        var submitItemsArray = [];
        var openDialog = true;

        // debug
        let pdtSpotlightOptions = {};
        pdtSpotlightOptions.dynamicActionId = dynamicActionId;
        pdtSpotlightOptions.ajaxIdentifier = ajaxIdentifier;
        pdtSpotlightOptions.eventName = eventName;
        pdtSpotlightOptions.fireOnInit = fireOnInit;
        pdtSpotlightOptions.placeholderText = placeholderText;
        pdtSpotlightOptions.moreCharsText = moreCharsText;
        pdtSpotlightOptions.noMatchText = noMatchText;
        pdtSpotlightOptions.oneMatchText = oneMatchText;
        pdtSpotlightOptions.multipleMatchesText = multipleMatchesText;
        pdtSpotlightOptions.inPageSearchText = inPageSearchText;
        pdtSpotlightOptions.searchHistoryDeleteText = searchHistoryDeleteText;
        pdtSpotlightOptions.enableKeyboardShortcuts = enableKeyboardShortcuts;
        pdtSpotlightOptions.keyboardShortcuts = keyboardShortcuts;
        pdtSpotlightOptions.submitItems = submitItems;
        pdtSpotlightOptions.enableInPageSearch = enableInPageSearch;
        pdtSpotlightOptions.maxNavResult = maxNavResult;
        pdtSpotlightOptions.width = width;
        pdtSpotlightOptions.enableDataCache = enableDataCache;
        pdtSpotlightOptions.spotlightTheme = spotlightTheme;
        pdtSpotlightOptions.enablePrefillSelectedText = enablePrefillSelectedText;
        pdtSpotlightOptions.showProcessing = showProcessing;
        pdtSpotlightOptions.placeHolderIcon = placeHolderIcon;
        pdtSpotlightOptions.enableSearchHistory = enableSearchHistory;
        pdtSpotlightOptions.appLimit = appLimit;
        apex.debug.info({ pdtSpotlightOptions });



        // polyfill for older browsers like IE (startsWith & includes functions)
        if (!String.prototype.startsWith) {
          String.prototype.startsWith = function (search, pos) {
            return this.substr(!pos || pos < 0 ? 0 : +pos, search.length) === search;
          };
        }
        if (!String.prototype.includes) {
          String.prototype.includes = function (search, start) {
            'use strict';
            if (typeof start !== 'number') {
              start = 0;
            }

            if (start + search.length > this.length) {
              return false;
            } else {
              return this.indexOf(search, start) !== -1;
            }
          };
        }

        // set boolean global vars
        apexSpotlight.gEnableInPageSearch = (enableInPageSearch == 'Y') ? true : false;
        apexSpotlight.gEnableDataCache = (enableDataCache == 'Y') ? true : false;
        apexSpotlight.gEnablePrefillSelectedText = (enablePrefillSelectedText == 'Y') ? true : false;
        apexSpotlight.gShowProcessing = (showProcessing == 'Y') ? true : false;
        apexSpotlight.gEnableSearchHistory = (enableSearchHistory == 'Y') ? true : false;
        apexSpotlight.gEnableDefaultText = (defaultText) ? true : false;
        apexSpotlight.defaultText = defaultText;

        // build page items to submit array
        if (submitItems) {
          submitItemsArray = apexSpotlight.gSubmitItemsArray = submitItems.split(',');
        }

        // set spotlight theme
        switch (spotlightTheme) {
          case 'ORANGE':
            apexSpotlight.gResultListThemeClass = 'pdt-apx-Spotlight-result-orange';
            apexSpotlight.gIconThemeClass = 'pdt-apx-Spotlight-icon-orange';
            break;
          case 'RED':
            apexSpotlight.gResultListThemeClass = 'pdt-apx-Spotlight-result-red';
            apexSpotlight.gIconThemeClass = 'pdt-apx-Spotlight-icon-red';
            break;
          case 'DARK':
            apexSpotlight.gResultListThemeClass = 'pdt-apx-Spotlight-result-dark';
            apexSpotlight.gIconThemeClass = 'pdt-apx-Spotlight-icon-dark';
            break;
        }

        // set search placeholder icon
        if (placeHolderIcon === 'DEFAULT') {
          apexSpotlight.gPlaceHolderIcon = 'a-Icon icon-search';
        } else {
          apexSpotlight.gPlaceHolderIcon = 'fa ' + placeHolderIcon;
        }

        // checks for opening dialog
        if (eventName == 'keyboardShortcut' || fireOnInit == 'Y') {
          openDialog = true;
        } else if (eventName == 'ready') {
          openDialog = false;
        } else {
          openDialog = true;
        }

        // trigger input and search again --> if search input has some value and getData request has finshed
        $('body').on('pdt-apexspotlight-get-data', function () {
          if (apexSpotlight.gHasDialogCreated && (!apexSpotlight.hasSearchResultsDynamicEntries())) {
            var searchValue = $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val().trim();
            if (searchValue) {
              apexSpotlight.search(searchValue);
              $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).trigger('input');
            }
          }
        });

        $('body').on('pdt-apexspotlight-prefetch-data', function () {
          pdt.opt.spotlightPrefetching = true;
          $('.pdt-spotlight-devbar-entry').addClass('fa-refresh pdt-prefetching fa-anim-spin');
          apexSpotlight.vfetchStartTime = new Date();
          apexSpotlight.getSpotlightData(function (data) {
            const vfetchEndTime = new Date();
            const duration = vfetchEndTime - apexSpotlight.vfetchStartTime;
            apex.debug.info('Spotlight Data Ready in ' + duration + 'ms');
          });
        });

        // open dialog
        if (openDialog) {
          apexSpotlight.openSpotlightDialog();
        }
      }
    }; // end namespace apexSpotlight

    // call real pluginHandler function
    apexSpotlight.pluginHandler(pOptions);
  }
};

