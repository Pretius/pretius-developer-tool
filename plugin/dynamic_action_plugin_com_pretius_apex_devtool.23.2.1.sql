prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>2282420131933307
,p_default_application_id=>147
,p_default_id_offset=>0
,p_default_owner=>'WKSP_X'
);
end;
/
 
prompt APPLICATION 147 - PDT
--
-- Application Export:
--   Application:     147
--   Name:            PDT
--   Date and Time:   13:33 Sunday April 7, 2024
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 236191428466094549
--   Manifest End
--   Version:         23.2.3
--   Instance ID:     8567745099245431
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_pretius_apex_devtool
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(236191428466094549)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.PRETIUS.APEX.DEVTOOL'
,p_display_name=>'Pretius Developer Tool'
,p_category=>'INIT'
,p_image_prefix=>'&APP_PRETIUS_DEVTOOL_PREFIX.'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES##MIN_DIRECTORY#pretiusDeveloperTool#MIN#.js',
'#PLUGIN_FILES#revealer/#MIN_DIRECTORY#jquery.ui.dialog-collapse#MIN#.js',
'#PLUGIN_FILES#revealer/#MIN_DIRECTORY#contentRevealer#MIN#.js',
'#PLUGIN_FILES#revealer/#MIN_DIRECTORY#revealer#MIN#.js',
'#PLUGIN_FILES#reload-frame/#MIN_DIRECTORY#contentReloadFrame#MIN#.js',
'#PLUGIN_FILES#libs/mousetrap/mousetrap.min.js',
'#PLUGIN_FILES#libs/mousetrap/mousetrap-global-bind.min.js',
'#PLUGIN_FILES#libs/pako/pako.min.js',
'#PLUGIN_FILES#build-option-highlight/#MIN_DIRECTORY#contentBuildOptionHighlight#MIN#.js',
'#PLUGIN_FILES#dev-bar/#MIN_DIRECTORY#pretiusToolbar#MIN#.js',
'#PLUGIN_FILES#dev-bar/#MIN_DIRECTORY#contentDevBar#MIN#.js',
'#PLUGIN_FILES#dev-bar/#MIN_DIRECTORY#apexspotlight#MIN#.js'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#revealer/#MIN_DIRECTORY#revealer#MIN#.css',
'#PLUGIN_FILES#revealer/#MIN_DIRECTORY#jquery.ui.dialog-collapse#MIN#.css',
'#PLUGIN_FILES#build-option-highlight/#MIN_DIRECTORY#contentBuildOptionHighlight#MIN#.css',
'#PLUGIN_FILES#dev-bar/#MIN_DIRECTORY#apexspotlight#MIN#.css',
'#PLUGIN_FILES#dev-bar/#MIN_DIRECTORY#dev-bar#MIN#.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   /*',
'    * Plugin:   Pretius Developer Tool',
'    * Version:  23.2.1',
'    *',
'    * License:  MIT License Copyright 2022 Pretius Sp. z o.o. Sp. K.',
'    * Homepage: ',
'    * Mail:     apex-plugins@pretius.com',
'    * Issues:   https://github.com/Pretius/pretius-developer-tool/issues',
'    *',
'    * Author:   Matt Mulvaney',
'    * Mail:     mmulvaney@pretius.com',
'    * Twitter:  Matt_Mulvaney',
'    *',
'    */',
'  FUNCTION render(',
'    p_dynamic_action IN apex_plugin.t_dynamic_action,',
'    p_plugin         IN apex_plugin.t_plugin ',
'  ) RETURN apex_plugin.t_dynamic_action_render_result',
'  IS',
'    v_result              apex_plugin.t_dynamic_action_render_result; ',
'    l_plugs_row           APEX_APPL_PLUGINS%ROWTYPE;',
'    l_configuration_test  NUMBER DEFAULT 0;',
'    c_plugin_name         CONSTANT VARCHAR2(24) DEFAULT ''COM.PRETIUS.APEX.DEVTOOL'';',
'    l_application_group   apex_applications.application_group%TYPE DEFAULT NULL;',
'    c_app_id              CONSTANT apex_applications.application_id%TYPE DEFAULT v(''APP_ID'');',
'  BEGIN',
'    -- Debug',
'    IF apex_application.g_debug ',
'    THEN',
'      apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                            p_dynamic_action => p_dynamic_action);',
'    END IF;',
'    SELECT *',
'      INTO l_plugs_row',
'      FROM apex_appl_plugins',
'     WHERE application_id = c_app_id',
'       AND name = c_plugin_name;',
'',
'      SELECT application_group',
'        INTO l_application_group',
'        FROM apex_applications',
'       WHERE application_id = c_app_id;',
'',
'    SELECT count(*)',
'     INTO l_configuration_test',
'     from APEX_APPLICATION_PAGE_DA_ACTS a,',
'          APEX_APPLICATION_PAGE_DA d,',
'          apex_application_build_options b',
'    where a.application_id = c_app_id ',
'      and a.page_id = 0',
'      and a.action_code = ''PLUGIN_'' || c_plugin_name',
'      and d.dynamic_action_id = a.dynamic_action_id',
'      and d.build_option_id = b.build_option_id',
'      and b.status_on_export = ''Exclude'';',
'',
'    IF NVL( l_configuration_test, 0 ) = 0',
'    THEN',
'      SELECT count(*)',
'      INTO l_configuration_test',
'      from APEX_APPLICATION_PAGE_DA_ACTS a,',
'            apex_application_build_options b',
'      where a.application_id = c_app_id ',
'        and a.page_id = 0',
'        and a.action_code = ''PLUGIN_'' || c_plugin_name',
'        and a.build_option_id = b.build_option_id',
'        and b.status_on_export = ''Exclude'';',
'    END IF;',
'',
'    v_result.javascript_function := ',
'    apex_string.format(',
'    q''[function render() {',
'        pdt.render({',
'            da: this,',
'            opt: {',
'                filePrefix: "%s",',
'                ajaxIdentifier: "%s",',
'                version: "%s",',
'                debugPrefix: "%s",',
'                configurationTest: "%s",',
'                dynamicActionId: "%s",',
'                applicationGroupName: "%s",',
'                env: {',
'                    APP_ID: "%s",',
'                    APP_PAGE_ID: "%s"',
'                    }',
'                }',
'            });',
'        }]'',',
'    p_plugin.file_prefix,',
'    apex_plugin.get_ajax_identifier,',
'    l_plugs_row.version_identifier,',
'    l_plugs_row.display_name || '': '',',
'    apex_debug.tochar( l_configuration_test = 1 ),',
'    p_dynamic_action.id,',
'    NVL( l_application_group, ''- Unassigned -''  ),',
'    c_app_id,',
'    v(''APP_PAGE_ID'')',
'    );',
' ',
'    RETURN v_result;',
'  ',
'  EXCEPTION',
'    WHEN OTHERS then',
'      htp.p( SQLERRM );',
'      return v_result;',
'  END render;',
'  PROCEDURE ajax_build_option_excluded',
'  IS',
'    c sys_refcursor;',
'  BEGIN',
'    OPEN c for',
'     WITH ITEMS AS ',
'     (',
'      SELECT i.item_name,  ',
'             b.build_option_name,',
'             ''ITEM'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM apex_application_page_items i,',
'             apex_application_build_options b',
'       WHERE i.application_id = v(''APP_ID'')',
'         AND i.page_id IN ( v(''APP_PAGE_ID''), 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    REGIONS AS  ',
' (     SELECT NVL( i.static_id, ''R'' || region_id ) item_name,  ',
'             b.build_option_name,',
'             ''REGION'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM apex_application_page_regions i,',
'             apex_application_build_options b',
'       WHERE i.application_id = v(''APP_ID'')',
'         AND i.page_id IN ( v(''APP_PAGE_ID''), 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    IG_COLS AS',
'    (',
'    SELECT NVL2( i.static_id, i.static_id || ''_HDR'', ''R'' || column_id || ''_ig_grid_vc_cur'' ) item_name,  ',
'             b.build_option_name,',
'             ''IG_COL'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM APEX_APPL_PAGE_IG_COLUMNS i,',
'             apex_application_build_options b',
'       WHERE i.application_id = v(''APP_ID'')',
'         AND i.page_id IN ( v(''APP_PAGE_ID''), 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    IR_COLS AS',
' (     SELECT NVL( i.static_id, ''C'' || column_id ) item_name,  ',
'             b.build_option_name,',
'             ''IR_COL'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM apex_application_page_ir_col i,',
'             apex_application_build_options b',
'       WHERE i.application_id = v(''APP_ID'')',
'         AND i.page_id IN ( v(''APP_PAGE_ID''), 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    BUTTONS AS  ',
' (     SELECT NVL( button_static_id, ''B'' || button_id )  item_name,  ',
'             b.build_option_name,',
'             ''BUTTON'' page_item_type,',
'             REPLACE( RTRIM(REPLACE(  i.build_option, ''{Not '' || b.build_option_name, ''-''), ''}'') , b.build_option_name ) || b.status_on_export status',
'        FROM apex_application_page_buttons i,',
'             apex_application_build_options b',
'       WHERE i.application_id = v(''APP_ID'')',
'         AND i.page_id IN ( v(''APP_PAGE_ID''), 0 )',
'         AND  i.build_option  IN ( ''{Not '' || b.build_option_name || ''}'',  b.build_option_name  )',
'          )',
'    SELECT item_name,',
'           build_option_name,',
'           page_item_type,',
'           CASE status ',
'             WHEN ''-Include''',
'               THEN ''Exlude''',
'             WHEN ''-Exlude''',
'               THEN ''Include''',
'             ELSE ',
'               status',
'             END status',
'        FROM ( ',
'              SELECT * FROM items ',
'               UNION ALL',
'               SELECT * FROM regions ',
'               UNION ALL',
'               SELECT * FROM buttons',
'               UNION ALL',
'               SELECT * FROM ir_cols ',
'               UNION ALL',
'               SELECT * FROM ig_cols',
'               );',
'    apex_json.open_object;',
'    apex_json.write( ''items'', c);',
'    apex_json.close_object;  ',
'  END ajax_build_option_excluded;',
'  PROCEDURE ajax_debug_detail',
'  IS',
'    c sys_refcursor;',
'  BEGIN',
'    OPEN c for',
'        select elapsed_time "Elapsed",',
'            execution_time "Execution",',
'            message "Message",',
'            message_level "Level",',
'            TO_CHAR( ROUND(RATIO_TO_REPORT(NVL(execution_time, 0)) OVER () * 100, 1 ), ''990.00'' ) AS "Ratio"',
'        from APEX_DEBUG_MESSAGES  ',
'        where  page_view_id = apex_application.g_x02 ',
'        order by  message_timestamp, id;',
'    apex_json.open_object;',
'    apex_json.write( ''items'', c);',
'    apex_json.close_object; ',
'  END ajax_debug_detail;',
'  PROCEDURE ajax_debug_view',
'  IS',
'    c sys_refcursor;',
'  BEGIN',
'    OPEN c for',
'       with data as ( select ',
'            PAGE_VIEW_ID, ',
'            session_id,',
'            max(apex_user) apex_user,',
'            application_id,',
'            page_id,',
'            max(MESSAGE_TIMESTAMP) - min(MESSAGE_TIMESTAMP) diff,',
'            max(MESSAGE_TIMESTAMP) max_timestamp,',
'            count(id) entries',
'        from APEX_DEBUG_MESSAGES ',
'        where INSTR( apex_application.g_x02, '':'' || page_id || '':'' ) > 0',
'        and application_id = v(''APP_ID'')',
'        group by ',
'            PAGE_VIEW_ID, ',
'            session_id, ',
'            application_id,',
'            page_id',
'        ),',
'        prepared as (',
'        select  ',
'            d.PAGE_VIEW_ID "View Identifier",',
'            d.session_id "Session Id",',
'            d.apex_user "User",',
'            d.application_id "Application",',
'            d.page_id "Page",',
'            CASE a.page_view_type ',
'            WHEN ''Ajax'' THEN ''ajax plugin''',
'            WHEN ''Rendering'' THEN ''show''',
'            WHEN ''Processing'' THEN RTRIM( ''accept '' || a.REQUEST_VALUE )',
'            ELSE a.page_view_type ',
'            END "Path Info",',
'            d.entries "Entries",',
'            apex_util.get_since(d.max_timestamp) "Timestamp",',
'            to_char(',
'                extract( day from d.diff )*24*60*60*1000 +',
'                extract( hour from d.diff )*60*60*1000 +',
'                extract( minute from d.diff )*60*1000 +',
'                extract( second from d.diff ), ''0.0000'') "Seconds"',
'        from data d, ',
'             APEX_WORKSPACE_ACTIVITY_LOG a',
'      where d.page_view_id = debug_page_view_id',
'        order by max_timestamp desc )',
'        SELECT *',
'          FROM prepared ',
'        WHERE rownum <= 10;',
'    apex_json.open_object;',
'    apex_json.write( ''items'', c);',
'    apex_json.close_object; ',
'  END ajax_debug_view;',
'  PROCEDURE ajax_revealer',
'  IS',
'    c sys_refcursor;',
'    l_subs_clob           CLOB DEFAULT NULL;',
'    l_host_address        VARCHAR2(512) DEFAULT NULL;',
'    l_host_name           VARCHAR2(512) DEFAULT NULL;',
'    PROCEDURE p_write( p_name VARCHAR2, p_value VARCHAR2 )',
'    IS',
'    BEGIN',
'        apex_json.open_object;',
'        apex_json.write(''Name'', p_name );',
'        apex_json.write(''Value'', p_value );',
'        apex_json.close_object;',
'    END p_write;',
'    FUNCTION f_get_host_address',
'    RETURN VARCHAR2',
'    IS',
'    BEGIN',
'       RETURN UTL_INADDR.get_host_address;',
'    EXCEPTION',
'      WHEN OTHERS',
'      THEN',
'         RETURN ''[Unavailable]'';',
'    END f_get_host_address;',
'    FUNCTION f_get_host_name',
'    RETURN VARCHAR2',
'    IS',
'    BEGIN',
'       RETURN UTL_INADDR.GET_HOST_NAME(f_get_host_address);',
'    EXCEPTION',
'      WHEN OTHERS',
'      THEN',
'         RETURN ''[Unavailable]'';',
'    END f_get_host_name;',
'  BEGIN',
'    l_host_address        := f_get_host_address;',
'    l_host_name           := f_get_host_name;',
'        apex_json.initialize_clob_output( p_preserve => true );',
'        apex_json.open_array; ',
'            p_write( ''APEX$ROW_NUM'', v(''APEX$ROW_NUM'') );',
'            p_write( ''APEX$ROW_SELECTOR'', v(''APEX$ROW_SELECTOR'') );',
'            p_write( ''APEX$ROW_STATUS'', v(''APEX$ROW_STATUS'') );',
'            p_write( ''APP_ID'', v(''APP_ID'') );',
'            p_write( ''APP_ALIAS'', v(''APP_ALIAS'') );',
'            p_write( ''APP_AJAX_X01'', v(''APP_AJAX_X01'') );',
'            p_write( ''APP_AJAX_X02'', v(''APP_AJAX_X02'') );',
'            p_write( ''APP_AJAX_X03'', v(''APP_AJAX_X03'') );',
'            p_write( ''APP_AJAX_X04'', v(''APP_AJAX_X04'') );',
'            p_write( ''APP_AJAX_X05'', v(''APP_AJAX_X05'') );',
'            p_write( ''APP_AJAX_X06'', v(''APP_AJAX_X06'') );',
'            p_write( ''APP_AJAX_X07'', v(''APP_AJAX_X07'') );',
'            p_write( ''APP_AJAX_X08'', v(''APP_AJAX_X08'') );',
'            p_write( ''APP_AJAX_X09'', v(''APP_AJAX_X09'') );',
'            p_write( ''APP_AJAX_X10'', v(''APP_AJAX_X10'') );',
'            p_write( ''APP_BUILDER_SESSION'', v(''APP_BUILDER_SESSION'') );',
'            p_write( ''APP_DATE_TIME_FORMAT'', v(''APP_DATE_TIME_FORMAT'') );',
'            p_write( ''APP_IMAGES'', v(''APP_IMAGES'') );',
'            p_write( ''APP_NLS_DATE_FORMAT'', v(''APP_NLS_DATE_FORMAT'') );',
'            p_write( ''APP_NLS_TIMESTAMP_FORMAT'', v(''APP_NLS_TIMESTAMP_FORMAT'') );',
'            p_write( ''APP_NLS_TIMESTAMP_TZ_FORMAT'', v(''APP_NLS_TIMESTAMP_TZ_FORMAT'') );',
'            p_write( ''APP_PAGE_ALIAS'', v(''APP_PAGE_ALIAS'') );',
'            p_write( ''APP_PAGE_ID'', v(''APP_PAGE_ID'') );',
'            p_write( ''APP_REQUEST_DATA_HASH'', v(''APP_REQUEST_DATA_HASH'') );',
'            p_write( ''APP_SESSION'', v(''APP_SESSION'') );',
'            p_write( ''APP_SESSION_VISIBLE'', v(''APP_SESSION_VISIBLE'') );',
'            p_write( ''APP_TITLE'', v(''APP_TITLE'') );',
'            p_write( ''APP_UNIQUE_PAGE_ID'', v(''APP_UNIQUE_PAGE_ID'') );',
'            p_write( ''APP_USER'', v(''APP_USER'') );',
'            p_write( ''AUTHENTICATED_URL_PREFIX'', v(''AUTHENTICATED_URL_PREFIX'') );',
'            p_write( ''BROWSER_LANGUAGE'', v(''BROWSER_LANGUAGE'') );',
'            p_write( ''CURRENT_PARENT_TAB_TEXT'', ''&CURRENT_PARENT_TAB_TEXT.'' );',
'            p_write( ''Vars'', v(''Vars'') );',
'            p_write( ''DEBUG'', v(''DEBUG'') );',
'            p_write( ''HOME_LINK'', v(''HOME_LINK'') );',
'            p_write( ''IMAGE_PREFIX'', v(''IMAGE_PREFIX'') );',
'            p_write( ''JET_BASE_DIRECTORY'', ''#JET_BASE_DIRECTORY#'' );',
'            p_write( ''JET_CSS_DIRECTORY'', ''#JET_CSS_DIRECTORY#'' );',
'            p_write( ''JET_JS_DIRECTORY'', ''#JET_JS_DIRECTORY#'' );',
'            p_write( ''LOGIN_URL'', v(''LOGIN_URL'') );',
'            p_write( ''LOGOUT_URL'', v(''LOGOUT_URL'') );',
'            p_write( ''APP_TEXT$Message_Name'', v(''APP_TEXT$Message_Name'') );',
'            p_write( ''APP_TEXT$Message_Name$Lang'', v(''APP_TEXT$Message_Name$Lang'') );',
'            p_write( ''PRINTER_FRIENDLY'', v(''PRINTER_FRIENDLY'') );',
'            p_write( ''PROXY_SERVER'', APEX_APPLICATION.G_PROXY_SERVER );',
'            p_write( ''PUBLIC_URL_PREFIX'', v(''PUBLIC_URL_PREFIX'') );',
'            p_write( ''REQUEST'', v(''REQUEST'') );',
'            p_write( ''SCHEMA OWNER'', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER );',
'            p_write( ''SQLERRM'', ''#SQLERRM#'' );',
'            p_write( ''SYSDATE_YYYYMMDD'', v(''SYSDATE_YYYYMMDD'') );',
'            p_write( ''THEME_DB_IMAGES'', ''#THEME_DB_IMAGES#'' );',
'            p_write( ''THEME_IMAGES'', ''#THEME_IMAGES#'' );',
'            p_write( ''WORKSPACE_IMAGES'', v(''WORKSPACE_IMAGES'') );',
'            p_write( ''WORKSPACE_ID'', v(''WORKSPACE_ID'') );        ',
'        apex_json.close_array;',
'        l_subs_clob := apex_json.get_clob_output;',
'        apex_json.free_output;',
'    open c ',
'    for ',
'    with scrape as (',
'        select',
'            "Page",',
'            "Name",',
'            "Type",',
'            "Page Value",',
'            NVL(v("Name"), '' '' ) "Session Value",',
'            "Category"',
'        from xmltable(',
'            ''/json/row''',
'            passing apex_json.to_xmltype_sql( apex_application.g_clob_01, ',
'                                            p_strict => ''N'' )',
'            columns',
'            "Page" VARCHAR2(32) path ''Page/text()'',',
'            "Name" VARCHAR2(128) path ''Name/text()'',',
'            "Type" VARCHAR2(32) path ''Type/text()'',',
'            "Page Value" VARCHAR2(4000) path ''Value/text()'',',
'            "Category" VARCHAR2(32) path ''Category/text()''',
'        )),',
'        nonRenderedItems as (',
'            SELECT TO_CHAR( page_id ) page_id,',
'                   item_name',
'              FROM apex_application_page_items',
'             WHERE INSTR( apex_application.g_x02, '':'' || page_id || '':'' ) > 0',
'               AND application_id = v(''APP_ID'')',
'              MINUS',
'            SELECT "Page", ',
'                   "Name"',
'              FROM scrape',
'        ),',
'        nonRendered as (',
'             SELECT TO_CHAR(pi.page_id) "Page",',
'                    pi.item_name "Name",',
'                    TRIM( REPLACE( UPPER ( display_as ), ''FIELD'' ) ) "Type",',
'                    NULL "Page Value",',
'                    NVL(v(pi.item_name), '' '' ) "Session Value",',
'                    ''NR,PI,P'' || CASE pi.page_id WHEN 0 THEN ''0'' ELSE ''X'' END "Category"',
'               FROM apex_application_page_items pi,',
'                    nonRenderedItems nr',
'              WHERE pi.page_id = nr.page_id',
'                AND pi.item_name = nr.item_name',
'                AND pi.application_id = v(''APP_ID'')',
'        )',
'        SELECT * ',
'        from scrape',
'        UNION ALL',
'        SELECT * ',
'        from nonRendered',
'        UNION ALL',
'        SELECT ''*'',',
'            item_name,',
'            ''APPLICATION ITEM'',',
'            NULL,',
'            v(item_name),',
'            ''AI''',
'        FROM apex_application_items',
'        WHERE application_id = v(''APP_ID'')',
'        UNION ALL',
'        SELECT ''*'',',
'            "Name",',
'            ''APEX SUBSTITUTION'',',
'            NULL,',
'            "Value",',
'            ''SB''',
'        from xmltable(',
'            ''/json/row''',
'            passing apex_json.to_xmltype_sql( l_subs_clob, ',
'                                            p_strict => ''N'' )',
'            columns',
'            "Name" VARCHAR2(128) path ''Name/text()'',',
'            "Value" VARCHAR2(4000) path ''Value/text()''',
'        )',
'        UNION ALL',
'        SELECT ''*'',',
'            SUBSTITUTION_STRING,',
'            ''APPLICATION SUBSTITUTION'',',
'            NULL,',
'            SUBSTITUTION_VALUE,',
'            ''SB''',
'        FROM APEX_APPLICATION_SUBSTITUTIONS',
'        WHERE application_id = v(''APP_ID'')',
'        UNION ALL',
'        SELECT ''*'',',
'            name,',
'            ''APEX'',',
'            NULL,',
'            val,',
'            ''AP''',
'        FROM ( SELECT *',
'                FROM   (SELECT version_no, ',
'                               api_compatibility, ',
'                               patch_applied',
'                          FROM apex_release)',
'                UNPIVOT (val for name in (version_no, api_compatibility, patch_applied) ) )',
'        UNION ALL',
'        SELECT ''*'',',
'            name,',
'            ''DATABASE'',',
'            NULL,',
'            val,',
'            ''AP''',
'        FROM ( SELECT *',
'                FROM   (SELECT product, ',
'                            version,',
'                            status',
'                        FROM   product_component_version )',
'                UNPIVOT  (val for name in (product, version, status)  )',
'                UNION ALL',
'                SELECT ''GLOBAL_NAME'' name, global_name FROM GLOBAL_NAME',
'                UNION ALL',
'                SELECT ''HOST_ADDRESS''name, l_host_address FROM dual',
'                UNION ALL',
'                SELECT ''HOST_NAME'' name, l_host_name val FROM dual ',
'                )',
'        UNION ALL',
'        SELECT ''*'',',
'            name,',
'            ''USERENV CONTEXT'',',
'            NULL,',
'            val,',
'            ''CX''',
'        FROM (',
'                -- https://stackoverflow.com/a/18879366',
'                select res.*',
'                from (',
'                select *',
'                    from (',
'                        select',
'                        sys_context (''userenv'',''ACTION'') ACTION,',
'                        sys_context (''userenv'',''AUDITED_CURSORID'') AUDITED_CURSORID,',
'                        sys_context (''userenv'',''AUTHENTICATED_IDENTITY'') AUTHENTICATED_IDENTITY,',
'                        sys_context (''userenv'',''AUTHENTICATION_DATA'') AUTHENTICATION_DATA,',
'                        sys_context (''userenv'',''AUTHENTICATION_METHOD'') AUTHENTICATION_METHOD,',
'                        sys_context (''userenv'',''BG_JOB_ID'') BG_JOB_ID,',
'                        sys_context (''userenv'',''CLIENT_IDENTIFIER'') CLIENT_IDENTIFIER,',
'                        sys_context (''userenv'',''CLIENT_INFO'') CLIENT_INFO,',
'                        sys_context (''userenv'',''CURRENT_BIND'') CURRENT_BIND,',
'                        sys_context (''userenv'',''CURRENT_EDITION_ID'') CURRENT_EDITION_ID,',
'                        sys_context (''userenv'',''CURRENT_EDITION_NAME'') CURRENT_EDITION_NAME,',
'                        sys_context (''userenv'',''CURRENT_SCHEMA'') CURRENT_SCHEMA,',
'                        sys_context (''userenv'',''CURRENT_SCHEMAID'') CURRENT_SCHEMAID,',
'                        sys_context (''userenv'',''CURRENT_SQL'') CURRENT_SQL,',
'                        sys_context (''userenv'',''CURRENT_SQLn'') CURRENT_SQLn,',
'                        sys_context (''userenv'',''CURRENT_SQL_LENGTH'') CURRENT_SQL_LENGTH,',
'                        sys_context (''userenv'',''CURRENT_USER'') CURRENT_USER,',
'                        sys_context (''userenv'',''CURRENT_USERID'') CURRENT_USERID,',
'                        sys_context (''userenv'',''DATABASE_ROLE'') DATABASE_ROLE,',
'                        sys_context (''userenv'',''DB_DOMAIN'') DB_DOMAIN,',
'                        sys_context (''userenv'',''DB_NAME'') DB_NAME,',
'                        sys_context (''userenv'',''DB_UNIQUE_NAME'') DB_UNIQUE_NAME,',
'                        sys_context (''userenv'',''DBLINK_INFO'') DBLINK_INFO,',
'                        sys_context (''userenv'',''ENTRYID'') ENTRYID,',
'                        sys_context (''userenv'',''ENTERPRISE_IDENTITY'') ENTERPRISE_IDENTITY,',
'                        sys_context (''userenv'',''FG_JOB_ID'') FG_JOB_ID,',
'                        sys_context (''userenv'',''GLOBAL_CONTEXT_MEMORY'') GLOBAL_CONTEXT_MEMORY,',
'                        sys_context (''userenv'',''GLOBAL_UID'') GLOBAL_UID,',
'                        sys_context (''userenv'',''HOST'') HOST,',
'                        sys_context (''userenv'',''IDENTIFICATION_TYPE'') IDENTIFICATION_TYPE,',
'                        sys_context (''userenv'',''INSTANCE'') INSTANCE,',
'                        sys_context (''userenv'',''INSTANCE_NAME'') INSTANCE_NAME,',
'                        sys_context (''userenv'',''IP_ADDRESS'') IP_ADDRESS,',
'                        sys_context (''userenv'',''ISDBA'') ISDBA,',
'                        sys_context (''userenv'',''LANG'') LANG,',
'                        sys_context (''userenv'',''LANGUAGE'') LANGUAGE,',
'                        sys_context (''userenv'',''MODULE'') MODULE,',
'                        sys_context (''userenv'',''NETWORK_PROTOCOL'') NETWORK_PROTOCOL,',
'                        sys_context (''userenv'',''NLS_CALENDAR'') NLS_CALENDAR,',
'                        sys_context (''userenv'',''NLS_CURRENCY'') NLS_CURRENCY,',
'                        sys_context (''userenv'',''NLS_DATE_FORMAT'') NLS_DATE_FORMAT,',
'                        sys_context (''userenv'',''NLS_DATE_LANGUAGE'') NLS_DATE_LANGUAGE,',
'                        sys_context (''userenv'',''NLS_SORT'') NLS_SORT,',
'                        sys_context (''userenv'',''NLS_TERRITORY'') NLS_TERRITORY,',
'                        sys_context (''userenv'',''OS_USER'') OS_USER,',
'                        sys_context (''userenv'',''POLICY_INVOKER'') POLICY_INVOKER,',
'                        sys_context (''userenv'',''PROXY_ENTERPRISE_IDENTITY'') PROXY_ENTERPRISE_IDENTITY,',
'                        sys_context (''userenv'',''PROXY_USER'') PROXY_USER,',
'                        sys_context (''userenv'',''PROXY_USERID'') PROXY_USERID,',
'                        sys_context (''userenv'',''SERVER_HOST'') SERVER_HOST,',
'                        sys_context (''userenv'',''SERVICE_NAME'') SERVICE_NAME,',
'                        sys_context (''userenv'',''SESSION_EDITION_ID'') SESSION_EDITION_ID,',
'                        sys_context (''userenv'',''SESSION_EDITION_NAME'') SESSION_EDITION_NAME,',
'                        sys_context (''userenv'',''SESSION_USER'') SESSION_USER,',
'                        sys_context (''userenv'',''SESSION_USERID'') SESSION_USERID,',
'                        sys_context (''userenv'',''SESSIONID'') SESSIONID,',
'                        sys_context (''userenv'',''SID'') SID,',
'                        sys_context (''userenv'',''STATEMENTID'') STATEMENTID,',
'                        sys_context (''userenv'',''TERMINAL'') TERMINAL',
'                        from dual',
'                    )',
'                    unpivot include nulls (',
'                        val for name in (action, audited_cursorid, authenticated_identity, authentication_data, authentication_method, bg_job_id, client_identifier, client_info, current_bind, current_edition_id, current_edition_name, current_schema, '
||'current_schemaid, current_sql, current_sqln, current_sql_length, current_user, current_userid, database_role, db_domain, db_name, db_unique_name, dblink_info, entryid, enterprise_identity, fg_job_id, global_context_memory, global_uid, host, identific'
||'ation_type, instance, instance_name, ip_address, isdba, lang, language, module, network_protocol, nls_calendar, nls_currency, nls_date_format, nls_date_language, nls_sort, nls_territory, os_user, policy_invoker, proxy_enterprise_identity, proxy_user,'
||' proxy_userid, server_host, service_name, session_edition_id, session_edition_name, session_user, session_userid, sessionid, sid, statementid, terminal)',
'                )',
'            ) res',
'        )',
'        ; ',
'        apex_json.open_object;',
'        apex_json.write( ''items'', c);',
'        apex_json.close_object; ',
'  END ajax_revealer;',
' ',
'  --',
'  -- Execute Spotlight GET_DATA Request',
'  PROCEDURE ajax_spotlight_get_data',
'  IS',
'      c               sys_refcursor;',
'      l_row_from_c    CONSTANT PLS_INTEGER DEFAULT apex_application.g_x03;',
'      l_row_to_c      CONSTANT PLS_INTEGER DEFAULT apex_application.g_x04;',
'      l_page_group_c  CONSTANT apex_applications.application_group%TYPE DEFAULT apex_application.g_x02;',
'      l_app_id_c      CONSTANT apex_applications.application_id%TYPE DEFAULT NV(''APP_ID'');',
'      l_app_page_id_c CONSTANT apex_application_pages.page_id%TYPE DEFAULT NV(''APP_PAGE_ID'');',
'      l_session_c     CONSTANT NUMBER DEFAULT v(''SESSION'');',
'      l_debug_c       CONSTANT VARCHAR2(32) DEFAULT v(''DEBUG'');',
'      l_app_limit_c   CONSTANT apex_application.g_x05%TYPE DEFAULT NVL( apex_application.g_x05, ''N'' );',
'  BEGIN',
'     OPEN c FOR',
'        select * from(select * from(select a.*,row_number() over (order by null) apx$rownum ',
'        from(select * from (select i.* --, count(*) over () as APEX$TOTAL_ROW_COUNT',
'        from (select *',
'        from ((select /*+ qb_name(apex$inner) */d.* from (',
'        SELECT ''Page '' || aap.page_id || '' : '' || NVL( apex_escape.html( aap.page_title ), ''Global Page'' ) ||',
'               ''<span style="display:none"> / "'' || aap.application_id || '' '' ||  aap.page_id || ''"</span>'' AS "n"',
'              ,''<span class="margin-right-sm pdt-apx-Spotlight-inline-link fa '' || ',
'                 ( SELECT NVL2( MAX(alp.lock_id), ''u-danger-text fa-lock'', ''u-success-text fa-unlock'' ) x  ',
'                    FROM apex_application_locked_pages alp',
'                   WHERE alp.application_id = aap.application_id ',
'                    AND alp.page_id = aap.page_id ) ||',
'                ''" aria-hidden="true"></span>'' ||',
'                ''<span class="u-color-'' || TO_CHAR( MOD( aap.application_id, 45) + 1 ) || '' margin-right-sm pdt-apx-Spotlight-desc-lozenge">App '' || aap.application_id || ''</span>'' ||',
'                ''<span class="u-hot margin-right-sm pdt-apx-Spotlight-desc-lozenge" title="alias: '' || apex_escape.html(lower(aap.page_alias)) || ''">'' || aap.page_mode || ''</span>'' ||',
'                ''<span class="u-warning margin-right-sm pdt-apx-Spotlight-desc-lozenge">'' ||  apex_util.get_since( aap.last_updated_on ) || ''</span>'' ||',
'                ''<span class="u-warning margin-right-sm pdt-apx-Spotlight-desc-lozenge">'' || nvl(lower(apex_escape.html(aap.last_updated_by)),''?'') || ''</span>'' ||',
'                ''<span class="u-info margin-right-sm pdt-apx-Spotlight-desc-lozenge">'' ||  aap.page_function || ''</span>'' ||',
'                ''<span class="u-success margin-right-sm pdt-apx-Spotlight-desc-lozenge">'' ||  nvl(lower(apex_escape.html(aap.PAGE_GROUP)), ''Unassigned'') || ''</span>''',
'                as "d"',
'              , apex_string.format(''javascript:pdt.pretiusToolbar.openBuilder( ''''%0'''', ''''%1'''', ~WINDOW~ );'' ',
'               , aap.application_id',
'               , aap.page_id ) AS "u"',
'              , CASE aap.page_id WHEN 0 THEN ''fa-number-0-o'' ELSE CASE aap.page_mode WHEN ''Normal'' THEN ''fa-file-o'' ELSE ''fa-layout-modal-header'' END END ',
'              AS "i",',
'              ''FALSE''',
'              AS "s",',
'              ''#479d9d'' ',
'              AS "ic" ',
'              ,'':WS:'' ||',
'               CASE WHEN l_app_id_c = aap.application_id THEN '':APP:'' END ||',
'               CASE WHEN l_page_group_c = NVL( app.application_group, ''- Unassigned -'' ) THEN '':AG:'' END ',
'               AS "c"',
'              ,aap.application_id || ''.'' || aap.page_id "x",',
'               CASE aap.page_id ',
'               WHEN 0 ',
'               THEN NULL',
'               ELSE',
'                 apex_string.format(''<a href="#" pdt-Spotlink-url="%0" class="pdt-apx-Spotlight-inline-link"><span aria-hidden="true" class="fa fa-play-circle-o"></span></a>'',',
'                 ''f'' || ''?p='' || aap.application_id || '':'' || aap.page_id || '':'' || l_session_c || ''::'' || l_debug_c || '':::''',
'                 ) ',
'               END ',
'               AS "shortcutlink",',
'               ''redirect''',
'               AS "t"',
'        FROM apex_application_pages aap,',
'             apex_applications app',
'       WHERE app.application_id = aap.application_id',
'         AND ( ( l_app_limit_c = ''N'' )',
'                OR ',
'               ( l_app_limit_c = ''Y'' AND',
'                 app.application_id = l_app_id_c )',
'             )',
'      ORDER BY CASE aap.page_id WHEN l_app_page_id_c THEN -1 ELSE aap.page_id + 1 END , ',
'            CASE aap.application_id WHEN l_app_id_c THEN -1 ELSE aap.application_id END',
'        ) d',
'        )) i ',
'        ) i',
'        )i ',
'        )a',
'        )where apx$rownum <= l_row_to_c -- Range to',
'        )where apx$rownum >= l_row_from_c -- Range from',
'        ;',
'',
'    apex_json.write(c);',
'  END ajax_spotlight_get_data;',
'',
'  FUNCTION ajax( p_dynamic_action in apex_plugin.t_dynamic_action,',
'                 p_plugin         in apex_plugin.t_plugin) ',
'  RETURN apex_plugin.t_dynamic_action_ajax_result',
'  IS',
'    l_result              apex_plugin.t_dynamic_action_ajax_result;',
'    l_ajax_type           apex_application.g_x01%TYPE DEFAULT apex_application.g_x01;',
'  BEGIN',
'    IF l_ajax_type = ''REVEALER''',
'    THEN',
'        ajax_revealer;',
'    ELSIF l_ajax_type = ''DEBUG_VIEW''',
'    THEN',
'        ajax_debug_view;',
'    ELSIF l_ajax_type = ''DEBUG_DETAIL''',
'    THEN',
'        ajax_debug_detail;',
'    ELSIF l_ajax_type = ''BUILD_OPTION_EXCLUDED''',
'    THEN ',
'        ajax_build_option_excluded;',
'    ELSIF l_ajax_type = ''GET_DATA'' ',
'    THEN',
'       ajax_spotlight_get_data;',
'    ELSIF l_ajax_type = ''GET_URL'' ',
'    THEN',
'       apex_json.open_object;',
'       apex_json.write(''url'',',
'                       apex_util.prepare_url(apex_application.g_x02));',
'       apex_json.close_object;',
'    END IF;',
'    RETURN l_result;',
'  END ajax;'))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'&APP_PRETIUS_DEVTOOL_PKG.render'
,p_ajax_function=>'&APP_PRETIUS_DEVTOOL_PKG.ajax'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The <strong>Pretius Developer Tool</strong> Dynamic Action plug-in offers several features for the APEX developer</p>',
'<p>features include: </p>',
'<ul>',
'   <li>Revealer: Display of APEX item values from page and session</li>',
'   <li>Reload Frame: A one click modal dialog refresh option</li>',
'   <li>Build Option Highlight: Visually see which items have a build option assgined</li>',
'   <li>Developer Toolbar Enhancements: (1) Quick Page Builder Access (2) Debug Icon glows when on< (3) Developer Bar Enhancements/li>',
'</ul>'))
,p_version_identifier=>'23.2.1'
,p_about_url=>'https://github.com/Pretius/pretius-developer-tool/'
,p_files_version=>578
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E70726574697573446576656C6F706572546F6F6C476C6F77207B0D0A2020202070616464696E672D6C6566743A203570782021696D706F7274616E743B0D0A2020202066696C7465723A2064726F702D736861646F772830203020367078206F72616E';
wwv_flow_imp.g_varchar2_table(2) := '6765293B0D0A7D0D0A0D0A2E70726574697573446576656C6F706572546F6F6C526567696F6E50616464696E67207B0D0A202020206D617267696E2D746F703A20302E3038656D3B0D0A202020206D617267696E2D6C6566743A20302E3034656D3B0D0A';
wwv_flow_imp.g_varchar2_table(3) := '7D0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219965513344840668)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'build-option-highlight/contentBuildOptionHighlight.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E636F6E74656E744275696C644F7074696F6E486967686C69676874203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A2020202076617220666164654F75744475726174696F6E3B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(2) := '20202066756E6374696F6E2066616465496E466164654F7574286974656D4E616D652C20705374617475732C207053756666697829207B0D0A0D0A202020202020202076617220636F6C6F7572436F6465203D203139343B0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(3) := '6966202870537461747573203D3D20274578636C7564652729207B0D0A202020202020202020202020636F6C6F7572436F6465203D20303B0D0A20202020202020207D0D0A0D0A20202020202020202428272327202B206974656D4E616D65202B207053';
wwv_flow_imp.g_varchar2_table(4) := '7566666978292E616464436C617373282770726574697573446576656C6F706572546F6F6C526567696F6E50616464696E6727293B0D0A20202020202020207661722064203D20303B0D0A2020202020202020666F7220287661722069203D203130303B';
wwv_flow_imp.g_varchar2_table(5) := '2069203E3D2035303B2069203D2069202D20302E3129207B202F2F6920726570726573656E747320746865206C696768746E6573730D0A20202020202020202020202064202B3D20333B0D0A2020202020202020202020202866756E6374696F6E202869';
wwv_flow_imp.g_varchar2_table(6) := '692C20646429207B0D0A2020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0D0A20202020202020202020202020202020202020202428272327202B206974656D4E616D65202B2070537566666978292E';
wwv_flow_imp.g_varchar2_table(7) := '637373282766696C746572272C202764726F702D736861646F77282031707820317078203670782068736C2827202B20636F6C6F7572436F6465202B20272C313030252C27202B206969202B2027252927293B0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(8) := '207D2C206464293B0D0A2020202020202020202020207D2928692C2064293B0D0A20202020202020207D0D0A0D0A20202020202020207661722064203D20666164654F75744475726174696F6E3B20200D0A0D0A20202020202020206966202864203E20';
wwv_flow_imp.g_varchar2_table(9) := '3029207B0D0A202020202020202020202020666F7220287661722069203D2035303B2069203C3D203130303B2069203D2069202B20302E3129207B202F2F6920726570726573656E747320746865206C696768746E6573730D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(10) := '20202020202064202B3D20333B0D0A202020202020202020202020202020202866756E6374696F6E202869692C20646429207B0D0A202020202020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0D0A20';
wwv_flow_imp.g_varchar2_table(11) := '20202020202020202020202020202020202020202020202428272327202B206974656D4E616D65202B2070537566666978292E637373282766696C746572272C202764726F702D736861646F77282031707820317078203670782068736C2827202B2063';
wwv_flow_imp.g_varchar2_table(12) := '6F6C6F7572436F6465202B20272C313030252C27202B206969202B2027252927293B0D0A202020202020202020202020202020202020202020202020696620286969203E3D20393929207B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(13) := '20202020202428272327202B206974656D4E616D65202B2070537566666978292E72656D6F7665436C617373282770726574697573446576656C6F706572546F6F6C526567696F6E50616464696E6727293B0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(14) := '20202020202020207D0D0A20202020202020202020202020202020202020207D2C206464293B0D0A202020202020202020202020202020207D2928692C2064293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A';
wwv_flow_imp.g_varchar2_table(15) := '0D0A2020202066756E6374696F6E2061637469766174652829207B0D0A0D0A2020202020202020666164654F75744475726174696F6E203D207064742E67657453657474696E6728276275696C646F7074696F6E68696768746C696768742E6475726174';
wwv_flow_imp.g_varchar2_table(16) := '696F6E27293B0D0A202020202020202069662028202169734E614E28666164654F75744475726174696F6E2920297B0D0A2020202020202020202020202F2F206E756D6265720D0A202020202020202020202020666164654F75744475726174696F6E20';
wwv_flow_imp.g_varchar2_table(17) := '3D204E756D6265722820666164654F75744475726174696F6E2029202A20313030303B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020202F2F204E6F742061206E756D6265720D0A20202020202020202020202066616465';
wwv_flow_imp.g_varchar2_table(18) := '4F75744475726174696F6E203D20363030303B202F2F2044656661756C740D0A20202020202020207D3B0D0A0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E';
wwv_flow_imp.g_varchar2_table(19) := '706C7567696E287064742E6F70742E616A61784964656E7469666965722C207B0D0A2020202020202020202020207830313A20274255494C445F4F5054494F4E5F4558434C55444544270D0A20202020202020207D2C207B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(20) := '2020737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020202020202020202020686967686C69676874286461';
wwv_flow_imp.g_varchar2_table(21) := '74612E6974656D73293B0D0A2020202020202020202020207D0D0A2020202020202020202020202C0D0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F77';
wwv_flow_imp.g_varchar2_table(22) := '6E29207B0D0A202020202020202020202020202020202F2F2068616E646C65206572726F720D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020202020202020202020706474';
wwv_flow_imp.g_varchar2_table(23) := '2E616A61784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374';
wwv_flow_imp.g_varchar2_table(24) := '696F6E20686967686C69676874287053656C6563746F727329207B0D0A2020202020202020666F7220287661722069203D20303B2069203C207053656C6563746F72732E6C656E6774683B20692B2B29207B0D0A20202020202020202020202076617220';
wwv_flow_imp.g_varchar2_table(25) := '6974656D4E616D65203D207053656C6563746F72735B695D2E4954454D5F4E414D453B0D0A202020202020202020202020766172206974656D537461747573203D207053656C6563746F72735B695D2E5354415455533B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(26) := '20766172206974656D54797065203D207053656C6563746F72735B695D2E504147455F4954454D5F545950453B0D0A20202020202020202020202076617220737566666978203D2027273B0D0A0D0A202020202020202020202020696620286974656D54';
wwv_flow_imp.g_varchar2_table(27) := '797065203D3D20274954454D2729207B0D0A20202020202020202020202020202020737566666978203D20275F434F4E5441494E4552273B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202066616465496E466164654F7574';
wwv_flow_imp.g_varchar2_table(28) := '286974656D4E616D652C206974656D5374617475732C20737566666978293B0D0A0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202072657475726E207B0D0A202020202020202061637469766174653A2061637469766174650D0A202020';
wwv_flow_imp.g_varchar2_table(29) := '207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219965821730840685)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'build-option-highlight/contentBuildOptionHighlight.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E70726574697573446576656C6F706572546F6F6C476C6F777B70616464696E672D6C6566743A35707821696D706F7274616E743B66696C7465723A64726F702D736861646F772830203020367078206F72616E6765297D2E7072657469757344657665';
wwv_flow_imp.g_varchar2_table(2) := '6C6F706572546F6F6C526567696F6E50616464696E677B6D617267696E2D746F703A2E3038656D3B6D617267696E2D6C6566743A2E3034656D7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219966264817840686)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'build-option-highlight/minified/contentBuildOptionHighlight.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E636F6E74656E744275696C644F7074696F6E486967686C696768743D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E206528652C742C6F297B766172206E3D3139343B224578636C756465223D3D742626286E';
wwv_flow_imp.g_varchar2_table(2) := '3D30292C24282223222B652B6F292E616464436C617373282270726574697573446576656C6F706572546F6F6C526567696F6E50616464696E6722293B666F722876617220723D302C753D3130303B753E3D35303B752D3D2E3129722B3D332C66756E63';
wwv_flow_imp.g_varchar2_table(3) := '74696F6E28742C69297B73657454696D656F75742866756E6374696F6E28297B24282223222B652B6F292E637373282266696C746572222C2264726F702D736861646F77282031707820317078203670782068736C28222B6E2B222C313030252C222B74';
wwv_flow_imp.g_varchar2_table(4) := '2B22252922297D2C69297D28752C72293B723D693B696628723E3029666F7228753D35303B753C3D3130303B752B3D2E3129722B3D332C66756E6374696F6E28742C69297B73657454696D656F75742866756E6374696F6E28297B24282223222B652B6F';
wwv_flow_imp.g_varchar2_table(5) := '292E637373282266696C746572222C2264726F702D736861646F77282031707820317078203670782068736C28222B6E2B222C313030252C222B742B22252922292C743E3D3939262624282223222B652B6F292E72656D6F7665436C6173732822707265';
wwv_flow_imp.g_varchar2_table(6) := '74697573446576656C6F706572546F6F6C526567696F6E50616464696E6722297D2C69297D28752C72297D66756E6374696F6E207428297B693D7064742E67657453657474696E6728226275696C646F7074696F6E68696768746C696768742E64757261';
wwv_flow_imp.g_varchar2_table(7) := '74696F6E22292C693D69734E614E2869293F3665333A3165332A4E756D6265722869292C7064742E636C6F616B44656275674C6576656C28292C617065782E7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965722C';
wwv_flow_imp.g_varchar2_table(8) := '7B7830313A224255494C445F4F5054494F4E5F4558434C55444544227D2C7B737563636573733A66756E6374696F6E2865297B7064742E756E436C6F616B44656275674C6576656C28292C6F28652E6974656D73297D2C6572726F723A66756E6374696F';
wwv_flow_imp.g_varchar2_table(9) := '6E28652C742C6F297B7064742E756E436C6F616B44656275674C6576656C28292C7064742E616A61784572726F7248616E646C657228652C742C6F297D7D297D66756E6374696F6E206F2874297B666F7228766172206F3D303B6F3C742E6C656E677468';
wwv_flow_imp.g_varchar2_table(10) := '3B6F2B2B297B76617220693D745B6F5D2E4954454D5F4E414D452C6E3D745B6F5D2E5354415455532C723D745B6F5D2E504147455F4954454D5F545950452C753D22223B224954454D223D3D72262628753D225F434F4E5441494E455222292C6528692C';
wwv_flow_imp.g_varchar2_table(11) := '6E2C75297D7D76617220693B72657475726E7B61637469766174653A747D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219966682185840687)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'build-option-highlight/minified/contentBuildOptionHighlight.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0D0A202A20415045582053706F746C69676874205365617263680D0A202A20417574686F723A2044616E69656C20486F63686C6569746E65720D0A202A20437265646974733A204150455820446576205465616D3A202F692F617065785F75692F';
wwv_flow_imp.g_varchar2_table(2) := '6373732F636F72652F53706F746C696768742E6373730D0A202A2056657273696F6E3A20312E362E310D0A202A2F0D0A2E7064742D6170782D53706F746C69676874207B0D0A2020646973706C61793A20666C65783B0D0A20206F766572666C6F773A20';
wwv_flow_imp.g_varchar2_table(3) := '68696464656E3B0D0A20206865696768743A206175746F2021696D706F7274616E743B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D626F6479207B0D0A2020666C65782D67726F773A20313B0D0A2020646973706C61793A20666C65';
wwv_flow_imp.g_varchar2_table(4) := '783B0D0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0D0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0D0A20206F766572666C6F773A2068696464656E3B0D0A7D0D0A0D0A2F2A20';
wwv_flow_imp.g_varchar2_table(5) := '426F647920436C61737320746F2070726576656E74207363726F6C6C696E67207768656E2073706F746C69676874206973206F70656E202A2F0D0A626F64792E617065782D73706F746C696768742D616374697665207B0D0A20206F766572666C6F773A';
wwv_flow_imp.g_varchar2_table(6) := '2068696464656E3B0D0A7D0D0A0D0A2F2A2053706F746C6967687420526573756C7473202A2F0D0A2E7064742D6170782D53706F746C696768742D726573756C7473207B0D0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C20';
wwv_flow_imp.g_varchar2_table(7) := '3235352C203235352C20302E3938293B0D0A2020666C65782D67726F773A20313B0D0A20206F766572666C6F773A206175746F3B0D0A20206D61782D6865696768743A20353076683B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D72';
wwv_flow_imp.g_varchar2_table(8) := '6573756C74733A656D707479207B0D0A2020646973706C61793A206E6F6E653B0D0A7D0D0A0D0A2F2A2053706F746C6967687420526573756C7473204C697374202A2F0D0A2E7064742D6170782D53706F746C696768742D726573756C74734C69737420';
wwv_flow_imp.g_varchar2_table(9) := '7B0D0A20206C6973742D7374796C653A206E6F6E653B0D0A20206D617267696E3A20303B0D0A202070616464696E673A20303B0D0A7D0D0A0D0A2F2A204C697374204974656D202A2F0D0A2E7064742D6170782D53706F746C696768742D726573756C74';
wwv_flow_imp.g_varchar2_table(10) := '3A6E6F74283A6C6173742D6368696C6429207B0D0A2020626F726465722D626F74746F6D3A2031707820736F6C6964207267626128302C20302C20302C20302E3035293B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D696E6C696E65';
wwv_flow_imp.g_varchar2_table(11) := '2D6C696E6B3A686F766572207B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B0D0A2020636F6C6F723A2077686974653B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E';
wwv_flow_imp.g_varchar2_table(12) := '7064742D6170782D53706F746C696768742D696E6C696E652D6C696E6B207B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B0D0A20202F2A206261636B67726F756E642D636F6C6F723A20233035373243453B202A2F0D0A2020636F6C';
wwv_flow_imp.g_varchar2_table(13) := '6F723A20236666663B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D726573756C74202E7064742D6170782D53706F746C696768742D6C696E6B3A686F766572207B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B0D';
wwv_flow_imp.g_varchar2_table(14) := '0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B207B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B0D0A2020626163';
wwv_flow_imp.g_varchar2_table(15) := '6B67726F756E642D636F6C6F723A20233035373243453B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C69676874';
wwv_flow_imp.g_varchar2_table(16) := '2D6C696E6B202E7064742D6170782D53706F746C696768742D646573632C202E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B202E7064742D6170782D';
wwv_flow_imp.g_varchar2_table(17) := '53706F746C696768742D73686F7274637574207B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C69';
wwv_flow_imp.g_varchar2_table(18) := '6E6B202E7064742D6170782D53706F746C696768742D73686F7274637574207B0D0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E3135293B0D0A7D0D0A0D0A2E7064742D6170782D53706F74';
wwv_flow_imp.g_varchar2_table(19) := '6C696768742D686561646572207B0D0A202070616464696E673A2030707820313670782030707820313670783B0D0A2020666C65782D736872696E6B3A20303B0D0A2020646973706C61793A20666C65783B0D0A2020706F736974696F6E3A2072656C61';
wwv_flow_imp.g_varchar2_table(20) := '746976653B0D0A2020626F726465722D626F74746F6D3A2031707820736F6C6964207267626128302C20302C20302C20302E3035293B0D0A20206D617267696E2D626F74746F6D3A202D3170783B0D0A20206261636B67726F756E642D636F6C6F723A20';
wwv_flow_imp.g_varchar2_table(21) := '7768697465736D6F6B653B0D0A7D0D0A0D0A2F2A20536561726368204669656C64202A2F0D0A2E7064742D6170782D53706F746C696768742D736561726368207B0D0A202070616464696E673A20313670783B0D0A2020666C65782D736872696E6B3A20';
wwv_flow_imp.g_varchar2_table(22) := '303B0D0A2020646973706C61793A20666C65783B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A2020626F726465722D626F74746F6D3A2031707820736F6C6964207267626128302C20302C20302C20302E3035293B0D0A20206D617267';
wwv_flow_imp.g_varchar2_table(23) := '696E2D626F74746F6D3A202D3170783B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D736561726368202E7064742D6170782D53706F746C696768742D69636F6E207B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A20';
wwv_flow_imp.g_varchar2_table(24) := '207A2D696E6465783A20313B0D0A20206261636B67726F756E642D636F6C6F723A20236264633363373B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D6669656C64207B0D0A2020666C65782D67726F773A20313B0D0A2020706F7369';
wwv_flow_imp.g_varchar2_table(25) := '74696F6E3A206162736F6C7574653B0D0A2020746F703A20303B0D0A20206C6566743A20303B0D0A202072696768743A20303B0D0A2020626F74746F6D3A20303B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D696E707574207B0D0A';
wwv_flow_imp.g_varchar2_table(26) := '2020666F6E742D73697A653A20323070782021696D706F7274616E743B0D0A20206C696E652D6865696768743A20333270783B0D0A20206865696768743A20363470783B0D0A202070616464696E673A2031367078203136707820313670782036347078';
wwv_flow_imp.g_varchar2_table(27) := '3B0D0A2020626F726465722D77696474683A20303B0D0A2020646973706C61793A20626C6F636B3B0D0A202077696474683A20313030253B0D0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E';
wwv_flow_imp.g_varchar2_table(28) := '3938293B0D0A2020636F6C6F723A20626C61636B3B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D696E7075743A666F637573207B0D0A20206F75746C696E653A206E6F6E653B0D0A7D0D0A0D0A2F2A20526573756C74204C696E6B20';
wwv_flow_imp.g_varchar2_table(29) := '2A2F0D0A2E7064742D6170782D53706F746C696768742D6C696E6B207B0D0A2020646973706C61793A20626C6F636B3B0D0A2020646973706C61793A20666C65783B0D0A202070616464696E673A20313070782031367078203132707820313670783B0D';
wwv_flow_imp.g_varchar2_table(30) := '0A2020636F6C6F723A20233230323032303B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D6C696E6B3A666F637573207B0D0A20206F75746C696E653A206E6F6E653B0D0A';
wwv_flow_imp.g_varchar2_table(31) := '7D0D0A0D0A2E7064742D6170782D53706F746C696768742D69636F6E207B0D0A20206D617267696E2D72696768743A20313670783B0D0A202070616464696E673A203870783B0D0A202077696474683A20333270783B0D0A20206865696768743A203332';
wwv_flow_imp.g_varchar2_table(32) := '70783B0D0A2020626F782D736861646F773A2030203020302031707820236666663B0D0A2020626F726465722D7261646975733A203270783B0D0A20206261636B67726F756E642D636F6C6F723A20233339396265613B0D0A2020636F6C6F723A202366';
wwv_flow_imp.g_varchar2_table(33) := '66663B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D726573756C742D2D617070202E7064742D6170782D53706F746C696768742D69636F6E207B0D0A20206261636B67726F756E642D636F6C6F723A20236635346232313B0D0A7D0D';
wwv_flow_imp.g_varchar2_table(34) := '0A0D0A2E7064742D6170782D53706F746C696768742D726573756C742D2D7773202E7064742D6170782D53706F746C696768742D69636F6E207B0D0A20206261636B67726F756E642D636F6C6F723A20233234636237663B0D0A7D0D0A0D0A2E7064742D';
wwv_flow_imp.g_varchar2_table(35) := '6170782D53706F746C696768742D696E666F207B0D0A2020666C65782D67726F773A20313B0D0A2020646973706C61793A20666C65783B0D0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0D0A20206A7573746966792D636F6E74656E';
wwv_flow_imp.g_varchar2_table(36) := '743A2063656E7465723B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D6C6162656C207B0D0A2020666F6E742D73697A653A20313470783B0D0A2020666F6E742D7765696768743A203530303B0D0A7D0D0A0D0A2E7064742D6170782D';
wwv_flow_imp.g_varchar2_table(37) := '53706F746C696768742D64657363207B0D0A2020666F6E742D73697A653A20313170783B0D0A2020636F6C6F723A207267626128302C20302C20302C20302E3635293B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D73686F72746375';
wwv_flow_imp.g_varchar2_table(38) := '74207B0D0A20206C696E652D6865696768743A20313670783B0D0A2020666F6E742D73697A653A20313270783B0D0A2020636F6C6F723A207267626128302C20302C20302C20302E3635293B0D0A202070616464696E673A20347078203470783B0D0A20';
wwv_flow_imp.g_varchar2_table(39) := '20626F726465722D7261646975733A20323470783B0D0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E303235293B0D0A7D0D0A0D0A2F2A2053706F746C69676874204469616C6F67202A2F0D0A626F647920';
wwv_flow_imp.g_varchar2_table(40) := '2E75692D6469616C6F672E75692D6469616C6F672D2D7064742D6170657873706F746C69676874207B0D0A2020626F726465722D77696474683A20303B0D0A2020626F782D736861646F773A2030203870782031367078207267626128302C20302C2030';
wwv_flow_imp.g_varchar2_table(41) := '2C20302E3235292C20302031707820327078207267626128302C20302C20302C20302E3135292C20302030203020317078207267626128302C20302C20302C20302E3035293B0D0A20206261636B67726F756E642D636F6C6F723A207472616E73706172';
wwv_flow_imp.g_varchar2_table(42) := '656E743B0D0A7D0D0A0D0A626F6479202E75692D6469616C6F672E75692D6469616C6F672D2D7064742D6170657873706F746C69676874202E75692D6469616C6F672D7469746C65626172207B0D0A2020646973706C61793A206E6F6E653B0D0A7D0D0A';
wwv_flow_imp.g_varchar2_table(43) := '0D0A406D65646961206F6E6C792073637265656E20616E6420286D61782D6865696768743A20373638707829207B0D0A20202E7064742D6170782D53706F746C696768742D726573756C7473207B0D0A202020206D61782D6865696768743A2033393070';
wwv_flow_imp.g_varchar2_table(44) := '783B0D0A20207D0D0A7D0D0A0D0A2F2A20546970707920486973746F727920506F706F766572202A2F0D0A756C2E7064742D73706F746C696768742D686973746F72792D6C697374207B0D0A2020746578742D616C69676E3A206C6566743B0D0A7D0D0A';
wwv_flow_imp.g_varchar2_table(45) := '0D0A612E7064742D73706F746C696768742D686973746F72792D6C696E6B2C0D0A612E7064742D73706F746C696768742D686973746F72792D64656C657465207B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2F2A20415045582053706F74';
wwv_flow_imp.g_varchar2_table(46) := '6C6967687420536561726368204F72616E6765205468656D65202A2F0D0A2E7064742D6170782D53706F746C696768742D726573756C742D6F72616E67652E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B207B0D0A';
wwv_flow_imp.g_varchar2_table(47) := '20206261636B67726F756E642D636F6C6F723A20236635396533333B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D69636F6E2D6F72616E6765207B0D0A20206261636B67726F756E642D636F';
wwv_flow_imp.g_varchar2_table(48) := '6C6F723A20233739373837653B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2F2A20415045582053706F746C696768742053656172636820526564205468656D65202A2F0D0A2E7064742D6170782D53706F746C696768742D726573756C74';
wwv_flow_imp.g_varchar2_table(49) := '2D7265642E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B207B0D0A20206261636B67726F756E642D636F6C6F723A20236461316231623B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2E7064742D6170';
wwv_flow_imp.g_varchar2_table(50) := '782D53706F746C696768742D69636F6E2D726564207B0D0A20206261636B67726F756E642D636F6C6F723A20233630363036303B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2F2A20415045582053706F746C696768742053656172636820';
wwv_flow_imp.g_varchar2_table(51) := '4461726B205468656D65202A2F0D0A2E7064742D6170782D53706F746C696768742D726573756C742D6461726B2E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B207B0D0A20206261636B67726F756E642D636F6C6F';
wwv_flow_imp.g_varchar2_table(52) := '723A20233332333333363B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D69636F6E2D6461726B207B0D0A20206261636B67726F756E642D636F6C6F723A20236536653665363B0D0A2020636F';
wwv_flow_imp.g_varchar2_table(53) := '6C6F723A20233430343034303B0D0A2020626F782D736861646F773A2030203020302031707820233430343034303B0D0A7D0D0A0D0A2E7064742D6170782D53706F746C696768742D646573632D6C6F7A656E6765207B0D0A202070616464696E673A32';
wwv_flow_imp.g_varchar2_table(54) := '70783B200D0A2020626F726465722D7261646975733A3570780D0A7D0D0A0D0A2E7064742D7370742D6C626C207B0D0A20206865696768743A20323470783B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219967081791840689)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/apexspotlight.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0D0A202A20415045582053706F746C69676874205365617263680D0A202A20417574686F723A204D617474204D756C76616E6579200D0A202A20437265646974733A2044616E69656C20486F63686C6569746E65723A2068747470733A2F2F6769';
wwv_flow_imp.g_varchar2_table(2) := '746875622E636F6D2F44616E69336C53756E2F617065782D706C7567696E2D73706F746C69676874200D0A202A202020202020202020204150455820446576205465616D20202020203A202F692F617065785F75692F6A732F73706F746C696768742E6A';
wwv_flow_imp.g_varchar2_table(3) := '730D0A202A2056657273696F6E3A2032322E322E330D0A202A2F0D0A0D0A2F2A2A0D0A202A20457874656E64207064740D0A202A2F0D0A7064742E6170657853706F746C69676874203D207B0D0A20202F2A2A0D0A2020202A20496E6974206B6579626F';
wwv_flow_imp.g_varchar2_table(4) := '6172642073686F727463757473206F6E2070616765206C6F61640D0A2020202A2040706172616D207B6F626A6563747D20704F7074696F6E730D0A2020202A2F0D0A2020696E69744B6579626F61726453686F7274637574733A2066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(5) := '28704F7074696F6E7329207B0D0A202020202F2F206368616E67652064656661756C74206576656E740D0A20202020704F7074696F6E732E6576656E744E616D65203D20276B6579626F61726453686F7274637574273B0D0A0D0A202020202F2F206465';
wwv_flow_imp.g_varchar2_table(6) := '6275670D0A20202020617065782E64656275672E696E666F28276170657853706F746C696768742E696E69744B6579426F61726453686F727463757473202D20704F7074696F6E73272C20704F7074696F6E73293B0D0A0D0A2020202076617220656E61';
wwv_flow_imp.g_varchar2_table(7) := '626C654B6579626F61726453686F727463757473203D20704F7074696F6E732E656E61626C654B6579626F61726453686F7274637574733B0D0A20202020766172206B6579626F61726453686F727463757473203D20704F7074696F6E732E6B6579626F';
wwv_flow_imp.g_varchar2_table(8) := '61726453686F7274637574733B0D0A20202020766172206B6579626F61726453686F7274637574734172726179203D205B5D3B0D0A0D0A2020202069662028656E61626C654B6579626F61726453686F727463757473203D3D2027592729207B0D0A2020';
wwv_flow_imp.g_varchar2_table(9) := '202020206B6579626F61726453686F7274637574734172726179203D206B6579626F61726453686F7274637574732E73706C697428272C27293B0D0A0D0A2020202020202F2F2064697361626C652064656661756C74206265686176696F7220746F206E';
wwv_flow_imp.g_varchar2_table(10) := '6F742062696E6420696E20696E707574206669656C64730D0A2020202020204D6F757365747261702E73746F7043616C6C6261636B203D2066756E6374696F6E2028652C20656C656D656E742C20636F6D626F29207B0D0A202020202020202072657475';
wwv_flow_imp.g_varchar2_table(11) := '726E2066616C73653B0D0A2020202020207D3B0D0A2020202020204D6F757365747261702E70726F746F747970652E73746F7043616C6C6261636B203D2066756E6374696F6E2028652C20656C656D656E742C20636F6D626F29207B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(12) := '202072657475726E2066616C73653B0D0A2020202020207D3B0D0A0D0A2020202020202F2F2062696E64206D6F75737472617020746F206B6579626F6172642073686F72746375740D0A2020202020204D6F757365747261702E62696E64286B6579626F';
wwv_flow_imp.g_varchar2_table(13) := '61726453686F72746375747341727261792C2066756E6374696F6E20286529207B0D0A20202020202020202F2F2070726576656E742064656661756C74206265686176696F720D0A202020202020202069662028652E70726576656E7444656661756C74';
wwv_flow_imp.g_varchar2_table(14) := '29207B0D0A20202020202020202020652E70726576656E7444656661756C7428293B0D0A20202020202020207D20656C7365207B0D0A202020202020202020202F2F20696E7465726E6574206578706C6F7265720D0A20202020202020202020652E7265';
wwv_flow_imp.g_varchar2_table(15) := '7475726E56616C7565203D2066616C73653B0D0A20202020202020207D0D0A20202020202020202F2F2063616C6C206D61696E20706C7567696E2068616E646C65720D0A20202020202020207064742E6170657853706F746C696768742E706C7567696E';
wwv_flow_imp.g_varchar2_table(16) := '48616E646C657228704F7074696F6E73293B0D0A2020202020207D293B0D0A202020207D0D0A20207D2C0D0A20202F2A2A0D0A2020202A205365742073706F746C696768742073656172636820696E70757420746F20686973746F72792076616C75650D';
wwv_flow_imp.g_varchar2_table(17) := '0A2020202A2040706172616D207B737472696E677D20705365617263685465726D0D0A2020202A2F0D0A2020736574486973746F727953656172636856616C75653A2066756E6374696F6E2028705365617263685465726D29207B0D0A20202020242827';
wwv_flow_imp.g_varchar2_table(18) := '2E7064742D6170782D53706F746C696768742D696E70757427292E76616C28705365617263685465726D292E747269676765722827696E70757427293B0D0A20207D2C0D0A20202F2A2A0D0A2020202A20506C7567696E2068616E646C6572202D206361';
wwv_flow_imp.g_varchar2_table(19) := '6C6C65642066726F6D20706C7567696E2072656E6465722066756E6374696F6E0D0A2020202A2040706172616D207B6F626A6563747D20704F7074696F6E730D0A2020202A2F0D0A2020706C7567696E48616E646C65723A2066756E6374696F6E202870';
wwv_flow_imp.g_varchar2_table(20) := '4F7074696F6E7329207B0D0A202020202F2A2A0D0A20202020202A204D61696E204E616D6573706163650D0A20202020202A2F0D0A20202020766172206170657853706F746C69676874203D207B0D0A2020202020202F2A2A0D0A202020202020202A20';
wwv_flow_imp.g_varchar2_table(21) := '436F6E7374616E74730D0A202020202020202A2F0D0A202020202020444F543A20272E272C0D0A20202020202053505F4449414C4F473A20277064742D6170782D53706F746C69676874272C0D0A20202020202053505F494E5055543A20277064742D61';
wwv_flow_imp.g_varchar2_table(22) := '70782D53706F746C696768742D696E707574272C0D0A20202020202053505F524553554C54533A20277064742D6170782D53706F746C696768742D726573756C7473272C0D0A20202020202053505F4143544956453A202769732D616374697665272C0D';
wwv_flow_imp.g_varchar2_table(23) := '0A20202020202053505F53484F52544355543A20277064742D6170782D53706F746C696768742D73686F7274637574272C0D0A20202020202053505F414354494F4E5F53484F52544355543A202773706F746C696768742D736561726368272C0D0A2020';
wwv_flow_imp.g_varchar2_table(24) := '2020202053505F524553554C545F4C4142454C3A20277064742D6170782D53706F746C696768742D6C6162656C272C0D0A20202020202053505F4C4956455F524547494F4E3A20277064742D73702D617269612D6D617463682D666F756E64272C0D0A20';
wwv_flow_imp.g_varchar2_table(25) := '202020202053505F4C4953543A20277064742D73702D726573756C742D6C697374272C0D0A2020202020204B4559533A20242E75692E6B6579436F64652C0D0A20202020202055524C5F54595045533A207B0D0A20202020202020207265646972656374';
wwv_flow_imp.g_varchar2_table(26) := '3A20277265646972656374272C0D0A2020202020202020736561726368506167653A20277365617263682D70616765270D0A2020202020207D2C0D0A20202020202049434F4E533A207B0D0A2020202020202020706167653A202766612D77696E646F77';
wwv_flow_imp.g_varchar2_table(27) := '2D736561726368272C0D0A20202020202020207365617263683A202769636F6E2D736561726368270D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20676C6F62616C20766172730D0A202020202020202A2F0D0A20202020';
wwv_flow_imp.g_varchar2_table(28) := '2020674D61784E6176526573756C743A2035302C0D0A2020202020206757696474683A203635302C0D0A202020202020674861734469616C6F67437265617465643A2066616C73652C0D0A20202020202067536561726368496E6465783A205B5D2C0D0A';
wwv_flow_imp.g_varchar2_table(29) := '20202020202067537461746963496E6465783A205B5D2C0D0A202020202020674B6579776F7264733A2027272C0D0A20202020202067416A61784964656E7469666965723A206E756C6C2C0D0A2020202020206744796E616D6963416374696F6E49643A';
wwv_flow_imp.g_varchar2_table(30) := '206E756C6C2C0D0A20202020202067506C616365686F6C646572546578743A206E756C6C2C0D0A202020202020674D6F72654368617273546578743A206E756C6C2C0D0A202020202020674E6F4D61746368546578743A206E756C6C2C0D0A2020202020';
wwv_flow_imp.g_varchar2_table(31) := '20674F6E654D61746368546578743A206E756C6C2C0D0A202020202020674D756C7469706C654D617463686573546578743A206E756C6C2C0D0A20202020202067496E50616765536561726368546578743A206E756C6C2C0D0A20202020202067536561';
wwv_flow_imp.g_varchar2_table(32) := '726368486973746F727944656C657465546578743A206E756C6C2C0D0A20202020202067456E61626C65496E506167655365617263683A20747275652C0D0A20202020202067456E61626C654461746143616368653A2066616C73652C0D0A2020202020';
wwv_flow_imp.g_varchar2_table(33) := '2067456E61626C6550726566696C6C53656C6563746564546578743A2066616C73652C0D0A20202020202067456E61626C65536561726368486973746F72793A2066616C73652C0D0A202020202020675375626D69744974656D7341727261793A205B5D';
wwv_flow_imp.g_varchar2_table(34) := '2C0D0A20202020202067526573756C744C6973745468656D65436C6173733A2027272C0D0A2020202020206749636F6E5468656D65436C6173733A2027272C0D0A2020202020206753686F7750726F63657373696E673A2066616C73652C0D0A20202020';
wwv_flow_imp.g_varchar2_table(35) := '202067506C616365486F6C64657249636F6E3A2027612D49636F6E2069636F6E2D736561726368272C0D0A20202020202067576169745370696E6E6572243A206E756C6C2C0D0A2020202020206744656661756C74546578743A206E756C6C2C0D0A2020';
wwv_flow_imp.g_varchar2_table(36) := '2020202067446174614368756E6B65643A205B5D2C0D0A202020202020676368756E6B53697A653A2035303030302C0D0A202020202020674170704C696D69743A206E756C6C2C0D0A202020202020766665746368537461727454696D653A206E657720';
wwv_flow_imp.g_varchar2_table(37) := '4461746528292C0D0A2020202020202F2A2A0D0A202020202020202A2F0D0A202020202020726573746F72654F72696749636F6E3A2066756E6374696F6E202829207B0D0A20202020202020202428272E7064742D73706F746C696768742D6465766261';
wwv_flow_imp.g_varchar2_table(38) := '722D656E74727927290D0A202020202020202020202E72656D6F7665436C617373282766612D72656672657368207064742D7072656665746368696E672066612D616E696D2D7370696E27290D0A202020202020202020202E616464436C617373282766';
wwv_flow_imp.g_varchar2_table(39) := '612D77696E646F772D6172726F772D757027293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20476574204A534F4E20636F6E7461696E696E67206461746120666F722073706F746C696768742073656172636820656E';
wwv_flow_imp.g_varchar2_table(40) := '74726965732066726F6D2044420D0A202020202020202A2040706172616D207B66756E6374696F6E7D2063616C6C6261636B0D0A202020202020202A20407046726F6D52616E6765207B737472696E677D20537461727420526F770D0A20202020202020';
wwv_flow_imp.g_varchar2_table(41) := '2A204070546F52616E6765207B737472696E677D20456E6420526F770D0A202020202020202A2F0D0A20202020202067657453706F746C69676874446174614368756E6B65643A2066756E6374696F6E202863616C6C6261636B2C207046726F6D52616E';
wwv_flow_imp.g_varchar2_table(42) := '67652C2070546F52616E676529207B0D0A2020202020202020617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965722C207B0D0A20202020202020202020706167654974656D733A2061';
wwv_flow_imp.g_varchar2_table(43) := '70657853706F746C696768742E675375626D69744974656D7341727261792C0D0A202020202020202020207830313A20274745545F44415441272C0D0A202020202020202020207830323A207064742E6F70742E6170706C69636174696F6E47726F7570';
wwv_flow_imp.g_varchar2_table(44) := '4E616D652C0D0A202020202020202020207830333A207046726F6D52616E67652C0D0A202020202020202020207830343A2070546F52616E67652C0D0A202020202020202020207830353A206170657853706F746C696768742E674170704C696D69740D';
wwv_flow_imp.g_varchar2_table(45) := '0A20202020202020207D2C207B0D0A2020202020202020202064617461547970653A20276A736F6E272C0D0A20202020202020202020737563636573733A2066756E6374696F6E20286461746129207B0D0A20202020202020202020202076617220644C';
wwv_flow_imp.g_varchar2_table(46) := '656E677468203D20646174612E6C656E6774683B0D0A202020202020202020202020617065782E64656275672E696E666F28275044543A204665746368656420506167652052616E6765205B27202B207046726F6D52616E6765202B20272D27202B2028';
wwv_flow_imp.g_varchar2_table(47) := '7046726F6D52616E6765202B20644C656E677468202D203129202B20275D206F662027202B20644C656E677468202B202720726F7728732927293B0D0A2020202020202020202020206170657853706F746C696768742E67446174614368756E6B65642E';
wwv_flow_imp.g_varchar2_table(48) := '70757368282E2E2E64617461293B0D0A0D0A20202020202020202020202069662028644C656E677468203D3D206170657853706F746C696768742E676368756E6B53697A6529207B0D0A0D0A20202020202020202020202020206170657853706F746C69';
wwv_flow_imp.g_varchar2_table(49) := '6768742E67657453706F746C69676874446174614368756E6B6564280D0A2020202020202020202020202020202063616C6C6261636B2C0D0A202020202020202020202020202020207046726F6D52616E6765202B206170657853706F746C696768742E';
wwv_flow_imp.g_varchar2_table(50) := '676368756E6B53697A652C0D0A2020202020202020202020202020202070546F52616E6765202B206170657853706F746C696768742E676368756E6B53697A65293B0D0A2020202020202020202020207D20656C7365207B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(51) := '2020202064617461203D206170657853706F746C696768742E67446174614368756E6B65643B0D0A20202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020202020202020207064742E6F70';
wwv_flow_imp.g_varchar2_table(52) := '742E73706F746C696768745072656665746368696E67203D2066616C73653B0D0A20202020202020202020202020206170657853706F746C696768742E726573746F72654F72696749636F6E28293B0D0A2020202020202020202020202020617065782E';
wwv_flow_imp.g_varchar2_table(53) := '6576656E742E747269676765722827626F6479272C20277064742D6170657873706F746C696768742D616A61782D73756363657373272C2064617461293B0D0A20202020202020202020202020202F2F20617065782E64656275672E696E666F28226170';
wwv_flow_imp.g_varchar2_table(54) := '657853706F746C696768742E67657453706F746C696768744461746120414A41582053756363657373222C2064617461293B0D0A2020202020202020202020202020696620286170657853706F746C696768742E67456E61626C65446174614361636865';
wwv_flow_imp.g_varchar2_table(55) := '29207B0D0A202020202020202020202020202020202F2F204D4D203A204368616E676564206D696E64206F6E202D2D3E204D4D3A20416C776179732073746F726520746F207265706C61636520616E7920616765642063616368650D0A20202020202020';
wwv_flow_imp.g_varchar2_table(56) := '2020202020202020206170657853706F746C696768742E73657453706F746C696768744461746153657373696F6E53746F72616765284A534F4E2E737472696E67696679286461746129293B0D0A20202020202020202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(57) := '2020202020202020206170657853706F746C696768742E68696465576169745370696E6E657228293B0D0A202020202020202020202020202063616C6C6261636B2864617461293B0D0A2020202020202020202020207D0D0A202020202020202020207D';
wwv_flow_imp.g_varchar2_table(58) := '2C0D0A202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A2020202020202020202020207064742E756E436C6F616B44656275674C6576656C2829';
wwv_flow_imp.g_varchar2_table(59) := '3B0D0A2020202020202020202020207064742E6F70742E73706F746C696768745072656665746368696E67203D2066616C73653B0D0A2020202020202020202020206170657853706F746C696768742E726573746F72654F72696749636F6E28293B0D0A';
wwv_flow_imp.g_varchar2_table(60) := '202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20277064742D6170657873706F746C696768742D616A61782D6572726F72272C207B0D0A2020202020202020202020202020226D657373616765223A2065';
wwv_flow_imp.g_varchar2_table(61) := '72726F725468726F776E0D0A2020202020202020202020207D293B0D0A202020202020202020202020617065782E64656275672E696E666F28226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F7222';
wwv_flow_imp.g_varchar2_table(62) := '2C206572726F725468726F776E293B0D0A2020202020202020202020206170657853706F746C696768742E68696465576169745370696E6E657228293B0D0A20202020202020202020202063616C6C6261636B285B5D293B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(63) := '7D0D0A20202020202020207D293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20476574204A534F4E20636F6E7461696E696E67206461746120666F722073706F746C696768742073656172636820656E747269657320';
wwv_flow_imp.g_varchar2_table(64) := '66726F6D2044420D0A202020202020202A2040706172616D207B66756E6374696F6E7D2063616C6C6261636B0D0A202020202020202A2F0D0A20202020202067657453706F746C69676874446174613A2066756E6374696F6E202863616C6C6261636B29';
wwv_flow_imp.g_varchar2_table(65) := '207B0D0A2020202020202020766172206361636865446174613B0D0A2020202020202020696620286170657853706F746C696768742E67456E61626C6544617461436163686529207B0D0A20202020202020202020636163686544617461203D20617065';
wwv_flow_imp.g_varchar2_table(66) := '7853706F746C696768742E67657453706F746C696768744461746153657373696F6E53746F7261676528293B0D0A202020202020202020206966202863616368654461746129207B0D0A2020202020202020202020207064742E6F70742E73706F746C69';
wwv_flow_imp.g_varchar2_table(67) := '6768745072656665746368696E67203D2066616C73653B0D0A2020202020202020202020206170657853706F746C696768742E726573746F72654F72696749636F6E28293B0D0A20202020202020202020202063616C6C6261636B284A534F4E2E706172';
wwv_flow_imp.g_varchar2_table(68) := '73652863616368654461746129293B0D0A20202020202020202020202072657475726E3B0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020202020747279207B0D0A202020202020202020206170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(69) := '2E73686F77576169745370696E6E657228293B0D0A202020202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A20202020202020202020617065782E64656275672E696E666F2822504454204665746368696E6720446174612E';
wwv_flow_imp.g_varchar2_table(70) := '2E2E22293B0D0A202020202020202020206170657853706F746C696768742E67657453706F746C69676874446174614368756E6B65642863616C6C6261636B2C20312C206170657853706F746C696768742E676368756E6B53697A65293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(71) := '202020207D206361746368202865727229207B0D0A202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A202020202020202020207064742E6F70742E73706F746C696768745072656665746368696E67203D206661';
wwv_flow_imp.g_varchar2_table(72) := '6C73653B0D0A202020202020202020206170657853706F746C696768742E726573746F72654F72696749636F6E28293B0D0A20202020202020202020617065782E6576656E742E747269676765722827626F6479272C20277064742D6170657873706F74';
wwv_flow_imp.g_varchar2_table(73) := '6C696768742D616A61782D6572726F72272C207B0D0A202020202020202020202020226D657373616765223A206572720D0A202020202020202020207D293B0D0A20202020202020202020617065782E64656275672E696E666F28226170657853706F74';
wwv_flow_imp.g_varchar2_table(74) := '6C696768742E67657453706F746C696768744461746120414A4158204572726F72222C20657272293B0D0A202020202020202020206170657853706F746C696768742E68696465576169745370696E6E657228293B0D0A2020202020202020202063616C';
wwv_flow_imp.g_varchar2_table(75) := '6C6261636B285B5D293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20476574204A534F4E20636F6E7461696E696E67205353502055524C2077697468207265706C61636564207365617263';
wwv_flow_imp.g_varchar2_table(76) := '68206B6579776F72642076616C756520287E5345415243485F56414C55457E20737562737469747574696F6E20737472696E67290D0A202020202020202A2040706172616D207B737472696E677D207055726C0D0A202020202020202A2040706172616D';
wwv_flow_imp.g_varchar2_table(77) := '207B66756E6374696F6E7D2063616C6C6261636B0D0A202020202020202A2F0D0A20202020202067657450726F7065724170657855726C3A2066756E6374696F6E20287055726C2C2063616C6C6261636B29207B0D0A2020202020202020747279207B0D';
wwv_flow_imp.g_varchar2_table(78) := '0A202020202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A20202020202020202020617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965722C207B0D0A2020';
wwv_flow_imp.g_varchar2_table(79) := '202020202020202020207830313A20274745545F55524C272C0D0A2020202020202020202020207830323A206170657853706F746C696768742E674B6579776F7264732C0D0A2020202020202020202020207830333A207055726C0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(80) := '2020207D2C207B0D0A20202020202020202020202064617461547970653A20276A736F6E272C0D0A202020202020202020202020737563636573733A2066756E6374696F6E20286461746129207B0D0A20202020202020202020202020207064742E756E';
wwv_flow_imp.g_varchar2_table(81) := '436C6F616B44656275674C6576656C28293B0D0A2020202020202020202020202020617065782E64656275672E696E666F28226170657853706F746C696768742E67657450726F7065724170657855726C20414A41582053756363657373222C20646174';
wwv_flow_imp.g_varchar2_table(82) := '61293B0D0A202020202020202020202020202063616C6C6261636B2864617461293B0D0A2020202020202020202020207D2C0D0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C20';
wwv_flow_imp.g_varchar2_table(83) := '6572726F725468726F776E29207B0D0A20202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A2020202020202020202020202020617065782E64656275672E696E666F28226170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(84) := '2E67657450726F7065724170657855726C20414A4158204572726F72222C206572726F725468726F776E293B0D0A202020202020202020202020202063616C6C6261636B287B0D0A202020202020202020202020202020202275726C223A207055726C0D';
wwv_flow_imp.g_varchar2_table(85) := '0A20202020202020202020202020207D293B0D0A2020202020202020202020207D0D0A202020202020202020207D293B0D0A20202020202020207D206361746368202865727229207B0D0A202020202020202020207064742E756E436C6F616B44656275';
wwv_flow_imp.g_varchar2_table(86) := '674C6576656C28293B0D0A20202020202020202020617065782E64656275672E696E666F28226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C20657272293B0D0A2020202020202020202063';
wwv_flow_imp.g_varchar2_table(87) := '616C6C6261636B287B0D0A2020202020202020202020202275726C223A207055726C0D0A202020202020202020207D293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2053617665204A534F';
wwv_flow_imp.g_varchar2_table(88) := '4E204461746120696E206C6F63616C2073657373696F6E2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C6170705F73657373696F6E3E2E3C64612D69643E2E64617461290D0A20202020';
wwv_flow_imp.g_varchar2_table(89) := '2020202A2040706172616D207B6F626A6563747D2070446174610D0A202020202020202A2F0D0A20202020202073657453706F746C696768744461746153657373696F6E53746F726167653A2066756E6374696F6E2028704461746129207B0D0A202020';
wwv_flow_imp.g_varchar2_table(90) := '20202020207661722068617353657373696F6E53746F72616765537570706F7274203D20617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F727428293B0D0A0D0A2020202020202020696620286861735365737369';
wwv_flow_imp.g_varchar2_table(91) := '6F6E53746F72616765537570706F727429207B0D0A0D0A202020202020202020202F2F2073746F7265206E65772070446174610D0A20202020202020202020766172206170657853657373696F6E203D202476282770496E7374616E636527293B0D0A20';
wwv_flow_imp.g_varchar2_table(92) := '2020202020202020207661722073657373696F6E53746F72616765203D20617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0D0A2020202020202020202020207072656669783A2027706474417065785370';
wwv_flow_imp.g_varchar2_table(93) := '6F746C69676874272C0D0A20202020202020202020202075736541707049643A20747275650D0A202020202020202020207D293B0D0A0D0A202020202020202020202F2F2052656D6F766520616E7920726564756E64616E742073746F726167650D0A20';
wwv_flow_imp.g_varchar2_table(94) := '202020202020202020666F7220286C6574206B657920696E2073657373696F6E53746F726167652E5F73746F726529207B0D0A202020202020202020202020696620286B65792E656E647357697468282770647453706F746C6967687444617461272929';
wwv_flow_imp.g_varchar2_table(95) := '207B0D0A20202020202020202020202020206B6579203D206B65792E7265706C616365282F5E7064744170657853706F746C696768745C2E2F2C202727293B0D0A202020202020202020202020202073657373696F6E53746F726167652E72656D6F7665';
wwv_flow_imp.g_varchar2_table(96) := '4974656D286B6579293B0D0A2020202020202020202020207D0D0A202020202020202020207D0D0A0D0A202020202020202020202F2F20636F6D707265737320776974682070616B6F0D0A20202020202020202020636F6E7374206465666C6174656420';
wwv_flow_imp.g_varchar2_table(97) := '3D2070616B6F2E6465666C617465284A534F4E2E737472696E6769667928704461746129293B0D0A20202020202020202020636F6E7374204348554E4B5F53495A45203D2034363635363B202F2F20746869732068617320746F20626520612066616374';
wwv_flow_imp.g_varchar2_table(98) := '6F72206F662073697820692E6520365E32203D2034363635360D0A20202020202020202020636F6E737420656E636F6465644368756E6B73203D205B5D3B0D0A20202020202020202020666F7220286C65742069203D20303B2069203C206465666C6174';
wwv_flow_imp.g_varchar2_table(99) := '65642E6C656E6774683B2069202B3D204348554E4B5F53495A4529207B0D0A202020202020202020202020636F6E7374206368756E6B203D206465666C617465642E736C69636528692C2069202B204348554E4B5F53495A45293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(100) := '2020202020636F6E737420656E636F6465644368756E6B203D2062746F6128537472696E672E66726F6D43686172436F64652E6170706C79286E756C6C2C206368756E6B29293B0D0A202020202020202020202020656E636F6465644368756E6B732E70';
wwv_flow_imp.g_varchar2_table(101) := '75736828656E636F6465644368756E6B293B0D0A202020202020202020207D0D0A20202020202020202020636F6E737420656E636F64656444617461203D20656E636F6465644368756E6B732E6A6F696E282222293B0D0A0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(102) := '2F2F2073657373696F6E53746F726167652E7365744974656D286170657853657373696F6E202B20272E27202B206170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E70647453706F746C6967687444617461272C20';
wwv_flow_imp.g_varchar2_table(103) := '656E636F64656444617461293B0D0A2020202020202020202073657373696F6E53746F726167652E7365744974656D286170657853657373696F6E202B20272E70647453706F746C6967687444617461272C20656E636F64656444617461293B0D0A2020';
wwv_flow_imp.g_varchar2_table(104) := '2020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20476574204A534F4E20446174612066726F6D206C6F63616C2073657373696F6E2073746F72616765206F662062726F7773657220286170657853706F74';
wwv_flow_imp.g_varchar2_table(105) := '6C696768742E3C6170705F69643E2E3C6170705F73657373696F6E3E2E3C64612D69643E2E64617461290D0A202020202020202A2F0D0A20202020202067657453706F746C696768744461746153657373696F6E53746F726167653A2066756E6374696F';
wwv_flow_imp.g_varchar2_table(106) := '6E202829207B0D0A20202020202020207661722068617353657373696F6E53746F72616765537570706F7274203D20617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F727428293B0D0A0D0A202020202020202076';
wwv_flow_imp.g_varchar2_table(107) := '61722073746F7261676556616C75653B0D0A20202020202020206966202868617353657373696F6E53746F72616765537570706F727429207B0D0A20202020202020202020766172206170657853657373696F6E203D202476282770496E7374616E6365';
wwv_flow_imp.g_varchar2_table(108) := '27293B0D0A202020202020202020207661722073657373696F6E53746F72616765203D20617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0D0A2020202020202020202020207072656669783A2027706474';
wwv_flow_imp.g_varchar2_table(109) := '4170657853706F746C69676874272C0D0A20202020202020202020202075736541707049643A20747275650D0A202020202020202020207D293B0D0A202020202020202020202F2F20656E6353746F7261676556616C7565203D2073657373696F6E5374';
wwv_flow_imp.g_varchar2_table(110) := '6F726167652E6765744974656D286170657853657373696F6E202B20272E27202B206170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E70647453706F746C696768744461746127293B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(111) := '656E6353746F7261676556616C7565203D2073657373696F6E53746F726167652E6765744974656D286170657853657373696F6E202B20272E70647453706F746C696768744461746127293B0D0A0D0A2020202020202020202069662028656E6353746F';
wwv_flow_imp.g_varchar2_table(112) := '7261676556616C756529207B0D0A2020202020202020202020202F2F20556E636F6D707265737320776974682070616B6F0D0A202020202020202020202020636F6E7374206465636F64656444617461203D2061746F6228656E6353746F726167655661';
wwv_flow_imp.g_varchar2_table(113) := '6C7565293B0D0A202020202020202020202020636F6E7374206368617244617461203D206465636F646564446174612E73706C6974282727292E6D61702866756E6374696F6E20287829207B2072657475726E20782E63686172436F646541742830293B';
wwv_flow_imp.g_varchar2_table(114) := '207D293B0D0A202020202020202020202020636F6E73742062696E44617461203D206E65772055696E74384172726179286368617244617461293B0D0A20202020202020202020202073746F7261676556616C7565203D204A534F4E2E70617273652870';
wwv_flow_imp.g_varchar2_table(115) := '616B6F2E696E666C6174652862696E446174612C207B20746F3A2027737472696E6727207D29293B0D0A202020202020202020207D0D0A0D0A20202020202020207D0D0A202020202020202072657475726E2073746F7261676556616C75653B0D0A2020';
wwv_flow_imp.g_varchar2_table(116) := '202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A205361766520736561726368207465726D20696E206C6F63616C2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C6461';
wwv_flow_imp.g_varchar2_table(117) := '2D69643E2E686973746F7279290D0A202020202020202A2040706172616D207B737472696E677D20705365617263685465726D0D0A202020202020202A2F0D0A20202020202073657453706F746C69676874486973746F72794C6F63616C53746F726167';
wwv_flow_imp.g_varchar2_table(118) := '653A2066756E6374696F6E2028705365617263685465726D29207B0D0A2020202020202020766172206861734C6F63616C53746F72616765537570706F7274203D20617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F72';
wwv_flow_imp.g_varchar2_table(119) := '7428293B0D0A20202020202020207661722073746F726167654172726179203D205B5D3B0D0A0D0A20202020202020207661722072656D6F76654475707346726F6D4172726179203D2066756E6374696F6E202870417272617929207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(120) := '202020202076617220756E69717565203D207B7D3B0D0A202020202020202020207041727261792E666F72456163682866756E6374696F6E20286929207B0D0A2020202020202020202020206966202821756E697175655B695D29207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(121) := '202020202020202020756E697175655B695D203D20747275653B0D0A2020202020202020202020207D0D0A202020202020202020207D293B0D0A2020202020202020202072657475726E204F626A6563742E6B65797328756E69717565293B0D0A202020';
wwv_flow_imp.g_varchar2_table(122) := '20202020207D3B0D0A0D0A20202020202020207661722072656D6F76654F6C6456616C75657346726F6D4172726179203D2066756E6374696F6E202870417272617929207B0D0A20202020202020202020666F7220287661722069203D20303B2069203C';
wwv_flow_imp.g_varchar2_table(123) := '207041727261792E6C656E6774683B20692B2B29207B0D0A2020202020202020202020206966202869203E20333029207B0D0A20202020202020202020202020207041727261792E73706C69636528692C2031293B0D0A2020202020202020202020207D';
wwv_flow_imp.g_varchar2_table(124) := '0D0A202020202020202020207D0D0A2020202020202020202072657475726E207041727261793B0D0A20202020202020207D3B0D0A20202020202020202F2F206F6E6C792061646420737472696E677320746F20666972737420706F736974696F6E206F';
wwv_flow_imp.g_varchar2_table(125) := '662061727261790D0A20202020202020206966202869734E614E28705365617263685465726D2929207B0D0A2020202020202020202073746F726167654172726179203D206170657853706F746C696768742E67657453706F746C69676874486973746F';
wwv_flow_imp.g_varchar2_table(126) := '72794C6F63616C53746F7261676528293B0D0A2020202020202020202073746F7261676541727261792E756E736869667428705365617263685465726D2E7472696D2829293B0D0A2020202020202020202073746F726167654172726179203D2072656D';
wwv_flow_imp.g_varchar2_table(127) := '6F76654475707346726F6D41727261792873746F726167654172726179293B0D0A2020202020202020202073746F726167654172726179203D2072656D6F76654F6C6456616C75657346726F6D41727261792873746F726167654172726179293B0D0A0D';
wwv_flow_imp.g_varchar2_table(128) := '0A20202020202020202020696620286861734C6F63616C53746F72616765537570706F727429207B0D0A202020202020202020202020766172206C6F63616C53746F72616765203D20617065782E73746F726167652E67657453636F7065644C6F63616C';
wwv_flow_imp.g_varchar2_table(129) := '53746F72616765287B0D0A20202020202020202020202020207072656669783A20276170657853706F746C69676874272C0D0A202020202020202020202020202075736541707049643A20747275650D0A2020202020202020202020207D293B0D0A2020';
wwv_flow_imp.g_varchar2_table(130) := '202020202020202020206C6F63616C53746F726167652E7365744974656D286170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E686973746F7279272C204A534F4E2E737472696E676966792873746F726167654172';
wwv_flow_imp.g_varchar2_table(131) := '72617929293B0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2047657420736176656420736561726368207465726D732066726F6D206C6F63616C2073746F72';
wwv_flow_imp.g_varchar2_table(132) := '616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C64612D69643E2E686973746F7279290D0A202020202020202A2F0D0A20202020202067657453706F746C69676874486973746F72794C6F63616C5374';
wwv_flow_imp.g_varchar2_table(133) := '6F726167653A2066756E6374696F6E202829207B0D0A2020202020202020766172206861734C6F63616C53746F72616765537570706F7274203D20617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F727428293B0D0A0D';
wwv_flow_imp.g_varchar2_table(134) := '0A20202020202020207661722073746F7261676556616C75653B0D0A20202020202020207661722073746F726167654172726179203D205B5D3B0D0A2020202020202020696620286861734C6F63616C53746F72616765537570706F727429207B0D0A20';
wwv_flow_imp.g_varchar2_table(135) := '202020202020202020766172206C6F63616C53746F72616765203D20617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B0D0A2020202020202020202020207072656669783A20276170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(136) := '272C0D0A20202020202020202020202075736541707049643A20747275650D0A202020202020202020207D293B0D0A2020202020202020202073746F7261676556616C7565203D206C6F63616C53746F726167652E6765744974656D286170657853706F';
wwv_flow_imp.g_varchar2_table(137) := '746C696768742E6744796E616D6963416374696F6E4964202B20272E686973746F727927293B0D0A202020202020202020206966202873746F7261676556616C756529207B0D0A20202020202020202020202073746F726167654172726179203D204A53';
wwv_flow_imp.g_varchar2_table(138) := '4F4E2E70617273652873746F7261676556616C7565293B0D0A202020202020202020207D0D0A20202020202020207D0D0A202020202020202072657475726E2073746F7261676541727261793B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A';
wwv_flow_imp.g_varchar2_table(139) := '202020202020202A2052656D6F766520736176656420736561726368207465726D732066726F6D206C6F63616C2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C6170705F73657373696F';
wwv_flow_imp.g_varchar2_table(140) := '6E3E2E3C64612D69643E2E686973746F7279290D0A202020202020202A2F0D0A20202020202072656D6F766553706F746C69676874486973746F72794C6F63616C53746F726167653A2066756E6374696F6E202829207B0D0A2020202020202020766172';
wwv_flow_imp.g_varchar2_table(141) := '206861734C6F63616C53746F72616765537570706F7274203D20617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F727428293B0D0A0D0A2020202020202020696620286861734C6F63616C53746F72616765537570706F';
wwv_flow_imp.g_varchar2_table(142) := '727429207B0D0A20202020202020202020766172206C6F63616C53746F72616765203D20617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B0D0A2020202020202020202020207072656669783A20276170657853';
wwv_flow_imp.g_varchar2_table(143) := '706F746C69676874272C0D0A20202020202020202020202075736541707049643A20747275650D0A202020202020202020207D293B0D0A202020202020202020206C6F63616C53746F726167652E72656D6F76654974656D286170657853706F746C6967';
wwv_flow_imp.g_varchar2_table(144) := '68742E6744796E616D6963416374696F6E4964202B20272E686973746F727927293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2053686F7720706F706F766572207573696E672074697070';
wwv_flow_imp.g_varchar2_table(145) := '792E6A7320776869636820636F6E7461696E7320736176656420686973746F727920656E7472696573206F66206C6F63616C2073746F726167650D0A202020202020202A2F0D0A20202020202073686F775469707079486973746F7279506F706F766572';
wwv_flow_imp.g_varchar2_table(146) := '3A2066756E6374696F6E202829207B0D0A202020202020202076617220686973746F72794172726179203D206170657853706F746C696768742E67657453706F746C69676874486973746F72794C6F63616C53746F726167652829207C7C205B5D3B0D0A';
wwv_flow_imp.g_varchar2_table(147) := '202020202020202076617220636F6E74656E74203D2027273B0D0A2020202020202020766172206C6F6F70436F756E74203D20303B0D0A0D0A202020202020202069662028686973746F727941727261792E6C656E677468203E203029207B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(148) := '2020202020202020206170657853706F746C696768742E64657374726F795469707079486973746F7279506F706F76657228293B0D0A202020202020202020202428276469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E2729';
wwv_flow_imp.g_varchar2_table(149) := '2E6373732827637572736F72272C2027706F696E74657227293B0D0A0D0A20202020202020202020636F6E74656E74202B3D20273C756C20636C6173733D2273706F746C696768742D686973746F72792D6C697374223E273B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(150) := '20666F7220287661722069203D20303B2069203C20686973746F727941727261792E6C656E6774683B20692B2B29207B0D0A202020202020202020202020636F6E74656E74202B3D20223C6C693E3C6120636C6173733D5C2273706F746C696768742D68';
wwv_flow_imp.g_varchar2_table(151) := '6973746F72792D6C696E6B5C2220687265663D5C226A6176617363726970743A7064742E6170657853706F746C696768742E736574486973746F727953656172636856616C7565282722202B20617065782E7574696C2E65736361706548544D4C286869';
wwv_flow_imp.g_varchar2_table(152) := '73746F727941727261795B695D29202B202227293B5C223E22202B20617065782E7574696C2E65736361706548544D4C28686973746F727941727261795B695D29202B20223C2F613E3C2F6C693E223B0D0A2020202020202020202020206C6F6F70436F';
wwv_flow_imp.g_varchar2_table(153) := '756E74203D206C6F6F70436F756E74202B20313B0D0A202020202020202020202020696620286C6F6F70436F756E74203E3D20323029207B0D0A2020202020202020202020202020627265616B3B0D0A2020202020202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(154) := '20202020207D0D0A20202020202020202020636F6E74656E74202B3D20223C6C693E3C6120636C6173733D5C2273706F746C696768742D686973746F72792D64656C6574655C2220687265663D5C226A6176617363726970743A766F69642830293B5C22';
wwv_flow_imp.g_varchar2_table(155) := '3E3C693E22202B206170657853706F746C696768742E67536561726368486973746F727944656C65746554657874202B20223C2F693E3C2F613E3C2F6C693E223B0D0A20202020202020202020636F6E74656E74202B3D20273C2F756C3E273B0D0A0D0A';
wwv_flow_imp.g_varchar2_table(156) := '202020202020202020207469707079282428276469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E27295B305D2C207B0D0A202020202020202020202020636F6E74656E743A20636F6E74656E742C0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(157) := '202020696E7465726163746976653A20747275652C0D0A2020202020202020202020206172726F773A20747275652C0D0A202020202020202020202020706C6163656D656E743A202772696768742D656E64272C0D0A202020202020202020202020616E';
wwv_flow_imp.g_varchar2_table(158) := '696D61746546696C6C3A2066616C73650D0A202020202020202020207D293B0D0A0D0A20202020202020202020242827626F647927292E6F6E2827636C69636B272C2027612E73706F746C696768742D686973746F72792D6C696E6B272C2066756E6374';
wwv_flow_imp.g_varchar2_table(159) := '696F6E202829207B0D0A2020202020202020202020206170657853706F746C696768742E686964655469707079486973746F7279506F706F76657228293B0D0A202020202020202020207D293B0D0A20202020202020202020242827626F647927292E6F';
wwv_flow_imp.g_varchar2_table(160) := '6E2827636C69636B272C2027612E73706F746C696768742D686973746F72792D64656C657465272C2066756E6374696F6E202829207B0D0A2020202020202020202020206170657853706F746C696768742E64657374726F795469707079486973746F72';
wwv_flow_imp.g_varchar2_table(161) := '79506F706F76657228293B0D0A2020202020202020202020206170657853706F746C696768742E72656D6F766553706F746C69676874486973746F72794C6F63616C53746F7261676528293B0D0A202020202020202020207D293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(162) := '207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A204869646520706F706F766572207573696E672074697070792E6A7320776869636820636F6E7461696E7320736176656420686973746F727920656E7472696573206F';
wwv_flow_imp.g_varchar2_table(163) := '66206C6F63616C2073746F726167650D0A202020202020202A2F0D0A202020202020686964655469707079486973746F7279506F706F7665723A2066756E6374696F6E202829207B0D0A2020202020202020766172207469707079456C656D203D202428';
wwv_flow_imp.g_varchar2_table(164) := '276469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E27295B305D3B0D0A2020202020202020696620287469707079456C656D202626207469707079456C656D2E5F746970707929207B0D0A2020202020202020202074697070';
wwv_flow_imp.g_varchar2_table(165) := '79456C656D2E5F74697070792E6869646528293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2044657374726F7920706F706F766572207573696E672074697070792E6A7320776869636820';
wwv_flow_imp.g_varchar2_table(166) := '636F6E7461696E7320736176656420686973746F727920656E7472696573206F66206C6F63616C2073746F726167650D0A202020202020202A2F0D0A20202020202064657374726F795469707079486973746F7279506F706F7665723A2066756E637469';
wwv_flow_imp.g_varchar2_table(167) := '6F6E202829207B0D0A2020202020202020766172207469707079456C656D203D202428276469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E27295B305D3B0D0A2020202020202020696620287469707079456C656D20262620';
wwv_flow_imp.g_varchar2_table(168) := '7469707079456C656D2E5F746970707929207B0D0A202020202020202020207469707079456C656D2E5F74697070792E64657374726F7928293B0D0A20202020202020207D0D0A202020202020202024286170657853706F746C696768742E444F54202B';
wwv_flow_imp.g_varchar2_table(169) := '206170657853706F746C696768742E53505F494E505554292E666F63757328293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2053686F772077616974207370696E6E657220746F2073686F772070726F677265737320';
wwv_flow_imp.g_varchar2_table(170) := '6F6620414A41582063616C6C0D0A202020202020202A2F0D0A20202020202073686F77576169745370696E6E65723A2066756E6374696F6E202829207B0D0A2020202020202020696620286170657853706F746C696768742E6753686F7750726F636573';
wwv_flow_imp.g_varchar2_table(171) := '73696E6729207B0D0A202020202020202020202428276469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E207370616E27292E70726F702827636C6173734E616D65272C202727292E616464436C617373282766612066612D72';
wwv_flow_imp.g_varchar2_table(172) := '6566726573682066612D616E696D2D7370696E27293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20486964652077616974207370696E6E657220616E6420646973706C6179206465666175';
wwv_flow_imp.g_varchar2_table(173) := '6C74207365617263682069636F6E0D0A202020202020202A2F0D0A20202020202068696465576169745370696E6E65723A2066756E6374696F6E202829207B0D0A2020202020202020696620286170657853706F746C696768742E6753686F7750726F63';
wwv_flow_imp.g_varchar2_table(174) := '657373696E6729207B0D0A202020202020202020202428276469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E207370616E27292E70726F702827636C6173734E616D65272C202727292E616464436C61737328617065785370';
wwv_flow_imp.g_varchar2_table(175) := '6F746C696768742E67506C616365486F6C64657249636F6E293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A204765742074657874206F662073656C65637465642074657874206F6E20646F';
wwv_flow_imp.g_varchar2_table(176) := '63756D656E740D0A202020202020202A2F0D0A20202020202067657453656C6563746564546578743A2066756E6374696F6E202829207B0D0A20202020202020207661722072616E67653B0D0A20202020202020206966202877696E646F772E67657453';
wwv_flow_imp.g_varchar2_table(177) := '656C656374696F6E29207B0D0A2020202020202020202072616E6765203D2077696E646F772E67657453656C656374696F6E28293B0D0A2020202020202020202072657475726E2072616E67652E746F537472696E6728292E7472696D28293B0D0A2020';
wwv_flow_imp.g_varchar2_table(178) := '2020202020207D20656C7365207B0D0A2020202020202020202069662028646F63756D656E742E73656C656374696F6E2E63726561746552616E676529207B0D0A20202020202020202020202072616E6765203D20646F63756D656E742E73656C656374';
wwv_flow_imp.g_varchar2_table(179) := '696F6E2E63726561746552616E676528293B0D0A20202020202020202020202072657475726E2072616E67652E746578742E7472696D28293B0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F';
wwv_flow_imp.g_varchar2_table(180) := '2A2A0D0A202020202020202A2046657463682073656C6563746564207465787420616E642073657420697420746F2073706F746C696768742073656172636820696E7075740D0A202020202020202A2F0D0A20202020202073657453656C656374656454';
wwv_flow_imp.g_varchar2_table(181) := '6578743A2066756E6374696F6E2028705465787429207B0D0A20202020202020202F2F206765742073656C656374656420746578740D0A20202020202020207661722073656C6563746564546578743B0D0A0D0A20202020202020206966202870546578';
wwv_flow_imp.g_varchar2_table(182) := '7429207B0D0A2020202020202020202073656C656374656454657874203D2070546578743B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202073656C656374656454657874203D206170657853706F746C696768742E67657453';
wwv_flow_imp.g_varchar2_table(183) := '656C65637465645465787428293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F207365742073656C6563746564207465787420746F2073706F746C6967687420696E7075740D0A20202020202020206966202873656C65637465645465';
wwv_flow_imp.g_varchar2_table(184) := '787429207B0D0A202020202020202020202F2F206966206469616C6F672026206461746120616C72656164792074686572650D0A20202020202020202020696620286170657853706F746C696768742E674861734469616C6F674372656174656429207B';
wwv_flow_imp.g_varchar2_table(185) := '0D0A20202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C2873656C656374656454657874292E747269676765722827696E70757427293B0D0A202020';
wwv_flow_imp.g_varchar2_table(186) := '2020202020202020202F2F206469616C6F672068617320746F206265206F70656E656420262064617461206D75737420626520666574636865640D0A202020202020202020207D20656C7365207B0D0A2020202020202020202020202F2F206E6F742075';
wwv_flow_imp.g_varchar2_table(187) := '6E74696C206461746120686173206265656E20696E20706C6163650D0A202020202020202020202020242827626F647927292E6F6E28277064742D6170657873706F746C696768742D6765742D64617461272C2066756E6374696F6E202829207B0D0A20';
wwv_flow_imp.g_varchar2_table(188) := '2020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C2873656C656374656454657874292E747269676765722827696E70757427293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(189) := '20202020202020207D293B0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A205772617070657220666F7220617065782E6E617669676174696F6E2E7265646972';
wwv_flow_imp.g_varchar2_table(190) := '65637420746F206F7074696F6E616C6C792073686F7720612077616974696E67207370696E6E6572206265666F7265207265646972656374696E670D0A202020202020202A2040706172616D207B737472696E677D207057686572650D0A202020202020';
wwv_flow_imp.g_varchar2_table(191) := '202A2F0D0A20202020202072656469726563743A2066756E6374696F6E202870576865726529207B0D0A2020202020202020696620286170657853706F746C696768742E6753686F7750726F63657373696E6729207B0D0A202020202020202020207472';
wwv_flow_imp.g_varchar2_table(192) := '79207B0D0A2020202020202020202020202F2F206E6F2077616974696E67207370696E6E657220666F72206A61766173637269707420746172676574730D0A202020202020202020202020696620287057686572652E7374617274735769746828276A61';
wwv_flow_imp.g_varchar2_table(193) := '76617363726970743A272929207B0D0A2020202020202020202020202020617065782E6E617669676174696F6E2E726564697265637428705768657265293B0D0A2020202020202020202020207D20656C7365207B0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(194) := '202F2F206F6E6C792073686F77207370696E6E6572206966206E6F7420616C72656164792070726573656E7420616E64206966206974C2B47320616E204150455820746172676574207061676520616E64206E6F20636C69656E7420736964652076616C';
wwv_flow_imp.g_varchar2_table(195) := '69646174696F6E206572726F7273206F63637572656420616E6420746865207061676520686173206E6F74206368616E6765640D0A2020202020202020202020202020696620282428277370616E2E752D50726F63657373696E6727292E6C656E677468';
wwv_flow_imp.g_varchar2_table(196) := '203D3D20302026260D0A202020202020202020202020202020207057686572652E737461727473576974682827663F703D27292026260D0A20202020202020202020202020202020617065782E706167652E76616C696461746528292026260D0A202020';
wwv_flow_imp.g_varchar2_table(197) := '2020202020202020202020202021617065782E706167652E69734368616E676564282929207B0D0A202020202020202020202020202020206170657853706F746C696768742E67576169745370696E6E657224203D20617065782E7574696C2E73686F77';
wwv_flow_imp.g_varchar2_table(198) := '5370696E6E657228242827626F64792729293B0D0A20202020202020202020202020207D0D0A2020202020202020202020202020617065782E6E617669676174696F6E2E726564697265637428705768657265293B0D0A2020202020202020202020207D';
wwv_flow_imp.g_varchar2_table(199) := '0D0A202020202020202020207D206361746368202865727229207B0D0A202020202020202020202020696620286170657853706F746C696768742E67576169745370696E6E65722429207B0D0A20202020202020202020202020206170657853706F746C';
wwv_flow_imp.g_varchar2_table(200) := '696768742E67576169745370696E6E6572242E72656D6F766528293B0D0A2020202020202020202020207D0D0A202020202020202020202020617065782E6E617669676174696F6E2E726564697265637428705768657265293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(201) := '20207D0D0A20202020202020207D20656C7365207B0D0A20202020202020202020617065782E6E617669676174696F6E2E726564697265637428705768657265293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A';
wwv_flow_imp.g_varchar2_table(202) := '202020202020202A2048616E646C65206172696120617474726962757465730D0A202020202020202A2F0D0A20202020202068616E646C6541726961417474723A2066756E6374696F6E202829207B0D0A202020202020202076617220726573756C7473';
wwv_flow_imp.g_varchar2_table(203) := '24203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0D0A20202020202020202020696E70757424203D2024286170657853706F746C696768742E444F54202B206170657853';
wwv_flow_imp.g_varchar2_table(204) := '706F746C696768742E53505F494E505554292C0D0A202020202020202020206163746976654964203D20726573756C7473242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F41435449564529';
wwv_flow_imp.g_varchar2_table(205) := '2E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C545F4C4142454C292E617474722827696427292C0D0A20202020202020202020616374697665456C656D24203D20242827232720';
wwv_flow_imp.g_varchar2_table(206) := '2B206163746976654964292C0D0A2020202020202020202061637469766554657874203D20616374697665456C656D242E7465787428292C0D0A202020202020202020206C697324203D20726573756C7473242E66696E6428276C6927292C0D0A202020';
wwv_flow_imp.g_varchar2_table(207) := '202020202020206973457870616E646564203D206C6973242E6C656E67746820213D3D20302C0D0A202020202020202020206C69766554657874203D2027272C0D0A20202020202020202020726573756C7473436F756E74203D206C6973242E66696C74';
wwv_flow_imp.g_varchar2_table(208) := '65722866756E6374696F6E202829207B0D0A2020202020202020202020202F2F204578636C7564652074686520676C6F62616C20696E736572746564203C6C693E2C207768696368206861732073686F727463757473204374726C202B20312C20322C20';
wwv_flow_imp.g_varchar2_table(209) := '330D0A2020202020202020202020202F2F2073756368206173202253656172636820576F726B737061636520666F722078222E0D0A20202020202020202020202072657475726E20242874686973292E66696E64286170657853706F746C696768742E44';
wwv_flow_imp.g_varchar2_table(210) := '4F54202B206170657853706F746C696768742E53505F53484F5254435554292E6C656E677468203D3D3D20303B0D0A202020202020202020207D292E6C656E6774683B0D0A0D0A202020202020202024286170657853706F746C696768742E444F54202B';
wwv_flow_imp.g_varchar2_table(211) := '206170657853706F746C696768742E53505F524553554C545F4C4142454C290D0A202020202020202020202E617474722827617269612D73656C6563746564272C202766616C736527293B0D0A0D0A2020202020202020616374697665456C656D240D0A';
wwv_flow_imp.g_varchar2_table(212) := '202020202020202020202E617474722827617269612D73656C6563746564272C20277472756527293B0D0A0D0A2020202020202020696620286170657853706F746C696768742E674B6579776F726473203D3D3D20272729207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(213) := '20206C69766554657874203D206170657853706F746C696768742E674D6F72654368617273546578743B0D0A20202020202020207D20656C73652069662028726573756C7473436F756E74203D3D3D203029207B0D0A202020202020202020206C697665';
wwv_flow_imp.g_varchar2_table(214) := '54657874203D206170657853706F746C696768742E674E6F4D61746368546578743B0D0A20202020202020207D20656C73652069662028726573756C7473436F756E74203D3D3D203129207B0D0A202020202020202020206C69766554657874203D2061';
wwv_flow_imp.g_varchar2_table(215) := '70657853706F746C696768742E674F6E654D61746368546578743B0D0A20202020202020207D20656C73652069662028726573756C7473436F756E74203E203129207B0D0A202020202020202020206C69766554657874203D20726573756C7473436F75';
wwv_flow_imp.g_varchar2_table(216) := '6E74202B20272027202B206170657853706F746C696768742E674D756C7469706C654D617463686573546578743B0D0A20202020202020207D0D0A0D0A20202020202020206C69766554657874203D2061637469766554657874202B20272C2027202B20';
wwv_flow_imp.g_varchar2_table(217) := '6C697665546578743B0D0A0D0A20202020202020202428272327202B206170657853706F746C696768742E53505F4C4956455F524547494F4E292E74657874286C69766554657874293B0D0A0D0A2020202020202020696E707574240D0A202020202020';
wwv_flow_imp.g_varchar2_table(218) := '202020202F2F202E706172656E74282920202F2F206172696120312E31207061747465726E0D0A202020202020202020202E617474722827617269612D61637469766564657363656E64616E74272C206163746976654964290D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(219) := '202E617474722827617269612D657870616E646564272C206973457870616E646564293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20436C6F7365206D6F64616C2073706F746C69676874206469616C6F670D0A2020';
wwv_flow_imp.g_varchar2_table(220) := '20202020202A2F0D0A202020202020636C6F73654469616C6F673A2066756E6374696F6E202829207B0D0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6469';
wwv_flow_imp.g_varchar2_table(221) := '616C6F672827636C6F736527293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2052657365742073706F746C696768740D0A202020202020202A2F0D0A202020202020726573657453706F746C696768743A2066756E63';
wwv_flow_imp.g_varchar2_table(222) := '74696F6E202829207B0D0A20202020202020202428272327202B206170657853706F746C696768742E53505F4C495354292E656D70747928293B0D0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C69';
wwv_flow_imp.g_varchar2_table(223) := '6768742E53505F494E505554292E76616C282727293B202F2F2072656D6F76656420222E666F63757328293B222066726F6D20746865207461696C206173206974207761732070726576656E74696E6720697420666F637573696E67206120326E642074';
wwv_flow_imp.g_varchar2_table(224) := '696D650D0A20202020202020206170657853706F746C696768742E674B6579776F726473203D2027273B0D0A20202020202020206170657853706F746C696768742E68616E646C65417269614174747228293B0D0A2020202020207D2C0D0A2020202020';
wwv_flow_imp.g_varchar2_table(225) := '202F2A2A0D0A202020202020202A204E617669676174696F6E20746F2074617267657420776869636820697320636F6E7461696E656420696E20656C656D2420283C613E206C696E6B290D0A202020202020202A2040706172616D207B6F626A6563747D';
wwv_flow_imp.g_varchar2_table(226) := '20656C656D240D0A202020202020202A2040706172616D207B6F626A6563747D206576656E740D0A202020202020202A2F0D0A202020202020676F546F3A2066756E6374696F6E2028656C656D242C206576656E7429207B0D0A20202020202020207661';
wwv_flow_imp.g_varchar2_table(227) := '722075726C203D20656C656D242E64617461282775726C27292C0D0A2020202020202020202074797065203D20656C656D242E6461746128277479706527293B0D0A0D0A202020202020202073776974636820287479706529207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(228) := '20202063617365206170657853706F746C696768742E55524C5F54595045532E736561726368506167653A0D0A2020202020202020202020206170657853706F746C696768742E696E5061676553656172636828293B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(229) := '627265616B3B0D0A0D0A2020202020202020202063617365206170657853706F746C696768742E55524C5F54595045532E72656469726563743A0D0A2020202020202020202020202F2F207265706C616365207E5345415243485F56414C55457E207375';
wwv_flow_imp.g_varchar2_table(230) := '62737469747574696F6E20737472696E670D0A2020202020202020202020206966202875726C2E696E636C7564657328277E5345415243485F56414C55457E272929207B0D0A20202020202020202020202020202F2F2065736361706520736F6D652070';
wwv_flow_imp.g_varchar2_table(231) := '726F626C656D61746963206368617273203A2C22270D0A20202020202020202020202020206170657853706F746C696768742E674B6579776F726473203D206170657853706F746C696768742E674B6579776F7264732E7265706C616365282F3A7C2C7C';
wwv_flow_imp.g_varchar2_table(232) := '227C272F672C20272027292E7472696D28293B0D0A20202020202020202020202020202F2F20736572766572207369646520696620415045582055524C2069732064657465637465640D0A20202020202020202020202020206966202875726C2E737461';
wwv_flow_imp.g_varchar2_table(233) := '727473576974682827663F703D272929207B0D0A202020202020202020202020202020206170657853706F746C696768742E67657450726F7065724170657855726C2875726C2C2066756E6374696F6E20286461746129207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(234) := '2020202020202020206170657853706F746C696768742E726564697265637428646174612E75726C293B0D0A202020202020202020202020202020207D293B0D0A202020202020202020202020202020202F2F20636C69656E74207369646520666F7220';
wwv_flow_imp.g_varchar2_table(235) := '616C6C206F746865722055524C730D0A20202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202075726C203D2075726C2E7265706C61636528277E5345415243485F56414C55457E272C206170657853706F74';
wwv_flow_imp.g_varchar2_table(236) := '6C696768742E674B6579776F726473293B0D0A202020202020202020202020202020206170657853706F746C696768742E72656469726563742875726C293B0D0A20202020202020202020202020207D0D0A2020202020202020202020207D0D0A202020';
wwv_flow_imp.g_varchar2_table(237) := '2020202020202020202F2F207265706C616365207E5345415243485F56414C55457E20737562737469747574696F6E20737472696E670D0A202020202020202020202020656C7365206966202875726C2E696E636C7564657328277E57494E444F577E27';
wwv_flow_imp.g_varchar2_table(238) := '2929207B0D0A2020202020202020202020202020696620286576656E742E6374726C4B6579207C7C206576656E742E6D6574614B657929207B0D0A202020202020202020202020202020202F2F20436F6E74726F6C206B6579206F7220636F6D6D616E64';
wwv_flow_imp.g_varchar2_table(239) := '206B6579206973206265696E672068656C6420646F776E0D0A2020202020202020202020202020202075726C203D2075726C2E7265706C61636528277E57494E444F577E272C20277472756527293B0D0A20202020202020202020202020207D20656C73';
wwv_flow_imp.g_varchar2_table(240) := '65207B0D0A2020202020202020202020202020202075726C203D2075726C2E7265706C61636528277E57494E444F577E272C202766616C736527293B0D0A20202020202020202020202020207D0D0A20202020202020202020202020206170657853706F';
wwv_flow_imp.g_varchar2_table(241) := '746C696768742E72656469726563742875726C293B0D0A20202020202020202020202020202F2F206E6F726D616C2055524C20776974686F757420737562737469747574696F6E20737472696E670D0A2020202020202020202020207D20656C7365207B';
wwv_flow_imp.g_varchar2_table(242) := '0D0A20202020202020202020202020206170657853706F746C696768742E72656469726563742875726C293B0D0A2020202020202020202020207D0D0A202020202020202020202020627265616B3B0D0A20202020202020207D0D0A0D0A202020202020';
wwv_flow_imp.g_varchar2_table(243) := '20206170657853706F746C696768742E636C6F73654469616C6F6728293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A204765742048544D4C206D61726B75700D0A202020202020202A2040706172616D207B6F626A65';
wwv_flow_imp.g_varchar2_table(244) := '63747D20646174610D0A202020202020202A2F0D0A2020202020206765744D61726B75703A2066756E6374696F6E20286461746129207B0D0A2020202020202020766172207469746C65203D20646174612E7469746C652C0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(245) := '64657363203D20646174612E64657363207C7C2027272C0D0A2020202020202020202075726C203D20646174612E75726C2C0D0A2020202020202020202074797065203D20646174612E747970652C0D0A2020202020202020202069636F6E203D206461';
wwv_flow_imp.g_varchar2_table(246) := '74612E69636F6E2C0D0A2020202020202020202069636F6E436F6C6F72203D20646174612E69636F6E436F6C6F722C0D0A2020202020202020202073686F7274637574203D20646174612E73686F72746375742C0D0A2020202020202020202073746174';
wwv_flow_imp.g_varchar2_table(247) := '6963203D20646174612E7374617469632C0D0A2020202020202020202073686F72746375744D61726B7570203D2073686F7274637574203F20273C7370616E20636C6173733D2227202B206170657853706F746C696768742E53505F53484F5254435554';
wwv_flow_imp.g_varchar2_table(248) := '202B202722203E27202B2073686F7274637574202B20273C2F7370616E3E27203A2027272C0D0A202020202020202020202F2F2073686F72746375744D61726B7570203D20273C7370616E20636C6173733D2227202B206170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(249) := '2E53505F53484F5254435554202B202722203E27202B202773686F727463757427202B20273C2F7370616E3E272C0D0A202020202020202020206461746141747472203D2027272C0D0A2020202020202020202069636F6E537472696E67203D2027272C';
wwv_flow_imp.g_varchar2_table(250) := '0D0A20202020202020202020696E64657854797065203D2027272C0D0A2020202020202020202069636F6E436F6C6F72537472696E67203D2027272C0D0A202020202020202020206F75743B0D0A0D0A20202020202020206966202875726C203D3D3D20';
wwv_flow_imp.g_varchar2_table(251) := '30207C7C2075726C29207B0D0A202020202020202020206461746141747472203D2027646174612D75726C3D2227202B2075726C202B20272220273B0D0A20202020202020207D0D0A0D0A2020202020202020696620287479706529207B0D0A20202020';
wwv_flow_imp.g_varchar2_table(252) := '2020202020206461746141747472203D206461746141747472202B202720646174612D747970653D2227202B2074797065202B20272220273B0D0A20202020202020207D0D0A0D0A20202020202020206966202869636F6E2E7374617274735769746828';
wwv_flow_imp.g_varchar2_table(253) := '2766612D272929207B0D0A2020202020202020202069636F6E537472696E67203D202766612027202B2069636F6E3B0D0A20202020202020207D20656C7365206966202869636F6E2E73746172747357697468282769636F6E2D272929207B0D0A202020';
wwv_flow_imp.g_varchar2_table(254) := '2020202020202069636F6E537472696E67203D2027612D49636F6E2027202B2069636F6E3B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202069636F6E537472696E67203D2027612D49636F6E2069636F6E2D73656172636827';
wwv_flow_imp.g_varchar2_table(255) := '3B0D0A20202020202020207D0D0A0D0A20202020202020202F2F20697320697420612073746174696320656E747279206F7220612064796E616D69632073656172636820726573756C740D0A20202020202020206966202873746174696329207B0D0A20';
wwv_flow_imp.g_varchar2_table(256) := '202020202020202020696E64657854797065203D2027535441544943273B0D0A20202020202020207D20656C7365207B0D0A20202020202020202020696E64657854797065203D202744594E414D4943273B0D0A20202020202020207D0D0A0D0A202020';
wwv_flow_imp.g_varchar2_table(257) := '20202020206966202869636F6E436F6C6F7229207B0D0A2020202020202020202069636F6E436F6C6F72537472696E67203D20277374796C653D226261636B67726F756E642D636F6C6F723A27202B2069636F6E436F6C6F72202B202722273B0D0A2020';
wwv_flow_imp.g_varchar2_table(258) := '2020202020207D0D0A0D0A20202020202020206F7574203D20273C6C6920636C6173733D227064742D6170782D53706F746C696768742D726573756C742027202B206170657853706F746C696768742E67526573756C744C6973745468656D65436C6173';
wwv_flow_imp.g_varchar2_table(259) := '73202B2027207064742D6170782D53706F746C696768742D726573756C742D2D70616765207064742D6170782D53706F746C696768742D27202B20696E64657854797065202B2027223E27202B0D0A20202020202020202020273C7370616E20636C6173';
wwv_flow_imp.g_varchar2_table(260) := '733D227064742D6170782D53706F746C696768742D6C696E6B222027202B206461746141747472202B20273E27202B0D0A20202020202020202020273C7370616E20636C6173733D227064742D6170782D53706F746C696768742D69636F6E2027202B20';
wwv_flow_imp.g_varchar2_table(261) := '6170657853706F746C696768742E6749636F6E5468656D65436C617373202B2027222027202B2069636F6E436F6C6F72537472696E67202B202720617269612D68696464656E3D2274727565223E27202B0D0A20202020202020202020273C7370616E20';
wwv_flow_imp.g_varchar2_table(262) := '636C6173733D2227202B2069636F6E537472696E67202B2027223E3C2F7370616E3E27202B0D0A20202020202020202020273C2F7370616E3E27202B0D0A20202020202020202020273C7370616E20636C6173733D227064742D6170782D53706F746C69';
wwv_flow_imp.g_varchar2_table(263) := '6768742D696E666F223E27202B0D0A20202020202020202020273C7370616E20636C6173733D2227202B206170657853706F746C696768742E53505F524553554C545F4C4142454C202B20272220726F6C653D226F7074696F6E223E27202B207469746C';
wwv_flow_imp.g_varchar2_table(264) := '65202B20273C2F7370616E3E27202B0D0A20202020202020202020273C7370616E20636C6173733D227064742D6170782D53706F746C696768742D64657363206D617267696E2D746F702D736D223E27202B2064657363202B20273C2F7370616E3E2720';
wwv_flow_imp.g_varchar2_table(265) := '2B0D0A20202020202020202020273C2F7370616E3E27202B0D0A2020202020202020202073686F72746375744D61726B7570202B0D0A20202020202020202020273C2F7370616E3E27202B0D0A20202020202020202020273C2F6C693E273B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(266) := '2020202020202072657475726E206F75743B0D0A0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A205075736820737461746963206C69737420656E747269657320746F20726573756C747365740D0A202020202020202A20';
wwv_flow_imp.g_varchar2_table(267) := '40706172616D207B61727261797D20726573756C74730D0A202020202020202A2F0D0A202020202020726573756C74734164644F6E733A2066756E6374696F6E2028726573756C747329207B0D0A0D0A20202020202020207661722073686F7274637574';
wwv_flow_imp.g_varchar2_table(268) := '436F756E746572203D20303B0D0A0D0A2020202020202020696620286170657853706F746C696768742E67456E61626C65496E5061676553656172636829207B0D0A20202020202020202020726573756C74732E70757368287B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(269) := '202020206E3A206170657853706F746C696768742E67496E50616765536561726368546578742C0D0A202020202020202020202020753A2027272C0D0A202020202020202020202020693A206170657853706F746C696768742E49434F4E532E70616765';
wwv_flow_imp.g_varchar2_table(270) := '2C0D0A20202020202020202020202069633A206E756C6C2C0D0A202020202020202020202020743A206170657853706F746C696768742E55524C5F54595045532E736561726368506167652C0D0A20202020202020202020202073686F72746375743A20';
wwv_flow_imp.g_varchar2_table(271) := '274374726C202B2031272C0D0A202020202020202020202020733A20747275650D0A202020202020202020207D293B0D0A2020202020202020202073686F7274637574436F756E746572203D2073686F7274637574436F756E746572202B20313B0D0A20';
wwv_flow_imp.g_varchar2_table(272) := '202020202020207D0D0A0D0A2020202020202020666F7220287661722069203D20303B2069203C206170657853706F746C696768742E67537461746963496E6465782E6C656E6774683B20692B2B29207B0D0A2020202020202020202073686F72746375';
wwv_flow_imp.g_varchar2_table(273) := '74436F756E746572203D2073686F7274637574436F756E746572202B20313B0D0A202020202020202020206966202873686F7274637574436F756E746572203E203929207B0D0A202020202020202020202020726573756C74732E70757368287B0D0A20';
wwv_flow_imp.g_varchar2_table(274) := '202020202020202020202020206E3A206170657853706F746C696768742E67537461746963496E6465785B695D2E6E2C0D0A2020202020202020202020202020643A206170657853706F746C696768742E67537461746963496E6465785B695D2E642C0D';
wwv_flow_imp.g_varchar2_table(275) := '0A2020202020202020202020202020753A206170657853706F746C696768742E67537461746963496E6465785B695D2E752C0D0A2020202020202020202020202020693A206170657853706F746C696768742E67537461746963496E6465785B695D2E69';
wwv_flow_imp.g_varchar2_table(276) := '2C0D0A202020202020202020202020202069633A206170657853706F746C696768742E67537461746963496E6465785B695D2E69632C0D0A2020202020202020202020202020743A206170657853706F746C696768742E67537461746963496E6465785B';
wwv_flow_imp.g_varchar2_table(277) := '695D2E742C0D0A2020202020202020202020202020733A206170657853706F746C696768742E67537461746963496E6465785B695D2E730D0A2020202020202020202020207D293B0D0A202020202020202020207D20656C7365207B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(278) := '202020202020726573756C74732E70757368287B0D0A20202020202020202020202020206E3A206170657853706F746C696768742E67537461746963496E6465785B695D2E6E2C0D0A2020202020202020202020202020643A206170657853706F746C69';
wwv_flow_imp.g_varchar2_table(279) := '6768742E67537461746963496E6465785B695D2E642C0D0A2020202020202020202020202020753A206170657853706F746C696768742E67537461746963496E6465785B695D2E752C0D0A2020202020202020202020202020693A206170657853706F74';
wwv_flow_imp.g_varchar2_table(280) := '6C696768742E67537461746963496E6465785B695D2E692C0D0A202020202020202020202020202069633A206170657853706F746C696768742E67537461746963496E6465785B695D2E69632C0D0A2020202020202020202020202020743A2061706578';
wwv_flow_imp.g_varchar2_table(281) := '53706F746C696768742E67537461746963496E6465785B695D2E742C0D0A2020202020202020202020202020733A206170657853706F746C696768742E67537461746963496E6465785B695D2E732C0D0A202020202020202020202020202073686F7274';
wwv_flow_imp.g_varchar2_table(282) := '6375743A20274374726C202B2027202B2073686F7274637574436F756E7465720D0A2020202020202020202020207D293B0D0A202020202020202020207D0D0A20202020202020207D0D0A0D0A202020202020202072657475726E20726573756C74733B';
wwv_flow_imp.g_varchar2_table(283) := '0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20536561726368204E617669676174696F6E0D0A202020202020202A2040706172616D207B61727261797D207061747465726E730D0A202020202020202A2F0D0A20202020';
wwv_flow_imp.g_varchar2_table(284) := '20207365617263684E61763A2066756E6374696F6E20287061747465726E7329207B0D0A2020202020202020766172206E6176526573756C7473203D205B5D2C0D0A20202020202020202020686173526573756C7473203D2066616C73652C0D0A202020';
wwv_flow_imp.g_varchar2_table(285) := '202020202020207061747465726E2C0D0A202020202020202020207061747465726E4C656E677468203D207061747465726E732E6C656E6774682C0D0A20202020202020202020692C0D0A2020202020202020202073656172636856616C7565203D2024';
wwv_flow_imp.g_varchar2_table(286) := '286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C28292E7472696D28292C0D0A2020202020202020202061707046696C746572203D20273A27202B20617065782E6974656D282752';
wwv_flow_imp.g_varchar2_table(287) := '305F53504F544C494748545F46494C54455227292E67657456616C75652829202B20273A273B0D0A0D0A2020202020202020766172206E6172726F776564536574203D2066756E6374696F6E202829207B0D0A2020202020202020202072657475726E20';
wwv_flow_imp.g_varchar2_table(288) := '686173526573756C7473203F206E6176526573756C7473203A206170657853706F746C696768742E67536561726368496E6465783B0D0A20202020202020207D3B0D0A0D0A20202020202020207661722067657453636F7265203D2066756E6374696F6E';
wwv_flow_imp.g_varchar2_table(289) := '2028706F732C20776F726473436F756E742C2066756C6C54787429207B0D0A202020202020202020207661722073636F7265203D203130302C0D0A202020202020202020202020737061636573203D20776F726473436F756E74202D20312C0D0A202020';
wwv_flow_imp.g_varchar2_table(290) := '202020202020202020706F736974696F6E4F6657686F6C654B6579776F7264733B0D0A0D0A2020202020202020202069662028706F73203D3D3D203020262620737061636573203D3D3D203029207B0D0A2020202020202020202020202F2F2070657266';
wwv_flow_imp.g_varchar2_table(291) := '656374206D617463682028206D6174636865642066726F6D20746865206669727374206C65747465722077697468206E6F20737061636520290D0A20202020202020202020202072657475726E2073636F72653B0D0A202020202020202020207D20656C';
wwv_flow_imp.g_varchar2_table(292) := '7365207B0D0A2020202020202020202020202F2F207768656E20736561726368202773716C2063272C202753514C20436F6D6D616E6473272073686F756C642073636F726520686967686572207468616E202753514C2053637269707473270D0A202020';
wwv_flow_imp.g_varchar2_table(293) := '2020202020202020202F2F207768656E207365617263682027736372697074272C202753637269707420506C616E6E6572272073686F756C642073636F726520686967686572207468616E202753514C2053637269707473270D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(294) := '202020706F736974696F6E4F6657686F6C654B6579776F726473203D2066756C6C5478742E696E6465784F66286170657853706F746C696768742E674B6579776F726473293B0D0A20202020202020202020202069662028706F736974696F6E4F665768';
wwv_flow_imp.g_varchar2_table(295) := '6F6C654B6579776F726473203D3D3D202D3129207B0D0A202020202020202020202020202073636F7265203D2073636F7265202D20706F73202D20737061636573202D20776F726473436F756E743B0D0A2020202020202020202020207D20656C736520';
wwv_flow_imp.g_varchar2_table(296) := '7B0D0A202020202020202020202020202073636F7265203D2073636F7265202D20706F736974696F6E4F6657686F6C654B6579776F7264733B0D0A2020202020202020202020207D0D0A202020202020202020207D0D0A0D0A2020202020202020202072';
wwv_flow_imp.g_varchar2_table(297) := '657475726E2073636F72653B0D0A20202020202020207D3B0D0A0D0A2020202020202020666F72202869203D20303B2069203C207061747465726E732E6C656E6774683B20692B2B29207B0D0A202020202020202020207061747465726E203D20706174';
wwv_flow_imp.g_varchar2_table(298) := '7465726E735B695D3B0D0A0D0A202020202020202020206E6176526573756C7473203D206E6172726F77656453657428290D0A2020202020202020202020202E66696C7465722866756E6374696F6E2028656C656D2C20696E64657829207B0D0A202020';
wwv_flow_imp.g_varchar2_table(299) := '2020202020202020202020766172206E616D65203D20656C656D2E6E2E746F4C6F7765724361736528292C0D0A2020202020202020202020202020202063617465676F7279203D20656C656D2E632C0D0A20202020202020202020202020202020657861';
wwv_flow_imp.g_varchar2_table(300) := '6374203D20656C656D2E782C0D0A20202020202020202020202020202020776F726473436F756E74203D206E616D652E73706C697428272027292E6C656E6774682C0D0A20202020202020202020202020202020706F736974696F6E203D206E616D652E';
wwv_flow_imp.g_varchar2_table(301) := '736561726368287061747465726E293B0D0A0D0A20202020202020202020202020206966202873656172636856616C7565203D3D20657861637429207B0D0A202020202020202020202020202020202F2F20557365722073656172636820666F72206578';
wwv_flow_imp.g_varchar2_table(302) := '61637420706167650D0A2020202020202020202020202020202072657475726E20747275653B0D0A20202020202020202020202020207D0D0A0D0A2020202020202020202020202020696620287061747465726E4C656E677468203E20776F726473436F';
wwv_flow_imp.g_varchar2_table(303) := '756E7429207B0D0A202020202020202020202020202020202F2F206B6579776F72647320636F6E7461696E73206D6F726520776F726473207468616E20737472696E6720746F2062652073656172636865640D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(304) := '72657475726E2066616C73653B0D0A20202020202020202020202020207D0D0A0D0A20202020202020202020202020202F2F20436865636B206966207061676520696E20636F72726563742063617465676F72790D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(305) := '696620282163617465676F72792E696E636C756465732861707046696C7465722929207B0D0A2020202020202020202020202020202072657475726E2066616C73653B0D0A20202020202020202020202020207D0D0A0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(306) := '202069662028706F736974696F6E203E202D3129207B0D0A20202020202020202020202020202020656C656D2E73636F7265203D2067657453636F726528706F736974696F6E2C20776F726473436F756E742C206E616D65293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(307) := '20202020202020206966202861706578290D0A20202020202020202020202020202020202072657475726E20747275653B0D0A20202020202020202020202020207D20656C73652069662028656C656D2E7429207B202F2F20746F6B656E73202873686F';
wwv_flow_imp.g_varchar2_table(308) := '7274206465736372697074696F6E20666F72206E617620656E74726965732E290D0A2020202020202020202020202020202069662028656C656D2E742E736561726368287061747465726E29203E202D3129207B0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(309) := '20202020656C656D2E73636F7265203D20313B0D0A20202020202020202020202020202020202072657475726E20747275653B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020207D0D0A0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(310) := '2020207D290D0A2020202020202020202020202E736F72742866756E6374696F6E2028612C206229207B0D0A202020202020202020202020202072657475726E20622E73636F7265202D20612E73636F72653B0D0A2020202020202020202020207D293B';
wwv_flow_imp.g_varchar2_table(311) := '0D0A0D0A20202020202020202020686173526573756C7473203D20747275653B0D0A20202020202020207D0D0A0D0A202020202020202076617220666F726D61744E6176526573756C7473203D2066756E6374696F6E202872657329207B0D0A20202020';
wwv_flow_imp.g_varchar2_table(312) := '202020202020766172206F7574203D2027272C0D0A202020202020202020202020692C0D0A2020202020202020202020206974656D2C0D0A202020202020202020202020747970652C0D0A20202020202020202020202073686F72746375742C0D0A2020';
wwv_flow_imp.g_varchar2_table(313) := '2020202020202020202069636F6E2C0D0A20202020202020202020202069636F6E436F6C6F722C0D0A2020202020202020202020207374617469632C0D0A202020202020202020202020656E747279203D207B7D3B0D0A0D0A2020202020202020202069';
wwv_flow_imp.g_varchar2_table(314) := '6620287265732E6C656E677468203E206170657853706F746C696768742E674D61784E6176526573756C7429207B0D0A2020202020202020202020207265732E6C656E677468203D206170657853706F746C696768742E674D61784E6176526573756C74';
wwv_flow_imp.g_varchar2_table(315) := '3B0D0A202020202020202020207D0D0A0D0A20202020202020202020666F72202869203D20303B2069203C207265732E6C656E6774683B20692B2B29207B0D0A2020202020202020202020206974656D203D207265735B695D3B0D0A0D0A202020202020';
wwv_flow_imp.g_varchar2_table(316) := '20202020202073686F7274637574203D206974656D2E73686F72746375746C696E6B3B20202F2F6974656D2E73686F72746375743B0D0A20202020202020202020202074797065203D206974656D2E74207C7C206170657853706F746C696768742E5552';
wwv_flow_imp.g_varchar2_table(317) := '4C5F54595045532E72656469726563743B0D0A20202020202020202020202069636F6E203D206974656D2E69207C7C206170657853706F746C696768742E49434F4E532E7365617263683B0D0A202020202020202020202020737461746963203D206974';
wwv_flow_imp.g_varchar2_table(318) := '656D2E73207C7C2066616C73653B0D0A202020202020202020202020696620286974656D2E696320213D3D202744454641554C542729207B0D0A202020202020202020202020202069636F6E436F6C6F72203D206974656D2E69633B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(319) := '2020202020207D0D0A0D0A202020202020202020202020656E747279203D207B0D0A20202020202020202020202020207469746C653A206974656D2E6E2C0D0A2020202020202020202020202020646573633A206974656D2E642C0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(320) := '2020202020202075726C3A206974656D2E752C0D0A202020202020202020202020202069636F6E3A2069636F6E2C0D0A202020202020202020202020202069636F6E436F6C6F723A2069636F6E436F6C6F722C0D0A202020202020202020202020202074';
wwv_flow_imp.g_varchar2_table(321) := '7970653A20747970652C0D0A20202020202020202020202020207374617469633A207374617469630D0A2020202020202020202020207D3B0D0A0D0A2020202020202020202020206966202873686F727463757429207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(322) := '202020656E7472792E73686F7274637574203D2073686F72746375743B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020206F7574203D206F7574202B206170657853706F746C696768742E6765744D61726B757028656E7472';
wwv_flow_imp.g_varchar2_table(323) := '79293B0D0A202020202020202020207D0D0A2020202020202020202072657475726E206F75743B0D0A20202020202020207D3B0D0A202020202020202072657475726E20666F726D61744E6176526573756C7473286170657853706F746C696768742E72';
wwv_flow_imp.g_varchar2_table(324) := '6573756C74734164644F6E73286E6176526573756C747329293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A205365617263680D0A202020202020202A2040706172616D207B737472696E677D206B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(325) := '202A2F0D0A2020202020207365617263683A2066756E6374696F6E20286B29207B0D0A2020202020202020766172205052454649585F454E545259203D20277064742D73702D726573756C742D273B0D0A20202020202020202F2F2073746F7265206B65';
wwv_flow_imp.g_varchar2_table(326) := '79776F7264730D0A20202020202020206170657853706F746C696768742E674B6579776F726473203D206B2E7472696D28293B0D0A0D0A202020202020202076617220776F726473203D206170657853706F746C696768742E674B6579776F7264732E73';
wwv_flow_imp.g_varchar2_table(327) := '706C697428272027292C0D0A2020202020202020202072657324203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0D0A202020202020202020207061747465726E73203D20';
wwv_flow_imp.g_varchar2_table(328) := '5B5D2C0D0A202020202020202020206E61764F757075742C0D0A20202020202020202020693B0D0A2020202020202020666F72202869203D20303B2069203C20776F7264732E6C656E6774683B20692B2B29207B0D0A202020202020202020202F2F2073';
wwv_flow_imp.g_varchar2_table(329) := '746F7265206B65797320696E20617272617920746F20737570706F727420737061636520696E206B6579776F72647320666F72206E617669676174696F6E20656E74726965732C0D0A202020202020202020202F2F20652E672E20277374612066272066';
wwv_flow_imp.g_varchar2_table(330) := '696E64732027537461746963204170706C69636174696F6E2046696C6573270D0A202020202020202020202F2F207061747465726E732E70757368286E65772052656745787028617065782E7574696C2E65736361706552656745787028776F7264735B';
wwv_flow_imp.g_varchar2_table(331) := '695D292C202767692729293B0D0A0D0A202020202020202020202F2F204D4D203A205468697320636F64652075736573206E65676174697665206C6F6F6B626568696E6420283F3C212E2E2E29200D0A202020202020202020202F2F20616E64206E6567';
wwv_flow_imp.g_varchar2_table(332) := '6174697665206C6F6F6B616865616420283F215B5E3C5D2A3F3E2920746F206578636C756465206D6174636865732074686174206F6363757220696E736964652048544D4C20746167732E0D0A202020202020202020207061747465726E732E70757368';
wwv_flow_imp.g_varchar2_table(333) := '28206E657720526567457870280D0A20202020202020202020202022283F3C213C2F3F5B612D7A5D5B5E3E5D2A3F3E292822202B20617065782E7574696C2E65736361706552656745787028776F7264735B695D29202B202229283F215B5E3C5D2A3F3E';
wwv_flow_imp.g_varchar2_table(334) := '29222C0D0A202020202020202020202020226769220D0A2020202020202020202029293B0D0A202020202020202020200D0A20202020202020207D0D0A0D0A20202020202020206E61764F75707574203D206170657853706F746C696768742E73656172';
wwv_flow_imp.g_varchar2_table(335) := '63684E6176287061747465726E73293B0D0A0D0A20202020202020202428272327202B206170657853706F746C696768742E53505F4C495354290D0A202020202020202020202E68746D6C286E61764F75707574290D0A202020202020202020202E6669';
wwv_flow_imp.g_varchar2_table(336) := '6E6428276C6927290D0A202020202020202020202E656163682866756E6374696F6E20286929207B0D0A202020202020202020202020766172207468617424203D20242874686973293B0D0A20202020202020202020202074686174240D0A2020202020';
wwv_flow_imp.g_varchar2_table(337) := '2020202020202020202E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C545F4C4142454C290D0A20202020202020202020202020202E6174747228276964272C205052454649585F';
wwv_flow_imp.g_varchar2_table(338) := '454E545259202B2069293B202F2F20666F72206163636573736962696C6974790D0A202020202020202020207D290D0A202020202020202020202E666972737428290D0A202020202020202020202E616464436C617373286170657853706F746C696768';
wwv_flow_imp.g_varchar2_table(339) := '742E53505F414354495645293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A2043726561746573207468652073706F746C69676874206469616C6F67206D61726B75700D0A202020202020202A2040706172616D207B73';
wwv_flow_imp.g_varchar2_table(340) := '7472696E677D2070506C616365486F6C6465720D0A202020202020202A2F0D0A20202020202063726561746553706F746C696768744469616C6F673A2066756E6374696F6E202870506C616365486F6C64657229207B0D0A202020202020202076617220';
wwv_flow_imp.g_varchar2_table(341) := '6372656174654469616C6F67203D2066756E6374696F6E202829207B0D0A2020202020202020202076617220766965774865696768742C0D0A2020202020202020202020206C696E654865696768742C0D0A20202020202020202020202076696577546F';
wwv_flow_imp.g_varchar2_table(342) := '702C0D0A202020202020202020202020726F7773506572566965773B0D0A0D0A2020202020202020202076617220696E697448656967687473203D2066756E6374696F6E202829207B0D0A2020202020202020202020206966202824286170657853706F';
wwv_flow_imp.g_varchar2_table(343) := '746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6C656E677468203E203029207B0D0A20202020202020202020202020207661722076696577546F7024203D202428276469762E7064742D6170782D53706F';
wwv_flow_imp.g_varchar2_table(344) := '746C696768742D726573756C747327293B0D0A202020202020202020202020202076696577486569676874203D2076696577546F70242E6F7574657248656967687428293B0D0A20202020202020202020202020206C696E65486569676874203D202428';
wwv_flow_imp.g_varchar2_table(345) := '276C692E7064742D6170782D53706F746C696768742D726573756C7427292E6F7574657248656967687428293B0D0A202020202020202020202020202076696577546F70203D2076696577546F70242E6F666673657428292E746F703B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(346) := '202020202020202020726F777350657256696577203D202876696577486569676874202F206C696E65486569676874293B0D0A2020202020202020202020207D0D0A202020202020202020207D3B0D0A0D0A20202020202020202020766172207363726F';
wwv_flow_imp.g_varchar2_table(347) := '6C6C6564446F776E4F75744F6656696577203D2066756E6374696F6E2028656C656D2429207B0D0A20202020202020202020202069662028656C656D245B305D29207B0D0A202020202020202020202020202076617220746F70203D20656C656D242E6F';
wwv_flow_imp.g_varchar2_table(348) := '666673657428292E746F703B0D0A202020202020202020202020202069662028746F70203C203029207B0D0A2020202020202020202020202020202072657475726E20747275653B202F2F207363726F6C6C2062617220776173207573656420746F2067';
wwv_flow_imp.g_varchar2_table(349) := '657420616374697665206974656D206F7574206F6620766965770D0A20202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202072657475726E20746F70203E20766965774865696768743B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(350) := '20202020202020207D0D0A2020202020202020202020207D0D0A202020202020202020207D3B0D0A0D0A20202020202020202020766172207363726F6C6C656455704F75744F6656696577203D2066756E6374696F6E2028656C656D2429207B0D0A2020';
wwv_flow_imp.g_varchar2_table(351) := '2020202020202020202069662028656C656D245B305D29207B0D0A202020202020202020202020202076617220746F70203D20656C656D242E6F666673657428292E746F703B0D0A202020202020202020202020202069662028746F70203E2076696577';
wwv_flow_imp.g_varchar2_table(352) := '48656967687429207B0D0A2020202020202020202020202020202072657475726E20747275653B202F2F207363726F6C6C2062617220776173207573656420746F2067657420616374697665206974656D206F7574206F6620766965770D0A2020202020';
wwv_flow_imp.g_varchar2_table(353) := '2020202020202020207D20656C7365207B0D0A2020202020202020202020202020202072657475726E20746F70203C3D2076696577546F703B0D0A20202020202020202020202020207D0D0A2020202020202020202020207D0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(354) := '207D3B0D0A0D0A202020202020202020202F2F206B6579626F61726420555020616E6420444F574E20737570706F727420746F20676F207468726F75676820726573756C74730D0A20202020202020202020766172206765744E657874203D2066756E63';
wwv_flow_imp.g_varchar2_table(355) := '74696F6E20287265732429207B0D0A2020202020202020202020207661722063757272656E7424203D20726573242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645292C0D0A20';
wwv_flow_imp.g_varchar2_table(356) := '2020202020202020202020202073657175656E6365203D2063757272656E74242E696E64657828292C0D0A20202020202020202020202020206E657874243B0D0A2020202020202020202020206966202821726F77735065725669657729207B0D0A2020';
wwv_flow_imp.g_varchar2_table(357) := '202020202020202020202020696E69744865696768747328293B0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020696620282163757272656E74242E6C656E677468207C7C2063757272656E74242E697328273A6C6173742D';
wwv_flow_imp.g_varchar2_table(358) := '6368696C64272929207B0D0A20202020202020202020202020202F2F2048697420626F74746F6D2C207363726F6C6C20746F20746F700D0A202020202020202020202020202063757272656E74242E72656D6F7665436C617373286170657853706F746C';
wwv_flow_imp.g_varchar2_table(359) := '696768742E53505F414354495645293B0D0A2020202020202020202020202020726573242E66696E6428276C6927292E666972737428292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(360) := '202020202020726573242E616E696D617465287B0D0A202020202020202020202020202020207363726F6C6C546F703A20300D0A20202020202020202020202020207D293B0D0A2020202020202020202020207D20656C7365207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(361) := '202020202020206E65787424203D2063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E6E65787428292E616464436C617373286170657853706F746C696768742E53505F414354495645';
wwv_flow_imp.g_varchar2_table(362) := '293B0D0A2020202020202020202020202020696620287363726F6C6C6564446F776E4F75744F6656696577286E657874242929207B0D0A20202020202020202020202020202020726573242E616E696D617465287B0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(363) := '20202020207363726F6C6C546F703A202873657175656E6365202D20726F777350657256696577202B203229202A206C696E654865696768740D0A202020202020202020202020202020207D2C2030293B0D0A20202020202020202020202020207D0D0A';
wwv_flow_imp.g_varchar2_table(364) := '2020202020202020202020207D0D0A202020202020202020207D3B0D0A0D0A202020202020202020207661722067657450726576203D2066756E6374696F6E20287265732429207B0D0A2020202020202020202020207661722063757272656E7424203D';
wwv_flow_imp.g_varchar2_table(365) := '20726573242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645292C0D0A202020202020202020202020202073657175656E6365203D2063757272656E74242E696E64657828292C';
wwv_flow_imp.g_varchar2_table(366) := '0D0A202020202020202020202020202070726576243B0D0A0D0A2020202020202020202020206966202821726F77735065725669657729207B0D0A2020202020202020202020202020696E69744865696768747328293B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(367) := '207D0D0A0D0A2020202020202020202020206966202821726573242E6C656E677468207C7C2063757272656E74242E697328273A66697273742D6368696C64272929207B0D0A20202020202020202020202020202F2F2048697420746F702C207363726F';
wwv_flow_imp.g_varchar2_table(368) := '6C6C20746F20626F74746F6D0D0A202020202020202020202020202063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645293B0D0A2020202020202020202020202020726573242E66696E6428';
wwv_flow_imp.g_varchar2_table(369) := '276C6927292E6C61737428292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0D0A2020202020202020202020202020726573242E616E696D617465287B0D0A202020202020202020202020202020207363726F6C';
wwv_flow_imp.g_varchar2_table(370) := '6C546F703A20726573242E66696E6428276C6927292E6C656E677468202A206C696E654865696768740D0A20202020202020202020202020207D293B0D0A2020202020202020202020207D20656C7365207B0D0A20202020202020202020202020207072';
wwv_flow_imp.g_varchar2_table(371) := '657624203D2063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E7072657628292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(372) := '202020202020202020696620287363726F6C6C656455704F75744F66566965772870726576242929207B0D0A20202020202020202020202020202020726573242E616E696D617465287B0D0A2020202020202020202020202020202020207363726F6C6C';
wwv_flow_imp.g_varchar2_table(373) := '546F703A202873657175656E6365202D203129202A206C696E654865696768740D0A202020202020202020202020202020207D2C2030293B0D0A20202020202020202020202020207D0D0A2020202020202020202020207D0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(374) := '7D3B0D0A0D0A20202020202020202020242877696E646F77292E6F6E28276170657877696E646F77726573697A6564272C2066756E6374696F6E202829207B0D0A202020202020202020202020696E69744865696768747328293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(375) := '2020207D293B0D0A0D0A0D0A202020202020202020207661722073706F746C69676874526164696F46696C746572203D0D0A202020202020202020202020273C64697620636C6173733D22636F6E7461696E6572223E27202B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(376) := '202020273C64697620636C6173733D22726F7720223E27202B0D0A202020202020202020202020273C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F20636F6C2D737461727420636F6C2D656E64223E3C646976';
wwv_flow_imp.g_varchar2_table(377) := '20636C6173733D22742D466F726D2D6669656C64436F6E7461696E657220742D466F726D2D6669656C64436F6E7461696E65722D2D666C6F6174696E674C6162656C20742D466F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E70';
wwv_flow_imp.g_varchar2_table(378) := '75747320742D466F726D2D6669656C64436F6E7461696E65722D2D726164696F427574746F6E47726F757020617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D726164696F67726F757020222069643D225230';
wwv_flow_imp.g_varchar2_table(379) := '5F53504F544C494748545F46494C5445525F434F4E5441494E4552223E3C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E6572223E27202B0D0A202020202020202020202020273C2F6469763E3C64697620636C6173733D22';
wwv_flow_imp.g_varchar2_table(380) := '742D466F726D2D696E707574436F6E7461696E65722070616464696E672D6E6F6E65223E3C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C64697620746162696E6465783D222D31222069643D2252305F53504F544C49';
wwv_flow_imp.g_varchar2_table(381) := '4748545F46494C5445522220617269612D6C6162656C6C656462793D2252305F53504F544C494748545F46494C5445525F4C4142454C2220636C6173733D22726164696F5F67726F757020617065782D6974656D2D67726F757020617065782D6974656D';
wwv_flow_imp.g_varchar2_table(382) := '2D67726F75702D2D726320617065782D6974656D2D726164696F206D617267696E2D746F702D6E6F6E65207064742D72657665616C65722D69676E6F72652220726F6C653D2267726F7570223E27202B0D0A202020202020202020202020273C64697620';
wwv_flow_imp.g_varchar2_table(383) := '636C6173733D22617065782D6974656D2D6772696420726164696F5F67726F7570223E27202B0D0A202020202020202020202020273C64697620636C6173733D22617065782D6974656D2D677269642D726F77223E27202B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(384) := '2020273C64697620636C6173733D22617065782D6974656D2D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2252305F53504F544C494748545F46494C5445525F3022206E616D653D2252305F53504F544C494748545F46';
wwv_flow_imp.g_varchar2_table(385) := '494C5445522220646174612D646973706C61793D225468697320417070222076616C75653D224150502220636865636B65643D22636865636B6564223E3C6C6162656C20636C6173733D22752D726164696F2070616464696E672D746F702D6E6F6E6520';
wwv_flow_imp.g_varchar2_table(386) := '70616464696E672D626F74746F6D2D6E6F6E65207064742D7370742D6C626C2220666F723D2252305F53504F544C494748545F46494C5445525F30223E54686973204170703C2F6C6162656C3E3C2F6469763E27202B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(387) := '273C64697620636C6173733D22617065782D6974656D2D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2252305F53504F544C494748545F46494C5445525F3122206E616D653D2252305F53504F544C494748545F46494C';
wwv_flow_imp.g_varchar2_table(388) := '5445522220646174612D646973706C61793D22576F726B73706163652041707073222076616C75653D225753223E3C6C6162656C20636C6173733D22752D726164696F2070616464696E672D746F702D6E6F6E652070616464696E672D626F74746F6D2D';
wwv_flow_imp.g_varchar2_table(389) := '6E6F6E65207064742D7370742D6C626C2220666F723D2252305F53504F544C494748545F46494C5445525F31223E576F726B737061636520417070733C2F6C6162656C3E3C2F6469763E27202B0D0A202020202020202020202020273C64697620636C61';
wwv_flow_imp.g_varchar2_table(390) := '73733D22617065782D6974656D2D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2252305F53504F544C494748545F46494C5445525F3222206E616D653D2252305F53504F544C494748545F46494C544552222064617461';
wwv_flow_imp.g_varchar2_table(391) := '2D646973706C61793D224170706C69636174696F6E2047726F7570222076616C75653D224147223E3C6C6162656C20636C6173733D22752D726164696F2070616464696E672D746F702D6E6F6E652070616464696E672D626F74746F6D2D6E6F6E652070';
wwv_flow_imp.g_varchar2_table(392) := '64742D7370742D6C626C2220666F723D2252305F53504F544C494748545F46494C5445525F32223E47726F75703A2025303C2F6C6162656C3E3C2F6469763E27202B0D0A202020202020202020202020273C2F6469763E3C2F6469763E3C2F6469763E27';
wwv_flow_imp.g_varchar2_table(393) := '202B0D0A202020202020202020202020273C2F6469763E3C7370616E2069643D2252305F53504F544C494748545F46494C5445525F6572726F725F706C616365686F6C6465722220636C6173733D22612D466F726D2D6572726F722220646174612D7465';
wwv_flow_imp.g_varchar2_table(394) := '6D706C6174652D69643D22223E3C2F7370616E3E3C2F6469763E3C2F6469763E3C2F6469763E27202B0D0A202020202020202020202020273C2F6469763E27202B0D0A202020202020202020202020273C2F6469763E273B0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(395) := '202066756E6374696F6E20656C6C6973707365735472696D287374722C206C696D697429207B0D0A202020202020202020202020696620287374722E6C656E677468203C3D206C696D697429207B0D0A202020202020202020202020202072657475726E';
wwv_flow_imp.g_varchar2_table(396) := '207374723B0D0A2020202020202020202020207D20656C7365207B0D0A202020202020202020202020202072657475726E207374722E73756273747228302C206C696D6974202D203329202B20272E2E2E273B0D0A2020202020202020202020207D0D0A';
wwv_flow_imp.g_varchar2_table(397) := '202020202020202020207D0D0A2020202020202020202073706F746C69676874526164696F46696C746572203D20617065782E6C616E672E666F726D61744E6F4573636170652873706F746C69676874526164696F46696C7465722C20656C6C69737073';
wwv_flow_imp.g_varchar2_table(398) := '65735472696D287064742E6F70742E6170706C69636174696F6E47726F75704E616D652C20343029293B0D0A0D0A20202020202020202020242827626F647927290D0A2020202020202020202020202E617070656E64280D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(399) := '202020273C64697620636C6173733D2227202B206170657853706F746C696768742E53505F4449414C4F47202B20272220646174612D69643D2227202B206170657853706F746C696768742E6744796E616D6963416374696F6E4964202B2027223E2720';
wwv_flow_imp.g_varchar2_table(400) := '2B0D0A2020202020202020202020202020273C64697620636C6173733D227064742D6170782D53706F746C696768742D626F6479223E27202B0D0A2020202020202020202020202020273C64697620636C6173733D227064742D6170782D53706F746C69';
wwv_flow_imp.g_varchar2_table(401) := '6768742D686561646572223E27202B2073706F746C69676874526164696F46696C746572202B20273C2F6469763E27202B0D0A2020202020202020202020202020273C64697620636C6173733D227064742D6170782D53706F746C696768742D73656172';
wwv_flow_imp.g_varchar2_table(402) := '6368223E27202B0D0A2020202020202020202020202020273C64697620636C6173733D227064742D6170782D53706F746C696768742D69636F6E207064742D6170782D53706F746C696768742D69636F6E2D6D61696E223E27202B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(403) := '20202020202020273C7370616E20636C6173733D2227202B206170657853706F746C696768742E67506C616365486F6C64657249636F6E202B20272220617269612D68696464656E3D2274727565223E3C2F7370616E3E27202B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(404) := '202020202020273C2F6469763E27202B0D0A2020202020202020202020202020273C64697620636C6173733D227064742D6170782D53706F746C696768742D6669656C64223E27202B0D0A2020202020202020202020202020273C696E70757420747970';
wwv_flow_imp.g_varchar2_table(405) := '653D22746578742220726F6C653D22636F6D626F626F782220617269612D657870616E6465643D2266616C73652220617269612D6175746F636F6D706C6574653D226E6F6E652220617269612D686173706F7075703D22747275652220617269612D6C61';
wwv_flow_imp.g_varchar2_table(406) := '62656C3D2253706F746C69676874205365617263682220617269612D6F776E733D2227202B206170657853706F746C696768742E53505F4C495354202B202722206175746F636F6D706C6574653D226F666622206175746F636F72726563743D226F6666';
wwv_flow_imp.g_varchar2_table(407) := '22207370656C6C636865636B3D2266616C73652220636C6173733D2227202B206170657853706F746C696768742E53505F494E505554202B20272220706C616365686F6C6465723D2227202B2070506C616365486F6C646572202B2027223E27202B0D0A';
wwv_flow_imp.g_varchar2_table(408) := '2020202020202020202020202020273C2F6469763E27202B0D0A2020202020202020202020202020273C64697620726F6C653D22726567696F6E2220636C6173733D22752D56697375616C6C7948696464656E2220617269612D6C6976653D22706F6C69';
wwv_flow_imp.g_varchar2_table(409) := '7465222069643D2227202B206170657853706F746C696768742E53505F4C4956455F524547494F4E202B2027223E3C2F6469763E27202B0D0A2020202020202020202020202020273C2F6469763E27202B0D0A2020202020202020202020202020273C64';
wwv_flow_imp.g_varchar2_table(410) := '697620636C6173733D2227202B206170657853706F746C696768742E53505F524553554C5453202B2027223E27202B0D0A2020202020202020202020202020273C756C20636C6173733D227064742D6170782D53706F746C696768742D726573756C7473';
wwv_flow_imp.g_varchar2_table(411) := '4C697374222069643D2227202B206170657853706F746C696768742E53505F4C495354202B20272220746162696E6465783D222D312220726F6C653D226C697374626F78223E3C2F756C3E27202B0D0A2020202020202020202020202020273C2F646976';
wwv_flow_imp.g_varchar2_table(412) := '3E27202B0D0A2020202020202020202020202020273C2F6469763E27202B0D0A2020202020202020202020202020273C2F6469763E270D0A202020202020202020202020290D0A2020202020202020202020202E6F6E2827696E707574272C2061706578';
wwv_flow_imp.g_varchar2_table(413) := '53706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E5055542C2066756E6374696F6E202829207B0D0A20202020202020202020202020207661722076203D20242874686973292E76616C28292E7472696D28292C0D0A';
wwv_flow_imp.g_varchar2_table(414) := '202020202020202020202020202020206C656E203D20762E6C656E6774683B0D0A0D0A2020202020202020202020202020696620286C656E203D3D3D203029207B0D0A202020202020202020202020202020206170657853706F746C696768742E726573';
wwv_flow_imp.g_varchar2_table(415) := '657453706F746C6967687428293B202F2F20636C656172732065766572797468696E67207768656E206B6579776F72642069732072656D6F7665642E0D0A20202020202020202020202020207D20656C736520696620286C656E203E3D2031207C7C2021';
wwv_flow_imp.g_varchar2_table(416) := '69734E614E28762929207B0D0A202020202020202020202020202020202F2F20736561726368207265717569726573206D6F7265207468616E2030206368617261637465722C206F722069742069732061206E756D6265722E0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(417) := '20202020202020696620287620213D3D206170657853706F746C696768742E674B6579776F72647329207B0D0A2020202020202020202020202020202020206170657853706F746C696768742E7365617263682876293B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(418) := '20202020207D0D0A20202020202020202020202020207D0D0A2020202020202020202020207D290D0A2020202020202020202020202E6F6E28276368616E6765272C20272352305F53504F544C494748545F46494C544552272C2066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(419) := '286529207B0D0A20202020202020202020202020206170657853706F746C696768742E7365617263682824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C28292E7472696D2829';
wwv_flow_imp.g_varchar2_table(420) := '293B0D0A202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E747269676765722827696E70757427293B0D0A2020202020202020202020207D290D0A20';
wwv_flow_imp.g_varchar2_table(421) := '20202020202020202020202E6F6E28276B6579646F776E272C206170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F472C2066756E6374696F6E20286529207B0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(422) := '2076617220726573756C747324203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0D0A202020202020202020202020202020206C61737439526573756C74732C0D0A202020';
wwv_flow_imp.g_varchar2_table(423) := '2020202020202020202020202073686F72746375744E756D6265723B0D0A0D0A20202020202020202020202020202F2F2075702F646F776E206172726F77730D0A20202020202020202020202020207377697463682028652E776869636829207B0D0A20';
wwv_flow_imp.g_varchar2_table(424) := '20202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E444F574E3A0D0A202020202020202020202020202020202020652E70726576656E7444656661756C7428293B0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(425) := '2020206765744E65787428726573756C747324293B0D0A202020202020202020202020202020202020627265616B3B0D0A0D0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E55503A0D0A20202020';
wwv_flow_imp.g_varchar2_table(426) := '2020202020202020202020202020652E70726576656E7444656661756C7428293B0D0A2020202020202020202020202020202020206765745072657628726573756C747324293B0D0A202020202020202020202020202020202020627265616B3B0D0A0D';
wwv_flow_imp.g_varchar2_table(427) := '0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E454E5445523A0D0A202020202020202020202020202020202020652E70726576656E7444656661756C7428293B202F2F20646F6E2774207375626D';
wwv_flow_imp.g_varchar2_table(428) := '6974206F6E20656E7465720D0A202020202020202020202020202020202020696620286170657853706F746C696768742E67456E61626C65536561726368486973746F727929207B0D0A2020202020202020202020202020202020202020617065785370';
wwv_flow_imp.g_varchar2_table(429) := '6F746C696768742E73657453706F746C69676874486973746F72794C6F63616C53746F726167652824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C2829293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(430) := '202020202020202020202020207D0D0A2020202020202020202020202020202020206170657853706F746C696768742E676F546F28726573756C7473242E66696E6428276C692E69732D616374697665207370616E27292C2065293B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(431) := '202020202020202020202020627265616B3B0D0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E5441423A0D0A2020202020202020202020202020202020206170657853706F746C696768742E636C';
wwv_flow_imp.g_varchar2_table(432) := '6F73654469616C6F6728293B0D0A202020202020202020202020202020202020627265616B3B0D0A20202020202020202020202020207D0D0A0D0A202020202020202020202020202069662028652E6374726C4B657929207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(433) := '202020202020202F2F20737570706F727473204374726C202B20312C20322C20332C20342C20352C20362C20372C20382C20392073686F7274637574730D0A202020202020202020202020202020206C61737439526573756C7473203D20726573756C74';
wwv_flow_imp.g_varchar2_table(434) := '73242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F53484F5254435554292E706172656E7428292E67657428293B0D0A202020202020202020202020202020207377697463682028652E7768';
wwv_flow_imp.g_varchar2_table(435) := '69636829207B0D0A202020202020202020202020202020202020636173652034393A202F2F204374726C202B20310D0A202020202020202020202020202020202020202073686F72746375744E756D626572203D20313B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(436) := '202020202020202020627265616B3B0D0A202020202020202020202020202020202020636173652035303A202F2F204374726C202B20320D0A202020202020202020202020202020202020202073686F72746375744E756D626572203D20323B0D0A2020';
wwv_flow_imp.g_varchar2_table(437) := '202020202020202020202020202020202020627265616B3B0D0A0D0A202020202020202020202020202020202020636173652035313A202F2F204374726C202B20330D0A202020202020202020202020202020202020202073686F72746375744E756D62';
wwv_flow_imp.g_varchar2_table(438) := '6572203D20333B0D0A2020202020202020202020202020202020202020627265616B3B0D0A0D0A202020202020202020202020202020202020636173652035323A202F2F204374726C202B20340D0A202020202020202020202020202020202020202073';
wwv_flow_imp.g_varchar2_table(439) := '686F72746375744E756D626572203D20343B0D0A2020202020202020202020202020202020202020627265616B3B0D0A0D0A202020202020202020202020202020202020636173652035333A202F2F204374726C202B20350D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(440) := '2020202020202020202073686F72746375744E756D626572203D20353B0D0A2020202020202020202020202020202020202020627265616B3B0D0A0D0A202020202020202020202020202020202020636173652035343A202F2F204374726C202B20360D';
wwv_flow_imp.g_varchar2_table(441) := '0A202020202020202020202020202020202020202073686F72746375744E756D626572203D20363B0D0A2020202020202020202020202020202020202020627265616B3B0D0A0D0A202020202020202020202020202020202020636173652035353A202F';
wwv_flow_imp.g_varchar2_table(442) := '2F204374726C202B20370D0A202020202020202020202020202020202020202073686F72746375744E756D626572203D20373B0D0A2020202020202020202020202020202020202020627265616B3B0D0A0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(443) := '20636173652035363A202F2F204374726C202B20380D0A202020202020202020202020202020202020202073686F72746375744E756D626572203D20383B0D0A2020202020202020202020202020202020202020627265616B3B0D0A0D0A202020202020';
wwv_flow_imp.g_varchar2_table(444) := '202020202020202020202020636173652035373A202F2F204374726C202B20390D0A202020202020202020202020202020202020202073686F72746375744E756D626572203D20393B0D0A2020202020202020202020202020202020202020627265616B';
wwv_flow_imp.g_varchar2_table(445) := '3B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020206966202873686F72746375744E756D62657229207B0D0A2020202020202020202020202020202020206170657853706F746C696768742E676F546F28';
wwv_flow_imp.g_varchar2_table(446) := '24286C61737439526573756C74735B73686F72746375744E756D626572202D20315D292C2065293B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020207D0D0A0D0A20202020202020202020202020202F2F20536869';
wwv_flow_imp.g_varchar2_table(447) := '6674202B2054616220746F20636C6F736520616E6420666F63757320676F6573206261636B20746F207768657265206974207761732E0D0A202020202020202020202020202069662028652E73686966744B657929207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(448) := '202020202069662028652E7768696368203D3D3D206170657853706F746C696768742E4B4559532E54414229207B0D0A2020202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(449) := '2020202020202020202020207D0D0A20202020202020202020202020207D0D0A0D0A20202020202020202020202020206170657853706F746C696768742E68616E646C65417269614174747228293B0D0A0D0A2020202020202020202020207D290D0A20';
wwv_flow_imp.g_varchar2_table(450) := '20202020202020202020202E6F6E2827636C69636B272C20277370616E2E7064742D6170782D53706F746C696768742D6C696E6B272C2066756E6374696F6E20286529207B0D0A2020202020202020202020202020696620286170657853706F746C6967';
wwv_flow_imp.g_varchar2_table(451) := '68742E67456E61626C65536561726368486973746F727929207B0D0A202020202020202020202020202020206170657853706F746C696768742E73657453706F746C69676874486973746F72794C6F63616C53746F726167652824286170657853706F74';
wwv_flow_imp.g_varchar2_table(452) := '6C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C2829293B0D0A20202020202020202020202020207D0D0A20202020202020202020202020206170657853706F746C696768742E676F546F282428746869';
wwv_flow_imp.g_varchar2_table(453) := '73292C2065293B0D0A2020202020202020202020207D290D0A2020202020202020202020202E6F6E28276D6F7573656D6F7665272C20276C692E7064742D6170782D53706F746C696768742D726573756C74272C2066756E6374696F6E202829207B0D0A';
wwv_flow_imp.g_varchar2_table(454) := '202020202020202020202020202076617220686967686C6967687424203D20242874686973293B0D0A2020202020202020202020202020686967686C69676874240D0A202020202020202020202020202020202E706172656E7428290D0A202020202020';
wwv_flow_imp.g_varchar2_table(455) := '202020202020202020202E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645290D0A202020202020202020202020202020202E72656D6F7665436C617373286170657853706F746C';
wwv_flow_imp.g_varchar2_table(456) := '696768742E53505F414354495645293B0D0A0D0A2020202020202020202020202020686967686C69676874242E616464436C617373286170657853706F746C696768742E53505F414354495645293B0D0A20202020202020202020202020202F2F206861';
wwv_flow_imp.g_varchar2_table(457) := '6E646C65417269614174747228293B0D0A2020202020202020202020207D290D0A2020202020202020202020202E6F6E2827626C7572272C206170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47';
wwv_flow_imp.g_varchar2_table(458) := '2C2066756E6374696F6E20286529207B0D0A20202020202020202020202020202F2F20646F6E277420646F2074686973206966206469616C6F6720697320636C6F7365642F636C6F73696E670D0A20202020202020202020202020206966202824286170';
wwv_flow_imp.g_varchar2_table(459) := '657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6469616C6F67282269734F70656E222929207B0D0A202020202020202020202020202020202F2F20696E7075742074616B657320666F637573';
wwv_flow_imp.g_varchar2_table(460) := '206469616C6F67206C6F73657320666F63757320746F207363726F6C6C206261720D0A2020202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E666F63';
wwv_flow_imp.g_varchar2_table(461) := '757328293B0D0A20202020202020202020202020207D0D0A2020202020202020202020207D290D0A2020202020202020202020202E6F6E2827636C69636B272C20272E7064742D6170782D53706F746C696768742D696E6C696E652D6C696E6B272C2066';
wwv_flow_imp.g_varchar2_table(462) := '756E6374696F6E20286529207B0D0A20202020202020202020202020202F2F205468616E6B7320436861744750540D0A2020202020202020202020202020636F6E73742075726C203D20746869732E67657441747472696275746528277064742D53706F';
wwv_flow_imp.g_varchar2_table(463) := '746C696E6B2D75726C27293B0D0A20202020202020202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A2020202020202020202020202020617065782E7365727665722E706C7567696E286170657853706F746C696768742E67';
wwv_flow_imp.g_varchar2_table(464) := '416A61784964656E7469666965722C207B0D0A202020202020202020202020202020207830313A20274745545F55524C272C0D0A202020202020202020202020202020207830323A2075726C0D0A20202020202020202020202020207D2C207B0D0A2020';
wwv_flow_imp.g_varchar2_table(465) := '202020202020202020202020202064617461547970653A20276A736F6E272C0D0A20202020202020202020202020202020737563636573733A2066756E6374696F6E20286461746129207B0D0A2020202020202020202020202020202020207064742E75';
wwv_flow_imp.g_varchar2_table(466) := '6E436C6F616B44656275674C6576656C28293B0D0A202020202020202020202020202020202020696620286461746129207B0D0A202020202020202020202020202020202020202076617220707265706172656455726C203D20646174612E75726C3B0D';
wwv_flow_imp.g_varchar2_table(467) := '0A202020202020202020202020202020202020202069662028707265706172656455726C2E7374617274735769746828276A6176617363726970743A272929207B0D0A202020202020202020202020202020202020202020206170657853706F746C6967';
wwv_flow_imp.g_varchar2_table(468) := '68742E636C6F73654469616C6F6728293B0D0A20202020202020202020202020202020202020202020636F6E737420636F6465203D20707265706172656455726C2E736C696365283131293B202F2F2052656D6F766520276A6176617363726970743A27';
wwv_flow_imp.g_varchar2_table(469) := '207072656669780D0A202020202020202020202020202020202020202020206576616C28636F6465293B0D0A20202020202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020202077696E64';
wwv_flow_imp.g_varchar2_table(470) := '6F772E6C6F636174696F6E2E68726566203D20707265706172656455726C3B0D0A20202020202020202020202020202020202020207D0D0A2020202020202020202020202020202020207D0D0A202020202020202020202020202020207D2C0D0A202020';
wwv_flow_imp.g_varchar2_table(471) := '202020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A2020202020202020202020202020202020207064742E756E436C6F616B44656275674C';
wwv_flow_imp.g_varchar2_table(472) := '6576656C28293B0D0A202020202020202020202020202020202020617065782E64656275672E696E666F2822706474206170657853706F746C69676874204745545F55524C222C206572726F725468726F776E293B0D0A0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(473) := '20202020207D0D0A20202020202020202020202020207D293B0D0A0D0A202020202020202020202020202072657475726E2066616C73653B0D0A2020202020202020202020207D293B0D0A0D0A202020202020202020202F2F20457363617065206B6579';
wwv_flow_imp.g_varchar2_table(474) := '2070726573736564206F6E63652C20636C656172206669656C642C2074776963652C20636C6F7365206469616C6F672E0D0A2020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F44';
wwv_flow_imp.g_varchar2_table(475) := '49414C4F47292E6F6E28276B6579646F776E272C2066756E6374696F6E20286529207B0D0A20202020202020202020202076617220696E70757424203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E5350';
wwv_flow_imp.g_varchar2_table(476) := '5F494E505554293B0D0A20202020202020202020202069662028652E7768696368203D3D3D206170657853706F746C696768742E4B4559532E45534341504529207B0D0A202020202020202020202020202069662028696E707574242E76616C28292920';
wwv_flow_imp.g_varchar2_table(477) := '7B0D0A202020202020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0D0A20202020202020202020202020202020652E73746F7050726F7061676174696F6E28293B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(478) := '202020207D20656C7365207B0D0A202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0D0A20202020202020202020202020207D0D0A2020202020202020202020207D0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(479) := '20207D293B0D0A0D0A202020202020202020206170657853706F746C696768742E674861734469616C6F6743726561746564203D20747275653B0D0A20202020202020207D3B0D0A20202020202020206372656174654469616C6F6728293B0D0A202020';
wwv_flow_imp.g_varchar2_table(480) := '2020207D2C0D0A2020202020202F2A2A0D0A202020202020202A204F70656E2053706F746C69676874204469616C6F670D0A202020202020202A2040706172616D207B6F626A6563747D2070466F637573456C656D656E740D0A202020202020202A2F0D';
wwv_flow_imp.g_varchar2_table(481) := '0A2020202020206F70656E53706F746C696768744469616C6F673A2066756E6374696F6E202870466F637573456C656D656E7429207B0D0A20202020202020202F2F2044697361626C652053706F746C6967687420666F72204D6F64616C204469616C6F';
wwv_flow_imp.g_varchar2_table(482) := '670D0A2020202020202020696620282877696E646F772E73656C6620213D3D2077696E646F772E746F702929207B0D0A2020202020202020202072657475726E2066616C73653B0D0A20202020202020207D0D0A0D0A2020202020202020617065785370';
wwv_flow_imp.g_varchar2_table(483) := '6F746C696768742E674861734469616C6F6743726561746564203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6C656E677468203E20303B0D0A0D0A20202020202020202F2F';
wwv_flow_imp.g_varchar2_table(484) := '20696620616C72656164792063726561746564206469616C6F672069732066726F6D20616E6F74686572204441202D2D3E2064657374726F79206578697374696E67206469616C6F670D0A2020202020202020696620286170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(485) := '2E674861734469616C6F674372656174656429207B0D0A202020202020202020206966202824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E617474722827646174612D6964272920';
wwv_flow_imp.g_varchar2_table(486) := '213D206170657853706F746C696768742E6744796E616D6963416374696F6E496429207B0D0A2020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0D0A2020202020202020202020202428617065';
wwv_flow_imp.g_varchar2_table(487) := '7853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E72656D6F766528293B0D0A2020202020202020202020206170657853706F746C696768742E674861734469616C6F6743726561746564203D2066';
wwv_flow_imp.g_varchar2_table(488) := '616C73653B0D0A202020202020202020207D0D0A20202020202020207D0D0A0D0A20202020202020202F2F207365742073656C6563746564207465787420746F2073706F746C6967687420696E7075740D0A202020202020202069662028617065785370';
wwv_flow_imp.g_varchar2_table(489) := '6F746C696768742E67456E61626C6550726566696C6C53656C65637465645465787429207B0D0A202020202020202020206170657853706F746C696768742E73657453656C65637465645465787428293B0D0A20202020202020207D0D0A0D0A20202020';
wwv_flow_imp.g_varchar2_table(490) := '20202020696620286170657853706F746C696768742E67456E61626C6544656661756C745465787429207B0D0A202020202020202020206170657853706F746C696768742E73657453656C656374656454657874286170657853706F746C696768742E64';
wwv_flow_imp.g_varchar2_table(491) := '656661756C7454657874293B0D0A20202020202020202020242827626F647927292E7472696767657228277064742D6170657873706F746C696768742D6765742D6461746127293B202F2F204D4D203A206669786573207768656E207365617263682069';
wwv_flow_imp.g_varchar2_table(492) := '6E7075742C20627574206E6F20726573756C7473200D0A20202020202020207D0D0A0D0A2020202020202020766172206F70656E4469616C6F67203D2066756E6374696F6E202829207B0D0A2020202020202020202076617220646C6724203D20242861';
wwv_flow_imp.g_varchar2_table(493) := '70657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292C0D0A2020202020202020202020207363726F6C6C59203D2077696E646F772E7363726F6C6C59207C7C2077696E646F772E70616765594F66';
wwv_flow_imp.g_varchar2_table(494) := '667365743B0D0A202020202020202020206966202821646C67242E686173436C617373282775692D6469616C6F672D636F6E74656E742729207C7C2021646C67242E6469616C6F67282269734F70656E222929207B0D0A20202020202020202020202064';
wwv_flow_imp.g_varchar2_table(495) := '6C67242E6469616C6F67287B0D0A202020202020202020202020202077696474683A206170657853706F746C696768742E6757696474682C0D0A20202020202020202020202020206865696768743A20276175746F272C0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(496) := '2020206D6F64616C3A20747275652C0D0A2020202020202020202020202020706F736974696F6E3A207B0D0A202020202020202020202020202020206D793A202263656E74657220746F70222C0D0A2020202020202020202020202020202061743A2022';
wwv_flow_imp.g_varchar2_table(497) := '63656E74657220746F702B22202B20287363726F6C6C59202B203634292C0D0A202020202020202020202020202020206F663A20242827626F647927290D0A20202020202020202020202020207D2C0D0A20202020202020202020202020206469616C6F';
wwv_flow_imp.g_varchar2_table(498) := '67436C6173733A202775692D6469616C6F672D2D7064742D6170657873706F746C69676874272C0D0A20202020202020202020202020206F70656E3A2066756E6374696F6E202829207B0D0A20202020202020202020202020202020617065782E657665';
wwv_flow_imp.g_varchar2_table(499) := '6E742E747269676765722827626F6479272C20277064742D6170657873706F746C696768742D6F70656E2D6469616C6F6727293B0D0A0D0A2020202020202020202020202020202076617220646C6724203D20242874686973293B0D0A0D0A2020202020';
wwv_flow_imp.g_varchar2_table(500) := '2020202020202020202020646C67240D0A2020202020202020202020202020202020202E63737328276D696E2D686569676874272C20276175746F27290D0A2020202020202020202020202020202020202E7072657628272E75692D6469616C6F672D74';
wwv_flow_imp.g_varchar2_table(501) := '69746C6562617227290D0A2020202020202020202020202020202020202E72656D6F766528293B0D0A0D0A20202020202020202020202020202020617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28293B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(502) := '2020202020202020202020202020202F2F2073686F7720686973746F727920706F706F7665720D0A20202020202020202020202020202020696620286170657853706F746C696768742E67456E61626C65536561726368486973746F727929207B0D0A20';
wwv_flow_imp.g_varchar2_table(503) := '20202020202020202020202020202020206170657853706F746C696768742E73686F775469707079486973746F7279506F706F76657228293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202428272E';
wwv_flow_imp.g_varchar2_table(504) := '75692D7769646765742D6F7665726C617927292E6F6E2827636C69636B272C2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(505) := '20202020202020202020207D293B0D0A2020202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E666F63757328293B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(506) := '20207D2C0D0A20202020202020202020202020206372656174653A2066756E6374696F6E202829207B0D0A20202020202020202020202020207D2C0D0A2020202020202020202020202020636C6F73653A2066756E6374696F6E202829207B0D0A202020';
wwv_flow_imp.g_varchar2_table(507) := '20202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20277064742D6170657873706F746C696768742D636C6F73652D6469616C6F6727293B0D0A202020202020202020202020202020206170657853706F74';
wwv_flow_imp.g_varchar2_table(508) := '6C696768742E726573657453706F746C6967687428293B0D0A20202020202020202020202020202020617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28293B0D0A202020202020202020202020202020202F2F2064697374';
wwv_flow_imp.g_varchar2_table(509) := '726F7920686973746F727920706F706F7665720D0A20202020202020202020202020202020696620286170657853706F746C696768742E67456E61626C65536561726368486973746F727929207B0D0A2020202020202020202020202020202020206170';
wwv_flow_imp.g_varchar2_table(510) := '657853706F746C696768742E64657374726F795469707079486973746F7279506F706F76657228293B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(511) := '2020202020207D0D0A20202020202020207D3B0D0A0D0A2020202020202020696620286170657853706F746C696768742E674861734469616C6F674372656174656429207B0D0A202020202020202020206F70656E4469616C6F6728293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(512) := '202020207D20656C7365207B0D0A202020202020202020206170657853706F746C696768742E63726561746553706F746C696768744469616C6F67286170657853706F746C696768742E67506C616365686F6C64657254657874293B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(513) := '202020206F70656E4469616C6F6728293B0D0A202020202020202020206170657853706F746C696768742E67657453706F746C69676874446174612866756E6374696F6E20286461746129207B0D0A2020202020202020202020206170657853706F746C';
wwv_flow_imp.g_varchar2_table(514) := '696768742E67536561726368496E646578203D20242E6772657028646174612C2066756E6374696F6E20286529207B0D0A202020202020202020202020202072657475726E20652E73203D3D2066616C73653B0D0A2020202020202020202020207D293B';
wwv_flow_imp.g_varchar2_table(515) := '0D0A2020202020202020202020206170657853706F746C696768742E67537461746963496E646578203D20242E6772657028646174612C2066756E6374696F6E20286529207B0D0A202020202020202020202020202072657475726E20652E73203D3D20';
wwv_flow_imp.g_varchar2_table(516) := '747275653B0D0A2020202020202020202020207D293B0D0A202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20277064742D6170657873706F746C696768742D6765742D6461746127292F2F2C2064617461';
wwv_flow_imp.g_varchar2_table(517) := '293B0D0A202020202020202020207D293B0D0A20202020202020207D0D0A0D0A2020202020202020666F637573456C656D656E74203D2070466F637573456C656D656E743B202F2F20636F756C642062652075736566756C20666F722073686F72746375';
wwv_flow_imp.g_varchar2_table(518) := '747320616464656420627920617065782E616374696F6E0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A20496E2D5061676520736561726368207573696E67206D61726B2E6A730D0A202020202020202A2040706172616D';
wwv_flow_imp.g_varchar2_table(519) := '207B737472696E677D20704B6579776F72640D0A202020202020202A2F0D0A202020202020696E506167655365617263683A2066756E6374696F6E2028704B6579776F726429207B0D0A2020202020202020766172206B6579776F7264203D20704B6579';
wwv_flow_imp.g_varchar2_table(520) := '776F7264207C7C206170657853706F746C696768742E674B6579776F7264733B0D0A2020202020202020242827626F647927292E756E6D61726B287B0D0A20202020202020202020646F6E653A2066756E6374696F6E202829207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(521) := '20202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0D0A2020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0D0A202020202020202020202020242827626F647927';
wwv_flow_imp.g_varchar2_table(522) := '292E6D61726B286B6579776F72642C207B7D293B0D0A202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D696E706167652D736561726368272C207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(523) := '202020202020202020226B6579776F7264223A206B6579776F72640D0A2020202020202020202020207D293B0D0A202020202020202020207D0D0A20202020202020207D293B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(524) := '2A20436865636B20696620726573756C74736574206D61726B7570206861732064796E616D6963206C69737420656E747269657320286E6F7420737461746963290D0A202020202020202A204072657475726E207B626F6F6C65616E7D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(525) := '20202A2F0D0A202020202020686173536561726368526573756C747344796E616D6963456E74726965733A2066756E6374696F6E202829207B0D0A20202020202020207661722068617344796E616D6963456E7472696573203D202428276C692E706474';
wwv_flow_imp.g_varchar2_table(526) := '2D6170782D53706F746C696768742D726573756C7427292E686173436C61737328277064742D6170782D53706F746C696768742D44594E414D49432729207C7C2066616C73653B0D0A202020202020202072657475726E2068617344796E616D6963456E';
wwv_flow_imp.g_varchar2_table(527) := '74726965733B0D0A2020202020207D2C0D0A2020202020202F2A2A0D0A202020202020202A205265616C20506C7567696E2068616E646C6572202D2063616C6C65642066726F6D206F7574657220706C7567696E48616E646C65722066756E6374696F6E';
wwv_flow_imp.g_varchar2_table(528) := '0D0A202020202020202A2040706172616D207B6F626A6563747D20704F7074696F6E730D0A202020202020202A2F0D0A202020202020706C7567696E48616E646C65723A2066756E6374696F6E2028704F7074696F6E7329207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(529) := '2F2F20706C7567696E20617474726962757465730D0A20202020202020207661722064796E616D6963416374696F6E4964203D206170657853706F746C696768742E6744796E616D6963416374696F6E4964203D20704F7074696F6E732E64796E616D69';
wwv_flow_imp.g_varchar2_table(530) := '63416374696F6E49643B0D0A202020202020202076617220616A61784964656E746966696572203D206170657853706F746C696768742E67416A61784964656E746966696572203D20704F7074696F6E732E616A61784964656E7469666965723B0D0A20';
wwv_flow_imp.g_varchar2_table(531) := '20202020202020766172206576656E744E616D65203D20704F7074696F6E732E6576656E744E616D653B0D0A202020202020202076617220666972654F6E496E6974203D20704F7074696F6E732E666972654F6E496E69743B0D0A0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(532) := '2076617220706C616365686F6C64657254657874203D206170657853706F746C696768742E67506C616365686F6C64657254657874203D20704F7074696F6E732E706C616365686F6C646572546578743B0D0A2020202020202020766172206D6F726543';
wwv_flow_imp.g_varchar2_table(533) := '6861727354657874203D206170657853706F746C696768742E674D6F7265436861727354657874203D20704F7074696F6E732E6D6F72654368617273546578743B0D0A2020202020202020766172206E6F4D6174636854657874203D206170657853706F';
wwv_flow_imp.g_varchar2_table(534) := '746C696768742E674E6F4D6174636854657874203D20704F7074696F6E732E6E6F4D61746368546578743B0D0A2020202020202020766172206F6E654D6174636854657874203D206170657853706F746C696768742E674F6E654D617463685465787420';
wwv_flow_imp.g_varchar2_table(535) := '3D20704F7074696F6E732E6F6E654D61746368546578743B0D0A2020202020202020766172206D756C7469706C654D61746368657354657874203D206170657853706F746C696768742E674D756C7469706C654D61746368657354657874203D20704F70';
wwv_flow_imp.g_varchar2_table(536) := '74696F6E732E6D756C7469706C654D617463686573546578743B0D0A202020202020202076617220696E5061676553656172636854657874203D206170657853706F746C696768742E67496E5061676553656172636854657874203D20704F7074696F6E';
wwv_flow_imp.g_varchar2_table(537) := '732E696E50616765536561726368546578743B0D0A202020202020202076617220736561726368486973746F727944656C65746554657874203D206170657853706F746C696768742E67536561726368486973746F727944656C65746554657874203D20';
wwv_flow_imp.g_varchar2_table(538) := '704F7074696F6E732E736561726368486973746F727944656C657465546578743B0D0A0D0A202020202020202076617220656E61626C654B6579626F61726453686F727463757473203D20704F7074696F6E732E656E61626C654B6579626F6172645368';
wwv_flow_imp.g_varchar2_table(539) := '6F7274637574733B0D0A2020202020202020766172206B6579626F61726453686F727463757473203D20704F7074696F6E732E6B6579626F61726453686F7274637574733B0D0A2020202020202020766172207375626D69744974656D73203D20704F70';
wwv_flow_imp.g_varchar2_table(540) := '74696F6E732E7375626D69744974656D733B0D0A202020202020202076617220656E61626C65496E50616765536561726368203D20704F7074696F6E732E656E61626C65496E506167655365617263683B0D0A2020202020202020766172206D61784E61';
wwv_flow_imp.g_varchar2_table(541) := '76526573756C74203D206170657853706F746C696768742E674D61784E6176526573756C74203D20704F7074696F6E732E6D61784E6176526573756C743B0D0A2020202020202020766172207769647468203D206170657853706F746C696768742E6757';
wwv_flow_imp.g_varchar2_table(542) := '69647468203D20704F7074696F6E732E77696474683B0D0A202020202020202076617220656E61626C65446174614361636865203D20704F7074696F6E732E656E61626C654461746143616368653B0D0A20202020202020207661722073706F746C6967';
wwv_flow_imp.g_varchar2_table(543) := '68745468656D65203D20704F7074696F6E732E73706F746C696768745468656D653B0D0A202020202020202076617220656E61626C6550726566696C6C53656C656374656454657874203D20704F7074696F6E732E656E61626C6550726566696C6C5365';
wwv_flow_imp.g_varchar2_table(544) := '6C6563746564546578743B0D0A20202020202020207661722073686F7750726F63657373696E67203D20704F7074696F6E732E73686F7750726F63657373696E673B0D0A202020202020202076617220706C616365486F6C64657249636F6E203D20704F';
wwv_flow_imp.g_varchar2_table(545) := '7074696F6E732E706C616365486F6C64657249636F6E3B0D0A202020202020202076617220656E61626C65536561726368486973746F7279203D20704F7074696F6E732E656E61626C65536561726368486973746F72793B0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(546) := '7661722064656661756C7454657874203D206170657853706F746C696768742E6744656661756C7454657874203D20704F7074696F6E732E64656661756C74546578743B0D0A2020202020202020766172206170704C696D6974203D206170657853706F';
wwv_flow_imp.g_varchar2_table(547) := '746C696768742E674170704C696D6974203D20704F7074696F6E732E6170704C696D69743B0D0A0D0A2020202020202020766172207375626D69744974656D734172726179203D205B5D3B0D0A2020202020202020766172206F70656E4469616C6F6720';
wwv_flow_imp.g_varchar2_table(548) := '3D20747275653B0D0A0D0A20202020202020202F2F2064656275670D0A20202020202020206C65742070647453706F746C696768744F7074696F6E73203D207B7D3B0D0A202020202020202070647453706F746C696768744F7074696F6E732E64796E61';
wwv_flow_imp.g_varchar2_table(549) := '6D6963416374696F6E4964203D2064796E616D6963416374696F6E49643B0D0A202020202020202070647453706F746C696768744F7074696F6E732E616A61784964656E746966696572203D20616A61784964656E7469666965723B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(550) := '202070647453706F746C696768744F7074696F6E732E6576656E744E616D65203D206576656E744E616D653B0D0A202020202020202070647453706F746C696768744F7074696F6E732E666972654F6E496E6974203D20666972654F6E496E69743B0D0A';
wwv_flow_imp.g_varchar2_table(551) := '202020202020202070647453706F746C696768744F7074696F6E732E706C616365686F6C64657254657874203D20706C616365686F6C646572546578743B0D0A202020202020202070647453706F746C696768744F7074696F6E732E6D6F726543686172';
wwv_flow_imp.g_varchar2_table(552) := '7354657874203D206D6F72654368617273546578743B0D0A202020202020202070647453706F746C696768744F7074696F6E732E6E6F4D6174636854657874203D206E6F4D61746368546578743B0D0A202020202020202070647453706F746C69676874';
wwv_flow_imp.g_varchar2_table(553) := '4F7074696F6E732E6F6E654D6174636854657874203D206F6E654D61746368546578743B0D0A202020202020202070647453706F746C696768744F7074696F6E732E6D756C7469706C654D61746368657354657874203D206D756C7469706C654D617463';
wwv_flow_imp.g_varchar2_table(554) := '686573546578743B0D0A202020202020202070647453706F746C696768744F7074696F6E732E696E5061676553656172636854657874203D20696E50616765536561726368546578743B0D0A202020202020202070647453706F746C696768744F707469';
wwv_flow_imp.g_varchar2_table(555) := '6F6E732E736561726368486973746F727944656C65746554657874203D20736561726368486973746F727944656C657465546578743B0D0A202020202020202070647453706F746C696768744F7074696F6E732E656E61626C654B6579626F6172645368';
wwv_flow_imp.g_varchar2_table(556) := '6F727463757473203D20656E61626C654B6579626F61726453686F7274637574733B0D0A202020202020202070647453706F746C696768744F7074696F6E732E6B6579626F61726453686F727463757473203D206B6579626F61726453686F7274637574';
wwv_flow_imp.g_varchar2_table(557) := '733B0D0A202020202020202070647453706F746C696768744F7074696F6E732E7375626D69744974656D73203D207375626D69744974656D733B0D0A202020202020202070647453706F746C696768744F7074696F6E732E656E61626C65496E50616765';
wwv_flow_imp.g_varchar2_table(558) := '536561726368203D20656E61626C65496E506167655365617263683B0D0A202020202020202070647453706F746C696768744F7074696F6E732E6D61784E6176526573756C74203D206D61784E6176526573756C743B0D0A202020202020202070647453';
wwv_flow_imp.g_varchar2_table(559) := '706F746C696768744F7074696F6E732E7769647468203D2077696474683B0D0A202020202020202070647453706F746C696768744F7074696F6E732E656E61626C65446174614361636865203D20656E61626C654461746143616368653B0D0A20202020';
wwv_flow_imp.g_varchar2_table(560) := '2020202070647453706F746C696768744F7074696F6E732E73706F746C696768745468656D65203D2073706F746C696768745468656D653B0D0A202020202020202070647453706F746C696768744F7074696F6E732E656E61626C6550726566696C6C53';
wwv_flow_imp.g_varchar2_table(561) := '656C656374656454657874203D20656E61626C6550726566696C6C53656C6563746564546578743B0D0A202020202020202070647453706F746C696768744F7074696F6E732E73686F7750726F63657373696E67203D2073686F7750726F63657373696E';
wwv_flow_imp.g_varchar2_table(562) := '673B0D0A202020202020202070647453706F746C696768744F7074696F6E732E706C616365486F6C64657249636F6E203D20706C616365486F6C64657249636F6E3B0D0A202020202020202070647453706F746C696768744F7074696F6E732E656E6162';
wwv_flow_imp.g_varchar2_table(563) := '6C65536561726368486973746F7279203D20656E61626C65536561726368486973746F72793B0D0A202020202020202070647453706F746C696768744F7074696F6E732E6170704C696D6974203D206170704C696D69743B0D0A20202020202020206170';
wwv_flow_imp.g_varchar2_table(564) := '65782E64656275672E696E666F287B2070647453706F746C696768744F7074696F6E73207D293B0D0A0D0A0D0A0D0A20202020202020202F2F20706F6C7966696C6C20666F72206F6C6465722062726F7773657273206C696B6520494520287374617274';
wwv_flow_imp.g_varchar2_table(565) := '7357697468202620696E636C756465732066756E6374696F6E73290D0A20202020202020206966202821537472696E672E70726F746F747970652E7374617274735769746829207B0D0A20202020202020202020537472696E672E70726F746F74797065';
wwv_flow_imp.g_varchar2_table(566) := '2E73746172747357697468203D2066756E6374696F6E20287365617263682C20706F7329207B0D0A20202020202020202020202072657475726E20746869732E7375627374722821706F73207C7C20706F73203C2030203F2030203A202B706F732C2073';
wwv_flow_imp.g_varchar2_table(567) := '65617263682E6C656E67746829203D3D3D207365617263683B0D0A202020202020202020207D3B0D0A20202020202020207D0D0A20202020202020206966202821537472696E672E70726F746F747970652E696E636C7564657329207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(568) := '2020202020537472696E672E70726F746F747970652E696E636C75646573203D2066756E6374696F6E20287365617263682C20737461727429207B0D0A2020202020202020202020202775736520737472696374273B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(569) := '69662028747970656F6620737461727420213D3D20276E756D6265722729207B0D0A20202020202020202020202020207374617274203D20303B0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020696620287374617274202B';
wwv_flow_imp.g_varchar2_table(570) := '207365617263682E6C656E677468203E20746869732E6C656E67746829207B0D0A202020202020202020202020202072657475726E2066616C73653B0D0A2020202020202020202020207D20656C7365207B0D0A20202020202020202020202020207265';
wwv_flow_imp.g_varchar2_table(571) := '7475726E20746869732E696E6465784F66287365617263682C2073746172742920213D3D202D313B0D0A2020202020202020202020207D0D0A202020202020202020207D3B0D0A20202020202020207D0D0A0D0A20202020202020202F2F207365742062';
wwv_flow_imp.g_varchar2_table(572) := '6F6F6C65616E20676C6F62616C20766172730D0A20202020202020206170657853706F746C696768742E67456E61626C65496E50616765536561726368203D2028656E61626C65496E50616765536561726368203D3D2027592729203F2074727565203A';
wwv_flow_imp.g_varchar2_table(573) := '2066616C73653B0D0A20202020202020206170657853706F746C696768742E67456E61626C65446174614361636865203D2028656E61626C65446174614361636865203D3D2027592729203F2074727565203A2066616C73653B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(574) := '6170657853706F746C696768742E67456E61626C6550726566696C6C53656C656374656454657874203D2028656E61626C6550726566696C6C53656C656374656454657874203D3D2027592729203F2074727565203A2066616C73653B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(575) := '2020206170657853706F746C696768742E6753686F7750726F63657373696E67203D202873686F7750726F63657373696E67203D3D2027592729203F2074727565203A2066616C73653B0D0A20202020202020206170657853706F746C696768742E6745';
wwv_flow_imp.g_varchar2_table(576) := '6E61626C65536561726368486973746F7279203D2028656E61626C65536561726368486973746F7279203D3D2027592729203F2074727565203A2066616C73653B0D0A20202020202020206170657853706F746C696768742E67456E61626C6544656661';
wwv_flow_imp.g_varchar2_table(577) := '756C7454657874203D202864656661756C745465787429203F2074727565203A2066616C73653B0D0A20202020202020206170657853706F746C696768742E64656661756C7454657874203D2064656661756C74546578743B0D0A0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(578) := '202F2F206275696C642070616765206974656D7320746F207375626D69742061727261790D0A2020202020202020696620287375626D69744974656D7329207B0D0A202020202020202020207375626D69744974656D734172726179203D206170657853';
wwv_flow_imp.g_varchar2_table(579) := '706F746C696768742E675375626D69744974656D734172726179203D207375626D69744974656D732E73706C697428272C27293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F207365742073706F746C69676874207468656D650D0A20';
wwv_flow_imp.g_varchar2_table(580) := '20202020202020737769746368202873706F746C696768745468656D6529207B0D0A202020202020202020206361736520274F52414E4745273A0D0A2020202020202020202020206170657853706F746C696768742E67526573756C744C697374546865';
wwv_flow_imp.g_varchar2_table(581) := '6D65436C617373203D20277064742D6170782D53706F746C696768742D726573756C742D6F72616E6765273B0D0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D20277064742D6170782D53';
wwv_flow_imp.g_varchar2_table(582) := '706F746C696768742D69636F6E2D6F72616E6765273B0D0A202020202020202020202020627265616B3B0D0A20202020202020202020636173652027524544273A0D0A2020202020202020202020206170657853706F746C696768742E67526573756C74';
wwv_flow_imp.g_varchar2_table(583) := '4C6973745468656D65436C617373203D20277064742D6170782D53706F746C696768742D726573756C742D726564273B0D0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D20277064742D61';
wwv_flow_imp.g_varchar2_table(584) := '70782D53706F746C696768742D69636F6E2D726564273B0D0A202020202020202020202020627265616B3B0D0A202020202020202020206361736520274441524B273A0D0A2020202020202020202020206170657853706F746C696768742E6752657375';
wwv_flow_imp.g_varchar2_table(585) := '6C744C6973745468656D65436C617373203D20277064742D6170782D53706F746C696768742D726573756C742D6461726B273B0D0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D20277064';
wwv_flow_imp.g_varchar2_table(586) := '742D6170782D53706F746C696768742D69636F6E2D6461726B273B0D0A202020202020202020202020627265616B3B0D0A20202020202020207D0D0A0D0A20202020202020202F2F207365742073656172636820706C616365686F6C6465722069636F6E';
wwv_flow_imp.g_varchar2_table(587) := '0D0A202020202020202069662028706C616365486F6C64657249636F6E203D3D3D202744454641554C542729207B0D0A202020202020202020206170657853706F746C696768742E67506C616365486F6C64657249636F6E203D2027612D49636F6E2069';
wwv_flow_imp.g_varchar2_table(588) := '636F6E2D736561726368273B0D0A20202020202020207D20656C7365207B0D0A202020202020202020206170657853706F746C696768742E67506C616365486F6C64657249636F6E203D202766612027202B20706C616365486F6C64657249636F6E3B0D';
wwv_flow_imp.g_varchar2_table(589) := '0A20202020202020207D0D0A0D0A20202020202020202F2F20636865636B7320666F72206F70656E696E67206469616C6F670D0A2020202020202020696620286576656E744E616D65203D3D20276B6579626F61726453686F727463757427207C7C2066';
wwv_flow_imp.g_varchar2_table(590) := '6972654F6E496E6974203D3D2027592729207B0D0A202020202020202020206F70656E4469616C6F67203D20747275653B0D0A20202020202020207D20656C736520696620286576656E744E616D65203D3D202772656164792729207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(591) := '20202020206F70656E4469616C6F67203D2066616C73653B0D0A20202020202020207D20656C7365207B0D0A202020202020202020206F70656E4469616C6F67203D20747275653B0D0A20202020202020207D0D0A0D0A20202020202020202F2F207472';
wwv_flow_imp.g_varchar2_table(592) := '696767657220696E70757420616E642073656172636820616761696E202D2D3E2069662073656172636820696E7075742068617320736F6D652076616C756520616E6420676574446174612072657175657374206861732066696E736865640D0A202020';
wwv_flow_imp.g_varchar2_table(593) := '2020202020242827626F647927292E6F6E28277064742D6170657873706F746C696768742D6765742D64617461272C2066756E6374696F6E202829207B0D0A20202020202020202020696620286170657853706F746C696768742E674861734469616C6F';
wwv_flow_imp.g_varchar2_table(594) := '67437265617465642026262028216170657853706F746C696768742E686173536561726368526573756C747344796E616D6963456E747269657328292929207B0D0A2020202020202020202020207661722073656172636856616C7565203D2024286170';
wwv_flow_imp.g_varchar2_table(595) := '657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C28292E7472696D28293B0D0A2020202020202020202020206966202873656172636856616C756529207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(596) := '2020206170657853706F746C696768742E7365617263682873656172636856616C7565293B0D0A202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E74';
wwv_flow_imp.g_varchar2_table(597) := '7269676765722827696E70757427293B0D0A2020202020202020202020207D0D0A202020202020202020207D0D0A20202020202020207D293B0D0A0D0A2020202020202020242827626F647927292E6F6E28277064742D6170657873706F746C69676874';
wwv_flow_imp.g_varchar2_table(598) := '2D70726566657463682D64617461272C2066756E6374696F6E202829207B0D0A202020202020202020207064742E6F70742E73706F746C696768745072656665746368696E67203D20747275653B0D0A202020202020202020202428272E7064742D7370';
wwv_flow_imp.g_varchar2_table(599) := '6F746C696768742D6465766261722D656E74727927292E616464436C617373282766612D72656672657368207064742D7072656665746368696E672066612D616E696D2D7370696E27293B0D0A202020202020202020206170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(600) := '2E766665746368537461727454696D65203D206E6577204461746528293B0D0A202020202020202020206170657853706F746C696768742E67657453706F746C69676874446174612866756E6374696F6E20286461746129207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(601) := '20202020636F6E737420766665746368456E6454696D65203D206E6577204461746528293B0D0A202020202020202020202020636F6E7374206475726174696F6E203D20766665746368456E6454696D65202D206170657853706F746C696768742E7666';
wwv_flow_imp.g_varchar2_table(602) := '65746368537461727454696D653B0D0A202020202020202020202020617065782E64656275672E696E666F282753706F746C69676874204461746120526561647920696E2027202B206475726174696F6E202B20276D7327293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(603) := '20207D293B0D0A20202020202020207D293B0D0A0D0A20202020202020202F2F206F70656E206469616C6F670D0A2020202020202020696620286F70656E4469616C6F6729207B0D0A202020202020202020206170657853706F746C696768742E6F7065';
wwv_flow_imp.g_varchar2_table(604) := '6E53706F746C696768744469616C6F6728293B0D0A20202020202020207D0D0A2020202020207D0D0A202020207D3B202F2F20656E64206E616D657370616365206170657853706F746C696768740D0A0D0A202020202F2F2063616C6C207265616C2070';
wwv_flow_imp.g_varchar2_table(605) := '6C7567696E48616E646C65722066756E6374696F6E0D0A202020206170657853706F746C696768742E706C7567696E48616E646C657228704F7074696F6E73293B0D0A20207D0D0A7D3B0D0A0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219967408482840732)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/apexspotlight.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E74446576426172203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A2020202066756E6374696F6E2073706F746C696768744F7074696F6E7328704576656E74';
wwv_flow_imp.g_varchar2_table(2) := '4E616D6529207B0D0A20202020202020202F2F2053746172742053706F746C69676874204861726E6573730D0A20202020202020207661722070647453706F744F7074203D207B0D0A2020202020202020202020202264796E616D6963416374696F6E49';
wwv_flow_imp.g_varchar2_table(3) := '64223A207064742E6F70742E64796E616D6963416374696F6E49642C0D0A20202020202020202020202022616A61784964656E746966696572223A207064742E6F70742E616A61784964656E7469666965722C0D0A202020202020202020202020226576';
wwv_flow_imp.g_varchar2_table(4) := '656E744E616D65223A20704576656E744E616D652C202F2F226B6579626F61726453686F7274637574222C202F2F22636C69636B222C0D0A20202020202020202020202022666972654F6E496E6974223A20224E222C0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(5) := '22706C616365686F6C64657254657874223A2022456E74657220612050616765204E756D626572206F72204E616D65222C0D0A202020202020202020202020226D6F7265436861727354657874223A2022506C6561736520656E746572206174206C6561';
wwv_flow_imp.g_varchar2_table(6) := '73742074776F206C65747465727320746F20736561726368222C0D0A202020202020202020202020226E6F4D6174636854657874223A20224E6F206D6174636820666F756E64222C0D0A202020202020202020202020226F6E654D617463685465787422';
wwv_flow_imp.g_varchar2_table(7) := '3A202231206D6174636820666F756E64222C0D0A202020202020202020202020226D756C7469706C654D61746368657354657874223A20226D61746368657320666F756E64222C0D0A20202020202020202020202022696E506167655365617263685465';
wwv_flow_imp.g_varchar2_table(8) := '7874223A2022536561726368206F6E2063757272656E742050616765222C0D0A20202020202020202020202022736561726368486973746F727944656C65746554657874223A2022436C6561722053656172636820486973746F7279222C0D0A20202020';
wwv_flow_imp.g_varchar2_table(9) := '202020202020202022656E61626C654B6579626F61726453686F727463757473223A202259222C0D0A20202020202020202020202022656E61626C65496E50616765536561726368223A20224E222C0D0A202020202020202020202020226D61784E6176';
wwv_flow_imp.g_varchar2_table(10) := '526573756C74223A20393939392C0D0A202020202020202020202020227769647468223A2022363530222C0D0A20202020202020202020202022656E61626C65446174614361636865223A207064742E67657453657474696E6728276465766261722E6F';
wwv_flow_imp.g_varchar2_table(11) := '70656E6275696C646572636163686527292C0D0A2020202020202020202020202273706F746C696768745468656D65223A20225354414E44415244222C0D0A20202020202020202020202022656E61626C6550726566696C6C53656C6563746564546578';
wwv_flow_imp.g_varchar2_table(12) := '74223A20224E222C0D0A2020202020202020202020202273686F7750726F63657373696E67223A202259222C0D0A20202020202020202020202022706C616365486F6C64657249636F6E223A202244454641554C54222C0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(13) := '2022656E61626C65536561726368486973746F7279223A20224E222C0D0A2020202020202020202020202264656661756C7454657874223A207064742E6F70742E656E762E4150505F504147455F49442C0D0A202020202020202020202020226170704C';
wwv_flow_imp.g_varchar2_table(14) := '696D6974223A207064742E67657453657474696E6728276465766261722E6F70656E6275696C6465726170706C696D697427290D0A20202020202020207D3B0D0A202020202020202072657475726E2070647453706F744F70743B0D0A202020207D0D0A';
wwv_flow_imp.g_varchar2_table(15) := '0D0A2020202066756E6374696F6E206163746976617465476C6F7744656275672829207B0D0A0D0A20202020202020207661722076446576656C6F706572734F6E6C79203D202759273B0D0A0D0A20202020202020202F2F20446F6E7420616374697661';
wwv_flow_imp.g_varchar2_table(16) := '746520666F72206E6F6E2D646576656C6F706572730D0A20202020202020206966202821282876446576656C6F706572734F6E6C79203D3D20275927202626202428272361706578446576546F6F6C62617227292E6C656E67746820213D203029207C7C';
wwv_flow_imp.g_varchar2_table(17) := '2076446576656C6F706572734F6E6C79203D3D20274E272929207B0D0A20202020202020202020202072657475726E3B0D0A20202020202020207D0D0A0D0A20202020202020202F2F206F627461696E20446562756720736574696E672066726F6D2070';
wwv_flow_imp.g_varchar2_table(18) := '64656275672070616765207661726961626C650D0A202020202020202076617220706465627567203D20617065782E6974656D282770646562756727292E67657456616C756528293B0D0A0D0A20202020202020207661722069734465627567203D2028';
wwv_flow_imp.g_varchar2_table(19) := '5B27272C20274E4F275D2E696E6465784F662870646562756729203D3D202D31293B0D0A2020202020202020696620286973446562756729207B0D0A2020202020202020202020202428272361706578446576546F6F6C62617227292E66696E6428272E';
wwv_flow_imp.g_varchar2_table(20) := '612D49636F6E2E69636F6E2D646562756727292E72656D6F7665436C61737328292E616464436C617373282766612066612D6275672066616D2D636865636B2066616D2D69732D7375636365737327293B0D0A20202020202020207D20656C7365207B0D';
wwv_flow_imp.g_varchar2_table(21) := '0A2020202020202020202020202428272361706578446576546F6F6C62617227292E66696E6428272E612D49636F6E2E69636F6E2D646562756727292E72656D6F7665436C61737328292E616464436C617373282766612066612D6275672066616D2D78';
wwv_flow_imp.g_varchar2_table(22) := '2066616D2D69732D64697361626C656427293B0D0A20202020202020207D0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E2061637469766174654F70656E4275696C6465722829207B0D0A0D0A2020202020202020766172207644657665';
wwv_flow_imp.g_varchar2_table(23) := '6C6F706572734F6E6C79203D202759273B0D0A202020202020202076617220764B6579626F61726453686F7274637574203D207064742E67657453657474696E6728276465766261722E6F70656E6275696C6465726B6227293B0D0A0D0A202020202020';
wwv_flow_imp.g_varchar2_table(24) := '20202F2F20446F6E7420616374697661746520666F72206E6F6E2D646576656C6F706572730D0A20202020202020206966202821282876446576656C6F706572734F6E6C79203D3D20275927202626202428272361706578446576546F6F6C6261722729';
wwv_flow_imp.g_varchar2_table(25) := '2E6C656E67746820213D203029207C7C2076446576656C6F706572734F6E6C79203D3D20274E272929207B0D0A20202020202020202020202072657475726E3B0D0A20202020202020207D0D0A0D0A20202020202020202F2F2042696E64206B6579626F';
wwv_flow_imp.g_varchar2_table(26) := '6172642073686F7274637574730D0A20202020202020204D6F757365747261702E62696E64476C6F62616C28276374726C2B616C742B27202B20764B6579626F61726453686F72746375742E746F4C6F7765724361736528292C2066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(27) := '286529207B0D0A20202020202020202020202070647453706F746C696768742873706F746C696768744F7074696F6E7328276B6579626F61726453686F72746375742729293B0D0A20202020202020207D293B0D0A0D0A20202020202020206966202824';
wwv_flow_imp.g_varchar2_table(28) := '28272361706578446576546F6F6C6261725061676527292E6C656E677468203E2030202626202428272361706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C53706F746C6967687427292E6C656E677468203D3D203029';
wwv_flow_imp.g_varchar2_table(29) := '207B0D0A0D0A2020202020202020202020207661722069636F6E48746D6C203D20273C7370616E20636C6173733D22612D49636F6E206661207064742D73706F746C696768742D6465766261722D656E7472792220617269612D68696464656E3D227472';
wwv_flow_imp.g_varchar2_table(30) := '7565223E3C2F7370616E3E270D0A0D0A2020202020202020202020202428272361706578446576546F6F6C6261725061676527292E706172656E7428292E6166746572280D0A20202020202020202020202020202020617065782E6C616E672E666F726D';
wwv_flow_imp.g_varchar2_table(31) := '61744E6F457363617065280D0A2020202020202020202020202020202020202020273C6C693E3C627574746F6E2069643D2261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C53706F746C696768742220747970653D';
wwv_flow_imp.g_varchar2_table(32) := '22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C62617222207469746C653D224F70656E204275696C646572205B6374726C2B616C742B25305D2220617269612D6C6162656C3D22566172732220';
wwv_flow_imp.g_varchar2_table(33) := '646174612D6C696E6B3D22223E2027202B0D0A20202020202020202020202020202020202020202725312027202B0D0A2020202020202020202020202020202020202020273C2F627574746F6E3E3C2F6C693E272C0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(34) := '20202020202020764B6579626F61726453686F72746375742E746F4C6F7765724361736528292C0D0A202020202020202020202020202020202020202069636F6E48746D6C0D0A20202020202020202020202020202020290D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(35) := '2020293B0D0A0D0A2020202020202020202020207064742E666978546F6F6C626172576964746828293B0D0A0D0A2020202020202020202020207661722068203D20646F63756D656E742E676574456C656D656E7442794964282261706578446576546F';
wwv_flow_imp.g_varchar2_table(36) := '6F6C62617250726574697573446576656C6F706572546F6F6C53706F746C6967687422293B0D0A202020202020202020202020696620286829207B0D0A20202020202020202020202020202020682E6164644576656E744C697374656E65722822636C69';
wwv_flow_imp.g_varchar2_table(37) := '636B222C2066756E6374696F6E20286576656E7429207B0D0A202020202020202020202020202020202020202070647453706F746C696768742873706F746C696768744F7074696F6E7328276B6579626F61726453686F72746375742729293B0D0A2020';
wwv_flow_imp.g_varchar2_table(38) := '20202020202020202020202020207D2C2074727565293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A2020202020202020696620287064742E67657453657474696E6728276465766261722E6F70656E6275696C64657263';
wwv_flow_imp.g_varchar2_table(39) := '616368652729203D3D2027592729207B0D0A2020202020202020202020202F2F202F2F205072654665746368200D0A20202020202020202020202070647453706F746C696768742873706F746C696768744F7074696F6E73282772656164792729293B0D';
wwv_flow_imp.g_varchar2_table(40) := '0A202020202020202020202020242827626F647927292E7472696767657228277064742D6170657873706F746C696768742D70726566657463682D6461746127293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020202428';
wwv_flow_imp.g_varchar2_table(41) := '272E7064742D73706F746C696768742D6465766261722D656E74727927292E616464436C617373282766612D77696E646F772D6172726F772D757027293B0D0A20202020202020207D0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E2070';
wwv_flow_imp.g_varchar2_table(42) := '647453706F746C69676874286F707429207B0D0A2020202020202020696620287064742E6F70742E73706F746C696768745072656665746368696E6729207B0D0A202020202020202020202020617065782E6D6573736167652E616C6572742822504454';
wwv_flow_imp.g_varchar2_table(43) := '2069732063757272656E746C792063616368696E67205061676520446174612E20506C6561736520726574727920696E206120666577206D6F6D656E74732E22293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020207064';
wwv_flow_imp.g_varchar2_table(44) := '742E6170657853706F746C696768742E706C7567696E48616E646C6572286F7074293B0D0A20202020202020207D0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E206163746976617465486F6D655265706C6163652829207B0D0A202020';
wwv_flow_imp.g_varchar2_table(45) := '20202020202F2F204368616E6765205469746C650D0A20202020202020202428272361706578446576546F6F6C626172486F6D6527292E6174747228277469746C65272C2753686172656420436F6D706F6E656E7473202D204374726C2F436D642B436C';
wwv_flow_imp.g_varchar2_table(46) := '69636B20746F206F70656E20696E2061206E65772074616227293B0D0A20202020202020202F2F204368616E67652049636F6E0D0A20202020202020202428272361706578446576546F6F6C626172486F6D65207370616E2E612D49636F6E27292E7265';
wwv_flow_imp.g_varchar2_table(47) := '6D6F7665436C61737328292E616464436C61737328202766612066612D7368617065732720293B0D0A20202020202020202F2F2052656D6F7665204C6162656C0D0A20202020202020202428272361706578446576546F6F6C626172486F6D65202E612D';
wwv_flow_imp.g_varchar2_table(48) := '446576546F6F6C6261722D627574746F6E4C6162656C27292E7265706C6163655769746828293B0D0A0D0A20202020202020202F2F20436C69636B696E67204F70656E732053686172656420436F6D706F6E656E74730D0A202020202020202024282723';
wwv_flow_imp.g_varchar2_table(49) := '61706578446576546F6F6C626172486F6D6527292E6F66662827636C69636B27293B0D0A20202020202020202428272361706578446576546F6F6C626172486F6D6527292E6F6E2827636C69636B272C2066756E6374696F6E20286576656E7429207B0D';
wwv_flow_imp.g_varchar2_table(50) := '0A202020202020202020202020766172207057696E646F77203D206576656E742E6374726C4B6579207C7C206576656E742E6D6574614B65793B0D0A2020202020202020202020207064742E70726574697573546F6F6C6261722E6F70656E5368617265';
wwv_flow_imp.g_varchar2_table(51) := '64436F6D706F6E656E7473287057696E646F77293B0D0A20202020202020207D293B0D0A202020207D0D0A0D0A0D0A2020202072657475726E207B0D0A202020202020202061637469766174654F70656E4275696C6465723A2061637469766174654F70';
wwv_flow_imp.g_varchar2_table(52) := '656E4275696C6465722C0D0A20202020202020206163746976617465476C6F7744656275673A206163746976617465476C6F7744656275672C0D0A20202020202020206163746976617465486F6D655265706C6163653A206163746976617465486F6D65';
wwv_flow_imp.g_varchar2_table(53) := '5265706C6163650D0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219967861701840733)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/contentDevBar.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E7064742D676C6F774465627567207B0D0A20202020636F6C6F723A20234646303030300D0A7D0D0A0D0A2E7064742D7072656665746368696E67207B0D0A20202020636F6C6F723A20236666613530302020200D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219968260702840735)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/dev-bar.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E7064742D6170782D53706F746C696768747B646973706C61793A666C65783B6F766572666C6F773A68696464656E3B6865696768743A6175746F21696D706F7274616E747D2E7064742D6170782D53706F746C696768742D626F64797B666C65782D67';
wwv_flow_imp.g_varchar2_table(2) := '726F773A313B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B6F766572666C6F773A68696464656E7D626F64792E617065';
wwv_flow_imp.g_varchar2_table(3) := '782D73706F746C696768742D6163746976657B6F766572666C6F773A68696464656E7D2E7064742D6170782D53706F746C696768742D726573756C74737B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E393829';
wwv_flow_imp.g_varchar2_table(4) := '3B666C65782D67726F773A313B6F766572666C6F773A6175746F3B6D61782D6865696768743A353076687D2E7064742D6170782D53706F746C696768742D726573756C74733A656D7074797B646973706C61793A6E6F6E657D2E7064742D6170782D5370';
wwv_flow_imp.g_varchar2_table(5) := '6F746C696768742D726573756C74734C6973747B6C6973742D7374796C653A6E6F6E653B6D617267696E3A303B70616464696E673A307D2E7064742D6170782D53706F746C696768742D726573756C743A6E6F74283A6C6173742D6368696C64297B626F';
wwv_flow_imp.g_varchar2_table(6) := '726465722D626F74746F6D3A31707820736F6C6964207267626128302C302C302C2E3035297D2E7064742D6170782D53706F746C696768742D696E6C696E652D6C696E6B3A686F7665727B746578742D6465636F726174696F6E3A6E6F6E653B636F6C6F';
wwv_flow_imp.g_varchar2_table(7) := '723A236666667D2E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D696E6C696E652D6C696E6B7B746578742D6465636F726174696F6E3A6E6F6E653B636F6C6F72';
wwv_flow_imp.g_varchar2_table(8) := '3A236666667D2E7064742D6170782D53706F746C696768742D726573756C74202E7064742D6170782D53706F746C696768742D6C696E6B3A686F7665727B746578742D6465636F726174696F6E3A6E6F6E657D2E7064742D6170782D53706F746C696768';
wwv_flow_imp.g_varchar2_table(9) := '742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B7B746578742D6465636F726174696F6E3A6E6F6E653B6261636B67726F756E642D636F6C6F723A233035373263653B636F6C6F723A236666667D';
wwv_flow_imp.g_varchar2_table(10) := '2E7064742D6170782D53706F746C696768742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B202E7064742D6170782D53706F746C696768742D646573632C2E7064742D6170782D53706F746C6967';
wwv_flow_imp.g_varchar2_table(11) := '68742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B202E7064742D6170782D53706F746C696768742D73686F72746375747B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768';
wwv_flow_imp.g_varchar2_table(12) := '742D726573756C742E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B202E7064742D6170782D53706F746C696768742D73686F72746375747B6261636B67726F756E642D636F6C6F723A72676261283235352C323535';
wwv_flow_imp.g_varchar2_table(13) := '2C3235352C2E3135297D2E7064742D6170782D53706F746C696768742D6865616465727B70616464696E673A302031367078203020313670783B666C65782D736872696E6B3A303B646973706C61793A666C65783B706F736974696F6E3A72656C617469';
wwv_flow_imp.g_varchar2_table(14) := '76653B626F726465722D626F74746F6D3A31707820736F6C6964207267626128302C302C302C2E3035293B6D617267696E2D626F74746F6D3A2D3170783B6261636B67726F756E642D636F6C6F723A236635663566357D2E7064742D6170782D53706F74';
wwv_flow_imp.g_varchar2_table(15) := '6C696768742D7365617263687B70616464696E673A313670783B666C65782D736872696E6B3A303B646973706C61793A666C65783B706F736974696F6E3A72656C61746976653B626F726465722D626F74746F6D3A31707820736F6C6964207267626128';
wwv_flow_imp.g_varchar2_table(16) := '302C302C302C2E3035293B6D617267696E2D626F74746F6D3A2D3170787D2E7064742D6170782D53706F746C696768742D736561726368202E7064742D6170782D53706F746C696768742D69636F6E7B706F736974696F6E3A72656C61746976653B7A2D';
wwv_flow_imp.g_varchar2_table(17) := '696E6465783A313B6261636B67726F756E642D636F6C6F723A236264633363377D2E7064742D6170782D53706F746C696768742D6669656C647B666C65782D67726F773A313B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A30';
wwv_flow_imp.g_varchar2_table(18) := '3B72696768743A303B626F74746F6D3A307D2E7064742D6170782D53706F746C696768742D696E7075747B666F6E742D73697A653A3230707821696D706F7274616E743B6C696E652D6865696768743A333270783B6865696768743A363470783B706164';
wwv_flow_imp.g_varchar2_table(19) := '64696E673A313670782031367078203136707820363470783B626F726465722D77696474683A303B646973706C61793A626C6F636B3B77696474683A313030253B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E';
wwv_flow_imp.g_varchar2_table(20) := '3938293B636F6C6F723A233030307D2E7064742D6170782D53706F746C696768742D696E7075743A666F6375737B6F75746C696E653A307D2E7064742D6170782D53706F746C696768742D6C696E6B7B646973706C61793A626C6F636B3B646973706C61';
wwv_flow_imp.g_varchar2_table(21) := '793A666C65783B70616464696E673A313070782031367078203132707820313670783B636F6C6F723A233230323032303B616C69676E2D6974656D733A63656E7465727D2E7064742D6170782D53706F746C696768742D6C696E6B3A666F6375737B6F75';
wwv_flow_imp.g_varchar2_table(22) := '746C696E653A307D2E7064742D6170782D53706F746C696768742D69636F6E7B6D617267696E2D72696768743A313670783B70616464696E673A3870783B77696474683A333270783B6865696768743A333270783B626F782D736861646F773A30203020';
wwv_flow_imp.g_varchar2_table(23) := '302031707820236666663B626F726465722D7261646975733A3270783B6261636B67726F756E642D636F6C6F723A233339396265613B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768742D726573756C742D2D617070202E706474';
wwv_flow_imp.g_varchar2_table(24) := '2D6170782D53706F746C696768742D69636F6E7B6261636B67726F756E642D636F6C6F723A236635346232317D2E7064742D6170782D53706F746C696768742D726573756C742D2D7773202E7064742D6170782D53706F746C696768742D69636F6E7B62';
wwv_flow_imp.g_varchar2_table(25) := '61636B67726F756E642D636F6C6F723A233234636237667D2E7064742D6170782D53706F746C696768742D696E666F7B666C65782D67726F773A313B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B6A75737469';
wwv_flow_imp.g_varchar2_table(26) := '66792D636F6E74656E743A63656E7465727D2E7064742D6170782D53706F746C696768742D6C6162656C7B666F6E742D73697A653A313470783B666F6E742D7765696768743A3530307D2E7064742D6170782D53706F746C696768742D646573637B666F';
wwv_flow_imp.g_varchar2_table(27) := '6E742D73697A653A313170783B636F6C6F723A7267626128302C302C302C2E3635297D2E7064742D6170782D53706F746C696768742D73686F72746375747B6C696E652D6865696768743A313670783B666F6E742D73697A653A313270783B636F6C6F72';
wwv_flow_imp.g_varchar2_table(28) := '3A7267626128302C302C302C2E3635293B70616464696E673A347078203470783B626F726465722D7261646975733A323470783B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E303235297D626F6479202E75692D6469616C6F';
wwv_flow_imp.g_varchar2_table(29) := '672E75692D6469616C6F672D2D7064742D6170657873706F746C696768747B626F726465722D77696474683A303B626F782D736861646F773A30203870782031367078207267626128302C302C302C2E3235292C30203170782032707820726762612830';
wwv_flow_imp.g_varchar2_table(30) := '2C302C302C2E3135292C302030203020317078207267626128302C302C302C2E3035293B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D626F6479202E75692D6469616C6F672E75692D6469616C6F672D2D7064742D61706578';
wwv_flow_imp.g_varchar2_table(31) := '73706F746C69676874202E75692D6469616C6F672D7469746C656261727B646973706C61793A6E6F6E657D406D65646961206F6E6C792073637265656E20616E6420286D61782D6865696768743A3736387078297B2E7064742D6170782D53706F746C69';
wwv_flow_imp.g_varchar2_table(32) := '6768742D726573756C74737B6D61782D6865696768743A33393070787D7D756C2E7064742D73706F746C696768742D686973746F72792D6C6973747B746578742D616C69676E3A6C6566747D612E7064742D73706F746C696768742D686973746F72792D';
wwv_flow_imp.g_varchar2_table(33) := '64656C6574652C612E7064742D73706F746C696768742D686973746F72792D6C696E6B7B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768742D726573756C742D6F72616E67652E69732D616374697665202E7064742D6170782D53';
wwv_flow_imp.g_varchar2_table(34) := '706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A236635396533333B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768742D69636F6E2D6F72616E67657B6261636B67726F756E642D636F6C6F723A2337';
wwv_flow_imp.g_varchar2_table(35) := '39373837653B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768742D726573756C742D7265642E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A2364';
wwv_flow_imp.g_varchar2_table(36) := '61316231623B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768742D69636F6E2D7265647B6261636B67726F756E642D636F6C6F723A233630363036303B636F6C6F723A236666667D2E7064742D6170782D53706F746C696768742D';
wwv_flow_imp.g_varchar2_table(37) := '726573756C742D6461726B2E69732D616374697665202E7064742D6170782D53706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A233332333333363B636F6C6F723A236666667D2E7064742D6170782D53706F746C69676874';
wwv_flow_imp.g_varchar2_table(38) := '2D69636F6E2D6461726B7B6261636B67726F756E642D636F6C6F723A236536653665363B636F6C6F723A233430343034303B626F782D736861646F773A30203020302031707820233430343034307D2E7064742D6170782D53706F746C696768742D6465';
wwv_flow_imp.g_varchar2_table(39) := '73632D6C6F7A656E67657B70616464696E673A3270783B626F726465722D7261646975733A3570787D2E7064742D7370742D6C626C7B6865696768743A323470787D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219968685748840748)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/minified/apexspotlight.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E6170657853706F746C696768743D7B696E69744B6579626F61726453686F7274637574733A66756E6374696F6E2874297B742E6576656E744E616D653D226B6579626F61726453686F7274637574222C617065782E64656275672E696E666F28';
wwv_flow_imp.g_varchar2_table(2) := '226170657853706F746C696768742E696E69744B6579426F61726453686F727463757473202D20704F7074696F6E73222C74293B76617220653D742E656E61626C654B6579626F61726453686F7274637574732C613D742E6B6579626F61726453686F72';
wwv_flow_imp.g_varchar2_table(3) := '74637574732C693D5B5D3B2259223D3D65262628693D612E73706C697428222C22292C4D6F757365747261702E73746F7043616C6C6261636B3D66756E6374696F6E28742C652C61297B72657475726E21317D2C4D6F757365747261702E70726F746F74';
wwv_flow_imp.g_varchar2_table(4) := '7970652E73746F7043616C6C6261636B3D66756E6374696F6E28742C652C61297B72657475726E21317D2C4D6F757365747261702E62696E6428692C66756E6374696F6E2865297B652E70726576656E7444656661756C743F652E70726576656E744465';
wwv_flow_imp.g_varchar2_table(5) := '6661756C7428293A652E72657475726E56616C75653D21312C7064742E6170657853706F746C696768742E706C7567696E48616E646C65722874297D29297D2C736574486973746F727953656172636856616C75653A66756E6374696F6E2874297B2428';
wwv_flow_imp.g_varchar2_table(6) := '222E7064742D6170782D53706F746C696768742D696E70757422292E76616C2874292E747269676765722822696E70757422297D2C706C7567696E48616E646C65723A66756E6374696F6E28704F7074696F6E73297B766172206170657853706F746C69';
wwv_flow_imp.g_varchar2_table(7) := '6768743D7B444F543A222E222C53505F4449414C4F473A227064742D6170782D53706F746C69676874222C53505F494E5055543A227064742D6170782D53706F746C696768742D696E707574222C53505F524553554C54533A227064742D6170782D5370';
wwv_flow_imp.g_varchar2_table(8) := '6F746C696768742D726573756C7473222C53505F4143544956453A2269732D616374697665222C53505F53484F52544355543A227064742D6170782D53706F746C696768742D73686F7274637574222C53505F414354494F4E5F53484F52544355543A22';
wwv_flow_imp.g_varchar2_table(9) := '73706F746C696768742D736561726368222C53505F524553554C545F4C4142454C3A227064742D6170782D53706F746C696768742D6C6162656C222C53505F4C4956455F524547494F4E3A227064742D73702D617269612D6D617463682D666F756E6422';
wwv_flow_imp.g_varchar2_table(10) := '2C53505F4C4953543A227064742D73702D726573756C742D6C697374222C4B4559533A242E75692E6B6579436F64652C55524C5F54595045533A7B72656469726563743A227265646972656374222C736561726368506167653A227365617263682D7061';
wwv_flow_imp.g_varchar2_table(11) := '6765227D2C49434F4E533A7B706167653A2266612D77696E646F772D736561726368222C7365617263683A2269636F6E2D736561726368227D2C674D61784E6176526573756C743A35302C6757696474683A3635302C674861734469616C6F6743726561';
wwv_flow_imp.g_varchar2_table(12) := '7465643A21312C67536561726368496E6465783A5B5D2C67537461746963496E6465783A5B5D2C674B6579776F7264733A22222C67416A61784964656E7469666965723A6E756C6C2C6744796E616D6963416374696F6E49643A6E756C6C2C67506C6163';
wwv_flow_imp.g_varchar2_table(13) := '65686F6C646572546578743A6E756C6C2C674D6F72654368617273546578743A6E756C6C2C674E6F4D61746368546578743A6E756C6C2C674F6E654D61746368546578743A6E756C6C2C674D756C7469706C654D617463686573546578743A6E756C6C2C';
wwv_flow_imp.g_varchar2_table(14) := '67496E50616765536561726368546578743A6E756C6C2C67536561726368486973746F727944656C657465546578743A6E756C6C2C67456E61626C65496E506167655365617263683A21302C67456E61626C654461746143616368653A21312C67456E61';
wwv_flow_imp.g_varchar2_table(15) := '626C6550726566696C6C53656C6563746564546578743A21312C67456E61626C65536561726368486973746F72793A21312C675375626D69744974656D7341727261793A5B5D2C67526573756C744C6973745468656D65436C6173733A22222C6749636F';
wwv_flow_imp.g_varchar2_table(16) := '6E5468656D65436C6173733A22222C6753686F7750726F63657373696E673A21312C67506C616365486F6C64657249636F6E3A22612D49636F6E2069636F6E2D736561726368222C67576169745370696E6E6572243A6E756C6C2C6744656661756C7454';
wwv_flow_imp.g_varchar2_table(17) := '6578743A6E756C6C2C67446174614368756E6B65643A5B5D2C676368756E6B53697A653A3565342C674170704C696D69743A6E756C6C2C766665746368537461727454696D653A6E657720446174652C726573746F72654F72696749636F6E3A66756E63';
wwv_flow_imp.g_varchar2_table(18) := '74696F6E28297B2428222E7064742D73706F746C696768742D6465766261722D656E74727922292E72656D6F7665436C617373282266612D72656672657368207064742D7072656665746368696E672066612D616E696D2D7370696E22292E616464436C';
wwv_flow_imp.g_varchar2_table(19) := '617373282266612D77696E646F772D6172726F772D757022297D2C67657453706F746C69676874446174614368756E6B65643A66756E6374696F6E28742C652C61297B617065782E7365727665722E706C7567696E286170657853706F746C696768742E';
wwv_flow_imp.g_varchar2_table(20) := '67416A61784964656E7469666965722C7B706167654974656D733A6170657853706F746C696768742E675375626D69744974656D7341727261792C7830313A224745545F44415441222C7830323A7064742E6F70742E6170706C69636174696F6E47726F';
wwv_flow_imp.g_varchar2_table(21) := '75704E616D652C7830333A652C7830343A612C7830353A6170657853706F746C696768742E674170704C696D69747D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2869297B76617220703D692E6C656E6774683B';
wwv_flow_imp.g_varchar2_table(22) := '617065782E64656275672E696E666F28225044543A204665746368656420506167652052616E6765205B222B652B222D222B28652B702D31292B225D206F6620222B702B2220726F7728732922292C6170657853706F746C696768742E67446174614368';
wwv_flow_imp.g_varchar2_table(23) := '756E6B65642E70757368282E2E2E69292C703D3D6170657853706F746C696768742E676368756E6B53697A653F6170657853706F746C696768742E67657453706F746C69676874446174614368756E6B656428742C652B6170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(24) := '2E676368756E6B53697A652C612B6170657853706F746C696768742E676368756E6B53697A65293A28693D6170657853706F746C696768742E67446174614368756E6B65642C7064742E756E436C6F616B44656275674C6576656C28292C7064742E6F70';
wwv_flow_imp.g_varchar2_table(25) := '742E73706F746C696768745072656665746368696E673D21312C6170657853706F746C696768742E726573746F72654F72696749636F6E28292C617065782E6576656E742E747269676765722822626F6479222C227064742D6170657873706F746C6967';
wwv_flow_imp.g_varchar2_table(26) := '68742D616A61782D73756363657373222C69292C6170657853706F746C696768742E67456E61626C6544617461436163686526266170657853706F746C696768742E73657453706F746C696768744461746153657373696F6E53746F72616765284A534F';
wwv_flow_imp.g_varchar2_table(27) := '4E2E737472696E67696679286929292C6170657853706F746C696768742E68696465576169745370696E6E657228292C74286929297D2C6572726F723A66756E6374696F6E28652C612C69297B7064742E756E436C6F616B44656275674C6576656C2829';
wwv_flow_imp.g_varchar2_table(28) := '2C7064742E6F70742E73706F746C696768745072656665746368696E673D21312C6170657853706F746C696768742E726573746F72654F72696749636F6E28292C617065782E6576656E742E747269676765722822626F6479222C227064742D61706578';
wwv_flow_imp.g_varchar2_table(29) := '73706F746C696768742D616A61782D6572726F72222C7B6D6573736167653A697D292C617065782E64656275672E696E666F28226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C69292C6170';
wwv_flow_imp.g_varchar2_table(30) := '657853706F746C696768742E68696465576169745370696E6E657228292C74285B5D297D7D297D2C67657453706F746C69676874446174613A66756E6374696F6E2874297B76617220653B6966286170657853706F746C696768742E67456E61626C6544';
wwv_flow_imp.g_varchar2_table(31) := '6174614361636865262628653D6170657853706F746C696768742E67657453706F746C696768744461746153657373696F6E53746F7261676528292C65292972657475726E207064742E6F70742E73706F746C696768745072656665746368696E673D21';
wwv_flow_imp.g_varchar2_table(32) := '312C6170657853706F746C696768742E726573746F72654F72696749636F6E28292C766F69642074284A534F4E2E7061727365286529293B7472797B6170657853706F746C696768742E73686F77576169745370696E6E657228292C7064742E636C6F61';
wwv_flow_imp.g_varchar2_table(33) := '6B44656275674C6576656C28292C617065782E64656275672E696E666F2822504454204665746368696E6720446174612E2E2E22292C6170657853706F746C696768742E67657453706F746C69676874446174614368756E6B656428742C312C61706578';
wwv_flow_imp.g_varchar2_table(34) := '53706F746C696768742E676368756E6B53697A65297D63617463682865297B7064742E756E436C6F616B44656275674C6576656C28292C7064742E6F70742E73706F746C696768745072656665746368696E673D21312C6170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(35) := '2E726573746F72654F72696749636F6E28292C617065782E6576656E742E747269676765722822626F6479222C227064742D6170657873706F746C696768742D616A61782D6572726F72222C7B6D6573736167653A657D292C617065782E64656275672E';
wwv_flow_imp.g_varchar2_table(36) := '696E666F28226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C65292C6170657853706F746C696768742E68696465576169745370696E6E657228292C74285B5D297D7D2C67657450726F7065';
wwv_flow_imp.g_varchar2_table(37) := '724170657855726C3A66756E6374696F6E28742C65297B7472797B7064742E636C6F616B44656275674C6576656C28292C617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965722C7B78';
wwv_flow_imp.g_varchar2_table(38) := '30313A224745545F55524C222C7830323A6170657853706F746C696768742E674B6579776F7264732C7830333A747D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2874297B7064742E756E436C6F616B44656275';
wwv_flow_imp.g_varchar2_table(39) := '674C6576656C28292C617065782E64656275672E696E666F28226170657853706F746C696768742E67657450726F7065724170657855726C20414A41582053756363657373222C74292C652874297D2C6572726F723A66756E6374696F6E28612C692C70';
wwv_flow_imp.g_varchar2_table(40) := '297B7064742E756E436C6F616B44656275674C6576656C28292C617065782E64656275672E696E666F28226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C70292C65287B75726C3A747D297D';
wwv_flow_imp.g_varchar2_table(41) := '7D297D63617463682861297B7064742E756E436C6F616B44656275674C6576656C28292C617065782E64656275672E696E666F28226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C61292C65';
wwv_flow_imp.g_varchar2_table(42) := '287B75726C3A747D297D7D2C73657453706F746C696768744461746153657373696F6E53746F726167653A66756E6374696F6E2874297B76617220653D617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F72742829';
wwv_flow_imp.g_varchar2_table(43) := '3B69662865297B76617220613D2476282270496E7374616E636522292C693D617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A227064744170657853706F746C69676874222C7573654170';
wwv_flow_imp.g_varchar2_table(44) := '7049643A21307D293B666F72286C6574207420696E20692E5F73746F726529742E656E647357697468282270647453706F746C69676874446174612229262628743D742E7265706C616365282F5E7064744170657853706F746C696768745C2E2F2C2222';
wwv_flow_imp.g_varchar2_table(45) := '292C692E72656D6F76654974656D287429293B636F6E737420653D70616B6F2E6465666C617465284A534F4E2E737472696E67696679287429292C703D34363635362C6F3D5B5D3B666F72286C657420743D303B743C652E6C656E6774683B742B3D7029';
wwv_flow_imp.g_varchar2_table(46) := '7B636F6E737420613D652E736C69636528742C742B70292C693D62746F6128537472696E672E66726F6D43686172436F64652E6170706C79286E756C6C2C6129293B6F2E707573682869297D636F6E7374206C3D6F2E6A6F696E282222293B692E736574';
wwv_flow_imp.g_varchar2_table(47) := '4974656D28612B222E70647453706F746C6967687444617461222C6C297D7D2C67657453706F746C696768744461746153657373696F6E53746F726167653A66756E6374696F6E28297B76617220742C653D617065782E73746F726167652E6861735365';
wwv_flow_imp.g_varchar2_table(48) := '7373696F6E53746F72616765537570706F727428293B69662865297B76617220613D2476282270496E7374616E636522292C693D617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A227064';
wwv_flow_imp.g_varchar2_table(49) := '744170657853706F746C69676874222C75736541707049643A21307D293B696628656E6353746F7261676556616C75653D692E6765744974656D28612B222E70647453706F746C696768744461746122292C656E6353746F7261676556616C7565297B63';
wwv_flow_imp.g_varchar2_table(50) := '6F6E737420653D61746F6228656E6353746F7261676556616C7565292C613D652E73706C6974282222292E6D61702866756E6374696F6E2874297B72657475726E20742E63686172436F646541742830297D292C693D6E65772055696E74384172726179';
wwv_flow_imp.g_varchar2_table(51) := '2861293B743D4A534F4E2E70617273652870616B6F2E696E666C61746528692C7B746F3A22737472696E67227D29297D7D72657475726E20747D2C73657453706F746C69676874486973746F72794C6F63616C53746F726167653A66756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(52) := '74297B76617220653D617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F727428292C613D5B5D2C693D66756E6374696F6E2874297B76617220653D7B7D3B72657475726E20742E666F72456163682866756E6374696F6E';
wwv_flow_imp.g_varchar2_table(53) := '2874297B655B745D7C7C28655B745D3D2130297D292C4F626A6563742E6B6579732865297D2C703D66756E6374696F6E2874297B666F722876617220653D303B653C742E6C656E6774683B652B2B29653E33302626742E73706C69636528652C31293B72';
wwv_flow_imp.g_varchar2_table(54) := '657475726E20747D3B69662869734E614E287429262628613D6170657853706F746C696768742E67657453706F746C69676874486973746F72794C6F63616C53746F7261676528292C612E756E736869667428742E7472696D2829292C613D692861292C';
wwv_flow_imp.g_varchar2_table(55) := '613D702861292C6529297B766172206F3D617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A21307D293B6F2E7365744974656D28';
wwv_flow_imp.g_varchar2_table(56) := '6170657853706F746C696768742E6744796E616D6963416374696F6E49642B222E686973746F7279222C4A534F4E2E737472696E67696679286129297D7D2C67657453706F746C69676874486973746F72794C6F63616C53746F726167653A66756E6374';
wwv_flow_imp.g_varchar2_table(57) := '696F6E28297B76617220742C653D617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F727428292C613D5B5D3B69662865297B76617220693D617065782E73746F726167652E67657453636F7065644C6F63616C53746F72';
wwv_flow_imp.g_varchar2_table(58) := '616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A21307D293B743D692E6765744974656D286170657853706F746C696768742E6744796E616D6963416374696F6E49642B222E686973746F727922292C742626';
wwv_flow_imp.g_varchar2_table(59) := '28613D4A534F4E2E7061727365287429297D72657475726E20617D2C72656D6F766553706F746C69676874486973746F72794C6F63616C53746F726167653A66756E6374696F6E28297B76617220743D617065782E73746F726167652E6861734C6F6361';
wwv_flow_imp.g_varchar2_table(60) := '6C53746F72616765537570706F727428293B69662874297B76617220653D617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A2130';
wwv_flow_imp.g_varchar2_table(61) := '7D293B652E72656D6F76654974656D286170657853706F746C696768742E6744796E616D6963416374696F6E49642B222E686973746F727922297D7D2C73686F775469707079486973746F7279506F706F7665723A66756E6374696F6E28297B76617220';
wwv_flow_imp.g_varchar2_table(62) := '743D6170657853706F746C696768742E67657453706F746C69676874486973746F72794C6F63616C53746F7261676528297C7C5B5D2C653D22222C613D303B696628742E6C656E6774683E30297B6170657853706F746C696768742E64657374726F7954';
wwv_flow_imp.g_varchar2_table(63) := '69707079486973746F7279506F706F76657228292C2428226469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E22292E6373732822637572736F72222C22706F696E74657222292C652B3D273C756C20636C6173733D2273706F';
wwv_flow_imp.g_varchar2_table(64) := '746C696768742D686973746F72792D6C697374223E273B666F722876617220693D303B693C742E6C656E677468262628652B3D273C6C693E3C6120636C6173733D2273706F746C696768742D686973746F72792D6C696E6B2220687265663D226A617661';
wwv_flow_imp.g_varchar2_table(65) := '7363726970743A7064742E6170657853706F746C696768742E736574486973746F727953656172636856616C7565285C27272B617065782E7574696C2E65736361706548544D4C28745B695D292B2227293B5C223E222B617065782E7574696C2E657363';
wwv_flow_imp.g_varchar2_table(66) := '61706548544D4C28745B695D292B223C2F613E3C2F6C693E222C612B3D312C2128613E3D323029293B692B2B293B652B3D273C6C693E3C6120636C6173733D2273706F746C696768742D686973746F72792D64656C6574652220687265663D226A617661';
wwv_flow_imp.g_varchar2_table(67) := '7363726970743A766F69642830293B223E3C693E272B6170657853706F746C696768742E67536561726368486973746F727944656C657465546578742B223C2F693E3C2F613E3C2F6C693E222C652B3D223C2F756C3E222C746970707928242822646976';
wwv_flow_imp.g_varchar2_table(68) := '2E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E22295B305D2C7B636F6E74656E743A652C696E7465726163746976653A21302C6172726F773A21302C706C6163656D656E743A2272696768742D656E64222C616E696D6174654669';
wwv_flow_imp.g_varchar2_table(69) := '6C6C3A21317D292C242822626F647922292E6F6E2822636C69636B222C22612E73706F746C696768742D686973746F72792D6C696E6B222C66756E6374696F6E28297B6170657853706F746C696768742E686964655469707079486973746F7279506F70';
wwv_flow_imp.g_varchar2_table(70) := '6F76657228297D292C242822626F647922292E6F6E2822636C69636B222C22612E73706F746C696768742D686973746F72792D64656C657465222C66756E6374696F6E28297B6170657853706F746C696768742E64657374726F79546970707948697374';
wwv_flow_imp.g_varchar2_table(71) := '6F7279506F706F76657228292C6170657853706F746C696768742E72656D6F766553706F746C69676874486973746F72794C6F63616C53746F7261676528297D297D7D2C686964655469707079486973746F7279506F706F7665723A66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(72) := '28297B76617220743D2428226469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E22295B305D3B742626742E5F74697070792626742E5F74697070792E6869646528297D2C64657374726F795469707079486973746F7279506F';
wwv_flow_imp.g_varchar2_table(73) := '706F7665723A66756E6374696F6E28297B76617220743D2428226469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E22295B305D3B742626742E5F74697070792626742E5F74697070792E64657374726F7928292C2428617065';
wwv_flow_imp.g_varchar2_table(74) := '7853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E666F63757328297D2C73686F77576169745370696E6E65723A66756E6374696F6E28297B6170657853706F746C696768742E6753686F7750726F636573';
wwv_flow_imp.g_varchar2_table(75) := '73696E6726262428226469762E7064742D6170782D53706F746C696768742D69636F6E2D6D61696E207370616E22292E70726F702822636C6173734E616D65222C2222292E616464436C617373282266612066612D726566726573682066612D616E696D';
wwv_flow_imp.g_varchar2_table(76) := '2D7370696E22297D2C68696465576169745370696E6E65723A66756E6374696F6E28297B6170657853706F746C696768742E6753686F7750726F63657373696E6726262428226469762E7064742D6170782D53706F746C696768742D69636F6E2D6D6169';
wwv_flow_imp.g_varchar2_table(77) := '6E207370616E22292E70726F702822636C6173734E616D65222C2222292E616464436C617373286170657853706F746C696768742E67506C616365486F6C64657249636F6E297D2C67657453656C6563746564546578743A66756E6374696F6E28297B76';
wwv_flow_imp.g_varchar2_table(78) := '617220743B72657475726E2077696E646F772E67657453656C656374696F6E3F28743D77696E646F772E67657453656C656374696F6E28292C742E746F537472696E6728292E7472696D2829293A646F63756D656E742E73656C656374696F6E2E637265';
wwv_flow_imp.g_varchar2_table(79) := '61746552616E67653F28743D646F63756D656E742E73656C656374696F6E2E63726561746552616E676528292C742E746578742E7472696D2829293A766F696420307D2C73657453656C6563746564546578743A66756E6374696F6E2874297B76617220';
wwv_flow_imp.g_varchar2_table(80) := '653B653D747C7C6170657853706F746C696768742E67657453656C65637465645465787428292C652626286170657853706F746C696768742E674861734469616C6F67437265617465643F24286170657853706F746C696768742E444F542B6170657853';
wwv_flow_imp.g_varchar2_table(81) := '706F746C696768742E53505F494E505554292E76616C2865292E747269676765722822696E70757422293A242822626F647922292E6F6E28227064742D6170657873706F746C696768742D6765742D64617461222C66756E6374696F6E28297B24286170';
wwv_flow_imp.g_varchar2_table(82) := '657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E76616C2865292E747269676765722822696E70757422297D29297D2C72656469726563743A66756E6374696F6E2874297B6966286170657853706F74';
wwv_flow_imp.g_varchar2_table(83) := '6C696768742E6753686F7750726F63657373696E67297472797B742E7374617274735769746828226A6176617363726970743A22293F617065782E6E617669676174696F6E2E72656469726563742874293A28303D3D2428227370616E2E752D50726F63';
wwv_flow_imp.g_varchar2_table(84) := '657373696E6722292E6C656E6774682626742E737461727473576974682822663F703D22292626617065782E706167652E76616C69646174652829262621617065782E706167652E69734368616E67656428292626286170657853706F746C696768742E';
wwv_flow_imp.g_varchar2_table(85) := '67576169745370696E6E6572243D617065782E7574696C2E73686F775370696E6E657228242822626F6479222929292C617065782E6E617669676174696F6E2E7265646972656374287429297D63617463682865297B6170657853706F746C696768742E';
wwv_flow_imp.g_varchar2_table(86) := '67576169745370696E6E65722426266170657853706F746C696768742E67576169745370696E6E6572242E72656D6F766528292C617065782E6E617669676174696F6E2E72656469726563742874297D656C736520617065782E6E617669676174696F6E';
wwv_flow_imp.g_varchar2_table(87) := '2E72656469726563742874297D2C68616E646C6541726961417474723A66756E6374696F6E28297B76617220743D24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F524553554C5453292C653D242861706578';
wwv_flow_imp.g_varchar2_table(88) := '53706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292C613D742E66696E64286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F414354495645292E66696E64286170657853';
wwv_flow_imp.g_varchar2_table(89) := '706F746C696768742E444F542B6170657853706F746C696768742E53505F524553554C545F4C4142454C292E617474722822696422292C693D24282223222B61292C703D692E7465787428292C6F3D742E66696E6428226C6922292C6C3D30213D3D6F2E';
wwv_flow_imp.g_varchar2_table(90) := '6C656E6774682C723D22222C673D6F2E66696C7465722866756E6374696F6E28297B72657475726E20303D3D3D242874686973292E66696E64286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F53484F52544355';
wwv_flow_imp.g_varchar2_table(91) := '54292E6C656E6774687D292E6C656E6774683B24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F524553554C545F4C4142454C292E617474722822617269612D73656C6563746564222C2266616C736522292C';
wwv_flow_imp.g_varchar2_table(92) := '692E617474722822617269612D73656C6563746564222C227472756522292C22223D3D3D6170657853706F746C696768742E674B6579776F7264733F723D6170657853706F746C696768742E674D6F72654368617273546578743A303D3D3D673F723D61';
wwv_flow_imp.g_varchar2_table(93) := '70657853706F746C696768742E674E6F4D61746368546578743A313D3D3D673F723D6170657853706F746C696768742E674F6E654D61746368546578743A673E31262628723D672B2220222B6170657853706F746C696768742E674D756C7469706C654D';
wwv_flow_imp.g_varchar2_table(94) := '61746368657354657874292C723D702B222C20222B722C24282223222B6170657853706F746C696768742E53505F4C4956455F524547494F4E292E746578742872292C652E617474722822617269612D61637469766564657363656E64616E74222C6129';
wwv_flow_imp.g_varchar2_table(95) := '2E617474722822617269612D657870616E646564222C6C297D2C636C6F73654469616C6F673A66756E6374696F6E28297B24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292E6469616C6F67';
wwv_flow_imp.g_varchar2_table(96) := '2822636C6F736522297D2C726573657453706F746C696768743A66756E6374696F6E28297B24282223222B6170657853706F746C696768742E53505F4C495354292E656D70747928292C24286170657853706F746C696768742E444F542B617065785370';
wwv_flow_imp.g_varchar2_table(97) := '6F746C696768742E53505F494E505554292E76616C282222292C6170657853706F746C696768742E674B6579776F7264733D22222C6170657853706F746C696768742E68616E646C65417269614174747228297D2C676F546F3A66756E6374696F6E2874';
wwv_flow_imp.g_varchar2_table(98) := '2C65297B76617220613D742E64617461282275726C22292C693D742E6461746128227479706522293B7377697463682869297B63617365206170657853706F746C696768742E55524C5F54595045532E736561726368506167653A6170657853706F746C';
wwv_flow_imp.g_varchar2_table(99) := '696768742E696E5061676553656172636828293B627265616B3B63617365206170657853706F746C696768742E55524C5F54595045532E72656469726563743A612E696E636C7564657328227E5345415243485F56414C55457E22293F28617065785370';
wwv_flow_imp.g_varchar2_table(100) := '6F746C696768742E674B6579776F7264733D6170657853706F746C696768742E674B6579776F7264732E7265706C616365282F3A7C2C7C227C272F672C222022292E7472696D28292C612E737461727473576974682822663F703D22293F617065785370';
wwv_flow_imp.g_varchar2_table(101) := '6F746C696768742E67657450726F7065724170657855726C28612C66756E6374696F6E2874297B6170657853706F746C696768742E726564697265637428742E75726C297D293A28613D612E7265706C61636528227E5345415243485F56414C55457E22';
wwv_flow_imp.g_varchar2_table(102) := '2C6170657853706F746C696768742E674B6579776F726473292C6170657853706F746C696768742E726564697265637428612929293A612E696E636C7564657328227E57494E444F577E22293F28613D652E6374726C4B65797C7C652E6D6574614B6579';
wwv_flow_imp.g_varchar2_table(103) := '3F612E7265706C61636528227E57494E444F577E222C227472756522293A612E7265706C61636528227E57494E444F577E222C2266616C736522292C6170657853706F746C696768742E7265646972656374286129293A6170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(104) := '2E72656469726563742861297D6170657853706F746C696768742E636C6F73654469616C6F6728297D2C6765744D61726B75703A66756E6374696F6E2874297B76617220652C613D742E7469746C652C693D742E646573637C7C22222C703D742E75726C';
wwv_flow_imp.g_varchar2_table(105) := '2C6F3D742E747970652C6C3D742E69636F6E2C723D742E69636F6E436F6C6F722C673D742E73686F72746375742C6E3D742E7374617469632C733D673F273C7370616E20636C6173733D22272B6170657853706F746C696768742E53505F53484F525443';
wwv_flow_imp.g_varchar2_table(106) := '55542B2722203E272B672B223C2F7370616E3E223A22222C683D22222C533D22222C633D22222C643D22223B72657475726E28303D3D3D707C7C7029262628683D27646174612D75726C3D22272B702B27222027292C6F262628683D682B272064617461';
wwv_flow_imp.g_varchar2_table(107) := '2D747970653D22272B6F2B27222027292C533D6C2E73746172747357697468282266612D22293F22666120222B6C3A6C2E73746172747357697468282269636F6E2D22293F22612D49636F6E20222B6C3A22612D49636F6E2069636F6E2D736561726368';
wwv_flow_imp.g_varchar2_table(108) := '222C633D6E3F22535441544943223A2244594E414D4943222C72262628643D277374796C653D226261636B67726F756E642D636F6C6F723A272B722B272227292C653D273C6C6920636C6173733D227064742D6170782D53706F746C696768742D726573';
wwv_flow_imp.g_varchar2_table(109) := '756C7420272B6170657853706F746C696768742E67526573756C744C6973745468656D65436C6173732B22207064742D6170782D53706F746C696768742D726573756C742D2D70616765207064742D6170782D53706F746C696768742D222B632B27223E';
wwv_flow_imp.g_varchar2_table(110) := '3C7370616E20636C6173733D227064742D6170782D53706F746C696768742D6C696E6B2220272B682B273E3C7370616E20636C6173733D227064742D6170782D53706F746C696768742D69636F6E20272B6170657853706F746C696768742E6749636F6E';
wwv_flow_imp.g_varchar2_table(111) := '5468656D65436C6173732B272220272B642B2720617269612D68696464656E3D2274727565223E3C7370616E20636C6173733D22272B532B27223E3C2F7370616E3E3C2F7370616E3E3C7370616E20636C6173733D227064742D6170782D53706F746C69';
wwv_flow_imp.g_varchar2_table(112) := '6768742D696E666F223E3C7370616E20636C6173733D22272B6170657853706F746C696768742E53505F524553554C545F4C4142454C2B272220726F6C653D226F7074696F6E223E272B612B273C2F7370616E3E3C7370616E20636C6173733D22706474';
wwv_flow_imp.g_varchar2_table(113) := '2D6170782D53706F746C696768742D64657363206D617267696E2D746F702D736D223E272B692B223C2F7370616E3E3C2F7370616E3E222B732B223C2F7370616E3E3C2F6C693E222C657D2C726573756C74734164644F6E733A66756E6374696F6E2874';
wwv_flow_imp.g_varchar2_table(114) := '297B76617220653D303B6170657853706F746C696768742E67456E61626C65496E50616765536561726368262628742E70757368287B6E3A6170657853706F746C696768742E67496E50616765536561726368546578742C753A22222C693A6170657853';
wwv_flow_imp.g_varchar2_table(115) := '706F746C696768742E49434F4E532E706167652C69633A6E756C6C2C743A6170657853706F746C696768742E55524C5F54595045532E736561726368506167652C73686F72746375743A224374726C202B2031222C733A21307D292C652B3D31293B666F';
wwv_flow_imp.g_varchar2_table(116) := '722876617220613D303B613C6170657853706F746C696768742E67537461746963496E6465782E6C656E6774683B612B2B29652B3D312C653E393F742E70757368287B6E3A6170657853706F746C696768742E67537461746963496E6465785B615D2E6E';
wwv_flow_imp.g_varchar2_table(117) := '2C643A6170657853706F746C696768742E67537461746963496E6465785B615D2E642C753A6170657853706F746C696768742E67537461746963496E6465785B615D2E752C693A6170657853706F746C696768742E67537461746963496E6465785B615D';
wwv_flow_imp.g_varchar2_table(118) := '2E692C69633A6170657853706F746C696768742E67537461746963496E6465785B615D2E69632C743A6170657853706F746C696768742E67537461746963496E6465785B615D2E742C733A6170657853706F746C696768742E67537461746963496E6465';
wwv_flow_imp.g_varchar2_table(119) := '785B615D2E737D293A742E70757368287B6E3A6170657853706F746C696768742E67537461746963496E6465785B615D2E6E2C643A6170657853706F746C696768742E67537461746963496E6465785B615D2E642C753A6170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(120) := '2E67537461746963496E6465785B615D2E752C693A6170657853706F746C696768742E67537461746963496E6465785B615D2E692C69633A6170657853706F746C696768742E67537461746963496E6465785B615D2E69632C743A6170657853706F746C';
wwv_flow_imp.g_varchar2_table(121) := '696768742E67537461746963496E6465785B615D2E742C733A6170657853706F746C696768742E67537461746963496E6465785B615D2E732C73686F72746375743A224374726C202B20222B657D293B72657475726E20747D2C7365617263684E61763A';
wwv_flow_imp.g_varchar2_table(122) := '66756E6374696F6E2874297B76617220652C612C693D5B5D2C703D21312C6F3D742E6C656E6774682C6C3D24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E76616C28292E7472696D28292C';
wwv_flow_imp.g_varchar2_table(123) := '723D223A222B617065782E6974656D282252305F53504F544C494748545F46494C54455222292E67657456616C756528292B223A222C673D66756E6374696F6E28297B72657475726E20703F693A6170657853706F746C696768742E6753656172636849';
wwv_flow_imp.g_varchar2_table(124) := '6E6465787D2C6E3D66756E6374696F6E28742C652C61297B76617220692C703D3130302C6F3D652D313B72657475726E20303D3D3D742626303D3D3D6F3F703A28693D612E696E6465784F66286170657853706F746C696768742E674B6579776F726473';
wwv_flow_imp.g_varchar2_table(125) := '292C2D313D3D3D693F703D702D742D6F2D653A702D3D692C70297D3B666F7228613D303B613C742E6C656E6774683B612B2B29653D745B615D2C693D6728292E66696C7465722866756E6374696F6E28742C61297B76617220693D742E6E2E746F4C6F77';
wwv_flow_imp.g_varchar2_table(126) := '65724361736528292C703D742E632C673D742E782C733D692E73706C697428222022292E6C656E6774682C683D692E7365617263682865293B6966286C3D3D672972657475726E21303B6966286F3E732972657475726E21313B69662821702E696E636C';
wwv_flow_imp.g_varchar2_table(127) := '756465732872292972657475726E21313B696628683E2D31297B696628742E73636F72653D6E28682C732C69292C617065782972657475726E21307D656C736520696628742E742626742E742E7365617263682865293E2D312972657475726E20742E73';
wwv_flow_imp.g_varchar2_table(128) := '636F72653D312C21307D292E736F72742866756E6374696F6E28742C65297B72657475726E20652E73636F72652D742E73636F72657D292C703D21303B76617220733D66756E6374696F6E2874297B76617220652C612C692C702C6F2C6C2C722C673D22';
wwv_flow_imp.g_varchar2_table(129) := '222C6E3D7B7D3B666F7228742E6C656E6774683E6170657853706F746C696768742E674D61784E6176526573756C74262628742E6C656E6774683D6170657853706F746C696768742E674D61784E6176526573756C74292C653D303B653C742E6C656E67';
wwv_flow_imp.g_varchar2_table(130) := '74683B652B2B29613D745B655D2C703D612E73686F72746375746C696E6B2C693D612E747C7C6170657853706F746C696768742E55524C5F54595045532E72656469726563742C6F3D612E697C7C6170657853706F746C696768742E49434F4E532E7365';
wwv_flow_imp.g_varchar2_table(131) := '617263682C723D612E737C7C21312C2244454641554C5422213D3D612E69632626286C3D612E6963292C6E3D7B7469746C653A612E6E2C646573633A612E642C75726C3A612E752C69636F6E3A6F2C69636F6E436F6C6F723A6C2C747970653A692C7374';
wwv_flow_imp.g_varchar2_table(132) := '617469633A727D2C702626286E2E73686F72746375743D70292C672B3D6170657853706F746C696768742E6765744D61726B7570286E293B72657475726E20677D3B72657475726E2073286170657853706F746C696768742E726573756C74734164644F';
wwv_flow_imp.g_varchar2_table(133) := '6E73286929297D2C7365617263683A66756E6374696F6E2874297B76617220653D227064742D73702D726573756C742D223B6170657853706F746C696768742E674B6579776F7264733D742E7472696D28293B76617220612C692C703D6170657853706F';
wwv_flow_imp.g_varchar2_table(134) := '746C696768742E674B6579776F7264732E73706C697428222022292C6F3D2824286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F524553554C5453292C5B5D293B666F7228693D303B693C702E6C656E6774683B';
wwv_flow_imp.g_varchar2_table(135) := '692B2B296F2E70757368286E6577205265674578702822283F3C213C2F3F5B612D7A5D5B5E3E5D2A3F3E2928222B617065782E7574696C2E65736361706552656745787028705B695D292B2229283F215B5E3C5D2A3F3E29222C2267692229293B613D61';
wwv_flow_imp.g_varchar2_table(136) := '70657853706F746C696768742E7365617263684E6176286F292C24282223222B6170657853706F746C696768742E53505F4C495354292E68746D6C2861292E66696E6428226C6922292E656163682866756E6374696F6E2874297B76617220613D242874';
wwv_flow_imp.g_varchar2_table(137) := '686973293B612E66696E64286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F524553554C545F4C4142454C292E6174747228226964222C652B74297D292E666972737428292E616464436C617373286170657853';
wwv_flow_imp.g_varchar2_table(138) := '706F746C696768742E53505F414354495645297D2C63726561746553706F746C696768744469616C6F673A66756E6374696F6E2870506C616365486F6C646572297B766172206372656174654469616C6F673D66756E6374696F6E28297B66756E637469';
wwv_flow_imp.g_varchar2_table(139) := '6F6E20656C6C6973707365735472696D28742C65297B72657475726E20742E6C656E6774683C3D653F743A742E73756273747228302C652D33292B222E2E2E227D76617220766965774865696768742C6C696E654865696768742C76696577546F702C72';
wwv_flow_imp.g_varchar2_table(140) := '6F7773506572566965772C696E6974486569676874733D66756E6374696F6E28297B69662824286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292E6C656E6774683E30297B76617220743D2428';
wwv_flow_imp.g_varchar2_table(141) := '226469762E7064742D6170782D53706F746C696768742D726573756C747322293B766965774865696768743D742E6F7574657248656967687428292C6C696E654865696768743D2428226C692E7064742D6170782D53706F746C696768742D726573756C';
wwv_flow_imp.g_varchar2_table(142) := '7422292E6F7574657248656967687428292C76696577546F703D742E6F666673657428292E746F702C726F7773506572566965773D766965774865696768742F6C696E654865696768747D7D2C7363726F6C6C6564446F776E4F75744F66566965773D66';
wwv_flow_imp.g_varchar2_table(143) := '756E6374696F6E2874297B696628745B305D297B76617220653D742E6F666673657428292E746F703B72657475726E20653C307C7C653E766965774865696768747D7D2C7363726F6C6C656455704F75744F66566965773D66756E6374696F6E2874297B';
wwv_flow_imp.g_varchar2_table(144) := '696628745B305D297B76617220653D742E6F666673657428292E746F703B72657475726E20653E766965774865696768747C7C653C3D76696577546F707D7D2C6765744E6578743D66756E6374696F6E2874297B76617220652C613D742E66696E642861';
wwv_flow_imp.g_varchar2_table(145) := '70657853706F746C696768742E444F542B6170657853706F746C696768742E53505F414354495645292C693D612E696E64657828293B726F7773506572566965777C7C696E69744865696768747328292C21612E6C656E6774687C7C612E697328223A6C';
wwv_flow_imp.g_varchar2_table(146) := '6173742D6368696C6422293F28612E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292C742E66696E6428226C6922292E666972737428292E616464436C617373286170657853706F746C696768742E53505F41';
wwv_flow_imp.g_varchar2_table(147) := '4354495645292C742E616E696D617465287B7363726F6C6C546F703A307D29293A28653D612E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E6E65787428292E616464436C617373286170657853706F746C';
wwv_flow_imp.g_varchar2_table(148) := '696768742E53505F414354495645292C7363726F6C6C6564446F776E4F75744F66566965772865292626742E616E696D617465287B7363726F6C6C546F703A28692D726F7773506572566965772B32292A6C696E654865696768747D2C3029297D2C6765';
wwv_flow_imp.g_varchar2_table(149) := '74507265763D66756E6374696F6E2874297B76617220652C613D742E66696E64286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F414354495645292C693D612E696E64657828293B726F7773506572566965777C';
wwv_flow_imp.g_varchar2_table(150) := '7C696E69744865696768747328292C21742E6C656E6774687C7C612E697328223A66697273742D6368696C6422293F28612E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292C742E66696E6428226C6922292E';
wwv_flow_imp.g_varchar2_table(151) := '6C61737428292E616464436C617373286170657853706F746C696768742E53505F414354495645292C742E616E696D617465287B7363726F6C6C546F703A742E66696E6428226C6922292E6C656E6774682A6C696E654865696768747D29293A28653D61';
wwv_flow_imp.g_varchar2_table(152) := '2E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E7072657628292E616464436C617373286170657853706F746C696768742E53505F414354495645292C7363726F6C6C656455704F75744F66566965772865';
wwv_flow_imp.g_varchar2_table(153) := '292626742E616E696D617465287B7363726F6C6C546F703A28692D31292A6C696E654865696768747D2C3029297D3B242877696E646F77292E6F6E28226170657877696E646F77726573697A6564222C66756E6374696F6E28297B696E69744865696768';
wwv_flow_imp.g_varchar2_table(154) := '747328297D293B7661722073706F746C69676874526164696F46696C7465723D273C64697620636C6173733D22636F6E7461696E6572223E3C64697620636C6173733D22726F7720223E3C64697620636C6173733D22636F6C20636F6C2D313220617065';
wwv_flow_imp.g_varchar2_table(155) := '782D636F6C2D6175746F20636F6C2D737461727420636F6C2D656E64223E3C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E657220742D466F726D2D6669656C64436F6E7461696E65722D2D666C6F6174696E674C6162656C';
wwv_flow_imp.g_varchar2_table(156) := '20742D466F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E7075747320742D466F726D2D6669656C64436F6E7461696E65722D2D726164696F427574746F6E47726F757020617065782D6974656D2D777261707065722061706578';
wwv_flow_imp.g_varchar2_table(157) := '2D6974656D2D777261707065722D2D726164696F67726F757020222069643D2252305F53504F544C494748545F46494C5445525F434F4E5441494E4552223E3C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E6572223E3C2F';
wwv_flow_imp.g_varchar2_table(158) := '6469763E3C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E65722070616464696E672D6E6F6E65223E3C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C64697620746162696E6465783D222D';
wwv_flow_imp.g_varchar2_table(159) := '31222069643D2252305F53504F544C494748545F46494C5445522220617269612D6C6162656C6C656462793D2252305F53504F544C494748545F46494C5445525F4C4142454C2220636C6173733D22726164696F5F67726F757020617065782D6974656D';
wwv_flow_imp.g_varchar2_table(160) := '2D67726F757020617065782D6974656D2D67726F75702D2D726320617065782D6974656D2D726164696F206D617267696E2D746F702D6E6F6E65207064742D72657665616C65722D69676E6F72652220726F6C653D2267726F7570223E3C64697620636C';
wwv_flow_imp.g_varchar2_table(161) := '6173733D22617065782D6974656D2D6772696420726164696F5F67726F7570223E3C64697620636C6173733D22617065782D6974656D2D677269642D726F77223E3C64697620636C6173733D22617065782D6974656D2D6F7074696F6E223E3C696E7075';
wwv_flow_imp.g_varchar2_table(162) := '7420747970653D22726164696F222069643D2252305F53504F544C494748545F46494C5445525F3022206E616D653D2252305F53504F544C494748545F46494C5445522220646174612D646973706C61793D225468697320417070222076616C75653D22';
wwv_flow_imp.g_varchar2_table(163) := '4150502220636865636B65643D22636865636B6564223E3C6C6162656C20636C6173733D22752D726164696F2070616464696E672D746F702D6E6F6E652070616464696E672D626F74746F6D2D6E6F6E65207064742D7370742D6C626C2220666F723D22';
wwv_flow_imp.g_varchar2_table(164) := '52305F53504F544C494748545F46494C5445525F30223E54686973204170703C2F6C6162656C3E3C2F6469763E3C64697620636C6173733D22617065782D6974656D2D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2252';
wwv_flow_imp.g_varchar2_table(165) := '305F53504F544C494748545F46494C5445525F3122206E616D653D2252305F53504F544C494748545F46494C5445522220646174612D646973706C61793D22576F726B73706163652041707073222076616C75653D225753223E3C6C6162656C20636C61';
wwv_flow_imp.g_varchar2_table(166) := '73733D22752D726164696F2070616464696E672D746F702D6E6F6E652070616464696E672D626F74746F6D2D6E6F6E65207064742D7370742D6C626C2220666F723D2252305F53504F544C494748545F46494C5445525F31223E576F726B737061636520';
wwv_flow_imp.g_varchar2_table(167) := '417070733C2F6C6162656C3E3C2F6469763E3C64697620636C6173733D22617065782D6974656D2D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2252305F53504F544C494748545F46494C5445525F3222206E616D653D';
wwv_flow_imp.g_varchar2_table(168) := '2252305F53504F544C494748545F46494C5445522220646174612D646973706C61793D224170706C69636174696F6E2047726F7570222076616C75653D224147223E3C6C6162656C20636C6173733D22752D726164696F2070616464696E672D746F702D';
wwv_flow_imp.g_varchar2_table(169) := '6E6F6E652070616464696E672D626F74746F6D2D6E6F6E65207064742D7370742D6C626C2220666F723D2252305F53504F544C494748545F46494C5445525F32223E47726F75703A2025303C2F6C6162656C3E3C2F6469763E3C2F6469763E3C2F646976';
wwv_flow_imp.g_varchar2_table(170) := '3E3C2F6469763E3C2F6469763E3C7370616E2069643D2252305F53504F544C494748545F46494C5445525F6572726F725F706C616365686F6C6465722220636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D';
wwv_flow_imp.g_varchar2_table(171) := '22223E3C2F7370616E3E3C2F6469763E3C2F6469763E3C2F6469763E3C2F6469763E3C2F6469763E273B73706F746C69676874526164696F46696C7465723D617065782E6C616E672E666F726D61744E6F4573636170652873706F746C69676874526164';
wwv_flow_imp.g_varchar2_table(172) := '696F46696C7465722C656C6C6973707365735472696D287064742E6F70742E6170706C69636174696F6E47726F75704E616D652C343029292C242822626F647922292E617070656E6428273C64697620636C6173733D22272B6170657853706F746C6967';
wwv_flow_imp.g_varchar2_table(173) := '68742E53505F4449414C4F472B272220646174612D69643D22272B6170657853706F746C696768742E6744796E616D6963416374696F6E49642B27223E3C64697620636C6173733D227064742D6170782D53706F746C696768742D626F6479223E3C6469';
wwv_flow_imp.g_varchar2_table(174) := '7620636C6173733D227064742D6170782D53706F746C696768742D686561646572223E272B73706F746C69676874526164696F46696C7465722B273C2F6469763E3C64697620636C6173733D227064742D6170782D53706F746C696768742D7365617263';
wwv_flow_imp.g_varchar2_table(175) := '68223E3C64697620636C6173733D227064742D6170782D53706F746C696768742D69636F6E207064742D6170782D53706F746C696768742D69636F6E2D6D61696E223E3C7370616E20636C6173733D22272B6170657853706F746C696768742E67506C61';
wwv_flow_imp.g_varchar2_table(176) := '6365486F6C64657249636F6E2B272220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F6469763E3C64697620636C6173733D227064742D6170782D53706F746C696768742D6669656C64223E3C696E70757420747970653D227465';
wwv_flow_imp.g_varchar2_table(177) := '78742220726F6C653D22636F6D626F626F782220617269612D657870616E6465643D2266616C73652220617269612D6175746F636F6D706C6574653D226E6F6E652220617269612D686173706F7075703D22747275652220617269612D6C6162656C3D22';
wwv_flow_imp.g_varchar2_table(178) := '53706F746C69676874205365617263682220617269612D6F776E733D22272B6170657853706F746C696768742E53505F4C4953542B2722206175746F636F6D706C6574653D226F666622206175746F636F72726563743D226F666622207370656C6C6368';
wwv_flow_imp.g_varchar2_table(179) := '65636B3D2266616C73652220636C6173733D22272B6170657853706F746C696768742E53505F494E5055542B272220706C616365686F6C6465723D22272B70506C616365486F6C6465722B27223E3C2F6469763E3C64697620726F6C653D22726567696F';
wwv_flow_imp.g_varchar2_table(180) := '6E2220636C6173733D22752D56697375616C6C7948696464656E2220617269612D6C6976653D22706F6C697465222069643D22272B6170657853706F746C696768742E53505F4C4956455F524547494F4E2B27223E3C2F6469763E3C2F6469763E3C6469';
wwv_flow_imp.g_varchar2_table(181) := '7620636C6173733D22272B6170657853706F746C696768742E53505F524553554C54532B27223E3C756C20636C6173733D227064742D6170782D53706F746C696768742D726573756C74734C697374222069643D22272B6170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(182) := '2E53505F4C4953542B272220746162696E6465783D222D312220726F6C653D226C697374626F78223E3C2F756C3E3C2F6469763E3C2F6469763E3C2F6469763E27292E6F6E2822696E707574222C6170657853706F746C696768742E444F542B61706578';
wwv_flow_imp.g_varchar2_table(183) := '53706F746C696768742E53505F494E5055542C66756E6374696F6E28297B76617220743D242874686973292E76616C28292E7472696D28292C653D742E6C656E6774683B303D3D3D653F6170657853706F746C696768742E726573657453706F746C6967';
wwv_flow_imp.g_varchar2_table(184) := '687428293A28653E3D317C7C2169734E614E28742929262674213D3D6170657853706F746C696768742E674B6579776F72647326266170657853706F746C696768742E7365617263682874297D292E6F6E28226368616E6765222C222352305F53504F54';
wwv_flow_imp.g_varchar2_table(185) := '4C494748545F46494C544552222C66756E6374696F6E2874297B6170657853706F746C696768742E7365617263682824286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E76616C28292E747269';
wwv_flow_imp.g_varchar2_table(186) := '6D2829292C24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E747269676765722822696E70757422297D292E6F6E28226B6579646F776E222C6170657853706F746C696768742E444F542B61';
wwv_flow_imp.g_varchar2_table(187) := '70657853706F746C696768742E53505F4449414C4F472C66756E6374696F6E2874297B76617220652C612C693D24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F524553554C5453293B73776974636828742E';
wwv_flow_imp.g_varchar2_table(188) := '7768696368297B63617365206170657853706F746C696768742E4B4559532E444F574E3A742E70726576656E7444656661756C7428292C6765744E6578742869293B627265616B3B63617365206170657853706F746C696768742E4B4559532E55503A74';
wwv_flow_imp.g_varchar2_table(189) := '2E70726576656E7444656661756C7428292C676574507265762869293B627265616B3B63617365206170657853706F746C696768742E4B4559532E454E5445523A742E70726576656E7444656661756C7428292C6170657853706F746C696768742E6745';
wwv_flow_imp.g_varchar2_table(190) := '6E61626C65536561726368486973746F727926266170657853706F746C696768742E73657453706F746C69676874486973746F72794C6F63616C53746F726167652824286170657853706F746C696768742E444F542B6170657853706F746C696768742E';
wwv_flow_imp.g_varchar2_table(191) := '53505F494E505554292E76616C2829292C6170657853706F746C696768742E676F546F28692E66696E6428226C692E69732D616374697665207370616E22292C74293B627265616B3B63617365206170657853706F746C696768742E4B4559532E544142';
wwv_flow_imp.g_varchar2_table(192) := '3A6170657853706F746C696768742E636C6F73654469616C6F6728297D696628742E6374726C4B6579297B73776974636828653D692E66696E64286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F53484F525443';
wwv_flow_imp.g_varchar2_table(193) := '5554292E706172656E7428292E67657428292C742E7768696368297B636173652034393A613D313B627265616B3B636173652035303A613D323B627265616B3B636173652035313A613D333B627265616B3B636173652035323A613D343B627265616B3B';
wwv_flow_imp.g_varchar2_table(194) := '636173652035333A613D353B627265616B3B636173652035343A613D363B627265616B3B636173652035353A613D373B627265616B3B636173652035363A613D383B627265616B3B636173652035373A613D397D6126266170657853706F746C69676874';
wwv_flow_imp.g_varchar2_table(195) := '2E676F546F282428655B612D315D292C74297D742E73686966744B65792626742E77686963683D3D3D6170657853706F746C696768742E4B4559532E54414226266170657853706F746C696768742E636C6F73654469616C6F6728292C6170657853706F';
wwv_flow_imp.g_varchar2_table(196) := '746C696768742E68616E646C65417269614174747228297D292E6F6E2822636C69636B222C227370616E2E7064742D6170782D53706F746C696768742D6C696E6B222C66756E6374696F6E2874297B6170657853706F746C696768742E67456E61626C65';
wwv_flow_imp.g_varchar2_table(197) := '536561726368486973746F727926266170657853706F746C696768742E73657453706F746C69676874486973746F72794C6F63616C53746F726167652824286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E';
wwv_flow_imp.g_varchar2_table(198) := '505554292E76616C2829292C6170657853706F746C696768742E676F546F28242874686973292C74297D292E6F6E28226D6F7573656D6F7665222C226C692E7064742D6170782D53706F746C696768742D726573756C74222C66756E6374696F6E28297B';
wwv_flow_imp.g_varchar2_table(199) := '76617220743D242874686973293B742E706172656E7428292E66696E64286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F414354495645292E72656D6F7665436C617373286170657853706F746C696768742E53';
wwv_flow_imp.g_varchar2_table(200) := '505F414354495645292C742E616464436C617373286170657853706F746C696768742E53505F414354495645297D292E6F6E2822626C7572222C6170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F472C';
wwv_flow_imp.g_varchar2_table(201) := '66756E6374696F6E2874297B24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292E6469616C6F67282269734F70656E2229262624286170657853706F746C696768742E444F542B6170657853';
wwv_flow_imp.g_varchar2_table(202) := '706F746C696768742E53505F494E505554292E666F63757328297D292E6F6E2822636C69636B222C222E7064742D6170782D53706F746C696768742D696E6C696E652D6C696E6B222C66756E6374696F6E2865297B636F6E73742075726C3D746869732E';
wwv_flow_imp.g_varchar2_table(203) := '67657441747472696275746528227064742D53706F746C696E6B2D75726C22293B72657475726E207064742E636C6F616B44656275674C6576656C28292C617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A6178';
wwv_flow_imp.g_varchar2_table(204) := '4964656E7469666965722C7B7830313A224745545F55524C222C7830323A75726C7D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2864617461297B6966287064742E756E436C6F616B44656275674C6576656C28';
wwv_flow_imp.g_varchar2_table(205) := '292C64617461297B76617220707265706172656455726C3D646174612E75726C3B696628707265706172656455726C2E7374617274735769746828226A6176617363726970743A2229297B6170657853706F746C696768742E636C6F73654469616C6F67';
wwv_flow_imp.g_varchar2_table(206) := '28293B636F6E737420636F64653D707265706172656455726C2E736C696365283131293B6576616C28636F6465297D656C73652077696E646F772E6C6F636174696F6E2E687265663D707265706172656455726C7D7D2C6572726F723A66756E6374696F';
wwv_flow_imp.g_varchar2_table(207) := '6E28742C652C61297B7064742E756E436C6F616B44656275674C6576656C28292C617065782E64656275672E696E666F2822706474206170657853706F746C69676874204745545F55524C222C61297D7D292C21317D292C24286170657853706F746C69';
wwv_flow_imp.g_varchar2_table(208) := '6768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292E6F6E28226B6579646F776E222C66756E6374696F6E2874297B76617220653D24286170657853706F746C696768742E444F542B6170657853706F746C696768742E5350';
wwv_flow_imp.g_varchar2_table(209) := '5F494E505554293B742E77686963683D3D3D6170657853706F746C696768742E4B4559532E455343415045262628652E76616C28293F286170657853706F746C696768742E726573657453706F746C6967687428292C742E73746F7050726F7061676174';
wwv_flow_imp.g_varchar2_table(210) := '696F6E2829293A6170657853706F746C696768742E636C6F73654469616C6F672829297D292C6170657853706F746C696768742E674861734469616C6F67437265617465643D21307D3B6372656174654469616C6F6728297D2C6F70656E53706F746C69';
wwv_flow_imp.g_varchar2_table(211) := '6768744469616C6F673A66756E6374696F6E2874297B69662877696E646F772E73656C66213D3D77696E646F772E746F702972657475726E21313B6170657853706F746C696768742E674861734469616C6F67437265617465643D24286170657853706F';
wwv_flow_imp.g_varchar2_table(212) := '746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292E6C656E6774683E302C6170657853706F746C696768742E674861734469616C6F6743726561746564262624286170657853706F746C696768742E444F542B6170';
wwv_flow_imp.g_varchar2_table(213) := '657853706F746C696768742E53505F4449414C4F47292E617474722822646174612D69642229213D6170657853706F746C696768742E6744796E616D6963416374696F6E49642626286170657853706F746C696768742E726573657453706F746C696768';
wwv_flow_imp.g_varchar2_table(214) := '7428292C24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292E72656D6F766528292C6170657853706F746C696768742E674861734469616C6F67437265617465643D2131292C617065785370';
wwv_flow_imp.g_varchar2_table(215) := '6F746C696768742E67456E61626C6550726566696C6C53656C65637465645465787426266170657853706F746C696768742E73657453656C65637465645465787428292C6170657853706F746C696768742E67456E61626C6544656661756C7454657874';
wwv_flow_imp.g_varchar2_table(216) := '2626286170657853706F746C696768742E73657453656C656374656454657874286170657853706F746C696768742E64656661756C7454657874292C242822626F647922292E7472696767657228227064742D6170657873706F746C696768742D676574';
wwv_flow_imp.g_varchar2_table(217) := '2D646174612229293B76617220653D66756E6374696F6E28297B76617220743D24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F4449414C4F47292C653D77696E646F772E7363726F6C6C597C7C77696E646F';
wwv_flow_imp.g_varchar2_table(218) := '772E70616765594F66667365743B742E686173436C617373282275692D6469616C6F672D636F6E74656E7422292626742E6469616C6F67282269734F70656E22297C7C742E6469616C6F67287B77696474683A6170657853706F746C696768742E675769';
wwv_flow_imp.g_varchar2_table(219) := '6474682C6865696768743A226175746F222C6D6F64616C3A21302C706F736974696F6E3A7B6D793A2263656E74657220746F70222C61743A2263656E74657220746F702B222B28652B3634292C6F663A242822626F647922297D2C6469616C6F67436C61';
wwv_flow_imp.g_varchar2_table(220) := '73733A2275692D6469616C6F672D2D7064742D6170657873706F746C69676874222C6F70656E3A66756E6374696F6E28297B617065782E6576656E742E747269676765722822626F6479222C227064742D6170657873706F746C696768742D6F70656E2D';
wwv_flow_imp.g_varchar2_table(221) := '6469616C6F6722293B76617220743D242874686973293B742E63737328226D696E2D686569676874222C226175746F22292E7072657628222E75692D6469616C6F672D7469746C6562617222292E72656D6F766528292C617065782E6E61766967617469';
wwv_flow_imp.g_varchar2_table(222) := '6F6E2E626567696E467265657A655363726F6C6C28292C6170657853706F746C696768742E67456E61626C65536561726368486973746F727926266170657853706F746C696768742E73686F775469707079486973746F7279506F706F76657228292C24';
wwv_flow_imp.g_varchar2_table(223) := '28222E75692D7769646765742D6F7665726C617922292E6F6E2822636C69636B222C66756E6374696F6E28297B6170657853706F746C696768742E636C6F73654469616C6F6728297D292C24286170657853706F746C696768742E444F542B6170657853';
wwv_flow_imp.g_varchar2_table(224) := '706F746C696768742E53505F494E505554292E666F63757328297D2C6372656174653A66756E6374696F6E28297B7D2C636C6F73653A66756E6374696F6E28297B617065782E6576656E742E747269676765722822626F6479222C227064742D61706578';
wwv_flow_imp.g_varchar2_table(225) := '73706F746C696768742D636C6F73652D6469616C6F6722292C6170657853706F746C696768742E726573657453706F746C6967687428292C617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28292C6170657853706F746C69';
wwv_flow_imp.g_varchar2_table(226) := '6768742E67456E61626C65536561726368486973746F727926266170657853706F746C696768742E64657374726F795469707079486973746F7279506F706F76657228297D7D297D3B6170657853706F746C696768742E674861734469616C6F67437265';
wwv_flow_imp.g_varchar2_table(227) := '617465643F6528293A286170657853706F746C696768742E63726561746553706F746C696768744469616C6F67286170657853706F746C696768742E67506C616365686F6C64657254657874292C6528292C6170657853706F746C696768742E67657453';
wwv_flow_imp.g_varchar2_table(228) := '706F746C69676874446174612866756E6374696F6E2874297B6170657853706F746C696768742E67536561726368496E6465783D242E6772657028742C66756E6374696F6E2874297B72657475726E20303D3D742E737D292C6170657853706F746C6967';
wwv_flow_imp.g_varchar2_table(229) := '68742E67537461746963496E6465783D242E6772657028742C66756E6374696F6E2874297B72657475726E20313D3D742E737D292C617065782E6576656E742E747269676765722822626F6479222C227064742D6170657873706F746C696768742D6765';
wwv_flow_imp.g_varchar2_table(230) := '742D6461746122297D29292C666F637573456C656D656E743D747D2C696E506167655365617263683A66756E6374696F6E2874297B76617220653D747C7C6170657853706F746C696768742E674B6579776F7264733B242822626F647922292E756E6D61';
wwv_flow_imp.g_varchar2_table(231) := '726B287B646F6E653A66756E6374696F6E28297B6170657853706F746C696768742E636C6F73654469616C6F6728292C6170657853706F746C696768742E726573657453706F746C6967687428292C242822626F647922292E6D61726B28652C7B7D292C';
wwv_flow_imp.g_varchar2_table(232) := '617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D696E706167652D736561726368222C7B6B6579776F72643A657D297D7D297D2C686173536561726368526573756C747344796E616D6963456E7472';
wwv_flow_imp.g_varchar2_table(233) := '6965733A66756E6374696F6E28297B76617220743D2428226C692E7064742D6170782D53706F746C696768742D726573756C7422292E686173436C61737328227064742D6170782D53706F746C696768742D44594E414D494322297C7C21313B72657475';
wwv_flow_imp.g_varchar2_table(234) := '726E20747D2C706C7567696E48616E646C65723A66756E6374696F6E2874297B76617220653D6170657853706F746C696768742E6744796E616D6963416374696F6E49643D742E64796E616D6963416374696F6E49642C613D6170657853706F746C6967';
wwv_flow_imp.g_varchar2_table(235) := '68742E67416A61784964656E7469666965723D742E616A61784964656E7469666965722C693D742E6576656E744E616D652C703D742E666972654F6E496E69742C6F3D6170657853706F746C696768742E67506C616365686F6C646572546578743D742E';
wwv_flow_imp.g_varchar2_table(236) := '706C616365686F6C646572546578742C6C3D6170657853706F746C696768742E674D6F72654368617273546578743D742E6D6F72654368617273546578742C723D6170657853706F746C696768742E674E6F4D61746368546578743D742E6E6F4D617463';
wwv_flow_imp.g_varchar2_table(237) := '68546578742C673D6170657853706F746C696768742E674F6E654D61746368546578743D742E6F6E654D61746368546578742C6E3D6170657853706F746C696768742E674D756C7469706C654D617463686573546578743D742E6D756C7469706C654D61';
wwv_flow_imp.g_varchar2_table(238) := '7463686573546578742C733D6170657853706F746C696768742E67496E50616765536561726368546578743D742E696E50616765536561726368546578742C683D6170657853706F746C696768742E67536561726368486973746F727944656C65746554';
wwv_flow_imp.g_varchar2_table(239) := '6578743D742E736561726368486973746F727944656C657465546578742C533D742E656E61626C654B6579626F61726453686F7274637574732C633D742E6B6579626F61726453686F7274637574732C643D742E7375626D69744974656D732C783D742E';
wwv_flow_imp.g_varchar2_table(240) := '656E61626C65496E506167655365617263682C753D6170657853706F746C696768742E674D61784E6176526573756C743D742E6D61784E6176526573756C742C663D6170657853706F746C696768742E6757696474683D742E77696474682C543D742E65';
wwv_flow_imp.g_varchar2_table(241) := '6E61626C654461746143616368652C763D742E73706F746C696768745468656D652C493D742E656E61626C6550726566696C6C53656C6563746564546578742C503D742E73686F7750726F63657373696E672C793D742E706C616365486F6C6465724963';
wwv_flow_imp.g_varchar2_table(242) := '6F6E2C6D3D742E656E61626C65536561726368486973746F72792C443D6170657853706F746C696768742E6744656661756C74546578743D742E64656661756C74546578742C623D6170657853706F746C696768742E674170704C696D69743D742E6170';
wwv_flow_imp.g_varchar2_table(243) := '704C696D69742C5F3D21303B6C6574204C3D7B7D3B737769746368284C2E64796E616D6963416374696F6E49643D652C4C2E616A61784964656E7469666965723D612C4C2E6576656E744E616D653D692C4C2E666972654F6E496E69743D702C4C2E706C';
wwv_flow_imp.g_varchar2_table(244) := '616365686F6C646572546578743D6F2C4C2E6D6F72654368617273546578743D6C2C4C2E6E6F4D61746368546578743D722C4C2E6F6E654D61746368546578743D672C4C2E6D756C7469706C654D617463686573546578743D6E2C4C2E696E5061676553';
wwv_flow_imp.g_varchar2_table(245) := '6561726368546578743D732C4C2E736561726368486973746F727944656C657465546578743D682C4C2E656E61626C654B6579626F61726453686F7274637574733D532C4C2E6B6579626F61726453686F7274637574733D632C4C2E7375626D69744974';
wwv_flow_imp.g_varchar2_table(246) := '656D733D642C4C2E656E61626C65496E506167655365617263683D782C4C2E6D61784E6176526573756C743D752C4C2E77696474683D662C4C2E656E61626C654461746143616368653D542C4C2E73706F746C696768745468656D653D762C4C2E656E61';
wwv_flow_imp.g_varchar2_table(247) := '626C6550726566696C6C53656C6563746564546578743D492C4C2E73686F7750726F63657373696E673D502C4C2E706C616365486F6C64657249636F6E3D792C4C2E656E61626C65536561726368486973746F72793D6D2C4C2E6170704C696D69743D62';
wwv_flow_imp.g_varchar2_table(248) := '2C617065782E64656275672E696E666F287B70647453706F746C696768744F7074696F6E733A4C7D292C537472696E672E70726F746F747970652E737461727473576974687C7C28537472696E672E70726F746F747970652E737461727473576974683D';
wwv_flow_imp.g_varchar2_table(249) := '66756E6374696F6E28742C65297B72657475726E20746869732E7375627374722821657C7C653C303F303A2B652C742E6C656E677468293D3D3D747D292C537472696E672E70726F746F747970652E696E636C756465737C7C28537472696E672E70726F';
wwv_flow_imp.g_varchar2_table(250) := '746F747970652E696E636C756465733D66756E6374696F6E28742C65297B2275736520737472696374223B72657475726E226E756D62657222213D747970656F662065262628653D30292C2128652B742E6C656E6774683E746869732E6C656E67746829';
wwv_flow_imp.g_varchar2_table(251) := '26262D31213D3D746869732E696E6465784F6628742C65297D292C6170657853706F746C696768742E67456E61626C65496E506167655365617263683D2259223D3D782C6170657853706F746C696768742E67456E61626C654461746143616368653D22';
wwv_flow_imp.g_varchar2_table(252) := '59223D3D542C6170657853706F746C696768742E67456E61626C6550726566696C6C53656C6563746564546578743D2259223D3D492C6170657853706F746C696768742E6753686F7750726F63657373696E673D2259223D3D502C6170657853706F746C';
wwv_flow_imp.g_varchar2_table(253) := '696768742E67456E61626C65536561726368486973746F72793D2259223D3D6D2C6170657853706F746C696768742E67456E61626C6544656661756C74546578743D2121442C6170657853706F746C696768742E64656661756C74546578743D442C6426';
wwv_flow_imp.g_varchar2_table(254) := '26286170657853706F746C696768742E675375626D69744974656D7341727261793D642E73706C697428222C2229292C76297B63617365224F52414E4745223A6170657853706F746C696768742E67526573756C744C6973745468656D65436C6173733D';
wwv_flow_imp.g_varchar2_table(255) := '227064742D6170782D53706F746C696768742D726573756C742D6F72616E6765222C6170657853706F746C696768742E6749636F6E5468656D65436C6173733D227064742D6170782D53706F746C696768742D69636F6E2D6F72616E6765223B62726561';
wwv_flow_imp.g_varchar2_table(256) := '6B3B6361736522524544223A6170657853706F746C696768742E67526573756C744C6973745468656D65436C6173733D227064742D6170782D53706F746C696768742D726573756C742D726564222C6170657853706F746C696768742E6749636F6E5468';
wwv_flow_imp.g_varchar2_table(257) := '656D65436C6173733D227064742D6170782D53706F746C696768742D69636F6E2D726564223B627265616B3B63617365224441524B223A6170657853706F746C696768742E67526573756C744C6973745468656D65436C6173733D227064742D6170782D';
wwv_flow_imp.g_varchar2_table(258) := '53706F746C696768742D726573756C742D6461726B222C6170657853706F746C696768742E6749636F6E5468656D65436C6173733D227064742D6170782D53706F746C696768742D69636F6E2D6461726B227D6170657853706F746C696768742E67506C';
wwv_flow_imp.g_varchar2_table(259) := '616365486F6C64657249636F6E3D2244454641554C54223D3D3D793F22612D49636F6E2069636F6E2D736561726368223A22666120222B792C5F3D226B6579626F61726453686F7274637574223D3D697C7C2259223D3D707C7C22726561647922213D69';
wwv_flow_imp.g_varchar2_table(260) := '2C242822626F647922292E6F6E28227064742D6170657873706F746C696768742D6765742D64617461222C66756E6374696F6E28297B6966286170657853706F746C696768742E674861734469616C6F67437265617465642626216170657853706F746C';
wwv_flow_imp.g_varchar2_table(261) := '696768742E686173536561726368526573756C747344796E616D6963456E74726965732829297B76617220743D24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E76616C28292E7472696D28';
wwv_flow_imp.g_varchar2_table(262) := '293B742626286170657853706F746C696768742E7365617263682874292C24286170657853706F746C696768742E444F542B6170657853706F746C696768742E53505F494E505554292E747269676765722822696E7075742229297D7D292C242822626F';
wwv_flow_imp.g_varchar2_table(263) := '647922292E6F6E28227064742D6170657873706F746C696768742D70726566657463682D64617461222C66756E6374696F6E28297B7064742E6F70742E73706F746C696768745072656665746368696E673D21302C2428222E7064742D73706F746C6967';
wwv_flow_imp.g_varchar2_table(264) := '68742D6465766261722D656E74727922292E616464436C617373282266612D72656672657368207064742D7072656665746368696E672066612D616E696D2D7370696E22292C6170657853706F746C696768742E766665746368537461727454696D653D';
wwv_flow_imp.g_varchar2_table(265) := '6E657720446174652C6170657853706F746C696768742E67657453706F746C69676874446174612866756E6374696F6E2874297B636F6E737420653D6E657720446174652C613D652D6170657853706F746C696768742E76666574636853746172745469';
wwv_flow_imp.g_varchar2_table(266) := '6D653B617065782E64656275672E696E666F282253706F746C69676874204461746120526561647920696E20222B612B226D7322297D297D292C5F26266170657853706F746C696768742E6F70656E53706F746C696768744469616C6F6728297D7D3B61';
wwv_flow_imp.g_varchar2_table(267) := '70657853706F746C696768742E706C7567696E48616E646C657228704F7074696F6E73297D7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219969032052840750)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/minified/apexspotlight.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E744465764261723D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E20652865297B72657475726E7B64796E616D6963416374696F6E49643A7064742E6F70742E64796E616D69';
wwv_flow_imp.g_varchar2_table(2) := '63416374696F6E49642C616A61784964656E7469666965723A7064742E6F70742E616A61784964656E7469666965722C6576656E744E616D653A652C666972654F6E496E69743A224E222C706C616365686F6C646572546578743A22456E746572206120';
wwv_flow_imp.g_varchar2_table(3) := '50616765204E756D626572206F72204E616D65222C6D6F72654368617273546578743A22506C6561736520656E746572206174206C656173742074776F206C65747465727320746F20736561726368222C6E6F4D61746368546578743A224E6F206D6174';
wwv_flow_imp.g_varchar2_table(4) := '636820666F756E64222C6F6E654D61746368546578743A2231206D6174636820666F756E64222C6D756C7469706C654D617463686573546578743A226D61746368657320666F756E64222C696E50616765536561726368546578743A2253656172636820';
wwv_flow_imp.g_varchar2_table(5) := '6F6E2063757272656E742050616765222C736561726368486973746F727944656C657465546578743A22436C6561722053656172636820486973746F7279222C656E61626C654B6579626F61726453686F7274637574733A2259222C656E61626C65496E';
wwv_flow_imp.g_varchar2_table(6) := '506167655365617263683A224E222C6D61784E6176526573756C743A393939392C77696474683A22363530222C656E61626C654461746143616368653A7064742E67657453657474696E6728226465766261722E6F70656E6275696C6465726361636865';
wwv_flow_imp.g_varchar2_table(7) := '22292C73706F746C696768745468656D653A225354414E44415244222C656E61626C6550726566696C6C53656C6563746564546578743A224E222C73686F7750726F63657373696E673A2259222C706C616365486F6C64657249636F6E3A224445464155';
wwv_flow_imp.g_varchar2_table(8) := '4C54222C656E61626C65536561726368486973746F72793A224E222C64656661756C74546578743A7064742E6F70742E656E762E4150505F504147455F49442C6170704C696D69743A7064742E67657453657474696E6728226465766261722E6F70656E';
wwv_flow_imp.g_varchar2_table(9) := '6275696C6465726170706C696D697422297D7D66756E6374696F6E20612865297B7064742E6F70742E73706F746C696768745072656665746368696E673F617065782E6D6573736167652E616C65727428225044542069732063757272656E746C792063';
wwv_flow_imp.g_varchar2_table(10) := '616368696E67205061676520446174612E20506C6561736520726574727920696E206120666577206D6F6D656E74732E22293A7064742E6170657853706F746C696768742E706C7567696E48616E646C65722865297D72657475726E7B61637469766174';
wwv_flow_imp.g_varchar2_table(11) := '654F70656E4275696C6465723A66756E6374696F6E207428297B766172206F3D7064742E67657453657474696E6728226465766261722E6F70656E6275696C6465726B6222293B69662830213D2428222361706578446576546F6F6C62617222292E6C65';
wwv_flow_imp.g_varchar2_table(12) := '6E677468297B6966284D6F757365747261702E62696E64476C6F62616C28226374726C2B616C742B222B6F2E746F4C6F7765724361736528292C66756E6374696F6E2874297B61286528226B6579626F61726453686F72746375742229297D292C242822';
wwv_flow_imp.g_varchar2_table(13) := '2361706578446576546F6F6C6261725061676522292E6C656E6774683E302626303D3D2428222361706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C53706F746C6967687422292E6C656E677468297B24282223617065';
wwv_flow_imp.g_varchar2_table(14) := '78446576546F6F6C6261725061676522292E706172656E7428292E616674657228617065782E6C616E672E666F726D61744E6F45736361706528273C6C693E3C627574746F6E2069643D2261706578446576546F6F6C6261725072657469757344657665';
wwv_flow_imp.g_varchar2_table(15) := '6C6F706572546F6F6C53706F746C696768742220747970653D22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C62617222207469746C653D224F70656E204275696C646572205B6374726C2B616C';
wwv_flow_imp.g_varchar2_table(16) := '742B25305D2220617269612D6C6162656C3D22566172732220646174612D6C696E6B3D22223E202531203C2F627574746F6E3E3C2F6C693E272C6F2E746F4C6F7765724361736528292C273C7370616E20636C6173733D22612D49636F6E206661207064';
wwv_flow_imp.g_varchar2_table(17) := '742D73706F746C696768742D6465766261722D656E7472792220617269612D68696464656E3D2274727565223E3C2F7370616E3E2729292C7064742E666978546F6F6C626172576964746828293B76617220723D646F63756D656E742E676574456C656D';
wwv_flow_imp.g_varchar2_table(18) := '656E7442794964282261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C53706F746C6967687422293B722626722E6164644576656E744C697374656E65722822636C69636B222C66756E6374696F6E2874297B612865';
wwv_flow_imp.g_varchar2_table(19) := '28226B6579626F61726453686F72746375742229297D2C2130297D2259223D3D7064742E67657453657474696E6728226465766261722E6F70656E6275696C646572636163686522293F28612865282272656164792229292C242822626F647922292E74';
wwv_flow_imp.g_varchar2_table(20) := '72696767657228227064742D6170657873706F746C696768742D70726566657463682D646174612229293A2428222E7064742D73706F746C696768742D6465766261722D656E74727922292E616464436C617373282266612D77696E646F772D6172726F';
wwv_flow_imp.g_varchar2_table(21) := '772D757022297D7D2C6163746976617465476C6F7744656275673A66756E6374696F6E206528297B30213D2428222361706578446576546F6F6C62617222292E6C656E6774682626282D313D3D5B22222C224E4F225D2E696E6465784F6628617065782E';
wwv_flow_imp.g_varchar2_table(22) := '6974656D282270646562756722292E67657456616C75652829293F2428222361706578446576546F6F6C62617222292E66696E6428222E612D49636F6E2E69636F6E2D646562756722292E72656D6F7665436C61737328292E616464436C617373282266';
wwv_flow_imp.g_varchar2_table(23) := '612066612D6275672066616D2D636865636B2066616D2D69732D7375636365737322293A2428222361706578446576546F6F6C62617222292E66696E6428222E612D49636F6E2E69636F6E2D646562756722292E72656D6F7665436C61737328292E6164';
wwv_flow_imp.g_varchar2_table(24) := '64436C617373282266612066612D6275672066616D2D782066616D2D69732D64697361626C65642229297D2C6163746976617465486F6D655265706C6163653A66756E6374696F6E206528297B2428222361706578446576546F6F6C626172486F6D6522';
wwv_flow_imp.g_varchar2_table(25) := '292E6174747228227469746C65222C2253686172656420436F6D706F6E656E7473202D204374726C2F436D642B436C69636B20746F206F70656E20696E2061206E65772074616222292C2428222361706578446576546F6F6C626172486F6D6520737061';
wwv_flow_imp.g_varchar2_table(26) := '6E2E612D49636F6E22292E72656D6F7665436C61737328292E616464436C617373282266612066612D73686170657322292C2428222361706578446576546F6F6C626172486F6D65202E612D446576546F6F6C6261722D627574746F6E4C6162656C2229';
wwv_flow_imp.g_varchar2_table(27) := '2E7265706C6163655769746828292C2428222361706578446576546F6F6C626172486F6D6522292E6F66662822636C69636B22292C2428222361706578446576546F6F6C626172486F6D6522292E6F6E2822636C69636B222C66756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(28) := '7B76617220613D652E6374726C4B65797C7C652E6D6574614B65793B7064742E70726574697573546F6F6C6261722E6F70656E536861726564436F6D706F6E656E74732861297D297D7D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219969485349840751)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/minified/contentDevBar.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E7064742D676C6F7744656275677B636F6C6F723A7265647D2E7064742D7072656665746368696E677B636F6C6F723A6F72616E67657D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219969811319840753)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/minified/dev-bar.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573546F6F6C6261723D66756E6374696F6E28297B2275736520737472696374223B6C657420653D617065782E6E617669676174696F6E2C6E3D617065782E6D6573736167652C743D22415045585F4255494C444552222C723D61';
wwv_flow_imp.g_varchar2_table(2) := '7065782E6C616E672E6765744D6573736167652822444556454C4F5045525F544F4F4C4241525F4E4F5F4255494C44455222292C6F3D2F663F703D345C645C645C643A2F2C613D2F5E345C645C645C64242F3B66756E6374696F6E206C2865297B766172';
wwv_flow_imp.g_varchar2_table(3) := '206E3B696628286E3D65292E6E616D6526266E2E6E616D652E6D6174636828225E222B74292972657475726E206E756C6C3B7472797B696628652E6F70656E6572262621652E6F70656E65722E636C6F7365642626652E6F70656E65722E617065782626';
wwv_flow_imp.g_varchar2_table(4) := '652E6F70656E65722E617065782E6A5175657279297B696628652E6F70656E65722E6C6F636174696F6E2E687265662E6D61746368282F663F703D345C645C645C643A2F297C7C652E6F70656E65722E646F63756D656E742E676574456C656D656E7442';
wwv_flow_imp.g_varchar2_table(5) := '794964282270466C6F77496422292E76616C75652E6D61746368282F5E345C645C645C64242F292972657475726E20652E6F70656E65723B72657475726E206C28652E6F70656E6572297D7D63617463682872297B7D72657475726E206E756C6C7D6675';
wwv_flow_imp.g_varchar2_table(6) := '6E6374696F6E207028297B76617220653D66756E6374696F6E2065286E297B6966286E2E6E616D6526266E2E6E616D652E6D6174636828225E222B74292972657475726E206E756C6C3B7472797B6966286E2E6F70656E65722626216E2E6F70656E6572';
wwv_flow_imp.g_varchar2_table(7) := '2E636C6F73656426266E2E6F70656E65722E6170657826266E2E6F70656E65722E617065782E6A5175657279297B6966286F2E74657374286E2E6F70656E65722E6C6F636174696F6E2E68726566297C7C612E74657374286E2E6F70656E65722E646F63';
wwv_flow_imp.g_varchar2_table(8) := '756D656E742E676574456C656D656E7442794964282270466C6F77496422292E76616C7565292972657475726E206E2E6F70656E65723B72657475726E2065286E2E6F70656E6572297D7D63617463682872297B7D72657475726E206E756C6C7D287769';
wwv_flow_imp.g_varchar2_table(9) := '6E646F77293B72657475726E20653F652E646F63756D656E742E676574456C656D656E7442794964282270496E7374616E636522292E76616C75653A6E756C6C7D66756E6374696F6E2075286F297B77696E646F772E6E616D653D3D3D743F652E726564';
wwv_flow_imp.g_varchar2_table(10) := '6972656374286F293A7028293F652E6F70656E496E4E657757696E646F77286F2C742C7B616C745375666669783A7028297D293A6E2E636F6E6669726D28722C6E3D3E7B6E26262877696E646F772E6E616D653D22222C652E7265646972656374286F29';
wwv_flow_imp.g_varchar2_table(11) := '297D297D72657475726E7B6F70656E4275696C6465723A66756E6374696F6E206E28722C6F2C61297B76617220702C692C632C642C662C733D2428222361706578446576546F6F6C6261725061676522292E617474722822646174612D6C696E6B22292C';
wwv_flow_imp.g_varchar2_table(12) := '6D3D6E756C6C2C673D6E756C6C3B733D28733D28733D28733D732E7265706C616365282F2866625F666C6F775F69643D295B5E265D2A2F2C222431222B7229292E7265706C616365282F2866625F666C6F775F706167655F69643D295B5E265D2A2F2C22';
wwv_flow_imp.g_varchar2_table(13) := '2431222B6F29292E7265706C616365282F2866343030305F70315F666C6F773D295B5E265D2A2F2C222431222B7229292E7265706C616365282F2866343030305F70315F706167653D295B5E265D2A2F2C222431222B6F292C613F652E6F70656E496E4E';
wwv_flow_imp.g_varchar2_table(14) := '657757696E646F772873293A28703D722C693D6F2C633D66756E6374696F6E28297B752873297D2C663D6C2877696E646F77292C662626662E7061676544657369676E65723F28662E7061676544657369676E65722E7365745061676553656C65637469';
wwv_flow_imp.g_varchar2_table(15) := '6F6E28702C692C6E756C6C2C6E756C6C2C66756E6374696F6E2865297B224F4B22213D3D65262622504147455F4348414E47455F41424F5254454422213D3D6526266328297D292C652E6F70656E496E4E657757696E646F772822222C742C7B616C7453';
wwv_flow_imp.g_varchar2_table(16) := '75666669783A28643D6C2877696E646F7729293F642E646F63756D656E742E676574456C656D656E7442794964282270496E7374616E636522292E76616C75653A6E756C6C7D29293A632829297D2C6F70656E536861726564436F6D706F6E656E74733A';
wwv_flow_imp.g_varchar2_table(17) := '66756E6374696F6E206E2874297B76617220723D2428222361706578446576546F6F6C6261725061676522292E617474722822646174612D6C696E6B22293B6C6574206F3D722E6D61746368282F5B3F265D73657373696F6E3D285C642B292F293F2E5B';
wwv_flow_imp.g_varchar2_table(18) := '315D3B723D722E7265706C616365282F5C2F706167652D64657369676E65725B5C735C535D2A2F2C222F7368617265642D636F6D706F6E656E747322292B603F73657373696F6E3D247B6F7D602B222646425F464C4F575F49443D222B7064742E6F7074';
wwv_flow_imp.g_varchar2_table(19) := '2E656E762E4150505F49442B222646425F464C4F575F504147455F49443D222B7064742E6F70742E656E762E4150505F504147455F49442C743F652E6F70656E496E4E657757696E646F772872293A752872297D7D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219970251561840758)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/minified/pretiusToolbar.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573546F6F6C626172203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A20202020636F6E7374206E6176203D20617065782E6E617669676174696F6E2C0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(2) := '6D657373616765203D20617065782E6D6573736167652C0D0A20202020202020204255494C4445525F57494E444F575F4E414D45203D2027415045585F4255494C444552272C0D0A2020202020202020444556454C4F5045525F544F4F4C4241525F4E4F';
wwv_flow_imp.g_varchar2_table(3) := '5F4255494C444552203D20617065782E6C616E672E6765744D657373616765280D0A20202020202020202020202027444556454C4F5045525F544F4F4C4241525F4E4F5F4255494C444552270D0A2020202020202020292C0D0A20202020202020204255';
wwv_flow_imp.g_varchar2_table(4) := '494C4445525F5245474558203D202F663F703D345C645C645C643A2F2C0D0A2020202020202020464C4F575F5245474558203D202F5E345C645C645C64242F3B0D0A2020202066756E6374696F6E2069734275696C64657257696E646F7728776E642920';
wwv_flow_imp.g_varchar2_table(5) := '7B0D0A202020202020202072657475726E20776E642E6E616D6520262620776E642E6E616D652E6D6174636828275E27202B204255494C4445525F57494E444F575F4E414D45293B0D0A202020207D0D0A2020202066756E6374696F6E20676574427569';
wwv_flow_imp.g_varchar2_table(6) := '6C646572496E7374616E63652829207B0D0A2020202020202020766172206275696C64657257696E646F77203D20676574417065784275696C64657246726F6D4F70656E6572436861696E2877696E646F77293B0D0A2020202020202020696620286275';
wwv_flow_imp.g_varchar2_table(7) := '696C64657257696E646F7729207B0D0A20202020202020202020202072657475726E206275696C64657257696E646F772E646F63756D656E742E676574456C656D656E7442794964282770496E7374616E636527292E76616C75653B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(8) := '20207D0D0A202020202020202072657475726E206E756C6C3B0D0A202020207D0D0A2020202066756E6374696F6E20676574417065784275696C64657246726F6D4F70656E6572436861696E28776E6429207B0D0A202020202020202069662028697342';
wwv_flow_imp.g_varchar2_table(9) := '75696C64657257696E646F7728776E642929207B0D0A20202020202020202020202072657475726E206E756C6C3B0D0A20202020202020207D0D0A2020202020202020747279207B0D0A202020202020202020202020696620280D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(10) := '2020202020202020776E642E6F70656E65722026260D0A2020202020202020202020202020202021776E642E6F70656E65722E636C6F7365642026260D0A20202020202020202020202020202020776E642E6F70656E65722E617065782026260D0A2020';
wwv_flow_imp.g_varchar2_table(11) := '2020202020202020202020202020776E642E6F70656E65722E617065782E6A51756572790D0A20202020202020202020202029207B0D0A20202020202020202020202020202020696620280D0A2020202020202020202020202020202020202020776E64';
wwv_flow_imp.g_varchar2_table(12) := '2E6F70656E65722E6C6F636174696F6E2E687265662E6D61746368282F663F703D345C645C645C643A2F29207C7C0D0A2020202020202020202020202020202020202020776E642E6F70656E65722E646F63756D656E742E676574456C656D656E744279';
wwv_flow_imp.g_varchar2_table(13) := '4964282770466C6F77496427292E76616C75652E6D61746368282F5E345C645C645C64242F290D0A2020202020202020202020202020202029207B0D0A202020202020202020202020202020202020202072657475726E20776E642E6F70656E65723B0D';
wwv_flow_imp.g_varchar2_table(14) := '0A202020202020202020202020202020207D20656C7365207B0D0A202020202020202020202020202020202020202072657475726E20676574417065784275696C64657246726F6D4F70656E6572436861696E28776E642E6F70656E6572293B0D0A2020';
wwv_flow_imp.g_varchar2_table(15) := '20202020202020202020202020207D0D0A2020202020202020202020207D0D0A20202020202020207D2063617463682028657829207B0D0A20202020202020202020202072657475726E206E756C6C3B0D0A20202020202020207D0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(16) := '2072657475726E206E756C6C3B0D0A202020207D0D0A2020202066756E6374696F6E206E61766967617465496E5061676544657369676E65722861707049642C207061676549642C207479706549642C20636F6D706F6E656E7449642C206572726F7246';
wwv_flow_imp.g_varchar2_table(17) := '6E29207B0D0A2020202020202020766172206275696C64657257696E646F77203D20676574417065784275696C64657246726F6D4F70656E6572436861696E2877696E646F77293B0D0A2020202020202020696620286275696C64657257696E646F7720';
wwv_flow_imp.g_varchar2_table(18) := '2626206275696C64657257696E646F772E7061676544657369676E657229207B0D0A2020202020202020202020206275696C64657257696E646F772E7061676544657369676E65722E7365745061676553656C656374696F6E280D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(19) := '202020202020202061707049642C0D0A202020202020202020202020202020207061676549642C0D0A202020202020202020202020202020207479706549642C0D0A20202020202020202020202020202020636F6D706F6E656E7449642C0D0A20202020';
wwv_flow_imp.g_varchar2_table(20) := '20202020202020202020202066756E6374696F6E2028726573756C7429207B0D0A202020202020202020202020202020202020202069662028726573756C7420213D3D20274F4B2720262620726573756C7420213D3D2027504147455F4348414E47455F';
wwv_flow_imp.g_varchar2_table(21) := '41424F525445442729207B0D0A2020202020202020202020202020202020202020202020206572726F72466E28293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(22) := '202020293B0D0A2020202020202020202020206E61762E6F70656E496E4E657757696E646F772827272C204255494C4445525F57494E444F575F4E414D452C207B0D0A20202020202020202020202020202020616C745375666669783A20676574427569';
wwv_flow_imp.g_varchar2_table(23) := '6C646572496E7374616E636528292C0D0A2020202020202020202020207D293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206572726F72466E28293B0D0A20202020202020207D0D0A202020207D0D0A202020206675';
wwv_flow_imp.g_varchar2_table(24) := '6E6374696F6E2066696E644275696C64657257696E646F77287729207B0D0A202020202020202069662028772E6E616D6520262620772E6E616D652E6D6174636828275E27202B204255494C4445525F57494E444F575F4E414D452929207B0D0A202020';
wwv_flow_imp.g_varchar2_table(25) := '20202020202020202072657475726E206E756C6C3B0D0A20202020202020207D0D0A2020202020202020747279207B0D0A202020202020202020202020696620280D0A20202020202020202020202020202020772E6F70656E65722026260D0A20202020';
wwv_flow_imp.g_varchar2_table(26) := '20202020202020202020202021772E6F70656E65722E636C6F7365642026260D0A20202020202020202020202020202020772E6F70656E65722E617065782026260D0A20202020202020202020202020202020772E6F70656E65722E617065782E6A5175';
wwv_flow_imp.g_varchar2_table(27) := '6572790D0A20202020202020202020202029207B0D0A20202020202020202020202020202020696620280D0A20202020202020202020202020202020202020204255494C4445525F52454745582E7465737428772E6F70656E65722E6C6F636174696F6E';
wwv_flow_imp.g_varchar2_table(28) := '2E6872656629207C7C0D0A2020202020202020202020202020202020202020464C4F575F52454745582E7465737428772E6F70656E65722E646F63756D656E742E676574456C656D656E7442794964282770466C6F77496427292E76616C7565290D0A20';
wwv_flow_imp.g_varchar2_table(29) := '20202020202020202020202020202029207B0D0A202020202020202020202020202020202020202072657475726E20772E6F70656E65723B0D0A202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(30) := '2020202072657475726E2066696E644275696C64657257696E646F7728772E6F70656E6572293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A20202020202020207D2063617463682028657829207B0D0A20';
wwv_flow_imp.g_varchar2_table(31) := '202020202020202020202072657475726E206E756C6C3B0D0A20202020202020207D0D0A202020202020202072657475726E206E756C6C3B0D0A202020207D0D0A2020202066756E6374696F6E206765744275696C646572496E7374616E636549642829';
wwv_flow_imp.g_varchar2_table(32) := '207B0D0A2020202020202020766172206275696C646572203D2066696E644275696C64657257696E646F772877696E646F77293B0D0A202020202020202072657475726E206275696C646572203F206275696C6465722E646F63756D656E742E67657445';
wwv_flow_imp.g_varchar2_table(33) := '6C656D656E7442794964282770496E7374616E636527292E76616C7565203A206E756C6C3B0D0A202020207D0D0A2020202066756E6374696F6E206F70656E4275696C64657257696E646F772875726C29207B0D0A20202020202020206966202877696E';
wwv_flow_imp.g_varchar2_table(34) := '646F772E6E616D65203D3D3D204255494C4445525F57494E444F575F4E414D4529207B0D0A2020202020202020202020206E61762E72656469726563742875726C293B0D0A20202020202020207D20656C73652069662028216765744275696C64657249';
wwv_flow_imp.g_varchar2_table(35) := '6E7374616E63654964282929207B0D0A2020202020202020202020206D6573736167652E636F6E6669726D28444556454C4F5045525F544F4F4C4241525F4E4F5F4255494C4445522C20286F6B29203D3E207B0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(36) := '20696620286F6B29207B0D0A202020202020202020202020202020202020202077696E646F772E6E616D65203D2027273B0D0A20202020202020202020202020202020202020206E61762E72656469726563742875726C293B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(37) := '202020202020207D0D0A2020202020202020202020207D293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206E61762E6F70656E496E4E657757696E646F772875726C2C204255494C4445525F57494E444F575F4E414D';
wwv_flow_imp.g_varchar2_table(38) := '452C207B0D0A20202020202020202020202020202020616C745375666669783A206765744275696C646572496E7374616E6365496428292C0D0A2020202020202020202020207D293B0D0A20202020202020207D0D0A202020207D0D0A2020202066756E';
wwv_flow_imp.g_varchar2_table(39) := '6374696F6E206F70656E4275696C646572287041707049442C20705061676549442C207057696E646F7729207B0D0A20202020202020207661722075726C203D202428272361706578446576546F6F6C6261725061676527292E61747472282764617461';
wwv_flow_imp.g_varchar2_table(40) := '2D6C696E6B27293B0D0A0D0A20202020202020202F2F205265706C6163652074686520662076616C75657320776974682070417070494420616E6420705061676549440D0A202020202020202075726C203D2075726C2E7265706C616365282F2866625F';
wwv_flow_imp.g_varchar2_table(41) := '666C6F775F69643D295B5E265D2A2F2C2027243127202B20704170704944293B0D0A202020202020202075726C203D2075726C2E7265706C616365282F2866625F666C6F775F706167655F69643D295B5E265D2A2F2C2027243127202B20705061676549';
wwv_flow_imp.g_varchar2_table(42) := '44293B0D0A202020202020202075726C203D2075726C2E7265706C616365282F2866343030305F70315F666C6F773D295B5E265D2A2F2C2027243127202B20704170704944293B0D0A202020202020202075726C203D2075726C2E7265706C616365282F';
wwv_flow_imp.g_varchar2_table(43) := '2866343030305F70315F706167653D295B5E265D2A2F2C2027243127202B2070506167654944293B0D0A0D0A2020202020202020696620287057696E646F7729207B0D0A2020202020202020202020206E61762E6F70656E496E4E657757696E646F7728';
wwv_flow_imp.g_varchar2_table(44) := '75726C293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206E61766967617465496E5061676544657369676E6572287041707049442C20705061676549442C206E756C6C2C206E756C6C2C2066756E6374696F6E202829';
wwv_flow_imp.g_varchar2_table(45) := '207B0D0A202020202020202020202020202020206F70656E4275696C64657257696E646F772875726C293B0D0A2020202020202020202020207D293B0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202066756E6374696F6E206F70656E53';
wwv_flow_imp.g_varchar2_table(46) := '6861726564436F6D706F6E656E7473287057696E646F7729207B0D0A20202020202020202F2F20476574207468652055524C2066726F6D20746865206461746120617474726962757465206F6620616E20656C656D656E74207769746820746865204944';
wwv_flow_imp.g_varchar2_table(47) := '202761706578446576546F6F6C62617250616765270D0A20202020202020207661722075726C203D202428272361706578446576546F6F6C6261725061676527292E617474722827646174612D6C696E6B27293B0D0A0D0A20202020202020202F2F2045';
wwv_flow_imp.g_varchar2_table(48) := '7874726163742073657373696F6E2049442066726F6D207468652055524C207573696E6720726567756C61722065787072657373696F6E0D0A2020202020202020636F6E73742073657373696F6E4964203D2075726C2E6D61746368282F5B3F265D7365';
wwv_flow_imp.g_varchar2_table(49) := '7373696F6E3D285C642B292F293F2E5B315D3B0D0A0D0A20202020202020202F2F205265706C6163652065766572797468696E6720616674657220272F706167652D64657369676E657227207769746820272F7368617265642D636F6D706F6E656E7473';
wwv_flow_imp.g_varchar2_table(50) := '2720696E207468652055524C0D0A20202020202020202F2F20616E6420617070656E64207468652073657373696F6E20494420746F20746865206D6F6469666965642055524C0D0A202020202020202075726C203D2075726C2E7265706C616365282F5C';
wwv_flow_imp.g_varchar2_table(51) := '2F706167652D64657369676E65725B5C735C535D2A2F2C20272F7368617265642D636F6D706F6E656E74732729202B20603F73657373696F6E3D247B73657373696F6E49647D60202B200D0A20202020202020202020202020272646425F464C4F575F49';
wwv_flow_imp.g_varchar2_table(52) := '443D27202B207064742E6F70742E656E762E4150505F4944202B0D0A20202020202020202020202020272646425F464C4F575F504147455F49443D27202B207064742E6F70742E656E762E4150505F504147455F49443B0D0A0D0A202020202020202069';
wwv_flow_imp.g_varchar2_table(53) := '6620287057696E646F7729207B0D0A2020202020202020202020206E61762E6F70656E496E4E657757696E646F772875726C293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206F70656E4275696C64657257696E646F';
wwv_flow_imp.g_varchar2_table(54) := '772875726C293B0D0A20202020202020207D0D0A0D0A202020207D0D0A2020202072657475726E207B0D0A20202020202020206F70656E4275696C6465723A206F70656E4275696C6465722C0D0A20202020202020206F70656E536861726564436F6D70';
wwv_flow_imp.g_varchar2_table(55) := '6F6E656E74733A206F70656E536861726564436F6D706F6E656E74730D0A202020207D3B0D0A7D2928293B0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219970689782840760)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'dev-bar/pretiusToolbar.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2866756E6374696F6E2861297B76617220633D7B7D2C643D612E70726F746F747970652E73746F7043616C6C6261636B3B612E70726F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28652C622C612C66297B72657475726E2074';
wwv_flow_imp.g_varchar2_table(2) := '6869732E7061757365643F21303A635B615D7C7C635B665D3F21313A642E63616C6C28746869732C652C622C61297D3B612E70726F746F747970652E62696E64476C6F62616C3D66756E6374696F6E28612C622C64297B746869732E62696E6428612C62';
wwv_flow_imp.g_varchar2_table(3) := '2C64293B6966286120696E7374616E63656F6620417272617929666F7228623D303B623C612E6C656E6774683B622B2B29635B615B625D5D3D21303B656C736520635B615D3D21307D3B612E696E697428297D29284D6F75736574726170293B0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219971048587840762)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'libs/mousetrap/mousetrap-global-bind.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A206D6F757365747261702076312E362E312063726169672E69732F6B696C6C696E672F6D696365202A2F0D0A2866756E6374696F6E28722C762C66297B66756E6374696F6E207728612C622C67297B612E6164644576656E744C697374656E65723F';
wwv_flow_imp.g_varchar2_table(2) := '612E6164644576656E744C697374656E657228622C672C2131293A612E6174746163684576656E7428226F6E222B622C67297D66756E6374696F6E20412861297B696628226B65797072657373223D3D612E74797065297B76617220623D537472696E67';
wwv_flow_imp.g_varchar2_table(3) := '2E66726F6D43686172436F646528612E7768696368293B612E73686966744B65797C7C28623D622E746F4C6F776572436173652829293B72657475726E20627D72657475726E20705B612E77686963685D3F705B612E77686963685D3A745B612E776869';
wwv_flow_imp.g_varchar2_table(4) := '63685D3F745B612E77686963685D3A537472696E672E66726F6D43686172436F646528612E7768696368292E746F4C6F7765724361736528297D66756E6374696F6E20462861297B76617220623D5B5D3B612E73686966744B65792626622E7075736828';
wwv_flow_imp.g_varchar2_table(5) := '22736869667422293B612E616C744B65792626622E707573682822616C7422293B612E6374726C4B65792626622E7075736828226374726C22293B612E6D6574614B65792626622E7075736828226D65746122293B72657475726E20627D66756E637469';
wwv_flow_imp.g_varchar2_table(6) := '6F6E20782861297B72657475726E227368696674223D3D617C7C226374726C223D3D617C7C22616C74223D3D617C7C0D0A226D657461223D3D617D66756E6374696F6E204228612C62297B76617220672C632C642C663D5B5D3B673D613B222B223D3D3D';
wwv_flow_imp.g_varchar2_table(7) := '673F673D5B222B225D3A28673D672E7265706C616365282F5C2B7B327D2F672C222B706C757322292C673D672E73706C697428222B2229293B666F7228643D303B643C672E6C656E6774683B2B2B6429633D675B645D2C435B635D262628633D435B635D';
wwv_flow_imp.g_varchar2_table(8) := '292C622626226B6579707265737322213D622626445B635D262628633D445B635D2C662E70757368282273686966742229292C782863292626662E707573682863293B673D633B643D623B6966282164297B696628216E297B6E3D7B7D3B666F72287661';
wwv_flow_imp.g_varchar2_table(9) := '72207120696E20702939353C7126263131323E717C7C702E6861734F776E50726F70657274792871292626286E5B705B715D5D3D71297D643D6E5B675D3F226B6579646F776E223A226B65797072657373227D226B65797072657373223D3D642626662E';
wwv_flow_imp.g_varchar2_table(10) := '6C656E677468262628643D226B6579646F776E22293B72657475726E7B6B65793A632C6D6F646966696572733A662C616374696F6E3A647D7D66756E6374696F6E204528612C62297B72657475726E206E756C6C3D3D3D617C7C613D3D3D763F21313A61';
wwv_flow_imp.g_varchar2_table(11) := '3D3D3D623F21303A4528612E706172656E744E6F64652C62297D66756E6374696F6E20632861297B66756E6374696F6E20622861297B613D0D0A617C7C7B7D3B76617220623D21312C6C3B666F72286C20696E206E29615B6C5D3F623D21303A6E5B6C5D';
wwv_flow_imp.g_varchar2_table(12) := '3D303B627C7C28793D2131297D66756E6374696F6E206728612C622C752C652C632C67297B766172206C2C6D2C6B3D5B5D2C663D752E747970653B69662821682E5F63616C6C6261636B735B615D2972657475726E5B5D3B226B65797570223D3D662626';
wwv_flow_imp.g_varchar2_table(13) := '78286129262628623D5B615D293B666F72286C3D303B6C3C682E5F63616C6C6261636B735B615D2E6C656E6774683B2B2B6C296966286D3D682E5F63616C6C6261636B735B615D5B6C5D2C28657C7C216D2E7365717C7C6E5B6D2E7365715D3D3D6D2E6C';
wwv_flow_imp.g_varchar2_table(14) := '6576656C292626663D3D6D2E616374696F6E297B76617220643B28643D226B65797072657373223D3D66262621752E6D6574614B6579262621752E6374726C4B6579297C7C28643D6D2E6D6F646966696572732C643D622E736F727428292E6A6F696E28';
wwv_flow_imp.g_varchar2_table(15) := '222C22293D3D3D642E736F727428292E6A6F696E28222C2229293B64262628643D6526266D2E7365713D3D6526266D2E6C6576656C3D3D672C28216526266D2E636F6D626F3D3D637C7C64292626682E5F63616C6C6261636B735B615D2E73706C696365';
wwv_flow_imp.g_varchar2_table(16) := '286C2C31292C6B2E70757368286D29297D72657475726E206B7D66756E6374696F6E206628612C622C632C65297B682E73746F7043616C6C6261636B28622C0D0A622E7461726765747C7C622E737263456C656D656E742C632C65297C7C2131213D3D61';
wwv_flow_imp.g_varchar2_table(17) := '28622C63297C7C28622E70726576656E7444656661756C743F622E70726576656E7444656661756C7428293A622E72657475726E56616C75653D21312C622E73746F7050726F7061676174696F6E3F622E73746F7050726F7061676174696F6E28293A62';
wwv_flow_imp.g_varchar2_table(18) := '2E63616E63656C427562626C653D2130297D66756E6374696F6E20642861297B226E756D62657222213D3D747970656F6620612E7768696368262628612E77686963683D612E6B6579436F6465293B76617220623D412861293B62262628226B65797570';
wwv_flow_imp.g_varchar2_table(19) := '223D3D612E7479706526267A3D3D3D623F7A3D21313A682E68616E646C654B657928622C462861292C6129297D66756E6374696F6E207028612C632C752C65297B66756E6374696F6E206C2863297B72657475726E2066756E6374696F6E28297B793D63';
wwv_flow_imp.g_varchar2_table(20) := '3B2B2B6E5B615D3B636C65617254696D656F75742872293B723D73657454696D656F757428622C314533297D7D66756E6374696F6E20672863297B6628752C632C61293B226B6579757022213D3D652626287A3D41286329293B73657454696D656F7574';
wwv_flow_imp.g_varchar2_table(21) := '28622C3130297D666F722876617220643D6E5B615D3D303B643C632E6C656E6774683B2B2B64297B766172206D3D642B313D3D3D632E6C656E6774683F673A6C28657C7C0D0A4228635B642B315D292E616374696F6E293B7128635B645D2C6D2C652C61';
wwv_flow_imp.g_varchar2_table(22) := '2C64297D7D66756E6374696F6E207128612C622C632C652C64297B682E5F6469726563744D61705B612B223A222B635D3D623B613D612E7265706C616365282F5C732B2F672C222022293B76617220663D612E73706C697428222022293B313C662E6C65';
wwv_flow_imp.g_varchar2_table(23) := '6E6774683F7028612C662C622C63293A28633D4228612C63292C682E5F63616C6C6261636B735B632E6B65795D3D682E5F63616C6C6261636B735B632E6B65795D7C7C5B5D2C6728632E6B65792C632E6D6F646966696572732C7B747970653A632E6163';
wwv_flow_imp.g_varchar2_table(24) := '74696F6E7D2C652C612C64292C682E5F63616C6C6261636B735B632E6B65795D5B653F22756E7368696674223A2270757368225D287B63616C6C6261636B3A622C6D6F646966696572733A632E6D6F646966696572732C616374696F6E3A632E61637469';
wwv_flow_imp.g_varchar2_table(25) := '6F6E2C7365713A652C6C6576656C3A642C636F6D626F3A617D29297D76617220683D746869733B613D617C7C763B69662821286820696E7374616E63656F662063292972657475726E206E657720632861293B682E7461726765743D613B682E5F63616C';
wwv_flow_imp.g_varchar2_table(26) := '6C6261636B733D7B7D3B682E5F6469726563744D61703D7B7D3B766172206E3D7B7D2C722C7A3D21312C743D21312C793D21313B682E5F68616E646C654B65793D66756E6374696F6E28612C0D0A632C64297B76617220653D6728612C632C64292C6B3B';
wwv_flow_imp.g_varchar2_table(27) := '633D7B7D3B76617220683D302C6C3D21313B666F72286B3D303B6B3C652E6C656E6774683B2B2B6B29655B6B5D2E736571262628683D4D6174682E6D617828682C655B6B5D2E6C6576656C29293B666F72286B3D303B6B3C652E6C656E6774683B2B2B6B';
wwv_flow_imp.g_varchar2_table(28) := '29655B6B5D2E7365713F655B6B5D2E6C6576656C3D3D682626286C3D21302C635B655B6B5D2E7365715D3D312C6628655B6B5D2E63616C6C6261636B2C642C655B6B5D2E636F6D626F2C655B6B5D2E73657129293A6C7C7C6628655B6B5D2E63616C6C62';
wwv_flow_imp.g_varchar2_table(29) := '61636B2C642C655B6B5D2E636F6D626F293B653D226B65797072657373223D3D642E747970652626743B642E74797065213D797C7C782861297C7C657C7C622863293B743D6C2626226B6579646F776E223D3D642E747970657D3B682E5F62696E644D75';
wwv_flow_imp.g_varchar2_table(30) := '6C7469706C653D66756E6374696F6E28612C622C63297B666F722876617220643D303B643C612E6C656E6774683B2B2B64297128615B645D2C622C63297D3B7728612C226B65797072657373222C64293B7728612C226B6579646F776E222C64293B7728';
wwv_flow_imp.g_varchar2_table(31) := '612C226B65797570222C64297D69662872297B76617220703D7B383A226261636B7370616365222C393A22746162222C31333A22656E746572222C31363A227368696674222C31373A226374726C222C0D0A31383A22616C74222C32303A22636170736C';
wwv_flow_imp.g_varchar2_table(32) := '6F636B222C32373A22657363222C33323A227370616365222C33333A22706167657570222C33343A2270616765646F776E222C33353A22656E64222C33363A22686F6D65222C33373A226C656674222C33383A227570222C33393A227269676874222C34';
wwv_flow_imp.g_varchar2_table(33) := '303A22646F776E222C34353A22696E73222C34363A2264656C222C39313A226D657461222C39333A226D657461222C3232343A226D657461227D2C743D7B3130363A222A222C3130373A222B222C3130393A222D222C3131303A222E222C3131313A222F';
wwv_flow_imp.g_varchar2_table(34) := '222C3138363A223B222C3138373A223D222C3138383A222C222C3138393A222D222C3139303A222E222C3139313A222F222C3139323A2260222C3231393A225B222C3232303A225C5C222C3232313A225D222C3232323A2227227D2C443D7B227E223A22';
wwv_flow_imp.g_varchar2_table(35) := '60222C2221223A2231222C2240223A2232222C2223223A2233222C243A2234222C2225223A2235222C225E223A2236222C2226223A2237222C222A223A2238222C2228223A2239222C2229223A2230222C5F3A222D222C222B223A223D222C223A223A22';
wwv_flow_imp.g_varchar2_table(36) := '3B222C2722273A2227222C223C223A222C222C223E223A222E222C223F223A222F222C227C223A225C5C227D2C433D7B6F7074696F6E3A22616C74222C636F6D6D616E643A226D657461222C2272657475726E223A22656E746572222C0D0A6573636170';
wwv_flow_imp.g_varchar2_table(37) := '653A22657363222C706C75733A222B222C6D6F643A2F4D61637C69506F647C6950686F6E657C695061642F2E74657374286E6176696761746F722E706C6174666F726D293F226D657461223A226374726C227D2C6E3B666F7228663D313B32303E663B2B';
wwv_flow_imp.g_varchar2_table(38) := '2B6629705B3131312B665D3D2266222B663B666F7228663D303B393E3D663B2B2B6629705B662B39365D3D662E746F537472696E6728293B632E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B613D6120696E7374616E63';
wwv_flow_imp.g_varchar2_table(39) := '656F662041727261793F613A5B615D3B746869732E5F62696E644D756C7469706C652E63616C6C28746869732C612C622C63293B72657475726E20746869737D3B632E70726F746F747970652E756E62696E643D66756E6374696F6E28612C62297B7265';
wwv_flow_imp.g_varchar2_table(40) := '7475726E20746869732E62696E642E63616C6C28746869732C612C66756E6374696F6E28297B7D2C62297D3B632E70726F746F747970652E747269676765723D66756E6374696F6E28612C62297B696628746869732E5F6469726563744D61705B612B22';
wwv_flow_imp.g_varchar2_table(41) := '3A222B625D29746869732E5F6469726563744D61705B612B223A222B625D287B7D2C61293B72657475726E20746869737D3B632E70726F746F747970652E72657365743D66756E6374696F6E28297B746869732E5F63616C6C6261636B733D7B7D3B0D0A';
wwv_flow_imp.g_varchar2_table(42) := '746869732E5F6469726563744D61703D7B7D3B72657475726E20746869737D3B632E70726F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28612C62297B72657475726E2D313C282220222B622E636C6173734E616D652B222022';
wwv_flow_imp.g_varchar2_table(43) := '292E696E6465784F662822206D6F757365747261702022297C7C4528622C746869732E746172676574293F21313A22494E505554223D3D622E7461674E616D657C7C2253454C454354223D3D622E7461674E616D657C7C225445585441524541223D3D62';
wwv_flow_imp.g_varchar2_table(44) := '2E7461674E616D657C7C622E6973436F6E74656E744564697461626C657D3B632E70726F746F747970652E68616E646C654B65793D66756E6374696F6E28297B72657475726E20746869732E5F68616E646C654B65792E6170706C7928746869732C6172';
wwv_flow_imp.g_varchar2_table(45) := '67756D656E7473297D3B632E6164644B6579636F6465733D66756E6374696F6E2861297B666F7228766172206220696E206129612E6861734F776E50726F7065727479286229262628705B625D3D615B625D293B6E3D6E756C6C7D3B632E696E69743D66';
wwv_flow_imp.g_varchar2_table(46) := '756E6374696F6E28297B76617220613D632876292C623B666F72286220696E206129225F22213D3D622E636861724174283029262628635B625D3D66756E6374696F6E2862297B72657475726E2066756E6374696F6E28297B72657475726E20615B625D';
wwv_flow_imp.g_varchar2_table(47) := '2E6170706C7928612C0D0A617267756D656E7473297D7D286229297D3B632E696E697428293B722E4D6F757365747261703D633B22756E646566696E656422213D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274732626286D6F';
wwv_flow_imp.g_varchar2_table(48) := '64756C652E6578706F7274733D63293B2266756E6374696F6E223D3D3D747970656F6620646566696E652626646566696E652E616D642626646566696E652866756E6374696F6E28297B72657475726E20637D297D7D292822756E646566696E65642221';
wwv_flow_imp.g_varchar2_table(49) := '3D3D747970656F662077696E646F773F77696E646F773A6E756C6C2C22756E646566696E656422213D3D747970656F662077696E646F773F646F63756D656E743A6E756C6C293B0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219971438135840764)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'libs/mousetrap/mousetrap.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A212070616B6F20322E312E302068747470733A2F2F6769746875622E636F6D2F6E6F646563612F70616B6F20406C6963656E736520284D495420414E44205A6C696229202A2F0D0A2166756E6374696F6E28742C65297B226F626A656374223D3D74';
wwv_flow_imp.g_varchar2_table(2) := '7970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F65286578706F727473293A2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B22';
wwv_flow_imp.g_varchar2_table(3) := '6578706F727473225D2C65293A652828743D22756E646566696E656422213D747970656F6620676C6F62616C546869733F676C6F62616C546869733A747C7C73656C66292E70616B6F3D7B7D297D28746869732C2866756E6374696F6E2874297B227573';
wwv_flow_imp.g_varchar2_table(4) := '6520737472696374223B66756E6374696F6E20652874297B6C657420653D742E6C656E6774683B666F72283B2D2D653E3D303B29745B655D3D307D636F6E737420613D3235362C693D3238362C6E3D33302C733D31352C723D6E65772055696E74384172';
wwv_flow_imp.g_varchar2_table(5) := '726179285B302C302C302C302C302C302C302C302C312C312C312C312C322C322C322C322C332C332C332C332C342C342C342C342C352C352C352C352C305D292C6F3D6E65772055696E74384172726179285B302C302C302C302C312C312C322C322C33';
wwv_flow_imp.g_varchar2_table(6) := '2C332C342C342C352C352C362C362C372C372C382C382C392C392C31302C31302C31312C31312C31322C31322C31332C31335D292C6C3D6E65772055696E74384172726179285B302C302C302C302C302C302C302C302C302C302C302C302C302C302C30';
wwv_flow_imp.g_varchar2_table(7) := '2C302C322C332C375D292C683D6E65772055696E74384172726179285B31362C31372C31382C302C382C372C392C362C31302C352C31312C342C31322C332C31332C322C31342C312C31355D292C643D6E657720417272617928353736293B652864293B';
wwv_flow_imp.g_varchar2_table(8) := '636F6E7374205F3D6E6577204172726179283630293B65285F293B636F6E737420663D6E657720417272617928353132293B652866293B636F6E737420633D6E657720417272617928323536293B652863293B636F6E737420753D6E6577204172726179';
wwv_flow_imp.g_varchar2_table(9) := '283239293B652875293B636F6E737420773D6E6577204172726179286E293B66756E6374696F6E206D28742C652C612C692C6E297B746869732E7374617469635F747265653D742C746869732E65787472615F626974733D652C746869732E6578747261';
wwv_flow_imp.g_varchar2_table(10) := '5F626173653D612C746869732E656C656D733D692C746869732E6D61785F6C656E6774683D6E2C746869732E6861735F73747265653D742626742E6C656E6774687D6C657420622C672C703B66756E6374696F6E206B28742C65297B746869732E64796E';
wwv_flow_imp.g_varchar2_table(11) := '5F747265653D742C746869732E6D61785F636F64653D302C746869732E737461745F646573633D657D652877293B636F6E737420763D743D3E743C3235363F665B745D3A665B3235362B28743E3E3E37295D2C793D28742C65293D3E7B742E70656E6469';
wwv_flow_imp.g_varchar2_table(12) := '6E675F6275665B742E70656E64696E672B2B5D3D32353526652C742E70656E64696E675F6275665B742E70656E64696E672B2B5D3D653E3E3E38263235357D2C783D28742C652C61293D3E7B742E62695F76616C69643E31362D613F28742E62695F6275';
wwv_flow_imp.g_varchar2_table(13) := '667C3D653C3C742E62695F76616C69642636353533352C7928742C742E62695F627566292C742E62695F6275663D653E3E31362D742E62695F76616C69642C742E62695F76616C69642B3D612D3136293A28742E62695F6275667C3D653C3C742E62695F';
wwv_flow_imp.g_varchar2_table(14) := '76616C69642636353533352C742E62695F76616C69642B3D61297D2C7A3D28742C652C61293D3E7B7828742C615B322A655D2C615B322A652B315D297D2C413D28742C65293D3E7B6C657420613D303B646F7B617C3D3126742C743E3E3E3D312C613C3C';
wwv_flow_imp.g_varchar2_table(15) := '3D317D7768696C65282D2D653E30293B72657475726E20613E3E3E317D2C453D28742C652C61293D3E7B636F6E737420693D6E6577204172726179283136293B6C6574206E2C722C6F3D303B666F72286E3D313B6E3C3D733B6E2B2B296F3D6F2B615B6E';
wwv_flow_imp.g_varchar2_table(16) := '2D315D3C3C312C695B6E5D3D6F3B666F7228723D303B723C3D653B722B2B297B6C657420653D745B322A722B315D3B30213D3D65262628745B322A725D3D4128695B655D2B2B2C6529297D7D2C523D743D3E7B6C657420653B666F7228653D303B653C69';
wwv_flow_imp.g_varchar2_table(17) := '3B652B2B29742E64796E5F6C747265655B322A655D3D303B666F7228653D303B653C6E3B652B2B29742E64796E5F64747265655B322A655D3D303B666F7228653D303B653C31393B652B2B29742E626C5F747265655B322A655D3D303B742E64796E5F6C';
wwv_flow_imp.g_varchar2_table(18) := '747265655B3531325D3D312C742E6F70745F6C656E3D742E7374617469635F6C656E3D302C742E73796D5F6E6578743D742E6D6174636865733D307D2C5A3D743D3E7B742E62695F76616C69643E383F7928742C742E62695F627566293A742E62695F76';
wwv_flow_imp.g_varchar2_table(19) := '616C69643E30262628742E70656E64696E675F6275665B742E70656E64696E672B2B5D3D742E62695F627566292C742E62695F6275663D302C742E62695F76616C69643D307D2C553D28742C652C612C69293D3E7B636F6E7374206E3D322A652C733D32';
wwv_flow_imp.g_varchar2_table(20) := '2A613B72657475726E20745B6E5D3C745B735D7C7C745B6E5D3D3D3D745B735D2626695B655D3C3D695B615D7D2C533D28742C652C61293D3E7B636F6E737420693D742E686561705B615D3B6C6574206E3D613C3C313B666F72283B6E3C3D742E686561';
wwv_flow_imp.g_varchar2_table(21) := '705F6C656E2626286E3C742E686561705F6C656E26265528652C742E686561705B6E2B315D2C742E686561705B6E5D2C742E64657074682926266E2B2B2C215528652C692C742E686561705B6E5D2C742E646570746829293B29742E686561705B615D3D';
wwv_flow_imp.g_varchar2_table(22) := '742E686561705B6E5D2C613D6E2C6E3C3C3D313B742E686561705B615D3D697D2C443D28742C652C69293D3E7B6C6574206E2C732C6C2C682C643D303B69662830213D3D742E73796D5F6E65787429646F7B6E3D32353526742E70656E64696E675F6275';
wwv_flow_imp.g_varchar2_table(23) := '665B742E73796D5F6275662B642B2B5D2C6E2B3D2832353526742E70656E64696E675F6275665B742E73796D5F6275662B642B2B5D293C3C382C733D742E70656E64696E675F6275665B742E73796D5F6275662B642B2B5D2C303D3D3D6E3F7A28742C73';
wwv_flow_imp.g_varchar2_table(24) := '2C65293A286C3D635B735D2C7A28742C6C2B612B312C65292C683D725B6C5D2C30213D3D68262628732D3D755B6C5D2C7828742C732C6829292C6E2D2D2C6C3D76286E292C7A28742C6C2C69292C683D6F5B6C5D2C30213D3D682626286E2D3D775B6C5D';
wwv_flow_imp.g_varchar2_table(25) := '2C7828742C6E2C682929297D7768696C6528643C742E73796D5F6E657874293B7A28742C3235362C65297D2C543D28742C65293D3E7B636F6E737420613D652E64796E5F747265652C693D652E737461745F646573632E7374617469635F747265652C6E';
wwv_flow_imp.g_varchar2_table(26) := '3D652E737461745F646573632E6861735F73747265652C723D652E737461745F646573632E656C656D733B6C6574206F2C6C2C682C643D2D313B666F7228742E686561705F6C656E3D302C742E686561705F6D61783D3537332C6F3D303B6F3C723B6F2B';
wwv_flow_imp.g_varchar2_table(27) := '2B2930213D3D615B322A6F5D3F28742E686561705B2B2B742E686561705F6C656E5D3D643D6F2C742E64657074685B6F5D3D30293A615B322A6F2B315D3D303B666F72283B742E686561705F6C656E3C323B29683D742E686561705B2B2B742E68656170';
wwv_flow_imp.g_varchar2_table(28) := '5F6C656E5D3D643C323F2B2B643A302C615B322A685D3D312C742E64657074685B685D3D302C742E6F70745F6C656E2D2D2C6E262628742E7374617469635F6C656E2D3D695B322A682B315D293B666F7228652E6D61785F636F64653D642C6F3D742E68';
wwv_flow_imp.g_varchar2_table(29) := '6561705F6C656E3E3E313B6F3E3D313B6F2D2D295328742C612C6F293B683D723B646F7B6F3D742E686561705B315D2C742E686561705B315D3D742E686561705B742E686561705F6C656E2D2D5D2C5328742C612C31292C6C3D742E686561705B315D2C';
wwv_flow_imp.g_varchar2_table(30) := '742E686561705B2D2D742E686561705F6D61785D3D6F2C742E686561705B2D2D742E686561705F6D61785D3D6C2C615B322A685D3D615B322A6F5D2B615B322A6C5D2C742E64657074685B685D3D28742E64657074685B6F5D3E3D742E64657074685B6C';
wwv_flow_imp.g_varchar2_table(31) := '5D3F742E64657074685B6F5D3A742E64657074685B6C5D292B312C615B322A6F2B315D3D615B322A6C2B315D3D682C742E686561705B315D3D682B2B2C5328742C612C31297D7768696C6528742E686561705F6C656E3E3D32293B742E686561705B2D2D';
wwv_flow_imp.g_varchar2_table(32) := '742E686561705F6D61785D3D742E686561705B315D2C2828742C65293D3E7B636F6E737420613D652E64796E5F747265652C693D652E6D61785F636F64652C6E3D652E737461745F646573632E7374617469635F747265652C723D652E737461745F6465';
wwv_flow_imp.g_varchar2_table(33) := '73632E6861735F73747265652C6F3D652E737461745F646573632E65787472615F626974732C6C3D652E737461745F646573632E65787472615F626173652C683D652E737461745F646573632E6D61785F6C656E6774683B6C657420642C5F2C662C632C';
wwv_flow_imp.g_varchar2_table(34) := '752C772C6D3D303B666F7228633D303B633C3D733B632B2B29742E626C5F636F756E745B635D3D303B666F7228615B322A742E686561705B742E686561705F6D61785D2B315D3D302C643D742E686561705F6D61782B313B643C3537333B642B2B295F3D';
wwv_flow_imp.g_varchar2_table(35) := '742E686561705B645D2C633D615B322A615B322A5F2B315D2B315D2B312C633E68262628633D682C6D2B2B292C615B322A5F2B315D3D632C5F3E697C7C28742E626C5F636F756E745B635D2B2B2C753D302C5F3E3D6C262628753D6F5B5F2D6C5D292C77';
wwv_flow_imp.g_varchar2_table(36) := '3D615B322A5F5D2C742E6F70745F6C656E2B3D772A28632B75292C72262628742E7374617469635F6C656E2B3D772A286E5B322A5F2B315D2B752929293B69662830213D3D6D297B646F7B666F7228633D682D313B303D3D3D742E626C5F636F756E745B';
wwv_flow_imp.g_varchar2_table(37) := '635D3B29632D2D3B742E626C5F636F756E745B635D2D2D2C742E626C5F636F756E745B632B315D2B3D322C742E626C5F636F756E745B685D2D2D2C6D2D3D327D7768696C65286D3E30293B666F7228633D683B30213D3D633B632D2D29666F72285F3D74';
wwv_flow_imp.g_varchar2_table(38) := '2E626C5F636F756E745B635D3B30213D3D5F3B29663D742E686561705B2D2D645D2C663E697C7C28615B322A662B315D213D3D63262628742E6F70745F6C656E2B3D28632D615B322A662B315D292A615B322A665D2C615B322A662B315D3D63292C5F2D';
wwv_flow_imp.g_varchar2_table(39) := '2D297D7D2928742C65292C4528612C642C742E626C5F636F756E74297D2C4F3D28742C652C61293D3E7B6C657420692C6E2C733D2D312C723D655B315D2C6F3D302C6C3D372C683D343B666F7228303D3D3D722626286C3D3133382C683D33292C655B32';
wwv_flow_imp.g_varchar2_table(40) := '2A28612B31292B315D3D36353533352C693D303B693C3D613B692B2B296E3D722C723D655B322A28692B31292B315D2C2B2B6F3C6C26266E3D3D3D727C7C286F3C683F742E626C5F747265655B322A6E5D2B3D6F3A30213D3D6E3F286E213D3D73262674';
wwv_flow_imp.g_varchar2_table(41) := '2E626C5F747265655B322A6E5D2B2B2C742E626C5F747265655B33325D2B2B293A6F3C3D31303F742E626C5F747265655B33345D2B2B3A742E626C5F747265655B33365D2B2B2C6F3D302C733D6E2C303D3D3D723F286C3D3133382C683D33293A6E3D3D';
wwv_flow_imp.g_varchar2_table(42) := '3D723F286C3D362C683D33293A286C3D372C683D3429297D2C493D28742C652C61293D3E7B6C657420692C6E2C733D2D312C723D655B315D2C6F3D302C6C3D372C683D343B666F7228303D3D3D722626286C3D3133382C683D33292C693D303B693C3D61';
wwv_flow_imp.g_varchar2_table(43) := '3B692B2B296966286E3D722C723D655B322A28692B31292B315D2C21282B2B6F3C6C26266E3D3D3D7229297B6966286F3C6829646F7B7A28742C6E2C742E626C5F74726565297D7768696C652830213D2D2D6F293B656C73652030213D3D6E3F286E213D';
wwv_flow_imp.g_varchar2_table(44) := '3D732626287A28742C6E2C742E626C5F74726565292C6F2D2D292C7A28742C31362C742E626C5F74726565292C7828742C6F2D332C3229293A6F3C3D31303F287A28742C31372C742E626C5F74726565292C7828742C6F2D332C3329293A287A28742C31';
wwv_flow_imp.g_varchar2_table(45) := '382C742E626C5F74726565292C7828742C6F2D31312C3729293B6F3D302C733D6E2C303D3D3D723F286C3D3133382C683D33293A6E3D3D3D723F286C3D362C683D33293A286C3D372C683D34297D7D3B6C657420463D21313B636F6E7374204C3D28742C';
wwv_flow_imp.g_varchar2_table(46) := '652C612C69293D3E7B7828742C302B28693F313A30292C33292C5A2874292C7928742C61292C7928742C7E61292C612626742E70656E64696E675F6275662E73657428742E77696E646F772E737562617272617928652C652B61292C742E70656E64696E';
wwv_flow_imp.g_varchar2_table(47) := '67292C742E70656E64696E672B3D617D3B766172204E3D28742C652C692C6E293D3E7B6C657420732C722C6F3D303B742E6C6576656C3E303F28323D3D3D742E7374726D2E646174615F74797065262628742E7374726D2E646174615F747970653D2874';
wwv_flow_imp.g_varchar2_table(48) := '3D3E7B6C657420652C693D343039333632343434373B666F7228653D303B653C3D33313B652B2B2C693E3E3E3D3129696628312669262630213D3D742E64796E5F6C747265655B322A655D2972657475726E20303B69662830213D3D742E64796E5F6C74';
wwv_flow_imp.g_varchar2_table(49) := '7265655B31385D7C7C30213D3D742E64796E5F6C747265655B32305D7C7C30213D3D742E64796E5F6C747265655B32365D2972657475726E20313B666F7228653D33323B653C613B652B2B2969662830213D3D742E64796E5F6C747265655B322A655D29';
wwv_flow_imp.g_varchar2_table(50) := '72657475726E20313B72657475726E20307D29287429292C5428742C742E6C5F64657363292C5428742C742E645F64657363292C6F3D28743D3E7B6C657420653B666F72284F28742C742E64796E5F6C747265652C742E6C5F646573632E6D61785F636F';
wwv_flow_imp.g_varchar2_table(51) := '6465292C4F28742C742E64796E5F64747265652C742E645F646573632E6D61785F636F6465292C5428742C742E626C5F64657363292C653D31383B653E3D332626303D3D3D742E626C5F747265655B322A685B655D2B315D3B652D2D293B72657475726E';
wwv_flow_imp.g_varchar2_table(52) := '20742E6F70745F6C656E2B3D332A28652B31292B352B352B342C657D292874292C733D742E6F70745F6C656E2B332B373E3E3E332C723D742E7374617469635F6C656E2B332B373E3E3E332C723C3D73262628733D7229293A733D723D692B352C692B34';
wwv_flow_imp.g_varchar2_table(53) := '3C3D7326262D31213D3D653F4C28742C652C692C6E293A343D3D3D742E73747261746567797C7C723D3D3D733F287828742C322B286E3F313A30292C33292C4428742C642C5F29293A287828742C342B286E3F313A30292C33292C2828742C652C612C69';
wwv_flow_imp.g_varchar2_table(54) := '293D3E7B6C6574206E3B666F72287828742C652D3235372C35292C7828742C612D312C35292C7828742C692D342C34292C6E3D303B6E3C693B6E2B2B297828742C742E626C5F747265655B322A685B6E5D2B315D2C33293B4928742C742E64796E5F6C74';
wwv_flow_imp.g_varchar2_table(55) := '7265652C652D31292C4928742C742E64796E5F64747265652C612D31297D2928742C742E6C5F646573632E6D61785F636F64652B312C742E645F646573632E6D61785F636F64652B312C6F2B31292C4428742C742E64796E5F6C747265652C742E64796E';
wwv_flow_imp.g_varchar2_table(56) := '5F647472656529292C522874292C6E26265A2874297D2C423D7B5F74725F696E69743A743D3E7B467C7C282828293D3E7B6C657420742C652C612C682C6B3B636F6E737420763D6E6577204172726179283136293B666F7228613D302C683D303B683C32';
wwv_flow_imp.g_varchar2_table(57) := '383B682B2B29666F7228755B685D3D612C743D303B743C313C3C725B685D3B742B2B29635B612B2B5D3D683B666F7228635B612D315D3D682C6B3D302C683D303B683C31363B682B2B29666F7228775B685D3D6B2C743D303B743C313C3C6F5B685D3B74';
wwv_flow_imp.g_varchar2_table(58) := '2B2B29665B6B2B2B5D3D683B666F72286B3E3E3D373B683C6E3B682B2B29666F7228775B685D3D6B3C3C372C743D303B743C313C3C6F5B685D2D373B742B2B29665B3235362B6B2B2B5D3D683B666F7228653D303B653C3D733B652B2B29765B655D3D30';
wwv_flow_imp.g_varchar2_table(59) := '3B666F7228743D303B743C3D3134333B29645B322A742B315D3D382C742B2B2C765B385D2B2B3B666F72283B743C3D3235353B29645B322A742B315D3D392C742B2B2C765B395D2B2B3B666F72283B743C3D3237393B29645B322A742B315D3D372C742B';
wwv_flow_imp.g_varchar2_table(60) := '2B2C765B375D2B2B3B666F72283B743C3D3238373B29645B322A742B315D3D382C742B2B2C765B385D2B2B3B666F72284528642C3238372C76292C743D303B743C6E3B742B2B295F5B322A742B315D3D352C5F5B322A745D3D4128742C35293B623D6E65';
wwv_flow_imp.g_varchar2_table(61) := '77206D28642C722C3235372C692C73292C673D6E6577206D285F2C6F2C302C6E2C73292C703D6E6577206D286E65772041727261792830292C6C2C302C31392C37297D2928292C463D2130292C742E6C5F646573633D6E6577206B28742E64796E5F6C74';
wwv_flow_imp.g_varchar2_table(62) := '7265652C62292C742E645F646573633D6E6577206B28742E64796E5F64747265652C67292C742E626C5F646573633D6E6577206B28742E626C5F747265652C70292C742E62695F6275663D302C742E62695F76616C69643D302C522874297D2C5F74725F';
wwv_flow_imp.g_varchar2_table(63) := '73746F7265645F626C6F636B3A4C2C5F74725F666C7573685F626C6F636B3A4E2C5F74725F74616C6C793A28742C652C69293D3E28742E70656E64696E675F6275665B742E73796D5F6275662B742E73796D5F6E6578742B2B5D3D652C742E70656E6469';
wwv_flow_imp.g_varchar2_table(64) := '6E675F6275665B742E73796D5F6275662B742E73796D5F6E6578742B2B5D3D653E3E382C742E70656E64696E675F6275665B742E73796D5F6275662B742E73796D5F6E6578742B2B5D3D692C303D3D3D653F742E64796E5F6C747265655B322A695D2B2B';
wwv_flow_imp.g_varchar2_table(65) := '3A28742E6D6174636865732B2B2C652D2D2C742E64796E5F6C747265655B322A28635B695D2B612B31295D2B2B2C742E64796E5F64747265655B322A762865295D2B2B292C742E73796D5F6E6578743D3D3D742E73796D5F656E64292C5F74725F616C69';
wwv_flow_imp.g_varchar2_table(66) := '676E3A743D3E7B7828742C322C33292C7A28742C3235362C64292C28743D3E7B31363D3D3D742E62695F76616C69643F287928742C742E62695F627566292C742E62695F6275663D302C742E62695F76616C69643D30293A742E62695F76616C69643E3D';
wwv_flow_imp.g_varchar2_table(67) := '38262628742E70656E64696E675F6275665B742E70656E64696E672B2B5D3D32353526742E62695F6275662C742E62695F6275663E3E3D382C742E62695F76616C69642D3D38297D292874297D7D3B76617220433D28742C652C612C69293D3E7B6C6574';
wwv_flow_imp.g_varchar2_table(68) := '206E3D363535333526747C302C733D743E3E3E31362636353533357C302C723D303B666F72283B30213D3D613B297B723D613E3265333F3265333A612C612D3D723B646F7B6E3D6E2B655B692B2B5D7C302C733D732B6E7C307D7768696C65282D2D7229';
wwv_flow_imp.g_varchar2_table(69) := '3B6E253D36353532312C73253D36353532317D72657475726E206E7C733C3C31367C307D3B636F6E7374204D3D6E65772055696E7433324172726179282828293D3E7B6C657420742C653D5B5D3B666F722876617220613D303B613C3235363B612B2B29';
wwv_flow_imp.g_varchar2_table(70) := '7B743D613B666F722876617220693D303B693C383B692B2B29743D3126743F333938383239323338345E743E3E3E313A743E3E3E313B655B615D3D747D72657475726E20657D292829293B76617220483D28742C652C612C69293D3E7B636F6E7374206E';
wwv_flow_imp.g_varchar2_table(71) := '3D4D2C733D692B613B745E3D2D313B666F72286C657420613D693B613C733B612B2B29743D743E3E3E385E6E5B3235352628745E655B615D295D3B72657475726E2D315E747D2C6A3D7B323A226E6565642064696374696F6E617279222C313A22737472';
wwv_flow_imp.g_varchar2_table(72) := '65616D20656E64222C303A22222C222D31223A2266696C65206572726F72222C222D32223A2273747265616D206572726F72222C222D33223A2264617461206572726F72222C222D34223A22696E73756666696369656E74206D656D6F7279222C222D35';
wwv_flow_imp.g_varchar2_table(73) := '223A22627566666572206572726F72222C222D36223A22696E636F6D70617469626C652076657273696F6E227D2C4B3D7B5A5F4E4F5F464C5553483A302C5A5F5041525449414C5F464C5553483A312C5A5F53594E435F464C5553483A322C5A5F46554C';
wwv_flow_imp.g_varchar2_table(74) := '4C5F464C5553483A332C5A5F46494E4953483A342C5A5F424C4F434B3A352C5A5F54524545533A362C5A5F4F4B3A302C5A5F53545245414D5F454E443A312C5A5F4E4545445F444943543A322C5A5F4552524E4F3A2D312C5A5F53545245414D5F455252';
wwv_flow_imp.g_varchar2_table(75) := '4F523A2D322C5A5F444154415F4552524F523A2D332C5A5F4D454D5F4552524F523A2D342C5A5F4255465F4552524F523A2D352C5A5F4E4F5F434F4D5052455353494F4E3A302C5A5F424553545F53504545443A312C5A5F424553545F434F4D50524553';
wwv_flow_imp.g_varchar2_table(76) := '53494F4E3A392C5A5F44454641554C545F434F4D5052455353494F4E3A2D312C5A5F46494C54455245443A312C5A5F485546464D414E5F4F4E4C593A322C5A5F524C453A332C5A5F46495845443A342C5A5F44454641554C545F53545241544547593A30';
wwv_flow_imp.g_varchar2_table(77) := '2C5A5F42494E4152593A302C5A5F544558543A312C5A5F554E4B4E4F574E3A322C5A5F4445464C415445443A387D3B636F6E73747B5F74725F696E69743A502C5F74725F73746F7265645F626C6F636B3A592C5F74725F666C7573685F626C6F636B3A47';
wwv_flow_imp.g_varchar2_table(78) := '2C5F74725F74616C6C793A582C5F74725F616C69676E3A577D3D422C7B5A5F4E4F5F464C5553483A712C5A5F5041525449414C5F464C5553483A4A2C5A5F46554C4C5F464C5553483A512C5A5F46494E4953483A562C5A5F424C4F434B3A242C5A5F4F4B';
wwv_flow_imp.g_varchar2_table(79) := '3A74742C5A5F53545245414D5F454E443A65742C5A5F53545245414D5F4552524F523A61742C5A5F444154415F4552524F523A69742C5A5F4255465F4552524F523A6E742C5A5F44454641554C545F434F4D5052455353494F4E3A73742C5A5F46494C54';
wwv_flow_imp.g_varchar2_table(80) := '455245443A72742C5A5F485546464D414E5F4F4E4C593A6F742C5A5F524C453A6C742C5A5F46495845443A68742C5A5F44454641554C545F53545241544547593A64742C5A5F554E4B4E4F574E3A5F742C5A5F4445464C415445443A66747D3D4B2C6374';
wwv_flow_imp.g_varchar2_table(81) := '3D3235382C75743D3236322C77743D34322C6D743D3131332C62743D3636362C67743D28742C65293D3E28742E6D73673D6A5B655D2C65292C70743D743D3E322A742D28743E343F393A30292C6B743D743D3E7B6C657420653D742E6C656E6774683B66';
wwv_flow_imp.g_varchar2_table(82) := '6F72283B2D2D653E3D303B29745B655D3D307D2C76743D743D3E7B6C657420652C612C692C6E3D742E775F73697A653B653D742E686173685F73697A652C693D653B646F7B613D742E686561645B2D2D695D2C742E686561645B695D3D613E3D6E3F612D';
wwv_flow_imp.g_varchar2_table(83) := '6E3A307D7768696C65282D2D65293B653D6E2C693D653B646F7B613D742E707265765B2D2D695D2C742E707265765B695D3D613E3D6E3F612D6E3A307D7768696C65282D2D65297D3B6C65742079743D28742C652C61293D3E28653C3C742E686173685F';
wwv_flow_imp.g_varchar2_table(84) := '73686966745E612926742E686173685F6D61736B3B636F6E73742078743D743D3E7B636F6E737420653D742E73746174653B6C657420613D652E70656E64696E673B613E742E617661696C5F6F7574262628613D742E617661696C5F6F7574292C30213D';
wwv_flow_imp.g_varchar2_table(85) := '3D61262628742E6F75747075742E73657428652E70656E64696E675F6275662E737562617272617928652E70656E64696E675F6F75742C652E70656E64696E675F6F75742B61292C742E6E6578745F6F7574292C742E6E6578745F6F75742B3D612C652E';
wwv_flow_imp.g_varchar2_table(86) := '70656E64696E675F6F75742B3D612C742E746F74616C5F6F75742B3D612C742E617661696C5F6F75742D3D612C652E70656E64696E672D3D612C303D3D3D652E70656E64696E67262628652E70656E64696E675F6F75743D3029297D2C7A743D28742C65';
wwv_flow_imp.g_varchar2_table(87) := '293D3E7B4728742C742E626C6F636B5F73746172743E3D303F742E626C6F636B5F73746172743A2D312C742E73747273746172742D742E626C6F636B5F73746172742C65292C742E626C6F636B5F73746172743D742E73747273746172742C787428742E';
wwv_flow_imp.g_varchar2_table(88) := '7374726D297D2C41743D28742C65293D3E7B742E70656E64696E675F6275665B742E70656E64696E672B2B5D3D657D2C45743D28742C65293D3E7B742E70656E64696E675F6275665B742E70656E64696E672B2B5D3D653E3E3E38263235352C742E7065';
wwv_flow_imp.g_varchar2_table(89) := '6E64696E675F6275665B742E70656E64696E672B2B5D3D32353526657D2C52743D28742C652C612C69293D3E7B6C6574206E3D742E617661696C5F696E3B72657475726E206E3E692626286E3D69292C303D3D3D6E3F303A28742E617661696C5F696E2D';
wwv_flow_imp.g_varchar2_table(90) := '3D6E2C652E73657428742E696E7075742E737562617272617928742E6E6578745F696E2C742E6E6578745F696E2B6E292C61292C313D3D3D742E73746174652E777261703F742E61646C65723D4328742E61646C65722C652C6E2C61293A323D3D3D742E';
wwv_flow_imp.g_varchar2_table(91) := '73746174652E77726170262628742E61646C65723D4828742E61646C65722C652C6E2C6129292C742E6E6578745F696E2B3D6E2C742E746F74616C5F696E2B3D6E2C6E297D2C5A743D28742C65293D3E7B6C657420612C692C6E3D742E6D61785F636861';
wwv_flow_imp.g_varchar2_table(92) := '696E5F6C656E6774682C733D742E73747273746172742C723D742E707265765F6C656E6774682C6F3D742E6E6963655F6D617463683B636F6E7374206C3D742E73747273746172743E742E775F73697A652D75743F742E73747273746172742D28742E77';
wwv_flow_imp.g_varchar2_table(93) := '5F73697A652D7574293A302C683D742E77696E646F772C643D742E775F6D61736B2C5F3D742E707265762C663D742E73747273746172742B63743B6C657420633D685B732B722D315D2C753D685B732B725D3B742E707265765F6C656E6774683E3D742E';
wwv_flow_imp.g_varchar2_table(94) := '676F6F645F6D617463682626286E3E3E3D32292C6F3E742E6C6F6F6B61686561642626286F3D742E6C6F6F6B6168656164293B646F7B696628613D652C685B612B725D3D3D3D752626685B612B722D315D3D3D3D632626685B615D3D3D3D685B735D2626';
wwv_flow_imp.g_varchar2_table(95) := '685B2B2B615D3D3D3D685B732B315D297B732B3D322C612B2B3B646F7B7D7768696C6528685B2B2B735D3D3D3D685B2B2B615D2626685B2B2B735D3D3D3D685B2B2B615D2626685B2B2B735D3D3D3D685B2B2B615D2626685B2B2B735D3D3D3D685B2B2B';
wwv_flow_imp.g_varchar2_table(96) := '615D2626685B2B2B735D3D3D3D685B2B2B615D2626685B2B2B735D3D3D3D685B2B2B615D2626685B2B2B735D3D3D3D685B2B2B615D2626685B2B2B735D3D3D3D685B2B2B615D2626733C66293B696628693D63742D28662D73292C733D662D63742C693E';
wwv_flow_imp.g_varchar2_table(97) := '72297B696628742E6D617463685F73746172743D652C723D692C693E3D6F29627265616B3B633D685B732B722D315D2C753D685B732B725D7D7D7D7768696C652828653D5F5B6526645D293E6C262630213D2D2D6E293B72657475726E20723C3D742E6C';
wwv_flow_imp.g_varchar2_table(98) := '6F6F6B61686561643F723A742E6C6F6F6B61686561647D2C55743D743D3E7B636F6E737420653D742E775F73697A653B6C657420612C692C6E3B646F7B696628693D742E77696E646F775F73697A652D742E6C6F6F6B61686561642D742E737472737461';
wwv_flow_imp.g_varchar2_table(99) := '72742C742E73747273746172743E3D652B28652D757429262628742E77696E646F772E73657428742E77696E646F772E737562617272617928652C652B652D69292C30292C742E6D617463685F73746172742D3D652C742E73747273746172742D3D652C';
wwv_flow_imp.g_varchar2_table(100) := '742E626C6F636B5F73746172742D3D652C742E696E736572743E742E7374727374617274262628742E696E736572743D742E7374727374617274292C76742874292C692B3D65292C303D3D3D742E7374726D2E617661696C5F696E29627265616B3B6966';
wwv_flow_imp.g_varchar2_table(101) := '28613D527428742E7374726D2C742E77696E646F772C742E73747273746172742B742E6C6F6F6B61686561642C69292C742E6C6F6F6B61686561642B3D612C742E6C6F6F6B61686561642B742E696E736572743E3D3329666F72286E3D742E7374727374';
wwv_flow_imp.g_varchar2_table(102) := '6172742D742E696E736572742C742E696E735F683D742E77696E646F775B6E5D2C742E696E735F683D797428742C742E696E735F682C742E77696E646F775B6E2B315D293B742E696E73657274262628742E696E735F683D797428742C742E696E735F68';
wwv_flow_imp.g_varchar2_table(103) := '2C742E77696E646F775B6E2B332D315D292C742E707265765B6E26742E775F6D61736B5D3D742E686561645B742E696E735F685D2C742E686561645B742E696E735F685D3D6E2C6E2B2B2C742E696E736572742D2D2C2128742E6C6F6F6B61686561642B';
wwv_flow_imp.g_varchar2_table(104) := '742E696E736572743C3329293B293B7D7768696C6528742E6C6F6F6B61686561643C7574262630213D3D742E7374726D2E617661696C5F696E297D2C53743D28742C65293D3E7B6C657420612C692C6E2C733D742E70656E64696E675F6275665F73697A';
wwv_flow_imp.g_varchar2_table(105) := '652D353E742E775F73697A653F742E775F73697A653A742E70656E64696E675F6275665F73697A652D352C723D302C6F3D742E7374726D2E617661696C5F696E3B646F7B696628613D36353533352C6E3D742E62695F76616C69642B34323E3E332C742E';
wwv_flow_imp.g_varchar2_table(106) := '7374726D2E617661696C5F6F75743C6E29627265616B3B6966286E3D742E7374726D2E617661696C5F6F75742D6E2C693D742E73747273746172742D742E626C6F636B5F73746172742C613E692B742E7374726D2E617661696C5F696E262628613D692B';
wwv_flow_imp.g_varchar2_table(107) := '742E7374726D2E617661696C5F696E292C613E6E262628613D6E292C613C73262628303D3D3D61262665213D3D567C7C653D3D3D717C7C61213D3D692B742E7374726D2E617661696C5F696E2929627265616B3B723D653D3D3D562626613D3D3D692B74';
wwv_flow_imp.g_varchar2_table(108) := '2E7374726D2E617661696C5F696E3F313A302C5928742C302C302C72292C742E70656E64696E675F6275665B742E70656E64696E672D345D3D612C742E70656E64696E675F6275665B742E70656E64696E672D335D3D613E3E382C742E70656E64696E67';
wwv_flow_imp.g_varchar2_table(109) := '5F6275665B742E70656E64696E672D325D3D7E612C742E70656E64696E675F6275665B742E70656E64696E672D315D3D7E613E3E382C787428742E7374726D292C69262628693E61262628693D61292C742E7374726D2E6F75747075742E73657428742E';
wwv_flow_imp.g_varchar2_table(110) := '77696E646F772E737562617272617928742E626C6F636B5F73746172742C742E626C6F636B5F73746172742B69292C742E7374726D2E6E6578745F6F7574292C742E7374726D2E6E6578745F6F75742B3D692C742E7374726D2E617661696C5F6F75742D';
wwv_flow_imp.g_varchar2_table(111) := '3D692C742E7374726D2E746F74616C5F6F75742B3D692C742E626C6F636B5F73746172742B3D692C612D3D69292C61262628527428742E7374726D2C742E7374726D2E6F75747075742C742E7374726D2E6E6578745F6F75742C61292C742E7374726D2E';
wwv_flow_imp.g_varchar2_table(112) := '6E6578745F6F75742B3D612C742E7374726D2E617661696C5F6F75742D3D612C742E7374726D2E746F74616C5F6F75742B3D61297D7768696C6528303D3D3D72293B72657475726E206F2D3D742E7374726D2E617661696C5F696E2C6F2626286F3E3D74';
wwv_flow_imp.g_varchar2_table(113) := '2E775F73697A653F28742E6D6174636865733D322C742E77696E646F772E73657428742E7374726D2E696E7075742E737562617272617928742E7374726D2E6E6578745F696E2D742E775F73697A652C742E7374726D2E6E6578745F696E292C30292C74';
wwv_flow_imp.g_varchar2_table(114) := '2E73747273746172743D742E775F73697A652C742E696E736572743D742E7374727374617274293A28742E77696E646F775F73697A652D742E73747273746172743C3D6F262628742E73747273746172742D3D742E775F73697A652C742E77696E646F77';
wwv_flow_imp.g_varchar2_table(115) := '2E73657428742E77696E646F772E737562617272617928742E775F73697A652C742E775F73697A652B742E7374727374617274292C30292C742E6D6174636865733C322626742E6D6174636865732B2B2C742E696E736572743E742E7374727374617274';
wwv_flow_imp.g_varchar2_table(116) := '262628742E696E736572743D742E737472737461727429292C742E77696E646F772E73657428742E7374726D2E696E7075742E737562617272617928742E7374726D2E6E6578745F696E2D6F2C742E7374726D2E6E6578745F696E292C742E7374727374';
wwv_flow_imp.g_varchar2_table(117) := '617274292C742E73747273746172742B3D6F2C742E696E736572742B3D6F3E742E775F73697A652D742E696E736572743F742E775F73697A652D742E696E736572743A6F292C742E626C6F636B5F73746172743D742E7374727374617274292C742E6869';
wwv_flow_imp.g_varchar2_table(118) := '67685F77617465723C742E7374727374617274262628742E686967685F77617465723D742E7374727374617274292C723F343A65213D3D71262665213D3D562626303D3D3D742E7374726D2E617661696C5F696E2626742E73747273746172743D3D3D74';
wwv_flow_imp.g_varchar2_table(119) := '2E626C6F636B5F73746172743F323A286E3D742E77696E646F775F73697A652D742E73747273746172742C742E7374726D2E617661696C5F696E3E6E2626742E626C6F636B5F73746172743E3D742E775F73697A65262628742E626C6F636B5F73746172';
wwv_flow_imp.g_varchar2_table(120) := '742D3D742E775F73697A652C742E73747273746172742D3D742E775F73697A652C742E77696E646F772E73657428742E77696E646F772E737562617272617928742E775F73697A652C742E775F73697A652B742E7374727374617274292C30292C742E6D';
wwv_flow_imp.g_varchar2_table(121) := '6174636865733C322626742E6D6174636865732B2B2C6E2B3D742E775F73697A652C742E696E736572743E742E7374727374617274262628742E696E736572743D742E737472737461727429292C6E3E742E7374726D2E617661696C5F696E2626286E3D';
wwv_flow_imp.g_varchar2_table(122) := '742E7374726D2E617661696C5F696E292C6E262628527428742E7374726D2C742E77696E646F772C742E73747273746172742C6E292C742E73747273746172742B3D6E2C742E696E736572742B3D6E3E742E775F73697A652D742E696E736572743F742E';
wwv_flow_imp.g_varchar2_table(123) := '775F73697A652D742E696E736572743A6E292C742E686967685F77617465723C742E7374727374617274262628742E686967685F77617465723D742E7374727374617274292C6E3D742E62695F76616C69642B34323E3E332C6E3D742E70656E64696E67';
wwv_flow_imp.g_varchar2_table(124) := '5F6275665F73697A652D6E3E36353533353F36353533353A742E70656E64696E675F6275665F73697A652D6E2C733D6E3E742E775F73697A653F742E775F73697A653A6E2C693D742E73747273746172742D742E626C6F636B5F73746172742C28693E3D';
wwv_flow_imp.g_varchar2_table(125) := '737C7C28697C7C653D3D3D5629262665213D3D712626303D3D3D742E7374726D2E617661696C5F696E2626693C3D6E29262628613D693E6E3F6E3A692C723D653D3D3D562626303D3D3D742E7374726D2E617661696C5F696E2626613D3D3D693F313A30';
wwv_flow_imp.g_varchar2_table(126) := '2C5928742C742E626C6F636B5F73746172742C612C72292C742E626C6F636B5F73746172742B3D612C787428742E7374726D29292C723F333A31297D2C44743D28742C65293D3E7B6C657420612C693B666F72283B3B297B696628742E6C6F6F6B616865';
wwv_flow_imp.g_varchar2_table(127) := '61643C7574297B69662855742874292C742E6C6F6F6B61686561643C75742626653D3D3D712972657475726E20313B696628303D3D3D742E6C6F6F6B616865616429627265616B7D696628613D302C742E6C6F6F6B61686561643E3D33262628742E696E';
wwv_flow_imp.g_varchar2_table(128) := '735F683D797428742C742E696E735F682C742E77696E646F775B742E73747273746172742B332D315D292C613D742E707265765B742E737472737461727426742E775F6D61736B5D3D742E686561645B742E696E735F685D2C742E686561645B742E696E';
wwv_flow_imp.g_varchar2_table(129) := '735F685D3D742E7374727374617274292C30213D3D612626742E73747273746172742D613C3D742E775F73697A652D7574262628742E6D617463685F6C656E6774683D5A7428742C6129292C742E6D617463685F6C656E6774683E3D3329696628693D58';
wwv_flow_imp.g_varchar2_table(130) := '28742C742E73747273746172742D742E6D617463685F73746172742C742E6D617463685F6C656E6774682D33292C742E6C6F6F6B61686561642D3D742E6D617463685F6C656E6774682C742E6D617463685F6C656E6774683C3D742E6D61785F6C617A79';
wwv_flow_imp.g_varchar2_table(131) := '5F6D617463682626742E6C6F6F6B61686561643E3D33297B742E6D617463685F6C656E6774682D2D3B646F7B742E73747273746172742B2B2C742E696E735F683D797428742C742E696E735F682C742E77696E646F775B742E73747273746172742B332D';
wwv_flow_imp.g_varchar2_table(132) := '315D292C613D742E707265765B742E737472737461727426742E775F6D61736B5D3D742E686561645B742E696E735F685D2C742E686561645B742E696E735F685D3D742E73747273746172747D7768696C652830213D2D2D742E6D617463685F6C656E67';
wwv_flow_imp.g_varchar2_table(133) := '7468293B742E73747273746172742B2B7D656C736520742E73747273746172742B3D742E6D617463685F6C656E6774682C742E6D617463685F6C656E6774683D302C742E696E735F683D742E77696E646F775B742E73747273746172745D2C742E696E73';
wwv_flow_imp.g_varchar2_table(134) := '5F683D797428742C742E696E735F682C742E77696E646F775B742E73747273746172742B315D293B656C736520693D5828742C302C742E77696E646F775B742E73747273746172745D292C742E6C6F6F6B61686561642D2D2C742E73747273746172742B';
wwv_flow_imp.g_varchar2_table(135) := '2B3B696628692626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574292972657475726E20317D72657475726E20742E696E736572743D742E73747273746172743C323F742E73747273746172743A322C653D3D3D563F287A74';
wwv_flow_imp.g_varchar2_table(136) := '28742C2130292C303D3D3D742E7374726D2E617661696C5F6F75743F333A34293A742E73796D5F6E6578742626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574293F313A327D2C54743D28742C65293D3E7B6C657420612C69';
wwv_flow_imp.g_varchar2_table(137) := '2C6E3B666F72283B3B297B696628742E6C6F6F6B61686561643C7574297B69662855742874292C742E6C6F6F6B61686561643C75742626653D3D3D712972657475726E20313B696628303D3D3D742E6C6F6F6B616865616429627265616B7D696628613D';
wwv_flow_imp.g_varchar2_table(138) := '302C742E6C6F6F6B61686561643E3D33262628742E696E735F683D797428742C742E696E735F682C742E77696E646F775B742E73747273746172742B332D315D292C613D742E707265765B742E737472737461727426742E775F6D61736B5D3D742E6865';
wwv_flow_imp.g_varchar2_table(139) := '61645B742E696E735F685D2C742E686561645B742E696E735F685D3D742E7374727374617274292C742E707265765F6C656E6774683D742E6D617463685F6C656E6774682C742E707265765F6D617463683D742E6D617463685F73746172742C742E6D61';
wwv_flow_imp.g_varchar2_table(140) := '7463685F6C656E6774683D322C30213D3D612626742E707265765F6C656E6774683C742E6D61785F6C617A795F6D617463682626742E73747273746172742D613C3D742E775F73697A652D7574262628742E6D617463685F6C656E6774683D5A7428742C';
wwv_flow_imp.g_varchar2_table(141) := '61292C742E6D617463685F6C656E6774683C3D35262628742E73747261746567793D3D3D72747C7C333D3D3D742E6D617463685F6C656E6774682626742E73747273746172742D742E6D617463685F73746172743E3430393629262628742E6D61746368';
wwv_flow_imp.g_varchar2_table(142) := '5F6C656E6774683D3229292C742E707265765F6C656E6774683E3D332626742E6D617463685F6C656E6774683C3D742E707265765F6C656E677468297B6E3D742E73747273746172742B742E6C6F6F6B61686561642D332C693D5828742C742E73747273';
wwv_flow_imp.g_varchar2_table(143) := '746172742D312D742E707265765F6D617463682C742E707265765F6C656E6774682D33292C742E6C6F6F6B61686561642D3D742E707265765F6C656E6774682D312C742E707265765F6C656E6774682D3D323B646F7B2B2B742E73747273746172743C3D';
wwv_flow_imp.g_varchar2_table(144) := '6E262628742E696E735F683D797428742C742E696E735F682C742E77696E646F775B742E73747273746172742B332D315D292C613D742E707265765B742E737472737461727426742E775F6D61736B5D3D742E686561645B742E696E735F685D2C742E68';
wwv_flow_imp.g_varchar2_table(145) := '6561645B742E696E735F685D3D742E7374727374617274297D7768696C652830213D2D2D742E707265765F6C656E677468293B696628742E6D617463685F617661696C61626C653D302C742E6D617463685F6C656E6774683D322C742E73747273746172';
wwv_flow_imp.g_varchar2_table(146) := '742B2B2C692626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574292972657475726E20317D656C736520696628742E6D617463685F617661696C61626C65297B696628693D5828742C302C742E77696E646F775B742E737472';
wwv_flow_imp.g_varchar2_table(147) := '73746172742D315D292C6926267A7428742C2131292C742E73747273746172742B2B2C742E6C6F6F6B61686561642D2D2C303D3D3D742E7374726D2E617661696C5F6F75742972657475726E20317D656C736520742E6D617463685F617661696C61626C';
wwv_flow_imp.g_varchar2_table(148) := '653D312C742E73747273746172742B2B2C742E6C6F6F6B61686561642D2D7D72657475726E20742E6D617463685F617661696C61626C65262628693D5828742C302C742E77696E646F775B742E73747273746172742D315D292C742E6D617463685F6176';
wwv_flow_imp.g_varchar2_table(149) := '61696C61626C653D30292C742E696E736572743D742E73747273746172743C323F742E73747273746172743A322C653D3D3D563F287A7428742C2130292C303D3D3D742E7374726D2E617661696C5F6F75743F333A34293A742E73796D5F6E6578742626';
wwv_flow_imp.g_varchar2_table(150) := '287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574293F313A327D3B66756E6374696F6E204F7428742C652C612C692C6E297B746869732E676F6F645F6C656E6774683D742C746869732E6D61785F6C617A793D652C746869732E';
wwv_flow_imp.g_varchar2_table(151) := '6E6963655F6C656E6774683D612C746869732E6D61785F636861696E3D692C746869732E66756E633D6E7D636F6E73742049743D5B6E6577204F7428302C302C302C302C5374292C6E6577204F7428342C342C382C342C4474292C6E6577204F7428342C';
wwv_flow_imp.g_varchar2_table(152) := '352C31362C382C4474292C6E6577204F7428342C362C33322C33322C4474292C6E6577204F7428342C342C31362C31362C5474292C6E6577204F7428382C31362C33322C33322C5474292C6E6577204F7428382C31362C3132382C3132382C5474292C6E';
wwv_flow_imp.g_varchar2_table(153) := '6577204F7428382C33322C3132382C3235362C5474292C6E6577204F742833322C3132382C3235382C313032342C5474292C6E6577204F742833322C3235382C3235382C343039362C5474295D3B66756E6374696F6E20467428297B746869732E737472';
wwv_flow_imp.g_varchar2_table(154) := '6D3D6E756C6C2C746869732E7374617475733D302C746869732E70656E64696E675F6275663D6E756C6C2C746869732E70656E64696E675F6275665F73697A653D302C746869732E70656E64696E675F6F75743D302C746869732E70656E64696E673D30';
wwv_flow_imp.g_varchar2_table(155) := '2C746869732E777261703D302C746869732E677A686561643D6E756C6C2C746869732E677A696E6465783D302C746869732E6D6574686F643D66742C746869732E6C6173745F666C7573683D2D312C746869732E775F73697A653D302C746869732E775F';
wwv_flow_imp.g_varchar2_table(156) := '626974733D302C746869732E775F6D61736B3D302C746869732E77696E646F773D6E756C6C2C746869732E77696E646F775F73697A653D302C746869732E707265763D6E756C6C2C746869732E686561643D6E756C6C2C746869732E696E735F683D302C';
wwv_flow_imp.g_varchar2_table(157) := '746869732E686173685F73697A653D302C746869732E686173685F626974733D302C746869732E686173685F6D61736B3D302C746869732E686173685F73686966743D302C746869732E626C6F636B5F73746172743D302C746869732E6D617463685F6C';
wwv_flow_imp.g_varchar2_table(158) := '656E6774683D302C746869732E707265765F6D617463683D302C746869732E6D617463685F617661696C61626C653D302C746869732E73747273746172743D302C746869732E6D617463685F73746172743D302C746869732E6C6F6F6B61686561643D30';
wwv_flow_imp.g_varchar2_table(159) := '2C746869732E707265765F6C656E6774683D302C746869732E6D61785F636861696E5F6C656E6774683D302C746869732E6D61785F6C617A795F6D617463683D302C746869732E6C6576656C3D302C746869732E73747261746567793D302C746869732E';
wwv_flow_imp.g_varchar2_table(160) := '676F6F645F6D617463683D302C746869732E6E6963655F6D617463683D302C746869732E64796E5F6C747265653D6E65772055696E74313641727261792831313436292C746869732E64796E5F64747265653D6E65772055696E74313641727261792831';
wwv_flow_imp.g_varchar2_table(161) := '3232292C746869732E626C5F747265653D6E65772055696E7431364172726179283738292C6B7428746869732E64796E5F6C74726565292C6B7428746869732E64796E5F6474726565292C6B7428746869732E626C5F74726565292C746869732E6C5F64';
wwv_flow_imp.g_varchar2_table(162) := '6573633D6E756C6C2C746869732E645F646573633D6E756C6C2C746869732E626C5F646573633D6E756C6C2C746869732E626C5F636F756E743D6E65772055696E7431364172726179283136292C746869732E686561703D6E65772055696E7431364172';
wwv_flow_imp.g_varchar2_table(163) := '72617928353733292C6B7428746869732E68656170292C746869732E686561705F6C656E3D302C746869732E686561705F6D61783D302C746869732E64657074683D6E65772055696E743136417272617928353733292C6B7428746869732E6465707468';
wwv_flow_imp.g_varchar2_table(164) := '292C746869732E73796D5F6275663D302C746869732E6C69745F62756673697A653D302C746869732E73796D5F6E6578743D302C746869732E73796D5F656E643D302C746869732E6F70745F6C656E3D302C746869732E7374617469635F6C656E3D302C';
wwv_flow_imp.g_varchar2_table(165) := '746869732E6D6174636865733D302C746869732E696E736572743D302C746869732E62695F6275663D302C746869732E62695F76616C69643D307D636F6E7374204C743D743D3E7B69662821742972657475726E20313B636F6E737420653D742E737461';
wwv_flow_imp.g_varchar2_table(166) := '74653B72657475726E21657C7C652E7374726D213D3D747C7C652E737461747573213D3D777426263537213D3D652E73746174757326263639213D3D652E73746174757326263733213D3D652E73746174757326263931213D3D652E7374617475732626';
wwv_flow_imp.g_varchar2_table(167) := '313033213D3D652E7374617475732626652E737461747573213D3D6D742626652E737461747573213D3D62743F313A307D2C4E743D743D3E7B6966284C742874292972657475726E20677428742C6174293B742E746F74616C5F696E3D742E746F74616C';
wwv_flow_imp.g_varchar2_table(168) := '5F6F75743D302C742E646174615F747970653D5F743B636F6E737420653D742E73746174653B72657475726E20652E70656E64696E673D302C652E70656E64696E675F6F75743D302C652E777261703C30262628652E777261703D2D652E77726170292C';
wwv_flow_imp.g_varchar2_table(169) := '652E7374617475733D323D3D3D652E777261703F35373A652E777261703F77743A6D742C742E61646C65723D323D3D3D652E777261703F303A312C652E6C6173745F666C7573683D2D322C502865292C74747D2C42743D743D3E7B636F6E737420653D4E';
wwv_flow_imp.g_varchar2_table(170) := '742874293B76617220613B72657475726E20653D3D3D747426262828613D742E7374617465292E77696E646F775F73697A653D322A612E775F73697A652C6B7428612E68656164292C612E6D61785F6C617A795F6D617463683D49745B612E6C6576656C';
wwv_flow_imp.g_varchar2_table(171) := '5D2E6D61785F6C617A792C612E676F6F645F6D617463683D49745B612E6C6576656C5D2E676F6F645F6C656E6774682C612E6E6963655F6D617463683D49745B612E6C6576656C5D2E6E6963655F6C656E6774682C612E6D61785F636861696E5F6C656E';
wwv_flow_imp.g_varchar2_table(172) := '6774683D49745B612E6C6576656C5D2E6D61785F636861696E2C612E73747273746172743D302C612E626C6F636B5F73746172743D302C612E6C6F6F6B61686561643D302C612E696E736572743D302C612E6D617463685F6C656E6774683D612E707265';
wwv_flow_imp.g_varchar2_table(173) := '765F6C656E6774683D322C612E6D617463685F617661696C61626C653D302C612E696E735F683D30292C657D2C43743D28742C652C612C692C6E2C73293D3E7B69662821742972657475726E2061743B6C657420723D313B696628653D3D3D7374262628';
wwv_flow_imp.g_varchar2_table(174) := '653D36292C693C303F28723D302C693D2D69293A693E3135262628723D322C692D3D3136292C6E3C317C7C6E3E397C7C61213D3D66747C7C693C387C7C693E31357C7C653C307C7C653E397C7C733C307C7C733E68747C7C383D3D3D69262631213D3D72';
wwv_flow_imp.g_varchar2_table(175) := '2972657475726E20677428742C6174293B383D3D3D69262628693D39293B636F6E7374206F3D6E65772046743B72657475726E20742E73746174653D6F2C6F2E7374726D3D742C6F2E7374617475733D77742C6F2E777261703D722C6F2E677A68656164';
wwv_flow_imp.g_varchar2_table(176) := '3D6E756C6C2C6F2E775F626974733D692C6F2E775F73697A653D313C3C6F2E775F626974732C6F2E775F6D61736B3D6F2E775F73697A652D312C6F2E686173685F626974733D6E2B372C6F2E686173685F73697A653D313C3C6F2E686173685F62697473';
wwv_flow_imp.g_varchar2_table(177) := '2C6F2E686173685F6D61736B3D6F2E686173685F73697A652D312C6F2E686173685F73686966743D7E7E28286F2E686173685F626974732B332D31292F33292C6F2E77696E646F773D6E65772055696E7438417272617928322A6F2E775F73697A65292C';
wwv_flow_imp.g_varchar2_table(178) := '6F2E686561643D6E65772055696E7431364172726179286F2E686173685F73697A65292C6F2E707265763D6E65772055696E7431364172726179286F2E775F73697A65292C6F2E6C69745F62756673697A653D313C3C6E2B362C6F2E70656E64696E675F';
wwv_flow_imp.g_varchar2_table(179) := '6275665F73697A653D342A6F2E6C69745F62756673697A652C6F2E70656E64696E675F6275663D6E65772055696E74384172726179286F2E70656E64696E675F6275665F73697A65292C6F2E73796D5F6275663D6F2E6C69745F62756673697A652C6F2E';
wwv_flow_imp.g_varchar2_table(180) := '73796D5F656E643D332A286F2E6C69745F62756673697A652D31292C6F2E6C6576656C3D652C6F2E73747261746567793D732C6F2E6D6574686F643D612C42742874297D3B766172204D743D7B6465666C617465496E69743A28742C65293D3E43742874';
wwv_flow_imp.g_varchar2_table(181) := '2C652C66742C31352C382C6474292C6465666C617465496E6974323A43742C6465666C61746552657365743A42742C6465666C61746552657365744B6565703A4E742C6465666C6174655365744865616465723A28742C65293D3E4C742874297C7C3221';
wwv_flow_imp.g_varchar2_table(182) := '3D3D742E73746174652E777261703F61743A28742E73746174652E677A686561643D652C7474292C6465666C6174653A28742C65293D3E7B6966284C742874297C7C653E247C7C653C302972657475726E20743F677428742C6174293A61743B636F6E73';
wwv_flow_imp.g_varchar2_table(183) := '7420613D742E73746174653B69662821742E6F75747075747C7C30213D3D742E617661696C5F696E262621742E696E7075747C7C612E7374617475733D3D3D6274262665213D3D562972657475726E20677428742C303D3D3D742E617661696C5F6F7574';
wwv_flow_imp.g_varchar2_table(184) := '3F6E743A6174293B636F6E737420693D612E6C6173745F666C7573683B696628612E6C6173745F666C7573683D652C30213D3D612E70656E64696E67297B69662878742874292C303D3D3D742E617661696C5F6F75742972657475726E20612E6C617374';
wwv_flow_imp.g_varchar2_table(185) := '5F666C7573683D2D312C74747D656C736520696628303D3D3D742E617661696C5F696E262670742865293C3D7074286929262665213D3D562972657475726E20677428742C6E74293B696628612E7374617475733D3D3D6274262630213D3D742E617661';
wwv_flow_imp.g_varchar2_table(186) := '696C5F696E2972657475726E20677428742C6E74293B696628612E7374617475733D3D3D77742626303D3D3D612E77726170262628612E7374617475733D6D74292C612E7374617475733D3D3D7774297B6C657420653D66742B28612E775F626974732D';
wwv_flow_imp.g_varchar2_table(187) := '383C3C34293C3C382C693D2D313B696628693D612E73747261746567793E3D6F747C7C612E6C6576656C3C323F303A612E6C6576656C3C363F313A363D3D3D612E6C6576656C3F323A332C657C3D693C3C362C30213D3D612E7374727374617274262628';
wwv_flow_imp.g_varchar2_table(188) := '657C3D3332292C652B3D33312D652533312C457428612C65292C30213D3D612E7374727374617274262628457428612C742E61646C65723E3E3E3136292C457428612C363535333526742E61646C657229292C742E61646C65723D312C612E7374617475';
wwv_flow_imp.g_varchar2_table(189) := '733D6D742C78742874292C30213D3D612E70656E64696E672972657475726E20612E6C6173745F666C7573683D2D312C74747D69662835373D3D3D612E73746174757329696628742E61646C65723D302C417428612C3331292C417428612C313339292C';
wwv_flow_imp.g_varchar2_table(190) := '417428612C38292C612E677A6865616429417428612C28612E677A686561642E746578743F313A30292B28612E677A686561642E686372633F323A30292B28612E677A686561642E65787472613F343A30292B28612E677A686561642E6E616D653F383A';
wwv_flow_imp.g_varchar2_table(191) := '30292B28612E677A686561642E636F6D6D656E743F31363A3029292C417428612C32353526612E677A686561642E74696D65292C417428612C612E677A686561642E74696D653E3E3826323535292C417428612C612E677A686561642E74696D653E3E31';
wwv_flow_imp.g_varchar2_table(192) := '3626323535292C417428612C612E677A686561642E74696D653E3E323426323535292C417428612C393D3D3D612E6C6576656C3F323A612E73747261746567793E3D6F747C7C612E6C6576656C3C323F343A30292C417428612C32353526612E677A6865';
wwv_flow_imp.g_varchar2_table(193) := '61642E6F73292C612E677A686561642E65787472612626612E677A686561642E65787472612E6C656E677468262628417428612C32353526612E677A686561642E65787472612E6C656E677468292C417428612C612E677A686561642E65787472612E6C';
wwv_flow_imp.g_varchar2_table(194) := '656E6774683E3E382632353529292C612E677A686561642E68637263262628742E61646C65723D4828742E61646C65722C612E70656E64696E675F6275662C612E70656E64696E672C3029292C612E677A696E6465783D302C612E7374617475733D3639';
wwv_flow_imp.g_varchar2_table(195) := '3B656C736520696628417428612C30292C417428612C30292C417428612C30292C417428612C30292C417428612C30292C417428612C393D3D3D612E6C6576656C3F323A612E73747261746567793E3D6F747C7C612E6C6576656C3C323F343A30292C41';
wwv_flow_imp.g_varchar2_table(196) := '7428612C33292C612E7374617475733D6D742C78742874292C30213D3D612E70656E64696E672972657475726E20612E6C6173745F666C7573683D2D312C74743B69662836393D3D3D612E737461747573297B696628612E677A686561642E6578747261';
wwv_flow_imp.g_varchar2_table(197) := '297B6C657420653D612E70656E64696E672C693D28363535333526612E677A686561642E65787472612E6C656E677468292D612E677A696E6465783B666F72283B612E70656E64696E672B693E612E70656E64696E675F6275665F73697A653B297B6C65';
wwv_flow_imp.g_varchar2_table(198) := '74206E3D612E70656E64696E675F6275665F73697A652D612E70656E64696E673B696628612E70656E64696E675F6275662E73657428612E677A686561642E65787472612E737562617272617928612E677A696E6465782C612E677A696E6465782B6E29';
wwv_flow_imp.g_varchar2_table(199) := '2C612E70656E64696E67292C612E70656E64696E673D612E70656E64696E675F6275665F73697A652C612E677A686561642E686372632626612E70656E64696E673E65262628742E61646C65723D4828742E61646C65722C612E70656E64696E675F6275';
wwv_flow_imp.g_varchar2_table(200) := '662C612E70656E64696E672D652C6529292C612E677A696E6465782B3D6E2C78742874292C30213D3D612E70656E64696E672972657475726E20612E6C6173745F666C7573683D2D312C74743B653D302C692D3D6E7D6C6574206E3D6E65772055696E74';
wwv_flow_imp.g_varchar2_table(201) := '38417272617928612E677A686561642E6578747261293B612E70656E64696E675F6275662E736574286E2E737562617272617928612E677A696E6465782C612E677A696E6465782B69292C612E70656E64696E67292C612E70656E64696E672B3D692C61';
wwv_flow_imp.g_varchar2_table(202) := '2E677A686561642E686372632626612E70656E64696E673E65262628742E61646C65723D4828742E61646C65722C612E70656E64696E675F6275662C612E70656E64696E672D652C6529292C612E677A696E6465783D307D612E7374617475733D37337D';
wwv_flow_imp.g_varchar2_table(203) := '69662837333D3D3D612E737461747573297B696628612E677A686561642E6E616D65297B6C657420652C693D612E70656E64696E673B646F7B696628612E70656E64696E673D3D3D612E70656E64696E675F6275665F73697A65297B696628612E677A68';
wwv_flow_imp.g_varchar2_table(204) := '6561642E686372632626612E70656E64696E673E69262628742E61646C65723D4828742E61646C65722C612E70656E64696E675F6275662C612E70656E64696E672D692C6929292C78742874292C30213D3D612E70656E64696E672972657475726E2061';
wwv_flow_imp.g_varchar2_table(205) := '2E6C6173745F666C7573683D2D312C74743B693D307D653D612E677A696E6465783C612E677A686561642E6E616D652E6C656E6774683F32353526612E677A686561642E6E616D652E63686172436F6465417428612E677A696E6465782B2B293A302C41';
wwv_flow_imp.g_varchar2_table(206) := '7428612C65297D7768696C652830213D3D65293B612E677A686561642E686372632626612E70656E64696E673E69262628742E61646C65723D4828742E61646C65722C612E70656E64696E675F6275662C612E70656E64696E672D692C6929292C612E67';
wwv_flow_imp.g_varchar2_table(207) := '7A696E6465783D307D612E7374617475733D39317D69662839313D3D3D612E737461747573297B696628612E677A686561642E636F6D6D656E74297B6C657420652C693D612E70656E64696E673B646F7B696628612E70656E64696E673D3D3D612E7065';
wwv_flow_imp.g_varchar2_table(208) := '6E64696E675F6275665F73697A65297B696628612E677A686561642E686372632626612E70656E64696E673E69262628742E61646C65723D4828742E61646C65722C612E70656E64696E675F6275662C612E70656E64696E672D692C6929292C78742874';
wwv_flow_imp.g_varchar2_table(209) := '292C30213D3D612E70656E64696E672972657475726E20612E6C6173745F666C7573683D2D312C74743B693D307D653D612E677A696E6465783C612E677A686561642E636F6D6D656E742E6C656E6774683F32353526612E677A686561642E636F6D6D65';
wwv_flow_imp.g_varchar2_table(210) := '6E742E63686172436F6465417428612E677A696E6465782B2B293A302C417428612C65297D7768696C652830213D3D65293B612E677A686561642E686372632626612E70656E64696E673E69262628742E61646C65723D4828742E61646C65722C612E70';
wwv_flow_imp.g_varchar2_table(211) := '656E64696E675F6275662C612E70656E64696E672D692C6929297D612E7374617475733D3130337D6966283130333D3D3D612E737461747573297B696628612E677A686561642E68637263297B696628612E70656E64696E672B323E612E70656E64696E';
wwv_flow_imp.g_varchar2_table(212) := '675F6275665F73697A6526262878742874292C30213D3D612E70656E64696E67292972657475726E20612E6C6173745F666C7573683D2D312C74743B417428612C32353526742E61646C6572292C417428612C742E61646C65723E3E3826323535292C74';
wwv_flow_imp.g_varchar2_table(213) := '2E61646C65723D307D696628612E7374617475733D6D742C78742874292C30213D3D612E70656E64696E672972657475726E20612E6C6173745F666C7573683D2D312C74747D69662830213D3D742E617661696C5F696E7C7C30213D3D612E6C6F6F6B61';
wwv_flow_imp.g_varchar2_table(214) := '686561647C7C65213D3D712626612E737461747573213D3D6274297B6C657420693D303D3D3D612E6C6576656C3F537428612C65293A612E73747261746567793D3D3D6F743F2828742C65293D3E7B6C657420613B666F72283B3B297B696628303D3D3D';
wwv_flow_imp.g_varchar2_table(215) := '742E6C6F6F6B616865616426262855742874292C303D3D3D742E6C6F6F6B616865616429297B696628653D3D3D712972657475726E20313B627265616B7D696628742E6D617463685F6C656E6774683D302C613D5828742C302C742E77696E646F775B74';
wwv_flow_imp.g_varchar2_table(216) := '2E73747273746172745D292C742E6C6F6F6B61686561642D2D2C742E73747273746172742B2B2C612626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574292972657475726E20317D72657475726E20742E696E736572743D30';
wwv_flow_imp.g_varchar2_table(217) := '2C653D3D3D563F287A7428742C2130292C303D3D3D742E7374726D2E617661696C5F6F75743F333A34293A742E73796D5F6E6578742626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574293F313A327D2928612C65293A612E';
wwv_flow_imp.g_varchar2_table(218) := '73747261746567793D3D3D6C743F2828742C65293D3E7B6C657420612C692C6E2C733B636F6E737420723D742E77696E646F773B666F72283B3B297B696628742E6C6F6F6B61686561643C3D6374297B69662855742874292C742E6C6F6F6B6168656164';
wwv_flow_imp.g_varchar2_table(219) := '3C3D63742626653D3D3D712972657475726E20313B696628303D3D3D742E6C6F6F6B616865616429627265616B7D696628742E6D617463685F6C656E6774683D302C742E6C6F6F6B61686561643E3D332626742E73747273746172743E302626286E3D74';
wwv_flow_imp.g_varchar2_table(220) := '2E73747273746172742D312C693D725B6E5D2C693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D29297B733D742E73747273746172742B63743B646F7B7D7768696C6528693D3D3D725B2B2B6E5D2626693D3D3D725B';
wwv_flow_imp.g_varchar2_table(221) := '2B2B6E5D2626693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D2626693D3D3D725B2B2B6E5D26266E3C73293B742E6D617463685F6C656E6774683D6374';
wwv_flow_imp.g_varchar2_table(222) := '2D28732D6E292C742E6D617463685F6C656E6774683E742E6C6F6F6B6168656164262628742E6D617463685F6C656E6774683D742E6C6F6F6B6168656164297D696628742E6D617463685F6C656E6774683E3D333F28613D5828742C312C742E6D617463';
wwv_flow_imp.g_varchar2_table(223) := '685F6C656E6774682D33292C742E6C6F6F6B61686561642D3D742E6D617463685F6C656E6774682C742E73747273746172742B3D742E6D617463685F6C656E6774682C742E6D617463685F6C656E6774683D30293A28613D5828742C302C742E77696E64';
wwv_flow_imp.g_varchar2_table(224) := '6F775B742E73747273746172745D292C742E6C6F6F6B61686561642D2D2C742E73747273746172742B2B292C612626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574292972657475726E20317D72657475726E20742E696E73';
wwv_flow_imp.g_varchar2_table(225) := '6572743D302C653D3D3D563F287A7428742C2130292C303D3D3D742E7374726D2E617661696C5F6F75743F333A34293A742E73796D5F6E6578742626287A7428742C2131292C303D3D3D742E7374726D2E617661696C5F6F7574293F313A327D2928612C';
wwv_flow_imp.g_varchar2_table(226) := '65293A49745B612E6C6576656C5D2E66756E6328612C65293B69662833213D3D69262634213D3D697C7C28612E7374617475733D6274292C313D3D3D697C7C333D3D3D692972657475726E20303D3D3D742E617661696C5F6F7574262628612E6C617374';
wwv_flow_imp.g_varchar2_table(227) := '5F666C7573683D2D31292C74743B696628323D3D3D69262628653D3D3D4A3F572861293A65213D3D242626285928612C302C302C2131292C653D3D3D512626286B7428612E68656164292C303D3D3D612E6C6F6F6B6168656164262628612E7374727374';
wwv_flow_imp.g_varchar2_table(228) := '6172743D302C612E626C6F636B5F73746172743D302C612E696E736572743D302929292C78742874292C303D3D3D742E617661696C5F6F7574292972657475726E20612E6C6173745F666C7573683D2D312C74747D72657475726E2065213D3D563F7474';
wwv_flow_imp.g_varchar2_table(229) := '3A612E777261703C3D303F65743A28323D3D3D612E777261703F28417428612C32353526742E61646C6572292C417428612C742E61646C65723E3E3826323535292C417428612C742E61646C65723E3E313626323535292C417428612C742E61646C6572';
wwv_flow_imp.g_varchar2_table(230) := '3E3E323426323535292C417428612C32353526742E746F74616C5F696E292C417428612C742E746F74616C5F696E3E3E3826323535292C417428612C742E746F74616C5F696E3E3E313626323535292C417428612C742E746F74616C5F696E3E3E323426';
wwv_flow_imp.g_varchar2_table(231) := '32353529293A28457428612C742E61646C65723E3E3E3136292C457428612C363535333526742E61646C657229292C78742874292C612E777261703E30262628612E777261703D2D612E77726170292C30213D3D612E70656E64696E673F74743A657429';
wwv_flow_imp.g_varchar2_table(232) := '7D2C6465666C617465456E643A743D3E7B6966284C742874292972657475726E2061743B636F6E737420653D742E73746174652E7374617475733B72657475726E20742E73746174653D6E756C6C2C653D3D3D6D743F677428742C6974293A74747D2C64';
wwv_flow_imp.g_varchar2_table(233) := '65666C61746553657444696374696F6E6172793A28742C65293D3E7B6C657420613D652E6C656E6774683B6966284C742874292972657475726E2061743B636F6E737420693D742E73746174652C6E3D692E777261703B696628323D3D3D6E7C7C313D3D';
wwv_flow_imp.g_varchar2_table(234) := '3D6E2626692E737461747573213D3D77747C7C692E6C6F6F6B61686561642972657475726E2061743B696628313D3D3D6E262628742E61646C65723D4328742E61646C65722C652C612C3029292C692E777261703D302C613E3D692E775F73697A65297B';
wwv_flow_imp.g_varchar2_table(235) := '303D3D3D6E2626286B7428692E68656164292C692E73747273746172743D302C692E626C6F636B5F73746172743D302C692E696E736572743D30293B6C657420743D6E65772055696E7438417272617928692E775F73697A65293B742E73657428652E73';
wwv_flow_imp.g_varchar2_table(236) := '7562617272617928612D692E775F73697A652C61292C30292C653D742C613D692E775F73697A657D636F6E737420733D742E617661696C5F696E2C723D742E6E6578745F696E2C6F3D742E696E7075743B666F7228742E617661696C5F696E3D612C742E';
wwv_flow_imp.g_varchar2_table(237) := '6E6578745F696E3D302C742E696E7075743D652C55742869293B692E6C6F6F6B61686561643E3D333B297B6C657420743D692E73747273746172742C653D692E6C6F6F6B61686561642D323B646F7B692E696E735F683D797428692C692E696E735F682C';
wwv_flow_imp.g_varchar2_table(238) := '692E77696E646F775B742B332D315D292C692E707265765B7426692E775F6D61736B5D3D692E686561645B692E696E735F685D2C692E686561645B692E696E735F685D3D742C742B2B7D7768696C65282D2D65293B692E73747273746172743D742C692E';
wwv_flow_imp.g_varchar2_table(239) := '6C6F6F6B61686561643D322C55742869297D72657475726E20692E73747273746172742B3D692E6C6F6F6B61686561642C692E626C6F636B5F73746172743D692E73747273746172742C692E696E736572743D692E6C6F6F6B61686561642C692E6C6F6F';
wwv_flow_imp.g_varchar2_table(240) := '6B61686561643D302C692E6D617463685F6C656E6774683D692E707265765F6C656E6774683D322C692E6D617463685F617661696C61626C653D302C742E6E6578745F696E3D722C742E696E7075743D6F2C742E617661696C5F696E3D732C692E777261';
wwv_flow_imp.g_varchar2_table(241) := '703D6E2C74747D2C6465666C617465496E666F3A2270616B6F206465666C617465202866726F6D204E6F646563612070726F6A65637429227D3B636F6E73742048743D28742C65293D3E4F626A6563742E70726F746F747970652E6861734F776E50726F';
wwv_flow_imp.g_varchar2_table(242) := '70657274792E63616C6C28742C65293B766172206A743D66756E6374696F6E2874297B636F6E737420653D41727261792E70726F746F747970652E736C6963652E63616C6C28617267756D656E74732C31293B666F72283B652E6C656E6774683B297B63';
wwv_flow_imp.g_varchar2_table(243) := '6F6E737420613D652E736869667428293B69662861297B696628226F626A65637422213D747970656F662061297468726F77206E657720547970654572726F7228612B226D757374206265206E6F6E2D6F626A65637422293B666F7228636F6E73742065';
wwv_flow_imp.g_varchar2_table(244) := '20696E206129487428612C6529262628745B655D3D615B655D297D7D72657475726E20747D2C4B743D743D3E7B6C657420653D303B666F72286C657420613D302C693D742E6C656E6774683B613C693B612B2B29652B3D745B615D2E6C656E6774683B63';
wwv_flow_imp.g_varchar2_table(245) := '6F6E737420613D6E65772055696E743841727261792865293B666F72286C657420653D302C693D302C6E3D742E6C656E6774683B653C6E3B652B2B297B6C6574206E3D745B655D3B612E736574286E2C69292C692B3D6E2E6C656E6774687D7265747572';
wwv_flow_imp.g_varchar2_table(246) := '6E20617D3B6C65742050743D21303B7472797B537472696E672E66726F6D43686172436F64652E6170706C79286E756C6C2C6E65772055696E74384172726179283129297D63617463682874297B50743D21317D636F6E73742059743D6E65772055696E';
wwv_flow_imp.g_varchar2_table(247) := '7438417272617928323536293B666F72286C657420743D303B743C3235363B742B2B2959745B745D3D743E3D3235323F363A743E3D3234383F353A743E3D3234303F343A743E3D3232343F333A743E3D3139323F323A313B59745B3235345D3D59745B32';
wwv_flow_imp.g_varchar2_table(248) := '35345D3D313B7661722047743D743D3E7B6966282266756E6374696F6E223D3D747970656F662054657874456E636F646572262654657874456E636F6465722E70726F746F747970652E656E636F64652972657475726E286E65772054657874456E636F';
wwv_flow_imp.g_varchar2_table(249) := '646572292E656E636F64652874293B6C657420652C612C692C6E2C732C723D742E6C656E6774682C6F3D303B666F72286E3D303B6E3C723B6E2B2B29613D742E63686172436F64654174286E292C35353239363D3D28363435313226612926266E2B313C';
wwv_flow_imp.g_varchar2_table(250) := '72262628693D742E63686172436F64654174286E2B31292C35363332303D3D283634353132266929262628613D36353533362B28612D35353239363C3C3130292B28692D3536333230292C6E2B2B29292C6F2B3D613C3132383F313A613C323034383F32';
wwv_flow_imp.g_varchar2_table(251) := '3A613C36353533363F333A343B666F7228653D6E65772055696E74384172726179286F292C733D302C6E3D303B733C6F3B6E2B2B29613D742E63686172436F64654174286E292C35353239363D3D28363435313226612926266E2B313C72262628693D74';
wwv_flow_imp.g_varchar2_table(252) := '2E63686172436F64654174286E2B31292C35363332303D3D283634353132266929262628613D36353533362B28612D35353239363C3C3130292B28692D3536333230292C6E2B2B29292C613C3132383F655B732B2B5D3D613A613C323034383F28655B73';
wwv_flow_imp.g_varchar2_table(253) := '2B2B5D3D3139327C613E3E3E362C655B732B2B5D3D3132387C36332661293A613C36353533363F28655B732B2B5D3D3232347C613E3E3E31322C655B732B2B5D3D3132387C613E3E3E362636332C655B732B2B5D3D3132387C36332661293A28655B732B';
wwv_flow_imp.g_varchar2_table(254) := '2B5D3D3234307C613E3E3E31382C655B732B2B5D3D3132387C613E3E3E31322636332C655B732B2B5D3D3132387C613E3E3E362636332C655B732B2B5D3D3132387C36332661293B72657475726E20657D2C58743D28742C65293D3E7B636F6E73742061';
wwv_flow_imp.g_varchar2_table(255) := '3D657C7C742E6C656E6774683B6966282266756E6374696F6E223D3D747970656F6620546578744465636F6465722626546578744465636F6465722E70726F746F747970652E6465636F64652972657475726E286E657720546578744465636F64657229';
wwv_flow_imp.g_varchar2_table(256) := '2E6465636F646528742E737562617272617928302C6529293B6C657420692C6E3B636F6E737420733D6E657720417272617928322A61293B666F72286E3D302C693D303B693C613B297B6C657420653D745B692B2B5D3B696628653C313238297B735B6E';
wwv_flow_imp.g_varchar2_table(257) := '2B2B5D3D653B636F6E74696E75657D6C657420723D59745B655D3B696628723E3429735B6E2B2B5D3D36353533332C692B3D722D313B656C73657B666F722865263D323D3D3D723F33313A333D3D3D723F31353A373B723E312626693C613B29653D653C';
wwv_flow_imp.g_varchar2_table(258) := '3C367C363326745B692B2B5D2C722D2D3B723E313F735B6E2B2B5D3D36353533333A653C36353533363F735B6E2B2B5D3D653A28652D3D36353533362C735B6E2B2B5D3D35353239367C653E3E313026313032332C735B6E2B2B5D3D35363332307C3130';
wwv_flow_imp.g_varchar2_table(259) := '32332665297D7D72657475726E2828742C65293D3E7B696628653C36353533342626742E7375626172726179262650742972657475726E20537472696E672E66726F6D43686172436F64652E6170706C79286E756C6C2C742E6C656E6774683D3D3D653F';
wwv_flow_imp.g_varchar2_table(260) := '743A742E737562617272617928302C6529293B6C657420613D22223B666F72286C657420693D303B693C653B692B2B29612B3D537472696E672E66726F6D43686172436F646528745B695D293B72657475726E20617D2928732C6E297D2C57743D28742C';
wwv_flow_imp.g_varchar2_table(261) := '65293D3E7B28653D657C7C742E6C656E677468293E742E6C656E677468262628653D742E6C656E677468293B6C657420613D652D313B666F72283B613E3D3026263132383D3D2831393226745B615D293B29612D2D3B72657475726E20613C307C7C303D';
wwv_flow_imp.g_varchar2_table(262) := '3D3D613F653A612B59745B745B615D5D3E653F613A657D3B7661722071743D66756E6374696F6E28297B746869732E696E7075743D6E756C6C2C746869732E6E6578745F696E3D302C746869732E617661696C5F696E3D302C746869732E746F74616C5F';
wwv_flow_imp.g_varchar2_table(263) := '696E3D302C746869732E6F75747075743D6E756C6C2C746869732E6E6578745F6F75743D302C746869732E617661696C5F6F75743D302C746869732E746F74616C5F6F75743D302C746869732E6D73673D22222C746869732E73746174653D6E756C6C2C';
wwv_flow_imp.g_varchar2_table(264) := '746869732E646174615F747970653D322C746869732E61646C65723D307D3B636F6E7374204A743D4F626A6563742E70726F746F747970652E746F537472696E672C7B5A5F4E4F5F464C5553483A51742C5A5F53594E435F464C5553483A56742C5A5F46';
wwv_flow_imp.g_varchar2_table(265) := '554C4C5F464C5553483A24742C5A5F46494E4953483A74652C5A5F4F4B3A65652C5A5F53545245414D5F454E443A61652C5A5F44454641554C545F434F4D5052455353494F4E3A69652C5A5F44454641554C545F53545241544547593A6E652C5A5F4445';
wwv_flow_imp.g_varchar2_table(266) := '464C415445443A73657D3D4B3B66756E6374696F6E2072652874297B746869732E6F7074696F6E733D6A74287B6C6576656C3A69652C6D6574686F643A73652C6368756E6B53697A653A31363338342C77696E646F77426974733A31352C6D656D4C6576';
wwv_flow_imp.g_varchar2_table(267) := '656C3A382C73747261746567793A6E657D2C747C7C7B7D293B6C657420653D746869732E6F7074696F6E733B652E7261772626652E77696E646F77426974733E303F652E77696E646F77426974733D2D652E77696E646F77426974733A652E677A697026';
wwv_flow_imp.g_varchar2_table(268) := '26652E77696E646F77426974733E302626652E77696E646F77426974733C3136262628652E77696E646F77426974732B3D3136292C746869732E6572723D302C746869732E6D73673D22222C746869732E656E6465643D21312C746869732E6368756E6B';
wwv_flow_imp.g_varchar2_table(269) := '733D5B5D2C746869732E7374726D3D6E65772071742C746869732E7374726D2E617661696C5F6F75743D303B6C657420613D4D742E6465666C617465496E69743228746869732E7374726D2C652E6C6576656C2C652E6D6574686F642C652E77696E646F';
wwv_flow_imp.g_varchar2_table(270) := '77426974732C652E6D656D4C6576656C2C652E7374726174656779293B69662861213D3D6565297468726F77206E6577204572726F72286A5B615D293B696628652E68656164657226264D742E6465666C61746553657448656164657228746869732E73';
wwv_flow_imp.g_varchar2_table(271) := '74726D2C652E686561646572292C652E64696374696F6E617279297B6C657420743B696628743D22737472696E67223D3D747970656F6620652E64696374696F6E6172793F477428652E64696374696F6E617279293A225B6F626A656374204172726179';
wwv_flow_imp.g_varchar2_table(272) := '4275666665725D223D3D3D4A742E63616C6C28652E64696374696F6E617279293F6E65772055696E7438417272617928652E64696374696F6E617279293A652E64696374696F6E6172792C613D4D742E6465666C61746553657444696374696F6E617279';
wwv_flow_imp.g_varchar2_table(273) := '28746869732E7374726D2C74292C61213D3D6565297468726F77206E6577204572726F72286A5B615D293B746869732E5F646963745F7365743D21307D7D66756E6374696F6E206F6528742C65297B636F6E737420613D6E65772072652865293B696628';
wwv_flow_imp.g_varchar2_table(274) := '612E7075736828742C2130292C612E657272297468726F7720612E6D73677C7C6A5B612E6572725D3B72657475726E20612E726573756C747D72652E70726F746F747970652E707573683D66756E6374696F6E28742C65297B636F6E737420613D746869';
wwv_flow_imp.g_varchar2_table(275) := '732E7374726D2C693D746869732E6F7074696F6E732E6368756E6B53697A653B6C6574206E2C733B696628746869732E656E6465642972657475726E21313B666F7228733D653D3D3D7E7E653F653A21303D3D3D653F74653A51742C22737472696E6722';
wwv_flow_imp.g_varchar2_table(276) := '3D3D747970656F6620743F612E696E7075743D47742874293A225B6F626A6563742041727261794275666665725D223D3D3D4A742E63616C6C2874293F612E696E7075743D6E65772055696E743841727261792874293A612E696E7075743D742C612E6E';
wwv_flow_imp.g_varchar2_table(277) := '6578745F696E3D302C612E617661696C5F696E3D612E696E7075742E6C656E6774683B3B29696628303D3D3D612E617661696C5F6F7574262628612E6F75747075743D6E65772055696E743841727261792869292C612E6E6578745F6F75743D302C612E';
wwv_flow_imp.g_varchar2_table(278) := '617661696C5F6F75743D69292C28733D3D3D56747C7C733D3D3D2474292626612E617661696C5F6F75743C3D3629746869732E6F6E4461746128612E6F75747075742E737562617272617928302C612E6E6578745F6F757429292C612E617661696C5F6F';
wwv_flow_imp.g_varchar2_table(279) := '75743D303B656C73657B6966286E3D4D742E6465666C61746528612C73292C6E3D3D3D61652972657475726E20612E6E6578745F6F75743E302626746869732E6F6E4461746128612E6F75747075742E737562617272617928302C612E6E6578745F6F75';
wwv_flow_imp.g_varchar2_table(280) := '7429292C6E3D4D742E6465666C617465456E6428746869732E7374726D292C746869732E6F6E456E64286E292C746869732E656E6465643D21302C6E3D3D3D65653B69662830213D3D612E617661696C5F6F7574297B696628733E302626612E6E657874';
wwv_flow_imp.g_varchar2_table(281) := '5F6F75743E3029746869732E6F6E4461746128612E6F75747075742E737562617272617928302C612E6E6578745F6F757429292C612E617661696C5F6F75743D303B656C736520696628303D3D3D612E617661696C5F696E29627265616B7D656C736520';
wwv_flow_imp.g_varchar2_table(282) := '746869732E6F6E4461746128612E6F7574707574297D72657475726E21307D2C72652E70726F746F747970652E6F6E446174613D66756E6374696F6E2874297B746869732E6368756E6B732E707573682874297D2C72652E70726F746F747970652E6F6E';
wwv_flow_imp.g_varchar2_table(283) := '456E643D66756E6374696F6E2874297B743D3D3D6565262628746869732E726573756C743D4B7428746869732E6368756E6B7329292C746869732E6368756E6B733D5B5D2C746869732E6572723D742C746869732E6D73673D746869732E7374726D2E6D';
wwv_flow_imp.g_varchar2_table(284) := '73677D3B766172206C653D7B4465666C6174653A72652C6465666C6174653A6F652C6465666C6174655261773A66756E6374696F6E28742C65297B72657475726E28653D657C7C7B7D292E7261773D21302C6F6528742C65297D2C677A69703A66756E63';
wwv_flow_imp.g_varchar2_table(285) := '74696F6E28742C65297B72657475726E28653D657C7C7B7D292E677A69703D21302C6F6528742C65297D2C636F6E7374616E74733A4B7D3B636F6E73742068653D31363230393B7661722064653D66756E6374696F6E28742C65297B6C657420612C692C';
wwv_flow_imp.g_varchar2_table(286) := '6E2C732C722C6F2C6C2C682C642C5F2C662C632C752C772C6D2C622C672C702C6B2C762C792C782C7A2C413B636F6E737420453D742E73746174653B613D742E6E6578745F696E2C7A3D742E696E7075742C693D612B28742E617661696C5F696E2D3529';
wwv_flow_imp.g_varchar2_table(287) := '2C6E3D742E6E6578745F6F75742C413D742E6F75747075742C733D6E2D28652D742E617661696C5F6F7574292C723D6E2B28742E617661696C5F6F75742D323537292C6F3D452E646D61782C6C3D452E7773697A652C683D452E77686176652C643D452E';
wwv_flow_imp.g_varchar2_table(288) := '776E6578742C5F3D452E77696E646F772C663D452E686F6C642C633D452E626974732C753D452E6C656E636F64652C773D452E64697374636F64652C6D3D28313C3C452E6C656E62697473292D312C623D28313C3C452E6469737462697473292D313B74';
wwv_flow_imp.g_varchar2_table(289) := '3A646F7B633C3135262628662B3D7A5B612B2B5D3C3C632C632B3D382C662B3D7A5B612B2B5D3C3C632C632B3D38292C673D755B66266D5D3B653A666F72283B3B297B696628703D673E3E3E32342C663E3E3E3D702C632D3D702C703D673E3E3E313626';
wwv_flow_imp.g_varchar2_table(290) := '3235352C303D3D3D7029415B6E2B2B5D3D363535333526673B656C73657B69662821283136267029297B696628303D3D283634267029297B673D755B2836353533352667292B28662628313C3C70292D31295D3B636F6E74696E756520657D6966283332';
wwv_flow_imp.g_varchar2_table(291) := '2670297B452E6D6F64653D31363139313B627265616B20747D742E6D73673D22696E76616C6964206C69746572616C2F6C656E67746820636F6465222C452E6D6F64653D68653B627265616B20747D6B3D363535333526672C70263D31352C7026262863';
wwv_flow_imp.g_varchar2_table(292) := '3C70262628662B3D7A5B612B2B5D3C3C632C632B3D38292C6B2B3D662628313C3C70292D312C663E3E3E3D702C632D3D70292C633C3135262628662B3D7A5B612B2B5D3C3C632C632B3D382C662B3D7A5B612B2B5D3C3C632C632B3D38292C673D775B66';
wwv_flow_imp.g_varchar2_table(293) := '26625D3B613A666F72283B3B297B696628703D673E3E3E32342C663E3E3E3D702C632D3D702C703D673E3E3E3136263235352C21283136267029297B696628303D3D283634267029297B673D775B2836353533352667292B28662628313C3C70292D3129';
wwv_flow_imp.g_varchar2_table(294) := '5D3B636F6E74696E756520617D742E6D73673D22696E76616C69642064697374616E636520636F6465222C452E6D6F64653D68653B627265616B20747D696628763D363535333526672C70263D31352C633C70262628662B3D7A5B612B2B5D3C3C632C63';
wwv_flow_imp.g_varchar2_table(295) := '2B3D382C633C70262628662B3D7A5B612B2B5D3C3C632C632B3D3829292C762B3D662628313C3C70292D312C763E6F297B742E6D73673D22696E76616C69642064697374616E636520746F6F20666172206261636B222C452E6D6F64653D68653B627265';
wwv_flow_imp.g_varchar2_table(296) := '616B20747D696628663E3E3E3D702C632D3D702C703D6E2D732C763E70297B696628703D762D702C703E682626452E73616E65297B742E6D73673D22696E76616C69642064697374616E636520746F6F20666172206261636B222C452E6D6F64653D6865';
wwv_flow_imp.g_varchar2_table(297) := '3B627265616B20747D696628793D302C783D5F2C303D3D3D64297B696628792B3D6C2D702C703C6B297B6B2D3D703B646F7B415B6E2B2B5D3D5F5B792B2B5D7D7768696C65282D2D70293B793D6E2D762C783D417D7D656C736520696628643C70297B69';
wwv_flow_imp.g_varchar2_table(298) := '6628792B3D6C2B642D702C702D3D642C703C6B297B6B2D3D703B646F7B415B6E2B2B5D3D5F5B792B2B5D7D7768696C65282D2D70293B696628793D302C643C6B297B703D642C6B2D3D703B646F7B415B6E2B2B5D3D5F5B792B2B5D7D7768696C65282D2D';
wwv_flow_imp.g_varchar2_table(299) := '70293B793D6E2D762C783D417D7D7D656C736520696628792B3D642D702C703C6B297B6B2D3D703B646F7B415B6E2B2B5D3D5F5B792B2B5D7D7768696C65282D2D70293B793D6E2D762C783D417D666F72283B6B3E323B29415B6E2B2B5D3D785B792B2B';
wwv_flow_imp.g_varchar2_table(300) := '5D2C415B6E2B2B5D3D785B792B2B5D2C415B6E2B2B5D3D785B792B2B5D2C6B2D3D333B6B262628415B6E2B2B5D3D785B792B2B5D2C6B3E31262628415B6E2B2B5D3D785B792B2B5D29297D656C73657B793D6E2D763B646F7B415B6E2B2B5D3D415B792B';
wwv_flow_imp.g_varchar2_table(301) := '2B5D2C415B6E2B2B5D3D415B792B2B5D2C415B6E2B2B5D3D415B792B2B5D2C6B2D3D337D7768696C65286B3E32293B6B262628415B6E2B2B5D3D415B792B2B5D2C6B3E31262628415B6E2B2B5D3D415B792B2B5D29297D627265616B7D7D627265616B7D';
wwv_flow_imp.g_varchar2_table(302) := '7D7768696C6528613C6926266E3C72293B6B3D633E3E332C612D3D6B2C632D3D6B3C3C332C66263D28313C3C63292D312C742E6E6578745F696E3D612C742E6E6578745F6F75743D6E2C742E617661696C5F696E3D613C693F692D612B353A352D28612D';
wwv_flow_imp.g_varchar2_table(303) := '69292C742E617661696C5F6F75743D6E3C723F722D6E2B3235373A3235372D286E2D72292C452E686F6C643D662C452E626974733D637D3B636F6E7374205F653D31352C66653D6E65772055696E7431364172726179285B332C342C352C362C372C382C';
wwv_flow_imp.g_varchar2_table(304) := '392C31302C31312C31332C31352C31372C31392C32332C32372C33312C33352C34332C35312C35392C36372C38332C39392C3131352C3133312C3136332C3139352C3232372C3235382C302C305D292C63653D6E65772055696E74384172726179285B31';
wwv_flow_imp.g_varchar2_table(305) := '362C31362C31362C31362C31362C31362C31362C31362C31372C31372C31372C31372C31382C31382C31382C31382C31392C31392C31392C31392C32302C32302C32302C32302C32312C32312C32312C32312C31362C37322C37385D292C75653D6E6577';
wwv_flow_imp.g_varchar2_table(306) := '2055696E7431364172726179285B312C322C332C342C352C372C392C31332C31372C32352C33332C34392C36352C39372C3132392C3139332C3235372C3338352C3531332C3736392C313032352C313533372C323034392C333037332C343039372C3631';
wwv_flow_imp.g_varchar2_table(307) := '34352C383139332C31323238392C31363338352C32343537372C302C305D292C77653D6E65772055696E74384172726179285B31362C31362C31362C31362C31372C31372C31382C31382C31392C31392C32302C32302C32312C32312C32322C32322C32';
wwv_flow_imp.g_varchar2_table(308) := '332C32332C32342C32342C32352C32352C32362C32362C32372C32372C32382C32382C32392C32392C36342C36345D293B766172206D653D28742C652C612C692C6E2C732C722C6F293D3E7B636F6E7374206C3D6F2E626974733B6C657420682C642C5F';
wwv_flow_imp.g_varchar2_table(309) := '2C662C632C752C773D302C6D3D302C623D302C673D302C703D302C6B3D302C763D302C793D302C783D302C7A3D302C413D6E756C6C3B636F6E737420453D6E65772055696E7431364172726179283136292C523D6E65772055696E743136417272617928';
wwv_flow_imp.g_varchar2_table(310) := '3136293B6C6574205A2C552C532C443D6E756C6C3B666F7228773D303B773C3D5F653B772B2B29455B775D3D303B666F72286D3D303B6D3C693B6D2B2B29455B655B612B6D5D5D2B2B3B666F7228703D6C2C673D5F653B673E3D312626303D3D3D455B67';
wwv_flow_imp.g_varchar2_table(311) := '5D3B672D2D293B696628703E67262628703D67292C303D3D3D672972657475726E206E5B732B2B5D3D32303937313532302C6E5B732B2B5D3D32303937313532302C6F2E626974733D312C303B666F7228623D313B623C672626303D3D3D455B625D3B62';
wwv_flow_imp.g_varchar2_table(312) := '2B2B293B666F7228703C62262628703D62292C793D312C773D313B773C3D5F653B772B2B29696628793C3C3D312C792D3D455B775D2C793C302972657475726E2D313B696628793E30262628303D3D3D747C7C31213D3D67292972657475726E2D313B66';
wwv_flow_imp.g_varchar2_table(313) := '6F7228525B315D3D302C773D313B773C5F653B772B2B29525B772B315D3D525B775D2B455B775D3B666F72286D3D303B6D3C693B6D2B2B2930213D3D655B612B6D5D262628725B525B655B612B6D5D5D2B2B5D3D6D293B696628303D3D3D743F28413D44';
wwv_flow_imp.g_varchar2_table(314) := '3D722C753D3230293A313D3D3D743F28413D66652C443D63652C753D323537293A28413D75652C443D77652C753D30292C7A3D302C6D3D302C773D622C633D732C6B3D702C763D302C5F3D2D312C783D313C3C702C663D782D312C313D3D3D742626783E';
wwv_flow_imp.g_varchar2_table(315) := '3835327C7C323D3D3D742626783E3539322972657475726E20313B666F72283B3B297B5A3D772D762C725B6D5D2B313C753F28553D302C533D725B6D5D293A725B6D5D3E3D753F28553D445B725B6D5D2D755D2C533D415B725B6D5D2D755D293A28553D';
wwv_flow_imp.g_varchar2_table(316) := '39362C533D30292C683D313C3C772D762C643D313C3C6B2C623D643B646F7B642D3D682C6E5B632B287A3E3E76292B645D3D5A3C3C32347C553C3C31367C537C307D7768696C652830213D3D64293B666F7228683D313C3C772D313B7A26683B29683E3E';
wwv_flow_imp.g_varchar2_table(317) := '3D313B69662830213D3D683F287A263D682D312C7A2B3D68293A7A3D302C6D2B2B2C303D3D2D2D455B775D297B696628773D3D3D6729627265616B3B773D655B612B725B6D5D5D7D696628773E702626287A266629213D3D5F297B666F7228303D3D3D76';
wwv_flow_imp.g_varchar2_table(318) := '262628763D70292C632B3D622C6B3D772D762C793D313C3C6B3B6B2B763C67262628792D3D455B6B2B765D2C2128793C3D3029293B296B2B2B2C793C3C3D313B696628782B3D313C3C6B2C313D3D3D742626783E3835327C7C323D3D3D742626783E3539';
wwv_flow_imp.g_varchar2_table(319) := '322972657475726E20313B5F3D7A26662C6E5B5F5D3D703C3C32347C6B3C3C31367C632D737C307D7D72657475726E2030213D3D7A2626286E5B632B7A5D3D772D763C3C32347C36343C3C31367C30292C6F2E626974733D702C307D3B636F6E73747B5A';
wwv_flow_imp.g_varchar2_table(320) := '5F46494E4953483A62652C5A5F424C4F434B3A67652C5A5F54524545533A70652C5A5F4F4B3A6B652C5A5F53545245414D5F454E443A76652C5A5F4E4545445F444943543A79652C5A5F53545245414D5F4552524F523A78652C5A5F444154415F455252';
wwv_flow_imp.g_varchar2_table(321) := '4F523A7A652C5A5F4D454D5F4552524F523A41652C5A5F4255465F4552524F523A45652C5A5F4445464C415445443A52657D3D4B2C5A653D31363138302C55653D31363139302C53653D31363139312C44653D31363139322C54653D31363139342C4F65';
wwv_flow_imp.g_varchar2_table(322) := '3D31363139392C49653D31363230302C46653D31363230362C4C653D31363230392C4E653D743D3E28743E3E3E323426323535292B28743E3E3E38263635323830292B282836353238302674293C3C38292B28283235352674293C3C3234293B66756E63';
wwv_flow_imp.g_varchar2_table(323) := '74696F6E20426528297B746869732E7374726D3D6E756C6C2C746869732E6D6F64653D302C746869732E6C6173743D21312C746869732E777261703D302C746869732E68617665646963743D21312C746869732E666C6167733D302C746869732E646D61';
wwv_flow_imp.g_varchar2_table(324) := '783D302C746869732E636865636B3D302C746869732E746F74616C3D302C746869732E686561643D6E756C6C2C746869732E77626974733D302C746869732E7773697A653D302C746869732E77686176653D302C746869732E776E6578743D302C746869';
wwv_flow_imp.g_varchar2_table(325) := '732E77696E646F773D6E756C6C2C746869732E686F6C643D302C746869732E626974733D302C746869732E6C656E6774683D302C746869732E6F66667365743D302C746869732E65787472613D302C746869732E6C656E636F64653D6E756C6C2C746869';
wwv_flow_imp.g_varchar2_table(326) := '732E64697374636F64653D6E756C6C2C746869732E6C656E626974733D302C746869732E64697374626974733D302C746869732E6E636F64653D302C746869732E6E6C656E3D302C746869732E6E646973743D302C746869732E686176653D302C746869';
wwv_flow_imp.g_varchar2_table(327) := '732E6E6578743D6E756C6C2C746869732E6C656E733D6E65772055696E743136417272617928333230292C746869732E776F726B3D6E65772055696E743136417272617928323838292C746869732E6C656E64796E3D6E756C6C2C746869732E64697374';
wwv_flow_imp.g_varchar2_table(328) := '64796E3D6E756C6C2C746869732E73616E653D302C746869732E6261636B3D302C746869732E7761733D307D636F6E73742043653D743D3E7B69662821742972657475726E20313B636F6E737420653D742E73746174653B72657475726E21657C7C652E';
wwv_flow_imp.g_varchar2_table(329) := '7374726D213D3D747C7C652E6D6F64653C5A657C7C652E6D6F64653E31363231313F313A307D2C4D653D743D3E7B69662843652874292972657475726E2078653B636F6E737420653D742E73746174653B72657475726E20742E746F74616C5F696E3D74';
wwv_flow_imp.g_varchar2_table(330) := '2E746F74616C5F6F75743D652E746F74616C3D302C742E6D73673D22222C652E77726170262628742E61646C65723D3126652E77726170292C652E6D6F64653D5A652C652E6C6173743D302C652E68617665646963743D302C652E666C6167733D2D312C';
wwv_flow_imp.g_varchar2_table(331) := '652E646D61783D33323736382C652E686561643D6E756C6C2C652E686F6C643D302C652E626974733D302C652E6C656E636F64653D652E6C656E64796E3D6E657720496E743332417272617928383532292C652E64697374636F64653D652E6469737464';
wwv_flow_imp.g_varchar2_table(332) := '796E3D6E657720496E743332417272617928353932292C652E73616E653D312C652E6261636B3D2D312C6B657D2C48653D743D3E7B69662843652874292972657475726E2078653B636F6E737420653D742E73746174653B72657475726E20652E777369';
wwv_flow_imp.g_varchar2_table(333) := '7A653D302C652E77686176653D302C652E776E6578743D302C4D652874297D2C6A653D28742C65293D3E7B6C657420613B69662843652874292972657475726E2078653B636F6E737420693D742E73746174653B72657475726E20653C303F28613D302C';
wwv_flow_imp.g_varchar2_table(334) := '653D2D65293A28613D352B28653E3E34292C653C343826262865263D313529292C65262628653C387C7C653E3135293F78653A286E756C6C213D3D692E77696E646F772626692E7762697473213D3D65262628692E77696E646F773D6E756C6C292C692E';
wwv_flow_imp.g_varchar2_table(335) := '777261703D612C692E77626974733D652C4865287429297D2C4B653D28742C65293D3E7B69662821742972657475726E2078653B636F6E737420613D6E65772042653B742E73746174653D612C612E7374726D3D742C612E77696E646F773D6E756C6C2C';
wwv_flow_imp.g_varchar2_table(336) := '612E6D6F64653D5A653B636F6E737420693D6A6528742C65293B72657475726E2069213D3D6B65262628742E73746174653D6E756C6C292C697D3B6C65742050652C59652C47653D21303B636F6E73742058653D743D3E7B6966284765297B50653D6E65';
wwv_flow_imp.g_varchar2_table(337) := '7720496E743332417272617928353132292C59653D6E657720496E7433324172726179283332293B6C657420653D303B666F72283B653C3134343B29742E6C656E735B652B2B5D3D383B666F72283B653C3235363B29742E6C656E735B652B2B5D3D393B';
wwv_flow_imp.g_varchar2_table(338) := '666F72283B653C3238303B29742E6C656E735B652B2B5D3D373B666F72283B653C3238383B29742E6C656E735B652B2B5D3D383B666F72286D6528312C742E6C656E732C302C3238382C50652C302C742E776F726B2C7B626974733A397D292C653D303B';
wwv_flow_imp.g_varchar2_table(339) := '653C33323B29742E6C656E735B652B2B5D3D353B6D6528322C742E6C656E732C302C33322C59652C302C742E776F726B2C7B626974733A357D292C47653D21317D742E6C656E636F64653D50652C742E6C656E626974733D392C742E64697374636F6465';
wwv_flow_imp.g_varchar2_table(340) := '3D59652C742E64697374626974733D357D2C57653D28742C652C612C69293D3E7B6C6574206E3B636F6E737420733D742E73746174653B72657475726E206E756C6C3D3D3D732E77696E646F77262628732E7773697A653D313C3C732E77626974732C73';
wwv_flow_imp.g_varchar2_table(341) := '2E776E6578743D302C732E77686176653D302C732E77696E646F773D6E65772055696E7438417272617928732E7773697A6529292C693E3D732E7773697A653F28732E77696E646F772E73657428652E737562617272617928612D732E7773697A652C61';
wwv_flow_imp.g_varchar2_table(342) := '292C30292C732E776E6578743D302C732E77686176653D732E7773697A65293A286E3D732E7773697A652D732E776E6578742C6E3E692626286E3D69292C732E77696E646F772E73657428652E737562617272617928612D692C612D692B6E292C732E77';
wwv_flow_imp.g_varchar2_table(343) := '6E657874292C28692D3D6E293F28732E77696E646F772E73657428652E737562617272617928612D692C61292C30292C732E776E6578743D692C732E77686176653D732E7773697A65293A28732E776E6578742B3D6E2C732E776E6578743D3D3D732E77';
wwv_flow_imp.g_varchar2_table(344) := '73697A65262628732E776E6578743D30292C732E77686176653C732E7773697A65262628732E77686176652B3D6E2929292C307D3B7661722071653D7B696E666C61746552657365743A48652C696E666C6174655265736574323A6A652C696E666C6174';
wwv_flow_imp.g_varchar2_table(345) := '6552657365744B6565703A4D652C696E666C617465496E69743A743D3E4B6528742C3135292C696E666C617465496E6974323A4B652C696E666C6174653A28742C65293D3E7B6C657420612C692C6E2C732C722C6F2C6C2C682C642C5F2C662C632C752C';
wwv_flow_imp.g_varchar2_table(346) := '772C6D2C622C672C702C6B2C762C792C782C7A3D303B636F6E737420413D6E65772055696E743841727261792834293B6C657420452C523B636F6E7374205A3D6E65772055696E74384172726179285B31362C31372C31382C302C382C372C392C362C31';
wwv_flow_imp.g_varchar2_table(347) := '302C352C31312C342C31322C332C31332C322C31342C312C31355D293B69662843652874297C7C21742E6F75747075747C7C21742E696E707574262630213D3D742E617661696C5F696E2972657475726E2078653B613D742E73746174652C612E6D6F64';
wwv_flow_imp.g_varchar2_table(348) := '653D3D3D5365262628612E6D6F64653D4465292C723D742E6E6578745F6F75742C6E3D742E6F75747075742C6C3D742E617661696C5F6F75742C733D742E6E6578745F696E2C693D742E696E7075742C6F3D742E617661696C5F696E2C683D612E686F6C';
wwv_flow_imp.g_varchar2_table(349) := '642C643D612E626974732C5F3D6F2C663D6C2C783D6B653B743A666F72283B3B2973776974636828612E6D6F6465297B63617365205A653A696628303D3D3D612E77726170297B612E6D6F64653D44653B627265616B7D666F72283B643C31363B297B69';
wwv_flow_imp.g_varchar2_table(350) := '6628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D6966283226612E77726170262633353631353D3D3D68297B303D3D3D612E7762697473262628612E77626974733D3135292C612E636865636B3D302C415B';
wwv_flow_imp.g_varchar2_table(351) := '305D3D32353526682C415B315D3D683E3E3E38263235352C612E636865636B3D4828612E636865636B2C412C322C30292C683D302C643D302C612E6D6F64653D31363138313B627265616B7D696628612E68656164262628612E686561642E646F6E653D';
wwv_flow_imp.g_varchar2_table(352) := '2131292C21283126612E77726170297C7C2828283235352668293C3C38292B28683E3E382929253331297B742E6D73673D22696E636F72726563742068656164657220636865636B222C612E6D6F64653D4C653B627265616B7D69662828313526682921';
wwv_flow_imp.g_varchar2_table(353) := '3D3D5265297B742E6D73673D22756E6B6E6F776E20636F6D7072657373696F6E206D6574686F64222C612E6D6F64653D4C653B627265616B7D696628683E3E3E3D342C642D3D342C793D382B2831352668292C303D3D3D612E7762697473262628612E77';
wwv_flow_imp.g_varchar2_table(354) := '626974733D79292C793E31357C7C793E612E7762697473297B742E6D73673D22696E76616C69642077696E646F772073697A65222C612E6D6F64653D4C653B627265616B7D612E646D61783D313C3C612E77626974732C612E666C6167733D302C742E61';
wwv_flow_imp.g_varchar2_table(355) := '646C65723D612E636865636B3D312C612E6D6F64653D35313226683F31363138393A53652C683D302C643D303B627265616B3B636173652031363138313A666F72283B643C31363B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B';
wwv_flow_imp.g_varchar2_table(356) := '732B2B5D3C3C642C642B3D387D696628612E666C6167733D682C2832353526612E666C61677329213D3D5265297B742E6D73673D22756E6B6E6F776E20636F6D7072657373696F6E206D6574686F64222C612E6D6F64653D4C653B627265616B7D696628';
wwv_flow_imp.g_varchar2_table(357) := '353733343426612E666C616773297B742E6D73673D22756E6B6E6F776E2068656164657220666C61677320736574222C612E6D6F64653D4C653B627265616B7D612E68656164262628612E686561642E746578743D683E3E382631292C35313226612E66';
wwv_flow_imp.g_varchar2_table(358) := '6C61677326263426612E77726170262628415B305D3D32353526682C415B315D3D683E3E3E38263235352C612E636865636B3D4828612E636865636B2C412C322C3029292C683D302C643D302C612E6D6F64653D31363138323B63617365203136313832';
wwv_flow_imp.g_varchar2_table(359) := '3A666F72283B643C33323B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D612E68656164262628612E686561642E74696D653D68292C35313226612E666C61677326263426612E77726170262628';
wwv_flow_imp.g_varchar2_table(360) := '415B305D3D32353526682C415B315D3D683E3E3E38263235352C415B325D3D683E3E3E3136263235352C415B335D3D683E3E3E3234263235352C612E636865636B3D4828612E636865636B2C412C342C3029292C683D302C643D302C612E6D6F64653D31';
wwv_flow_imp.g_varchar2_table(361) := '363138333B636173652031363138333A666F72283B643C31363B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D612E68656164262628612E686561642E78666C6167733D32353526682C612E6865';
wwv_flow_imp.g_varchar2_table(362) := '61642E6F733D683E3E38292C35313226612E666C61677326263426612E77726170262628415B305D3D32353526682C415B315D3D683E3E3E38263235352C612E636865636B3D4828612E636865636B2C412C322C3029292C683D302C643D302C612E6D6F';
wwv_flow_imp.g_varchar2_table(363) := '64653D31363138343B636173652031363138343A6966283130323426612E666C616773297B666F72283B643C31363B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D612E6C656E6774683D682C61';
wwv_flow_imp.g_varchar2_table(364) := '2E68656164262628612E686561642E65787472615F6C656E3D68292C35313226612E666C61677326263426612E77726170262628415B305D3D32353526682C415B315D3D683E3E3E38263235352C612E636865636B3D4828612E636865636B2C412C322C';
wwv_flow_imp.g_varchar2_table(365) := '3029292C683D302C643D307D656C736520612E68656164262628612E686561642E65787472613D6E756C6C293B612E6D6F64653D31363138353B636173652031363138353A6966283130323426612E666C616773262628633D612E6C656E6774682C633E';
wwv_flow_imp.g_varchar2_table(366) := '6F262628633D6F292C63262628612E68656164262628793D612E686561642E65787472615F6C656E2D612E6C656E6774682C612E686561642E65787472617C7C28612E686561642E65787472613D6E65772055696E7438417272617928612E686561642E';
wwv_flow_imp.g_varchar2_table(367) := '65787472615F6C656E29292C612E686561642E65787472612E73657428692E737562617272617928732C732B63292C7929292C35313226612E666C61677326263426612E77726170262628612E636865636B3D4828612E636865636B2C692C632C732929';
wwv_flow_imp.g_varchar2_table(368) := '2C6F2D3D632C732B3D632C612E6C656E6774682D3D63292C612E6C656E6774682929627265616B20743B612E6C656E6774683D302C612E6D6F64653D31363138363B636173652031363138363A6966283230343826612E666C616773297B696628303D3D';
wwv_flow_imp.g_varchar2_table(369) := '3D6F29627265616B20743B633D303B646F7B793D695B732B632B2B5D2C612E686561642626792626612E6C656E6774683C3635353336262628612E686561642E6E616D652B3D537472696E672E66726F6D43686172436F6465287929297D7768696C6528';
wwv_flow_imp.g_varchar2_table(370) := '792626633C6F293B69662835313226612E666C61677326263426612E77726170262628612E636865636B3D4828612E636865636B2C692C632C7329292C6F2D3D632C732B3D632C7929627265616B20747D656C736520612E68656164262628612E686561';
wwv_flow_imp.g_varchar2_table(371) := '642E6E616D653D6E756C6C293B612E6C656E6774683D302C612E6D6F64653D31363138373B636173652031363138373A6966283430393626612E666C616773297B696628303D3D3D6F29627265616B20743B633D303B646F7B793D695B732B632B2B5D2C';
wwv_flow_imp.g_varchar2_table(372) := '612E686561642626792626612E6C656E6774683C3635353336262628612E686561642E636F6D6D656E742B3D537472696E672E66726F6D43686172436F6465287929297D7768696C6528792626633C6F293B69662835313226612E666C61677326263426';
wwv_flow_imp.g_varchar2_table(373) := '612E77726170262628612E636865636B3D4828612E636865636B2C692C632C7329292C6F2D3D632C732B3D632C7929627265616B20747D656C736520612E68656164262628612E686561642E636F6D6D656E743D6E756C6C293B612E6D6F64653D313631';
wwv_flow_imp.g_varchar2_table(374) := '38383B636173652031363138383A69662835313226612E666C616773297B666F72283B643C31363B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D6966283426612E77726170262668213D3D2836';
wwv_flow_imp.g_varchar2_table(375) := '3535333526612E636865636B29297B742E6D73673D2268656164657220637263206D69736D61746368222C612E6D6F64653D4C653B627265616B7D683D302C643D307D612E68656164262628612E686561642E686372633D612E666C6167733E3E392631';
wwv_flow_imp.g_varchar2_table(376) := '2C612E686561642E646F6E653D2130292C742E61646C65723D612E636865636B3D302C612E6D6F64653D53653B627265616B3B636173652031363138393A666F72283B643C33323B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B';
wwv_flow_imp.g_varchar2_table(377) := '732B2B5D3C3C642C642B3D387D742E61646C65723D612E636865636B3D4E652868292C683D302C643D302C612E6D6F64653D55653B636173652055653A696628303D3D3D612E68617665646963742972657475726E20742E6E6578745F6F75743D722C74';
wwv_flow_imp.g_varchar2_table(378) := '2E617661696C5F6F75743D6C2C742E6E6578745F696E3D732C742E617661696C5F696E3D6F2C612E686F6C643D682C612E626974733D642C79653B742E61646C65723D612E636865636B3D312C612E6D6F64653D53653B636173652053653A696628653D';
wwv_flow_imp.g_varchar2_table(379) := '3D3D67657C7C653D3D3D706529627265616B20743B636173652044653A696628612E6C617374297B683E3E3E3D3726642C642D3D3726642C612E6D6F64653D46653B627265616B7D666F72283B643C333B297B696628303D3D3D6F29627265616B20743B';
wwv_flow_imp.g_varchar2_table(380) := '6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D73776974636828612E6C6173743D3126682C683E3E3E3D312C642D3D312C332668297B6361736520303A612E6D6F64653D31363139333B627265616B3B6361736520313A69662858652861292C61';
wwv_flow_imp.g_varchar2_table(381) := '2E6D6F64653D4F652C653D3D3D7065297B683E3E3E3D322C642D3D323B627265616B20747D627265616B3B6361736520323A612E6D6F64653D31363139363B627265616B3B6361736520333A742E6D73673D22696E76616C696420626C6F636B20747970';
wwv_flow_imp.g_varchar2_table(382) := '65222C612E6D6F64653D4C657D683E3E3E3D322C642D3D323B627265616B3B636173652031363139333A666F7228683E3E3E3D3726642C642D3D3726643B643C33323B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C';
wwv_flow_imp.g_varchar2_table(383) := '3C642C642B3D387D696628283635353335266829213D28683E3E3E31365E363535333529297B742E6D73673D22696E76616C69642073746F72656420626C6F636B206C656E67746873222C612E6D6F64653D4C653B627265616B7D696628612E6C656E67';
wwv_flow_imp.g_varchar2_table(384) := '74683D363535333526682C683D302C643D302C612E6D6F64653D54652C653D3D3D706529627265616B20743B636173652054653A612E6D6F64653D31363139353B636173652031363139353A696628633D612E6C656E6774682C63297B696628633E6F26';
wwv_flow_imp.g_varchar2_table(385) := '2628633D6F292C633E6C262628633D6C292C303D3D3D6329627265616B20743B6E2E73657428692E737562617272617928732C732B63292C72292C6F2D3D632C732B3D632C6C2D3D632C722B3D632C612E6C656E6774682D3D633B627265616B7D612E6D';
wwv_flow_imp.g_varchar2_table(386) := '6F64653D53653B627265616B3B636173652031363139363A666F72283B643C31343B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D696628612E6E6C656E3D3235372B2833312668292C683E3E3E';
wwv_flow_imp.g_varchar2_table(387) := '3D352C642D3D352C612E6E646973743D312B2833312668292C683E3E3E3D352C642D3D352C612E6E636F64653D342B2831352668292C683E3E3E3D342C642D3D342C612E6E6C656E3E3238367C7C612E6E646973743E3330297B742E6D73673D22746F6F';
wwv_flow_imp.g_varchar2_table(388) := '206D616E79206C656E677468206F722064697374616E63652073796D626F6C73222C612E6D6F64653D4C653B627265616B7D612E686176653D302C612E6D6F64653D31363139373B636173652031363139373A666F72283B612E686176653C612E6E636F';
wwv_flow_imp.g_varchar2_table(389) := '64653B297B666F72283B643C333B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D612E6C656E735B5A5B612E686176652B2B5D5D3D3726682C683E3E3E3D332C642D3D337D666F72283B612E6861';
wwv_flow_imp.g_varchar2_table(390) := '76653C31393B29612E6C656E735B5A5B612E686176652B2B5D5D3D303B696628612E6C656E636F64653D612E6C656E64796E2C612E6C656E626974733D372C453D7B626974733A612E6C656E626974737D2C783D6D6528302C612E6C656E732C302C3139';
wwv_flow_imp.g_varchar2_table(391) := '2C612E6C656E636F64652C302C612E776F726B2C45292C612E6C656E626974733D452E626974732C78297B742E6D73673D22696E76616C696420636F6465206C656E6774687320736574222C612E6D6F64653D4C653B627265616B7D612E686176653D30';
wwv_flow_imp.g_varchar2_table(392) := '2C612E6D6F64653D31363139383B636173652031363139383A666F72283B612E686176653C612E6E6C656E2B612E6E646973743B297B666F72283B7A3D612E6C656E636F64655B682628313C3C612E6C656E62697473292D315D2C6D3D7A3E3E3E32342C';
wwv_flow_imp.g_varchar2_table(393) := '623D7A3E3E3E3136263235352C673D3635353335267A2C21286D3C3D64293B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D696628673C313629683E3E3E3D6D2C642D3D6D2C612E6C656E735B61';
wwv_flow_imp.g_varchar2_table(394) := '2E686176652B2B5D3D673B656C73657B69662831363D3D3D67297B666F7228523D6D2B323B643C523B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D696628683E3E3E3D6D2C642D3D6D2C303D3D';
wwv_flow_imp.g_varchar2_table(395) := '3D612E68617665297B742E6D73673D22696E76616C696420626974206C656E67746820726570656174222C612E6D6F64653D4C653B627265616B7D793D612E6C656E735B612E686176652D315D2C633D332B28332668292C683E3E3E3D322C642D3D327D';
wwv_flow_imp.g_varchar2_table(396) := '656C73652069662831373D3D3D67297B666F7228523D6D2B333B643C523B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D683E3E3E3D6D2C642D3D6D2C793D302C633D332B28372668292C683E3E';
wwv_flow_imp.g_varchar2_table(397) := '3E3D332C642D3D337D656C73657B666F7228523D6D2B373B643C523B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D683E3E3E3D6D2C642D3D6D2C793D302C633D31312B283132372668292C683E';
wwv_flow_imp.g_varchar2_table(398) := '3E3E3D372C642D3D377D696628612E686176652B633E612E6E6C656E2B612E6E64697374297B742E6D73673D22696E76616C696420626974206C656E67746820726570656174222C612E6D6F64653D4C653B627265616B7D666F72283B632D2D3B29612E';
wwv_flow_imp.g_varchar2_table(399) := '6C656E735B612E686176652B2B5D3D797D7D696628612E6D6F64653D3D3D4C6529627265616B3B696628303D3D3D612E6C656E735B3235365D297B742E6D73673D22696E76616C696420636F6465202D2D206D697373696E6720656E642D6F662D626C6F';
wwv_flow_imp.g_varchar2_table(400) := '636B222C612E6D6F64653D4C653B627265616B7D696628612E6C656E626974733D392C453D7B626974733A612E6C656E626974737D2C783D6D6528312C612E6C656E732C302C612E6E6C656E2C612E6C656E636F64652C302C612E776F726B2C45292C61';
wwv_flow_imp.g_varchar2_table(401) := '2E6C656E626974733D452E626974732C78297B742E6D73673D22696E76616C6964206C69746572616C2F6C656E6774687320736574222C612E6D6F64653D4C653B627265616B7D696628612E64697374626974733D362C612E64697374636F64653D612E';
wwv_flow_imp.g_varchar2_table(402) := '6469737464796E2C453D7B626974733A612E64697374626974737D2C783D6D6528322C612E6C656E732C612E6E6C656E2C612E6E646973742C612E64697374636F64652C302C612E776F726B2C45292C612E64697374626974733D452E626974732C7829';
wwv_flow_imp.g_varchar2_table(403) := '7B742E6D73673D22696E76616C69642064697374616E63657320736574222C612E6D6F64653D4C653B627265616B7D696628612E6D6F64653D4F652C653D3D3D706529627265616B20743B63617365204F653A612E6D6F64653D49653B63617365204965';
wwv_flow_imp.g_varchar2_table(404) := '3A6966286F3E3D3626266C3E3D323538297B742E6E6578745F6F75743D722C742E617661696C5F6F75743D6C2C742E6E6578745F696E3D732C742E617661696C5F696E3D6F2C612E686F6C643D682C612E626974733D642C646528742C66292C723D742E';
wwv_flow_imp.g_varchar2_table(405) := '6E6578745F6F75742C6E3D742E6F75747075742C6C3D742E617661696C5F6F75742C733D742E6E6578745F696E2C693D742E696E7075742C6F3D742E617661696C5F696E2C683D612E686F6C642C643D612E626974732C612E6D6F64653D3D3D53652626';
wwv_flow_imp.g_varchar2_table(406) := '28612E6261636B3D2D31293B627265616B7D666F7228612E6261636B3D303B7A3D612E6C656E636F64655B682628313C3C612E6C656E62697473292D315D2C6D3D7A3E3E3E32342C623D7A3E3E3E3136263235352C673D3635353335267A2C21286D3C3D';
wwv_flow_imp.g_varchar2_table(407) := '64293B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D696628622626303D3D28323430266229297B666F7228703D6D2C6B3D622C763D673B7A3D612E6C656E636F64655B762B2828682628313C3C';
wwv_flow_imp.g_varchar2_table(408) := '702B6B292D31293E3E70295D2C6D3D7A3E3E3E32342C623D7A3E3E3E3136263235352C673D3635353335267A2C2128702B6D3C3D64293B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D683E3E3E';
wwv_flow_imp.g_varchar2_table(409) := '3D702C642D3D702C612E6261636B2B3D707D696628683E3E3E3D6D2C642D3D6D2C612E6261636B2B3D6D2C612E6C656E6774683D672C303D3D3D62297B612E6D6F64653D31363230353B627265616B7D69662833322662297B612E6261636B3D2D312C61';
wwv_flow_imp.g_varchar2_table(410) := '2E6D6F64653D53653B627265616B7D69662836342662297B742E6D73673D22696E76616C6964206C69746572616C2F6C656E67746820636F6465222C612E6D6F64653D4C653B627265616B7D612E65787472613D313526622C612E6D6F64653D31363230';
wwv_flow_imp.g_varchar2_table(411) := '313B636173652031363230313A696628612E6578747261297B666F7228523D612E65787472613B643C523B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D612E6C656E6774682B3D682628313C3C';
wwv_flow_imp.g_varchar2_table(412) := '612E6578747261292D312C683E3E3E3D612E65787472612C642D3D612E65787472612C612E6261636B2B3D612E65787472617D612E7761733D612E6C656E6774682C612E6D6F64653D31363230323B636173652031363230323A666F72283B7A3D612E64';
wwv_flow_imp.g_varchar2_table(413) := '697374636F64655B682628313C3C612E6469737462697473292D315D2C6D3D7A3E3E3E32342C623D7A3E3E3E3136263235352C673D3635353335267A2C21286D3C3D64293B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B';
wwv_flow_imp.g_varchar2_table(414) := '5D3C3C642C642B3D387D696628303D3D28323430266229297B666F7228703D6D2C6B3D622C763D673B7A3D612E64697374636F64655B762B2828682628313C3C702B6B292D31293E3E70295D2C6D3D7A3E3E3E32342C623D7A3E3E3E3136263235352C67';
wwv_flow_imp.g_varchar2_table(415) := '3D3635353335267A2C2128702B6D3C3D64293B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D683E3E3E3D702C642D3D702C612E6261636B2B3D707D696628683E3E3E3D6D2C642D3D6D2C612E62';
wwv_flow_imp.g_varchar2_table(416) := '61636B2B3D6D2C36342662297B742E6D73673D22696E76616C69642064697374616E636520636F6465222C612E6D6F64653D4C653B627265616B7D612E6F66667365743D672C612E65787472613D313526622C612E6D6F64653D31363230333B63617365';
wwv_flow_imp.g_varchar2_table(417) := '2031363230333A696628612E6578747261297B666F7228523D612E65787472613B643C523B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B5D3C3C642C642B3D387D612E6F66667365742B3D682628313C3C612E65787472';
wwv_flow_imp.g_varchar2_table(418) := '61292D312C683E3E3E3D612E65787472612C642D3D612E65787472612C612E6261636B2B3D612E65787472617D696628612E6F66667365743E612E646D6178297B742E6D73673D22696E76616C69642064697374616E636520746F6F2066617220626163';
wwv_flow_imp.g_varchar2_table(419) := '6B222C612E6D6F64653D4C653B627265616B7D612E6D6F64653D31363230343B636173652031363230343A696628303D3D3D6C29627265616B20743B696628633D662D6C2C612E6F66667365743E63297B696628633D612E6F66667365742D632C633E61';
wwv_flow_imp.g_varchar2_table(420) := '2E77686176652626612E73616E65297B742E6D73673D22696E76616C69642064697374616E636520746F6F20666172206261636B222C612E6D6F64653D4C653B627265616B7D633E612E776E6578743F28632D3D612E776E6578742C753D612E7773697A';
wwv_flow_imp.g_varchar2_table(421) := '652D63293A753D612E776E6578742D632C633E612E6C656E677468262628633D612E6C656E677468292C773D612E77696E646F777D656C736520773D6E2C753D722D612E6F66667365742C633D612E6C656E6774683B633E6C262628633D6C292C6C2D3D';
wwv_flow_imp.g_varchar2_table(422) := '632C612E6C656E6774682D3D633B646F7B6E5B722B2B5D3D775B752B2B5D7D7768696C65282D2D63293B303D3D3D612E6C656E677468262628612E6D6F64653D4965293B627265616B3B636173652031363230353A696628303D3D3D6C29627265616B20';
wwv_flow_imp.g_varchar2_table(423) := '743B6E5B722B2B5D3D612E6C656E6774682C6C2D2D2C612E6D6F64653D49653B627265616B3B636173652046653A696628612E77726170297B666F72283B643C33323B297B696628303D3D3D6F29627265616B20743B6F2D2D2C687C3D695B732B2B5D3C';
wwv_flow_imp.g_varchar2_table(424) := '3C642C642B3D387D696628662D3D6C2C742E746F74616C5F6F75742B3D662C612E746F74616C2B3D662C3426612E77726170262666262628742E61646C65723D612E636865636B3D612E666C6167733F4828612E636865636B2C6E2C662C722D66293A43';
wwv_flow_imp.g_varchar2_table(425) := '28612E636865636B2C6E2C662C722D6629292C663D6C2C3426612E77726170262628612E666C6167733F683A4E6528682929213D3D612E636865636B297B742E6D73673D22696E636F7272656374206461746120636865636B222C612E6D6F64653D4C65';
wwv_flow_imp.g_varchar2_table(426) := '3B627265616B7D683D302C643D307D612E6D6F64653D31363230373B636173652031363230373A696628612E777261702626612E666C616773297B666F72283B643C33323B297B696628303D3D3D6F29627265616B20743B6F2D2D2C682B3D695B732B2B';
wwv_flow_imp.g_varchar2_table(427) := '5D3C3C642C642B3D387D6966283426612E77726170262668213D3D283432393439363732393526612E746F74616C29297B742E6D73673D22696E636F7272656374206C656E67746820636865636B222C612E6D6F64653D4C653B627265616B7D683D302C';
wwv_flow_imp.g_varchar2_table(428) := '643D307D612E6D6F64653D31363230383B636173652031363230383A783D76653B627265616B20743B63617365204C653A783D7A653B627265616B20743B636173652031363231303A72657475726E2041653B64656661756C743A72657475726E207865';
wwv_flow_imp.g_varchar2_table(429) := '7D72657475726E20742E6E6578745F6F75743D722C742E617661696C5F6F75743D6C2C742E6E6578745F696E3D732C742E617661696C5F696E3D6F2C612E686F6C643D682C612E626974733D642C28612E7773697A657C7C66213D3D742E617661696C5F';
wwv_flow_imp.g_varchar2_table(430) := '6F75742626612E6D6F64653C4C65262628612E6D6F64653C46657C7C65213D3D626529292626576528742C742E6F75747075742C742E6E6578745F6F75742C662D742E617661696C5F6F7574292C5F2D3D742E617661696C5F696E2C662D3D742E617661';
wwv_flow_imp.g_varchar2_table(431) := '696C5F6F75742C742E746F74616C5F696E2B3D5F2C742E746F74616C5F6F75742B3D662C612E746F74616C2B3D662C3426612E77726170262666262628742E61646C65723D612E636865636B3D612E666C6167733F4828612E636865636B2C6E2C662C74';
wwv_flow_imp.g_varchar2_table(432) := '2E6E6578745F6F75742D66293A4328612E636865636B2C6E2C662C742E6E6578745F6F75742D6629292C742E646174615F747970653D612E626974732B28612E6C6173743F36343A30292B28612E6D6F64653D3D3D53653F3132383A30292B28612E6D6F';
wwv_flow_imp.g_varchar2_table(433) := '64653D3D3D4F657C7C612E6D6F64653D3D3D54653F3235363A30292C28303D3D3D5F2626303D3D3D667C7C653D3D3D6265292626783D3D3D6B65262628783D4565292C787D2C696E666C617465456E643A743D3E7B69662843652874292972657475726E';
wwv_flow_imp.g_varchar2_table(434) := '2078653B6C657420653D742E73746174653B72657475726E20652E77696E646F77262628652E77696E646F773D6E756C6C292C742E73746174653D6E756C6C2C6B657D2C696E666C6174654765744865616465723A28742C65293D3E7B69662843652874';
wwv_flow_imp.g_varchar2_table(435) := '292972657475726E2078653B636F6E737420613D742E73746174653B72657475726E20303D3D283226612E77726170293F78653A28612E686561643D652C652E646F6E653D21312C6B65297D2C696E666C61746553657444696374696F6E6172793A2874';
wwv_flow_imp.g_varchar2_table(436) := '2C65293D3E7B636F6E737420613D652E6C656E6774683B6C657420692C6E2C733B72657475726E2043652874293F78653A28693D742E73746174652C30213D3D692E777261702626692E6D6F6465213D3D55653F78653A692E6D6F64653D3D3D55652626';
wwv_flow_imp.g_varchar2_table(437) := '286E3D312C6E3D43286E2C652C612C30292C6E213D3D692E636865636B293F7A653A28733D576528742C652C612C61292C733F28692E6D6F64653D31363231302C4165293A28692E68617665646963743D312C6B652929297D2C696E666C617465496E66';
wwv_flow_imp.g_varchar2_table(438) := '6F3A2270616B6F20696E666C617465202866726F6D204E6F646563612070726F6A65637429227D3B766172204A653D66756E6374696F6E28297B746869732E746578743D302C746869732E74696D653D302C746869732E78666C6167733D302C74686973';
wwv_flow_imp.g_varchar2_table(439) := '2E6F733D302C746869732E65787472613D6E756C6C2C746869732E65787472615F6C656E3D302C746869732E6E616D653D22222C746869732E636F6D6D656E743D22222C746869732E686372633D302C746869732E646F6E653D21317D3B636F6E737420';
wwv_flow_imp.g_varchar2_table(440) := '51653D4F626A6563742E70726F746F747970652E746F537472696E672C7B5A5F4E4F5F464C5553483A56652C5A5F46494E4953483A24652C5A5F4F4B3A74612C5A5F53545245414D5F454E443A65612C5A5F4E4545445F444943543A61612C5A5F535452';
wwv_flow_imp.g_varchar2_table(441) := '45414D5F4552524F523A69612C5A5F444154415F4552524F523A6E612C5A5F4D454D5F4552524F523A73617D3D4B3B66756E6374696F6E2072612874297B746869732E6F7074696F6E733D6A74287B6368756E6B53697A653A36353533362C77696E646F';
wwv_flow_imp.g_varchar2_table(442) := '77426974733A31352C746F3A22227D2C747C7C7B7D293B636F6E737420653D746869732E6F7074696F6E733B652E7261772626652E77696E646F77426974733E3D302626652E77696E646F77426974733C3136262628652E77696E646F77426974733D2D';
wwv_flow_imp.g_varchar2_table(443) := '652E77696E646F77426974732C303D3D3D652E77696E646F7742697473262628652E77696E646F77426974733D2D313529292C2128652E77696E646F77426974733E3D302626652E77696E646F77426974733C3136297C7C742626742E77696E646F7742';
wwv_flow_imp.g_varchar2_table(444) := '6974737C7C28652E77696E646F77426974732B3D3332292C652E77696E646F77426974733E31352626652E77696E646F77426974733C34382626303D3D28313526652E77696E646F774269747329262628652E77696E646F77426974737C3D3135292C74';
wwv_flow_imp.g_varchar2_table(445) := '6869732E6572723D302C746869732E6D73673D22222C746869732E656E6465643D21312C746869732E6368756E6B733D5B5D2C746869732E7374726D3D6E65772071742C746869732E7374726D2E617661696C5F6F75743D303B6C657420613D71652E69';
wwv_flow_imp.g_varchar2_table(446) := '6E666C617465496E69743228746869732E7374726D2C652E77696E646F7742697473293B69662861213D3D7461297468726F77206E6577204572726F72286A5B615D293B696628746869732E6865616465723D6E6577204A652C71652E696E666C617465';
wwv_flow_imp.g_varchar2_table(447) := '47657448656164657228746869732E7374726D2C746869732E686561646572292C652E64696374696F6E61727926262822737472696E67223D3D747970656F6620652E64696374696F6E6172793F652E64696374696F6E6172793D477428652E64696374';
wwv_flow_imp.g_varchar2_table(448) := '696F6E617279293A225B6F626A6563742041727261794275666665725D223D3D3D51652E63616C6C28652E64696374696F6E61727929262628652E64696374696F6E6172793D6E65772055696E7438417272617928652E64696374696F6E61727929292C';
wwv_flow_imp.g_varchar2_table(449) := '652E726177262628613D71652E696E666C61746553657444696374696F6E61727928746869732E7374726D2C652E64696374696F6E617279292C61213D3D74612929297468726F77206E6577204572726F72286A5B615D297D66756E6374696F6E206F61';
wwv_flow_imp.g_varchar2_table(450) := '28742C65297B636F6E737420613D6E65772072612865293B696628612E707573682874292C612E657272297468726F7720612E6D73677C7C6A5B612E6572725D3B72657475726E20612E726573756C747D72612E70726F746F747970652E707573683D66';
wwv_flow_imp.g_varchar2_table(451) := '756E6374696F6E28742C65297B636F6E737420613D746869732E7374726D2C693D746869732E6F7074696F6E732E6368756E6B53697A652C6E3D746869732E6F7074696F6E732E64696374696F6E6172793B6C657420732C722C6F3B696628746869732E';
wwv_flow_imp.g_varchar2_table(452) := '656E6465642972657475726E21313B666F7228723D653D3D3D7E7E653F653A21303D3D3D653F24653A56652C225B6F626A6563742041727261794275666665725D223D3D3D51652E63616C6C2874293F612E696E7075743D6E65772055696E7438417272';
wwv_flow_imp.g_varchar2_table(453) := '61792874293A612E696E7075743D742C612E6E6578745F696E3D302C612E617661696C5F696E3D612E696E7075742E6C656E6774683B3B297B666F7228303D3D3D612E617661696C5F6F7574262628612E6F75747075743D6E65772055696E7438417272';
wwv_flow_imp.g_varchar2_table(454) := '61792869292C612E6E6578745F6F75743D302C612E617661696C5F6F75743D69292C733D71652E696E666C61746528612C72292C733D3D3D616126266E262628733D71652E696E666C61746553657444696374696F6E61727928612C6E292C733D3D3D74';
wwv_flow_imp.g_varchar2_table(455) := '613F733D71652E696E666C61746528612C72293A733D3D3D6E61262628733D616129293B612E617661696C5F696E3E302626733D3D3D65612626612E73746174652E777261703E30262630213D3D745B612E6E6578745F696E5D3B2971652E696E666C61';
wwv_flow_imp.g_varchar2_table(456) := '746552657365742861292C733D71652E696E666C61746528612C72293B7377697463682873297B636173652069613A63617365206E613A636173652061613A636173652073613A72657475726E20746869732E6F6E456E642873292C746869732E656E64';
wwv_flow_imp.g_varchar2_table(457) := '65643D21302C21317D6966286F3D612E617661696C5F6F75742C612E6E6578745F6F7574262628303D3D3D612E617661696C5F6F75747C7C733D3D3D6561292969662822737472696E67223D3D3D746869732E6F7074696F6E732E746F297B6C65742074';
wwv_flow_imp.g_varchar2_table(458) := '3D577428612E6F75747075742C612E6E6578745F6F7574292C653D612E6E6578745F6F75742D742C6E3D587428612E6F75747075742C74293B612E6E6578745F6F75743D652C612E617661696C5F6F75743D692D652C652626612E6F75747075742E7365';
wwv_flow_imp.g_varchar2_table(459) := '7428612E6F75747075742E737562617272617928742C742B65292C30292C746869732E6F6E44617461286E297D656C736520746869732E6F6E4461746128612E6F75747075742E6C656E6774683D3D3D612E6E6578745F6F75743F612E6F75747075743A';
wwv_flow_imp.g_varchar2_table(460) := '612E6F75747075742E737562617272617928302C612E6E6578745F6F757429293B69662873213D3D74617C7C30213D3D6F297B696628733D3D3D65612972657475726E20733D71652E696E666C617465456E6428746869732E7374726D292C746869732E';
wwv_flow_imp.g_varchar2_table(461) := '6F6E456E642873292C746869732E656E6465643D21302C21303B696628303D3D3D612E617661696C5F696E29627265616B7D7D72657475726E21307D2C72612E70726F746F747970652E6F6E446174613D66756E6374696F6E2874297B746869732E6368';
wwv_flow_imp.g_varchar2_table(462) := '756E6B732E707573682874297D2C72612E70726F746F747970652E6F6E456E643D66756E6374696F6E2874297B743D3D3D746126262822737472696E67223D3D3D746869732E6F7074696F6E732E746F3F746869732E726573756C743D746869732E6368';
wwv_flow_imp.g_varchar2_table(463) := '756E6B732E6A6F696E282222293A746869732E726573756C743D4B7428746869732E6368756E6B7329292C746869732E6368756E6B733D5B5D2C746869732E6572723D742C746869732E6D73673D746869732E7374726D2E6D73677D3B766172206C613D';
wwv_flow_imp.g_varchar2_table(464) := '7B496E666C6174653A72612C696E666C6174653A6F612C696E666C6174655261773A66756E6374696F6E28742C65297B72657475726E28653D657C7C7B7D292E7261773D21302C6F6128742C65297D2C756E677A69703A6F612C636F6E7374616E74733A';
wwv_flow_imp.g_varchar2_table(465) := '4B7D3B636F6E73747B4465666C6174653A68612C6465666C6174653A64612C6465666C6174655261773A5F612C677A69703A66617D3D6C652C7B496E666C6174653A63612C696E666C6174653A75612C696E666C6174655261773A77612C756E677A6970';
wwv_flow_imp.g_varchar2_table(466) := '3A6D617D3D6C613B7661722062613D68612C67613D64612C70613D5F612C6B613D66612C76613D63612C79613D75612C78613D77612C7A613D6D612C41613D4B2C45613D7B4465666C6174653A62612C6465666C6174653A67612C6465666C6174655261';
wwv_flow_imp.g_varchar2_table(467) := '773A70612C677A69703A6B612C496E666C6174653A76612C696E666C6174653A79612C696E666C6174655261773A78612C756E677A69703A7A612C636F6E7374616E74733A41617D3B742E4465666C6174653D62612C742E496E666C6174653D76612C74';
wwv_flow_imp.g_varchar2_table(468) := '2E636F6E7374616E74733D41612C742E64656661756C743D45612C742E6465666C6174653D67612C742E6465666C6174655261773D70612C742E677A69703D6B612C742E696E666C6174653D79612C742E696E666C6174655261773D78612C742E756E67';
wwv_flow_imp.g_varchar2_table(469) := '7A69703D7A612C4F626A6563742E646566696E6550726F706572747928742C225F5F65734D6F64756C65222C7B76616C75653A21307D297D29293B0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219971860076840768)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'libs/pako/pako.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '766172207064743D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E206528652C74297B72657475726E206E756C6C3D3D657C7C22223D3D653F743A657D66756E6374696F6E20742865297B66756E6374696F6E20742865';
wwv_flow_imp.g_varchar2_table(2) := '2C74297B72657475726E20652E73706C697428222E22292E7265647563652866756E6374696F6E28652C74297B72657475726E20653F655B745D3A6E756C6C7D2C747C7C73656C66297D72657475726E2074282273657474696E67732E222B652C706474';
wwv_flow_imp.g_varchar2_table(3) := '2E4A534F4E73657474696E6773297D66756E6374696F6E206928297B66756E6374696F6E206528297B72657475726E20646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E7457696474687D76617220742C692C612C6E3D242822';
wwv_flow_imp.g_varchar2_table(4) := '2361706578446576546F6F6C62617222292C6F3D2272746C223D3D3D6E2E6373732822646972656374696F6E22293F227269676874223A226C656674223B743D7B77696474683A22227D2C6E2E686173436C6173732822612D446576546F6F6C6261722D';
wwv_flow_imp.g_varchar2_table(5) := '2D746F7022297C7C6E2E686173436C6173732822612D446576546F6F6C6261722D2D626F74746F6D22293F28613D6528292C742E776869746553706163653D226E6F77726170222C6E2E6373732874292C693D6E2E6368696C6472656E2822756C22295B';
wwv_flow_imp.g_varchar2_table(6) := '305D2E636C69656E7457696474682B342C693E61262628693D61292C742E776869746553706163653D2277726170222C742E77696474683D692C745B6F5D3D28612D69292F32293A745B6F5D3D22222C6E2E6373732874297D66756E6374696F6E206128';
wwv_flow_imp.g_varchar2_table(7) := '297B76617220743D2428222361706578446576546F6F6C62617222292E6C656E6774683E303B6966287426262428222361706578446576546F6F6C6261724F7074696F6E7322292E6C656E6774683E302626303D3D2428222361706578446576546F6F6C';
wwv_flow_imp.g_varchar2_table(8) := '62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7322292E6C656E677468297B76617220613D273C7370616E20636C6173733D22612D49636F6E2066612066612D66696C7465722066616D2D782066616D2D69732D64616E676572';
wwv_flow_imp.g_varchar2_table(9) := '2220617269612D68696464656E3D2274727565223E3C2F7370616E3E273B2274727565223D3D7064742E6F70742E636F6E66696775726174696F6E54657374262628613D612E7265706C616365282266616D2D782066616D2D69732D64616E676572222C';
wwv_flow_imp.g_varchar2_table(10) := '222229292C2428222361706578446576546F6F6C6261724F7074696F6E7322292E706172656E7428292E616674657228617065782E6C616E672E666F726D61744E6F45736361706528273C6C693E3C627574746F6E2069643D2261706578446576546F6F';
wwv_flow_imp.g_varchar2_table(11) := '6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E732220747970653D22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C62617222207469746C653D225669657720506167';
wwv_flow_imp.g_varchar2_table(12) := '6520496E666F726D6174696F6E205B6374726C2B616C742B25305D2220617269612D6C6162656C3D22566172732220646174612D6C696E6B3D22223E202531203C2F627574746F6E3E3C2F6C693E272C225072657469757320446576656C6F7065722054';
wwv_flow_imp.g_varchar2_table(13) := '6F6F6C204F7074696F6E73222C6129293B766172206E3D646F63756D656E742E676574456C656D656E7442794964282261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7322293B66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(14) := '207228297B76617220653D7B73657474696E67733A7B6F70746F75743A7B7374617475733A617065782E6974656D282252305F4F50545F4F555422292E67657456616C756528297D2C72657665616C65723A7B656E61626C653A617065782E6974656D28';
wwv_flow_imp.g_varchar2_table(15) := '2252305F52455645414C45525F454E41424C4522292E67657456616C756528292C7461626C6F636B646561637469766174653A617065782E6974656D282252305F52455645414C45525F43524950504C455F5441424C4F434B22292E67657456616C7565';
wwv_flow_imp.g_varchar2_table(16) := '28292C6B623A617065782E6974656D282252305F52455645414C45525F4B425F53484F525443555422292E67657456616C756528297D2C72656C6F61646672616D653A7B656E61626C653A617065782E6974656D282252305F52454C4F41445F454E4142';
wwv_flow_imp.g_varchar2_table(17) := '4C4522292E67657456616C756528292C646576656C6F706572736F6E6C793A617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C5922292E67657456616C756528292C6279706173737761726E6F6E756E7361766564';
wwv_flow_imp.g_varchar2_table(18) := '3A617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E47454422292E67657456616C756528292C6B623A617065782E6974656D282252305F52454C4F41445F4B425F53484F525443555422292E67657456616C75652829';
wwv_flow_imp.g_varchar2_table(19) := '7D2C6275696C646F7074696F6E68696768746C696768743A7B656E61626C653A617065782E6974656D282252305F4255494C445F4F5054494F4E5F454E41424C4522292E67657456616C756528292C6475726174696F6E3A617065782E6974656D282252';
wwv_flow_imp.g_varchar2_table(20) := '305F4255494C445F4F5054494F4E5F4455524154494F4E22292E67657456616C756528297D2C6465766261723A7B676C6F776465627567656E61626C653A617065782E6974656D282252305F474C4F575F44454255475F49434F4E22292E67657456616C';
wwv_flow_imp.g_varchar2_table(21) := '756528292C6F70656E6275696C646572656E61626C653A617065782E6974656D282252305F4F50454E5F4255494C4445525F454E41424C4522292E67657456616C756528292C6F70656E6275696C64657263616368653A617065782E6974656D28225230';
wwv_flow_imp.g_varchar2_table(22) := '5F4F50454E5F4255494C4445525F434143484522292E67657456616C756528292C6F70656E6275696C6465726170706C696D69743A617065782E6974656D282252305F4F50454E5F4255494C4445525F4150505F4C494D495422292E67657456616C7565';
wwv_flow_imp.g_varchar2_table(23) := '28292C6F70656E6275696C6465726B623A617065782E6974656D282252305F4F50454E5F4255494C4445525F4B425F53484F525443555422292E67657456616C756528292C686F6D657265706C6163656C696E6B3A617065782E6974656D282252305F48';
wwv_flow_imp.g_varchar2_table(24) := '4F4D455F5245504C4143455F4C494E4B22292E67657456616C756528297D7D7D3B6C6F63616C53746F726167652E7365744974656D282270726574697573446576656C6F706572546F6F6C222C4A534F4E2E737472696E67696679286529292C7064742E';
wwv_flow_imp.g_varchar2_table(25) := '4A534F4E73657474696E67733D652C617065782E7468656D652E636C6F7365526567696F6E28242822237072657469757352657665616C6572496E6C696E652229292C617065782E6D6573736167652E73686F7750616765537563636573732822536574';
wwv_flow_imp.g_varchar2_table(26) := '74696E67732073617665642E205265667265736820796F75722062726F777365722E22297D6E26266E2E6164644576656E744C697374656E65722822636C69636B222C66756E6374696F6E2865297B6F28297D2C2130292C6C28292C6928292C24282223';
wwv_flow_imp.g_varchar2_table(27) := '61706578446576546F6F6C62617222292E7769647468282428222E612D446576546F6F6C6261722D6C69737422292E776964746828292B22707822292C242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C';
wwv_flow_imp.g_varchar2_table(28) := '222E6F70744F75744C696E6B222C66756E6374696F6E28297B617065782E6D6573736167652E636F6E6669726D28224279204F7074696E672D4F7574206F66205072657469757320446576656C6F70657220546F6F6C2C20796F752077696C6C206E6F20';
wwv_flow_imp.g_varchar2_table(29) := '6C6F6E6720686176652061636365737320746F2074686520706C75672D696E206665617475726573206F7220746869732073657474696E677320706167652E5C6E5C6E596F752063616E2072656761696E2061636365737320627920747970696E672074';
wwv_flow_imp.g_varchar2_table(30) := '686520666F6C6C6F77696E6720696E20746F207468652042726F7773657220436F6E736F6C65205C6E5C6E7064742E6F7074496E28293B5C6E5C6E596F752063616E2066696E64207468697320636F6D6D616E6420616761696E206F6E206F7572204769';
wwv_flow_imp.g_varchar2_table(31) := '7448756220506C7567696E20506167655C6E5C6E41726520796F75207375726520796F75207769736820746F20636F6E74696E75653F222C66756E6374696F6E2865297B65262628617065782E6974656D282252305F4F50545F4F555422292E73657456';
wwv_flow_imp.g_varchar2_table(32) := '616C756528225922292C722829297D297D292C242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C222E7064742D656E61626C652D616C6C222C66756E6374696F6E28297B617065782E6974656D28225230';
wwv_flow_imp.g_varchar2_table(33) := '5F52455645414C45525F454E41424C4522292E73657456616C756528225922292C617065782E6974656D282252305F52454C4F41445F454E41424C4522292E73657456616C756528225922292C617065782E6974656D282252305F4255494C445F4F5054';
wwv_flow_imp.g_varchar2_table(34) := '494F4E5F454E41424C4522292E73657456616C756528225922292C617065782E6974656D282252305F4F50454E5F4255494C4445525F454E41424C4522292E73657456616C756528225922292C617065782E6974656D282252305F474C4F575F44454255';
wwv_flow_imp.g_varchar2_table(35) := '475F49434F4E22292E73657456616C756528225922292C617065782E6974656D282252305F484F4D455F5245504C4143455F4C494E4B22292E73657456616C756528225922297D292C242822237072657469757352657665616C6572496E6C696E652229';
wwv_flow_imp.g_varchar2_table(36) := '2E6F6E2822636C69636B222C222352305F53415645222C66756E6374696F6E28297B7228297D292C242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C222352305F43414E43454C222C66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(37) := '28297B617065782E7468656D652E636C6F7365526567696F6E28242822237072657469757352657665616C6572496E6C696E652229297D292C242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C222352';
wwv_flow_imp.g_varchar2_table(38) := '305F52455645414C45525F454E41424C45222C66756E6374696F6E28297B224E223D3D6528617065782E6974656D282252305F52455645414C45525F454E41424C4522292E67657456616C756528292C224E22293F28617065782E6974656D282252305F';
wwv_flow_imp.g_varchar2_table(39) := '52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E455222292E64697361626C6528292C617065782E6974656D282252305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E455222292E64697361626C';
wwv_flow_imp.g_varchar2_table(40) := '652829293A28617065782E6974656D282252305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E455222292E656E61626C6528292C617065782E6974656D282252305F52455645414C45525F4B425F53484F5254435554';
wwv_flow_imp.g_varchar2_table(41) := '5F434F4E5441494E455222292E656E61626C652829297D292C242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C222352305F52454C4F41445F454E41424C45222C66756E6374696F6E28297B224E223D';
wwv_flow_imp.g_varchar2_table(42) := '3D6528617065782E6974656D282252305F52454C4F41445F454E41424C4522292E67657456616C756528292C224E22293F28617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455222292E64';
wwv_flow_imp.g_varchar2_table(43) := '697361626C6528292C617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E455222292E64697361626C6528292C617065782E6974656D282252305F52454C4F41445F4B425F53484F52544355';
wwv_flow_imp.g_varchar2_table(44) := '545F434F4E5441494E455222292E64697361626C652829293A28617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455222292E656E61626C6528292C617065782E6974656D282252305F5245';
wwv_flow_imp.g_varchar2_table(45) := '4C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E455222292E656E61626C6528292C617065782E6974656D282252305F52454C4F41445F4B425F53484F52544355545F434F4E5441494E455222292E656E61626C652829297D292C';
wwv_flow_imp.g_varchar2_table(46) := '242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C222352305F4255494C445F4F5054494F4E5F454E41424C45222C66756E6374696F6E28297B224E223D3D6528617065782E6974656D282252305F4255';
wwv_flow_imp.g_varchar2_table(47) := '494C445F4F5054494F4E5F454E41424C4522292E67657456616C756528292C224E22293F617065782E6974656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E455222292E64697361626C6528293A617065782E69';
wwv_flow_imp.g_varchar2_table(48) := '74656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E455222292E656E61626C6528297D292C242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C222352305F4F50';
wwv_flow_imp.g_varchar2_table(49) := '454E5F4255494C4445525F454E41424C45222C66756E6374696F6E28297B224E223D3D6528617065782E6974656D282252305F4F50454E5F4255494C4445525F454E41424C4522292E67657456616C756528292C224E22293F28617065782E6974656D28';
wwv_flow_imp.g_varchar2_table(50) := '2252305F4F50454E5F4255494C4445525F4B425F53484F52544355545F434F4E5441494E455222292E64697361626C6528292C617065782E6974656D282252305F4F50454E5F4255494C4445525F43414348455F434F4E5441494E455222292E64697361';
wwv_flow_imp.g_varchar2_table(51) := '626C6528292C617065782E6974656D282252305F4F50454E5F4255494C4445525F4150505F4C494D49545F434F4E5441494E455222292E64697361626C652829293A28617065782E6974656D282252305F4F50454E5F4255494C4445525F4B425F53484F';
wwv_flow_imp.g_varchar2_table(52) := '52544355545F434F4E5441494E455222292E656E61626C6528292C617065782E6974656D282252305F4F50454E5F4255494C4445525F43414348455F434F4E5441494E455222292E656E61626C6528292C617065782E6974656D282252305F4F50454E5F';
wwv_flow_imp.g_varchar2_table(53) := '4255494C4445525F4150505F4C494D49545F434F4E5441494E455222292E656E61626C652829297D297D7D66756E6374696F6E206E28297B617065782E7769646765742E7965734E6F282252305F52455645414C45525F454E41424C45222C2253574954';
wwv_flow_imp.g_varchar2_table(54) := '43485F434222292C617065782E7769646765742E7965734E6F282252305F52455645414C45525F43524950504C455F5441424C4F434B222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F52454C4F41445F454E';
wwv_flow_imp.g_varchar2_table(55) := '41424C45222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F52454C4F41445F444556454C4F504552535F4F4E4C59222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F';
wwv_flow_imp.g_varchar2_table(56) := '52454C4F41445F4259504153535F554E4348414E474544222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F4255494C445F4F5054494F4E5F454E41424C45222C225357495443485F434222292C617065782E77';
wwv_flow_imp.g_varchar2_table(57) := '69646765742E7965734E6F282252305F4F50454E5F4255494C4445525F454E41424C45222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F474C4F575F44454255475F49434F4E222C225357495443485F434222';
wwv_flow_imp.g_varchar2_table(58) := '292C617065782E7769646765742E7965734E6F282252305F4F50454E5F4255494C4445525F4341434845222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F4F50454E5F4255494C4445525F4150505F4C494D49';
wwv_flow_imp.g_varchar2_table(59) := '54222C225357495443485F434222292C617065782E7769646765742E7965734E6F282252305F484F4D455F5245504C4143455F4C494E4B222C225357495443485F434222292C2428222E7072657469757352657665616C6572496E6C696E65546F546865';
wwv_flow_imp.g_varchar2_table(60) := '546F70202E742D427574746F6E526567696F6E2D636F6C2D2D7269676874202E742D427574746F6E526567696F6E2D627574746F6E7322292E656D70747928292C2428222E7072657469757352657665616C6572496E6C696E65546F546865546F70202E';
wwv_flow_imp.g_varchar2_table(61) := '742D427574746F6E526567696F6E2D636F6C2D2D6C656674202E742D427574746F6E526567696F6E2D627574746F6E7322292E656D70747928292C242822237072657469757352657665616C6572496E6C696E65202352305F5341564522292E61707065';
wwv_flow_imp.g_varchar2_table(62) := '6E64546F282428222E742D427574746F6E526567696F6E2D636F6C2D2D7269676874202E742D427574746F6E526567696F6E2D627574746F6E732229292C242822237072657469757352657665616C6572496E6C696E65202352305F43414E43454C2229';
wwv_flow_imp.g_varchar2_table(63) := '2E617070656E64546F282428222E742D427574746F6E526567696F6E2D636F6C2D2D6C656674202E742D427574746F6E526567696F6E2D627574746F6E732229292C2428222E7072657469757352657665616C6572496E6C696E65546F546865546F7020';
wwv_flow_imp.g_varchar2_table(64) := '237072657469757352657665616C6572427574746F6E526567696F6E22292E73686F7728293B76617220653D7064742E4A534F4E73657474696E67733B696628242E6973456D7074794F626A6563742865297C7C28617065782E6974656D282252305F52';
wwv_flow_imp.g_varchar2_table(65) := '455645414C45525F454E41424C4522292E73657456616C7565287064742E67657453657474696E67282272657665616C65722E656E61626C652229292C617065782E6974656D282252305F52455645414C45525F43524950504C455F5441424C4F434B22';
wwv_flow_imp.g_varchar2_table(66) := '292E73657456616C7565287064742E6E766C287064742E67657453657474696E67282272657665616C65722E7461626C6F636B6465616374697661746522292C22592229292C617065782E6974656D282252305F52455645414C45525F4B425F53484F52';
wwv_flow_imp.g_varchar2_table(67) := '5443555422292E73657456616C7565287064742E6E766C287064742E67657453657474696E67282272657665616C65722E6B6222292C22512229292C617065782E6974656D282252305F52454C4F41445F454E41424C4522292E73657456616C75652870';
wwv_flow_imp.g_varchar2_table(68) := '64742E67657453657474696E67282272656C6F61646672616D652E656E61626C652229292C617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C5922292E73657456616C7565287064742E67657453657474696E6728';
wwv_flow_imp.g_varchar2_table(69) := '2272656C6F61646672616D652E6279706173737761726E6F6E756E73617665642229292C617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E47454422292E73657456616C7565287064742E6E766C287064742E676574';
wwv_flow_imp.g_varchar2_table(70) := '53657474696E67282272656C6F61646672616D652E6279706173737761726E6F6E756E736176656422292C22592229292C617065782E6974656D282252305F52454C4F41445F4B425F53484F525443555422292E73657456616C7565287064742E6E766C';
wwv_flow_imp.g_varchar2_table(71) := '287064742E67657453657474696E67282272656C6F61646672616D652E6B6222292C22522229292C617065782E6974656D282252305F4255494C445F4F5054494F4E5F454E41424C4522292E73657456616C7565287064742E67657453657474696E6728';
wwv_flow_imp.g_varchar2_table(72) := '226275696C646F7074696F6E68696768746C696768742E656E61626C652229292C617065782E6974656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E22292E73657456616C7565287064742E6E766C287064742E6765745365747469';
wwv_flow_imp.g_varchar2_table(73) := '6E6728226275696C646F7074696F6E68696768746C696768742E6475726174696F6E22292C22362229292C617065782E6974656D282252305F4F50454E5F4255494C4445525F454E41424C4522292E73657456616C7565287064742E6765745365747469';
wwv_flow_imp.g_varchar2_table(74) := '6E6728226465766261722E6F70656E6275696C646572656E61626C652229292C617065782E6974656D282252305F4F50454E5F4255494C4445525F434143484522292E73657456616C7565287064742E67657453657474696E6728226465766261722E6F';
wwv_flow_imp.g_varchar2_table(75) := '70656E6275696C64657263616368652229292C617065782E6974656D282252305F4F50454E5F4255494C4445525F4150505F4C494D495422292E73657456616C7565287064742E67657453657474696E6728226465766261722E6F70656E6275696C6465';
wwv_flow_imp.g_varchar2_table(76) := '726170706C696D69742229292C617065782E6974656D282252305F4F50454E5F4255494C4445525F4B425F53484F525443555422292E73657456616C7565287064742E6E766C287064742E67657453657474696E6728226465766261722E6F70656E6275';
wwv_flow_imp.g_varchar2_table(77) := '696C6465726B6222292C22572229292C617065782E6974656D282252305F474C4F575F44454255475F49434F4E22292E73657456616C7565287064742E67657453657474696E6728226465766261722E676C6F776465627567656E61626C652229292C61';
wwv_flow_imp.g_varchar2_table(78) := '7065782E6974656D282252305F484F4D455F5245504C4143455F4C494E4B22292E73657456616C7565287064742E67657453657474696E6728226465766261722E686F6D657265706C6163656C696E6B222929292C242822237072657469757352657665';
wwv_flow_imp.g_varchar2_table(79) := '616C6572496E6C696E65202352305F52455645414C45525F454E41424C4522292E7472696767657228226368616E676522292C242822237072657469757352657665616C6572496E6C696E65202352305F52454C4F41445F454E41424C4522292E747269';
wwv_flow_imp.g_varchar2_table(80) := '6767657228226368616E676522292C242822237072657469757352657665616C6572496E6C696E65202352305F4255494C445F4F5054494F4E5F454E41424C4522292E7472696767657228226368616E676522292C242822237072657469757352657665';
wwv_flow_imp.g_varchar2_table(81) := '616C6572496E6C696E65202352305F4F50454E5F4255494C4445525F454E41424C4522292E7472696767657228226368616E676522292C242822237072657469757352657665616C6572496E6C696E65202352305F474C4F575F44454255475F49434F4E';
wwv_flow_imp.g_varchar2_table(82) := '22292E7472696767657228226368616E676522292C242822237072657469757352657665616C6572496E6C696E65202352305F484F4D455F5245504C4143455F4C494E4B22292E7472696767657228226368616E676522292C2266616C7365223D3D7064';
wwv_flow_imp.g_varchar2_table(83) := '742E6F70742E636F6E66696775726174696F6E5465737426262428222370726574697573446576656C6F706572546F6F6C5761726E696E6722292E73686F7728292C2D31213D3D6E6176696761746F722E757365724167656E742E696E6465784F662822';
wwv_flow_imp.g_varchar2_table(84) := '4D61632229297B76617220743D224B6579626F6172642053686F727463757420636F6E74726F6C2B6F7074696F6E2B2E2E2E223B2428222352305F52455645414C45525F4B425F53484F52544355545F4C4142454C22292E746578742874292C24282223';
wwv_flow_imp.g_varchar2_table(85) := '52305F52454C4F41445F4B425F53484F52544355545F4C4142454C22292E746578742874292C2428222352305F524F50454E5F4255494C4445525F4B425F53484F52544355545F4C4142454C22292E746578742874297D7D66756E6374696F6E206F2865';
wwv_flow_imp.g_varchar2_table(86) := '297B617065782E7468656D652E6F70656E526567696F6E28242822237072657469757352657665616C6572496E6C696E652229292C242822237072657469757352657665616C6572496E6C696E65202E742D4469616C6F67526567696F6E2D626F647922';
wwv_flow_imp.g_varchar2_table(87) := '292E6C6F6164287064742E6F70742E66696C655072656669782B2270726574697573446576656C6F706572546F6F6C2E68746D6C222C66756E6374696F6E28297B6E28297D292C242822237072657469757352657665616C6572496E6C696E6520237072';
wwv_flow_imp.g_varchar2_table(88) := '6574697573436F6E74656E7422292E656D70747928292C2428222E7072657469757352657665616C6572496E6C696E65546F546865546F70202E75692D6469616C6F672D7469746C6522292E746578742822205072657469757320446576656C6F706572';
wwv_flow_imp.g_varchar2_table(89) := '20546F6F6C3A204F7074696F6E7322297D66756E6374696F6E206C28297B76617220653D273C64697620636C6173733D227072657469757352657665616C6572466F6F746572223E3C6120636C6173733D227072657469757352657665616C65724C696E';
wwv_flow_imp.g_varchar2_table(90) := '6B2070726574697573466F6F7465724F7074696F6E732220687265663D2268747470733A2F2F707265746975732E636F6D2F6D61696E2F22207461726765743D225F626C616E6B223E507265746975733C2F613E3C6120636C6173733D22707265746975';
wwv_flow_imp.g_varchar2_table(91) := '7352657665616C65724C696E6B2220687265663D2268747470733A2F2F747769747465722E636F6D2F4D6174745F4D756C76616E657922207461726765743D225F626C616E6B223E404D6174745F4D756C76616E6579203C2F613E3C6120636C6173733D';
wwv_flow_imp.g_varchar2_table(92) := '227072657469757352657665616C65724C696E6B2220687265663D2268747470733A2F2F747769747465722E636F6D2F50726574697573536F66747761726522207461726765743D225F626C616E6B223E4050726574697573536F6674776172653C2F61';
wwv_flow_imp.g_varchar2_table(93) := '3E3C64697620636C6173733D22707265746975735461626C6F636B56657273696F6E223E3C2F6469763E3C2F6469763E273B303D3D2428222E742D426F64792D696E6C696E654469616C6F677322292E6C656E6774682626242822236170657844657654';
wwv_flow_imp.g_varchar2_table(94) := '6F6F6C62617222292E70726570656E6428273C64697620636C6173733D22742D426F64792D696E6C696E654469616C6F6773223E3C2F6469763E27292C303D3D2428222E742D426F64792D696E6C696E654469616C6F6773202E636F6E7461696E657222';
wwv_flow_imp.g_varchar2_table(95) := '292E6C656E67746826262428222E742D426F64792D696E6C696E654469616C6F677322292E617070656E6428273C64697620636C6173733D22636F6E7461696E6572223E3C2F6469763E27292C2428222E742D426F64792D696E6C696E654469616C6F67';
wwv_flow_imp.g_varchar2_table(96) := '73202E636F6E7461696E657222292E617070656E642827202020203C64697620636C6173733D22726F77223E20202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E2020202020202020203C646976';
wwv_flow_imp.g_varchar2_table(97) := '2069643D227072657469757352657665616C6572496E6C696E655F706172656E74223E202020202020202020202020203C6469762069643D227072657469757352657665616C6572496E6C696E65222020202020202020202020202020202020636C6173';
wwv_flow_imp.g_varchar2_table(98) := '733D22742D4469616C6F67526567696F6E206A732D6D6F64616C206A732D6469616C6F672D6E6F4F7665726C6179206A732D647261676761626C65206A732D726573697A61626C65206A732D6469616C6F672D6175746F686569676874206A732D646961';
wwv_flow_imp.g_varchar2_table(99) := '6C6F672D73697A6536303078343030206A732D726567696F6E4469616C6F672220202020202020202020202020202020207374796C653D22646973706C61793A6E6F6E6522207469746C653D22205072657469757320446576656C6F70657220546F6F6C';
wwv_flow_imp.g_varchar2_table(100) := '3A2052657665616C6572223E20202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D77726170223E2020202020202020202020202020202020202020203C64697620636C6173733D22742D446961';
wwv_flow_imp.g_varchar2_table(101) := '6C6F67526567696F6E2D626F6479577261707065724F7574223E202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D626F647957726170706572496E223E20202020202020';
wwv_flow_imp.g_varchar2_table(102) := '202020202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D626F6479223E3C2F6469763E202020202020202020202020202020202020202020202020203C2F6469763E2020202020202020';
wwv_flow_imp.g_varchar2_table(103) := '202020202020202020202020203C2F6469763E2020202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D627574746F6E73223E202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(104) := '203C6469762069643D227072657469757352657665616C6572427574746F6E526567696F6E2220636C6173733D22742D427574746F6E526567696F6E20742D427574746F6E526567696F6E2D2D6469616C6F67526567696F6E22207374796C653D226469';
wwv_flow_imp.g_varchar2_table(105) := '73706C61793A6E6F6E65223E20202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D77726170223E2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(106) := '202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D636F6C20742D427574746F6E526567696F6E2D636F6C2D2D6C656674223E202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(107) := '203C64697620636C6173733D22742D427574746F6E526567696F6E2D627574746F6E73223E3C2F6469763E2020202020202020202020202020202020202020202020202020202020202020203C2F6469763E202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(108) := '2020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D636F6C20742D427574746F6E526567696F6E2D636F6C2D2D7269676874223E202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(109) := '202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D627574746F6E73223E3C2F6469763E2020202020202020202020202020202020202020202020202020202020202020203C2F6469763E202020202020202020';
wwv_flow_imp.g_varchar2_table(110) := '20202020202020202020202020202020202020203C2F6469763E202020202020202020202020202020202020202020202020203C2F6469763E2020202020202020202020202020202020202020203C2F6469763E20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(111) := '203C2F6469763E202020202020202020202020203C2F6469763E2020202020202020203C2F6469763E20202020203C2F6469763E203C2F6469763E2027293B76617220743D77696E646F772E696E6E657257696474682D32302C693D77696E646F772E69';
wwv_flow_imp.g_varchar2_table(112) := '6E6E65724865696768742D32303B743E316533262628743D316533292C693E363530262628693D363530292C242822237072657469757352657665616C6572496E6C696E6522292E656163682866756E6374696F6E28297B76617220613D242874686973';
wwv_flow_imp.g_varchar2_table(113) := '292C6E3D612E686173436C61737328226A732D726567696F6E506F70757022292C6F3D5B226A732D6469616C6F672D73697A6536303078343030222C742C695D2C6C3D2F6A732D706F7075702D706F732D285C772B292F2E6578656328746869732E636C';
wwv_flow_imp.g_varchar2_table(114) := '6173734E616D65292C723D612E617474722822646174612D706172656E742D656C656D656E7422292C733D7B6175746F4F70656E3A21312C636F6C6C61707365456E61626C65643A21302C6E6F4F7665726C61793A612E686173436C61737328226A732D';
wwv_flow_imp.g_varchar2_table(115) := '706F7075702D6E6F4F7665726C617922292C636C6F7365546578743A617065782E6C616E672E6765744D6573736167652822415045582E4449414C4F472E434C4F534522292C6D6F64616C3A6E7C7C612E686173436C61737328226A732D6D6F64616C22';
wwv_flow_imp.g_varchar2_table(116) := '292C726573697A61626C653A216E2626612E686173436C61737328226A732D726573697A61626C6522292C647261676761626C653A216E2626612E686173436C61737328226A732D647261676761626C6522292C6469616C6F67436C6173733A2275692D';
wwv_flow_imp.g_varchar2_table(117) := '6469616C6F672D2D696E6C696E65207072657469757352657665616C6572496E6C696E65546F546865546F70222C6F70656E3A66756E6374696F6E2865297B2428222E7072657469757352657665616C6572496E6C696E65546F546865546F70202E7072';
wwv_flow_imp.g_varchar2_table(118) := '6574697573436F6D707265737342746E22292E73686F7728292C2428222E7072657469757352657665616C6572496E6C696E65546F546865546F70202E70726574697573457870616E6442746E22292E6869646528292C2428222E707265746975735265';
wwv_flow_imp.g_varchar2_table(119) := '7665616C6572496E6C696E65546F546865546F7020237072657469757352657665616C6572427574746F6E526567696F6E22292E6869646528293B76617220743D2428222E75692D7769646765742D6F7665726C61792E75692D66726F6E7422292E6373';
wwv_flow_imp.g_varchar2_table(120) := '7328227A2D696E64657822293B2428652E746172676574292E6469616C6F6728226F7074696F6E222C226F7665726C61792D7A2D696E646578222C74292C2428222E75692D7769646765742D6F7665726C61792E75692D66726F6E7422292E6373732822';
wwv_flow_imp.g_varchar2_table(121) := '7A2D696E646578222C2222297D2C636C6F73653A66756E6374696F6E2865297B76617220743D2428652E746172676574292E6469616C6F6728226F7074696F6E222C226F7665726C61792D7A2D696E64657822293B2428222E75692D7769646765742D6F';
wwv_flow_imp.g_varchar2_table(122) := '7665726C61792E75692D66726F6E7422292E63737328227A2D696E646578222C74297D2C6372656174653A66756E6374696F6E28297B242874686973292E636C6F7365737428222E75692D6469616C6F6722292E6373732822706F736974696F6E222C22';
wwv_flow_imp.g_varchar2_table(123) := '666978656422292C242822237072657469757352657665616C6572496E6C696E6522292E706172656E7428292E617070656E642865292C2428222E7072657469757352657665616C6572466F6F746572202E707265746975735461626C6F636B56657273';
wwv_flow_imp.g_varchar2_table(124) := '696F6E22292E74657874287064742E6F70742E76657273696F6E297D7D2C703D6E3F22706F707570223A226469616C6F67223B6F262628732E77696474683D6F5B315D2C732E6865696768743D6F5B325D292C7226266E262628732E706172656E74456C';
wwv_flow_imp.g_varchar2_table(125) := '656D656E743D722C612E686173436C61737328226A732D706F7075702D63616C6C6F75742229262628732E63616C6C6F75743D2130292C6C262628732E72656C6174697665506F736974696F6E3D6C5B315D29292C242E65616368285B22776964746822';
wwv_flow_imp.g_varchar2_table(126) := '2C22686569676874222C226D696E5769647468222C226D696E486569676874222C226D61785769647468222C226D6178486569676874225D2C66756E6374696F6E28652C74297B76617220693D7061727365496E7428612E617474722822646174612D22';
wwv_flow_imp.g_varchar2_table(127) := '2B742E746F4C6F776572436173652829292C3130293B69734E614E2869297C7C28735B745D3D69297D292C242E65616368285B22617070656E64546F222C226469616C6F67436C617373225D2C66756E6374696F6E28652C74297B76617220693D612E61';
wwv_flow_imp.g_varchar2_table(128) := '7474722822646174612D222B742E746F4C6F776572436173652829293B69262628735B745D3D69297D292C732E617070656E64546F26262223223D3D3D732E617070656E64546F2E737562737472696E6728302C31292626303D3D3D2428732E61707065';
wwv_flow_imp.g_varchar2_table(129) := '6E64546F292E6C656E677468262624282223777776466C6F77466F726D22292E616674657228273C6469762069643D22272B7574696C2E65736361706548544D4C28732E617070656E64546F2E737562737472696E67283129292B27223E3C2F6469763E';
wwv_flow_imp.g_varchar2_table(130) := '27292C615B705D2873292E6F6E28702B226F70656E222C66756E6374696F6E28297B732E6D6F64616C2626617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28292C617065782E7769646765742E7574696C2E76697369';
wwv_flow_imp.g_varchar2_table(131) := '62696C6974794368616E676528615B305D2C2130297D292E6F6E28702B22726573697A65222C66756E6374696F6E28297B242874686973292E636C6F7365737428222E75692D6469616C6F6722292E6373732822706F736974696F6E222C226669786564';
wwv_flow_imp.g_varchar2_table(132) := '22297D292E6F6E28702B22636C6F7365222C66756E6374696F6E28297B732E6D6F64616C2626617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28292C242822237072657469757352657665616C6572496E6C696E65202E74';
wwv_flow_imp.g_varchar2_table(133) := '2D4469616C6F67526567696F6E2D626F647922292E656D70747928292C617065782E7769646765742E7574696C2E7669736962696C6974794368616E676528615B305D2C2131297D297D293B76617220613D273C696D67207372633D22272B7064742E6F';
wwv_flow_imp.g_varchar2_table(134) := '70742E66696C655072656669782B2772657665616C65722F666F6E7441706578486970737465722E7376672220636C6173733D227461626C6F636B4869707374657249636F6E206D617267696E2D72696768742D736D222F3E273B242822237072657469';
wwv_flow_imp.g_varchar2_table(135) := '757352657665616C6572496E6C696E6522292E706172656E7428292E66696E6428222E75692D6469616C6F672D7469746C6522292E616464436C6173732822666122292E6265666F72652861297D76617220722C732C702C752C523D66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(136) := '2865297B7064742E64613D652E64612C7064742E6F70743D652E6F70742C7064742E4A534F4E73657474696E67733D4A534F4E2E7061727365286C6F63616C53746F726167652E6765744974656D282270726574697573446576656C6F706572546F6F6C';
wwv_flow_imp.g_varchar2_table(137) := '2229292C617065782E64656275672E696E666F28652E6F70742E64656275675072656669782B2272656E646572222C65292C225922213D7064742E67657453657474696E6728226F70746F75742E73746174757322292626286128292C242E6973456D70';
wwv_flow_imp.g_varchar2_table(138) := '74794F626A656374287064742E4A534F4E73657474696E6773297C7C282259223D3D74282272657665616C65722E656E61626C65222926267064742E70726574697573436F6E74656E7452657665616C65722E6164644869707374657228292C2259223D';
wwv_flow_imp.g_varchar2_table(139) := '3D74282272656C6F61646672616D652E656E61626C65222926267064742E70726574697573436F6E74656E7452656C6F61644672616D652E616374697661746528292C2259223D3D7428226275696C646F7074696F6E68696768746C696768742E656E61';
wwv_flow_imp.g_varchar2_table(140) := '626C65222926267064742E636F6E74656E744275696C644F7074696F6E486967686C696768742E616374697661746528292C2259223D3D7428226465766261722E6F70656E6275696C646572656E61626C65222926267064742E70726574697573436F6E';
wwv_flow_imp.g_varchar2_table(141) := '74656E744465764261722E61637469766174654F70656E4275696C64657228292C2259223D3D7428226465766261722E676C6F776465627567656E61626C65222926267064742E70726574697573436F6E74656E744465764261722E6163746976617465';
wwv_flow_imp.g_varchar2_table(142) := '476C6F77446562756728292C2259223D3D7428226465766261722E686F6D657265706C6163656C696E6B222926267064742E70726574697573436F6E74656E744465764261722E6163746976617465486F6D655265706C616365282929292C7064742E66';
wwv_flow_imp.g_varchar2_table(143) := '6978546F6F6C626172576964746828297D2C5F3D66756E6374696F6E28297B7064742E7061676544656275674C6576656C3D617065782E6974656D282270646562756722292E67657456616C756528292C617065782E6974656D28227064656275672229';
wwv_flow_imp.g_varchar2_table(144) := '2E73657456616C756528224C4556454C3222297D2C673D66756E6374696F6E28297B6E756C6C213D7064742E7061676544656275674C6576656C2626617065782E6974656D282270646562756722292E73657456616C7565287064742E70616765446562';
wwv_flow_imp.g_varchar2_table(145) := '75674C6576656C297D2C643D66756E6374696F6E28652C742C69297B7064742E756E436C6F616B44656275674C6576656C28292C617065782E6D6573736167652E636C6561724572726F727328292C617065782E6D6573736167652E73686F774572726F';
wwv_flow_imp.g_varchar2_table(146) := '7273285B7B747970653A226572726F72222C6C6F636174696F6E3A5B2270616765225D2C6D6573736167653A692B223C62723E506C6561736520636865636B2062726F7773657220636F6E736F6C652E222C756E736166653A21317D5D292C617065782E';
wwv_flow_imp.g_varchar2_table(147) := '64656275672E696E666F28652C742C69297D2C453D66756E6374696F6E28297B76617220653D4A534F4E2E7061727365286C6F63616C53746F726167652E6765744974656D282270726574697573446576656C6F706572546F6F6C2229293B6E756C6C21';
wwv_flow_imp.g_varchar2_table(148) := '3D65262628652E73657474696E67732E6F70746F75742E7374617475733D224E222C6C6F63616C53746F726167652E7365744974656D282270726574697573446576656C6F706572546F6F6C222C4A534F4E2E737472696E67696679286529292C617065';
wwv_flow_imp.g_varchar2_table(149) := '782E6D6573736167652E73686F77506167655375636365737328224F7074656420496E20746F205072657469757320446576656C6F70657220546F6F6C2E205265667265736820796F75722062726F777365722E2229297D3B72657475726E7B72656E64';
wwv_flow_imp.g_varchar2_table(150) := '65723A522C64613A722C6F70743A732C4A534F4E73657474696E67733A702C6E766C3A652C666978546F6F6C62617257696474683A692C67657453657474696E673A742C7061676544656275674C6576656C3A752C636C6F616B44656275674C6576656C';
wwv_flow_imp.g_varchar2_table(151) := '3A5F2C756E436C6F616B44656275674C6576656C3A672C616A61784572726F7248616E646C65723A642C6F7074496E3A457D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219972239998840771)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'minified/pretiusDeveloperTool.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '3C64697620636C6173733D22726F77223E0D0A202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A20202020202020203C64697620636C6173733D22742D416C65727420742D416C6572742D2D';
wwv_flow_imp.g_varchar2_table(2) := '636F6C6F72424720742D416C6572742D2D686F72697A6F6E74616C20742D416C6572742D2D64656661756C7449636F6E7320742D416C6572742D2D7761726E696E6720742D416C6572742D2D61636365737369626C6548656164696E67220D0A20202020';
wwv_flow_imp.g_varchar2_table(3) := '202020202020202069643D2270726574697573446576656C6F706572546F6F6C5761726E696E6722207374796C653D22646973706C61793A6E6F6E65223E0D0A2020202020202020202020203C64697620636C6173733D22742D416C6572742D77726170';
wwv_flow_imp.g_varchar2_table(4) := '223E0D0A202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D69636F6E223E0D0A20202020202020202020202020202020202020203C7370616E20636C6173733D22742D49636F6E20223E3C2F7370616E3E0D0A20';
wwv_flow_imp.g_varchar2_table(5) := '2020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D636F6E74656E74223E0D0A20202020202020202020202020202020202020203C64697620636C617373';
wwv_flow_imp.g_varchar2_table(6) := '3D22742D416C6572742D686561646572223E0D0A2020202020202020202020202020202020202020202020203C683220636C6173733D22742D416C6572742D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C5761726E696E';
wwv_flow_imp.g_varchar2_table(7) := '675F68656164696E67223E436F6E66696775726174696F6E2050726F626C656D3C2F68323E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C64697620636C6173733D2274';
wwv_flow_imp.g_varchar2_table(8) := '2D416C6572742D626F6479223E5072657469757320446576656C6F70657220546F6F6C206973206120706C7567696E2074686174206578706F736573206D616E7920415045582076616C75657320666F72207468650D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(9) := '202020202020202020202062656E65666974206F662074686520446576656C6F7065722E3C62723E0D0A2020202020202020202020202020202020202020202020205768696C73742074686520506C7567696E206973206F6E6C79206163746976617465';
wwv_flow_imp.g_varchar2_table(10) := '6420776869736C742074686520446576656C6F706572204261722069732070726573656E742C207468657265206D617920626520776179730D0A20202020202020202020202020202020202020202020202074686174206120637572696F757320656E64';
wwv_flow_imp.g_varchar2_table(11) := '2D7573657220636F756C6420656E61626C6520746865204465766C6F70657220546F6F6C2074687573206578706F73696E67206170706C69636174696F6E206C6F6769632E3C62723E0D0A20202020202020202020202020202020202020202020202054';
wwv_flow_imp.g_varchar2_table(12) := '6F2061747461696E2074686520686967686573742073656375726974792C20697420697320686967686C79207265636F6D6D656E64656420746861743A0D0A2020202020202020202020202020202020202020202020203C756C3E0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(13) := '2020202020202020202020202020202020202020203C6C693E596F752068617665206F6E6520616E64206F6E6C79206F6E65205072657469757320446576656C6F70657220546F6F6C2044796E616D6963205472756520416374696F6E206F6E20506167';
wwv_flow_imp.g_varchar2_table(14) := '65205A65726F3C2F6C693E0D0A202020202020202020202020202020202020202020202020202020203C6C693E5468652044796E616D696320416374696F6E206973206173736F63696174656420776974682061203C610D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(15) := '20202020202020202020202020202020202020202020202020687265663D2268747470733A2F2F7777772E796F75747562652E636F6D2F77617463683F763D584F4C437248535252724D26743D38347322207461726765743D225F626C616E6B223E4275';
wwv_flow_imp.g_varchar2_table(16) := '696C640D0A2020202020202020202020202020202020202020202020202020202020202020202020204F7074696F6E20746861742069732073657420746F204578636C756465206F6E204578706F72743C2F613E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(17) := '20202020202020202020202020203C2F6C693E0D0A2020202020202020202020202020202020202020202020203C2F756C3E0D0A2020202020202020202020202020202020202020202020205768696C73742074686520506C7567696E2077696C6C2073';
wwv_flow_imp.g_varchar2_table(18) := '74696C6C20636F6E74696E756520746F2066756E6374696F6E2C2074686973206D6573736167652077696C6C206E616720796F7520756E74696C20796F752074616B65207468650D0A202020202020202020202020202020202020202020202020616374';
wwv_flow_imp.g_varchar2_table(19) := '696F6E206465736372696265642061626F76652E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C64697620636C617373';
wwv_flow_imp.g_varchar2_table(20) := '3D22742D416C6572742D627574746F6E73223E3C2F6469763E0D0A2020202020202020202020203C2F6469763E0D0A20202020202020203C2F6469763E0D0A202020203C2F6469763E0D0A3C2F6469763E0D0A0D0A3C64697620636C6173733D22726F77';
wwv_flow_imp.g_varchar2_table(21) := '223E0D0A202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A20202020202020203C6469763E0D0A2020202020202020202020203C7020636C6173733D226D617267696E2D626F74746F6D2D736D';
wwv_flow_imp.g_varchar2_table(22) := '206F70744F757454657874206D617267696E2D6C6566742D736D22207374796C653D22666F6E742D73697A653A20736D616C6C65723B223E446F6E27742077616E7420746F20757365205072657469757320446576656C6F70657220546F6F6C3F0D0A20';
wwv_flow_imp.g_varchar2_table(23) := '2020202020202020202020202020203C6120687265663D226A6176617363726970743A766F69642830292220636C6173733D226F70744F75744C696E6B223E4F70742D4F75743C2F613E20686572650D0A2020202020202020202020203C2F703E0D0A20';
wwv_flow_imp.g_varchar2_table(24) := '202020202020203C2F6469763E0D0A202020203C2F6469763E0D0A202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A20202020202020203C6469763E0D0A2020202020202020202020203C7020';
wwv_flow_imp.g_varchar2_table(25) := '636C6173733D226D617267696E2D626F74746F6D2D736D206F70744F75745465787420752D70756C6C5269676874206D617267696E2D72696768742D736D22207374796C653D22666F6E742D73697A653A20736D616C6C65723B223E436C69636B20746F';
wwv_flow_imp.g_varchar2_table(26) := '0D0A202020202020202020202020202020203C6120687265663D226A6176617363726970743A766F69642830292220636C6173733D227064742D656E61626C652D616C6C223E456E61626C6520416C6C3C2F613E2073657474696E67730D0A2020202020';
wwv_flow_imp.g_varchar2_table(27) := '202020202020203C2F703E0D0A20202020202020203C2F6469763E0D0A202020203C2F6469763E0D0A3C2F6469763E0D0A0D0A3C64697620636C6173733D22726F77223E0D0A202020203C64697620636C6173733D22636F6C20636F6C2D313220617065';
wwv_flow_imp.g_varchar2_table(28) := '782D636F6C2D6175746F223E0D0A20202020202020203C6469762069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E73223E0D0A2020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A20';
wwv_flow_imp.g_varchar2_table(29) := '2020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(30) := '20202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67220D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(31) := '20202020202020202069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E7352657665616C6572223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E';
wwv_flow_imp.g_varchar2_table(32) := '2D686561646572223E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D7469';
wwv_flow_imp.g_varchar2_table(33) := '746C65223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49636F6E20220D0A';
wwv_flow_imp.g_varchar2_table(34) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(35) := '2020202020202020202020202020203C683220636C6173733D22742D526567696F6E2D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E7352657665616C65725F68656164696E67223E0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(36) := '20202020202020202020202020202020202020202020202020202020202020202052657665616C65720D0A2020202020202020202020202020202020202020202020202020202020202020202020203C2F68323E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(37) := '2020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D';
wwv_flow_imp.g_varchar2_table(38) := '6865616465724974656D732D2D627574746F6E73223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D226A732D6D6178696D697A65427574746F6E436F6E7461696E';
wwv_flow_imp.g_varchar2_table(39) := '6572223E3C2F7370616E3E3C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567';
wwv_flow_imp.g_varchar2_table(40) := '696F6E2D626F647957726170223E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D746F70223E';
wwv_flow_imp.g_varchar2_table(41) := '0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(42) := '20202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D';
wwv_flow_imp.g_varchar2_table(43) := '0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F6479223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64';
wwv_flow_imp.g_varchar2_table(44) := '697620636C6173733D22636F6E7461696E6572223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C696E70757420747970653D2268696464656E222069643D2252305F4F50545F4F55542220';
wwv_flow_imp.g_varchar2_table(45) := '6E616D653D2252305F4F50545F4F5554222076616C75653D224E223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(46) := '2020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(47) := '2020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D';
wwv_flow_imp.g_varchar2_table(48) := '7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52455645414C45525F454E41424C455F434F4E5441494E4552223E0D0A2020';
wwv_flow_imp.g_varchar2_table(49) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A202020';
wwv_flow_imp.g_varchar2_table(50) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52455645414C45525F454E41424C45222069643D2252305F52455645414C4552';
wwv_flow_imp.g_varchar2_table(51) := '5F454E41424C455F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E456E61';
wwv_flow_imp.g_varchar2_table(52) := '626C653C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(53) := '202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(54) := '202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(55) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F52455645414C45525F454E41424C45220D0A';
wwv_flow_imp.g_varchar2_table(56) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F52455645414C45525F454E41424C45222076616C75653D';
wwv_flow_imp.g_varchar2_table(57) := '2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F6666';
wwv_flow_imp.g_varchar2_table(58) := '2D76616C75653D224E220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F666622';
wwv_flow_imp.g_varchar2_table(59) := '20646174612D6E702D636865636B65643D2231223E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173';
wwv_flow_imp.g_varchar2_table(60) := '733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C73';
wwv_flow_imp.g_varchar2_table(61) := '70616E2069643D2252305F52455645414C45525F454E41424C455F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(62) := '20202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(63) := '2020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(64) := '20202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(65) := '202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D31322061';
wwv_flow_imp.g_varchar2_table(66) := '7065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E6572207265';
wwv_flow_imp.g_varchar2_table(67) := '6C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(68) := '202020202069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E4552223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(69) := '20203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(70) := '20202020203C6C6162656C20666F723D2252305F52455645414C45525F43524950504C455F5441424C4F434B220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(71) := '2020202020202069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B5F4C4142454C220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(72) := '20202020202020636C6173733D22742D466F726D2D6C6162656C223E44656163746976617465203C610D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(73) := '20202020202020687265663D2268747470733A2F2F6269742E6C792F415045585461624C6F636B220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(74) := '2020202020207461726765743D225F626C616E6B223E5461626C6F636B3C2F613E2052657665616C65723C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(75) := '202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F';
wwv_flow_imp.g_varchar2_table(76) := '6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C';
wwv_flow_imp.g_varchar2_table(77) := '7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207479';
wwv_flow_imp.g_varchar2_table(78) := '70653D22636865636B626F78222069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(79) := '202020202020202020202020202020206E616D653D2252305F52455645414C45525F43524950504C455F5441424C4F434B222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(80) := '202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(81) := '20202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F66662220636865636B65643D22636865636B6564220D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(82) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(83) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(84) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020203C7370616E2069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B5F6572726F725F706C616365686F6C646572220D0A';
wwv_flow_imp.g_varchar2_table(85) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D2222';
wwv_flow_imp.g_varchar2_table(86) := '3E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(87) := '2020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(88) := '2020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(89) := '20202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(90) := '20202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D74657874';
wwv_flow_imp.g_varchar2_table(91) := '2D6669656C6420220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E455222';
wwv_flow_imp.g_varchar2_table(92) := '3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E';
wwv_flow_imp.g_varchar2_table(93) := '0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52455645414C45525F4B425F53484F5254435554220D0A20202020';
wwv_flow_imp.g_varchar2_table(94) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52455645414C45525F4B425F53484F52544355545F4C4142454C220D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(95) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E4B6579626F6172642053686F72746375740D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(96) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020204374726C2B416C742B2E2E2E3C2F6C6162656C3E0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(97) := '20202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D';
wwv_flow_imp.g_varchar2_table(98) := '466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D';
wwv_flow_imp.g_varchar2_table(99) := '22742D466F726D2D6974656D57726170706572223E3C696E70757420747970653D2274657874220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(100) := '202020202069643D2252305F52455645414C45525F4B425F53484F5254435554220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E';
wwv_flow_imp.g_varchar2_table(101) := '616D653D2252305F52455645414C45525F4B425F53484F5254435554220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C617373';
wwv_flow_imp.g_varchar2_table(102) := '3D22746578745F6669656C6420617065782D6974656D2D74657874222076616C75653D2251222073697A653D2231220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(103) := '202020202020202020202020206D61786C656E6774683D22312220646174612D6E702D636865636B65643D2231223E3C2F6469763E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(104) := '202020202020202020202020202020202020202069643D2252305F52455645414C45525F4B425F53484F52544355545F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(105) := '20202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(106) := '2020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020';
wwv_flow_imp.g_varchar2_table(107) := '20202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020';
wwv_flow_imp.g_varchar2_table(108) := '2020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(109) := '2020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(110) := '20202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D5265';
wwv_flow_imp.g_varchar2_table(111) := '67696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F6469';
wwv_flow_imp.g_varchar2_table(112) := '763E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C212D2D203C2F6469763E0D0A202020';
wwv_flow_imp.g_varchar2_table(113) := '202020202020202020202020203C64697620636C6173733D22726F77223E202D2D3E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A2020202020';
wwv_flow_imp.g_varchar2_table(114) := '202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67220D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(115) := '202020202020202020202069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E7352656C6F61644672616D65223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D52';
wwv_flow_imp.g_varchar2_table(116) := '6567696F6E2D686561646572223E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D';
wwv_flow_imp.g_varchar2_table(117) := '732D2D7469746C65223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49636F';
wwv_flow_imp.g_varchar2_table(118) := '6E20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(119) := '20202020202020202020202020202020202020203C683220636C6173733D22742D526567696F6E2D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E7352656C6F61644672616D655F68656164696E67223E0D';
wwv_flow_imp.g_varchar2_table(120) := '0A2020202020202020202020202020202020202020202020202020202020202020202020202020202052656C6F6164204672616D653C2F68323E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A';
wwv_flow_imp.g_varchar2_table(121) := '20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D627574746F6E73223E3C737061';
wwv_flow_imp.g_varchar2_table(122) := '6E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D226A732D6D6178696D697A65427574746F6E436F6E7461696E6572223E3C2F7370616E3E3C2F6469763E0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(123) := '2020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F647957726170223E0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(124) := '202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D746F70223E0D0A202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(125) := '2020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173';
wwv_flow_imp.g_varchar2_table(126) := '733D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(127) := '202020202020203C64697620636C6173733D22742D526567696F6E2D626F6479223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A202020';
wwv_flow_imp.g_varchar2_table(128) := '202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(129) := '3C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22';
wwv_flow_imp.g_varchar2_table(130) := '742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(131) := '202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F454E41424C455F434F4E5441494E4552223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(132) := '2020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(133) := '2020202020202020202020202020202020203C6C6162656C20666F723D2252305F52454C4F41445F454E41424C45222069643D2252305F52454C4F41445F454E41424C455F4C4142454C220D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(134) := '20202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E456E61626C653C2F6C6162656C3E0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(135) := '20202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D';
wwv_flow_imp.g_varchar2_table(136) := '466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D';
wwv_flow_imp.g_varchar2_table(137) := '22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(138) := '2020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F52454C4F41445F454E41424C45220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(139) := '2020202020202020202020202020202020202020202020202020206E616D653D2252305F52454C4F41445F454E41424C45222076616C75653D22592220646174612D6F6E2D6C6162656C3D224F6E220D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(140) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D76616C75653D224E2220646174612D6F66662D6C6162656C3D224F6666220D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(141) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(142) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A20';
wwv_flow_imp.g_varchar2_table(143) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C7370616E2069643D2252305F52454C4F41445F454E41424C455F6572726F725F706C616365686F6C64657222';
wwv_flow_imp.g_varchar2_table(144) := '0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D';
wwv_flow_imp.g_varchar2_table(145) := '22223E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(146) := '20202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(147) := '20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(148) := '202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(149) := '202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965';
wwv_flow_imp.g_varchar2_table(150) := '732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455222';
wwv_flow_imp.g_varchar2_table(151) := '207374796C653D22646973706C61793A6E6F6E65223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C';
wwv_flow_imp.g_varchar2_table(152) := '436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52454C4F4144';
wwv_flow_imp.g_varchar2_table(153) := '5F444556454C4F504552535F4F4E4C59220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F444556454C4F50';
wwv_flow_imp.g_varchar2_table(154) := '4552535F4F4E4C595F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E4465';
wwv_flow_imp.g_varchar2_table(155) := '76656C6F70657273204F6E6C793C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(156) := '20202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(157) := '20202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D';
wwv_flow_imp.g_varchar2_table(158) := '0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F52454C4F41445F44';
wwv_flow_imp.g_varchar2_table(159) := '4556454C4F504552535F4F4E4C59220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F52454C4F4144';
wwv_flow_imp.g_varchar2_table(160) := '5F444556454C4F504552535F4F4E4C59222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174';
wwv_flow_imp.g_varchar2_table(161) := '612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(162) := '20202020646174612D6F66662D6C6162656C3D224F66662220636865636B65643D22636865636B6564220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(163) := '202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(164) := '20202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(165) := '2020202020202020203C7370616E2069643D2252305F52454C4F41445F444556454C4F504552535F4F4E4C595F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(166) := '20202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(167) := '2020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(168) := '20202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(169) := '202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6469762063';
wwv_flow_imp.g_varchar2_table(170) := '6C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D';
wwv_flow_imp.g_varchar2_table(171) := '2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(172) := '202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(173) := '202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(174) := '202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52454C4F41445F4259504153535F554E4348414E474544220D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(175) := '202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4259504153535F554E4348414E4745445F4C4142454C220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(176) := '20202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E427970617373205761726E206F6E20556E6368616E6765640D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(177) := '20202020202020202020202020202020202020202020202020202020204368616E6765733C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F';
wwv_flow_imp.g_varchar2_table(178) := '6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D';
wwv_flow_imp.g_varchar2_table(179) := '34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E2063';
wwv_flow_imp.g_varchar2_table(180) := '6C6173733D22612D537769746368223E3C696E7075740D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D226368';
wwv_flow_imp.g_varchar2_table(181) := '65636B626F78222069643D2252305F52454C4F41445F4259504153535F554E4348414E474544220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(182) := '2020202020202020206E616D653D2252305F52454C4F41445F4259504153535F554E4348414E474544222076616C75653D2259220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(183) := '20202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(184) := '2020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F66662220636865636B65643D22636865636B6564220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(185) := '20202020202020202020202020202020202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(186) := '2020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(187) := '202020202020202020202020202020202020202020202020202020202020202020203C7370616E2069643D2252305F52454C4F41445F4259504153535F554E4348414E4745445F6572726F725F706C616365686F6C646572220D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(188) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D';
wwv_flow_imp.g_varchar2_table(189) := '0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(190) := '2020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(191) := '2020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(192) := '20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(193) := '20202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D746578742D6669656C6420220D';
wwv_flow_imp.g_varchar2_table(194) := '0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4B425F53484F52544355545F434F4E5441494E4552223E0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(195) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(196) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52454C4F41445F4B425F53484F5254435554220D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(197) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4B425F53484F52544355545F4C4142454C220D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(198) := '20202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E4B6579626F6172642053686F72746375740D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(199) := '202020202020202020202020202020202020202020202020202020202020202020202020204374726C2B416C742B2E2E2E3C2F6C6162656C3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(200) := '20202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461';
wwv_flow_imp.g_varchar2_table(201) := '696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D577261';
wwv_flow_imp.g_varchar2_table(202) := '70706572223E3C696E70757420747970653D2274657874220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C';
wwv_flow_imp.g_varchar2_table(203) := '4F41445F4B425F53484F525443555422206E616D653D2252305F52454C4F41445F4B425F53484F5254435554220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(204) := '2020202020202020202020636C6173733D22746578745F6669656C6420617065782D6974656D2D74657874222076616C75653D2252222073697A653D2231220D0A2020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(205) := '20202020202020202020202020202020202020202020202020202020206D61786C656E6774683D22312220646174612D6E702D636865636B65643D2231223E3C2F6469763E3C7370616E0D0A202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(206) := '20202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4B425F53484F52544355545F6572726F725F706C616365686F6C646572220D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(207) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(208) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(209) := '3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(210) := '3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020';
wwv_flow_imp.g_varchar2_table(211) := '20202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(212) := '202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64';
wwv_flow_imp.g_varchar2_table(213) := '697620636C6173733D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(214) := '202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F6469763E';
wwv_flow_imp.g_varchar2_table(215) := '0D0A0D0A0D0A202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620223E0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(216) := '20202020202020202020203C64697620636C6173733D22742D526567696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67220D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(217) := '20202069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E734275696C644F7074696F6E73486967686C69676874223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D2274';
wwv_flow_imp.g_varchar2_table(218) := '2D526567696F6E2D686561646572223E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974';
wwv_flow_imp.g_varchar2_table(219) := '656D732D2D7469746C65223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49';
wwv_flow_imp.g_varchar2_table(220) := '636F6E20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(221) := '202020202020202020202020202020202020202020203C683220636C6173733D22742D526567696F6E2D7469746C65220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202069643D22707265746975';
wwv_flow_imp.g_varchar2_table(222) := '73446576656C6F706572546F6F6C4F7074696F6E734275696C644F7074696F6E73486967686C696768745F68656164696E67223E4275696C64204F7074696F6E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(223) := '202020202020486967686C696768743C2F68323E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C6469762063';
wwv_flow_imp.g_varchar2_table(224) := '6C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D627574746F6E73223E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(225) := '2020202020636C6173733D226A732D6D6178696D697A65427574746F6E436F6E7461696E6572223E3C2F7370616E3E3C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(226) := '202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F647957726170223E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D5265';
wwv_flow_imp.g_varchar2_table(227) := '67696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D746F70223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F';
wwv_flow_imp.g_varchar2_table(228) := '6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A202020';
wwv_flow_imp.g_varchar2_table(229) := '20202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F6479223E0D0A2020';
wwv_flow_imp.g_varchar2_table(230) := '202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C';
wwv_flow_imp.g_varchar2_table(231) := '64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E';
wwv_flow_imp.g_varchar2_table(232) := '0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D697465';
wwv_flow_imp.g_varchar2_table(233) := '6D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4255';
wwv_flow_imp.g_varchar2_table(234) := '494C445F4F5054494F4E5F454E41424C455F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F72';
wwv_flow_imp.g_varchar2_table(235) := '6D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D225230';
wwv_flow_imp.g_varchar2_table(236) := '5F4255494C445F4F5054494F4E5F454E41424C45220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4255494C445F4F505449';
wwv_flow_imp.g_varchar2_table(237) := '4F4E5F454E41424C455F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E45';
wwv_flow_imp.g_varchar2_table(238) := '6E61626C653C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(239) := '2020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(240) := '2020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A20202020202020';
wwv_flow_imp.g_varchar2_table(241) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F4255494C445F4F5054494F4E5F454E41';
wwv_flow_imp.g_varchar2_table(242) := '424C45220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F4255494C445F4F5054494F4E5F454E4142';
wwv_flow_imp.g_varchar2_table(243) := '4C45222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E';
wwv_flow_imp.g_varchar2_table(244) := '2220646174612D6F66662D76616C75653D224E220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C';
wwv_flow_imp.g_varchar2_table(245) := '6162656C3D224F66662220646174612D6E702D636865636B65643D2231223E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(246) := '202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(247) := '20203C2F6469763E3C7370616E2069643D2252305F4255494C445F4F5054494F4E5F454E41424C455F6572726F725F706C616365686F6C646572220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(248) := '202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(249) := '20202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(250) := '202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(251) := '2020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C617373';
wwv_flow_imp.g_varchar2_table(252) := '3D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D666965';
wwv_flow_imp.g_varchar2_table(253) := '6C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D6E756D6265722D6669656C6420220D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(254) := '2020202020202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(255) := '202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(256) := '202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F4255494C445F4F5054494F4E5F4455524154494F4E220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(257) := '20202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(258) := '202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E466164652061667465722078205365636F6E64733C2F6C6162656C3E0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(259) := '2020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D';
wwv_flow_imp.g_varchar2_table(260) := '696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F';
wwv_flow_imp.g_varchar2_table(261) := '726D2D6974656D57726170706572223E3C696E70757420747970653D2274657874220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(262) := '69643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D';
wwv_flow_imp.g_varchar2_table(263) := '2252305F4255494C445F4F5054494F4E5F4455524154494F4E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D646573';
wwv_flow_imp.g_varchar2_table(264) := '63726962656462793D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F696E6C696E655F68656C70220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(265) := '20202020202020202020202020636C6173733D226E756D6265725F6669656C6420617065782D6974656D2D74657874222076616C75653D2236222073697A653D2232220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(266) := '2020202020202020202020202020202020202020202020202020202020202020206D61786C656E6774683D223222207374796C653D22746578742D616C69676E3A7269676874220D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(267) := '20202020202020202020202020202020202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C2F6469763E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(268) := '202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D696E6C696E6548656C70223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(269) := '20202020202020202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F696E6C696E655F68656C70223E300D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(270) := '202020202020202020202020202020202020202020202020202020202020202020202020746F206E657665722066616465206F75743C2F7370616E3E3C2F7370616E3E3C7370616E0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(271) := '2020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(272) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(273) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(274) := '203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(275) := '203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020';
wwv_flow_imp.g_varchar2_table(276) := '2020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(277) := '20202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C';
wwv_flow_imp.g_varchar2_table(278) := '64697620636C6173733D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(279) := '20202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C';
wwv_flow_imp.g_varchar2_table(280) := '212D2D203C2F6469763E202D2D3E0D0A0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(281) := '203C64697620636C6173733D22742D526567696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67220D0A2020202020202020202020202020202020202020202020202020202069643D22707265';
wwv_flow_imp.g_varchar2_table(282) := '74697573446576656C6F706572546F6F6C4F7074696F6E734F70656E4275696C646572223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D686561646572223E0D0A2020';
wwv_flow_imp.g_varchar2_table(283) := '2020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D7469746C65223E0D0A202020202020';
wwv_flow_imp.g_varchar2_table(284) := '2020202020202020202020202020202020202020202020202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49636F6E20220D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(285) := '20202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(286) := '20203C683220636C6173733D22742D526567696F6E2D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E734F70656E4275696C6465725F68656164696E67223E0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(287) := '2020202020202020202020202020202020202020202020446576656C6F7065722042617220456E68616E63656D656E74733C2F68323E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020';
wwv_flow_imp.g_varchar2_table(288) := '202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D627574746F6E73223E3C7370616E0D0A20';
wwv_flow_imp.g_varchar2_table(289) := '202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D226A732D6D6178696D697A65427574746F6E436F6E7461696E6572223E3C2F7370616E3E3C2F6469763E0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(290) := '20202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F647957726170223E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(291) := '2020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D746F70223E0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(292) := '20202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D2274';
wwv_flow_imp.g_varchar2_table(293) := '2D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(294) := '2020203C64697620636C6173733D22742D526567696F6E2D626F6479223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(295) := '2020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C646976';
wwv_flow_imp.g_varchar2_table(296) := '20636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F';
wwv_flow_imp.g_varchar2_table(297) := '726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(298) := '2020202020202020202020202020202020202020202020202069643D2252305F484F4D455F5245504C4143455F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(299) := '202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(300) := '202020202020202020202020203C6C6162656C20666F723D2252305F484F4D455F5245504C4143455F4C494E4B222069643D2252305F484F4D455F5245504C4143455F4C494E4B5F4C4142454C220D0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(301) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E3C7370616E20636C6173733D22612D49636F6E2069636F6E2D686F6D652220617269612D686964';
wwv_flow_imp.g_varchar2_table(302) := '64656E3D2274727565223E3C2F7370616E3E486F6D65206F70656E732053686172656420436F6D706F6E656E74733C2F6C6162656C3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(303) := '20202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E65';
wwv_flow_imp.g_varchar2_table(304) := '7220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D577261707065';
wwv_flow_imp.g_varchar2_table(305) := '72223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(306) := '2020747970653D22636865636B626F78222069643D2252305F484F4D455F5245504C4143455F4C494E4B220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(307) := '202020202020202020202020206E616D653D2252305F484F4D455F5245504C4143455F4C494E4B222076616C75653D2259220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(308) := '2020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(309) := '202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F66662220646174612D6E702D636865636B65643D2231223E3C7370616E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(310) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(311) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C7370616E2069643D2252305F484F4D455F5245504C4143455F4C494E4B5F6572726F725F706C616365686F6C646572220D0A20202020';
wwv_flow_imp.g_varchar2_table(312) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F73';
wwv_flow_imp.g_varchar2_table(313) := '70616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(314) := '20202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(315) := '20202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C68723E0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(316) := '20202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D63';
wwv_flow_imp.g_varchar2_table(317) := '6F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C';
wwv_flow_imp.g_varchar2_table(318) := '20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(319) := '69643D2252305F474C4F575F44454255475F49434F4E5F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22';
wwv_flow_imp.g_varchar2_table(320) := '742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F';
wwv_flow_imp.g_varchar2_table(321) := '723D2252305F474C4F575F44454255475F49434F4E222069643D2252305F474C4F575F44454255475F49434F4E5F4C4142454C220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(322) := '2020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E476C6F770D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(323) := '2044656275672049636F6E3C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(324) := '2020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(325) := '2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A20';
wwv_flow_imp.g_varchar2_table(326) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F474C4F575F4445425547';
wwv_flow_imp.g_varchar2_table(327) := '5F49434F4E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F474C4F575F44454255475F49434F4E';
wwv_flow_imp.g_varchar2_table(328) := '222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220';
wwv_flow_imp.g_varchar2_table(329) := '646174612D6F66662D76616C75653D224E220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162';
wwv_flow_imp.g_varchar2_table(330) := '656C3D224F66662220646174612D6E702D636865636B65643D2231223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(331) := '20202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(332) := '2020202020203C7370616E2069643D2252305F474C4F575F44454255475F49434F4E5F6572726F725F706C616365686F6C646572220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(333) := '202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(334) := '20202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(335) := '202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(336) := '2020202020202020202020202020202020202020203C68723E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(337) := '2020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(338) := '2020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D796573';
wwv_flow_imp.g_varchar2_table(339) := '2D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4F50454E5F4255494C4445525F454E41424C455F434F4E5441494E4552223E0D0A20';
wwv_flow_imp.g_varchar2_table(340) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A2020';
wwv_flow_imp.g_varchar2_table(341) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F4F50454E5F4255494C4445525F454E41424C45220D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(342) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4F50454E5F4255494C4445525F454E41424C455F4C4142454C2220636C6173733D22742D466F726D2D6C';
wwv_flow_imp.g_varchar2_table(343) := '6162656C223E53706F746C696768740D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020506167652044657369676E6572204163636573733C2F6C';
wwv_flow_imp.g_varchar2_table(344) := '6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(345) := '202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(346) := '202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(347) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F4F50454E5F4255494C4445525F454E41424C45220D0A2020';
wwv_flow_imp.g_varchar2_table(348) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F4F50454E5F4255494C4445525F454E41424C45222076616C75';
wwv_flow_imp.g_varchar2_table(349) := '653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F';
wwv_flow_imp.g_varchar2_table(350) := '66662D76616C75653D224E220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F66';
wwv_flow_imp.g_varchar2_table(351) := '662220646174612D6E702D636865636B65643D2231223E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C';
wwv_flow_imp.g_varchar2_table(352) := '6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(353) := '3C7370616E2069643D2252305F4F50454E5F4255494C4445525F454E41424C455F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(354) := '20202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(355) := '2020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(356) := '20202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(357) := '202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F';
wwv_flow_imp.g_varchar2_table(358) := '6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E746169';
wwv_flow_imp.g_varchar2_table(359) := '6E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(360) := '202020202020202020202069643D2252305F4F50454E5F4255494C4445525F43414348455F434F4E5441494E4552223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(361) := '20203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(362) := '20202020203C6C6162656C20666F723D2252305F4F50454E5F4255494C4445525F4341434845220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(363) := '2069643D2252305F4F50454E5F4255494C4445525F43414348455F4C4142454C2220636C6173733D22742D466F726D2D6C6162656C223E5573652043616368652028666F72206C6172676520776F726B737061636573293C2F6C6162656C3E0D0A202020';
wwv_flow_imp.g_varchar2_table(364) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(365) := '2020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(366) := '2020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(367) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F4F50454E5F4255494C4445525F4341434845220D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(368) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F4F50454E5F4255494C4445525F4341434845222076616C75653D2259220D0A2020202020';
wwv_flow_imp.g_varchar2_table(369) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E22';
wwv_flow_imp.g_varchar2_table(370) := '0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F66662220646174612D6E702D63';
wwv_flow_imp.g_varchar2_table(371) := '6865636B65643D2231223E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D5377697463';
wwv_flow_imp.g_varchar2_table(372) := '682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C7370616E2069643D225230';
wwv_flow_imp.g_varchar2_table(373) := '5F4F50454E5F4255494C4445525F43414348455F6572726F725F706C616365686F6C646572220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(374) := '636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(375) := '20203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(376) := '202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(377) := '2020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C';
wwv_flow_imp.g_varchar2_table(378) := '2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C2061';
wwv_flow_imp.g_varchar2_table(379) := '7065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206964';
wwv_flow_imp.g_varchar2_table(380) := '3D2252305F4F50454E5F4255494C4445525F4150505F4C494D49545F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C';
wwv_flow_imp.g_varchar2_table(381) := '6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162';
wwv_flow_imp.g_varchar2_table(382) := '656C20666F723D2252305F4F50454E5F4255494C4445525F4150505F4C494D4954220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D22';
wwv_flow_imp.g_varchar2_table(383) := '52305F4F50454E5F4255494C4445525F4150505F4C494D49545F4C4142454C2220636C6173733D22742D466F726D2D6C6162656C223E4C696D697420746F2043757272656E74204170702028666F7220506572666F726D616E6365293C2F6C6162656C3E';
wwv_flow_imp.g_varchar2_table(384) := '0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(385) := '20202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(386) := '20202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(387) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F4F50454E5F4255494C4445525F4150505F4C494D4954220D0A20202020';
wwv_flow_imp.g_varchar2_table(388) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F4F50454E5F4255494C4445525F4150505F4C494D4954222076616C';
wwv_flow_imp.g_varchar2_table(389) := '75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D';
wwv_flow_imp.g_varchar2_table(390) := '6F66662D76616C75653D224E220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F66662D6C6162656C3D224F';
wwv_flow_imp.g_varchar2_table(391) := '66662220646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202063';
wwv_flow_imp.g_varchar2_table(392) := '6C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(393) := '203C7370616E2069643D2252305F4F50454E5F4255494C4445525F4150505F4C494D49545F6572726F725F706C616365686F6C646572220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(394) := '2020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(395) := '202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(396) := '2020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(397) := '20202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F';
wwv_flow_imp.g_varchar2_table(398) := '6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F';
wwv_flow_imp.g_varchar2_table(399) := '6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D746578742D6669656C6420220D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(400) := '2020202020202020202020202020202020202069643D2252305F4F50454E5F4255494C4445525F4B425F53484F52544355545F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(401) := '202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(402) := '202020202020202020202020202020202020203C6C6162656C20666F723D2252305F4F50454E5F4255494C4445525F4B425F53484F5254435554220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(403) := '20202020202020202020202020202020202020202069643D2252305F524F50454E5F4255494C4445525F4B425F53484F52544355545F4C4142454C220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(404) := '20202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E4B6579626F6172642053686F72746375740D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(405) := '202020202020202020202020202020202020202020204374726C2B416C742B2E2E2E3C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469';
wwv_flow_imp.g_varchar2_table(406) := '763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D3422';
wwv_flow_imp.g_varchar2_table(407) := '3E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C696E707574207479';
wwv_flow_imp.g_varchar2_table(408) := '70653D2274657874220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4F50454E5F4255494C4445525F4B425F5348';
wwv_flow_imp.g_varchar2_table(409) := '4F5254435554220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F4F50454E5F4255494C4445525F4B425F5348';
wwv_flow_imp.g_varchar2_table(410) := '4F5254435554220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22746578745F6669656C6420617065782D6974656D';
wwv_flow_imp.g_varchar2_table(411) := '2D74657874222076616C75653D2257222073697A653D2231220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206D61786C656E677468';
wwv_flow_imp.g_varchar2_table(412) := '3D22312220646174612D6E702D636865636B65643D2231223E3C2F6469763E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206964';
wwv_flow_imp.g_varchar2_table(413) := '3D2252305F4F50454E5F4255494C4445525F4B425F53484F52544355545F696E6C696E655F68656C70223E3C2F7370616E3E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(414) := '202020202020202020202020202020202069643D2252305F4F50454E5F4255494C4445525F4B425F53484F52544355545F6572726F725F706C616365686F6C646572220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(415) := '2020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F722220646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(416) := '202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020';
wwv_flow_imp.g_varchar2_table(417) := '2020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020';
wwv_flow_imp.g_varchar2_table(418) := '202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(419) := '202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(420) := '2020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D52';
wwv_flow_imp.g_varchar2_table(421) := '6567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F64';
wwv_flow_imp.g_varchar2_table(422) := '69763E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F6469763E0D0A0D0A0D0A0D0A0D0A202020';
wwv_flow_imp.g_varchar2_table(423) := '202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(424) := '202020202020202020202020202020203C6469762069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E73427574746F6E73223E0D0A202020202020202020202020202020202020202020202020202020203C7461626C6520726F';
wwv_flow_imp.g_varchar2_table(425) := '6C653D2270726573656E746174696F6E222063656C6C73706163696E673D2230222063656C6C70616464696E673D22302220626F726465723D2230222077696474683D2231303025223E0D0A202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(426) := '20202020202020203C74626F64793E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C74723E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C';
wwv_flow_imp.g_varchar2_table(427) := '746420616C69676E3D226C656674223E3C627574746F6E20636C6173733D22742D427574746F6E207064742D6F7074696F6E2D627574746F6E2220747970653D22627574746F6E220D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(428) := '2020202020202020202020202020202020202020202069643D2252305F43414E43454C223E3C7370616E20636C6173733D22742D427574746F6E2D6C6162656C223E43616E63656C3C2F7370616E3E3C2F627574746F6E3E0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(429) := '2020202020202020202020202020202020202020202020202020202020203C2F74643E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C746420616C69676E3D227269676874223E3C62757474';
wwv_flow_imp.g_varchar2_table(430) := '6F6E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D427574746F6E207064742D6F7074696F6E2D627574746F6E20742D427574746F6E2D2D69636F6E';
wwv_flow_imp.g_varchar2_table(431) := '20742D427574746F6E2D2D69636F6E526967687420742D427574746F6E2D2D686F7420752D70756C6C5269676874220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970';
wwv_flow_imp.g_varchar2_table(432) := '653D22627574746F6E222069643D2252305F53415645223E3C7370616E20636C6173733D22742D49636F6E20742D49636F6E2D2D6C6566742066612066612D73617665220D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(433) := '20202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(434) := '20202020202020636C6173733D22742D427574746F6E2D6C6162656C223E536176653C2F7370616E3E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(435) := '636C6173733D22742D49636F6E20742D49636F6E2D2D72696768742066612066612D73617665220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D6869';
wwv_flow_imp.g_varchar2_table(436) := '6464656E3D2274727565223E3C2F7370616E3E3C2F627574746F6E3E3C2F74643E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C2F74723E0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(437) := '202020202020202020203C2F74626F64793E0D0A202020202020202020202020202020202020202020202020202020203C2F7461626C653E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(438) := '202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020203C2F6469763E0D0A20202020202020203C2F6469763E0D0A202020203C2F6469763E0D0A3C2F6469763E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219972534145840774)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'pretiusDeveloperTool.html'
,p_mime_type=>'text/html'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A0D0A2A20506C7567696E3A202020507265746975732052656C6F6164204672616D650D0A2A2056657273696F6E3A2020312E302E300D0A2A0D0A2A204C6963656E73653A20204D4954204C6963656E736520436F7079726967687420323032322050';
wwv_flow_imp.g_varchar2_table(2) := '7265746975732053702E207A206F2E6F2E2053702E204B2E0D0A2A20486F6D65706167653A200D0A2A204D61696C3A2020202020617065782D706C7567696E7340707265746975732E636F6D0D0A2A204973737565733A20202068747470733A2F2F6769';
wwv_flow_imp.g_varchar2_table(3) := '746875622E636F6D2F507265746975732F72656C6F61642D6672616D652F6973737565730D0A2A0D0A2A20417574686F723A2020204D617474204D756C76616E65790D0A2A204D61696C3A20202020206D6D756C76616E657940707265746975732E636F';
wwv_flow_imp.g_varchar2_table(4) := '6D0D0A2A20547769747465723A20204D6174745F4D756C76616E65790D0A2A0D0A2A2F0D0A0D0A76617220706474203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A202020207661722064613B0D0A20';
wwv_flow_imp.g_varchar2_table(5) := '202020766172206F70743B0D0A20202020766172204A534F4E73657474696E67733B0D0A20202020766172207061676544656275674C6576656C3B0D0A0D0A2020202066756E6374696F6E206E766C2876616C7565312C2076616C75653229207B0D0A20';
wwv_flow_imp.g_varchar2_table(6) := '202020202020206966202876616C756531203D3D206E756C6C207C7C2076616C756531203D3D202222290D0A20202020202020202020202072657475726E2076616C7565323B0D0A202020202020202072657475726E2076616C7565313B0D0A20202020';
wwv_flow_imp.g_varchar2_table(7) := '7D3B0D0A0D0A2020202066756E6374696F6E2067657453657474696E6728705061746829207B0D0A20202020202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F34353332323130310D0A202020202020202066756E';
wwv_flow_imp.g_varchar2_table(8) := '6374696F6E207265736F6C766528706174682C206F626A29207B0D0A20202020202020202020202072657475726E20706174682E73706C697428272E27292E7265647563652866756E6374696F6E2028707265762C206375727229207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(9) := '202020202020202020202072657475726E2070726576203F20707265765B637572725D203A206E756C6C0D0A2020202020202020202020207D2C206F626A207C7C2073656C66290D0A20202020202020207D0D0A0D0A202020202020202072657475726E';
wwv_flow_imp.g_varchar2_table(10) := '207265736F6C7665282773657474696E67732E27202B2070506174682C0D0A2020202020202020202020207064742E4A534F4E73657474696E6773293B0D0A202020207D0D0A0D0A0D0A2020202066756E6374696F6E20666978546F6F6C626172576964';
wwv_flow_imp.g_varchar2_table(11) := '74682829207B0D0A0D0A202020202020202066756E6374696F6E2067657457696E646F7757696474682829207B0D0A20202020202020202020202072657475726E20646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E74576964';
wwv_flow_imp.g_varchar2_table(12) := '74683B0D0A20202020202020207D0D0A0D0A2020202020202020766172206F2C20746257696474682C2077696E646F7757696474682C0D0A20202020202020202020202064746224203D202428222361706578446576546F6F6C62617222292C0D0A2020';
wwv_flow_imp.g_varchar2_table(13) := '20202020202020202020646972656374696F6E203D20647462242E6373732822646972656374696F6E2229203D3D3D202272746C22203F2022726967687422203A20226C656674223B202F2F207768656E20696E2052544C206D6F64652C20746865206C';
wwv_flow_imp.g_varchar2_table(14) := '656674204353532070726F70657274790D0A0D0A20202020202020206F203D207B0D0A20202020202020202020202077696474683A2022220D0A20202020202020207D3B0D0A202020202020202069662028647462242E686173436C6173732822612D44';
wwv_flow_imp.g_varchar2_table(15) := '6576546F6F6C6261722D2D746F702229207C7C20647462242E686173436C6173732822612D446576546F6F6C6261722D2D626F74746F6D222929207B0D0A20202020202020202020202077696E646F775769647468203D2067657457696E646F77576964';
wwv_flow_imp.g_varchar2_table(16) := '746828293B0D0A2020202020202020202020206F2E77686974655370616365203D20226E6F77726170223B20202F2F20636C65617220656C656D656E7420776964746820746F206765742064657369726564207769647468206F6620756C20636F6E7465';
wwv_flow_imp.g_varchar2_table(17) := '6E740D0A202020202020202020202020647462242E637373286F293B0D0A2020202020202020202020202F2F207573696E6720776964746820617373756D696E67206E6F206D617267696E206574632E0D0A202020202020202020202020746257696474';
wwv_flow_imp.g_varchar2_table(18) := '68203D20647462242E6368696C6472656E2822756C22295B305D2E636C69656E745769647468202B20343B202F2F2049452077616E7473206A7573742061206C6974746C6520657874726120746F206B6565702074686520627574746F6E732066726F6D';
wwv_flow_imp.g_varchar2_table(19) := '207772617070696E670D0A2020202020202020202020206966202874625769647468203E2077696E646F77576964746829207B0D0A2020202020202020202020202020202074625769647468203D2077696E646F7757696474683B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(20) := '20202020207D0D0A2020202020202020202020206F2E77686974655370616365203D202277726170223B0D0A2020202020202020202020206F2E7769647468203D20746257696474683B0D0A2020202020202020202020206F5B646972656374696F6E5D';
wwv_flow_imp.g_varchar2_table(21) := '203D202877696E646F775769647468202D207462576964746829202F20323B202F2F20706F736974696F6E20746865206F666673657420696E207468652063656E7465722E0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(22) := '206F5B646972656374696F6E5D203D2022223B202F2F20636C65617220746865206F666673657420616E642077696474680D0A20202020202020207D0D0A2020202020202020647462242E637373286F293B0D0A202020207D0D0A0D0A2020202066756E';
wwv_flow_imp.g_varchar2_table(23) := '6374696F6E20616464507265746975734F7074696F6E732829207B0D0A0D0A202020202020202076617220634973546F6F6C62617250726573656E74203D202428222361706578446576546F6F6C62617222292E6C656E677468203E20303B0D0A202020';
wwv_flow_imp.g_varchar2_table(24) := '202020202069662028634973546F6F6C62617250726573656E7429207B0D0A0D0A202020202020202020202020696620282428272361706578446576546F6F6C6261724F7074696F6E7327292E6C656E677468203E203020262620242827236170657844';
wwv_flow_imp.g_varchar2_table(25) := '6576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7327292E6C656E677468203D3D203029207B0D0A0D0A202020202020202020202020202020207661722072657665616C657249636F6E48746D6C203D20273C7370';
wwv_flow_imp.g_varchar2_table(26) := '616E20636C6173733D22612D49636F6E2066612066612D66696C7465722066616D2D782066616D2D69732D64616E6765722220617269612D68696464656E3D2274727565223E3C2F7370616E3E270D0A0D0A202020202020202020202020202020206966';
wwv_flow_imp.g_varchar2_table(27) := '20287064742E6F70742E636F6E66696775726174696F6E54657374203D3D2022747275652229207B0D0A202020202020202020202020202020202020202072657665616C657249636F6E48746D6C203D2072657665616C657249636F6E48746D6C2E7265';
wwv_flow_imp.g_varchar2_table(28) := '706C616365282766616D2D782066616D2D69732D64616E676572272C202727293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202428272361706578446576546F6F6C6261724F7074696F6E7327292E';
wwv_flow_imp.g_varchar2_table(29) := '706172656E7428292E6166746572280D0A2020202020202020202020202020202020202020617065782E6C616E672E666F726D61744E6F457363617065280D0A202020202020202020202020202020202020202020202020273C6C693E3C627574746F6E';
wwv_flow_imp.g_varchar2_table(30) := '2069643D2261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E732220747970653D22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C6261722220';
wwv_flow_imp.g_varchar2_table(31) := '7469746C653D2256696577205061676520496E666F726D6174696F6E205B6374726C2B616C742B25305D2220617269612D6C6162656C3D22566172732220646174612D6C696E6B3D22223E2027202B0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(32) := '20202020202725312027202B0D0A202020202020202020202020202020202020202020202020273C2F627574746F6E3E3C2F6C693E272C0D0A202020202020202020202020202020202020202020202020275072657469757320446576656C6F70657220';
wwv_flow_imp.g_varchar2_table(33) := '546F6F6C204F7074696F6E73272C0D0A20202020202020202020202020202020202020202020202072657665616C657249636F6E48746D6C0D0A2020202020202020202020202020202020202020290D0A20202020202020202020202020202020293B0D';
wwv_flow_imp.g_varchar2_table(34) := '0A0D0A202020202020202020202020202020207661722068203D20646F63756D656E742E676574456C656D656E7442794964282261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7322293B0D0A2020';
wwv_flow_imp.g_varchar2_table(35) := '2020202020202020202020202020696620286829207B0D0A2020202020202020202020202020202020202020682E6164644576656E744C697374656E65722822636C69636B222C2066756E6374696F6E20286576656E7429207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(36) := '2020202020202020202020202020202061706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7328293B0D0A0D0A20202020202020202020202020202020202020207D2C2074727565293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(37) := '20202020202020202020207D0D0A0D0A202020202020202020202020202020207472616E73706C616E74496E6C696E654469616C6F6728293B0D0A0D0A20202020202020202020202020202020666978546F6F6C626172576964746828293B0D0A202020';
wwv_flow_imp.g_varchar2_table(38) := '202020202020202020202020202F2F20437573746F6D204150455820352E30207769647468206669780D0A202020202020202020202020202020202428272361706578446576546F6F6C62617227292E7769647468282428272E612D446576546F6F6C62';
wwv_flow_imp.g_varchar2_table(39) := '61722D6C69737427292E77696474682829202B2027707827293B0D0A0D0A2020202020202020202020202020202066756E6374696F6E207064744F7074696F6E73536176652829207B0D0A2020202020202020202020202020202020202020766172204A';
wwv_flow_imp.g_varchar2_table(40) := '736F6E53657474696E6773203D207B0D0A2020202020202020202020202020202020202020202020202273657474696E6773223A207B0D0A20202020202020202020202020202020202020202020202020202020226F70746F7574223A207B0D0A202020';
wwv_flow_imp.g_varchar2_table(41) := '202020202020202020202020202020202020202020202020202020202022737461747573223A20617065782E6974656D282252305F4F50545F4F555422292E67657456616C756528290D0A20202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(42) := '2020207D2C0D0A202020202020202020202020202020202020202020202020202020202272657665616C6572223A207B0D0A202020202020202020202020202020202020202020202020202020202020202022656E61626C65223A20617065782E697465';
wwv_flow_imp.g_varchar2_table(43) := '6D282252305F52455645414C45525F454E41424C4522292E67657456616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020227461626C6F636B64656163746976617465223A20617065782E6974656D28';
wwv_flow_imp.g_varchar2_table(44) := '2252305F52455645414C45525F43524950504C455F5441424C4F434B22292E67657456616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020226B62223A20617065782E6974656D282252305F52455645';
wwv_flow_imp.g_varchar2_table(45) := '414C45525F4B425F53484F525443555422292E67657456616C756528290D0A202020202020202020202020202020202020202020202020202020207D2C0D0A202020202020202020202020202020202020202020202020202020202272656C6F61646672';
wwv_flow_imp.g_varchar2_table(46) := '616D65223A207B0D0A202020202020202020202020202020202020202020202020202020202020202022656E61626C65223A20617065782E6974656D282252305F52454C4F41445F454E41424C4522292E67657456616C756528292C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(47) := '202020202020202020202020202020202020202020202020202022646576656C6F706572736F6E6C79223A20617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C5922292E67657456616C756528292C0D0A20202020';
wwv_flow_imp.g_varchar2_table(48) := '20202020202020202020202020202020202020202020202020202020226279706173737761726E6F6E756E7361766564223A20617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E47454422292E67657456616C756528';
wwv_flow_imp.g_varchar2_table(49) := '292C0D0A2020202020202020202020202020202020202020202020202020202020202020226B62223A20617065782E6974656D282252305F52454C4F41445F4B425F53484F525443555422292E67657456616C756528290D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(50) := '20202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020202C0D0A20202020202020202020202020202020202020202020202020202020226275696C646F7074696F6E68696768746C696768';
wwv_flow_imp.g_varchar2_table(51) := '74223A207B0D0A202020202020202020202020202020202020202020202020202020202020202022656E61626C65223A20617065782E6974656D282252305F4255494C445F4F5054494F4E5F454E41424C4522292E67657456616C756528292C0D0A2020';
wwv_flow_imp.g_varchar2_table(52) := '202020202020202020202020202020202020202020202020202020202020226475726174696F6E223A20617065782E6974656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E22292E67657456616C756528290D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(53) := '20202020202020202020202020202020202020207D2C0D0A2020202020202020202020202020202020202020202020202020202022646576626172223A207B0D0A202020202020202020202020202020202020202020202020202020202020202022676C';
wwv_flow_imp.g_varchar2_table(54) := '6F776465627567656E61626C65223A20617065782E6974656D282252305F474C4F575F44454255475F49434F4E22292E67657456616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020226F70656E6275';
wwv_flow_imp.g_varchar2_table(55) := '696C646572656E61626C65223A20617065782E6974656D282252305F4F50454E5F4255494C4445525F454E41424C4522292E67657456616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020226F70656E';
wwv_flow_imp.g_varchar2_table(56) := '6275696C6465726361636865223A20617065782E6974656D282252305F4F50454E5F4255494C4445525F434143484522292E67657456616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020226F70656E';
wwv_flow_imp.g_varchar2_table(57) := '6275696C6465726170706C696D6974223A20617065782E6974656D282252305F4F50454E5F4255494C4445525F4150505F4C494D495422292E67657456616C756528292C0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(58) := '2020226F70656E6275696C6465726B62223A20617065782E6974656D282252305F4F50454E5F4255494C4445525F4B425F53484F525443555422292E67657456616C756528292C0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(59) := '202020202022686F6D657265706C6163656C696E6B223A20617065782E6974656D282252305F484F4D455F5245504C4143455F4C494E4B22292E67657456616C756528290D0A202020202020202020202020202020202020202020202020202020207D0D';
wwv_flow_imp.g_varchar2_table(60) := '0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D3B0D0A0D0A20202020202020202020202020202020202020206C6F63616C53746F726167652E7365744974656D282270726574';
wwv_flow_imp.g_varchar2_table(61) := '697573446576656C6F706572546F6F6C222C204A534F4E2E737472696E67696679284A736F6E53657474696E677329293B0D0A20202020202020202020202020202020202020207064742E4A534F4E73657474696E6773203D204A736F6E53657474696E';
wwv_flow_imp.g_varchar2_table(62) := '67733B0D0A2020202020202020202020202020202020202020617065782E7468656D652E636C6F7365526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A202020202020202020202020202020202020202061';
wwv_flow_imp.g_varchar2_table(63) := '7065782E6D6573736167652E73686F775061676553756363657373282253657474696E67732073617665642E205265667265736820796F75722062726F777365722E22293B0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(64) := '2020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C20222E6F70744F75744C696E6B222C2066756E6374696F6E202829207B0D0A20202020202020202020202020202020202020206170';
wwv_flow_imp.g_varchar2_table(65) := '65782E6D6573736167652E636F6E6669726D28224279204F7074696E672D4F7574206F66205072657469757320446576656C6F70657220546F6F6C2C20796F752077696C6C206E6F206C6F6E6720686176652061636365737320746F2074686520706C75';
wwv_flow_imp.g_varchar2_table(66) := '672D696E206665617475726573206F7220746869732073657474696E677320706167652E5C6E5C6E596F752063616E2072656761696E2061636365737320627920747970696E672074686520666F6C6C6F77696E6720696E20746F207468652042726F77';
wwv_flow_imp.g_varchar2_table(67) := '73657220436F6E736F6C65205C6E5C6E7064742E6F7074496E28293B5C6E5C6E596F752063616E2066696E64207468697320636F6D6D616E6420616761696E206F6E206F75722047697448756220506C7567696E20506167655C6E5C6E41726520796F75';
wwv_flow_imp.g_varchar2_table(68) := '207375726520796F75207769736820746F20636F6E74696E75653F222C2066756E6374696F6E20286F6B5072657373656429207B0D0A202020202020202020202020202020202020202020202020696620286F6B5072657373656429207B0D0A20202020';
wwv_flow_imp.g_varchar2_table(69) := '202020202020202020202020202020202020202020202020617065782E6974656D282252305F4F50545F4F555422292E73657456616C756528225922293B0D0A202020202020202020202020202020202020202020202020202020207064744F7074696F';
wwv_flow_imp.g_varchar2_table(70) := '6E735361766528293B0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(71) := '2020242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C20222E7064742D656E61626C652D616C6C222C2066756E6374696F6E202829207B0D0A202020202020202020202020202020202020202061706578';
wwv_flow_imp.g_varchar2_table(72) := '2E6974656D282752305F52455645414C45525F454E41424C4527292E73657456616C756528275927293B0D0A2020202020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F454E41424C4527292E73657456616C';
wwv_flow_imp.g_varchar2_table(73) := '756528275927293B0D0A2020202020202020202020202020202020202020617065782E6974656D282752305F4255494C445F4F5054494F4E5F454E41424C4527292E73657456616C756528275927293B0D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(74) := '2020617065782E6974656D282752305F4F50454E5F4255494C4445525F454E41424C4527292E73657456616C756528275927293B0D0A2020202020202020202020202020202020202020617065782E6974656D282752305F474C4F575F44454255475F49';
wwv_flow_imp.g_varchar2_table(75) := '434F4E27292E73657456616C756528275927293B0D0A2020202020202020202020202020202020202020617065782E6974656D282752305F484F4D455F5245504C4143455F4C494E4B27292E73657456616C756528275927293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(76) := '20202020202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C20222352305F53415645222C2066756E6374696F6E202829207B0D0A2020';
wwv_flow_imp.g_varchar2_table(77) := '2020202020202020202020202020202020207064744F7074696F6E735361766528293B0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E';
wwv_flow_imp.g_varchar2_table(78) := '6522292E6F6E2822636C69636B222C20222352305F43414E43454C222C2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020202020617065782E7468656D652E636C6F7365526567696F6E28242827237072657469757352';
wwv_flow_imp.g_varchar2_table(79) := '657665616C6572496E6C696E652729293B0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C2022';
wwv_flow_imp.g_varchar2_table(80) := '2352305F52455645414C45525F454E41424C45222C2066756E6374696F6E202829207B0D0A0D0A2020202020202020202020202020202020202020696620286E766C28617065782E6974656D282752305F52455645414C45525F454E41424C4527292E67';
wwv_flow_imp.g_varchar2_table(81) := '657456616C756528292C20274E2729203D3D20274E2729207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E455227';
wwv_flow_imp.g_varchar2_table(82) := '292E64697361626C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E455227292E64697361626C6528293B0D0A202020';
wwv_flow_imp.g_varchar2_table(83) := '20202020202020202020202020202020207D20656C7365207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E455227';
wwv_flow_imp.g_varchar2_table(84) := '292E656E61626C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E455227292E656E61626C6528293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(85) := '2020202020202020202020202020207D0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C202223';
wwv_flow_imp.g_varchar2_table(86) := '52305F52454C4F41445F454E41424C45222C2066756E6374696F6E202829207B0D0A0D0A2020202020202020202020202020202020202020696620286E766C28617065782E6974656D282752305F52454C4F41445F454E41424C4527292E67657456616C';
wwv_flow_imp.g_varchar2_table(87) := '756528292C20274E2729203D3D20274E2729207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455227292E6469736162';
wwv_flow_imp.g_varchar2_table(88) := '6C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(89) := '2020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F4B425F53484F52544355545F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020207D20656C7365';
wwv_flow_imp.g_varchar2_table(90) := '207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455227292E656E61626C6528293B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(91) := '202020202020202020202020617065782E6974656D282752305F52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E455227292E656E61626C6528293B0D0A202020202020202020202020202020202020202020202020617065';
wwv_flow_imp.g_varchar2_table(92) := '782E6974656D282752305F52454C4F41445F4B425F53484F52544355545F434F4E5441494E455227292E656E61626C6528293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D293B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(93) := '202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C20222352305F4255494C445F4F5054494F4E5F454E41424C45222C2066756E6374696F6E202829207B0D0A0D0A';
wwv_flow_imp.g_varchar2_table(94) := '2020202020202020202020202020202020202020696620286E766C28617065782E6974656D282752305F4255494C445F4F5054494F4E5F454E41424C4527292E67657456616C756528292C20274E2729203D3D20274E2729207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(95) := '20202020202020202020202020202020617065782E6974656D282752305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020207D20656C';
wwv_flow_imp.g_varchar2_table(96) := '7365207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E455227292E656E61626C6528293B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(97) := '2020202020202020207D0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C20222352305F4F5045';
wwv_flow_imp.g_varchar2_table(98) := '4E5F4255494C4445525F454E41424C45222C2066756E6374696F6E202829207B0D0A0D0A2020202020202020202020202020202020202020696620286E766C28617065782E6974656D282752305F4F50454E5F4255494C4445525F454E41424C4527292E';
wwv_flow_imp.g_varchar2_table(99) := '67657456616C756528292C20274E2729203D3D20274E2729207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F4F50454E5F4255494C4445525F4B425F53484F52544355545F434F4E5441494E4552';
wwv_flow_imp.g_varchar2_table(100) := '27292E64697361626C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F4F50454E5F4255494C4445525F43414348455F434F4E5441494E455227292E64697361626C6528293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(101) := '2020202020202020202020202020202020202020617065782E6974656D282752305F4F50454E5F4255494C4445525F4150505F4C494D49545F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(102) := '207D20656C7365207B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F4F50454E5F4255494C4445525F4B425F53484F52544355545F434F4E5441494E455227292E656E61626C6528293B0D0A202020';
wwv_flow_imp.g_varchar2_table(103) := '202020202020202020202020202020202020202020617065782E6974656D282752305F4F50454E5F4255494C4445525F43414348455F434F4E5441494E455227292E656E61626C6528293B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(104) := '20617065782E6974656D282752305F4F50454E5F4255494C4445525F4150505F4C494D49545F434F4E5441494E455227292E656E61626C6528293B0D0A20202020202020202020202020202020202020207D0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(105) := '7D293B0D0A0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202066756E6374696F6E206F7074696F6E734A532829207B0D0A0D0A2020202020202020617065782E7769646765742E7965734E6F282252';
wwv_flow_imp.g_varchar2_table(106) := '305F52455645414C45525F454E41424C45222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F52455645414C45525F43524950504C455F5441424C4F434B222C20225357495443485F';
wwv_flow_imp.g_varchar2_table(107) := '434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F52454C4F41445F454E41424C45222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F5245';
wwv_flow_imp.g_varchar2_table(108) := '4C4F41445F444556454C4F504552535F4F4E4C59222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F52454C4F41445F4259504153535F554E4348414E474544222C20225357495443';
wwv_flow_imp.g_varchar2_table(109) := '485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F4255494C445F4F5054494F4E5F454E41424C45222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E';
wwv_flow_imp.g_varchar2_table(110) := '6F282252305F4F50454E5F4255494C4445525F454E41424C45222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F474C4F575F44454255475F49434F4E222C20225357495443485F43';
wwv_flow_imp.g_varchar2_table(111) := '4222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F4F50454E5F4255494C4445525F4341434845222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252';
wwv_flow_imp.g_varchar2_table(112) := '305F4F50454E5F4255494C4445525F4150505F4C494D4954222C20225357495443485F434222293B0D0A2020202020202020617065782E7769646765742E7965734E6F282252305F484F4D455F5245504C4143455F4C494E4B222C20225357495443485F';
wwv_flow_imp.g_varchar2_table(113) := '434222293B0D0A0D0A20202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E742D427574746F6E526567696F6E2D636F6C2D2D7269676874202E742D427574746F6E526567696F6E2D627574746F6E';
wwv_flow_imp.g_varchar2_table(114) := '7327292E656D70747928293B0D0A20202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E742D427574746F6E526567696F6E2D636F6C2D2D6C656674202E742D427574746F6E526567696F6E2D6275';
wwv_flow_imp.g_varchar2_table(115) := '74746F6E7327292E656D70747928293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202352305F5341564527292E617070656E64546F282428272E742D427574746F6E526567696F6E2D636F6C2D2D72696768';
wwv_flow_imp.g_varchar2_table(116) := '74202E742D427574746F6E526567696F6E2D627574746F6E732729293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202352305F43414E43454C27292E617070656E64546F282428272E742D427574746F6E52';
wwv_flow_imp.g_varchar2_table(117) := '6567696F6E2D636F6C2D2D6C656674202E742D427574746F6E526567696F6E2D627574746F6E732729293B0D0A20202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F702023707265746975735265766561';
wwv_flow_imp.g_varchar2_table(118) := '6C6572427574746F6E526567696F6E27292E73686F7728293B0D0A0D0A2020202020202020766172204A534F4E73657474696E6773203D207064742E4A534F4E73657474696E67733B0D0A0D0A20202020202020206966202821242E6973456D7074794F';
wwv_flow_imp.g_varchar2_table(119) := '626A656374284A534F4E73657474696E67732929207B0D0A202020202020202020202020617065782E6974656D282252305F52455645414C45525F454E41424C4522292E73657456616C7565287064742E67657453657474696E67282772657665616C65';
wwv_flow_imp.g_varchar2_table(120) := '722E656E61626C652729293B0D0A202020202020202020202020617065782E6974656D282252305F52455645414C45525F43524950504C455F5441424C4F434B22292E73657456616C7565287064742E6E766C287064742E67657453657474696E672827';
wwv_flow_imp.g_varchar2_table(121) := '72657665616C65722E7461626C6F636B6465616374697661746527292C2027592729293B0D0A202020202020202020202020617065782E6974656D282252305F52455645414C45525F4B425F53484F525443555422292E73657456616C7565287064742E';
wwv_flow_imp.g_varchar2_table(122) := '6E766C287064742E67657453657474696E67282772657665616C65722E6B6227292C2027512729293B0D0A0D0A202020202020202020202020617065782E6974656D282252305F52454C4F41445F454E41424C4522292E73657456616C7565287064742E';
wwv_flow_imp.g_varchar2_table(123) := '67657453657474696E67282772656C6F61646672616D652E656E61626C652729293B0D0A202020202020202020202020617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C5922292E73657456616C7565287064742E';
wwv_flow_imp.g_varchar2_table(124) := '67657453657474696E67282772656C6F61646672616D652E6279706173737761726E6F6E756E73617665642729293B0D0A202020202020202020202020617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E4745442229';
wwv_flow_imp.g_varchar2_table(125) := '2E73657456616C7565287064742E6E766C287064742E67657453657474696E67282772656C6F61646672616D652E6279706173737761726E6F6E756E736176656427292C2027592729293B0D0A202020202020202020202020617065782E6974656D2822';
wwv_flow_imp.g_varchar2_table(126) := '52305F52454C4F41445F4B425F53484F525443555422292E73657456616C7565287064742E6E766C287064742E67657453657474696E67282772656C6F61646672616D652E6B6227292C2027522729293B0D0A0D0A202020202020202020202020617065';
wwv_flow_imp.g_varchar2_table(127) := '782E6974656D282252305F4255494C445F4F5054494F4E5F454E41424C4522292E73657456616C7565287064742E67657453657474696E6728276275696C646F7074696F6E68696768746C696768742E656E61626C652729293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(128) := '20202020617065782E6974656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E22292E73657456616C7565287064742E6E766C287064742E67657453657474696E6728276275696C646F7074696F6E68696768746C696768742E647572';
wwv_flow_imp.g_varchar2_table(129) := '6174696F6E27292C2027362729293B0D0A0D0A202020202020202020202020617065782E6974656D282252305F4F50454E5F4255494C4445525F454E41424C4522292E73657456616C7565287064742E67657453657474696E6728276465766261722E6F';
wwv_flow_imp.g_varchar2_table(130) := '70656E6275696C646572656E61626C652729293B0D0A202020202020202020202020617065782E6974656D282252305F4F50454E5F4255494C4445525F434143484522292E73657456616C7565287064742E67657453657474696E672827646576626172';
wwv_flow_imp.g_varchar2_table(131) := '2E6F70656E6275696C64657263616368652729293B0D0A202020202020202020202020617065782E6974656D282252305F4F50454E5F4255494C4445525F4150505F4C494D495422292E73657456616C7565287064742E67657453657474696E67282764';
wwv_flow_imp.g_varchar2_table(132) := '65766261722E6F70656E6275696C6465726170706C696D69742729293B0D0A202020202020202020202020617065782E6974656D282252305F4F50454E5F4255494C4445525F4B425F53484F525443555422292E73657456616C7565287064742E6E766C';
wwv_flow_imp.g_varchar2_table(133) := '287064742E67657453657474696E6728276465766261722E6F70656E6275696C6465726B6227292C2027572729293B0D0A202020202020202020202020617065782E6974656D282252305F474C4F575F44454255475F49434F4E22292E73657456616C75';
wwv_flow_imp.g_varchar2_table(134) := '65287064742E67657453657474696E6728276465766261722E676C6F776465627567656E61626C652729293B0D0A202020202020202020202020617065782E6974656D282252305F484F4D455F5245504C4143455F4C494E4B22292E73657456616C7565';
wwv_flow_imp.g_varchar2_table(135) := '287064742E67657453657474696E6728276465766261722E686F6D657265706C6163656C696E6B2729293B0D0A0D0A20202020202020207D0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202352305F5245';
wwv_flow_imp.g_varchar2_table(136) := '5645414C45525F454E41424C4522292E7472696767657228226368616E676522293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202352305F52454C4F41445F454E41424C4522292E74726967676572282263';
wwv_flow_imp.g_varchar2_table(137) := '68616E676522293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202352305F4255494C445F4F5054494F4E5F454E41424C4522292E7472696767657228226368616E676522293B0D0A20202020202020202428';
wwv_flow_imp.g_varchar2_table(138) := '22237072657469757352657665616C6572496E6C696E65202352305F4F50454E5F4255494C4445525F454E41424C4522292E7472696767657228226368616E676522293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C';
wwv_flow_imp.g_varchar2_table(139) := '696E65202352305F474C4F575F44454255475F49434F4E22292E7472696767657228226368616E676522293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202352305F484F4D455F5245504C4143455F4C494E';
wwv_flow_imp.g_varchar2_table(140) := '4B22292E7472696767657228226368616E676522293B0D0A0D0A2020202020202020696620287064742E6F70742E636F6E66696775726174696F6E54657374203D3D202266616C73652229207B0D0A202020202020202020202020242827237072657469';
wwv_flow_imp.g_varchar2_table(141) := '7573446576656C6F706572546F6F6C5761726E696E6727292E73686F7728293B0D0A20202020202020207D0D0A0D0A2020202020202020696620286E6176696761746F722E757365724167656E742E696E6465784F6628224D6163222920213D3D202D31';
wwv_flow_imp.g_varchar2_table(142) := '29207B0D0A2020202020202020202020202F2F2072756E6E696E67206F6E2061204D61630D0A20202020202020202020202076617220764D61634B6254657874203D20274B6579626F6172642053686F727463757420636F6E74726F6C2B6F7074696F6E';
wwv_flow_imp.g_varchar2_table(143) := '2B2E2E2E273B0D0A2020202020202020202020202428272352305F52455645414C45525F4B425F53484F52544355545F4C4142454C27292E7465787428764D61634B6254657874293B0D0A2020202020202020202020202428272352305F52454C4F4144';
wwv_flow_imp.g_varchar2_table(144) := '5F4B425F53484F52544355545F4C4142454C27292E7465787428764D61634B6254657874293B0D0A2020202020202020202020202428272352305F524F50454E5F4255494C4445525F4B425F53484F52544355545F4C4142454C27292E7465787428764D';
wwv_flow_imp.g_varchar2_table(145) := '61634B6254657874293B0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202066756E6374696F6E2061706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7328704D6F646529207B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(146) := '20202020202020617065782E7468656D652E6F70656E526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E742D446961';
wwv_flow_imp.g_varchar2_table(147) := '6C6F67526567696F6E2D626F647922292E6C6F6164287064742E6F70742E66696C65507265666978202B202270726574697573446576656C6F706572546F6F6C2E68746D6C222C2066756E6374696F6E202829207B0D0A2020202020202020202020206F';
wwv_flow_imp.g_varchar2_table(148) := '7074696F6E734A5328293B0D0A20202020202020207D293B0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E656D70747928293B0D0A20202020202020202428';
wwv_flow_imp.g_varchar2_table(149) := '272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E75692D6469616C6F672D7469746C6527292E746578742827205072657469757320446576656C6F70657220546F6F6C3A204F7074696F6E7327293B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(150) := '20202F2F2073656E644D6F64616C4D65737361676528293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E207472616E73706C616E74496E6C696E654469616C6F672829207B0D0A0D0A2020202020202020766172207072657469757352';
wwv_flow_imp.g_varchar2_table(151) := '657665616C6572466F6F746572203D0D0A202020202020202020202020273C64697620636C6173733D227072657469757352657665616C6572466F6F746572223E27202B0D0A202020202020202020202020273C6120636C6173733D2270726574697573';
wwv_flow_imp.g_varchar2_table(152) := '52657665616C65724C696E6B2070726574697573466F6F7465724F7074696F6E732220687265663D2268747470733A2F2F707265746975732E636F6D2F6D61696E2F22207461726765743D225F626C616E6B223E507265746975733C2F613E27202B0D0A';
wwv_flow_imp.g_varchar2_table(153) := '202020202020202020202020273C6120636C6173733D227072657469757352657665616C65724C696E6B2220687265663D2268747470733A2F2F747769747465722E636F6D2F4D6174745F4D756C76616E657922207461726765743D225F626C616E6B22';
wwv_flow_imp.g_varchar2_table(154) := '3E404D6174745F4D756C76616E6579203C2F613E27202B0D0A202020202020202020202020273C6120636C6173733D227072657469757352657665616C65724C696E6B2220687265663D2268747470733A2F2F747769747465722E636F6D2F5072657469';
wwv_flow_imp.g_varchar2_table(155) := '7573536F66747761726522207461726765743D225F626C616E6B223E4050726574697573536F6674776172653C2F613E27202B0D0A202020202020202020202020273C64697620636C6173733D22707265746975735461626C6F636B56657273696F6E22';
wwv_flow_imp.g_varchar2_table(156) := '3E3C2F6469763E27202B0D0A202020202020202020202020273C2F6469763E273B0D0A0D0A20202020202020202F2F2049662074686520706167652054656D706C61746520446F65736E7420737570706F727420496E6C696E65204469616C6F67732C20';
wwv_flow_imp.g_varchar2_table(157) := '6C696B65207061676520393939392C20616464206120636865656B79206469760D0A2020202020202020696620282428272E742D426F64792D696E6C696E654469616C6F677327292E6C656E677468203D3D203029207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(158) := '202428272361706578446576546F6F6C62617227292E70726570656E6428273C64697620636C6173733D22742D426F64792D696E6C696E654469616C6F6773223E3C2F6469763E27293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F20';
wwv_flow_imp.g_varchar2_table(159) := '4F6E6C7920637265617465206120636F6E7461696E657220696620746865726520617265206E6F206F7468657220696E6C696E65206469616C6F6773206F6E2074686520706167650D0A2020202020202020696620282428272E742D426F64792D696E6C';
wwv_flow_imp.g_varchar2_table(160) := '696E654469616C6F6773202E636F6E7461696E657227292E6C656E677468203D3D203029207B0D0A2020202020202020202020202428272E742D426F64792D696E6C696E654469616C6F677327292E617070656E6428273C64697620636C6173733D2263';
wwv_flow_imp.g_varchar2_table(161) := '6F6E7461696E6572223E3C2F6469763E27293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F20576861636B206120776164206F662048544D4C20696E2074686520636F6E7461696E65720D0A20202020202020202428272E742D426F64';
wwv_flow_imp.g_varchar2_table(162) := '792D696E6C696E654469616C6F6773202E636F6E7461696E657227292E617070656E64280D0A20202020202020202020202027202020203C64697620636C6173733D22726F77223E2027202B0D0A20202020202020202020202027202020203C64697620';
wwv_flow_imp.g_varchar2_table(163) := '636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E2027202B0D0A2020202020202020202020202720202020202020203C6469762069643D227072657469757352657665616C6572496E6C696E655F706172656E74223E20';
wwv_flow_imp.g_varchar2_table(164) := '27202B0D0A202020202020202020202020272020202020202020202020203C6469762069643D227072657469757352657665616C6572496E6C696E65222027202B0D0A2020202020202020202020202720202020202020202020202020202020636C6173';
wwv_flow_imp.g_varchar2_table(165) := '733D22742D4469616C6F67526567696F6E206A732D6D6F64616C206A732D6469616C6F672D6E6F4F7665726C6179206A732D647261676761626C65206A732D726573697A61626C65206A732D6469616C6F672D6175746F686569676874206A732D646961';
wwv_flow_imp.g_varchar2_table(166) := '6C6F672D73697A6536303078343030206A732D726567696F6E4469616C6F67222027202B0D0A20202020202020202020202027202020202020202020202020202020207374796C653D22646973706C61793A6E6F6E6522207469746C653D222050726574';
wwv_flow_imp.g_varchar2_table(167) := '69757320446576656C6F70657220546F6F6C3A2052657665616C6572223E2027202B0D0A20202020202020202020202027202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D77726170223E2027';
wwv_flow_imp.g_varchar2_table(168) := '202B0D0A2020202020202020202020202720202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D626F6479577261707065724F7574223E2027202B0D0A2020202020202020202020202720';
wwv_flow_imp.g_varchar2_table(169) := '20202020202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D626F647957726170706572496E223E2027202B0D0A2020202020202020202020202720202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(170) := '2020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D626F6479223E3C2F6469763E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020203C2F6469763E';
wwv_flow_imp.g_varchar2_table(171) := '2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020203C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020203C64697620636C6173733D22742D4469';
wwv_flow_imp.g_varchar2_table(172) := '616C6F67526567696F6E2D627574746F6E73223E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020203C6469762069643D227072657469757352657665616C6572427574746F6E526567696F6E22';
wwv_flow_imp.g_varchar2_table(173) := '20636C6173733D22742D427574746F6E526567696F6E20742D427574746F6E526567696F6E2D2D6469616C6F67526567696F6E22207374796C653D22646973706C61793A6E6F6E65223E2027202B0D0A2020202020202020202020202720202020202020';
wwv_flow_imp.g_varchar2_table(174) := '2020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D77726170223E2027202B0D0A20202020202020202020202027202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(175) := '20202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D636F6C20742D427574746F6E526567696F6E2D636F6C2D2D6C656674223E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(176) := '20202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D627574746F6E73223E3C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(177) := '202020202020202020203C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D636F6C20742D';
wwv_flow_imp.g_varchar2_table(178) := '427574746F6E526567696F6E2D636F6C2D2D7269676874223E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E';
wwv_flow_imp.g_varchar2_table(179) := '526567696F6E2D627574746F6E73223E3C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A202020202020202020202020272020';
wwv_flow_imp.g_varchar2_table(180) := '20202020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A20202020202020202020202027';
wwv_flow_imp.g_varchar2_table(181) := '20202020202020202020202020202020202020203C2F6469763E2027202B0D0A20202020202020202020202027202020202020202020202020202020203C2F6469763E2027202B0D0A202020202020202020202020272020202020202020202020203C2F';
wwv_flow_imp.g_varchar2_table(182) := '6469763E2027202B0D0A2020202020202020202020202720202020202020203C2F6469763E2027202B0D0A20202020202020202020202027202020203C2F6469763E2027202B0D0A202020202020202020202020273C2F6469763E20270D0A2020202020';
wwv_flow_imp.g_varchar2_table(183) := '202020293B0D0A0D0A20202020202020207661722076696577706F72745769647468203D2077696E646F772E696E6E65725769647468202D2032303B0D0A20202020202020207661722076696577706F7274486569676874203D2077696E646F772E696E';
wwv_flow_imp.g_varchar2_table(184) := '6E6572486569676874202D2032303B0D0A20202020202020206966202876696577706F72745769647468203E2031303030292076696577706F72745769647468203D20313030303B0D0A20202020202020206966202876696577706F7274486569676874';
wwv_flow_imp.g_varchar2_table(185) := '203E20363530292076696577706F7274486569676874203D203635303B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6522292E656163682866756E6374696F6E202829207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(186) := '2076617220696E737424203D20242874686973292C0D0A202020202020202020202020202020206973506F707570203D20696E7374242E686173436C61737328226A732D726567696F6E506F70757022292C0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(187) := '73697A65203D20205B226A732D6469616C6F672D73697A6536303078343030222C2076696577706F727457696474682C2076696577706F7274486569676874205D2C0D0A2020202020202020202020202020202072656C506F73203D202F6A732D706F70';
wwv_flow_imp.g_varchar2_table(188) := '75702D706F732D285C772B292F2E6578656328746869732E636C6173734E616D65292C0D0A20202020202020202020202020202020706172656E74203D20696E7374242E617474722822646174612D706172656E742D656C656D656E7422292C0D0A2020';
wwv_flow_imp.g_varchar2_table(189) := '20202020202020202020202020206F7074696F6E73203D207B0D0A20202020202020202020202020202020202020206175746F4F70656E3A2066616C73652C0D0A2020202020202020202020202020202020202020636F6C6C61707365456E61626C6564';
wwv_flow_imp.g_varchar2_table(190) := '3A20747275652C0D0A20202020202020202020202020202020202020206E6F4F7665726C61793A20696E7374242E686173436C61737328226A732D706F7075702D6E6F4F7665726C617922292C0D0A202020202020202020202020202020202020202063';
wwv_flow_imp.g_varchar2_table(191) := '6C6F7365546578743A20617065782E6C616E672E6765744D6573736167652822415045582E4449414C4F472E434C4F534522292C0D0A20202020202020202020202020202020202020206D6F64616C3A206973506F707570207C7C20696E7374242E6861';
wwv_flow_imp.g_varchar2_table(192) := '73436C61737328226A732D6D6F64616C22292C0D0A2020202020202020202020202020202020202020726573697A61626C653A206973506F707570203F2066616C7365203A20696E7374242E686173436C61737328226A732D726573697A61626C652229';
wwv_flow_imp.g_varchar2_table(193) := '2C0D0A2020202020202020202020202020202020202020647261676761626C653A206973506F707570203F2066616C7365203A20696E7374242E686173436C61737328226A732D647261676761626C6522292C0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(194) := '20202020206469616C6F67436C6173733A202775692D6469616C6F672D2D696E6C696E65207072657469757352657665616C6572496E6C696E65546F546865546F70272C0D0A20202020202020202020202020202020202020206F70656E3A2066756E63';
wwv_flow_imp.g_varchar2_table(195) := '74696F6E20286429207B0D0A2020202020202020202020202020202020202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E70726574697573436F6D707265737342746E27292E73686F7728293B0D';
wwv_flow_imp.g_varchar2_table(196) := '0A2020202020202020202020202020202020202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E70726574697573457870616E6442746E27292E6869646528293B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(197) := '2020202020202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F7020237072657469757352657665616C6572427574746F6E526567696F6E27292E6869646528293B0D0A0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(198) := '2020202020202020202020202F2F204C6F6720616E642072656D6F766520746865206F7665726C617973207A2D696E64657820746F20616C6C6F772074686520646576656C6F7065722062617220746F20656E61626C650D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(199) := '20202020202020202020202020766172206F7665726C61795A696E646578203D202428272E75692D7769646765742D6F7665726C61792E75692D66726F6E7427292E63737328227A2D696E64657822293B0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(200) := '202020202020202428642E746172676574292E6469616C6F6728226F7074696F6E222C20226F7665726C61792D7A2D696E646578222C206F7665726C61795A696E646578293B0D0A2020202020202020202020202020202020202020202020202428272E';
wwv_flow_imp.g_varchar2_table(201) := '75692D7769646765742D6F7665726C61792E75692D66726F6E7427292E63737328227A2D696E646578222C202222293B0D0A20202020202020202020202020202020202020207D2C0D0A2020202020202020202020202020202020202020636C6F73653A';
wwv_flow_imp.g_varchar2_table(202) := '2066756E6374696F6E20286429207B0D0A2020202020202020202020202020202020202020202020202F2F20526573746F726520746865206F7665726C617973207A2D696E6465780D0A2020202020202020202020202020202020202020202020207661';
wwv_flow_imp.g_varchar2_table(203) := '72206F7665726C61795A696E646578203D202428642E746172676574292E6469616C6F6728226F7074696F6E222C20226F7665726C61792D7A2D696E64657822293B0D0A2020202020202020202020202020202020202020202020202428272E75692D77';
wwv_flow_imp.g_varchar2_table(204) := '69646765742D6F7665726C61792E75692D66726F6E7427292E63737328227A2D696E646578222C206F7665726C61795A696E646578293B0D0A20202020202020202020202020202020202020207D2C0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(205) := '206372656174653A2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020202020202020202F2F20646F6E2774207363726F6C6C20746865206469616C6F6720776974682074686520706167650D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(206) := '2020202020202020202020202020242874686973292E636C6F7365737428222E75692D6469616C6F6722292E6373732822706F736974696F6E222C2022666978656422293B0D0A2020202020202020202020202020202020202020202020202428272370';
wwv_flow_imp.g_varchar2_table(207) := '72657469757352657665616C6572496E6C696E6527292E706172656E7428292E617070656E64287072657469757352657665616C6572466F6F746572293B0D0A2020202020202020202020202020202020202020202020202428272E7072657469757352';
wwv_flow_imp.g_varchar2_table(208) := '657665616C6572466F6F746572202E707265746975735461626C6F636B56657273696F6E27292E74657874287064742E6F70742E76657273696F6E293B0D0A20202020202020202020202020202020202020207D0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(209) := '20207D2C0D0A20202020202020202020202020202020776964676574203D206973506F707570203F2022706F70757022203A20226469616C6F67223B0D0A0D0A2020202020202020202020206966202873697A6529207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(210) := '20202020206F7074696F6E732E7769647468203D2073697A655B315D3B0D0A202020202020202020202020202020206F7074696F6E732E686569676874203D2073697A655B325D3B0D0A2020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(211) := '2069662028706172656E74202626206973506F70757029207B0D0A202020202020202020202020202020206F7074696F6E732E706172656E74456C656D656E74203D20706172656E743B0D0A2020202020202020202020202020202069662028696E7374';
wwv_flow_imp.g_varchar2_table(212) := '242E686173436C61737328226A732D706F7075702D63616C6C6F7574222929207B0D0A20202020202020202020202020202020202020206F7074696F6E732E63616C6C6F7574203D20747275653B202F2F20646F6E2774206578706C696369746C792073';
wwv_flow_imp.g_varchar2_table(213) := '657420746F2066616C73650D0A202020202020202020202020202020207D0D0A202020202020202020202020202020206966202872656C506F7329207B0D0A20202020202020202020202020202020202020206F7074696F6E732E72656C617469766550';
wwv_flow_imp.g_varchar2_table(214) := '6F736974696F6E203D2072656C506F735B315D3B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A202020202020202020202020242E65616368285B227769647468222C2022686569676874222C20226D696E57';
wwv_flow_imp.g_varchar2_table(215) := '69647468222C20226D696E486569676874222C20226D61785769647468222C20226D6178486569676874225D2C2066756E6374696F6E2028692C2070726F7029207B0D0A20202020202020202020202020202020766172206174747256616C7565203D20';
wwv_flow_imp.g_varchar2_table(216) := '7061727365496E7428696E7374242E617474722822646174612D22202B2070726F702E746F4C6F776572436173652829292C203130293B0D0A20202020202020202020202020202020696620282169734E614E286174747256616C75652929207B0D0A20';
wwv_flow_imp.g_varchar2_table(217) := '202020202020202020202020202020202020206F7074696F6E735B70726F705D203D206174747256616C75653B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A202020202020202020202020242E656163';
wwv_flow_imp.g_varchar2_table(218) := '68285B22617070656E64546F222C20226469616C6F67436C617373225D2C2066756E6374696F6E2028692C2070726F7029207B0D0A20202020202020202020202020202020766172206174747256616C7565203D20696E7374242E617474722822646174';
wwv_flow_imp.g_varchar2_table(219) := '612D22202B2070726F702E746F4C6F776572436173652829293B0D0A20202020202020202020202020202020696620286174747256616C756529207B0D0A20202020202020202020202020202020202020206F7074696F6E735B70726F705D203D206174';
wwv_flow_imp.g_varchar2_table(220) := '747256616C75653B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A202020202020202020202020696620286F7074696F6E732E617070656E64546F202626206F7074696F6E732E617070656E64546F2E73';
wwv_flow_imp.g_varchar2_table(221) := '7562737472696E6728302C203129203D3D3D202223222026262024286F7074696F6E732E617070656E64546F292E6C656E677468203D3D3D203029207B0D0A2020202020202020202020202020202024282223777776466C6F77466F726D22292E616674';
wwv_flow_imp.g_varchar2_table(222) := '657228273C6469762069643D2227202B207574696C2E65736361706548544D4C286F7074696F6E732E617070656E64546F2E737562737472696E6728312929202B2027223E3C2F6469763E27293B0D0A2020202020202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(223) := '20202020202020696E7374245B7769646765745D286F7074696F6E73290D0A202020202020202020202020202020202E6F6E28776964676574202B20226F70656E222C2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(224) := '202020696620286F7074696F6E732E6D6F64616C29207B0D0A202020202020202020202020202020202020202020202020617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28293B0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(225) := '202020202020207D0D0A2020202020202020202020202020202020202020617065782E7769646765742E7574696C2E7669736962696C6974794368616E676528696E7374245B305D2C2074727565293B0D0A202020202020202020202020202020207D29';
wwv_flow_imp.g_varchar2_table(226) := '0D0A202020202020202020202020202020202E6F6E28776964676574202B2022726573697A65222C2066756E6374696F6E202829207B0D0A20202020202020202020202020202020202020202F2F20726573697A65207365747320706F736974696F6E20';
wwv_flow_imp.g_varchar2_table(227) := '746F206162736F6C75746520736F20666978207768617420726573697A61626C652062726F6B650D0A2020202020202020202020202020202020202020242874686973292E636C6F7365737428222E75692D6469616C6F6722292E6373732822706F7369';
wwv_flow_imp.g_varchar2_table(228) := '74696F6E222C2022666978656422293B0D0A202020202020202020202020202020207D290D0A202020202020202020202020202020202E6F6E28776964676574202B2022636C6F7365222C2066756E6374696F6E202829207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(229) := '2020202020202020202020696620286F7074696F6E732E6D6F64616C29207B0D0A202020202020202020202020202020202020202020202020617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(230) := '202020202020202020202020207D0D0A2020202020202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E65202E742D4469616C6F67526567696F6E2D626F647922292E656D70747928293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(231) := '202020202020202020202020202020617065782E7769646765742E7574696C2E7669736962696C6974794368616E676528696E7374245B305D2C2066616C7365293B0D0A202020202020202020202020202020207D293B0D0A20202020202020207D293B';
wwv_flow_imp.g_varchar2_table(232) := '0D0A0D0A20202020202020207661722072657665616C657249636F6E48746D6C203D20273C696D67207372633D2227202B207064742E6F70742E66696C65507265666978202B202772657665616C65722F666F6E7441706578486970737465722E737667';
wwv_flow_imp.g_varchar2_table(233) := '27202B20272220636C6173733D227461626C6F636B4869707374657249636F6E206D617267696E2D72696768742D736D222F3E273B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6522292E706172656E7428292E';
wwv_flow_imp.g_varchar2_table(234) := '66696E6428222E75692D6469616C6F672D7469746C6522292E616464436C6173732827666127292E6265666F72652872657665616C657249636F6E48746D6C293B0D0A0D0A202020207D0D0A0D0A202020207661722072656E646572203D2066756E6374';
wwv_flow_imp.g_varchar2_table(235) := '696F6E2072656E646572286F7074696F6E7329207B0D0A0D0A20202020202020207064742E6461203D206F7074696F6E732E64613B0D0A20202020202020207064742E6F7074203D206F7074696F6E732E6F70743B0D0A20202020202020207064742E4A';
wwv_flow_imp.g_varchar2_table(236) := '534F4E73657474696E6773203D204A534F4E2E7061727365286C6F63616C53746F726167652E6765744974656D282270726574697573446576656C6F706572546F6F6C2229293B0D0A0D0A2020202020202020617065782E64656275672E696E666F286F';
wwv_flow_imp.g_varchar2_table(237) := '7074696F6E732E6F70742E6465627567507265666978202B202772656E646572272C206F7074696F6E73293B0D0A0D0A0D0A2020202020202020696620287064742E67657453657474696E6728276F70746F75742E737461747573272920213D20275927';
wwv_flow_imp.g_varchar2_table(238) := '29207B0D0A0D0A202020202020202020202020616464507265746975734F7074696F6E7328293B0D0A0D0A2020202020202020202020206966202821242E6973456D7074794F626A656374287064742E4A534F4E73657474696E67732929207B0D0A0D0A';
wwv_flow_imp.g_varchar2_table(239) := '202020202020202020202020202020202F2F2052657665616C65720D0A202020202020202020202020202020206966202867657453657474696E67282772657665616C65722E656E61626C652729203D3D2027592729207B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(240) := '202020202020202020207064742E70726574697573436F6E74656E7452657665616C65722E6164644869707374657228293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F2052656C6F61642046';
wwv_flow_imp.g_varchar2_table(241) := '72616D650D0A202020202020202020202020202020206966202867657453657474696E67282772656C6F61646672616D652E656E61626C652729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E707265746975';
wwv_flow_imp.g_varchar2_table(242) := '73436F6E74656E7452656C6F61644672616D652E616374697661746528293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F204275696C64204F7074696F6E20486967686C696768740D0A202020';
wwv_flow_imp.g_varchar2_table(243) := '202020202020202020202020206966202867657453657474696E6728276275696C646F7074696F6E68696768746C696768742E656E61626C652729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E636F6E7465';
wwv_flow_imp.g_varchar2_table(244) := '6E744275696C644F7074696F6E486967686C696768742E616374697661746528293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F204F70656E4275696C6465720D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(245) := '20202020206966202867657453657474696E6728276465766261722E6F70656E6275696C646572656E61626C652729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E70726574697573436F6E74656E74446576';
wwv_flow_imp.g_varchar2_table(246) := '4261722E61637469766174654F70656E4275696C64657228293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F20476C6F7744656275670D0A202020202020202020202020202020206966202867';
wwv_flow_imp.g_varchar2_table(247) := '657453657474696E6728276465766261722E676C6F776465627567656E61626C652729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E70726574697573436F6E74656E744465764261722E6163746976617465';
wwv_flow_imp.g_varchar2_table(248) := '476C6F77446562756728293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F20486F6D655265706C6163650D0A202020202020202020202020202020206966202867657453657474696E67282764';
wwv_flow_imp.g_varchar2_table(249) := '65766261722E686F6D657265706C6163656C696E6B2729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E70726574697573436F6E74656E744465764261722E6163746976617465486F6D655265706C61636528';
wwv_flow_imp.g_varchar2_table(250) := '290D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A20202020202020207064742E666978546F6F6C626172576964746828293B0D0A0D0A202020207D3B0D0A0D0A20202020';
wwv_flow_imp.g_varchar2_table(251) := '76617220636C6F616B44656275674C6576656C203D2066756E6374696F6E20636C6F616B44656275674C6576656C2829207B0D0A0D0A20202020202020207064742E7061676544656275674C6576656C203D20617065782E6974656D2827706465627567';
wwv_flow_imp.g_varchar2_table(252) := '27292E67657456616C756528293B0D0A2020202020202020617065782E6974656D282770646562756727292E73657456616C756528274C4556454C3227293B0D0A0D0A202020207D0D0A0D0A2020202076617220756E436C6F616B44656275674C657665';
wwv_flow_imp.g_varchar2_table(253) := '6C203D2066756E6374696F6E20756E436C6F616B44656275674C6576656C2829207B0D0A2020202020202020696620287064742E7061676544656275674C6576656C20213D20756E646566696E656429207B0D0A20202020202020202020202061706578';
wwv_flow_imp.g_varchar2_table(254) := '2E6974656D282770646562756727292E73657456616C7565287064742E7061676544656275674C6576656C293B0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202076617220616A61784572726F7248616E646C6572203D2066756E637469';
wwv_flow_imp.g_varchar2_table(255) := '6F6E20616A61784572726F7248616E646C65722870446174612C20704572722C20704572726F724D65737361676529207B0D0A0D0A20202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065';
wwv_flow_imp.g_varchar2_table(256) := '782E6D6573736167652E636C6561724572726F727328293B0D0A2020202020202020617065782E6D6573736167652E73686F774572726F7273285B7B0D0A202020202020202020202020747970653A20226572726F72222C0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(257) := '20206C6F636174696F6E3A205B2270616765225D2C0D0A2020202020202020202020206D6573736167653A20704572726F724D657373616765202B20273C62723E506C6561736520636865636B2062726F7773657220636F6E736F6C652E272C0D0A2020';
wwv_flow_imp.g_varchar2_table(258) := '20202020202020202020756E736166653A2066616C73650D0A20202020202020207D5D293B0D0A0D0A2020202020202020617065782E64656275672E696E666F2870446174612C20704572722C20704572726F724D657373616765293B0D0A202020207D';
wwv_flow_imp.g_varchar2_table(259) := '0D0A0D0A20202020766172206F7074496E203D2066756E6374696F6E206F7074496E2829207B0D0A2020202020202020766172206A203D204A534F4E2E7061727365286C6F63616C53746F726167652E6765744974656D28227072657469757344657665';
wwv_flow_imp.g_varchar2_table(260) := '6C6F706572546F6F6C2229293B0D0A2020202020202020696620286A20213D206E756C6C29207B0D0A2020202020202020202020206A2E73657474696E67732E6F70746F75742E737461747573203D20274E273B0D0A2020202020202020202020206C6F';
wwv_flow_imp.g_varchar2_table(261) := '63616C53746F726167652E7365744974656D282270726574697573446576656C6F706572546F6F6C222C204A534F4E2E737472696E67696679286A29293B0D0A202020202020202020202020617065782E6D6573736167652E73686F7750616765537563';
wwv_flow_imp.g_varchar2_table(262) := '6365737328224F7074656420496E20746F205072657469757320446576656C6F70657220546F6F6C2E205265667265736820796F75722062726F777365722E22293B0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202072657475726E207B';
wwv_flow_imp.g_varchar2_table(263) := '0D0A202020202020202072656E6465723A2072656E6465722C0D0A202020202020202064613A2064612C0D0A20202020202020206F70743A206F70742C0D0A20202020202020204A534F4E73657474696E67733A204A534F4E73657474696E67732C0D0A';
wwv_flow_imp.g_varchar2_table(264) := '20202020202020206E766C3A206E766C2C0D0A2020202020202020666978546F6F6C62617257696474683A20666978546F6F6C62617257696474682C0D0A202020202020202067657453657474696E673A2067657453657474696E672C0D0A2020202020';
wwv_flow_imp.g_varchar2_table(265) := '2020207061676544656275674C6576656C3A207061676544656275674C6576656C2C0D0A2020202020202020636C6F616B44656275674C6576656C3A20636C6F616B44656275674C6576656C2C0D0A2020202020202020756E436C6F616B44656275674C';
wwv_flow_imp.g_varchar2_table(266) := '6576656C3A20756E436C6F616B44656275674C6576656C2C0D0A2020202020202020616A61784572726F7248616E646C65723A20616A61784572726F7248616E646C65722C0D0A20202020202020206F7074496E3A206F7074496E0D0A202020207D0D0A';
wwv_flow_imp.g_varchar2_table(267) := '0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219972914685840777)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'pretiusDeveloperTool.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E7452656C6F61644672616D65203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A2020202066756E6374696F6E2061637469766174652829207B0D0A0D0A2020';
wwv_flow_imp.g_varchar2_table(2) := '202020202020766172204A534F4E73657474696E6773203D207064742E4A534F4E73657474696E67733B0D0A20202020202020207661722076446576656C6F706572734F6E6C79203D202759273B202F2F4A534F4E73657474696E67732E73657474696E';
wwv_flow_imp.g_varchar2_table(3) := '67732E72656C6F61646672616D652E646576656C6F706572736F6E6C793B0D0A202020202020202076617220764279706173735761726E4F6E556E73617665644368616E676573203D207064742E67657453657474696E6728202772656C6F6164667261';
wwv_flow_imp.g_varchar2_table(4) := '6D652E6279706173737761726E6F6E756E73617665642720293B0D0A202020202020202076617220764B6579626F61726453686F7274637574203D207064742E67657453657474696E6728202772656C6F61646672616D652E6B622720293B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(5) := '202020202020202428646F63756D656E74292E6F6E28226469616C6F676F70656E222C2066756E6374696F6E20286576656E7429207B0D0A2020202020202020202020202F2F20446F6E7420616374697661746520666F7220696672616D657320746861';
wwv_flow_imp.g_varchar2_table(6) := '7420617265276E74206D6F64616C206469616C676F730D0A20202020202020202020202069662028212824286576656E742E746172676574292E706172656E7428292E686173436C617373282775692D6469616C6F672D2D6170657827292929207B0D0A';
wwv_flow_imp.g_varchar2_table(7) := '2020202020202020202020202020202072657475726E3B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F20446F6E7420616374697661746520666F72206E6F6E2D646576656C6F706572730D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(8) := '2020206966202821282876446576656C6F706572734F6E6C79203D3D20275927202626202428272361706578446576546F6F6C62617227292E6C656E67746820213D203029207C7C2076446576656C6F706572734F6E6C79203D3D20274E272929207B0D';
wwv_flow_imp.g_varchar2_table(9) := '0A2020202020202020202020202020202072657475726E3B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F2020416464207265667265736820627574746F6E0D0A20202020202020202020202076617220764576656E';
wwv_flow_imp.g_varchar2_table(10) := '74546172676574203D2024286576656E742E746172676574292C0D0A202020202020202020202020202020207242746E5469746C65203D202752656C6F6164204672616D65272C0D0A202020202020202020202020202020207242746E203D0D0A202020';
wwv_flow_imp.g_varchar2_table(11) := '2020202020202020202020202020202020273C627574746F6E20747970653D22627574746F6E22207469746C653D2225302220617269612D6C6162656C3D2252656C6F6164204672616D65222027202B0D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(12) := '202027202020207374796C653D226D617267696E2D72696768743A253170783B222027202B0D0A20202020202020202020202020202020202020202720202020636C6173733D227072657469757352656C6F61644672616D6520742D427574746F6E2074';
wwv_flow_imp.g_varchar2_table(13) := '2D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D2274727565222027202B0D0A202020202020202020202020202020202020202027';
wwv_flow_imp.g_varchar2_table(14) := '2020202020202020636C6173733D227072657469757352656C6F61644672616D6549636F6E20742D49636F6E2066612066612D72656672657368223E3C2F7370616E3E3C2F627574746F6E3E272C0D0A2020202020202020202020202020202076506172';
wwv_flow_imp.g_varchar2_table(15) := '656E74203D202428764576656E74546172676574292E706172656E7428292C0D0A20202020202020202020202020202020765469746C65203D20242876506172656E74292E66696E6428272E75692D6469616C6F672D7469746C6527292C0D0A20202020';
wwv_flow_imp.g_varchar2_table(16) := '202020202020202020202020764469616C6F67436C6F736542746E203D20242876506172656E74292E66696E6428272E75692D6469616C6F672D7469746C656261722D636C6F736527292C0D0A20202020202020202020202020202020764D617267696E';
wwv_flow_imp.g_varchar2_table(17) := '203D20302C0D0A20202020202020202020202020202020764469616C6F67203D202428764576656E74546172676574292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C0D0A202020202020202020202020202020207669';
wwv_flow_imp.g_varchar2_table(18) := '4672616D65203D202428764469616C6F67292E66696E642827696672616D6527293B0D0A0D0A2020202020202020202020202F2F20696620636C6F736520627574746F6E20616C7265616479206861732061206D617267696E207468656E20706164206F';
wwv_flow_imp.g_varchar2_table(19) := '75740D0A202020202020202020202020696620282428764469616C6F67436C6F736542746E292E6C656E677468203E2030202626202428764469616C6F67436C6F736542746E292E63737328276D617267696E2D6C65667427292E7265706C6163652827';
wwv_flow_imp.g_varchar2_table(20) := '7078272C20272729203D3D2027302729207B0D0A20202020202020202020202020202020764D617267696E203D2033303B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028764B6579626F61726453686F72746375';
wwv_flow_imp.g_varchar2_table(21) := '7420213D206E756C6C29207B0D0A202020202020202020202020202020202F2F20466F726D617420427574746F6E207469746C652F746F6F6C7469700D0A202020202020202020202020202020207242746E5469746C65203D207242746E5469746C6520';
wwv_flow_imp.g_varchar2_table(22) := '2B20617065782E6C616E672E666F726D6174282720284374726C2B416C742B253029272C20764B6579626F61726453686F7274637574293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F2053657420427574746F6E';
wwv_flow_imp.g_varchar2_table(23) := '207469746C652F746F6F6C74697020616E642061646420427574746F6E0D0A2020202020202020202020207242746E203D20617065782E6C616E672E666F726D6174287242746E2C207242746E5469746C652C20764D617267696E293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(24) := '202020202020202428765469746C65292E6166746572287242746E293B0D0A0D0A20202020202020207D293B0D0A20202020202020200D0A0D0A2020202020202020242827626F647927292E6F6E2827636C69636B272C2027627574746F6E2E70726574';
wwv_flow_imp.g_varchar2_table(25) := '69757352656C6F61644672616D65272C2066756E6374696F6E20286576656E7429207B0D0A20202020202020202020202076617220764576656E74546172676574203D2024286576656E742E746172676574292C0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(26) := '2020764469616C6F67203D202428764576656E74546172676574292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C0D0A2020202020202020202020202020202076694672616D65203D202428764469616C6F67292E6669';
wwv_flow_imp.g_varchar2_table(27) := '6E642827696672616D6527292C0D0A2020202020202020202020202020202076526F7461746554696D656F7574203D20313030303B0D0A0D0A2020202020202020202020206966202876694672616D655B305D2E636F6E74656E7457696E646F772E6170';
wwv_flow_imp.g_varchar2_table(28) := '65782E706167652E69734368616E6765642829203D3D2066616C7365207C7C20764279706173735761726E4F6E556E73617665644368616E676573203D3D2027592729207B0D0A2020202020202020202020202020202076694672616D655B305D2E636F';
wwv_flow_imp.g_varchar2_table(29) := '6E74656E7457696E646F772E617065782E706167652E63616E63656C5761726E4F6E556E73617665644368616E67657328293B0D0A202020202020202020202020202020202428764576656E74546172676574292E706172656E7428292E66696E642827';
wwv_flow_imp.g_varchar2_table(30) := '2E7072657469757352656C6F61644672616D6549636F6E27292E616464436C617373282766612D616E696D2D7370696E27293B0D0A0D0A2020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0D0A202020';
wwv_flow_imp.g_varchar2_table(31) := '20202020202020202020202020202020202428764576656E74546172676574292E706172656E7428292E66696E6428272E7072657469757352656C6F61644672616D6549636F6E27292E72656D6F7665436C617373282766612D616E696D2D7370696E27';
wwv_flow_imp.g_varchar2_table(32) := '293B0D0A202020202020202020202020202020207D2C2076526F7461746554696D656F7574293B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202076694672616D655B305D2E636F6E74656E74446F63756D656E742E6C6F63';
wwv_flow_imp.g_varchar2_table(33) := '6174696F6E2E72656C6F616428293B0D0A20202020202020207D293B0D0A0D0A20202020202020202F2F2042696E64206B6579626F6172642073686F7274637574730D0A20202020202020204D6F757365747261702E62696E64476C6F62616C28276374';
wwv_flow_imp.g_varchar2_table(34) := '726C2B616C742B27202B20764B6579626F61726453686F72746375742E746F4C6F7765724361736528292C2066756E6374696F6E20286529207B0D0A202020202020202020202020706172656E742E242827627574746F6E2E7072657469757352656C6F';
wwv_flow_imp.g_varchar2_table(35) := '61644672616D653A6C61737427292E747269676765722827636C69636B27293B0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202072657475726E207B0D0A202020202020202061637469766174653A2061637469766174650D0A';
wwv_flow_imp.g_varchar2_table(36) := '202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219973392175840781)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'reload-frame/contentReloadFrame.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E7452656C6F61644672616D653D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E207428297B7064742E4A534F4E73657474696E67733B76617220743D2259222C613D7064742E';
wwv_flow_imp.g_varchar2_table(2) := '67657453657474696E67282272656C6F61646672616D652E6279706173737761726E6F6E756E736176656422292C653D7064742E67657453657474696E67282272656C6F61646672616D652E6B6222293B2428646F63756D656E74292E6F6E2822646961';
wwv_flow_imp.g_varchar2_table(3) := '6C6F676F70656E222C66756E6374696F6E2861297B6966282428612E746172676574292E706172656E7428292E686173436C617373282275692D6469616C6F672D2D6170657822292626282259223D3D74262630213D2428222361706578446576546F6F';
wwv_flow_imp.g_varchar2_table(4) := '6C62617222292E6C656E6774687C7C224E223D3D7429297B766172206E3D2428612E746172676574292C6F3D2252656C6F6164204672616D65222C693D273C627574746F6E20747970653D22627574746F6E22207469746C653D2225302220617269612D';
wwv_flow_imp.g_varchar2_table(5) := '6C6162656C3D2252656C6F6164204672616D652220202020207374796C653D226D617267696E2D72696768743A253170783B222020202020636C6173733D227072657469757352656C6F61644672616D6520742D427574746F6E20742D427574746F6E2D';
wwv_flow_imp.g_varchar2_table(6) := '2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D227472756522202020202020202020636C6173733D227072657469757352656C6F61644672616D6549';
wwv_flow_imp.g_varchar2_table(7) := '636F6E20742D49636F6E2066612066612D72656672657368223E3C2F7370616E3E3C2F627574746F6E3E272C723D24286E292E706172656E7428292C6C3D242872292E66696E6428222E75692D6469616C6F672D7469746C6522292C733D242872292E66';
wwv_flow_imp.g_varchar2_table(8) := '696E6428222E75692D6469616C6F672D7469746C656261722D636C6F736522292C643D302C703D24286E292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822293B242870292E66696E642822696672616D6522293B242873292E';
wwv_flow_imp.g_varchar2_table(9) := '6C656E6774683E3026262230223D3D242873292E63737328226D617267696E2D6C65667422292E7265706C61636528227078222C222229262628643D3330292C6E756C6C213D652626286F2B3D617065782E6C616E672E666F726D617428222028437472';
wwv_flow_imp.g_varchar2_table(10) := '6C2B416C742B253029222C6529292C693D617065782E6C616E672E666F726D617428692C6F2C64292C24286C292E61667465722869297D7D292C242822626F647922292E6F6E2822636C69636B222C22627574746F6E2E7072657469757352656C6F6164';
wwv_flow_imp.g_varchar2_table(11) := '4672616D65222C66756E6374696F6E2874297B76617220653D2428742E746172676574292C6E3D242865292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C6F3D24286E292E66696E642822696672616D6522292C693D31';
wwv_flow_imp.g_varchar2_table(12) := '65333B30213D6F5B305D2E636F6E74656E7457696E646F772E617065782E706167652E69734368616E67656428292626225922213D617C7C286F5B305D2E636F6E74656E7457696E646F772E617065782E706167652E63616E63656C5761726E4F6E556E';
wwv_flow_imp.g_varchar2_table(13) := '73617665644368616E67657328292C242865292E706172656E7428292E66696E6428222E7072657469757352656C6F61644672616D6549636F6E22292E616464436C617373282266612D616E696D2D7370696E22292C73657454696D656F75742866756E';
wwv_flow_imp.g_varchar2_table(14) := '6374696F6E28297B242865292E706172656E7428292E66696E6428222E7072657469757352656C6F61644672616D6549636F6E22292E72656D6F7665436C617373282266612D616E696D2D7370696E22297D2C6929292C6F5B305D2E636F6E74656E7444';
wwv_flow_imp.g_varchar2_table(15) := '6F63756D656E742E6C6F636174696F6E2E72656C6F616428297D292C4D6F757365747261702E62696E64476C6F62616C28226374726C2B616C742B222B652E746F4C6F7765724361736528292C66756E6374696F6E2874297B706172656E742E24282262';
wwv_flow_imp.g_varchar2_table(16) := '7574746F6E2E7072657469757352656C6F61644672616D653A6C61737422292E747269676765722822636C69636B22297D297D72657475726E7B61637469766174653A747D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219973735839840785)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'reload-frame/minified/contentReloadFrame.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E7452657665616C6572203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A202020207661722064656275674D6F64653B0D0A202020207661722072657665616C';
wwv_flow_imp.g_varchar2_table(2) := '657249636F6E48746D6C3B0D0A0D0A2020202076617220617065784974656D5479706573203D205B2254455854222C0D0A202020202020202022434845434B424F585F47524F5550222C0D0A202020202020202022444953504C41595F53415645535F53';
wwv_flow_imp.g_varchar2_table(3) := '54415445222C0D0A202020202020202022444953504C41595F4F4E4C59222C0D0A20202020202020202248494444454E222C0D0A20202020202020202253485554544C45222C0D0A202020202020202022524144494F5F47524F5550222C0D0A20202020';
wwv_flow_imp.g_varchar2_table(4) := '202020202253454C454354222C0D0A202020202020202022504F5055505F4B45595F4C4F56222C0D0A202020202020202022504F5055505F4C4F56222C0D0A202020202020202022535749544348222C0D0A202020202020202022544558544152454122';
wwv_flow_imp.g_varchar2_table(5) := '2C0D0A202020202020202022434B454449544F5233222C0D0A2020202020202020224155544F5F434F4D504C455445225D3B0D0A0D0A202020202F2F206E6F74202E617065782D6974656D2D67726F7570200D0A20202020766172206974656D53747269';
wwv_flow_imp.g_varchar2_table(6) := '6E67203D2022696E7075743A6E6F7428275B646174612D666F725D2C2E6A732D746162547261702C2E612D47562D726F7753656C65637427292C2022202B0D0A2020202020202020222E73656C6563746C6973742C2022202B0D0A202020202020202022';
wwv_flow_imp.g_varchar2_table(7) := '2E74657874617265612C2022202B0D0A2020202020202020222E6C6973746D616E616765723A6E6F74286669656C64736574292C2022202B0D0A2020202020202020222E617065782D6974656D2D726164696F2C2022202B0D0A2020202020202020222E';
wwv_flow_imp.g_varchar2_table(8) := '617065782D6974656D2D636865636B626F782C2022202B0D0A2020202020202020222E617065782D6974656D2D646973706C61792D6F6E6C792C2022202B0D0A2020202020202020222E617065782D6974656D2D67726F75702D2D73687574746C652C20';
wwv_flow_imp.g_varchar2_table(9) := '22202B0D0A2020202020202020222E617065782D6974656D2D73687574746C652C2022202B0D0A2020202020202020222E617065782D6974656D2D67726F75702D2D7377697463682C2022202B0D0A2020202020202020222E617065782D6974656D2D67';
wwv_flow_imp.g_varchar2_table(10) := '726F75702D2D6175746F2D636F6D706C6574652C2022202B0D0A2020202020202020222E617065782D6974656D2D7965732D6E6F2C2022202B0D0A20202020202020202274657874617265612C2022202B0D0A2020202020202020222E73687574746C65';
wwv_flow_imp.g_varchar2_table(11) := '3A6E6F74287461626C65292C2022202B0D0A2020202020202020222E73687574746C655F6C6566742C2022202B0D0A2020202020202020222E73687574746C655F72696768742C2022202B0D0A2020202020202020222E636865636B626F785F67726F75';
wwv_flow_imp.g_varchar2_table(12) := '703A6E6F7428276469762C7461626C6527292C2022202B0D0A2020202020202020222E7965735F6E6F223B0D0A0D0A202020207661722072657665616C657249676E6F7265436C617373203D20277064742D72657665616C65722D69676E6F7265273B0D';
wwv_flow_imp.g_varchar2_table(13) := '0A0D0A202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F313931323532320D0A2020202066756E6374696F6E2068746D6C4465636F646528696E70757429207B0D0A20202020202020207661722065203D20646F63';
wwv_flow_imp.g_varchar2_table(14) := '756D656E742E637265617465456C656D656E742827746578746172656127293B0D0A2020202020202020652E696E6E657248544D4C203D20696E7075743B0D0A20202020202020202F2F2068616E646C652063617365206F6620656D70747920696E7075';
wwv_flow_imp.g_varchar2_table(15) := '740D0A202020202020202072657475726E20652E6368696C644E6F6465732E6C656E677468203D3D3D2030203F202222203A20652E6368696C644E6F6465735B305D2E6E6F646556616C75653B0D0A202020207D0D0A0D0A20202020766172206672616D';
wwv_flow_imp.g_varchar2_table(16) := '65776F726B4172726179203D205B2770436F6E74657874272C202770466C6F774964272C202770466C6F77537465704964272C202770496E7374616E6365272C202770506167655375626D697373696F6E4964272C20277052657175657374272C202770';
wwv_flow_imp.g_varchar2_table(17) := '52656C6F61644F6E5375626D6974272C20277053616C74272C202770506167654974656D73526F7756657273696F6E272C202770506167654974656D7350726F746563746564272C2027706465627567272C20276170657843424D44756D6D7953656C65';
wwv_flow_imp.g_varchar2_table(18) := '6374696F6E272C20277050616765436865636B73756D272C2027705F6D64355F636865636B73756D272C20277050616765466F726D526567696F6E436865636B73756D73275D3B0D0A0D0A2020202066756E6374696F6E20696E6A656374536372697074';
wwv_flow_imp.g_varchar2_table(19) := '28796F7572437573746F6D4A617661536372697074436F64652C207065727369737429207B0D0A202020202020202076617220736372697074203D20646F63756D656E742E637265617465456C656D656E74282773637269707427293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(20) := '2020207363726970742E6964203D2027746D70536372697074273B0D0A202020202020202076617220636F6465203D20646F63756D656E742E637265617465546578744E6F646528272866756E6374696F6E2829207B27202B20796F7572437573746F6D';
wwv_flow_imp.g_varchar2_table(21) := '4A617661536372697074436F6465202B20277D2928293B27293B0D0A20202020202020207363726970742E617070656E644368696C6428636F6465293B0D0A2020202020202020696620282428646F63756D656E742E626F6479207C7C20646F63756D65';
wwv_flow_imp.g_varchar2_table(22) := '6E742E68656164292E6C656E677468203E203029207B0D0A20202020202020202020202028646F63756D656E742E626F6479207C7C20646F63756D656E742E68656164292E617070656E644368696C6428736372697074293B0D0A20202020202020207D';
wwv_flow_imp.g_varchar2_table(23) := '0D0A202020202020202024282223746D7053637269707422292E72656D6F766528293B0D0A202020207D0D0A0D0A2020202066756E6374696F6E2063726970706C655461624C6F636B52657665616C65722829207B0D0A20202020202020202F2F205365';
wwv_flow_imp.g_varchar2_table(24) := '6C65637420746865206E6F646520746861742077696C6C206265206F6273657276656420666F72206D75746174696F6E730D0A2020202020202020636F6E7374207461726765744E6F6465203D20646F63756D656E742E676574456C656D656E74427949';
wwv_flow_imp.g_varchar2_table(25) := '64282761706578446576546F6F6C62617227293B0D0A0D0A20202020202020202F2F204F7074696F6E7320666F7220746865206F6273657276657220287768696368206D75746174696F6E7320746F206F627365727665290D0A2020202020202020636F';
wwv_flow_imp.g_varchar2_table(26) := '6E737420636F6E666967203D207B20617474726962757465733A20747275652C206368696C644C6973743A20747275652C20737562747265653A2074727565207D3B0D0A0D0A20202020202020202F2F2043616C6C6261636B2066756E6374696F6E2074';
wwv_flow_imp.g_varchar2_table(27) := '6F2065786563757465207768656E206D75746174696F6E7320617265206F627365727665640D0A2020202020202020636F6E73742063616C6C6261636B546F6F6C626172203D2066756E6374696F6E20286D75746174696F6E734C6973742C206F627365';
wwv_flow_imp.g_varchar2_table(28) := '7276657229207B0D0A202020202020202020202020696620282428272361706578446576546F6F6C6261725661727327292E6C656E677468203E203029207B0D0A202020202020202020202020202020202428272361706578446576546F6F6C62617256';
wwv_flow_imp.g_varchar2_table(29) := '61727327292E636C6F7365737428276C6927292E7265706C6163655769746828293B0D0A202020202020202020202020202020206F62736572766572546F6F6C6261722E646973636F6E6E65637428293B0D0A2020202020202020202020207D0D0A2020';
wwv_flow_imp.g_varchar2_table(30) := '2020202020207D3B0D0A0D0A2020202020202020636F6E73742063616C6C6261636B496672616D65203D2066756E6374696F6E20286D75746174696F6E734C6973742C206F6273657276657229207B0D0A20202020202020202020202069662028242827';
wwv_flow_imp.g_varchar2_table(31) := '626F647920696672616D655B69643D227461626C6F636B52657665616C65724672616D65225D27292E6C656E677468203E203029207B0D0A20202020202020202020202020202020242827626F647920696672616D655B69643D227461626C6F636B5265';
wwv_flow_imp.g_varchar2_table(32) := '7665616C65724672616D65225D27292E7265706C6163655769746828293B0D0A202020202020202020202020202020206F62736572766572496672616D652E646973636F6E6E65637428293B0D0A2020202020202020202020207D0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(33) := '207D3B0D0A0D0A20202020202020202F2F2043726561746520616E206F6273657276657220696E7374616E6365206C696E6B656420746F207468652063616C6C6261636B2066756E6374696F6E0D0A2020202020202020636F6E7374206F627365727665';
wwv_flow_imp.g_varchar2_table(34) := '72546F6F6C626172203D206E6577204D75746174696F6E4F627365727665722863616C6C6261636B546F6F6C626172293B0D0A2020202020202020636F6E7374206F62736572766572496672616D65203D206E6577204D75746174696F6E4F6273657276';
wwv_flow_imp.g_varchar2_table(35) := '65722863616C6C6261636B496672616D65293B0D0A0D0A20202020202020202F2F205374617274206F6273657276696E672074686520746172676574206E6F646520666F7220636F6E66696775726564206D75746174696F6E730D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(36) := '6F62736572766572546F6F6C6261722E6F627365727665287461726765744E6F64652C20636F6E666967293B0D0A20202020202020206F62736572766572496672616D652E6F62736572766528242827626F647927295B305D2C20636F6E666967293B0D';
wwv_flow_imp.g_varchar2_table(37) := '0A202020207D0D0A0D0A2020202066756E6374696F6E20636C6F67287029207B0D0A2020202020202020696620287064742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F646529207B0D0A20202020202020202020202063';
wwv_flow_imp.g_varchar2_table(38) := '6F6E736F6C652E6C6F672870293B0D0A20202020202020207D0D0A202020207D0D0A2020202066756E6374696F6E2073656E644D6F64616C4D6573736167652829207B0D0A2020202020202020766172206A203D205B5D3B0D0A20202020202020207661';
wwv_flow_imp.g_varchar2_table(39) := '7220646973636F76657265645061676573203D20273A273B0D0A0D0A202020202020202066756E6374696F6E206164644974656D546F4A736F6E287053656C6563746F722C2070496672616D6553656C6563746F72203D20272729207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(40) := '202020202020207661722061203D207B7D3B0D0A2020202020202020202020207661722069203D20303B0D0A0D0A2020202020202020202020202F2F204765742050616765206E756D6265720D0A20202020202020202020202076617220796F75724375';
wwv_flow_imp.g_varchar2_table(41) := '73746F6D4A617661536372697074436F6465203D2022242827626F647927292E617474722827746D705F78272C2022202B2070496672616D6553656C6563746F72202B2022617065782E6974656D282770466C6F7753746570496427292E67657456616C';
wwv_flow_imp.g_varchar2_table(42) := '75652829293B223B0D0A202020202020202020202020696E6A65637453637269707428796F7572437573746F6D4A617661536372697074436F6465293B0D0A202020202020202020202020766172207870466C6F77537465704964203D20242822626F64';
wwv_flow_imp.g_varchar2_table(43) := '7922292E617474722822746D705F7822293B0D0A202020202020202020202020242822626F647922292E72656D6F7665417474722822746D705F7822293B0D0A0D0A202020202020202020202020636C6F67287053656C6563746F72293B0D0A0D0A2020';
wwv_flow_imp.g_varchar2_table(44) := '202020202020202020207661722074727565506167654964203D207870466C6F775374657049642E73706C697428225F22295B305D3B0D0A0D0A202020202020202020202020612E50616765203D207870466C6F775374657049643B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(45) := '202020202020612E4E616D65203D207053656C6563746F722E69643B0D0A0D0A20202020202020202020202076617220796F7572437573746F6D4A617661536372697074436F6465203D2068746D6C4465636F646528617065782E6C616E672E666F726D';
wwv_flow_imp.g_varchar2_table(46) := '6174280D0A20202020202020202020202020202020227661722072657665616C65724974656D203D202530617065782E6974656D2827253127293B2022202B0D0A20202020202020202020202020202020227661722072657665616C657256616C756549';
wwv_flow_imp.g_varchar2_table(47) := '74656D203D2072657665616C65724974656D2E67657456616C756528293B2022202B0D0A20202020202020202020202020202020227661722072657665616C657254797065203D2072657665616C65724974656D2E6974656D5F747970653B2022202B0D';
wwv_flow_imp.g_varchar2_table(48) := '0A20202020202020202020202020202020227661722072657665616C657256616C75654974656D537472696E673B2022202B0D0A2020202020202020202020202020202022696620282072657665616C657256616C75654974656D20696E7374616E6365';
wwv_flow_imp.g_varchar2_table(49) := '6F66204172726179292022202B0D0A20202020202020202020202020202020227B2022202B0D0A20202020202020202020202020202020222020202072657665616C657256616C75654974656D537472696E67203D2072657665616C657256616C756549';
wwv_flow_imp.g_varchar2_table(50) := '74656D2E6A6F696E28273A27293B2022202B0D0A20202020202020202020202020202020227D2022202B0D0A2020202020202020202020202020202022656C73652022202B0D0A20202020202020202020202020202020227B2022202B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(51) := '2020202020202020202020222020202072657665616C657256616C75654974656D537472696E67203D2072657665616C657256616C75654974656D3B2022202B0D0A20202020202020202020202020202020227D2022202B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(52) := '20202020202022242827626F647927292E617474722827746D705F7461624C6F636B4361736556616C7565272C2072657665616C657256616C75654974656D537472696E67293B2022202B0D0A2020202020202020202020202020202022242827626F64';
wwv_flow_imp.g_varchar2_table(53) := '7927292E617474722827746D705F7461624C6F636B4361736554797065272C202072657665616C657254797065293B20222C0D0A2020202020202020202020202020202070496672616D6553656C6563746F722C0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(54) := '2020612E4E616D6529293B0D0A0D0A202020202020202020202020696E6A65637453637269707428796F7572437573746F6D4A617661536372697074436F6465293B0D0A202020202020202020202020612E54797065203D20242822626F647922292E61';
wwv_flow_imp.g_varchar2_table(55) := '7474722822746D705F7461624C6F636B436173655479706522293B0D0A202020202020202020202020612E56616C7565203D20242822626F647922292E617474722822746D705F7461624C6F636B4361736556616C756522293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(56) := '20202020242822626F647922292E72656D6F7665417474722822746D705F7461624C6F636B4361736556616C756522293B0D0A202020202020202020202020242822626F647922292E72656D6F7665417474722822746D705F7461624C6F636B43617365';
wwv_flow_imp.g_varchar2_table(57) := '5479706522293B0D0A0D0A2020202020202020202020202F2F204966206E6F2041504558206974656D2C2074727920766961206E6F64650D0A20202020202020202020202069662028612E56616C7565203D3D20272729207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(58) := '20202020202020612E56616C7565203D207053656C6563746F722E76616C75653B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E5479706529207B0D0A20202020202020202020202020202020612E547970';
wwv_flow_imp.g_varchar2_table(59) := '65203D20612E547970652E746F55707065724361736528293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F204966206E6F206E616D652C2074727920746F206772616220616E20616C7465726E61746976650D0A20';
wwv_flow_imp.g_varchar2_table(60) := '20202020202020202020202F2F436F6C6F72207069636B6572206669780D0A20202020202020202020202069662028612E4E616D65203D3D20272729207B0D0A2020202020202020202020202020202076617220646976436C6173734E616D6573203D20';
wwv_flow_imp.g_varchar2_table(61) := '24287053656C6563746F72292E636C6F73657374282764697627292E617474722827636C61737327293B0D0A2020202020202020202020202020202069662028646976436C6173734E616D657320262620646976436C6173734E616D65732E7374617274';
wwv_flow_imp.g_varchar2_table(62) := '73576974682827636F6C6F727069636B6572272929207B0D0A20202020202020202020202020202020202020207661722063704944203D2024287053656C6563746F72292E636C6F7365737428272E636F6C6F727069636B657227292E61747472282769';
wwv_flow_imp.g_varchar2_table(63) := '6427293B0D0A0D0A2020202020202020202020202020202020202020612E4E616D65203D2063704944202B2027203E2027202B20646976436C6173734E616D65732E73706C697428272027295B305D2E7265706C6163652827636F6C6F727069636B6572';
wwv_flow_imp.g_varchar2_table(64) := '5F272C202727293B0D0A2020202020202020202020202020202020202020612E54797065203D2027494E50555420286173736F632E207769746820434F4C4F525F5049434B455229273B0D0A202020202020202020202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(65) := '202020202020207D0D0A0D0A2020202020202020202020206966202824287053656C6563746F72292E686173436C61737328276F6A2D636F6D706F6E656E742D696E69746E6F6465272929207B0D0A20202020202020202020202020202020612E547970';
wwv_flow_imp.g_varchar2_table(66) := '65202B3D202720286173736F632E2077697468204155544F5F434F4D504C45544529273B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065203D3D202746414C53452729207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(67) := '2020202020202020202F2F5365636F6E64206368616E63650D0A0D0A202020202020202020202020202020202F2F20666F722073776974636865730D0A202020202020202020202020202020206966202824287053656C6563746F72292E686173436C61';
wwv_flow_imp.g_varchar2_table(68) := '73732827617065782D6974656D2D67726F75702D2D7377697463682729207C7C0D0A202020202020202020202020202020202020202024287053656C6563746F72292E686173436C6173732827617065782D6974656D2D7965732D6E6F272929207B2061';
wwv_flow_imp.g_varchar2_table(69) := '2E54797065203D2027535749544348273B207D0D0A202020202020202020202020202020202F2F2054657874204669656C642077697468206175746F20636F6D706C6574650D0A202020202020202020202020202020206966202824287053656C656374';
wwv_flow_imp.g_varchar2_table(70) := '6F72292E686173436C6173732827617065782D6974656D2D67726F75702D2D6175746F2D636F6D706C657465272929207B20612E54797065203D20274155544F5F434F4D504C455445273B207D0D0A0D0A20202020202020202020202020202020696620';
wwv_flow_imp.g_varchar2_table(71) := '2824287053656C6563746F72292E686173436C6173732827612D427574746F6E2D2D6C6973744D616E61676572272929207B0D0A2020202020202020202020202020202020202020612E4E616D65203D20273E2027202B20612E56616C75653B0D0A2020';
wwv_flow_imp.g_varchar2_table(72) := '202020202020202020202020202020202020612E54797065203D2027286173736F632E2077697468204C4953545F4D414E4147455229273B0D0A202020202020202020202020202020207D0D0A202020202020202020202020202020202F2F2054657874';
wwv_flow_imp.g_varchar2_table(73) := '2061726561206669656C647365740D0A202020202020202020202020202020206966202824287053656C6563746F72292E697328276669656C6473657427292026262024287053656C6563746F72292E6368696C6472656E28272E617065782D6974656D';
wwv_flow_imp.g_varchar2_table(74) := '2D74657874617265613A666972737427292E6C656E677468203E203029207B0D0A2020202020202020202020202020202020202020612E54797065203D2027286173736F632E207769746820544558544152454129273B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(75) := '20202020207D0D0A202020202020202020202020202020202F2A204150455820352E3020616E6420756E6E616D6564202A2F0D0A2020202020202020202020202020202069662028612E4E616D65203D3D20272729207B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(76) := '202020202020202020612E4E616D65203D2024287053656C6563746F72292E6174747228276E616D6527293B202F2F205265706C616365206E616D652077697468206E616D65206174747269627574650D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(77) := '2020766172206F72696754797065203D2024287053656C6563746F72292E6174747228277479706527293B202F2F205265706C6163652046414C5345207479706520776974682074797065206174747269627574650D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(78) := '20202020202020696620286F7269675479706529207B0D0A202020202020202020202020202020202020202020202020612E54797065203D206F726967547970652E746F55707065724361736528293B0D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(79) := '20207D0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065203D3D202748494444454E27202626206672616D65776F726B41727261792E696E6465';
wwv_flow_imp.g_varchar2_table(80) := '784F6628612E4E616D6529203D3D202D3129207B0D0A202020202020202020202020202020206966202824287053656C6563746F72292E6E65787428292E66696E6428272E617065782D6974656D2D706F7075702D6C6F762C202E706F7075705F6C6F76';
wwv_flow_imp.g_varchar2_table(81) := '27292E6C656E677468203E203029207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E207769746820504F5055505F4C4F5629273B0D0A202020202020202020202020202020207D0D0A20202020';
wwv_flow_imp.g_varchar2_table(82) := '20202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065203D3D202753454C4543542729207B0D0A202020202020202020202020202020206966202824287053656C6563746F72292E686173436C61737328277368757474';
wwv_flow_imp.g_varchar2_table(83) := '6C655F6C6566742729207C7C2024287053656C6563746F72292E686173436C617373282773687574746C655F7269676874272929207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E2077697468';
wwv_flow_imp.g_varchar2_table(84) := '2053485554544C4529273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065203D3D2027504F5055505F4C4F562729207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(85) := '202020202020206966202824287053656C6563746F72292E636C6F7365737428276669656C6473657427292E706172656E7428292E636C6F7365737428276669656C6473657427292E686173436C6173732827617065782D6974656D2D6C6973742D6D61';
wwv_flow_imp.g_varchar2_table(86) := '6E61676572272929207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E20776974682053454C4543542F4C4953545F4D414E4147455229273B0D0A202020202020202020202020202020207D0D0A';
wwv_flow_imp.g_varchar2_table(87) := '202020202020202020202020202020206966202824287053656C6563746F72292E6174747228277469746C652729203D3D202741646420456E747279272026260D0A202020202020202020202020202020202020202024287053656C6563746F72292E69';
wwv_flow_imp.g_varchar2_table(88) := '732827696E70757427292026260D0A202020202020202020202020202020202020202024287053656C6563746F72292E697328275B6964243D22414444225D272929207B0D0A2020202020202020202020202020202020202020612E54797065202B3D20';
wwv_flow_imp.g_varchar2_table(89) := '2720286173736F632E2077697468204C4953545F4D414E4147455229273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065203D3D2027444953504C';
wwv_flow_imp.g_varchar2_table(90) := '41595F4F4E4C592729207B0D0A2020202020202020202020202020202076617220646F5F6964203D2024287053656C6563746F72292E7369626C696E67732827696E7075745B747970653D2268696464656E225D3A666972737427292E61747472282269';
wwv_flow_imp.g_varchar2_table(91) := '6422293B0D0A2020202020202020202020202020202069662028646F5F6964202626202428272327202B20646F5F69642E7265706C61636528275F444953504C4159272C202727292929207B0D0A2020202020202020202020202020202020202020612E';
wwv_flow_imp.g_varchar2_table(92) := '54797065202B3D202720286173736F632E207769746820444953504C41595F4F4E4C5929273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020207661722074797065496E4172';
wwv_flow_imp.g_varchar2_table(93) := '7279506F73203D20242E696E417272617928612E547970652C20617065784974656D5479706573293B0D0A0D0A202020202020202020202020696620287053656C6563746F722E636C6F7365737428225B636C6173735E3D27612D495252275D22292920';
wwv_flow_imp.g_varchar2_table(94) := '7B0D0A20202020202020202020202020202020612E43617465676F7279203D20274952273B0D0A2020202020202020202020207D0D0A202020202020202020202020656C736520696620287053656C6563746F722E636C6F7365737428225B636C617373';
wwv_flow_imp.g_varchar2_table(95) := '5E3D27612D4947275D222929207B0D0A20202020202020202020202020202020612E43617465676F7279203D20274947273B0D0A2020202020202020202020207D0D0A202020202020202020202020656C736520696620286672616D65776F726B417272';
wwv_flow_imp.g_varchar2_table(96) := '61792E696E6465784F6628612E4E616D6529203E3D203029207B0D0A20202020202020202020202020202020612E43617465676F7279203D20274657273B0D0A2020202020202020202020207D0D0A202020202020202020202020656C7365207B0D0A20';
wwv_flow_imp.g_varchar2_table(97) := '2020202020202020202020202020202F2F2050616765206974656D730D0A2020202020202020202020202020202069662028612E4E616D6520262620612E4E616D652E7374617274735769746828225022202B2074727565506167654964292026262074';
wwv_flow_imp.g_varchar2_table(98) := '797065496E41727279506F73203E202D3129207B0D0A2020202020202020202020202020202020202020612E43617465676F7279203D202750492C5058273B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(99) := '656C73652069662028612E4E616D6520262620612E4E616D652E737461727473576974682822503022292026262074797065496E41727279506F73203E202D3129207B0D0A2020202020202020202020202020202020202020612E43617465676F727920';
wwv_flow_imp.g_varchar2_table(100) := '3D202750492C5030273B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020202020656C7365207B0D0A2020202020202020202020202020202020202020612E43617465676F7279203D202750492C504F273B0D0A2020';
wwv_flow_imp.g_varchar2_table(101) := '20202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020206A2E707573682861293B0D0A20202020202020207D0D0A0D0A202020202020202076617220796F7572437573746F6D4A617661536372';
wwv_flow_imp.g_varchar2_table(102) := '697074436F6465203D2022242827626F647927292E617474722827746D705F78272C20617065782E6974656D282770466C6F7753746570496427292E67657456616C75652829293B223B0D0A2020202020202020696E6A65637453637269707428796F75';
wwv_flow_imp.g_varchar2_table(103) := '72437573746F6D4A617661536372697074436F6465293B0D0A2020202020202020766172207870466C6F77537465704964203D20242822626F647922292E617474722822746D705F7822293B0D0A2020202020202020242822626F647922292E72656D6F';
wwv_flow_imp.g_varchar2_table(104) := '7665417474722822746D705F7822293B0D0A0D0A2020202020202020646973636F76657265645061676573203D20646973636F76657265645061676573202B207870466C6F77537465704964202B20273A273B0D0A0D0A20202020202020207661722069';
wwv_flow_imp.g_varchar2_table(105) := '74656D53656C6563746F72203D2024286974656D537472696E67292E66696C7465722866756E6374696F6E2829207B0D0A20202020202020202020202072657475726E20212820242874686973292E686173436C6173732872657665616C657249676E6F';
wwv_flow_imp.g_varchar2_table(106) := '7265436C61737329207C7C20242874686973292E706172656E747328292E686173436C6173732872657665616C657249676E6F7265436C61737329293B0D0A202020202020202020207D293B0D0A0D0A202020202020202024286974656D53656C656374';
wwv_flow_imp.g_varchar2_table(107) := '6F72292E656163682866756E6374696F6E202829207B0D0A20202020202020202020202069662028242874686973292E636C6F736573742827237072657469757352657665616C6572496E6C696E6527292E6C656E677468203D3D203020262620242874';
wwv_flow_imp.g_varchar2_table(108) := '686973295B305D2E68617341747472696275746528226964222929207B0D0A202020202020202020202020202020206164644974656D546F4A736F6E2874686973293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(109) := '2020202020202076617220696672616D65437472203D20303B0D0A202020202020202076617220696672616D6553656C6563746F72537472696E67203D2022696672616D653A6E6F74285B69643D7461626C6F636B52657665616C65724672616D655D29';
wwv_flow_imp.g_varchar2_table(110) := '223B0D0A20202020202020202428696672616D6553656C6563746F72537472696E67292E66696C7465722866756E6374696F6E202829207B2072657475726E20242874686973292E706172656E747328272E75692D6469616C6F672D2D6170657827292E';
wwv_flow_imp.g_varchar2_table(111) := '6C656E677468203E20303B207D292E656163682866756E6374696F6E202829207B0D0A20202020202020202020202076617220696E6A65637453656C6563746F72537472696E67203D0D0A2020202020202020202020202020202068746D6C4465636F64';
wwv_flow_imp.g_varchar2_table(112) := '6528617065782E6C616E672E666F726D6174282720242822253022292E66696C7465722866756E6374696F6E2829207B72657475726E20242874686973292E706172656E747328222E75692D6469616C6F672D2D6170657822292E6C656E677468203E20';
wwv_flow_imp.g_varchar2_table(113) := '303B7D295B25315D2E636F6E74656E7457696E646F772E272C0D0A2020202020202020202020202020202020202020696672616D6553656C6563746F72537472696E672C0D0A2020202020202020202020202020202020202020696672616D6543747229';
wwv_flow_imp.g_varchar2_table(114) := '293B0D0A0D0A202020202020202020202020696672616D65437472203D20696672616D65437472202B20313B0D0A20202020202020202020202076617220696672616D6553656C6563746F72203D20746869733B0D0A2020202020202020202020207870';
wwv_flow_imp.g_varchar2_table(115) := '466C6F77537465704964203D20746869732E636F6E74656E7457696E646F772E70466C6F775374657049642E76616C7565202B20275F27202B20696672616D654374723B0D0A202020202020202020202020646973636F76657265645061676573203D20';
wwv_flow_imp.g_varchar2_table(116) := '646973636F76657265645061676573202B20746869732E636F6E74656E7457696E646F772E70466C6F775374657049642E76616C7565202B20273A273B0D0A202020202020202020202020242874686973292E636F6E74656E747328292E66696E642869';
wwv_flow_imp.g_varchar2_table(117) := '74656D537472696E67290D0A2020202020202020202020202E66696C7465722866756E6374696F6E2820696E6465782029207B0D0A2020202020202020202020202020202072657475726E20242874686973295B305D2E68617341747472696275746528';
wwv_flow_imp.g_varchar2_table(118) := '22696422293B0D0A20202020202020202020202020207D290D0A20202020202020202020202020202E656163682866756E6374696F6E202829207B0D0A202020202020202020202020202020206164644974656D546F4A736F6E28746869732C20696E6A';
wwv_flow_imp.g_varchar2_table(119) := '65637453656C6563746F72537472696E67293B0D0A2020202020202020202020207D293B0D0A20202020202020207D293B0D0A0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E';
wwv_flow_imp.g_varchar2_table(120) := '7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965722C207B0D0A2020202020202020202020207830313A202752455645414C4552272C0D0A2020202020202020202020207830323A20646973636F76657265645061';
wwv_flow_imp.g_varchar2_table(121) := '6765732C202F2F7072657469757352657665616C65722E7061676544656C696D6574656428292C0D0A202020202020202020202020705F636C6F625F30313A204A534F4E2E737472696E67696679286A290D0A20202020202020207D2C207B0D0A202020';
wwv_flow_imp.g_varchar2_table(122) := '202020202020202020737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020202020202020202020636C6F6728';
wwv_flow_imp.g_varchar2_table(123) := '64617461293B0D0A20202020202020202020202020202020737061726B557052657665616C6572287B20646174613A20646174612E6974656D73207D293B0D0A2020202020202020202020207D2C0D0A2020202020202020202020206572726F723A2066';
wwv_flow_imp.g_varchar2_table(124) := '756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A202020202020202020202020202020202F2F2068616E646C65206572726F720D0A202020202020202020202020202020207064742E616A61';
wwv_flow_imp.g_varchar2_table(125) := '784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(126) := '737061726B557052657665616C6572286529207B0D0A0D0A2020202020202020766172206D79537472696E674172726179203D207072657469757352657665616C65722E64697374696E6374506167657328652E64617461293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(127) := '766172206A7573745061676573203D2027273B0D0A20202020202020207661722061727261794C656E677468203D206D79537472696E6741727261792E6C656E6774683B0D0A2020202020202020666F7220287661722069203D20303B2069203C206172';
wwv_flow_imp.g_varchar2_table(128) := '7261794C656E6774683B20692B2B29207B0D0A202020202020202020202020696620286D79537472696E6741727261795B695D20213D20272A2729207B0D0A20202020202020202020202020202020242827237072657469757352657665616C6572496E';
wwv_flow_imp.g_varchar2_table(129) := '6C696E6520237072657469757350616765436F6E74726F6C7327292E617070656E6428273C696E70757420747970653D22726164696F22206E616D653D2270466C6F77537465704964222076616C75653D2227202B206D79537472696E6741727261795B';
wwv_flow_imp.g_varchar2_table(130) := '695D202B2027222069643D227061676546696C74657227202B206D79537472696E6741727261795B695D202B202722202F3E27293B0D0A20202020202020202020202020202020242827237072657469757352657665616C6572496E6C696E6520237072';
wwv_flow_imp.g_varchar2_table(131) := '657469757350616765436F6E74726F6C7327292E617070656E6428273C6C6162656C20666F723D227061676546696C74657227202B206D79537472696E6741727261795B695D202B2027223E506167652027202B206D79537472696E6741727261795B69';
wwv_flow_imp.g_varchar2_table(132) := '5D2E73706C697428225F22295B305D202B20273C2F6C6162656C3E27293B0D0A202020202020202020202020202020206A7573745061676573203D206A7573745061676573202B206D79537472696E6741727261795B695D202B20273A273B0D0A202020';
wwv_flow_imp.g_varchar2_table(133) := '2020202020202020207D0D0A20202020202020207D0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7327292E6174747228276A7573745061676573272C20';
wwv_flow_imp.g_varchar2_table(134) := '273A27202B206A7573745061676573293B0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7327292E617070656E6428273C696E70757420747970653D2272';
wwv_flow_imp.g_varchar2_table(135) := '6164696F22206E616D653D2270466C6F77537465704964222069643D227061676546696C746572416C6C222076616C75653D22416C6C22202F3E27293B200D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202370';
wwv_flow_imp.g_varchar2_table(136) := '72657469757350616765436F6E74726F6C7327292E617070656E6428273C6C6162656C20666F723D227061676546696C746572416C6C223E416C6C3C2F6C6162656C3E27293B0D0A0D0A20202020202020202F2F2041646420526573756C74730D0A2020';
wwv_flow_imp.g_varchar2_table(137) := '202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E656D70747928293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469';
wwv_flow_imp.g_varchar2_table(138) := '7573436F6E74656E7427292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528652E6461746129293B0D0A0D0A20202020202020202F2F2041646420616E7920637573746F6D69736174696F6E730D0A2020';
wwv_flow_imp.g_varchar2_table(139) := '2020202020207072657469757352657665616C65722E637573746F6D6973655461626C6528293B0D0A0D0A20202020202020202F2F204164642042696E64730D0A2020202020202020242827237072657469757352657665616C6572496E6C696E652023';
wwv_flow_imp.g_varchar2_table(140) := '72536561726368426F7827292E6B657975702866756E6374696F6E20286529207B207072657469757352657665616C65722E706572666F726D46696C74657228293B207D293B0D0A2020202020202020242827237072657469757352657665616C657249';
wwv_flow_imp.g_varchar2_table(141) := '6E6C696E65202372536561726368426F7827292E6F6E2827736561726368272C2066756E6374696F6E202829207B207072657469757352657665616C65722E706572666F726D46696C74657228293B207D293B0D0A202020202020202024282723707265';
wwv_flow_imp.g_varchar2_table(142) := '7469757352657665616C6572496E6C696E65202372436C656172536561726368426F7827292E6F6E2827636C69636B272C2066756E6374696F6E202829207B0D0A202020202020202020202020617065782E6974656D282772536561726368426F782729';
wwv_flow_imp.g_varchar2_table(143) := '2E73657456616C756528293B0D0A2020202020202020202020207072657469757352657665616C65722E706572666F726D46696C74657228293B0D0A20202020202020207D293B0D0A0D0A2020202020202020242822237072657469757352657665616C';
wwv_flow_imp.g_varchar2_table(144) := '6572496E6C696E6520696E7075745B747970653D726164696F5D22292E636C69636B2866756E6374696F6E202829207B0D0A20202020202020202020202069662028242822237072657469757352657665616C6572496E6C696E6520696E7075745B7479';
wwv_flow_imp.g_varchar2_table(145) := '70653D726164696F5D5B6E616D653D7043617465676F72795D3A636865636B656422292E76616C2829203D3D20224465627567506167652229207B0D0A202020202020202020202020202020207072657469757352657665616C65722E67657444656275';
wwv_flow_imp.g_varchar2_table(146) := '6756696577436F6E74656E7428293B0D0A2020202020202020202020207D20656C7365207B0D0A202020202020202020202020202020207072657469757352657665616C65722E706572666F726D46696C74657228293B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(147) := '207D0D0A20202020202020207D293B0D0A20202020200D0A20202020202020202F2F2044656661756C7420436C69636B730D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D72616469';
wwv_flow_imp.g_varchar2_table(148) := '6F5D5B6E616D653D70466C6F775374657049645D3A666972737422292E747269676765722822636C69636B22293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B';
wwv_flow_imp.g_varchar2_table(149) := '6E616D653D7043617465676F72795D3A666972737422292E6E65787428292E6E65787428292E747269676765722822636C69636B22293B0D0A0D0A20202020202020202F2F204C6F6164696E67206F6666202F2066696C74657273206F6E0D0A20202020';
wwv_flow_imp.g_varchar2_table(150) := '20202020242827237072657469757352657665616C6572496E6C696E65202E72657665616C65722D6C6F6164696E6727292E616464436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A20202020202020202428272370726574';
wwv_flow_imp.g_varchar2_table(151) := '69757352657665616C6572496E6C696E65202E72657665616C65722D68656164657227292E72656D6F7665436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A0D0A20202020202020202F2F466F6375730D0A20202020202020';
wwv_flow_imp.g_varchar2_table(152) := '20242827237072657469757352657665616C6572496E6C696E65202372536561726368426F7827292E666F63757328293B0D0A0D0A2020202020202020696620282077696E646F772E6C6F636174696F6E2E686F7374203D3D2027617065782E6F726163';
wwv_flow_imp.g_varchar2_table(153) := '6C652E636F6D2720297B200D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65206C6162656C5B666F723D22446562756750616765225D27292E616464436C6173732827617065785F64697361626C656427';
wwv_flow_imp.g_varchar2_table(154) := '293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65202344656275675061676527292E706172656E7428292E6174747228277469746C65272C2744697361626C6564206F6E20617065782E6F7261636C';
wwv_flow_imp.g_varchar2_table(155) := '652E636F6D2064756520746F204F52412D303030343027293B0D0A20202020202020207D0D0A0D0A202020207D3B0D0A0D0A2020202066756E6374696F6E2061706578446576546F6F6C62617252657665616C657228704D6F646529207B0D0A0D0A2020';
wwv_flow_imp.g_varchar2_table(156) := '202020202020617065782E7468656D652E6F70656E526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E742D4469616C';
wwv_flow_imp.g_varchar2_table(157) := '6F67526567696F6E2D626F647922292E6C6F6164287064742E6F70742E66696C65507265666978202B202272657665616C65722F72657665616C65722E68746D6C22293B0D0A0D0A2020202020202020242827237072657469757352657665616C657249';
wwv_flow_imp.g_varchar2_table(158) := '6E6C696E65202370726574697573436F6E74656E7427292E656D70747928293B0D0A20202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E75692D6469616C6F672D7469746C6527292E7465787428';
wwv_flow_imp.g_varchar2_table(159) := '27205072657469757320446576656C6F70657220546F6F6C3A2052657665616C657227293B0D0A202020202020202073656E644D6F64616C4D65737361676528293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E206164644869707374';
wwv_flow_imp.g_varchar2_table(160) := '65722829207B0D0A0D0A202020202020202076617220634973546F6F6C62617250726573656E74203D202428222361706578446576546F6F6C62617222292E6C656E677468203E20303B0D0A202020202020202069662028634973546F6F6C6261725072';
wwv_flow_imp.g_varchar2_table(161) := '6573656E7429207B0D0A0D0A202020202020202020202020696620282428272361706578446576546F6F6C626172517569636B4564697427292E6C656E677468203E2030202626202428272361706578446576546F6F6C62617252657665616C65722729';
wwv_flow_imp.g_varchar2_table(162) := '2E6C656E677468203D3D203029207B0D0A0D0A202020202020202020202020202020202F2F2072657665616C657249636F6E48746D6C203D20273C7370616E20636C6173733D22612D49636F6E2066612066612D686970737465722220617269612D6869';
wwv_flow_imp.g_varchar2_table(163) := '6464656E3D2274727565223E3C2F7370616E3E270D0A2020202020202020202020202020202072657665616C657249636F6E48746D6C203D20273C696D67207372633D2227202B207064742E6F70742E66696C65507265666978202B202772657665616C';
wwv_flow_imp.g_varchar2_table(164) := '65722F666F6E7441706578486970737465722D6F2E73766727202B20272227202B0D0A2020202020202020202020202020202027206F6E6C6F61643D227064742E666978546F6F6C626172576964746828293B222027202B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(165) := '2020202020202720636C6173733D227461626C6F636B4869707374657249636F6E22202F3E273B0D0A0D0A20202020202020202020202020202020766172206B62203D207064742E67657453657474696E67282772657665616C65722E6B6227292E746F';
wwv_flow_imp.g_varchar2_table(166) := '4C6F7765724361736528293B0D0A202020202020202020202020202020202428272361706578446576546F6F6C626172517569636B4564697427292E706172656E7428292E6265666F7265280D0A20202020202020202020202020202020202020206874';
wwv_flow_imp.g_varchar2_table(167) := '6D6C4465636F646528617065782E6C616E672E666F726D61744E6F457363617065280D0A202020202020202020202020202020202020202020202020273C6C693E3C627574746F6E2069643D2261706578446576546F6F6C62617252657665616C657222';
wwv_flow_imp.g_varchar2_table(168) := '20747970653D22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C62617222207469746C653D2256696577205061676520496E666F726D6174696F6E205B6374726C2B616C742B25305D2220617269';
wwv_flow_imp.g_varchar2_table(169) := '612D6C6162656C3D22566172732220646174612D6C696E6B3D22223E2027202B0D0A202020202020202020202020202020202020202020202020272531203C7370616E20636C6173733D22612D446576546F6F6C6261722D627574746F6E4C6162656C22';
wwv_flow_imp.g_varchar2_table(170) := '3E52657665616C65723C2F7370616E3E2027202B0D0A202020202020202020202020202020202020202020202020273C2F627574746F6E3E3C2F6C693E272C0D0A2020202020202020202020202020202020202020202020206B622C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(171) := '20202020202020202020202020202020202072657665616C657249636F6E48746D6C0D0A202020202020202020202020202020202020202029290D0A20202020202020202020202020202020293B0D0A0D0A202020202020202020202020202020207661';
wwv_flow_imp.g_varchar2_table(172) := '722068203D20646F63756D656E742E676574456C656D656E7442794964282261706578446576546F6F6C62617252657665616C657222293B0D0A20202020202020202020202020202020696620286829207B0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(173) := '20202020682E6164644576656E744C697374656E65722822636C69636B222C2066756E6374696F6E20286576656E7429207B0D0A20202020202020202020202020202020202020202020202061706578446576546F6F6C62617252657665616C65722829';
wwv_flow_imp.g_varchar2_table(174) := '3B0D0A0D0A20202020202020202020202020202020202020207D2C2074727565293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020207064742E666978546F6F6C626172576964746828293B0D0A202020';
wwv_flow_imp.g_varchar2_table(175) := '202020202020202020202020202F2F20437573746F6D204150455820352E30207769647468206669780D0A202020202020202020202020202020202428272361706578446576546F6F6C62617227292E7769647468282428272E612D446576546F6F6C62';
wwv_flow_imp.g_varchar2_table(176) := '61722D6C69737427292E77696474682829202B2027707827293B0D0A0D0A20202020202020202020202020202020696620287064742E67657453657474696E67282772657665616C65722E6B62272920213D20272729207B0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(177) := '202020202020202020202020696620286B6220213D20222229207B0D0A2020202020202020202020202020202020202020202020202F2F2042696E64206B6579626F6172642073686F7274637574730D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(178) := '20202020204D6F757365747261702E62696E64476C6F62616C28276374726C2B616C742B27202B206B622C2066756E6374696F6E20286529207B0D0A20202020202020202020202020202020202020202020202020202020706172656E742E2428273A66';
wwv_flow_imp.g_varchar2_table(179) := '6F63757327292E626C757228293B0D0A20202020202020202020202020202020202020202020202020202020706172656E742E7064742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F6465203D2066616C73653B0D0A2020';
wwv_flow_imp.g_varchar2_table(180) := '2020202020202020202020202020202020202020202020202020706172656E742E2428222361706578446576546F6F6C62617252657665616C657222292E747269676765722827636C69636B27293B0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(181) := '20202020207D293B0D0A2020202020202020202020202020202020202020202020204D6F757365747261702E62696E64476C6F62616C28276374726C2B616C742B73686966742B27202B206B622C2066756E6374696F6E20286529207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(182) := '202020202020202020202020202020202020202020202069662028706172656E742E2428222361706578446576546F6F6C62617252657665616C657222292E6C656E677468203E203029207B0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(183) := '20202020202020202020706172656E742E2428273A666F63757327292E626C757228293B0D0A2020202020202020202020202020202020202020202020202020202020202020617065782E6D6573736167652E73686F7750616765537563636573732822';
wwv_flow_imp.g_varchar2_table(184) := '4F70656E696E672052657665616C657220696E204465627567204D6F646522293B0D0A2020202020202020202020202020202020202020202020202020202020202020706172656E742E7064742E70726574697573436F6E74656E7452657665616C6572';
wwv_flow_imp.g_varchar2_table(185) := '2E64656275674D6F6465203D20747275653B0D0A2020202020202020202020202020202020202020202020202020202020202020706172656E742E2428222361706578446576546F6F6C62617252657665616C657222292E747269676765722827636C69';
wwv_flow_imp.g_varchar2_table(186) := '636B27293B0D0A202020202020202020202020202020202020202020202020202020207D0D0A2020202020202020202020202020202020202020202020207D293B0D0A20202020202020202020202020202020202020207D0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(187) := '2020202020207D0D0A0D0A0D0A202020202020202020202020202020202F2F2063726970706C65205461626C6F636B2052657665616C65720D0A20202020202020202020202020202020696620287064742E67657453657474696E67282772657665616C';
wwv_flow_imp.g_varchar2_table(188) := '65722E7461626C6F636B646561637469766174652729203D3D2027592729207B0D0A202020202020202020202020202020202020202063726970706C655461624C6F636B52657665616C657228293B0D0A202020202020202020202020202020207D0D0A';
wwv_flow_imp.g_varchar2_table(189) := '0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A0D0A0D0A2020202072657475726E207B0D0A2020202020202020616464486970737465723A20616464486970737465722C0D0A2020202020202020696E6A656374';
wwv_flow_imp.g_varchar2_table(190) := '5363726970743A20696E6A6563745363726970742C0D0A202020202020202064656275674D6F64653A2064656275674D6F64650D0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219974154281840788)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/contentRevealer.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '3C7376672076657273696F6E3D22312E312220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667222077696474683D22313622206865696768743D223132222076696577426F783D22302030203136203134223E0D0A3C';
wwv_flow_imp.g_varchar2_table(2) := '706174682066696C6C3D2277686974652220643D224D31352E3930312031302E393339632D302E3132372D302E3136392D302E3334342D302E32342D302E3534382D302E3137392D302E35333420302E3136342D312E30393320302E32342D312E373620';
wwv_flow_imp.g_varchar2_table(3) := '302E32342D302E37393320302D312E31372D302E3337362D312E3634362D302E3835342D302E3531312D302E35312D312E3134372D312E3134362D322E3335342D312E3134362D302E35393120302D312E31343920302E3231312D312E35393320302E35';
wwv_flow_imp.g_varchar2_table(4) := '39342D302E3434342D302E3338332D312E3030322D302E3539342D312E3539332D302E3539342D312E32303720302D312E38343320302E3633362D322E33353320312E3134362D302E34373720302E3437382D302E38353420302E3835342D312E363437';
wwv_flow_imp.g_varchar2_table(5) := '20302E3835342D302E36363720302D312E3232372D302E3037362D312E3736312D302E32342D302E3230352D302E3036322D302E34323120302E3031302D302E35343820302E3137392D302E31323620302E3136392D302E31333220302E342D302E3031';
wwv_flow_imp.g_varchar2_table(6) := '3520302E35373620312E30353120312E35373920322E36323720322E34383520342E33323420322E34383520312E323134203020322E33352D302E34383120332E3139372D312E33353520302E3232312D302E32323620302E35372D302E32323620302E';
wwv_flow_imp.g_varchar2_table(7) := '373931203020302E38343820302E38373420312E39383420312E33353520332E31393820312E33353520312E363937203020332E3237332D302E39303620342E3332332D322E34383520302E3131372D302E31373620302E3131312D302E3430362D302E';
wwv_flow_imp.g_varchar2_table(8) := '3031352D302E3537367A4D392E3131322031312E393438632D302E3239392D302E3330382D302E3639342D302E3437382D312E3131322D302E343738732D302E38313320302E31372D312E31313220302E343739632D312E33323120312E33362D332E35';
wwv_flow_imp.g_varchar2_table(9) := '383420312E3334352D352E30383720302E30333120302E31393620302E30313320302E33393820302E30323020302E36303620302E30323020312E323037203020312E3834332D302E36333620322E3335342D312E31343620302E3437362D302E343738';
wwv_flow_imp.g_varchar2_table(10) := '20302E3835332D302E38353420312E3634362D302E38353420302E343636203020302E38393920302E32323720312E31383920302E36323220302E31383920302E32353620302E36313720302E32353620302E383037203020302E32392D302E33393520';
wwv_flow_imp.g_varchar2_table(11) := '302E3732342D302E36323220312E31392D302E36323220302E373933203020312E313720302E33373620312E36343620302E38353420302E35313120302E353120312E31343720312E31343620322E33353420312E31343620302E323038203020302E34';
wwv_flow_imp.g_varchar2_table(12) := '312D302E30303720302E3630362D302E3032312D312E35303420312E3331342D332E37363720312E33332D352E3038372D302E3033317A223E3C2F706174683E0D0A3C706174682066696C6C3D2277686974652220643D224D302E36303920332E353436';
wwv_flow_imp.g_varchar2_table(13) := '6C302E35353520322E34393663302E32353620312E31353320312E323620312E39353820322E343420312E39353868302E36353963302E393534203020312E38312D302E35323920322E3233372D312E3338326C312E3330392D322E36313868302E3338';
wwv_flow_imp.g_varchar2_table(14) := '336C312E33303820322E36313863302E34323720302E38353320312E32383320312E33383220322E32333620312E33383268302E36353963312E313831203020322E3138352D302E38303520322E34342D312E3935386C302E3535352D322E3439366330';
wwv_flow_imp.g_varchar2_table(15) := '2E32343420302E30353620302E3439322D302E30373020302E35382D302E333120302E3039342D302E3235392D302E3034312D302E3534362D302E3330312D302E36342D312E3038312D302E33392D322E33352D302E3539362D332E3636392D302E3539';
wwv_flow_imp.g_varchar2_table(16) := '362D312E34383320302D322E35383620302E332D332E3635322031682D302E363936632D312E3036362D302E372D322E3136392D312D332E3635322D312D312E33313920302D322E35383820302E3230362D332E363720302E3539372D302E323620302E';
wwv_flow_imp.g_varchar2_table(17) := '3039342D302E33393520302E33382D302E33303120302E363420302E30383820302E323420302E33333620302E33363420302E353820302E3330397A4D31342E34323620332E3237366C2D302E35363720322E3535632D302E31353320302E3639312D30';
wwv_flow_imp.g_varchar2_table(18) := '2E37353520312E3137342D312E34363320312E313734682D302E363539632D302E35373220302D312E3038362D302E3331382D312E3334322D302E3832396C2D312E3233392D322E34373763302E3832322D302E34373720312E3637362D302E36393420';
wwv_flow_imp.g_varchar2_table(19) := '322E3834342D302E36393420302E383531203020312E36373220302E30393720322E34323620302E3237367A4D362E38343420332E3639346C2D312E32333920322E343737632D302E32353520302E3531312D302E37363920302E3832392D312E333431';
wwv_flow_imp.g_varchar2_table(20) := '20302E383239682D302E3636632D302E37303820302D312E33312D302E3438332D312E3436332D312E3137346C2D302E3536372D322E353563302E3735342D302E31373920312E3537352D302E32373620322E3432362D302E32373620312E3136382030';
wwv_flow_imp.g_varchar2_table(21) := '20322E30323220302E32313720322E38343420302E3639347A223E3C2F706174683E0D0A3C2F7376673E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219974520940840792)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/fontApexHipster-o.svg'
,p_mime_type=>'image/svg+xml'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '3C7376672076657273696F6E3D22312E312220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667222077696474683D22313622206865696768743D223132222076696577426F783D22302030203136203134223E0D0A3C';
wwv_flow_imp.g_varchar2_table(2) := '7061746820643D224D31352E3930312031302E393339632D302E3132372D302E3136392D302E3334342D302E32342D302E3534382D302E3137392D302E35333420302E3136342D312E30393320302E32342D312E373620302E32342D302E37393320302D';
wwv_flow_imp.g_varchar2_table(3) := '312E31372D302E3337362D312E3634362D302E3835342D302E3531312D302E35312D312E3134372D312E3134362D322E3335342D312E3134362D302E35393120302D312E31343920302E3231312D312E35393320302E3539342D302E3434342D302E3338';
wwv_flow_imp.g_varchar2_table(4) := '332D312E3030322D302E3539342D312E3539332D302E3539342D312E32303720302D312E38343320302E3633362D322E33353320312E3134362D302E34373720302E3437382D302E38353420302E3835342D312E36343720302E3835342D302E36363720';
wwv_flow_imp.g_varchar2_table(5) := '302D312E3232372D302E3037362D312E3736312D302E32342D302E3230352D302E3036322D302E34323120302E3031302D302E35343820302E3137392D302E31323620302E3136392D302E31333220302E342D302E30313520302E35373620312E303531';
wwv_flow_imp.g_varchar2_table(6) := '20312E35373920322E36323720322E34383520342E33323420322E34383520312E323134203020322E33352D302E34383120332E3139372D312E33353520302E3232312D302E32323620302E35372D302E32323620302E373931203020302E3834382030';
wwv_flow_imp.g_varchar2_table(7) := '2E38373420312E39383420312E33353520332E31393820312E33353520312E363937203020332E3237332D302E39303620342E3332332D322E34383520302E3131372D302E31373620302E3131312D302E3430362D302E3031352D302E3537367A4D392E';
wwv_flow_imp.g_varchar2_table(8) := '3131322031312E393438632D302E3239392D302E3330382D302E3639342D302E3437382D312E3131322D302E343738732D302E38313320302E31372D312E31313220302E343739632D312E33323120312E33362D332E35383420312E3334352D352E3038';
wwv_flow_imp.g_varchar2_table(9) := '3720302E30333120302E31393620302E30313320302E33393820302E30323020302E36303620302E30323020312E323037203020312E3834332D302E36333620322E3335342D312E31343620302E3437362D302E34373820302E3835332D302E38353420';
wwv_flow_imp.g_varchar2_table(10) := '312E3634362D302E38353420302E343636203020302E38393920302E32323720312E31383920302E36323220302E31383920302E32353620302E36313720302E32353620302E383037203020302E32392D302E33393520302E3732342D302E3632322031';
wwv_flow_imp.g_varchar2_table(11) := '2E31392D302E36323220302E373933203020312E313720302E33373620312E36343620302E38353420302E35313120302E353120312E31343720312E31343620322E33353420312E31343620302E323038203020302E34312D302E30303720302E363036';
wwv_flow_imp.g_varchar2_table(12) := '2D302E3032312D312E35303420312E3331342D332E37363720312E33332D352E3038372D302E3033317A223E3C2F706174683E0D0A3C7061746820643D224D302E36303920332E3534366C302E35353520322E34393663302E32353620312E3135332031';
wwv_flow_imp.g_varchar2_table(13) := '2E323620312E39353820322E343420312E39353868302E36353963302E393534203020312E38312D302E35323920322E3233372D312E3338326C312E3330392D322E36313868302E3338336C312E33303820322E36313863302E34323720302E38353320';
wwv_flow_imp.g_varchar2_table(14) := '312E32383320312E33383220322E32333620312E33383268302E36353963312E313831203020322E3138352D302E38303520322E34342D312E3935386C302E3535352D322E34393663302E32343420302E30353620302E3439322D302E30373020302E35';
wwv_flow_imp.g_varchar2_table(15) := '382D302E333120302E3039342D302E3235392D302E3034312D302E3534362D302E3330312D302E36342D312E3038312D302E33392D322E33352D302E3539362D332E3636392D302E3539362D312E34383320302D322E35383620302E332D332E36353220';
wwv_flow_imp.g_varchar2_table(16) := '31682D302E363936632D312E3036362D302E372D322E3136392D312D332E3635322D312D312E33313920302D322E35383820302E3230362D332E363720302E3539372D302E323620302E3039342D302E33393520302E33382D302E33303120302E363420';
wwv_flow_imp.g_varchar2_table(17) := '302E30383820302E323420302E33333620302E33363420302E353820302E3330397A4D31342E34323620332E3237366C2D302E35363720322E3535632D302E31353320302E3639312D302E37353520312E3137342D312E34363320312E313734682D302E';
wwv_flow_imp.g_varchar2_table(18) := '363539632D302E35373220302D312E3038362D302E3331382D312E3334322D302E3832396C2D312E3233392D322E34373763302E3832322D302E34373720312E3637362D302E36393420322E3834342D302E36393420302E383531203020312E36373220';
wwv_flow_imp.g_varchar2_table(19) := '302E30393720322E34323620302E3237367A4D362E38343420332E3639346C2D312E32333920322E343737632D302E32353520302E3531312D302E37363920302E3832392D312E33343120302E383239682D302E3636632D302E37303820302D312E3331';
wwv_flow_imp.g_varchar2_table(20) := '2D302E3438332D312E3436332D312E3137346C2D302E3536372D322E353563302E3735342D302E31373920312E3537352D302E32373620322E3432362D302E32373620312E313638203020322E30323220302E32313720322E38343420302E3639347A22';
wwv_flow_imp.g_varchar2_table(21) := '3E3C2F706174683E0D0A3C2F7376673E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219974953662840801)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/fontApexHipster.svg'
,p_mime_type=>'image/svg+xml'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A0D0A202A204A5175657279205549204469616C6F6720657874656E6420746F2061646420636F6C6C61707365206361706162696C697479204353532E0D0A202A0D0A202A20436F7079726967687420323031332E20204D61726B6F204D617274696E';
wwv_flow_imp.g_varchar2_table(2) := '6F7669C4870D0A202A20687474703A2F2F7777772E746563687974616C6B2E696E666F0D0A202A2F0D0A0D0A2E75692D6469616C6F67202E75692D6469616C6F672D7469746C656261722D636F6C6C617073652C0D0A2E75692D6469616C6F67202E7569';
wwv_flow_imp.g_varchar2_table(3) := '2D6469616C6F672D7469746C656261722D636F6C6C617073652D726573746F7265207B0D0A09706F736974696F6E3A206162736F6C7574653B0D0A0972696768743A20302E33656D3B0D0A09746F703A203530253B0D0A0977696474683A20323170783B';
wwv_flow_imp.g_varchar2_table(4) := '0D0A096D617267696E3A202D313070782030203020303B0D0A0970616464696E673A203170783B0D0A096865696768743A20323070783B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219975310738840804)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/jquery.ui.dialog-collapse.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A0D0A202A20457874656E6473204A5175657279205549204469616C6F6720746F2061646420636F6C6C6170736520627574746F6E20666561747572652E0D0A202A0D0A202A20436F7079726967687420323031332E20204D61726B6F204D61727469';
wwv_flow_imp.g_varchar2_table(2) := '6E6F7669C4870D0A202A20687474703A2F2F7777772E746563687974616C6B2E696E666F0D0A202A2F0D0A2866756E6374696F6E282429207B0D0A202020202F2F204164642064656661756C74206F7074696F6E7320616E64206576656E742063616C6C';
wwv_flow_imp.g_varchar2_table(3) := '6261636B730D0A20202020242E657874656E6428242E75692E6469616C6F672E70726F746F747970652E6F7074696F6E732C207B0D0A2020202020202020636F6C6C61707365456E61626C65643A206E756C6C2C0D0A20202020202020206265666F7265';
wwv_flow_imp.g_varchar2_table(4) := '436F6C6C617073653A206E756C6C2C0D0A2020202020202020636F6C6C617073653A206E756C6C2C0D0A20202020202020206265666F7265436F6C6C61707365526573746F72653A206E756C6C2C0D0A2020202020202020636F6C6C6170736552657374';
wwv_flow_imp.g_varchar2_table(5) := '6F72653A206E756C6C0D0A202020207D293B0D0A0D0A202020202F2F204261636B7570206F6C64205F696E69740D0A20202020766172205F696E6974203D20242E75692E6469616C6F672E70726F746F747970652E5F696E69743B0D0A0D0A202020202F';
wwv_flow_imp.g_varchar2_table(6) := '2F204E6577205F696E69740D0A20202020242E75692E6469616C6F672E70726F746F747970652E5F696E6974203D2066756E6374696F6E2829207B0D0A20202020202020202F2F204170706C79206F6C64205F696E69740D0A20202020202020205F696E';
wwv_flow_imp.g_varchar2_table(7) := '69742E6170706C7928746869732C20617267756D656E7473293B0D0A0D0A20202020202020202F2F20486F6C6473206F726967696E616C20746869732E6F7074696F6E732E726573697A61626C650D0A202020202020202076617220726573697A61626C';
wwv_flow_imp.g_varchar2_table(8) := '654F6C64203D206E756C6C3B0D0A2020202020202020696628746869732E6F7074696F6E732E636F6C6C61707365456E61626C656429207B0D0A202020202020202020202020746869732E616464436F6C6C61707365427574746F6E203D2066756E6374';
wwv_flow_imp.g_varchar2_table(9) := '696F6E2829207B0D0A202020202020202020202020202020202F2F20486964652074686520726573746F726520627574746F6E206966206974206578697374730D0A20202020202020202020202020202020696628746869732E75694469616C6F675469';
wwv_flow_imp.g_varchar2_table(10) := '746C65626172436F6C6C61707365526573746F7265290D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652E6869646528293B0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(11) := '20202020202020202F2F204164642074686520636F6C6C6170736520627574746F6E20696620697420646F65736E2774206578697374730D0A2020202020202020202020202020202069662821746869732E75694469616C6F675469746C65626172436F';
wwv_flow_imp.g_varchar2_table(12) := '6C6C6170736529207B0D0A0D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C61707365203D2024280D0A2020202020202020202020202020202020202020273C627574746F6E207479';
wwv_flow_imp.g_varchar2_table(13) := '70653D22627574746F6E22207469746C653D22436F6D70726573732220617269612D6C6162656C3D22436F6D70726573732220636C6173733D2270726574697573436F6D707265737342746E20742D427574746F6E20742D427574746F6E2D2D6E6F4C61';
wwv_flow_imp.g_varchar2_table(14) := '62656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D22742D49636F6E2066612066612D636F6D7072657373223E3C2F7370616E3E3C2F';
wwv_flow_imp.g_varchar2_table(15) := '627574746F6E3E270D0A2020202020202020202020202020202020202020290D0A20202020202020202020202020202020202020202E617070656E64546F2820746869732E75694469616C6F675469746C6562617220290D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(16) := '2020202020202020202E696E736572744265666F726528202428746869732E75694469616C6F675469746C65626172292E66696E642820272E75692D6469616C6F672D7469746C656261722D636C6F736527202920293B0D0A0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(17) := '2020202020202020202020746869732E5F6F6E2820746869732E75694469616C6F675469746C65626172436F6C6C617073652C207B0D0A2020202020202020202020202020202020202020202020202F2F2052756E20746869732E636F6C6C6170736520';
wwv_flow_imp.g_varchar2_table(18) := '6F6E20636C69636B0D0A202020202020202020202020202020202020202020202020636C69636B3A2066756E6374696F6E28206576656E742029207B0D0A202020202020202020202020202020202020202020202020202020206576656E742E70726576';
wwv_flow_imp.g_varchar2_table(19) := '656E7444656661756C7428293B0D0A20202020202020202020202020202020202020202020202020202020746869732E636F6C6C6170736528206576656E7420293B0D0A2020202020202020202020202020202020202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(20) := '2020202020202020202020202020207D293B0D0A202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C617073652E73686F77';
wwv_flow_imp.g_varchar2_table(21) := '28293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020746869732E616464436F6C6C61707365526573746F7265427574746F6E203D2066756E6374696F6E2829207B0D0A20';
wwv_flow_imp.g_varchar2_table(22) := '2020202020202020202020202020202F2F20486964652074686520636F6C6C6170736520627574746F6E206966206974206578697374730D0A20202020202020202020202020202020696628746869732E75694469616C6F675469746C65626172436F6C';
wwv_flow_imp.g_varchar2_table(23) := '6C61707365290D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C617073652E6869646528293B0D0A0D0A202020202020202020202020202020202F2F20416464207468652072657374';
wwv_flow_imp.g_varchar2_table(24) := '6F726520627574746F6E20696620697420646F65736E2774206578697374730D0A2020202020202020202020202020202069662821746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F7265297B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(25) := '20202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F7265203D2024280D0A202020202020202020202020202020202020202020202020273C627574746F6E20747970653D22627574746F';
wwv_flow_imp.g_varchar2_table(26) := '6E22207469746C653D22457870616E642220617269612D6C6162656C3D22457870616E642220636C6173733D2270726574697573457870616E6442746E20742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69';
wwv_flow_imp.g_varchar2_table(27) := '636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D22742D49636F6E2066612066612D657870616E64223E3C2F7370616E3E3C2F627574746F6E3E270D0A20202020202020';
wwv_flow_imp.g_varchar2_table(28) := '2020202020202020202020202020202020290D0A20202020202020202020202020202020202020202E696E736572744265666F726528202428746869732E75694469616C6F675469746C65626172292E66696E642820272E75692D6469616C6F672D7469';
wwv_flow_imp.g_varchar2_table(29) := '746C656261722D636C6F736527202920293B0D0A2020202020202020202020202020202020202020746869732E5F6F6E2820746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652C207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(30) := '2020202020202020202020202020202F2F2052756E20746869732E726573746F7265206F6E20636C69636B0D0A202020202020202020202020202020202020202020202020636C69636B3A2066756E6374696F6E28206576656E742029207B0D0A202020';
wwv_flow_imp.g_varchar2_table(31) := '202020202020202020202020202020202020202020202020206576656E742E70726576656E7444656661756C7428293B0D0A20202020202020202020202020202020202020202020202020202020746869732E726573746F726528206576656E7420293B';
wwv_flow_imp.g_varchar2_table(32) := '0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(33) := '746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652E73686F7728293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020746869732E63';
wwv_flow_imp.g_varchar2_table(34) := '6F6C6C61707365203D2066756E6374696F6E286576656E7429207B0D0A202020202020202020202020202020207661722073656C66203D20746869733B0D0A0D0A202020202020202020202020202020202F2F20416C6C6F772070656F706C6520746F20';
wwv_flow_imp.g_varchar2_table(35) := '61626F727420636F6C6C61707365206576656E740D0A202020202020202020202020202020206966202866616C7365203D3D3D2073656C662E5F7472696767657228276265666F7265436F6C6C61707365272929207B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(36) := '202020202020202072657475726E3B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F20736C696465557020746865206469616C6F6720656C656D656E740D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(37) := '20746869732E656C656D656E742E736C6964655570282766617374272C2066756E6374696F6E2829207B0D0A20202020202020202020202020202020202020202F2F204465616C20776974682074686520726573697A61626C65206F7074696F6E0D0A20';
wwv_flow_imp.g_varchar2_table(38) := '2020202020202020202020202020202020202069662873656C662E6F7074696F6E732E726573697A61626C65297B0D0A2020202020202020202020202020202020202020202020202F2F204261636B7570206F6C6420726573697A61626C65206F707469';
wwv_flow_imp.g_varchar2_table(39) := '6F6E0D0A202020202020202020202020202020202020202020202020726573697A61626C654F6C64203D2073656C662E6F7074696F6E732E726573697A61626C653B0D0A0D0A2020202020202020202020202020202020202020202020202F2F20446573';
wwv_flow_imp.g_varchar2_table(40) := '74726F792074686520726573697A61626C6520616E6420736574206469616C6F672068656967687420746F206175746F0D0A20202020202020202020202020202020202020202020202073656C662E75694469616C6F672E726573697A61626C65282764';
wwv_flow_imp.g_varchar2_table(41) := '657374726F7927292E6373732827686569676874272C20276175746F27293B0D0A0D0A2020202020202020202020202020202020202020202020202F2F204F7665727772697465206F726967696E616C20726573697A61626C65206F7074696F6E20746F';
wwv_flow_imp.g_varchar2_table(42) := '2064697361626C6520766572746963616C20726573697A650D0A20202020202020202020202020202020202020202020202073656C662E6F7074696F6E732E726573697A61626C65203D2027652C2077273B0D0A0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(43) := '202020202020202020202F2F204D616B6520726573697A61626C65207769746820746865206E657720726573697A61626C65206F7074696F6E0D0A20202020202020202020202020202020202020202020202073656C662E5F6D616B65526573697A6162';
wwv_flow_imp.g_varchar2_table(44) := '6C6528293B0D0A20202020202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202F2F205265706C61636520636F6C6C6170736520627574746F6E207769746820726573746F726520627574746F6E0D0A';
wwv_flow_imp.g_varchar2_table(45) := '202020202020202020202020202020202020202073656C662E616464436F6C6C61707365526573746F7265427574746F6E28293B0D0A0D0A20202020202020202020202020202020202020202F2F205472696767657220636F6C6C61707365206576656E';
wwv_flow_imp.g_varchar2_table(46) := '740D0A202020202020202020202020202020202020202073656C662E5F747269676765722827636F6C6C6170736527293B0D0A202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202072657475726E2073656C';
wwv_flow_imp.g_varchar2_table(47) := '663B0D0A2020202020202020202020207D3B0D0A0D0A202020202020202020202020746869732E726573746F7265203D2066756E6374696F6E286576656E7429207B0D0A202020202020202020202020202020207661722073656C66203D20746869733B';
wwv_flow_imp.g_varchar2_table(48) := '0D0A0D0A202020202020202020202020202020202F2F20416C6C6F772070656F706C6520746F2061626F727420726573746F7265206576656E740D0A202020202020202020202020202020206966202866616C7365203D3D3D2073656C662E5F74726967';
wwv_flow_imp.g_varchar2_table(49) := '67657228276265666F7265436F6C6C61707365526573746F7265272929207B0D0A20202020202020202020202020202020202020202020202072657475726E3B0D0A202020202020202020202020202020207D0D0A0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(50) := '2020202F2F20736C696465446F776E20746865206469616C6F6720656C656D656E740D0A20202020202020202020202020202020746869732E656C656D656E742E736C696465446F776E282766617374272C2066756E6374696F6E2829207B0D0A202020';
wwv_flow_imp.g_varchar2_table(51) := '20202020202020202020202020202020202F2F204465616C20776974682074686520726573697A61626C65206F7074696F6E0D0A202020202020202020202020202020202020202069662873656C662E6F7074696F6E732E726573697A61626C65297B0D';
wwv_flow_imp.g_varchar2_table(52) := '0A2020202020202020202020202020202020202020202020202F2F2044657374726F79206F757220686F72697A6F6E74616C206F6E6C7920726573697A650D0A20202020202020202020202020202020202020202020202073656C662E75694469616C6F';
wwv_flow_imp.g_varchar2_table(53) := '672E726573697A61626C65282764657374726F7927293B0D0A0D0A2020202020202020202020202020202020202020202020202F2F20526573746F7265206F726967696E616C20726573697A61626C65206F7074696F6E2066726F6D206261636B75700D';
wwv_flow_imp.g_varchar2_table(54) := '0A20202020202020202020202020202020202020202020202073656C662E6F7074696F6E732E726573697A61626C65203D20726573697A61626C654F6C643B0D0A0D0A2020202020202020202020202020202020202020202020202F2F204D616B652072';
wwv_flow_imp.g_varchar2_table(55) := '6573697A61626C65207769746820746865206F726967696E616C20726573697A61626C65206F7074696F6E0D0A20202020202020202020202020202020202020202020202073656C662E5F6D616B65526573697A61626C6528293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(56) := '202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202F2F205265706C61636520726573746F726520627574746F6E207769746820636F6C6C6170736520627574746F6E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(57) := '20202020202073656C662E616464436F6C6C61707365427574746F6E28293B0D0A0D0A20202020202020202020202020202020202020202F2F205472696767657220636F6C6C61707365206576656E740D0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(58) := '202073656C662E5F747269676765722827636F6C6C61707365526573746F726527293B0D0A202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202072657475726E2073656C663B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(59) := '20207D3B0D0A0D0A2020202020202020202020202F2F2042792064656661756C742061646420626F746820627574746F6E732C20636F6C6C6170736520627574746F6E2077696C6C206869646520726573746F72650D0A20202020202020202020202074';
wwv_flow_imp.g_varchar2_table(60) := '6869732E616464436F6C6C61707365526573746F7265427574746F6E28293B0D0A202020202020202020202020746869732E616464436F6C6C61707365427574746F6E28293B0D0A0D0A2020202020202020202020202F2F204465616C20776974682063';
wwv_flow_imp.g_varchar2_table(61) := '6F6C6C6170736520616E6420726573746F726520627574746F6E7320706F736974696F6E20696620636C6F736520627574746F6E2069732076697369626C650D0A202020202020202020202020696628746869732E75694469616C6F675469746C656261';
wwv_flow_imp.g_varchar2_table(62) := '72436C6F736520262620746869732E75694469616C6F675469746C65626172436C6F73652E697328273A76697369626C65272929207B0D0A20202020202020202020202020202020766172207269676874203D207061727365466C6F617428746869732E';
wwv_flow_imp.g_varchar2_table(63) := '75694469616C6F675469746C65626172436C6F73652E637373282772696768742729293B0D0A0D0A202020202020202020202020202020202428272E75692D6469616C6F672D7469746C656261722D636F6C6C617073652C202E75692D6469616C6F672D';
wwv_flow_imp.g_varchar2_table(64) := '7469746C656261722D636F6C6C617073652D726573746F726527290D0A20202020202020202020202020202020202020202E63737328277269676874272C20322A72696768742B746869732E75694469616C6F675469746C65626172436C6F73652E6F75';
wwv_flow_imp.g_varchar2_table(65) := '746572576964746828292B27707827293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D3B0D0A7D286A517565727929293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219975739196840809)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/jquery.ui.dialog-collapse.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E7452657665616C65723D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E20652865297B76617220743D646F63756D656E742E637265617465456C656D656E7428227465787461';
wwv_flow_imp.g_varchar2_table(2) := '72656122293B72657475726E20742E696E6E657248544D4C3D652C303D3D3D742E6368696C644E6F6465732E6C656E6774683F22223A742E6368696C644E6F6465735B305D2E6E6F646556616C75657D66756E6374696F6E207428652C74297B76617220';
wwv_flow_imp.g_varchar2_table(3) := '613D646F63756D656E742E637265617465456C656D656E74282273637269707422293B612E69643D22746D70536372697074223B76617220723D646F63756D656E742E637265617465546578744E6F646528222866756E6374696F6E2829207B222B652B';
wwv_flow_imp.g_varchar2_table(4) := '227D2928293B22293B612E617070656E644368696C642872292C2428646F63756D656E742E626F64797C7C646F63756D656E742E68656164292E6C656E6774683E30262628646F63756D656E742E626F64797C7C646F63756D656E742E68656164292E61';
wwv_flow_imp.g_varchar2_table(5) := '7070656E644368696C642861292C24282223746D7053637269707422292E72656D6F766528297D66756E6374696F6E206128297B636F6E737420653D646F63756D656E742E676574456C656D656E7442794964282261706578446576546F6F6C62617222';
wwv_flow_imp.g_varchar2_table(6) := '292C743D7B617474726962757465733A21302C6368696C644C6973743A21302C737562747265653A21307D2C613D66756E6374696F6E28652C74297B2428222361706578446576546F6F6C6261725661727322292E6C656E6774683E3026262824282223';
wwv_flow_imp.g_varchar2_table(7) := '61706578446576546F6F6C6261725661727322292E636C6F7365737428226C6922292E7265706C6163655769746828292C692E646973636F6E6E6563742829297D2C723D66756E6374696F6E28652C74297B242827626F647920696672616D655B69643D';
wwv_flow_imp.g_varchar2_table(8) := '227461626C6F636B52657665616C65724672616D65225D27292E6C656E6774683E30262628242827626F647920696672616D655B69643D227461626C6F636B52657665616C65724672616D65225D27292E7265706C6163655769746828292C6C2E646973';
wwv_flow_imp.g_varchar2_table(9) := '636F6E6E6563742829297D2C693D6E6577204D75746174696F6E4F627365727665722861292C6C3D6E6577204D75746174696F6E4F627365727665722872293B692E6F62736572766528652C74292C6C2E6F62736572766528242822626F647922295B30';
wwv_flow_imp.g_varchar2_table(10) := '5D2C74297D66756E6374696F6E20722865297B7064742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F64652626636F6E736F6C652E6C6F672865297D66756E6374696F6E206928297B66756E6374696F6E206128612C6C3D';
wwv_flow_imp.g_varchar2_table(11) := '2222297B766172206F3D7B7D2C6E3D22242827626F647927292E617474722827746D705F78272C20222B6C2B22617065782E6974656D282770466C6F7753746570496427292E67657456616C75652829293B223B74286E293B76617220703D242822626F';
wwv_flow_imp.g_varchar2_table(12) := '647922292E617474722822746D705F7822293B242822626F647922292E72656D6F7665417474722822746D705F7822292C722861293B76617220733D702E73706C697428225F22295B305D3B6F2E506167653D702C6F2E4E616D653D612E69643B6E3D65';
wwv_flow_imp.g_varchar2_table(13) := '28617065782E6C616E672E666F726D617428227661722072657665616C65724974656D203D202530617065782E6974656D2827253127293B207661722072657665616C657256616C75654974656D203D2072657665616C65724974656D2E67657456616C';
wwv_flow_imp.g_varchar2_table(14) := '756528293B207661722072657665616C657254797065203D2072657665616C65724974656D2E6974656D5F747970653B207661722072657665616C657256616C75654974656D537472696E673B20696620282072657665616C657256616C75654974656D';
wwv_flow_imp.g_varchar2_table(15) := '20696E7374616E63656F6620417272617929207B202020202072657665616C657256616C75654974656D537472696E67203D2072657665616C657256616C75654974656D2E6A6F696E28273A27293B207D20656C7365207B202020202072657665616C65';
wwv_flow_imp.g_varchar2_table(16) := '7256616C75654974656D537472696E67203D2072657665616C657256616C75654974656D3B207D20242827626F647927292E617474722827746D705F7461624C6F636B4361736556616C7565272C2072657665616C657256616C75654974656D53747269';
wwv_flow_imp.g_varchar2_table(17) := '6E67293B20242827626F647927292E617474722827746D705F7461624C6F636B4361736554797065272C202072657665616C657254797065293B20222C6C2C6F2E4E616D6529293B69662874286E292C6F2E547970653D242822626F647922292E617474';
wwv_flow_imp.g_varchar2_table(18) := '722822746D705F7461624C6F636B436173655479706522292C6F2E56616C75653D242822626F647922292E617474722822746D705F7461624C6F636B4361736556616C756522292C242822626F647922292E72656D6F7665417474722822746D705F7461';
wwv_flow_imp.g_varchar2_table(19) := '624C6F636B4361736556616C756522292C242822626F647922292E72656D6F7665417474722822746D705F7461624C6F636B436173655479706522292C22223D3D6F2E56616C75652626286F2E56616C75653D612E76616C7565292C6F2E547970652626';
wwv_flow_imp.g_varchar2_table(20) := '286F2E547970653D6F2E547970652E746F5570706572436173652829292C22223D3D6F2E4E616D65297B76617220633D242861292E636C6F73657374282264697622292E617474722822636C61737322293B696628632626632E73746172747357697468';
wwv_flow_imp.g_varchar2_table(21) := '2822636F6C6F727069636B65722229297B76617220643D242861292E636C6F7365737428222E636F6C6F727069636B657222292E617474722822696422293B6F2E4E616D653D642B22203E20222B632E73706C697428222022295B305D2E7265706C6163';
wwv_flow_imp.g_varchar2_table(22) := '652822636F6C6F727069636B65725F222C2222292C6F2E547970653D22494E50555420286173736F632E207769746820434F4C4F525F5049434B455229227D7D696628242861292E686173436C61737328226F6A2D636F6D706F6E656E742D696E69746E';
wwv_flow_imp.g_varchar2_table(23) := '6F646522292626286F2E547970652B3D2220286173736F632E2077697468204155544F5F434F4D504C4554452922292C2246414C5345223D3D6F2E5479706526262828242861292E686173436C6173732822617065782D6974656D2D67726F75702D2D73';
wwv_flow_imp.g_varchar2_table(24) := '776974636822297C7C242861292E686173436C6173732822617065782D6974656D2D7965732D6E6F2229292626286F2E547970653D2253574954434822292C242861292E686173436C6173732822617065782D6974656D2D67726F75702D2D6175746F2D';
wwv_flow_imp.g_varchar2_table(25) := '636F6D706C65746522292626286F2E547970653D224155544F5F434F4D504C45544522292C242861292E686173436C6173732822612D427574746F6E2D2D6C6973744D616E6167657222292626286F2E4E616D653D223E20222B6F2E56616C75652C6F2E';
wwv_flow_imp.g_varchar2_table(26) := '547970653D22286173736F632E2077697468204C4953545F4D414E414745522922292C242861292E697328226669656C6473657422292626242861292E6368696C6472656E28222E617065782D6974656D2D74657874617265613A666972737422292E6C';
wwv_flow_imp.g_varchar2_table(27) := '656E6774683E302626286F2E547970653D22286173736F632E20776974682054455854415245412922292C22223D3D6F2E4E616D6529297B6F2E4E616D653D242861292E6174747228226E616D6522293B766172206D3D242861292E6174747228227479';
wwv_flow_imp.g_varchar2_table(28) := '706522293B6D2626286F2E547970653D6D2E746F5570706572436173652829297D6966282248494444454E223D3D6F2E5479706526262D313D3D762E696E6465784F66286F2E4E616D65292626242861292E6E65787428292E66696E6428222E61706578';
wwv_flow_imp.g_varchar2_table(29) := '2D6974656D2D706F7075702D6C6F762C202E706F7075705F6C6F7622292E6C656E6774683E302626286F2E547970652B3D2220286173736F632E207769746820504F5055505F4C4F562922292C2253454C454354223D3D6F2E5479706526262824286129';
wwv_flow_imp.g_varchar2_table(30) := '2E686173436C617373282273687574746C655F6C65667422297C7C242861292E686173436C617373282273687574746C655F72696768742229292626286F2E547970652B3D2220286173736F632E20776974682053485554544C452922292C22504F5055';
wwv_flow_imp.g_varchar2_table(31) := '505F4C4F56223D3D6F2E54797065262628242861292E636C6F7365737428226669656C6473657422292E706172656E7428292E636C6F7365737428226669656C6473657422292E686173436C6173732822617065782D6974656D2D6C6973742D6D616E61';
wwv_flow_imp.g_varchar2_table(32) := '67657222292626286F2E547970652B3D2220286173736F632E20776974682053454C4543542F4C4953545F4D414E414745522922292C2241646420456E747279223D3D242861292E6174747228227469746C6522292626242861292E69732822696E7075';
wwv_flow_imp.g_varchar2_table(33) := '7422292626242861292E697328275B6964243D22414444225D27292626286F2E547970652B3D2220286173736F632E2077697468204C4953545F4D414E41474552292229292C22444953504C41595F4F4E4C59223D3D6F2E54797065297B76617220673D';
wwv_flow_imp.g_varchar2_table(34) := '242861292E7369626C696E67732827696E7075745B747970653D2268696464656E225D3A666972737427292E617474722822696422293B67262624282223222B672E7265706C61636528225F444953504C4159222C222229292626286F2E547970652B3D';
wwv_flow_imp.g_varchar2_table(35) := '2220286173736F632E207769746820444953504C41595F4F4E4C592922297D76617220623D242E696E4172726179286F2E547970652C75293B612E636C6F7365737428225B636C6173735E3D27612D495252275D22293F6F2E43617465676F72793D2249';
wwv_flow_imp.g_varchar2_table(36) := '52223A612E636C6F7365737428225B636C6173735E3D27612D4947275D22293F6F2E43617465676F72793D224947223A762E696E6465784F66286F2E4E616D65293E3D303F6F2E43617465676F72793D224657223A6F2E4E616D6526266F2E4E616D652E';
wwv_flow_imp.g_varchar2_table(37) := '73746172747357697468282250222B73292626623E2D313F6F2E43617465676F72793D2250492C5058223A6F2E4E616D6526266F2E4E616D652E737461727473576974682822503022292626623E2D313F6F2E43617465676F72793D2250492C5030223A';
wwv_flow_imp.g_varchar2_table(38) := '6F2E43617465676F72793D2250492C504F222C692E70757368286F297D76617220693D5B5D2C6F3D223A222C6E3D22242827626F647927292E617474722827746D705F78272C20617065782E6974656D282770466C6F7753746570496427292E67657456';
wwv_flow_imp.g_varchar2_table(39) := '616C75652829293B223B74286E293B76617220703D242822626F647922292E617474722822746D705F7822293B242822626F647922292E72656D6F7665417474722822746D705F7822292C6F3D6F2B702B223A223B76617220733D242863292E66696C74';
wwv_flow_imp.g_varchar2_table(40) := '65722866756E6374696F6E28297B72657475726E2128242874686973292E686173436C6173732864297C7C242874686973292E706172656E747328292E686173436C617373286429297D293B242873292E656163682866756E6374696F6E28297B303D3D';
wwv_flow_imp.g_varchar2_table(41) := '242874686973292E636C6F736573742822237072657469757352657665616C6572496E6C696E6522292E6C656E6774682626242874686973295B305D2E6861734174747269627574652822696422292626612874686973297D293B766172206D3D302C67';
wwv_flow_imp.g_varchar2_table(42) := '3D22696672616D653A6E6F74285B69643D7461626C6F636B52657665616C65724672616D655D29223B242867292E66696C7465722866756E6374696F6E28297B72657475726E20242874686973292E706172656E747328222E75692D6469616C6F672D2D';
wwv_flow_imp.g_varchar2_table(43) := '6170657822292E6C656E6774683E307D292E656163682866756E6374696F6E28297B76617220743D6528617065782E6C616E672E666F726D6174282720242822253022292E66696C7465722866756E6374696F6E2829207B72657475726E202428746869';
wwv_flow_imp.g_varchar2_table(44) := '73292E706172656E747328222E75692D6469616C6F672D2D6170657822292E6C656E677468203E20303B7D295B25315D2E636F6E74656E7457696E646F772E272C672C6D29293B6D2B3D313B703D746869732E636F6E74656E7457696E646F772E70466C';
wwv_flow_imp.g_varchar2_table(45) := '6F775374657049642E76616C75652B225F222B6D2C6F3D6F2B746869732E636F6E74656E7457696E646F772E70466C6F775374657049642E76616C75652B223A222C242874686973292E636F6E74656E747328292E66696E642863292E66696C74657228';
wwv_flow_imp.g_varchar2_table(46) := '66756E6374696F6E2865297B72657475726E20242874686973295B305D2E6861734174747269627574652822696422297D292E656163682866756E6374696F6E28297B6128746869732C74297D297D292C7064742E636C6F616B44656275674C6576656C';
wwv_flow_imp.g_varchar2_table(47) := '28292C617065782E7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965722C7B7830313A2252455645414C4552222C7830323A6F2C705F636C6F625F30313A4A534F4E2E737472696E676966792869297D2C7B737563';
wwv_flow_imp.g_varchar2_table(48) := '636573733A66756E6374696F6E2865297B7064742E756E436C6F616B44656275674C6576656C28292C722865292C6C287B646174613A652E6974656D737D297D2C6572726F723A66756E6374696F6E28652C742C61297B7064742E616A61784572726F72';
wwv_flow_imp.g_varchar2_table(49) := '48616E646C657228652C742C61297D7D297D66756E6374696F6E206C2865297B666F722876617220743D7072657469757352657665616C65722E64697374696E6374506167657328652E64617461292C613D22222C723D742E6C656E6774682C693D303B';
wwv_flow_imp.g_varchar2_table(50) := '693C723B692B2B29222A22213D745B695D262628242822237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7322292E617070656E6428273C696E70757420747970653D22726164696F22206E616D';
wwv_flow_imp.g_varchar2_table(51) := '653D2270466C6F77537465704964222076616C75653D22272B745B695D2B27222069643D227061676546696C746572272B745B695D2B2722202F3E27292C242822237072657469757352657665616C6572496E6C696E6520237072657469757350616765';
wwv_flow_imp.g_varchar2_table(52) := '436F6E74726F6C7322292E617070656E6428273C6C6162656C20666F723D227061676546696C746572272B745B695D2B27223E5061676520272B745B695D2E73706C697428225F22295B305D2B223C2F6C6162656C3E22292C613D612B745B695D2B223A';
wwv_flow_imp.g_varchar2_table(53) := '22293B242822237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7322292E6174747228226A7573745061676573222C223A222B61292C242822237072657469757352657665616C6572496E6C696E';
wwv_flow_imp.g_varchar2_table(54) := '6520237072657469757350616765436F6E74726F6C7322292E617070656E6428273C696E70757420747970653D22726164696F22206E616D653D2270466C6F77537465704964222069643D227061676546696C746572416C6C222076616C75653D22416C';
wwv_flow_imp.g_varchar2_table(55) := '6C22202F3E27292C242822237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7322292E617070656E6428273C6C6162656C20666F723D227061676546696C746572416C6C223E416C6C3C2F6C6162';
wwv_flow_imp.g_varchar2_table(56) := '656C3E27292C242822237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7422292E656D70747928292C242822237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7422';
wwv_flow_imp.g_varchar2_table(57) := '292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528652E6461746129292C7072657469757352657665616C65722E637573746F6D6973655461626C6528292C242822237072657469757352657665616C65';
wwv_flow_imp.g_varchar2_table(58) := '72496E6C696E65202372536561726368426F7822292E6B657975702866756E6374696F6E2865297B7072657469757352657665616C65722E706572666F726D46696C74657228297D292C242822237072657469757352657665616C6572496E6C696E6520';
wwv_flow_imp.g_varchar2_table(59) := '2372536561726368426F7822292E6F6E2822736561726368222C66756E6374696F6E28297B7072657469757352657665616C65722E706572666F726D46696C74657228297D292C242822237072657469757352657665616C6572496E6C696E6520237243';
wwv_flow_imp.g_varchar2_table(60) := '6C656172536561726368426F7822292E6F6E2822636C69636B222C66756E6374696F6E28297B617065782E6974656D282272536561726368426F7822292E73657456616C756528292C7072657469757352657665616C65722E706572666F726D46696C74';
wwv_flow_imp.g_varchar2_table(61) := '657228297D292C242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D22292E636C69636B2866756E6374696F6E28297B22446562756750616765223D3D242822237072657469757352657665616C';
wwv_flow_imp.g_varchar2_table(62) := '6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A636865636B656422292E76616C28293F7072657469757352657665616C65722E676574446562756756696577436F6E74656E7428293A707265';
wwv_flow_imp.g_varchar2_table(63) := '7469757352657665616C65722E706572666F726D46696C74657228297D292C242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F775374657049645D3A66697273742229';
wwv_flow_imp.g_varchar2_table(64) := '2E747269676765722822636C69636B22292C242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A666972737422292E6E65787428292E6E65787428292E';
wwv_flow_imp.g_varchar2_table(65) := '747269676765722822636C69636B22292C242822237072657469757352657665616C6572496E6C696E65202E72657665616C65722D6C6F6164696E6722292E616464436C61737328227377697463682D646973706C61792D6E6F6E6522292C2428222370';
wwv_flow_imp.g_varchar2_table(66) := '72657469757352657665616C6572496E6C696E65202E72657665616C65722D68656164657222292E72656D6F7665436C61737328227377697463682D646973706C61792D6E6F6E6522292C242822237072657469757352657665616C6572496E6C696E65';
wwv_flow_imp.g_varchar2_table(67) := '202372536561726368426F7822292E666F63757328292C22617065782E6F7261636C652E636F6D223D3D77696E646F772E6C6F636174696F6E2E686F7374262628242827237072657469757352657665616C6572496E6C696E65206C6162656C5B666F72';
wwv_flow_imp.g_varchar2_table(68) := '3D22446562756750616765225D27292E616464436C6173732822617065785F64697361626C656422292C242822237072657469757352657665616C6572496E6C696E65202344656275675061676522292E706172656E7428292E6174747228227469746C';
wwv_flow_imp.g_varchar2_table(69) := '65222C2244697361626C6564206F6E20617065782E6F7261636C652E636F6D2064756520746F204F52412D30303034302229297D66756E6374696F6E206F2865297B617065782E7468656D652E6F70656E526567696F6E28242822237072657469757352';
wwv_flow_imp.g_varchar2_table(70) := '657665616C6572496E6C696E652229292C242822237072657469757352657665616C6572496E6C696E65202E742D4469616C6F67526567696F6E2D626F647922292E6C6F6164287064742E6F70742E66696C655072656669782B2272657665616C65722F';
wwv_flow_imp.g_varchar2_table(71) := '72657665616C65722E68746D6C22292C242822237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7422292E656D70747928292C2428222E7072657469757352657665616C6572496E6C696E65546F546865546F';
wwv_flow_imp.g_varchar2_table(72) := '70202E75692D6469616C6F672D7469746C6522292E746578742822205072657469757320446576656C6F70657220546F6F6C3A2052657665616C657222292C6928297D66756E6374696F6E206E28297B76617220743D2428222361706578446576546F6F';
wwv_flow_imp.g_varchar2_table(73) := '6C62617222292E6C656E6774683E303B6966287426262428222361706578446576546F6F6C626172517569636B4564697422292E6C656E6774683E302626303D3D2428222361706578446576546F6F6C62617252657665616C657222292E6C656E677468';
wwv_flow_imp.g_varchar2_table(74) := '297B733D273C696D67207372633D22272B7064742E6F70742E66696C655072656669782B2772657665616C65722F666F6E7441706578486970737465722D6F2E73766722206F6E6C6F61643D227064742E666978546F6F6C626172576964746828293B22';
wwv_flow_imp.g_varchar2_table(75) := '2020636C6173733D227461626C6F636B4869707374657249636F6E22202F3E273B76617220723D7064742E67657453657474696E67282272657665616C65722E6B6222292E746F4C6F7765724361736528293B2428222361706578446576546F6F6C6261';
wwv_flow_imp.g_varchar2_table(76) := '72517569636B4564697422292E706172656E7428292E6265666F7265286528617065782E6C616E672E666F726D61744E6F45736361706528273C6C693E3C627574746F6E2069643D2261706578446576546F6F6C62617252657665616C65722220747970';
wwv_flow_imp.g_varchar2_table(77) := '653D22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C62617222207469746C653D2256696577205061676520496E666F726D6174696F6E205B6374726C2B616C742B25305D2220617269612D6C61';
wwv_flow_imp.g_varchar2_table(78) := '62656C3D22566172732220646174612D6C696E6B3D22223E202531203C7370616E20636C6173733D22612D446576546F6F6C6261722D627574746F6E4C6162656C223E52657665616C65723C2F7370616E3E203C2F627574746F6E3E3C2F6C693E272C72';
wwv_flow_imp.g_varchar2_table(79) := '2C732929293B76617220693D646F63756D656E742E676574456C656D656E7442794964282261706578446576546F6F6C62617252657665616C657222293B692626692E6164644576656E744C697374656E65722822636C69636B222C66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(80) := '2865297B6F28297D2C2130292C7064742E666978546F6F6C626172576964746828292C2428222361706578446576546F6F6C62617222292E7769647468282428222E612D446576546F6F6C6261722D6C69737422292E776964746828292B22707822292C';
wwv_flow_imp.g_varchar2_table(81) := '2222213D7064742E67657453657474696E67282272657665616C65722E6B62222926262222213D722626284D6F757365747261702E62696E64476C6F62616C28226374726C2B616C742B222B722C66756E6374696F6E2865297B706172656E742E242822';
wwv_flow_imp.g_varchar2_table(82) := '3A666F63757322292E626C757228292C706172656E742E7064742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F64653D21312C706172656E742E2428222361706578446576546F6F6C62617252657665616C657222292E74';
wwv_flow_imp.g_varchar2_table(83) := '7269676765722822636C69636B22297D292C4D6F757365747261702E62696E64476C6F62616C28226374726C2B616C742B73686966742B222B722C66756E6374696F6E2865297B706172656E742E2428222361706578446576546F6F6C62617252657665';
wwv_flow_imp.g_varchar2_table(84) := '616C657222292E6C656E6774683E30262628706172656E742E2428223A666F63757322292E626C757228292C617065782E6D6573736167652E73686F77506167655375636365737328224F70656E696E672052657665616C657220696E20446562756720';
wwv_flow_imp.g_varchar2_table(85) := '4D6F646522292C706172656E742E7064742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F64653D21302C706172656E742E2428222361706578446576546F6F6C62617252657665616C657222292E74726967676572282263';
wwv_flow_imp.g_varchar2_table(86) := '6C69636B2229297D29292C2259223D3D7064742E67657453657474696E67282272657665616C65722E7461626C6F636B64656163746976617465222926266128297D7D76617220702C732C753D5B2254455854222C22434845434B424F585F47524F5550';
wwv_flow_imp.g_varchar2_table(87) := '222C22444953504C41595F53415645535F5354415445222C22444953504C41595F4F4E4C59222C2248494444454E222C2253485554544C45222C22524144494F5F47524F5550222C2253454C454354222C22504F5055505F4B45595F4C4F56222C22504F';
wwv_flow_imp.g_varchar2_table(88) := '5055505F4C4F56222C22535749544348222C225445585441524541222C22434B454449544F5233222C224155544F5F434F4D504C455445225D2C633D22696E7075743A6E6F7428275B646174612D666F725D2C2E6A732D746162547261702C2E612D4756';
wwv_flow_imp.g_varchar2_table(89) := '2D726F7753656C65637427292C202E73656C6563746C6973742C202E74657874617265612C202E6C6973746D616E616765723A6E6F74286669656C64736574292C202E617065782D6974656D2D726164696F2C202E617065782D6974656D2D636865636B';
wwv_flow_imp.g_varchar2_table(90) := '626F782C202E617065782D6974656D2D646973706C61792D6F6E6C792C202E617065782D6974656D2D67726F75702D2D73687574746C652C202E617065782D6974656D2D73687574746C652C202E617065782D6974656D2D67726F75702D2D7377697463';
wwv_flow_imp.g_varchar2_table(91) := '682C202E617065782D6974656D2D67726F75702D2D6175746F2D636F6D706C6574652C202E617065782D6974656D2D7965732D6E6F2C2074657874617265612C202E73687574746C653A6E6F74287461626C65292C202E73687574746C655F6C6566742C';
wwv_flow_imp.g_varchar2_table(92) := '202E73687574746C655F72696768742C202E636865636B626F785F67726F75703A6E6F7428276469762C7461626C6527292C202E7965735F6E6F222C643D227064742D72657665616C65722D69676E6F7265222C763D5B2270436F6E74657874222C2270';
wwv_flow_imp.g_varchar2_table(93) := '466C6F774964222C2270466C6F77537465704964222C2270496E7374616E6365222C2270506167655375626D697373696F6E4964222C227052657175657374222C227052656C6F61644F6E5375626D6974222C227053616C74222C227050616765497465';
wwv_flow_imp.g_varchar2_table(94) := '6D73526F7756657273696F6E222C2270506167654974656D7350726F746563746564222C22706465627567222C226170657843424D44756D6D7953656C656374696F6E222C227050616765436865636B73756D222C22705F6D64355F636865636B73756D';
wwv_flow_imp.g_varchar2_table(95) := '222C227050616765466F726D526567696F6E436865636B73756D73225D3B72657475726E7B616464486970737465723A6E2C696E6A6563745363726970743A742C64656275674D6F64653A707D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219976141976840813)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/minified/contentRevealer.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E75692D6469616C6F67202E75692D6469616C6F672D7469746C656261722D636F6C6C617073652C2E75692D6469616C6F67202E75692D6469616C6F672D7469746C656261722D636F6C6C617073652D726573746F72657B706F736974696F6E3A616273';
wwv_flow_imp.g_varchar2_table(2) := '6F6C7574653B72696768743A2E33656D3B746F703A3530253B77696474683A323170783B6D617267696E3A2D313070782030203020303B70616464696E673A3170783B6865696768743A323070787D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219976517321840817)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/minified/jquery.ui.dialog-collapse.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2866756E6374696F6E2874297B742E657874656E6428742E75692E6469616C6F672E70726F746F747970652E6F7074696F6E732C7B636F6C6C61707365456E61626C65643A6E756C6C2C6265666F7265436F6C6C617073653A6E756C6C2C636F6C6C6170';
wwv_flow_imp.g_varchar2_table(2) := '73653A6E756C6C2C6265666F7265436F6C6C61707365526573746F72653A6E756C6C2C636F6C6C61707365526573746F72653A6E756C6C7D293B76617220653D742E75692E6469616C6F672E70726F746F747970652E5F696E69743B742E75692E646961';
wwv_flow_imp.g_varchar2_table(3) := '6C6F672E70726F746F747970652E5F696E69743D66756E6374696F6E28297B652E6170706C7928746869732C617267756D656E7473293B76617220693D6E756C6C3B696628746869732E6F7074696F6E732E636F6C6C61707365456E61626C6564262628';
wwv_flow_imp.g_varchar2_table(4) := '746869732E616464436F6C6C61707365427574746F6E3D66756E6374696F6E28297B746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652626746869732E75694469616C6F675469746C65626172436F6C6C617073';
wwv_flow_imp.g_varchar2_table(5) := '65526573746F72652E6869646528292C746869732E75694469616C6F675469746C65626172436F6C6C617073653F746869732E75694469616C6F675469746C65626172436F6C6C617073652E73686F7728293A28746869732E75694469616C6F67546974';
wwv_flow_imp.g_varchar2_table(6) := '6C65626172436F6C6C617073653D7428273C627574746F6E20747970653D22627574746F6E22207469746C653D22436F6D70726573732220617269612D6C6162656C3D22436F6D70726573732220636C6173733D2270726574697573436F6D7072657373';
wwv_flow_imp.g_varchar2_table(7) := '42746E20742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D22742D49636F';
wwv_flow_imp.g_varchar2_table(8) := '6E2066612066612D636F6D7072657373223E3C2F7370616E3E3C2F627574746F6E3E27292E617070656E64546F28746869732E75694469616C6F675469746C65626172292E696E736572744265666F7265287428746869732E75694469616C6F67546974';
wwv_flow_imp.g_varchar2_table(9) := '6C65626172292E66696E6428222E75692D6469616C6F672D7469746C656261722D636C6F73652229292C746869732E5F6F6E28746869732E75694469616C6F675469746C65626172436F6C6C617073652C7B636C69636B3A66756E6374696F6E2874297B';
wwv_flow_imp.g_varchar2_table(10) := '742E70726576656E7444656661756C7428292C746869732E636F6C6C617073652874297D7D29297D2C746869732E616464436F6C6C61707365526573746F7265427574746F6E3D66756E6374696F6E28297B746869732E75694469616C6F675469746C65';
wwv_flow_imp.g_varchar2_table(11) := '626172436F6C6C617073652626746869732E75694469616C6F675469746C65626172436F6C6C617073652E6869646528292C746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72653F746869732E75694469616C6F67';
wwv_flow_imp.g_varchar2_table(12) := '5469746C65626172436F6C6C61707365526573746F72652E73686F7728293A28746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72653D7428273C627574746F6E20747970653D22627574746F6E22207469746C653D';
wwv_flow_imp.g_varchar2_table(13) := '22457870616E642220617269612D6C6162656C3D22457870616E642220636C6173733D2270726574697573457870616E6442746E20742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574';
wwv_flow_imp.g_varchar2_table(14) := '746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D22742D49636F6E2066612066612D657870616E64223E3C2F7370616E3E3C2F627574746F6E3E27292E696E736572744265666F726528742874';
wwv_flow_imp.g_varchar2_table(15) := '6869732E75694469616C6F675469746C65626172292E66696E6428222E75692D6469616C6F672D7469746C656261722D636C6F73652229292C746869732E5F6F6E28746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F';
wwv_flow_imp.g_varchar2_table(16) := '72652C7B636C69636B3A66756E6374696F6E2874297B742E70726576656E7444656661756C7428292C746869732E726573746F72652874297D7D29297D2C746869732E636F6C6C617073653D66756E6374696F6E2874297B76617220653D746869733B69';
wwv_flow_imp.g_varchar2_table(17) := '66282131213D3D652E5F7472696767657228226265666F7265436F6C6C6170736522292972657475726E20746869732E656C656D656E742E736C6964655570282266617374222C66756E6374696F6E28297B652E6F7074696F6E732E726573697A61626C';
wwv_flow_imp.g_varchar2_table(18) := '65262628693D652E6F7074696F6E732E726573697A61626C652C652E75694469616C6F672E726573697A61626C65282264657374726F7922292E6373732822686569676874222C226175746F22292C652E6F7074696F6E732E726573697A61626C653D22';
wwv_flow_imp.g_varchar2_table(19) := '652C2077222C652E5F6D616B65526573697A61626C652829292C652E616464436F6C6C61707365526573746F7265427574746F6E28292C652E5F747269676765722822636F6C6C6170736522297D292C657D2C746869732E726573746F72653D66756E63';
wwv_flow_imp.g_varchar2_table(20) := '74696F6E2874297B76617220653D746869733B6966282131213D3D652E5F7472696767657228226265666F7265436F6C6C61707365526573746F726522292972657475726E20746869732E656C656D656E742E736C696465446F776E282266617374222C';
wwv_flow_imp.g_varchar2_table(21) := '66756E6374696F6E28297B652E6F7074696F6E732E726573697A61626C65262628652E75694469616C6F672E726573697A61626C65282264657374726F7922292C652E6F7074696F6E732E726573697A61626C653D692C652E5F6D616B65526573697A61';
wwv_flow_imp.g_varchar2_table(22) := '626C652829292C652E616464436F6C6C61707365427574746F6E28292C652E5F747269676765722822636F6C6C61707365526573746F726522297D292C657D2C746869732E616464436F6C6C61707365526573746F7265427574746F6E28292C74686973';
wwv_flow_imp.g_varchar2_table(23) := '2E616464436F6C6C61707365427574746F6E28292C746869732E75694469616C6F675469746C65626172436C6F73652626746869732E75694469616C6F675469746C65626172436C6F73652E697328223A76697369626C65222929297B766172206C3D70';
wwv_flow_imp.g_varchar2_table(24) := '61727365466C6F617428746869732E75694469616C6F675469746C65626172436C6F73652E637373282272696768742229293B7428222E75692D6469616C6F672D7469746C656261722D636F6C6C617073652C202E75692D6469616C6F672D7469746C65';
wwv_flow_imp.g_varchar2_table(25) := '6261722D636F6C6C617073652D726573746F726522292E63737328227269676874222C322A6C2B746869732E75694469616C6F675469746C65626172436C6F73652E6F75746572576964746828292B22707822297D7D7D29286A5175657279293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219976977952840821)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/minified/jquery.ui.dialog-collapse.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '237072657469757352657665616C6572496E6C696E65207461626C657B626F726465722D636F6C6C617073653A636F6C6C617073653B77696474683A313030257D237072657469757352657665616C6572496E6C696E652074642C237072657469757352';
wwv_flow_imp.g_varchar2_table(2) := '657665616C6572496E6C696E652074687B746578742D616C69676E3A6C6566743B70616464696E673A3870787D237072657469757352657665616C6572496E6C696E65202E616C7465726E6174652D726F77732D746C7B6261636B67726F756E642D636F';
wwv_flow_imp.g_varchar2_table(3) := '6C6F723A2366326632663221696D706F7274616E747D237072657469757352657665616C6572496E6C696E652074687B6261636B67726F756E642D636F6C6F723A233166393063623B636F6C6F723A236666667D237072657469757352657665616C6572';
wwv_flow_imp.g_varchar2_table(4) := '496E6C696E65206C6162656C2E736D616C6C4D6167696E4C6566747B6D617267696E2D6C6566743A313070787D237072657469757352657665616C6572496E6C696E65202E725365617263687B70616464696E673A3670783B666C6F61743A7269676874';
wwv_flow_imp.g_varchar2_table(5) := '7D237072657469757352657665616C6572496E6C696E65202E736964652D62792D736964657B666C6F61743A6C6566747D237072657469757352657665616C6572496E6C696E652074642E74645461626C6F636B566172737B6D61782D77696474683A32';
wwv_flow_imp.g_varchar2_table(6) := '303070783B776F72642D777261703A627265616B2D776F72647D237072657469757352657665616C6572496E6C696E65202E707265746975735461624C6162656C7B706F736974696F6E3A72656C61746976657D237072657469757352657665616C6572';
wwv_flow_imp.g_varchar2_table(7) := '496E6C696E65202E7072657469757352657665616C6572417474656E74696F6E7B666F6E742D7765696768743A3730307D237072657469757352657665616C6572496E6C696E65202E7072657469757352657665616C65724E6F6E52656E64657265647B';
wwv_flow_imp.g_varchar2_table(8) := '746578742D6465636F726174696F6E3A6C696E652D7468726F7567687D237072657469757352657665616C6572496E6C696E65202E72657665616C65722D6C6F6164696E677B706F736974696F6E3A6162736F6C7574653B6C6566743A3530257D237072';
wwv_flow_imp.g_varchar2_table(9) := '657469757352657665616C6572496E6C696E65202E72657665616C65722D6865616465727B6261636B67726F756E642D636F6C6F723A236638663866383B646973706C61793A696E6C696E652D626C6F636B3B77696474683A313030253B70616464696E';
wwv_flow_imp.g_varchar2_table(10) := '672D6C6566743A3570783B626F726465722D7261646975733A3570787D237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074683A666972';
wwv_flow_imp.g_varchar2_table(11) := '73742D6368696C647B646973706C61793A6E6F6E6521696D706F7274616E747D237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074643A';
wwv_flow_imp.g_varchar2_table(12) := '66697273742D6368696C647B646973706C61793A6E6F6E6521696D706F7274616E747D237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B5661727320747220';
wwv_flow_imp.g_varchar2_table(13) := '74683A6C6173742D6368696C647B646973706C61793A6E6F6E6521696D706F7274616E747D237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074';
wwv_flow_imp.g_varchar2_table(14) := '722074643A6C6173742D6368696C647B646973706C61793A6E6F6E6521696D706F7274616E747D237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E7465727B706F736974696F6E3A6162736F6C7574';
wwv_flow_imp.g_varchar2_table(15) := '653B746F703A2D3570783B72696768743A3170783B6261636B67726F756E642D636F6C6F723A233030303B636F6C6F723A236666663B626F726465722D7261646975733A3370783B70616464696E673A317078203370783B666F6E743A38707820566572';
wwv_flow_imp.g_varchar2_table(16) := '64616E617D237072657469757352657665616C6572496E6C696E65202E7377697463682D646973706C61792D6E6F6E657B646973706C61793A6E6F6E6521696D706F7274616E747D237072657469757352657665616C6572496E6C696E65202E64697370';
wwv_flow_imp.g_varchar2_table(17) := '6C61792D6E6F6E657B646973706C61793A6E6F6E6521696D706F7274616E747D237072657469757352657665616C6572496E6C696E65206C6162656C2E7377697463682D616C6F6E657B626F726465722D7261646975733A34707821696D706F7274616E';
wwv_flow_imp.g_varchar2_table(18) := '747D237072657469757352657665616C6572496E6C696E65207370616E2E66612E66612D686970737465722E7461626C6F636B2D72657665616C65722D69636F6E7B70616464696E672D746F703A3470787D237072657469757352657665616C6572496E';
wwv_flow_imp.g_varchar2_table(19) := '6C696E65202E7377697463682D6669656C647B666F6E742D66616D696C793A224C7563696461204772616E6465222C5461686F6D612C56657264616E612C73616E732D73657269663B70616464696E673A3470783B6F766572666C6F773A68696464656E';
wwv_flow_imp.g_varchar2_table(20) := '3B70616464696E672D6C6566743A307D237072657469757352657665616C6572496E6C696E65202E7377697463682D7469746C657B6D617267696E2D626F74746F6D3A3670787D237072657469757352657665616C6572496E6C696E65202E7377697463';
wwv_flow_imp.g_varchar2_table(21) := '682D6669656C6420696E7075747B706F736974696F6E3A6162736F6C75746521696D706F7274616E743B636C69703A7265637428302C302C302C30293B6865696768743A3170783B77696474683A3170783B626F726465723A303B6F766572666C6F773A';
wwv_flow_imp.g_varchar2_table(22) := '68696464656E7D237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C7B666C6F61743A6C6566747D237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C61';
wwv_flow_imp.g_varchar2_table(23) := '62656C7B646973706C61793A696E6C696E652D626C6F636B3B6D696E2D77696474683A343070783B6261636B67726F756E642D636F6C6F723A236534653465343B636F6C6F723A7267626128302C302C302C2E38293B666F6E742D73697A653A31347078';
wwv_flow_imp.g_varchar2_table(24) := '3B666F6E742D7765696768743A3430303B746578742D616C69676E3A63656E7465723B746578742D736861646F773A6E6F6E653B70616464696E673A35707820313470783B626F726465723A31707820736F6C6964207267626128302C302C302C2E3229';
wwv_flow_imp.g_varchar2_table(25) := '3B2D7765626B69742D626F782D736861646F773A696E73657420302031707820337078207267626128302C302C302C2E33292C30203170782072676261283235352C3235352C3235352C2E31293B626F782D736861646F773A696E736574203020317078';
wwv_flow_imp.g_varchar2_table(26) := '20337078207267626128302C302C302C2E33292C30203170782072676261283235352C3235352C3235352C2E31293B2D7765626B69742D7472616E736974696F6E3A616C6C202E317320656173652D696E2D6F75743B2D6D6F7A2D7472616E736974696F';
wwv_flow_imp.g_varchar2_table(27) := '6E3A616C6C202E317320656173652D696E2D6F75743B2D6D732D7472616E736974696F6E3A616C6C202E317320656173652D696E2D6F75743B2D6F2D7472616E736974696F6E3A616C6C202E317320656173652D696E2D6F75743B7472616E736974696F';
wwv_flow_imp.g_varchar2_table(28) := '6E3A616C6C202E317320656173652D696E2D6F75747D237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C3A686F7665727B637572736F723A706F696E7465727D237072657469757352657665616C';
wwv_flow_imp.g_varchar2_table(29) := '6572496E6C696E65202E7377697463682D6669656C6420696E7075743A636865636B65642B6C6162656C7B6261636B67726F756E642D636F6C6F723A233166393063623B636F6C6F723A236666663B2D7765626B69742D626F782D736861646F773A6E6F';
wwv_flow_imp.g_varchar2_table(30) := '6E653B626F782D736861646F773A6E6F6E657D237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C3A66697273742D6F662D747970657B626F726465722D7261646975733A34707820302030203470';
wwv_flow_imp.g_varchar2_table(31) := '787D237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C3A6C6173742D6F662D747970657B626F726465722D7261646975733A30203470782034707820307D237072657469757352657665616C6572';
wwv_flow_imp.g_varchar2_table(32) := '496E6C696E652074682E742D5265706F72742D636F6C486561647B626F726465722D7374796C653A736F6C69643B626F726465722D7261646975733A3670783B626F726465722D77696474683A3270787D237072657469757352657665616C6572496E6C';
wwv_flow_imp.g_varchar2_table(33) := '696E65202E6C64732D7370696E6E65727B636F6C6F723A6F6666696369616C3B646973706C61793A696E6C696E652D626C6F636B3B706F736974696F6E3A72656C61746976653B77696474683A363470783B6865696768743A363470787D237072657469';
wwv_flow_imp.g_varchar2_table(34) := '757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469767B7472616E73666F726D2D6F726967696E3A3332707820333270783B616E696D6174696F6E3A6C64732D7370696E6E657220312E3273206C696E65617220696E66696E';
wwv_flow_imp.g_varchar2_table(35) := '6974657D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A61667465727B636F6E74656E743A2220223B646973706C61793A626C6F636B3B706F736974696F6E3A6162736F6C7574653B746F703A3370';
wwv_flow_imp.g_varchar2_table(36) := '783B6C6566743A323970783B77696474683A3570783B6865696768743A313470783B626F726465722D7261646975733A3230253B6261636B67726F756E643A233166393063627D237072657469757352657665616C6572496E6C696E65202E6C64732D73';
wwv_flow_imp.g_varchar2_table(37) := '70696E6E6572206469763A6E74682D6368696C642831297B7472616E73666F726D3A726F746174652830293B616E696D6174696F6E2D64656C61793A2D312E31737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E65';
wwv_flow_imp.g_varchar2_table(38) := '72206469763A6E74682D6368696C642832297B7472616E73666F726D3A726F74617465283330646567293B616E696D6174696F6E2D64656C61793A2D31737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E65722064';
wwv_flow_imp.g_varchar2_table(39) := '69763A6E74682D6368696C642833297B7472616E73666F726D3A726F74617465283630646567293B616E696D6174696F6E2D64656C61793A2D2E39737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E657220646976';
wwv_flow_imp.g_varchar2_table(40) := '3A6E74682D6368696C642834297B7472616E73666F726D3A726F74617465283930646567293B616E696D6174696F6E2D64656C61793A2D2E38737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E';
wwv_flow_imp.g_varchar2_table(41) := '74682D6368696C642835297B7472616E73666F726D3A726F7461746528313230646567293B616E696D6174696F6E2D64656C61793A2D2E37737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74';
wwv_flow_imp.g_varchar2_table(42) := '682D6368696C642836297B7472616E73666F726D3A726F7461746528313530646567293B616E696D6174696F6E2D64656C61793A2D2E36737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E7468';
wwv_flow_imp.g_varchar2_table(43) := '2D6368696C642837297B7472616E73666F726D3A726F7461746528313830646567293B616E696D6174696F6E2D64656C61793A2D2E35737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D';
wwv_flow_imp.g_varchar2_table(44) := '6368696C642838297B7472616E73666F726D3A726F7461746528323130646567293B616E696D6174696F6E2D64656C61793A2D2E34737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D63';
wwv_flow_imp.g_varchar2_table(45) := '68696C642839297B7472616E73666F726D3A726F7461746528323430646567293B616E696D6174696F6E2D64656C61793A2D2E33737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368';
wwv_flow_imp.g_varchar2_table(46) := '696C64283130297B7472616E73666F726D3A726F7461746528323730646567293B616E696D6174696F6E2D64656C61793A2D2E32737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368';
wwv_flow_imp.g_varchar2_table(47) := '696C64283131297B7472616E73666F726D3A726F7461746528333030646567293B616E696D6174696F6E2D64656C61793A2D2E31737D237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368';
wwv_flow_imp.g_varchar2_table(48) := '696C64283132297B7472616E73666F726D3A726F7461746528333330646567293B616E696D6174696F6E2D64656C61793A30737D406B65796672616D6573206C64732D7370696E6E65727B30257B6F7061636974793A317D313030257B6F706163697479';
wwv_flow_imp.g_varchar2_table(49) := '3A307D7D237072657469757352657665616C6572496E6C696E65206469762370726574697573436F6E74656E747B666F6E742D66616D696C793A224C7563696461204772616E6465222C5461686F6D612C56657264616E612C73616E732D73657269663B';
wwv_flow_imp.g_varchar2_table(50) := '666F6E742D73697A653A313370787D2E7072657469757352657665616C6572496E6C696E65546F546865546F707B7A2D696E6465783A3939393921696D706F7274616E747D2E7072657469757352657665616C6572496E6C696E65546F546865546F7020';
wwv_flow_imp.g_varchar2_table(51) := '2E7072657469757352657665616C6572466F6F7465727B626F726465722D7374796C653A736F6C69643B626F726465722D636F6C6F723A236433643364333B626F726465722D77696474683A3170783B6261636B67726F756E642D636F6C6F723A236632';
wwv_flow_imp.g_varchar2_table(52) := '663266323B636F6C6F723A233166393063623B746578742D616C69676E3A63656E7465723B70616464696E672D6C6566743A3570783B6D61782D6865696768743A323270787D2E7072657469757352657665616C6572496E6C696E65546F546865546F70';
wwv_flow_imp.g_varchar2_table(53) := '20612E7072657469757352657665616C65724C696E6B7B636F6C6F723A2331663930636221696D706F7274616E743B666F6E742D73697A653A313270787D2E7072657469757352657665616C6572496E6C696E65546F546865546F70202E707265746975';
wwv_flow_imp.g_varchar2_table(54) := '735461626C6F636B56657273696F6E7B666C6F61743A72696768743B70616464696E672D72696768743A3570787D2E7072657469757352657665616C6572496E6C696E65546F546865546F70202E70726574697573466F6F7465724F7074696F6E737B66';
wwv_flow_imp.g_varchar2_table(55) := '6C6F61743A6C6566747D237072657469757352657665616C6572496E6C696E65202E6C696E6B4C696B657B637572736F723A706F696E7465723B636F6C6F723A233166393063627D2E7064742D6F7074696F6E2D627574746F6E3A6E6F74282370726574';
wwv_flow_imp.g_varchar2_table(56) := '69757352657665616C6572427574746F6E526567696F6E2E7064742D6F7074696F6E2D627574746F6E297B646973706C61793A6E6F6E657D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219977356928840825)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/minified/revealer.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '766172207072657469757352657665616C65723D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E20652865297B666F7228766172206E3D752E636C6F6E654E6F6465282131292C693D7428652C6E292C723D302C6C3D65';
wwv_flow_imp.g_varchar2_table(2) := '2E6C656E6774683B723C6C3B2B2B72297B666F722876617220613D702E636C6F6E654E6F6465282131292C733D302C643D692E6C656E6774683B733C643B2B2B73297B766172206F3D762E636C6F6E654E6F6465282131293B655B725D5B695B735D5D3B';
wwv_flow_imp.g_varchar2_table(3) := '6F2E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F646528655B725D5B695B735D5D7C7C222229292C612E617070656E644368696C64286F297D6E2E617070656E644368696C642861297D72657475726E206E7D6675';
wwv_flow_imp.g_varchar2_table(4) := '6E6374696F6E207428652C74297B666F7228766172206E3D5B5D2C693D702E636C6F6E654E6F6465282131292C723D302C6C3D652E6C656E6774683B723C6C3B722B2B29666F7228766172206120696E20655B725D29696628655B725D2E6861734F776E';
wwv_flow_imp.g_varchar2_table(5) := '50726F706572747928612926262D313D3D3D6E2E696E6465784F66286129297B6E2E707573682861293B76617220733D632E636C6F6E654E6F6465282131293B732E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F64';
wwv_flow_imp.g_varchar2_table(6) := '65286129292C692E617070656E644368696C642873297D72657475726E20742E617070656E644368696C642869292C6E7D66756E6374696F6E206E2865297B666F722876617220742C6E3D7B7D2C693D652C723D5B5D2C6C3D303B743D695B6C2B2B5D3B';
wwv_flow_imp.g_varchar2_table(7) := '297B76617220613D742E506167653B6120696E206E7C7C286E5B615D3D312C722E70757368286129297D72657475726E20722E7265766572736528297D66756E6374696F6E206928297B242822237072657469757352657665616C6572496E6C696E6520';
wwv_flow_imp.g_varchar2_table(8) := '74722E64617461526F7722292E656163682866756E6374696F6E28297B76617220653D242874686973292C743D652E66696E64282274643A6E74682D6368696C6428322922292C6E3D28652E66696E64282274643A6E74682D6368696C6428332922292C';
wwv_flow_imp.g_varchar2_table(9) := '652E66696E64282274643A6E74682D6368696C6428332922292E68746D6C2829292C693D652E66696E64282274643A6C6173742D6368696C6422292E68746D6C28293B21742E686173436C61737328227072657469757352657665616C6572417474656E';
wwv_flow_imp.g_varchar2_table(10) := '74696F6E22292626766F69642030213D3D6E26266E2E746F537472696E6728292E73746172747357697468282248494444454E22292626742E616464436C61737328227072657469757352657665616C6572417474656E74696F6E22292C21742E686173';
wwv_flow_imp.g_varchar2_table(11) := '436C61737328227072657469757352657665616C65724E6F6E52656E646572656422292626766F69642030213D3D692626692E746F537472696E6728292E696E636C7564657328224E522229262628742E616464436C6173732822707265746975735265';
wwv_flow_imp.g_varchar2_table(12) := '7665616C65724E6F6E52656E646572656422292C742E6174747228227469746C65222C224E6F6E2D52656E6465726564204974656D2229297D297D66756E6374696F6E20722865297B66756E6374696F6E20742874297B766172206E3D303B7265747572';
wwv_flow_imp.g_varchar2_table(13) := '6E20242822237072657469757352657665616C6572496E6C696E652074722E64617461526F7722292E656163682866756E6374696F6E28297B76617220693D242874686973292C6C3D692E66696E64282274643A666972737422292E68746D6C28292C61';
wwv_flow_imp.g_varchar2_table(14) := '3D692E66696E64282274643A6C61737422292E68746D6C28292C733D692E66696E64282274643A6E74682D6368696C6428322922292E68746D6C28292B2220222B692E66696E64282274643A6E74682D6368696C6428332922292E68746D6C28292B2220';
wwv_flow_imp.g_varchar2_table(15) := '222B692E66696E64282274643A6E74682D6368696C6428342922292E68746D6C28292B2220222B692E66696E64282274643A6E74682D6368696C6428352922292E68746D6C28293B733D732E746F537472696E6728292E746F5570706572436173652829';
wwv_flow_imp.g_varchar2_table(16) := '2C285B652C222A225D2E696E6465784F66286C293E2D317C7C22416C6C223D3D65292626766F69642030213D3D612626612E73706C697428222C22292E696E6465784F662874293E3D3026262D31213D3D732E696E6465784F662872292626286E2B3D31';
wwv_flow_imp.g_varchar2_table(17) := '292C285B652C222A225D2E696E6465784F66286C293E2D317C7C22416C6C223D3D6529262622414C4C223D3D742626766F69642030213D3D6126262243617465676F727922213D6126262D31213D3D732E696E6465784F662872292626286E2B3D31297D';
wwv_flow_imp.g_varchar2_table(18) := '292C6E7D766172206E3D5B5D2C693D5B225058222C225049222C225030222C22504F222C224952222C224947222C224149222C225342222C224358222C224657222C224150222C22414C4C225D2C723D242822237072657469757352657665616C657249';
wwv_flow_imp.g_varchar2_table(19) := '6E6C696E65202372536561726368426F7822292E76616C28292E746F55707065724361736528293B242822237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E74657222292E74657874282222292C24';
wwv_flow_imp.g_varchar2_table(20) := '2822237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E74657222292E72656D6F7665436C61737328226E6F74696669636174696F6E2D636F756E74657222293B666F7228766172206C3D303B6C3C69';
wwv_flow_imp.g_varchar2_table(21) := '2E6C656E6774683B6C2B2B297B76617220613D695B6C5D2C733D742861293B733E302626242822237072657469757352657665616C6572496E6C696E652023222B612B22636F756E74657222292E616464436C61737328226E6F74696669636174696F6E';
wwv_flow_imp.g_varchar2_table(22) := '2D636F756E74657222292E746578742873297D72657475726E206E7D66756E6374696F6E206C28297B76617220653D242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F';
wwv_flow_imp.g_varchar2_table(23) := '775374657049645D3A636865636B656422292E76616C28293B72657475726E20653D22416C6C223D3D653F242822237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7322292E6174747228226A75';
wwv_flow_imp.g_varchar2_table(24) := '7374506167657322293A223A222B652B223A222C657D66756E6374696F6E206128297B242822237072657469757352657665616C6572496E6C696E65202372536561726368426F7822292E76616C282222292C7064742E636C6F616B44656275674C6576';
wwv_flow_imp.g_varchar2_table(25) := '656C28292C617065782E7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965722C7B7830313A2244454255475F56494557222C7830323A6C28297D2C7B737563636573733A66756E6374696F6E2865297B7064742E75';
wwv_flow_imp.g_varchar2_table(26) := '6E436C6F616B44656275674C6576656C28292C242822237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E7422292E656D70747928292C242822237072657469757352657665616C6572496E6C696E';
wwv_flow_imp.g_varchar2_table(27) := '652023707265746975734465627567436F6E74656E7422292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528652E6974656D7329292C6428292C242822237072657469757352657665616C6572496E6C69';
wwv_flow_imp.g_varchar2_table(28) := '6E652023707265746975734465627567436F6E74656E74202E74645461626C6F636B566172733A66697273742D6368696C6422292E656163682866756E6374696F6E2865297B76617220743D242874686973293B242874292E616464436C61737328226C';
wwv_flow_imp.g_varchar2_table(29) := '696E6B4C696B6522292C742626742E6F6E2822636C69636B222C66756E6374696F6E2865297B7328242874292E746578742829297D297D292C6F28297D2C6572726F723A66756E6374696F6E28652C742C6E297B7064742E616A61784572726F7248616E';
wwv_flow_imp.g_varchar2_table(30) := '646C657228652C742C6E297D7D297D66756E6374696F6E20732865297B242822237072657469757352657665616C6572496E6C696E65202372536561726368426F7822292E76616C282222292C7064742E636C6F616B44656275674C6576656C28292C61';
wwv_flow_imp.g_varchar2_table(31) := '7065782E7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965722C7B7830313A2244454255475F44455441494C222C7830323A657D2C7B737563636573733A66756E6374696F6E2865297B7064742E756E436C6F616B';
wwv_flow_imp.g_varchar2_table(32) := '44656275674C6576656C28292C242822237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E7422292E656D70747928292C242822237072657469757352657665616C6572496E6C696E652023707265';
wwv_flow_imp.g_varchar2_table(33) := '746975734465627567436F6E74656E7422292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528652E6974656D7329292C6428297D2C6572726F723A66756E6374696F6E28652C742C6E297B7064742E616A';
wwv_flow_imp.g_varchar2_table(34) := '61784572726F7248616E646C657228652C742C6E297D7D297D66756E6374696F6E206428297B242822237072657469757352657665616C6572496E6C696E65202E616C7465726E6174652D726F77732D746C22292E72656D6F7665436C6173732822616C';
wwv_flow_imp.g_varchar2_table(35) := '7465726E6174652D726F77732D746C22292C242822237072657469757352657665616C6572496E6C696E65202E7461626C655461626C6F636B5661727320747222292E66696C7465722866756E6374696F6E28297B72657475726E2276697369626C6522';
wwv_flow_imp.g_varchar2_table(36) := '3D3D242874686973292E63737328227669736962696C69747922297D292E66696C74657228223A6F646422292E616464436C6173732822616C7465726E6174652D726F77732D746C22297D66756E6374696F6E206F28297B76617220653D5B225342222C';
wwv_flow_imp.g_varchar2_table(37) := '224358222C224149222C224150225D2C743D5B224657222C224952222C224947225D2C6E3D22222C693D242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F7753746570';
wwv_flow_imp.g_varchar2_table(38) := '49645D3A636865636B656422292E76616C28292C6C3D242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A636865636B656422292E76616C28292C613D';
wwv_flow_imp.g_varchar2_table(39) := '242822237072657469757352657665616C6572496E6C696E65202372536561726368426F7822292E76616C28292E746F55707065724361736528292C733D2428226C6162656C5B666F723D275061676553656C656374656441626F7665275D22293B732E';
wwv_flow_imp.g_varchar2_table(40) := '68746D6C282250222B692E73706C697428225F22295B305D2B273C7370616E2069643D225058636F756E746572223E3C2F7370616E3E27292C732E72656D6F7665436C61737328227377697463682D646973706C61792D6E6F6E6522292C242822237072';
wwv_flow_imp.g_varchar2_table(41) := '657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B5661727320747220746822292E73686F7728292C242822237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F';
wwv_flow_imp.g_varchar2_table(42) := '636B5661727320747220746422292E73686F7728292C22446562756750616765223D3D6C3F286E3D22237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E74222C2428222370726574697573526576';
wwv_flow_imp.g_varchar2_table(43) := '65616C6572496E6C696E65202370726574697573436F6E74656E7422292E6869646528292C24286E292E73686F772829293A286E3D22237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74222C24286E292E73';
wwv_flow_imp.g_varchar2_table(44) := '686F7728292C242822237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E7422292E686964652829292C22416C6C22213D697C7C28732E616464436C61737328227377697463682D646973706C6179';
wwv_flow_imp.g_varchar2_table(45) := '2D6E6F6E6522292C22505822213D6C293F28652E696E636C75646573286C29262628242822237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074683A6E74682D6368696C642834';
wwv_flow_imp.g_varchar2_table(46) := '2922292E6869646528292C242822237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074643A6E74682D6368696C6428342922292E686964652829292C742E696E636C7564657328';
wwv_flow_imp.g_varchar2_table(47) := '6C29262628242822237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074683A6E74682D6368696C6428352922292E6869646528292C242822237072657469757352657665616C65';
wwv_flow_imp.g_varchar2_table(48) := '72496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074643A6E74682D6368696C6428352922292E686964652829292C24286E2B222074722E64617461526F773A6E6F74283A66697273742922292E637373282276697369';
wwv_flow_imp.g_varchar2_table(49) := '62696C697479222C22636F6C6C6170736522292C24286E2B222074722E64617461526F7722292E656163682866756E6374696F6E28297B76617220653D242874686973292C743D652E66696E64282274643A666972737422292E68746D6C28292C6E3D65';
wwv_flow_imp.g_varchar2_table(50) := '2E66696E64282274643A6C61737422292E68746D6C28292C723D227464223B2244656275675061676522213D6C262628723D2274643A6E6F74283A66697273742C203A6C6173742922293B76617220733D652E66696E642872292E6D61702866756E6374';
wwv_flow_imp.g_varchar2_table(51) := '696F6E28297B72657475726E20242874686973292E7465787428297D292E67657428292E6A6F696E28222022292E746F55707065724361736528293B22446562756750616765223D3D6C3F2222213D6126262D313D3D3D732E696E6465784F662861297C';
wwv_flow_imp.g_varchar2_table(52) := '7C652E63737328227669736962696C697479222C2276697369626C6522293A285B692C222A225D2E696E6465784F662874293E2D317C7C22416C6C223D3D6929262628766F696420303D3D3D6E7C7C6E2E73706C697428222C22292E696E6465784F6628';
wwv_flow_imp.g_varchar2_table(53) := '6C293E3D307C7C22416C6C223D3D6C2926262D31213D3D732E696E6465784F662861292626652E63737328227669736962696C697479222C2276697369626C6522297D292C722869292C642829293A242822237072657469757352657665616C6572496E';
wwv_flow_imp.g_varchar2_table(54) := '6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A666972737422292E747269676765722822636C69636B22297D76617220753D646F63756D656E742E637265617465456C656D656E7428227461626C6522';
wwv_flow_imp.g_varchar2_table(55) := '292C703D646F63756D656E742E637265617465456C656D656E742822747222292C633D646F63756D656E742E637265617465456C656D656E742822746822292C763D646F63756D656E742E637265617465456C656D656E742822746422293B7265747572';
wwv_flow_imp.g_varchar2_table(56) := '6E20752E636C6173734E616D653D227461626C655461626C6F636B56617273222C702E636C6173734E616D653D2264617461526F77222C632E636C6173734E616D653D22742D5265706F72742D636F6C48656164222C762E636C6173734E616D653D2274';
wwv_flow_imp.g_varchar2_table(57) := '645461626C6F636B56617273222C7B706572666F726D46696C7465723A6F2C64697374696E637447726F7570733A722C6275696C6448746D6C5461626C653A652C637573746F6D6973655461626C653A692C64697374696E637450616765733A6E2C6765';
wwv_flow_imp.g_varchar2_table(58) := '74446562756756696577436F6E74656E743A612C7061676544656C696D657465643A6C7D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219977704795840830)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/minified/revealer.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A205374616E64617264202A2F0D0A0D0A2F2A20707265746975732023454231433233202A2F0D0A2F2A20507265746975732023314639304342202A2F0D0A0D0A237072657469757352657665616C6572496E6C696E65207461626C65207B0D0A2020';
wwv_flow_imp.g_varchar2_table(2) := '626F726465722D636F6C6C617073653A20636F6C6C617073653B0D0A202077696474683A20313030253B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E652074682C20237072657469757352657665616C6572496E6C696E652074';
wwv_flow_imp.g_varchar2_table(3) := '64207B0D0A2020746578742D616C69676E3A206C6566743B0D0A202070616464696E673A203870783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E616C7465726E6174652D726F77732D746C207B0D0A20206261636B67';
wwv_flow_imp.g_varchar2_table(4) := '726F756E642D636F6C6F723A20236632663266322021696D706F7274616E740D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65207468207B0D0A20206261636B67726F756E642D636F6C6F723A20233146393043423B0D0A202063';
wwv_flow_imp.g_varchar2_table(5) := '6F6C6F723A2077686974653B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65206C6162656C2E736D616C6C4D6167696E4C656674207B0D0A20206D617267696E2D6C6566743A20313070783B0D0A7D0D0A0D0A23707265746975';
wwv_flow_imp.g_varchar2_table(6) := '7352657665616C6572496E6C696E65202E72536561726368207B0D0A202070616464696E673A203670783B0D0A2020666C6F61743A2072696768743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E736964652D62792D73';
wwv_flow_imp.g_varchar2_table(7) := '696465207B0D0A2020666C6F61743A206C6566743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E652074642E74645461626C6F636B56617273207B0D0A20206D61782D77696474683A2032303070783B0D0A2020776F72642D77';
wwv_flow_imp.g_varchar2_table(8) := '7261703A20627265616B2D776F72643B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E707265746975735461624C6162656C207B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A7D0D0A0D0A237072657469';
wwv_flow_imp.g_varchar2_table(9) := '757352657665616C6572496E6C696E65202E7072657469757352657665616C6572417474656E74696F6E207B0D0A2020666F6E742D7765696768743A20626F6C643B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E707265';
wwv_flow_imp.g_varchar2_table(10) := '7469757352657665616C65724E6F6E52656E6465726564207B0D0A2020746578742D6465636F726174696F6E3A206C696E652D7468726F7567683B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E72657665616C65722D6C';
wwv_flow_imp.g_varchar2_table(11) := '6F6164696E67207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203530253B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E72657665616C65722D686561646572207B0D0A2020626163';
wwv_flow_imp.g_varchar2_table(12) := '6B67726F756E642D636F6C6F723A20236638663866383B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202077696474683A20313030253B0D0A202070616464696E672D6C6566743A203570783B0D0A2020626F726465722D7261';
wwv_flow_imp.g_varchar2_table(13) := '646975733A203570783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074683A66697273742D6368696C64207B0D0A';
wwv_flow_imp.g_varchar2_table(14) := '2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074';
wwv_flow_imp.g_varchar2_table(15) := '643A66697273742D6368696C64207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C';
wwv_flow_imp.g_varchar2_table(16) := '655461626C6F636B566172732074722074683A6C6173742D6368696C64207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F';
wwv_flow_imp.g_varchar2_table(17) := '6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074643A6C6173742D6368696C64207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C657249';
wwv_flow_imp.g_varchar2_table(18) := '6E6C696E65202E6E6F74696669636174696F6E2D636F756E746572207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A2020746F703A202D3570783B0D0A202072696768743A203170783B0D0A20206261636B67726F756E642D636F6C6F';
wwv_flow_imp.g_varchar2_table(19) := '723A20626C61636B3B0D0A2020636F6C6F723A20236666663B0D0A2020626F726465722D7261646975733A203370783B0D0A202070616464696E673A20317078203370783B0D0A2020666F6E743A203870782056657264616E613B0D0A7D0D0A0D0A2370';
wwv_flow_imp.g_varchar2_table(20) := '72657469757352657665616C6572496E6C696E65202E7377697463682D646973706C61792D6E6F6E65207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E';
wwv_flow_imp.g_varchar2_table(21) := '65202E646973706C61792D6E6F6E65207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A0D0A237072657469757352657665616C6572496E6C696E65206C6162656C2E7377697463682D616C6F6E65207B0D0A';
wwv_flow_imp.g_varchar2_table(22) := '2020626F726465722D7261646975733A203470782021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65207370616E2E66612E66612D686970737465722E7461626C6F636B2D72657665616C65722D6963';
wwv_flow_imp.g_varchar2_table(23) := '6F6E207B0D0A202070616464696E672D746F703A203470783B0D0A7D0D0A0D0A2F2A205377697463682052656C61746564202A2F0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64207B0D0A2020666F';
wwv_flow_imp.g_varchar2_table(24) := '6E742D66616D696C793A20224C7563696461204772616E6465222C205461686F6D612C2056657264616E612C2073616E732D73657269663B0D0A202070616464696E673A203470783B0D0A20206F766572666C6F773A2068696464656E3B0D0A20207061';
wwv_flow_imp.g_varchar2_table(25) := '6464696E672D6C6566743A203070780D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D7469746C65207B0D0A20206D617267696E2D626F74746F6D3A203670783B0D0A7D0D0A0D0A23707265746975735265';
wwv_flow_imp.g_varchar2_table(26) := '7665616C6572496E6C696E65202E7377697463682D6669656C6420696E707574207B0D0A2020706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B0D0A2020636C69703A207265637428302C20302C20302C2030293B0D0A202068';
wwv_flow_imp.g_varchar2_table(27) := '65696768743A203170783B0D0A202077696474683A203170783B0D0A2020626F726465723A20303B0D0A20206F766572666C6F773A2068696464656E3B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D66';
wwv_flow_imp.g_varchar2_table(28) := '69656C64206C6162656C207B0D0A2020666C6F61743A206C6566743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C207B0D0A2020646973706C61793A20696E6C696E652D62';
wwv_flow_imp.g_varchar2_table(29) := '6C6F636B3B0D0A20202F2A2077696474683A20363070783B202A2F0D0A20206D696E2D77696474683A20343070783B0D0A20206261636B67726F756E642D636F6C6F723A20236534653465343B0D0A2020636F6C6F723A207267626128302C20302C2030';
wwv_flow_imp.g_varchar2_table(30) := '2C20302E38293B0D0A2020666F6E742D73697A653A20313470783B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020746578742D616C69676E3A2063656E7465723B0D0A2020746578742D736861646F773A206E6F6E653B0D0A2020';
wwv_flow_imp.g_varchar2_table(31) := '70616464696E673A2035707820313470783B0D0A2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E32293B0D0A20202D7765626B69742D626F782D736861646F773A20696E736574203020317078203370782072';
wwv_flow_imp.g_varchar2_table(32) := '67626128302C20302C20302C20302E33292C2030203170782072676261283235352C203235352C203235352C20302E31293B0D0A2020626F782D736861646F773A20696E73657420302031707820337078207267626128302C20302C20302C20302E3329';
wwv_flow_imp.g_varchar2_table(33) := '2C2030203170782072676261283235352C203235352C203235352C20302E31293B0D0A20202D7765626B69742D7472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F75743B0D0A20202D6D6F7A2D7472616E736974696F6E3A2061';
wwv_flow_imp.g_varchar2_table(34) := '6C6C20302E317320656173652D696E2D6F75743B0D0A20202D6D732D7472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F75743B0D0A20202D6F2D7472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F7574';
wwv_flow_imp.g_varchar2_table(35) := '3B0D0A20207472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F75743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C3A686F766572207B0D0A202063';
wwv_flow_imp.g_varchar2_table(36) := '7572736F723A20706F696E7465723B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C6420696E7075743A636865636B65642B6C6162656C207B0D0A20206261636B67726F756E642D636F6C6F72';
wwv_flow_imp.g_varchar2_table(37) := '3A20233146393043423B0D0A2020636F6C6F723A2077686974653B0D0A20202D7765626B69742D626F782D736861646F773A206E6F6E653B0D0A2020626F782D736861646F773A206E6F6E653B0D0A7D0D0A0D0A237072657469757352657665616C6572';
wwv_flow_imp.g_varchar2_table(38) := '496E6C696E65202E7377697463682D6669656C64206C6162656C3A66697273742D6F662D74797065207B0D0A2020626F726465722D7261646975733A2034707820302030203470783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C69';
wwv_flow_imp.g_varchar2_table(39) := '6E65202E7377697463682D6669656C64206C6162656C3A6C6173742D6F662D74797065207B0D0A2020626F726465722D7261646975733A2030203470782034707820303B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65207468';
wwv_flow_imp.g_varchar2_table(40) := '2E742D5265706F72742D636F6C48656164207B0D0A2020626F726465722D7374796C653A20736F6C69643B0D0A20202F2A20626F726465722D636F6C6F723A20233146393043423B202A2F0D0A2020626F726465722D7261646975733A203670783B0D0A';
wwv_flow_imp.g_varchar2_table(41) := '2020626F726465722D77696474683A203270783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572207B0D0A2020636F6C6F723A206F6666696369616C3B0D0A2020646973706C61793A20696E6C';
wwv_flow_imp.g_varchar2_table(42) := '696E652D626C6F636B3B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A202077696474683A20363470783B0D0A20206865696768743A20363470783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C6473';
wwv_flow_imp.g_varchar2_table(43) := '2D7370696E6E657220646976207B0D0A20207472616E73666F726D2D6F726967696E3A203332707820333270783B0D0A2020616E696D6174696F6E3A206C64732D7370696E6E657220312E3273206C696E65617220696E66696E6974653B0D0A7D0D0A0D';
wwv_flow_imp.g_varchar2_table(44) := '0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6166746572207B0D0A2020636F6E74656E743A202220223B0D0A2020646973706C61793A20626C6F636B3B0D0A2020706F736974696F6E3A206162';
wwv_flow_imp.g_varchar2_table(45) := '736F6C7574653B0D0A2020746F703A203370783B0D0A20206C6566743A20323970783B0D0A202077696474683A203570783B0D0A20206865696768743A20313470783B0D0A2020626F726465722D7261646975733A203230253B0D0A20206261636B6772';
wwv_flow_imp.g_varchar2_table(46) := '6F756E643A20233146393043423B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283129207B0D0A20207472616E73666F726D3A20726F7461746528306465';
wwv_flow_imp.g_varchar2_table(47) := '67293B0D0A2020616E696D6174696F6E2D64656C61793A202D312E31733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283229207B0D0A20207472616E73';
wwv_flow_imp.g_varchar2_table(48) := '666F726D3A20726F74617465283330646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D31733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C';
wwv_flow_imp.g_varchar2_table(49) := '64283329207B0D0A20207472616E73666F726D3A20726F74617465283630646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E39733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D737069';
wwv_flow_imp.g_varchar2_table(50) := '6E6E6572206469763A6E74682D6368696C64283429207B0D0A20207472616E73666F726D3A20726F74617465283930646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E38733B0D0A7D0D0A0D0A237072657469757352657665616C';
wwv_flow_imp.g_varchar2_table(51) := '6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283529207B0D0A20207472616E73666F726D3A20726F7461746528313230646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E37733B0D0A7D';
wwv_flow_imp.g_varchar2_table(52) := '0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283629207B0D0A20207472616E73666F726D3A20726F7461746528313530646567293B0D0A2020616E696D6174696F';
wwv_flow_imp.g_varchar2_table(53) := '6E2D64656C61793A202D302E36733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283729207B0D0A20207472616E73666F726D3A20726F74617465283138';
wwv_flow_imp.g_varchar2_table(54) := '30646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E35733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283829207B0D0A20207472';
wwv_flow_imp.g_varchar2_table(55) := '616E73666F726D3A20726F7461746528323130646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E34733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74';
wwv_flow_imp.g_varchar2_table(56) := '682D6368696C64283929207B0D0A20207472616E73666F726D3A20726F7461746528323430646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E33733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E';
wwv_flow_imp.g_varchar2_table(57) := '6C64732D7370696E6E6572206469763A6E74682D6368696C6428313029207B0D0A20207472616E73666F726D3A20726F7461746528323730646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E32733B0D0A7D0D0A0D0A2370726574';
wwv_flow_imp.g_varchar2_table(58) := '69757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C6428313129207B0D0A20207472616E73666F726D3A20726F7461746528333030646567293B0D0A2020616E696D6174696F6E2D64656C61793A';
wwv_flow_imp.g_varchar2_table(59) := '202D302E31733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C6428313229207B0D0A20207472616E73666F726D3A20726F7461746528333330646567293B0D';
wwv_flow_imp.g_varchar2_table(60) := '0A2020616E696D6174696F6E2D64656C61793A2030733B0D0A7D0D0A0D0A406B65796672616D6573206C64732D7370696E6E6572207B0D0A20203025207B0D0A202020206F7061636974793A20313B0D0A20207D0D0A202031303025207B0D0A20202020';
wwv_flow_imp.g_varchar2_table(61) := '6F7061636974793A20303B0D0A20207D0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65206469762370726574697573436F6E74656E74207B0D0A2020666F6E742D66616D696C793A20224C7563696461204772616E6465222C20';
wwv_flow_imp.g_varchar2_table(62) := '5461686F6D612C2056657264616E612C2073616E732D73657269663B0D0A2020666F6E742D73697A653A20313370783B0D0A7D0D0A0D0A2E7072657469757352657665616C6572496E6C696E65546F546865546F70207B0D0A20207A2D696E6465783A20';
wwv_flow_imp.g_varchar2_table(63) := '393939392021696D706F7274616E740D0A7D0D0A0D0A2E7072657469757352657665616C6572496E6C696E65546F546865546F70202E7072657469757352657665616C6572466F6F746572207B0D0A2020626F726465722D7374796C653A20736F6C6964';
wwv_flow_imp.g_varchar2_table(64) := '3B0D0A2020626F726465722D636F6C6F723A206C69676874677265793B0D0A2020626F726465722D77696474683A203170783B0D0A20206261636B67726F756E642D636F6C6F723A20234632463246323B0D0A2020636F6C6F723A20233146393043423B';
wwv_flow_imp.g_varchar2_table(65) := '0D0A2020746578742D616C69676E3A2063656E7465723B0D0A202070616464696E672D6C6566743A203570783B0D0A20206D61782D6865696768743A20323270783B0D0A7D0D0A0D0A2E7072657469757352657665616C6572496E6C696E65546F546865';
wwv_flow_imp.g_varchar2_table(66) := '546F7020612E7072657469757352657665616C65724C696E6B207B0D0A2020636F6C6F723A20233146393043422021696D706F7274616E743B0D0A2020666F6E742D73697A653A20313270780D0A7D0D0A0D0A2E7072657469757352657665616C657249';
wwv_flow_imp.g_varchar2_table(67) := '6E6C696E65546F546865546F70202E707265746975735461626C6F636B56657273696F6E207B0D0A2020666C6F61743A2072696768743B0D0A202070616464696E672D72696768743A203570783B0D0A7D0D0A0D0A2E7072657469757352657665616C65';
wwv_flow_imp.g_varchar2_table(68) := '72496E6C696E65546F546865546F70202E70726574697573466F6F7465724F7074696F6E73207B0D0A2020666C6F61743A206C6566743B200D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C696E6B4C696B65207B0D0A20';
wwv_flow_imp.g_varchar2_table(69) := '20637572736F723A706F696E7465723B0D0A2020636F6C6F723A233146393043423B200D0A20202F2A20746578742D6465636F726174696F6E3A756E6465726C696E653B202A2F0D0A7D0D0A0D0A2F2A2046697820627567207468617420636F70696573';
wwv_flow_imp.g_varchar2_table(70) := '2050445420627574746F6E7320746F20706172656E74207061676520696620697420686173206120627574746F6E7320636F6E7461696E657220726567696F6E202A2F0D0A2E7064742D6F7074696F6E2D627574746F6E3A6E6F74282370726574697573';
wwv_flow_imp.g_varchar2_table(71) := '52657665616C6572427574746F6E526567696F6E202E7064742D6F7074696F6E2D627574746F6E29207B0D0A2020646973706C61793A206E6F6E653B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219978191969840835)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/revealer.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '3C64697620636C6173733D2272657665616C65722D6C6F6164696E67223E0D0A20202020202020203C64697620636C6173733D226C64732D7370696E6E6572223E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A20202020';
wwv_flow_imp.g_varchar2_table(2) := '2020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C';
wwv_flow_imp.g_varchar2_table(3) := '6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A20';
wwv_flow_imp.g_varchar2_table(4) := '2020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(5) := '20203C6469763E3C2F6469763E0D0A20202020202020203C2F6469763E0D0A3C2F6469763E0D0A3C64697620636C6173733D2272657665616C65722D686561646572207377697463682D646973706C61792D6E6F6E65223E0D0A20202020202020203C64';
wwv_flow_imp.g_varchar2_table(6) := '697620636C6173733D227253656172636822207374796C653D2270616464696E673A20303B223E0D0A202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(7) := '2020202020202020202020202020203C696E7075742069643D2772536561726368426F782720747970653D227365617263682220706C616365686F6C6465723D225365617263682E2E2E2220636C6173733D22746578745F6669656C6420617065782D69';
wwv_flow_imp.g_varchar2_table(8) := '74656D2D7465787422207374796C653D226865696768743A32347078223E0D0A2020202020202020202020202020202020202020202020203C7370616E20636C6173733D22742D466F726D2D6974656D5465787420742D466F726D2D6974656D54657874';
wwv_flow_imp.g_varchar2_table(9) := '2D2D706F737422207374796C653D226865696768743A32347078223E0D0A20202020202020202020202020202020202020202020202020202020202020203C627574746F6E2069643D2772436C656172536561726368426F782720747970653D22627574';
wwv_flow_imp.g_varchar2_table(10) := '746F6E22207469746C653D22436C656172205365617263682220617269612D6C6162656C3D22436C65617220536561726368220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22';
wwv_flow_imp.g_varchar2_table(11) := '742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C20742D427574746F6E2D2D6E6F5549223E3C7370616E0D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(12) := '2020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D22747275652220636C6173733D22742D49636F6E2066612066612D74696D6573223E3C2F7370616E3E3C2F627574746F6E3E3C2F7370616E3E0D0A';
wwv_flow_imp.g_varchar2_table(13) := '202020202020202020202020202020203C2F6469763E0D0A20202020202020203C2F6469763E0D0A20202020202020203C6469762069643D227072657469757350616765436F6E74726F6C732220636C6173733D227377697463682D6669656C64223E20';
wwv_flow_imp.g_varchar2_table(14) := '3C2F6469763E0D0A0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C732220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(15) := '202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22506167654974656D73222076616C75653D22504922202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D2250';
wwv_flow_imp.g_varchar2_table(16) := '6167654974656D732220636C6173733D22707265746975735461624C6162656C223E50616765204974656D730D0A2020202020202020202020202020202020202020202020203C7370616E2069643D225049636F756E746572223E3C2F7370616E3E0D0A';
wwv_flow_imp.g_varchar2_table(17) := '202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D225061676553656C656374656441626F';
wwv_flow_imp.g_varchar2_table(18) := '7665222076616C75653D22505822202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D225061676553656C656374656441626F76652220636C6173733D22707265746975735461624C6162656C223E50580D0A202020202020';
wwv_flow_imp.g_varchar2_table(19) := '2020202020202020202020202020202020203C7370616E2069643D225058636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E7075742074';
wwv_flow_imp.g_varchar2_table(20) := '7970653D22726164696F22206E616D653D227043617465676F7279222069643D22506167655A65726F222076616C75653D22503022202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22506167655A65726F2220636C6173';
wwv_flow_imp.g_varchar2_table(21) := '733D22707265746975735461624C6162656C223E50300D0A2020202020202020202020202020202020202020202020203C7370616E2069643D225030636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C616265';
wwv_flow_imp.g_varchar2_table(22) := '6C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D226F74686572506167654974656D73222076616C75653D22504F22202F3E0D0A202020202020';
wwv_flow_imp.g_varchar2_table(23) := '202020202020202020203C6C6162656C20666F723D226F74686572506167654974656D732220636C6173733D22707265746975735461624C6162656C223E4F74686572730D0A2020202020202020202020202020202020202020202020203C7370616E20';
wwv_flow_imp.g_varchar2_table(24) := '69643D22504F636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A20202020202020203C2F6469763E0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F';
wwv_flow_imp.g_varchar2_table(25) := '6E74726F6C73322220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F727922206964';
wwv_flow_imp.g_varchar2_table(26) := '3D22496E7465726163746976655265706F7274222076616C75653D22495222202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22496E7465726163746976655265706F72742220636C6173733D2270726574697573546162';
wwv_flow_imp.g_varchar2_table(27) := '4C6162656C223E496E742E205265702E0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224952636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A';
wwv_flow_imp.g_varchar2_table(28) := '202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22496E74657261637469766547726964222076616C75653D22494722202F3E0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(29) := '20202020203C6C6162656C20666F723D22496E746572616374697665477269642220636C6173733D22707265746975735461624C6162656C223E496E742E20477269640D0A2020202020202020202020202020202020202020202020203C7370616E2069';
wwv_flow_imp.g_varchar2_table(30) := '643D224947636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F';
wwv_flow_imp.g_varchar2_table(31) := '7279222069643D224170706C69636174696F6E4974656D73222076616C75653D22414922202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224170706C69636174696F6E4974656D732220636C6173733D22707265746975';
wwv_flow_imp.g_varchar2_table(32) := '735461624C6162656C223E4170702E204974656D730D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224149636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C';
wwv_flow_imp.g_varchar2_table(33) := '3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22537562737469747574696F6E537472696E6773222076616C75653D22534222202F3E0D0A2020';
wwv_flow_imp.g_varchar2_table(34) := '20202020202020202020202020203C6C6162656C20666F723D22537562737469747574696F6E537472696E67732220636C6173733D22707265746975735461624C6162656C223E537562732E0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(35) := '20203C7370616E2069643D225342636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D65';
wwv_flow_imp.g_varchar2_table(36) := '3D227043617465676F7279222069643D22436F6E74657874222076616C75653D22435822202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22436F6E746578742220636C6173733D22707265746975735461624C6162656C';
wwv_flow_imp.g_varchar2_table(37) := '223E436C69656E740D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224358636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(38) := '20202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D224672616D65776F726B4974656D73222076616C75653D22465722202F3E0D0A202020202020202020202020202020203C6C6162';
wwv_flow_imp.g_varchar2_table(39) := '656C20666F723D224672616D65776F726B4974656D732220636C6173733D22707265746975735461624C6162656C223E4672616D65776F726B0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224657636F756E74';
wwv_flow_imp.g_varchar2_table(40) := '6572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C7333';
wwv_flow_imp.g_varchar2_table(41) := '2220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22497465';
wwv_flow_imp.g_varchar2_table(42) := '6D73416C6C222076616C75653D22416C6C22202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224974656D73416C6C2220636C6173733D227377697463682D616C6F6E6520707265746975735461624C6162656C223E416C';
wwv_flow_imp.g_varchar2_table(43) := '6C0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D22414C4C636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E';
wwv_flow_imp.g_varchar2_table(44) := '0D0A0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C73352220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(45) := '203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D224974656D734150222076616C75653D22415022202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224974656D7341';
wwv_flow_imp.g_varchar2_table(46) := '502220636C6173733D227377697463682D616C6F6E6520707265746975735461624C6162656C223E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020636C6173733D2266612066612D696E666F2D737175';
wwv_flow_imp.g_varchar2_table(47) := '6172652D6F20752D616C69676E4D6964646C652220617269612D68696464656E3D2274727565223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224150636F756E746572223E3C2F7370616E';
wwv_flow_imp.g_varchar2_table(48) := '3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C73342220636C6173733D2273';
wwv_flow_imp.g_varchar2_table(49) := '77697463682D6669656C6420736964652D62792D73696465223E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D2244656275675061676522207661';
wwv_flow_imp.g_varchar2_table(50) := '6C75653D2244656275675061676522202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224465627567506167652220636C6173733D227377697463682D616C6F6E6520707265746975735461624C6162656C223E3C737061';
wwv_flow_imp.g_varchar2_table(51) := '6E20636C6173733D2266612066612D62756720752D616C69676E4D6964646C65220D0A2020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E0D0A2020202020';
wwv_flow_imp.g_varchar2_table(52) := '202020202020202020202020202020202020203C7370616E2069643D22585858636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A3C2F6469763E';
wwv_flow_imp.g_varchar2_table(53) := '0D0A0D0A3C6469762069643D2270726574697573436F6E74656E74223E203C2F6469763E0D0A0D0A3C6469762069643D22707265746975734465627567436F6E74656E74223E203C2F6469763E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219978571582840839)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/revealer.html'
,p_mime_type=>'text/html'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '766172207072657469757352657665616C6572203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A20202020766172205F7461626C655F203D20646F63756D656E742E637265617465456C656D656E7428';
wwv_flow_imp.g_varchar2_table(2) := '277461626C6527292C0D0A20202020202020205F74725F203D20646F63756D656E742E637265617465456C656D656E742827747227292C0D0A20202020202020205F74685F203D20646F63756D656E742E637265617465456C656D656E74282774682729';
wwv_flow_imp.g_varchar2_table(3) := '2C0D0A20202020202020205F74645F203D20646F63756D656E742E637265617465456C656D656E742827746427293B0D0A0D0A202020205F7461626C655F2E636C6173734E616D65203D20277461626C655461626C6F636B56617273273B0D0A20202020';
wwv_flow_imp.g_varchar2_table(4) := '5F74725F2E636C6173734E616D65203D202764617461526F77273B0D0A202020205F74685F2E636C6173734E616D65203D2027742D5265706F72742D636F6C48656164273B0D0A202020205F74645F2E636C6173734E616D65203D202774645461626C6F';
wwv_flow_imp.g_varchar2_table(5) := '636B56617273273B0D0A0D0A202020202F2F204275696C6473207468652048544D4C205461626C65206F7574206F66206D794C697374206A736F6E20646174612E0D0A2020202066756E6374696F6E206275696C6448746D6C5461626C65286172722920';
wwv_flow_imp.g_varchar2_table(6) := '7B0D0A2020202020202020766172207461626C65203D205F7461626C655F2E636C6F6E654E6F64652866616C7365292C0D0A202020202020202020202020636F6C756D6E73203D20616464416C6C436F6C756D6E48656164657273286172722C20746162';
wwv_flow_imp.g_varchar2_table(7) := '6C65293B0D0A2020202020202020666F7220287661722069203D20302C206D617869203D206172722E6C656E6774683B2069203C206D6178693B202B2B6929207B0D0A202020202020202020202020766172207472203D205F74725F2E636C6F6E654E6F';
wwv_flow_imp.g_varchar2_table(8) := '64652866616C7365293B0D0A202020202020202020202020666F722028766172206A203D20302C206D61786A203D20636F6C756D6E732E6C656E6774683B206A203C206D61786A3B202B2B6A29207B0D0A20202020202020202020202020202020766172';
wwv_flow_imp.g_varchar2_table(9) := '207464203D205F74645F2E636C6F6E654E6F64652866616C7365293B0D0A202020202020202020202020202020207661722063656C6C56616C7565203D206172725B695D5B636F6C756D6E735B6A5D5D3B0D0A2020202020202020202020202020202074';
wwv_flow_imp.g_varchar2_table(10) := '642E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F6465286172725B695D5B636F6C756D6E735B6A5D5D207C7C20272729293B0D0A2020202020202020202020202020202074722E617070656E644368696C64287464';
wwv_flow_imp.g_varchar2_table(11) := '293B0D0A2020202020202020202020207D0D0A2020202020202020202020207461626C652E617070656E644368696C64287472293B0D0A20202020202020207D0D0A202020202020202072657475726E207461626C653B0D0A202020207D0D0A0D0A2020';
wwv_flow_imp.g_varchar2_table(12) := '20202F2F204164647320612068656164657220726F7720746F20746865207461626C6520616E642072657475726E732074686520736574206F6620636F6C756D6E732E0D0A202020202F2F204E65656420746F20646F20756E696F6E206F66206B657973';
wwv_flow_imp.g_varchar2_table(13) := '2066726F6D20616C6C207265636F72647320617320736F6D65207265636F726473206D6179206E6F7420636F6E7461696E0D0A202020202F2F20616C6C207265636F7264730D0A2020202066756E6374696F6E20616464416C6C436F6C756D6E48656164';
wwv_flow_imp.g_varchar2_table(14) := '657273286172722C207461626C6529207B0D0A202020202020202076617220636F6C756D6E536574203D205B5D2C0D0A2020202020202020202020207472203D205F74725F2E636C6F6E654E6F64652866616C7365293B0D0A2020202020202020666F72';
wwv_flow_imp.g_varchar2_table(15) := '20287661722069203D20302C206C203D206172722E6C656E6774683B2069203C206C3B20692B2B29207B0D0A202020202020202020202020666F722028766172206B657920696E206172725B695D29207B0D0A2020202020202020202020202020202069';
wwv_flow_imp.g_varchar2_table(16) := '6620286172725B695D2E6861734F776E50726F7065727479286B65792920262620636F6C756D6E5365742E696E6465784F66286B657929203D3D3D202D3129207B0D0A2020202020202020202020202020202020202020636F6C756D6E5365742E707573';
wwv_flow_imp.g_varchar2_table(17) := '68286B6579293B0D0A2020202020202020202020202020202020202020766172207468203D205F74685F2E636C6F6E654E6F64652866616C7365293B0D0A202020202020202020202020202020202020202074682E617070656E644368696C6428646F63';
wwv_flow_imp.g_varchar2_table(18) := '756D656E742E637265617465546578744E6F6465286B657929293B0D0A202020202020202020202020202020202020202074722E617070656E644368696C64287468293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(19) := '207D0D0A20202020202020207D0D0A20202020202020207461626C652E617070656E644368696C64287472293B0D0A202020202020202072657475726E20636F6C756D6E5365743B0D0A202020207D0D0A0D0A2020202066756E6374696F6E2064697374';
wwv_flow_imp.g_varchar2_table(20) := '696E637450616765732861727229207B0D0A20202020202020202F2F20476574732044697374696E63742050616765730D0A2020202020202020766172206C6F6F6B7570203D207B7D3B0D0A2020202020202020766172206974656D73203D206172723B';
wwv_flow_imp.g_varchar2_table(21) := '0D0A202020202020202076617220726573756C74203D205B5D3B0D0A2020202020202020666F722028766172206974656D2C2069203D20303B206974656D203D206974656D735B692B2B5D3B29207B0D0A202020202020202020202020766172206E616D';
wwv_flow_imp.g_varchar2_table(22) := '65203D206974656D2E506167653B0D0A0D0A2020202020202020202020206966202821286E616D6520696E206C6F6F6B75702929207B0D0A202020202020202020202020202020206C6F6F6B75705B6E616D655D203D20313B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(23) := '20202020202020726573756C742E70757368286E616D65293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020202020202072657475726E20726573756C742E7265766572736528293B0D0A202020207D0D0A0D0A20202020';
wwv_flow_imp.g_varchar2_table(24) := '66756E6374696F6E20637573746F6D6973655461626C652829207B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E652074722E64617461526F7722292E656163682866756E6374696F6E202829207B0D0A0D0A';
wwv_flow_imp.g_varchar2_table(25) := '202020202020202020202020766172202474686973203D20242874686973293B0D0A20202020202020202020202076617220634E616D65203D2024746869732E66696E64282274643A6E74682D6368696C6428322922293B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(26) := '2020766172206343617465676F7279203D2024746869732E66696E64282274643A6E74682D6368696C6428332922293B0D0A202020202020202020202020766172206343617465676F727948203D2024746869732E66696E64282274643A6E74682D6368';
wwv_flow_imp.g_varchar2_table(27) := '696C6428332922292E68746D6C28293B0D0A202020202020202020202020766172206C6173744368696C6448203D2024746869732E66696E64282274643A6C6173742D6368696C6422292E68746D6C28293B0D0A0D0A2020202020202020202020202F2F';
wwv_flow_imp.g_varchar2_table(28) := '2048696464656E203D20426F6C640D0A202020202020202020202020696620282821634E616D652E686173436C61737328227072657469757352657665616C6572417474656E74696F6E2229292026262028747970656F6620286343617465676F727948';
wwv_flow_imp.g_varchar2_table(29) := '2920213D2027756E646566696E656427202626206343617465676F7279482E746F537472696E6728292E73746172747357697468282248494444454E22292929207B0D0A20202020202020202020202020202020634E616D652E616464436C6173732822';
wwv_flow_imp.g_varchar2_table(30) := '7072657469757352657665616C6572417474656E74696F6E22293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F204E6F6E2052656E6465726564203D20426F6C640D0A202020202020202020202020696620282821';
wwv_flow_imp.g_varchar2_table(31) := '634E616D652E686173436C61737328227072657469757352657665616C65724E6F6E52656E64657265642229292026262028747970656F6620286C6173744368696C64482920213D2027756E646566696E656427202626206C6173744368696C64482E74';
wwv_flow_imp.g_varchar2_table(32) := '6F537472696E6728292E696E636C7564657328224E5222292929207B0D0A20202020202020202020202020202020634E616D652E616464436C61737328227072657469757352657665616C65724E6F6E52656E646572656422293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(33) := '202020202020202020634E616D652E6174747228277469746C65272C20274E6F6E2D52656E6465726564204974656D27293B0D0A2020202020202020202020207D0D0A0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E';
wwv_flow_imp.g_varchar2_table(34) := '6374696F6E2064697374696E637447726F75707328705061676529207B0D0A202020202020202076617220726573756C74203D205B5D3B0D0A20202020202020207661722063617465676F72794172726179203D205B225058222C20225049222C202250';
wwv_flow_imp.g_varchar2_table(35) := '30222C2022504F222C20224952222C20224947222C20224149222C20225342222C20224358222C20224657222C20224150222C2022414C4C225D3B0D0A20202020202020207661722063686B53426F78203D20242827237072657469757352657665616C';
wwv_flow_imp.g_varchar2_table(36) := '6572496E6C696E65202372536561726368426F7827292E76616C28292E746F55707065724361736528293B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E74';
wwv_flow_imp.g_varchar2_table(37) := '657222292E74657874282727293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E74657222292E72656D6F7665436C61737328226E6F74696669636174696F6E2D';
wwv_flow_imp.g_varchar2_table(38) := '636F756E74657222293B0D0A0D0A202020202020202066756E6374696F6E20676574436F756E7428704361746529207B0D0A20202020202020202020202076617220746F74616C43617465203D20303B0D0A202020202020202020202020242822237072';
wwv_flow_imp.g_varchar2_table(39) := '657469757352657665616C6572496E6C696E652074722E64617461526F7722292E656163682866756E6374696F6E202829207B0D0A0D0A20202020202020202020202020202020766172202474686973203D20242874686973293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(40) := '20202020202020202076617220746450616765203D2024746869732E66696E64282274643A666972737422292E68746D6C28293B0D0A2020202020202020202020202020202076617220746443617465203D2024746869732E66696E64282274643A6C61';
wwv_flow_imp.g_varchar2_table(41) := '737422292E68746D6C28293B0D0A202020202020202020202020202020207661722074644E616D6556616C756573203D2024746869732E66696E64282274643A6E74682D6368696C6428322922292E68746D6C2829202B20272027202B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(42) := '20202020202020202020202020202024746869732E66696E64282274643A6E74682D6368696C6428332922292E68746D6C2829202B20272027202B0D0A202020202020202020202020202020202020202024746869732E66696E64282274643A6E74682D';
wwv_flow_imp.g_varchar2_table(43) := '6368696C6428342922292E68746D6C2829202B20272027202B0D0A202020202020202020202020202020202020202024746869732E66696E64282274643A6E74682D6368696C6428352922292E68746D6C28293B0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(44) := '202074644E616D6556616C756573203D2074644E616D6556616C7565732E746F537472696E6728292E746F55707065724361736528293B0D0A0D0A2020202020202020202020202020202069662028285B70506167652C20272A275D2E696E6465784F66';
wwv_flow_imp.g_varchar2_table(45) := '2874645061676529203E202D31207C7C207050616765203D3D2027416C6C27292026260D0A2020202020202020202020202020202020202020747970656F6620287464436174652920213D2027756E646566696E6564272026260D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(46) := '2020202020202020202020207464436174652E73706C697428222C22292E696E6465784F6628704361746529203E3D20302026260D0A20202020202020202020202020202020202020202874644E616D6556616C7565732E696E6465784F662863686B53';
wwv_flow_imp.g_varchar2_table(47) := '426F782920213D3D202D31290D0A2020202020202020202020202020202029207B0D0A2020202020202020202020202020202020202020746F74616C43617465203D20746F74616C43617465202B20313B0D0A202020202020202020202020202020207D';
wwv_flow_imp.g_varchar2_table(48) := '0D0A0D0A2020202020202020202020202020202069662028285B70506167652C20272A275D2E696E6465784F662874645061676529203E202D31207C7C207050616765203D3D2027416C6C27290D0A202020202020202020202020202020202020202026';
wwv_flow_imp.g_varchar2_table(49) := '26207043617465203D3D2027414C4C272026260D0A2020202020202020202020202020202020202020747970656F6620287464436174652920213D2027756E646566696E6564272026260D0A202020202020202020202020202020202020202074644361';
wwv_flow_imp.g_varchar2_table(50) := '746520213D202743617465676F7279272026260D0A20202020202020202020202020202020202020202874644E616D6556616C7565732E696E6465784F662863686B53426F782920213D3D202D31290D0A2020202020202020202020202020202029207B';
wwv_flow_imp.g_varchar2_table(51) := '0D0A2020202020202020202020202020202020202020746F74616C43617465203D20746F74616C43617465202B20313B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(52) := '72657475726E20746F74616C436174653B0D0A20202020202020207D0D0A0D0A2020202020202020666F7220287661722069203D20303B2069203C2063617465676F727941727261792E6C656E6774683B20692B2B29207B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(53) := '20207661722063203D2063617465676F727941727261795B695D3B0D0A2020202020202020202020207661722063617465436F756E74203D20676574436F756E742863293B0D0A2020202020202020202020206966202863617465436F756E74203E2030';
wwv_flow_imp.g_varchar2_table(54) := '29207B0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E65202322202B2063202B2022636F756E74657222292E616464436C61737328226E6F74696669636174696F6E2D636F756E74657222292E';
wwv_flow_imp.g_varchar2_table(55) := '746578742863617465436F756E74293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A202020202020202072657475726E20726573756C743B0D0A202020207D0D0A0D0A2020202066756E6374696F6E207061676544656C69';
wwv_flow_imp.g_varchar2_table(56) := '6D657465642829207B0D0A2020202020202020766172207061676544656C696D65746564203D20242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F775374657049645D';
wwv_flow_imp.g_varchar2_table(57) := '3A636865636B656422292E76616C28293B0D0A2020202020202020696620287061676544656C696D65746564203D3D2027416C6C2729207B0D0A2020202020202020202020207061676544656C696D65746564203D202428272370726574697573526576';
wwv_flow_imp.g_varchar2_table(58) := '65616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7327292E6174747228276A757374506167657327293B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A202020202020202020202020706167654465';
wwv_flow_imp.g_varchar2_table(59) := '6C696D65746564203D20273A27202B207061676544656C696D65746564202B20273A273B0D0A20202020202020207D0D0A202020202020202072657475726E207061676544656C696D657465643B0D0A202020207D0D0A0D0A2020202066756E6374696F';
wwv_flow_imp.g_varchar2_table(60) := '6E20676574446562756756696577436F6E74656E742829207B0D0A0D0A20202020202020202F2F2064656163746976617465206465627567207768656E2072657665616C65722067657474696E6720646174610D0A202020202020202024282723707265';
wwv_flow_imp.g_varchar2_table(61) := '7469757352657665616C6572496E6C696E65202372536561726368426F7827292E76616C282727293B0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E706C75';
wwv_flow_imp.g_varchar2_table(62) := '67696E287064742E6F70742E616A61784964656E7469666965722C207B0D0A2020202020202020202020207830313A202744454255475F56494557272C0D0A2020202020202020202020207830323A207061676544656C696D6574656428290D0A202020';
wwv_flow_imp.g_varchar2_table(63) := '20202020207D2C207B0D0A202020202020202020202020737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(64) := '202020202020202020242827237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E7427292E656D70747928293B0D0A2020202020202020202020202020202024282723707265746975735265766561';
wwv_flow_imp.g_varchar2_table(65) := '6C6572496E6C696E652023707265746975734465627567436F6E74656E7427292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528646174612E6974656D7329293B0D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(66) := '2020726F775374726F6B657328293B0D0A0D0A202020202020202020202020202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F363135353332320D0A202020202020202020202020202020202F2F20476574206669';
wwv_flow_imp.g_varchar2_table(67) := '72737420636F6C756D6E0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E74202E74645461626C6F636B566172733A66697273742D6368696C';
wwv_flow_imp.g_varchar2_table(68) := '6422292E656163682866756E6374696F6E20286549647829207B0D0A0D0A20202020202020202020202020202020202020207661722061203D20242874686973293B0D0A2020202020202020202020202020202020202020242861292E616464436C6173';
wwv_flow_imp.g_varchar2_table(69) := '7328276C696E6B4C696B6527293B0D0A0D0A2020202020202020202020202020202020202020696620286129207B0D0A202020202020202020202020202020202020202020202020612E6F6E2822636C69636B222C2066756E6374696F6E20286576656E';
wwv_flow_imp.g_varchar2_table(70) := '7429207B0D0A2020202020202020202020202020202020202020202020202020202067657444656275675669657744657461696C28242861292E746578742829293B0D0A2020202020202020202020202020202020202020202020207D293B0D0A202020';
wwv_flow_imp.g_varchar2_table(71) := '20202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020706572666F726D46696C74657228293B0D0A0D0A2020202020202020202020207D2C0D0A202020';
wwv_flow_imp.g_varchar2_table(72) := '2020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A202020202020202020202020202020202F2F2068616E646C65206572726F720D0A202020202020';
wwv_flow_imp.g_varchar2_table(73) := '202020202020202020207064742E616A61784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A202020207D';
wwv_flow_imp.g_varchar2_table(74) := '0D0A0D0A0D0A2020202066756E6374696F6E2067657444656275675669657744657461696C2870566965774964656E74696669657229207B0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237253656172';
wwv_flow_imp.g_varchar2_table(75) := '6368426F7827292E76616C282727293B0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965';
wwv_flow_imp.g_varchar2_table(76) := '722C207B0D0A2020202020202020202020207830313A202744454255475F44455441494C272C0D0A2020202020202020202020207830323A2070566965774964656E7469666965720D0A20202020202020207D2C207B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(77) := '737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A202020202020202020202020202020202428272370726574697573526576';
wwv_flow_imp.g_varchar2_table(78) := '65616C6572496E6C696E652023707265746975734465627567436F6E74656E7427292E656D70747928293B0D0A20202020202020202020202020202020242827237072657469757352657665616C6572496E6C696E652023707265746975734465627567';
wwv_flow_imp.g_varchar2_table(79) := '436F6E74656E7427292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528646174612E6974656D7329293B0D0A20202020202020202020202020202020726F775374726F6B657328293B200D0A2020202020';
wwv_flow_imp.g_varchar2_table(80) := '202020202020207D2C0D0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A202020202020202020202020202020202F2F2068616E646C65';
wwv_flow_imp.g_varchar2_table(81) := '206572726F720D0A202020202020202020202020202020207064742E616A61784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A202020202020';
wwv_flow_imp.g_varchar2_table(82) := '20207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E20726F775374726F6B65732829207B0D0A20202020202020202F2F2041646420416C7465726E61746520526F77207374726F6B65730D0A202020202020202024282723707265';
wwv_flow_imp.g_varchar2_table(83) := '7469757352657665616C6572496E6C696E65202E616C7465726E6174652D726F77732D746C27292E72656D6F7665436C6173732827616C7465726E6174652D726F77732D746C27293B0D0A2020202020202020242827237072657469757352657665616C';
wwv_flow_imp.g_varchar2_table(84) := '6572496E6C696E65202E7461626C655461626C6F636B5661727320747227292E66696C7465722866756E6374696F6E202829207B0D0A20202020202020202020202072657475726E20242874686973292E63737328277669736962696C6974792729203D';
wwv_flow_imp.g_varchar2_table(85) := '3D202776697369626C65273B0D0A20202020202020207D292E66696C74657228273A6F646427292E616464436C6173732827616C7465726E6174652D726F77732D746C27293B0D0A202020207D0D0A0D0A2020202066756E6374696F6E20706572666F72';
wwv_flow_imp.g_varchar2_table(86) := '6D46696C7465722829207B0D0A0D0A202020202020202076617220686964655061676556616C7565466F72203D205B225342222C20224358222C20224149222C20224150225D3B0D0A2020202020202020766172206869646553657373696F6E56616C75';
wwv_flow_imp.g_varchar2_table(87) := '65466F72203D205B224657222C20224952222C20224947225D3B0D0A2020202020202020766172206A71507265666578203D2027273B0D0A0D0A20202020202020207661722063686B50616765203D20242822237072657469757352657665616C657249';
wwv_flow_imp.g_varchar2_table(88) := '6E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F775374657049645D3A636865636B656422292E76616C28293B0D0A20202020202020207661722063686B43617465203D20242822237072657469757352657665616C65';
wwv_flow_imp.g_varchar2_table(89) := '72496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A636865636B656422292E76616C28293B0D0A20202020202020207661722063686B53426F78203D20242827237072657469757352657665616C65';
wwv_flow_imp.g_varchar2_table(90) := '72496E6C696E65202372536561726368426F7827292E76616C28292E746F55707065724361736528293B0D0A0D0A2020202020202020766172205061676553656C656374656441626F7665203D202428226C6162656C5B666F723D275061676553656C65';
wwv_flow_imp.g_varchar2_table(91) := '6374656441626F7665275D22293B0D0A20202020202020205061676553656C656374656441626F76652E68746D6C28225022202B2063686B506167652E73706C697428225F22295B305D202B20273C7370616E2069643D225058636F756E746572223E3C';
wwv_flow_imp.g_varchar2_table(92) := '2F7370616E3E27293B0D0A20202020202020205061676553656C656374656441626F76652E72656D6F7665436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A0D0A202020202020202024282723707265746975735265766561';
wwv_flow_imp.g_varchar2_table(93) := '6C6572496E6C696E65207461626C652E7461626C655461626C6F636B5661727320747220746827292E73686F7728293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F';
wwv_flow_imp.g_varchar2_table(94) := '636B5661727320747220746427292E73686F7728293B0D0A0D0A20202020202020206966202863686B43617465203D3D20274465627567506167652729207B0D0A2020202020202020202020206A71507265666578203D20272370726574697573526576';
wwv_flow_imp.g_varchar2_table(95) := '65616C6572496E6C696E652023707265746975734465627567436F6E74656E74273B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E6869646528293B0D';
wwv_flow_imp.g_varchar2_table(96) := '0A20202020202020202020202024286A71507265666578292E73686F7728293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206A71507265666578203D2027237072657469757352657665616C6572496E6C696E652023';
wwv_flow_imp.g_varchar2_table(97) := '70726574697573436F6E74656E74273B0D0A20202020202020202020202024286A71507265666578292E73686F7728293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573446562';
wwv_flow_imp.g_varchar2_table(98) := '7567436F6E74656E7427292E6869646528293B0D0A20202020202020207D0D0A0D0A0D0A20202020202020206966202863686B50616765203D3D2027416C6C2729207B0D0A2020202020202020202020205061676553656C656374656441626F76652E61';
wwv_flow_imp.g_varchar2_table(99) := '6464436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A2020202020202020202020206966202863686B43617465203D3D202750582729207B0D0A20202020202020202020202020202020242822237072657469757352657665';
wwv_flow_imp.g_varchar2_table(100) := '616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A666972737422292E747269676765722822636C69636B22293B0D0A2020202020202020202020202020202072657475726E3B0D0A202020';
wwv_flow_imp.g_varchar2_table(101) := '2020202020202020207D0D0A20202020202020207D0D0A0D0A202020202020202069662028686964655061676556616C7565466F722E696E636C756465732863686B436174652929207B0D0A202020202020202020202020242827237072657469757352';
wwv_flow_imp.g_varchar2_table(102) := '657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074683A6E74682D6368696C6428342927292E6869646528293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E';
wwv_flow_imp.g_varchar2_table(103) := '6C696E65207461626C652E7461626C655461626C6F636B566172732074722074643A6E74682D6368696C6428342927292E6869646528293B0D0A20202020202020207D0D0A0D0A2020202020202020696620286869646553657373696F6E56616C756546';
wwv_flow_imp.g_varchar2_table(104) := '6F722E696E636C756465732863686B436174652929207B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074683A6E74682D6368696C';
wwv_flow_imp.g_varchar2_table(105) := '6428352927292E6869646528293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074643A6E74682D6368696C6428352927292E6869';
wwv_flow_imp.g_varchar2_table(106) := '646528293B0D0A20202020202020207D0D0A0D0A202020202020202024286A71507265666578202B20222074722E64617461526F773A6E6F74283A66697273742922292E63737328227669736962696C697479222C2022636F6C6C6170736522293B0D0A';
wwv_flow_imp.g_varchar2_table(107) := '202020202020202024286A71507265666578202B20222074722E64617461526F7722292E656163682866756E6374696F6E202829207B0D0A0D0A202020202020202020202020766172202474686973203D20242874686973293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(108) := '2020202076617220746450616765203D2024746869732E66696E64282274643A666972737422292E68746D6C28293B0D0A20202020202020202020202076617220746443617465203D2024746869732E66696E64282274643A6C61737422292E68746D6C';
wwv_flow_imp.g_varchar2_table(109) := '28293B0D0A0D0A202020202020202020202020766172206669656C6453656C6563746F72203D20277464273B0D0A0D0A2020202020202020202020206966202863686B4361746520213D20274465627567506167652729207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(110) := '202020202020206669656C6453656C6563746F72203D202774643A6E6F74283A66697273742C203A6C61737429273B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020207661722074644E616D6556616C756573203D20247468';
wwv_flow_imp.g_varchar2_table(111) := '69732E66696E64286669656C6453656C6563746F72292E6D61702866756E6374696F6E202829207B0D0A2020202020202020202020202020202072657475726E20242874686973292E7465787428293B0D0A2020202020202020202020207D292E676574';
wwv_flow_imp.g_varchar2_table(112) := '28292E6A6F696E28272027292E746F55707065724361736528293B0D0A0D0A2020202020202020202020206966202863686B43617465203D3D20274465627567506167652729207B0D0A20202020202020202020202020202020696620280D0A20202020';
wwv_flow_imp.g_varchar2_table(113) := '202020202020202020202020202020202863686B53426F78203D3D202727207C7C2074644E616D6556616C7565732E696E6465784F662863686B53426F782920213D3D202D31290D0A2020202020202020202020202020202029207B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(114) := '202020202020202020202020202024746869732E63737328227669736962696C697479222C202276697369626C6522293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D20656C7365207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(115) := '202020202020202069662028285B63686B506167652C20272A275D2E696E6465784F662874645061676529203E202D31207C7C2063686B50616765203D3D2027416C6C27292026260D0A202020202020202020202020202020202020202028747970656F';
wwv_flow_imp.g_varchar2_table(116) := '66202874644361746529203D3D2027756E646566696E656427207C7C0D0A2020202020202020202020202020202020202020202020207464436174652E73706C697428222C22292E696E6465784F662863686B4361746529203E3D2030207C7C0D0A2020';
wwv_flow_imp.g_varchar2_table(117) := '2020202020202020202020202020202020202020202063686B43617465203D3D2027416C6C27292026260D0A20202020202020202020202020202020202020202874644E616D6556616C7565732E696E6465784F662863686B53426F782920213D3D202D';
wwv_flow_imp.g_varchar2_table(118) := '31290D0A2020202020202020202020202020202029207B0D0A202020202020202020202020202020202020202024746869732E63737328227669736962696C697479222C202276697369626C6522293B0D0A202020202020202020202020202020207D0D';
wwv_flow_imp.g_varchar2_table(119) := '0A2020202020202020202020207D0D0A0D0A20202020202020207D293B0D0A0D0A20202020202020202F2F2041646420546F74616C730D0A202020202020202064697374696E637447726F7570732863686B50616765293B0D0A2020202020202020726F';
wwv_flow_imp.g_varchar2_table(120) := '775374726F6B657328293B0D0A0D0A202020207D0D0A0D0A2020202072657475726E207B0D0A2020202020202020706572666F726D46696C7465723A20706572666F726D46696C7465722C0D0A202020202020202064697374696E637447726F7570733A';
wwv_flow_imp.g_varchar2_table(121) := '2064697374696E637447726F7570732C0D0A20202020202020206275696C6448746D6C5461626C653A206275696C6448746D6C5461626C652C0D0A2020202020202020637573746F6D6973655461626C653A20637573746F6D6973655461626C652C0D0A';
wwv_flow_imp.g_varchar2_table(122) := '202020202020202064697374696E637450616765733A2064697374696E637450616765732C0D0A2020202020202020676574446562756756696577436F6E74656E743A20676574446562756756696577436F6E74656E742C0D0A20202020202020207061';
wwv_flow_imp.g_varchar2_table(123) := '676544656C696D657465643A207061676544656C696D657465640D0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(219978985695840844)
,p_plugin_id=>wwv_flow_imp.id(236191428466094549)
,p_file_name=>'revealer/revealer.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
