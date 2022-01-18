prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2200493861665884
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'E'
);
end;
/
 
prompt APPLICATION 102 - Tip
--
-- Application Export:
--   Application:     102
--   Name:            Tip
--   Date and Time:   12:26 Monday January 10, 2022
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 5301589844662579
--   Manifest End
--   Version:         20.2.0.00.20
--   Instance ID:     300141872330586
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_pretius_apex_devtool
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(5301589844662579)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.PRETIUS.APEX.DEVTOOL'
,p_display_name=>'Pretius Developer Tool'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix=>'&APP_PRETIUS_DEVTOOL_PREFIX.'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#pretiusDeveloperTool.js',
'#PLUGIN_FILES#jquery.ui.dialog-collapse.js',
'#PLUGIN_FILES#contentRevealer.js',
'#PLUGIN_FILES#revealer.js',
'#PLUGIN_FILES#contentReloadFrame.js',
'#PLUGIN_FILES#mousetrap.min.js',
'#PLUGIN_FILES#mousetrap-global-bind.min.js',
'#PLUGIN_FILES#contentBuildOptionHighlight.js'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#revealer.css',
'#PLUGIN_FILES#jquery.ui.dialog-collapse.css',
'#PLUGIN_FILES#contentBuildOptionHighlight.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    /*',
'    * Plugin:   Pretius Developer Tool',
'    * Version:  21.2.5',
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
'  BEGIN',
'    -- Debug',
'    IF apex_application.g_debug ',
'    THEN',
'      apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                            p_dynamic_action => p_dynamic_action);',
'    END IF;',
'',
'    SELECT *',
'      INTO l_plugs_row',
'      FROM apex_appl_plugins',
'     WHERE application_id = :APP_ID',
'       AND name = c_plugin_name;',
'',
'    SELECT count(*)',
'     INTO l_configuration_test',
'     from APEX_APPLICATION_PAGE_DA_ACTS a,',
'          APEX_APPLICATION_PAGE_DA d,',
'          apex_application_build_options b',
'    where a.application_id = :APP_ID ',
'      and a.page_id = 0',
'      and a.action_code = ''PLUGIN_'' || c_plugin_name',
'      and d.dynamic_action_id = a.dynamic_action_id',
'      and d.build_option_id = b.build_option_id',
'      and b.status_on_export = ''Exclude'';',
'',
'    v_result.javascript_function := ',
'    apex_string.format(',
'    q''[function render() {',
'        pdt.render({',
'            da: this,',
'            opt: { filePrefix: "%s",',
'                   ajaxIdentifier: "%s",',
'                   version: "%s",',
'                   debugPrefix: "%s",',
'                   configurationTest: "%s" }',
'        });',
'        }]'',',
'    p_plugin.file_prefix,',
'    apex_plugin.get_ajax_identifier,',
'    l_plugs_row.version_identifier,',
'    l_plugs_row.display_name || '': '',',
'    apex_debug.tochar( l_configuration_test = 1 )',
'    );',
' ',
'    RETURN v_result;',
'  ',
'  EXCEPTION',
'    WHEN OTHERS then',
'      htp.p( SQLERRM );',
'      return v_result;',
'  END render;',
'',
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
'       WHERE i.application_id = :APP_ID',
'         AND i.page_id IN ( :APP_PAGE_ID, 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    REGIONS AS  ',
' (     SELECT NVL( i.static_id, ''R'' || region_id ) item_name,  ',
'             b.build_option_name,',
'             ''REGION'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM apex_application_page_regions i,',
'             apex_application_build_options b',
'       WHERE i.application_id = :APP_ID',
'         AND i.page_id IN ( :APP_PAGE_ID, 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    IG_COLS AS',
'    (',
'    SELECT NVL2( i.static_id, i.static_id || ''_HDR'', ''R'' || column_id || ''_ig_grid_vc_cur'' ) item_name,  ',
'             b.build_option_name,',
'             ''IG_COL'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM APEX_APPL_PAGE_IG_COLUMNS i,',
'             apex_application_build_options b',
'       WHERE i.application_id = :APP_ID',
'         AND i.page_id IN ( :APP_PAGE_ID, 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    IR_COLS AS',
' (     SELECT NVL( i.static_id, ''C'' || column_id ) item_name,  ',
'             b.build_option_name,',
'             ''IR_COL'' page_item_type,',
'             regexp_replace(i.BUILD_OPTION_ID, ''[0-9]'' ) || b.status_on_export status',
'        FROM apex_application_page_ir_col i,',
'             apex_application_build_options b',
'       WHERE i.application_id = :APP_ID',
'         AND i.page_id IN ( :APP_PAGE_ID, 0 )',
'         AND LTRIM(i.BUILD_OPTION_ID,''-'') = b.build_option_id ),',
'    BUTTONS AS  ',
' (     SELECT NVL( button_static_id, ''B'' || button_id )  item_name,  ',
'             b.build_option_name,',
'             ''BUTTON'' page_item_type,',
'             REPLACE( RTRIM(REPLACE(  i.build_option, ''{Not '' || b.build_option_name, ''-''), ''}'') , b.build_option_name ) || b.status_on_export status',
'        FROM apex_application_page_buttons i,',
'             apex_application_build_options b',
'       WHERE i.application_id = :APP_ID',
'         AND i.page_id IN ( :APP_PAGE_ID, 0 )',
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
'        FROM ( SELECT * FROM items ',
'               UNION ALL',
'               SELECT * FROM regions ',
'               UNION ALL',
'               SELECT * FROM buttons',
'               UNION ALL',
'               SELECT * FROM ir_cols ',
'               UNION ALL',
'               SELECT * FROM ig_cols);',
'',
'    apex_json.open_object;',
'    apex_json.write( ''items'', c);',
'    apex_json.close_object; ',
'',
'  END ajax_build_option_excluded;',
'',
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
'',
'    apex_json.open_object;',
'    apex_json.write( ''items'', c);',
'    apex_json.close_object; ',
'  END ajax_debug_detail;',
'',
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
'        and application_id = :APP_ID',
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
'',
'    apex_json.open_object;',
'    apex_json.write( ''items'', c);',
'    apex_json.close_object; ',
'  END ajax_debug_view;',
'',
'  PROCEDURE ajax_revealer',
'  IS',
'    c sys_refcursor;',
'    l_subs_clob           CLOB DEFAULT NULL;',
'    l_host_address        VARCHAR2(512) DEFAULT NULL;',
'    l_host_name           VARCHAR2(512) DEFAULT NULL;',
'',
'    PROCEDURE p_write( p_name VARCHAR2, p_value VARCHAR2 )',
'    IS',
'    BEGIN',
'        apex_json.open_object;',
'        apex_json.write(''Name'', p_name );',
'        apex_json.write(''Value'', p_value );',
'        apex_json.close_object;',
'    END p_write;',
'',
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
'',
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
'',
'',
'  BEGIN',
'',
'    l_host_address        := f_get_host_address;',
'    l_host_name           := f_get_host_name;',
'',
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
'',
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
'               AND application_id = :APP_ID',
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
'                AND pi.application_id = :APP_ID',
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
'        WHERE application_id = :APP_ID',
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
'        WHERE application_id = :APP_ID',
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
'',
'',
'',
'        apex_json.open_object;',
'        apex_json.write( ''items'', c);',
'        apex_json.close_object; ',
'  END ajax_revealer;',
'',
'',
'  FUNCTION ajax( p_dynamic_action in apex_plugin.t_dynamic_action,',
'                 p_plugin         in apex_plugin.t_plugin) ',
'  RETURN apex_plugin.t_dynamic_action_ajax_result',
'  IS',
'',
'    l_result              apex_plugin.t_dynamic_action_ajax_result;',
'    l_ajax_type           apex_application.g_x01%TYPE DEFAULT apex_application.g_x01;',
'    l_debug               VARCHAR2(32) DEFAULT :DEBUG;',
'',
'  BEGIN',
'',
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
'    END IF;',
'',
'    RETURN l_result;',
'  END ajax;'))
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
'</ul>'))
,p_version_identifier=>'21.2.5'
,p_about_url=>'https://github.com/Pretius/pretius-developer-tool/'
,p_files_version=>137
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E70726574697573446576656C6F706572546F6F6C476C6F77207B0D0A2020202070616464696E672D6C6566743A203570782021696D706F7274616E743B0D0A2020202066696C7465723A2064726F702D736861646F772830203020367078206F72616E';
wwv_flow_api.g_varchar2_table(2) := '6765293B0D0A7D0D0A0D0A2E70726574697573446576656C6F706572546F6F6C526567696F6E50616464696E67207B0D0A202020206D617267696E2D746F703A20302E3038656D3B0D0A202020206D617267696E2D6C6566743A20302E3034656D3B0D0A';
wwv_flow_api.g_varchar2_table(3) := '7D0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135221869047973934)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'contentBuildOptionHighlight.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7064742E636F6E74656E744275696C644F7074696F6E486967686C69676874203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A2020202076617220666164654F75744475726174696F6E3B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(2) := '20202066756E6374696F6E2066616465496E466164654F7574286974656D4E616D652C20705374617475732C207053756666697829207B0D0A0D0A202020202020202076617220636F6C6F7572436F6465203D203139343B0D0A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(3) := '6966202870537461747573203D3D20274578636C7564652729207B0D0A202020202020202020202020636F6C6F7572436F6465203D20303B0D0A20202020202020207D0D0A0D0A20202020202020202428272327202B206974656D4E616D65202B207053';
wwv_flow_api.g_varchar2_table(4) := '7566666978292E616464436C617373282770726574697573446576656C6F706572546F6F6C526567696F6E50616464696E6727293B0D0A20202020202020207661722064203D20303B0D0A2020202020202020666F7220287661722069203D203130303B';
wwv_flow_api.g_varchar2_table(5) := '2069203E3D2035303B2069203D2069202D20302E3129207B202F2F6920726570726573656E747320746865206C696768746E6573730D0A20202020202020202020202064202B3D20333B0D0A2020202020202020202020202866756E6374696F6E202869';
wwv_flow_api.g_varchar2_table(6) := '692C20646429207B0D0A2020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0D0A20202020202020202020202020202020202020202428272327202B206974656D4E616D65202B2070537566666978292E';
wwv_flow_api.g_varchar2_table(7) := '637373282766696C746572272C202764726F702D736861646F77282031707820317078203670782068736C2827202B20636F6C6F7572436F6465202B20272C313030252C27202B206969202B2027252927293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(8) := '207D2C206464293B0D0A2020202020202020202020207D2928692C2064293B0D0A20202020202020207D0D0A0D0A20202020202020207661722064203D20666164654F75744475726174696F6E3B20200D0A0D0A20202020202020206966202864203E20';
wwv_flow_api.g_varchar2_table(9) := '3029207B0D0A202020202020202020202020666F7220287661722069203D2035303B2069203C3D203130303B2069203D2069202B20302E3129207B202F2F6920726570726573656E747320746865206C696768746E6573730D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(10) := '20202020202064202B3D20333B0D0A202020202020202020202020202020202866756E6374696F6E202869692C20646429207B0D0A202020202020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0D0A20';
wwv_flow_api.g_varchar2_table(11) := '20202020202020202020202020202020202020202020202428272327202B206974656D4E616D65202B2070537566666978292E637373282766696C746572272C202764726F702D736861646F77282031707820317078203670782068736C2827202B2063';
wwv_flow_api.g_varchar2_table(12) := '6F6C6F7572436F6465202B20272C313030252C27202B206969202B2027252927293B0D0A202020202020202020202020202020202020202020202020696620286969203E3D20393929207B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(13) := '20202020202428272327202B206974656D4E616D65202B2070537566666978292E72656D6F7665436C617373282770726574697573446576656C6F706572546F6F6C526567696F6E50616464696E6727293B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(14) := '20202020202020207D0D0A20202020202020202020202020202020202020207D2C206464293B0D0A202020202020202020202020202020207D2928692C2064293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A';
wwv_flow_api.g_varchar2_table(15) := '0D0A2020202066756E6374696F6E2061637469766174652829207B0D0A0D0A2020202020202020666164654F75744475726174696F6E203D207064742E67657453657474696E6728276275696C646F7074696F6E68696768746C696768742E6475726174';
wwv_flow_api.g_varchar2_table(16) := '696F6E27293B0D0A202020202020202069662028202169734E614E28666164654F75744475726174696F6E2920297B0D0A2020202020202020202020202F2F206E756D6265720D0A202020202020202020202020666164654F75744475726174696F6E20';
wwv_flow_api.g_varchar2_table(17) := '3D204E756D6265722820666164654F75744475726174696F6E2029202A20313030303B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020202F2F204E6F742061206E756D6265720D0A20202020202020202020202066616465';
wwv_flow_api.g_varchar2_table(18) := '4F75744475726174696F6E203D20363030303B202F2F2044656661756C740D0A20202020202020207D3B0D0A0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E';
wwv_flow_api.g_varchar2_table(19) := '706C7567696E287064742E6F70742E616A61784964656E7469666965722C207B0D0A2020202020202020202020207830313A20274255494C445F4F5054494F4E5F4558434C55444544270D0A20202020202020207D2C207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(20) := '2020737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020202020202020202020686967686C69676874286461';
wwv_flow_api.g_varchar2_table(21) := '74612E6974656D73293B0D0A2020202020202020202020207D2C0D0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(22) := '20202020202020202F2F2068616E646C65206572726F720D0A202020202020202020202020202020207064742E616A61784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A20202020';
wwv_flow_api.g_varchar2_table(23) := '20202020202020207D0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E20686967686C69676874287053656C6563746F727329207B0D0A2020202020202020666F7220287661722069203D20303B2069203C';
wwv_flow_api.g_varchar2_table(24) := '207053656C6563746F72732E6C656E6774683B20692B2B29207B0D0A202020202020202020202020766172206974656D4E616D65203D207053656C6563746F72735B695D2E4954454D5F4E414D453B0D0A20202020202020202020202076617220697465';
wwv_flow_api.g_varchar2_table(25) := '6D537461747573203D207053656C6563746F72735B695D2E5354415455533B0D0A202020202020202020202020766172206974656D54797065203D207053656C6563746F72735B695D2E504147455F4954454D5F545950453B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '20202076617220737566666978203D2027273B0D0A0D0A202020202020202020202020696620286974656D54797065203D3D20274954454D2729207B0D0A20202020202020202020202020202020737566666978203D20275F434F4E5441494E4552273B';
wwv_flow_api.g_varchar2_table(27) := '0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202066616465496E466164654F7574286974656D4E616D652C206974656D5374617475732C20737566666978293B0D0A0D0A20202020202020207D0D0A202020207D0D0A0D0A20';
wwv_flow_api.g_varchar2_table(28) := '20202072657475726E207B0D0A202020202020202061637469766174653A2061637469766174650D0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135222119772973936)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'contentBuildOptionHighlight.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E7452656C6F61644672616D65203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A2020202066756E6374696F6E2061637469766174652829207B0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(2) := '202020202020766172204A534F4E73657474696E6773203D207064742E4A534F4E73657474696E67733B0D0A20202020202020207661722076446576656C6F706572734F6E6C79203D202759273B202F2F4A534F4E73657474696E67732E73657474696E';
wwv_flow_api.g_varchar2_table(3) := '67732E72656C6F61646672616D652E646576656C6F706572736F6E6C793B0D0A202020202020202076617220764279706173735761726E4F6E556E73617665644368616E676573203D207064742E67657453657474696E6728202772656C6F6164667261';
wwv_flow_api.g_varchar2_table(4) := '6D652E6279706173737761726E6F6E756E73617665642720293B0D0A202020202020202076617220764B6579626F61726453686F7274637574203D207064742E67657453657474696E6728202772656C6F61646672616D652E6B622720293B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(5) := '202020202020202428646F63756D656E74292E6F6E28226469616C6F676F70656E222C2066756E6374696F6E20286576656E7429207B0D0A2020202020202020202020202F2F20446F6E7420616374697661746520666F7220696672616D657320746861';
wwv_flow_api.g_varchar2_table(6) := '7420617265276E74206D6F64616C206469616C676F730D0A20202020202020202020202069662028212824286576656E742E746172676574292E706172656E7428292E686173436C617373282775692D6469616C6F672D2D6170657827292929207B0D0A';
wwv_flow_api.g_varchar2_table(7) := '2020202020202020202020202020202072657475726E3B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F20446F6E7420616374697661746520666F72206E6F6E2D646576656C6F706572730D0A202020202020202020';
wwv_flow_api.g_varchar2_table(8) := '2020206966202821282876446576656C6F706572734F6E6C79203D3D20275927202626202428272361706578446576546F6F6C62617227292E6C656E67746820213D203029207C7C2076446576656C6F706572734F6E6C79203D3D20274E272929207B0D';
wwv_flow_api.g_varchar2_table(9) := '0A2020202020202020202020202020202072657475726E3B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F2020416464207265667265736820627574746F6E0D0A20202020202020202020202076617220764576656E';
wwv_flow_api.g_varchar2_table(10) := '74546172676574203D2024286576656E742E746172676574292C0D0A202020202020202020202020202020207242746E5469746C65203D202752656C6F6164204672616D65272C0D0A202020202020202020202020202020207242746E203D0D0A202020';
wwv_flow_api.g_varchar2_table(11) := '2020202020202020202020202020202020273C627574746F6E20747970653D22627574746F6E22207469746C653D2225302220617269612D6C6162656C3D2252656C6F6164204672616D65222027202B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(12) := '202027202020207374796C653D226D617267696E2D72696768743A253170783B222027202B0D0A20202020202020202020202020202020202020202720202020636C6173733D227072657469757352656C6F61644672616D6520742D427574746F6E2074';
wwv_flow_api.g_varchar2_table(13) := '2D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D2274727565222027202B0D0A202020202020202020202020202020202020202027';
wwv_flow_api.g_varchar2_table(14) := '2020202020202020636C6173733D227072657469757352656C6F61644672616D6549636F6E20742D49636F6E2066612066612D72656672657368223E3C2F7370616E3E3C2F627574746F6E3E272C0D0A2020202020202020202020202020202076506172';
wwv_flow_api.g_varchar2_table(15) := '656E74203D202428764576656E74546172676574292E706172656E7428292C0D0A20202020202020202020202020202020765469746C65203D20242876506172656E74292E66696E6428272E75692D6469616C6F672D7469746C6527292C0D0A20202020';
wwv_flow_api.g_varchar2_table(16) := '202020202020202020202020764469616C6F67436C6F736542746E203D20242876506172656E74292E66696E6428272E75692D6469616C6F672D7469746C656261722D636C6F736527292C0D0A20202020202020202020202020202020764D617267696E';
wwv_flow_api.g_varchar2_table(17) := '203D20302C0D0A20202020202020202020202020202020764469616C6F67203D202428764576656E74546172676574292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C0D0A202020202020202020202020202020207669';
wwv_flow_api.g_varchar2_table(18) := '4672616D65203D202428764469616C6F67292E66696E642827696672616D6527293B0D0A0D0A2020202020202020202020202F2F20696620636C6F736520627574746F6E20616C7265616479206861732061206D617267696E207468656E20706164206F';
wwv_flow_api.g_varchar2_table(19) := '75740D0A202020202020202020202020696620282428764469616C6F67436C6F736542746E292E6C656E677468203E2030202626202428764469616C6F67436C6F736542746E292E63737328276D617267696E2D6C65667427292E7265706C6163652827';
wwv_flow_api.g_varchar2_table(20) := '7078272C20272729203D3D2027302729207B0D0A20202020202020202020202020202020764D617267696E203D2033303B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028764B6579626F61726453686F72746375';
wwv_flow_api.g_varchar2_table(21) := '7420213D206E756C6C29207B0D0A202020202020202020202020202020202F2F20466F726D617420427574746F6E207469746C652F746F6F6C7469700D0A202020202020202020202020202020207242746E5469746C65203D207242746E5469746C6520';
wwv_flow_api.g_varchar2_table(22) := '2B20617065782E6C616E672E666F726D6174282720284374726C2B416C742B253029272C20764B6579626F61726453686F7274637574293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F2053657420427574746F6E';
wwv_flow_api.g_varchar2_table(23) := '207469746C652F746F6F6C74697020616E642061646420427574746F6E0D0A2020202020202020202020207242746E203D20617065782E6C616E672E666F726D6174287242746E2C207242746E5469746C652C20764D617267696E293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(24) := '202020202020202428765469746C65292E6166746572287242746E293B0D0A0D0A20202020202020207D293B0D0A20202020202020200D0A0D0A2020202020202020242827626F647927292E6F6E2827636C69636B272C2027627574746F6E2E70726574';
wwv_flow_api.g_varchar2_table(25) := '69757352656C6F61644672616D65272C2066756E6374696F6E20286576656E7429207B0D0A20202020202020202020202076617220764576656E74546172676574203D2024286576656E742E746172676574292C0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '2020764469616C6F67203D202428764576656E74546172676574292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C0D0A2020202020202020202020202020202076694672616D65203D202428764469616C6F67292E6669';
wwv_flow_api.g_varchar2_table(27) := '6E642827696672616D6527292C0D0A2020202020202020202020202020202076526F7461746554696D656F7574203D20313030303B0D0A0D0A2020202020202020202020206966202876694672616D655B305D2E636F6E74656E7457696E646F772E6170';
wwv_flow_api.g_varchar2_table(28) := '65782E706167652E69734368616E6765642829203D3D2066616C7365207C7C20764279706173735761726E4F6E556E73617665644368616E676573203D3D2027592729207B0D0A2020202020202020202020202020202076694672616D655B305D2E636F';
wwv_flow_api.g_varchar2_table(29) := '6E74656E7457696E646F772E617065782E706167652E63616E63656C5761726E4F6E556E73617665644368616E67657328293B0D0A202020202020202020202020202020202428764576656E74546172676574292E706172656E7428292E66696E642827';
wwv_flow_api.g_varchar2_table(30) := '2E7072657469757352656C6F61644672616D6549636F6E27292E616464436C617373282766612D616E696D2D7370696E27293B0D0A0D0A2020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0D0A202020';
wwv_flow_api.g_varchar2_table(31) := '20202020202020202020202020202020202428764576656E74546172676574292E706172656E7428292E66696E6428272E7072657469757352656C6F61644672616D6549636F6E27292E72656D6F7665436C617373282766612D616E696D2D7370696E27';
wwv_flow_api.g_varchar2_table(32) := '293B0D0A202020202020202020202020202020207D2C2076526F7461746554696D656F7574293B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202076694672616D655B305D2E636F6E74656E74446F63756D656E742E6C6F63';
wwv_flow_api.g_varchar2_table(33) := '6174696F6E2E72656C6F616428293B0D0A20202020202020207D293B0D0A0D0A20202020202020202F2F2042696E64206B6579626F6172642073686F7274637574730D0A20202020202020204D6F757365747261702E62696E64476C6F62616C28276374';
wwv_flow_api.g_varchar2_table(34) := '726C2B616C742B27202B20764B6579626F61726453686F72746375742E746F4C6F7765724361736528292C2066756E6374696F6E20286529207B0D0A202020202020202020202020706172656E742E242827627574746F6E2E7072657469757352656C6F';
wwv_flow_api.g_varchar2_table(35) := '61644672616D653A6C61737427292E747269676765722827636C69636B27293B0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202072657475726E207B0D0A202020202020202061637469766174653A2061637469766174650D0A';
wwv_flow_api.g_varchar2_table(36) := '202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135222595329973936)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'contentReloadFrame.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7064742E70726574697573436F6E74656E7452657665616C6572203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A202020207661722064656275674D6F64653B0D0A202020207661722072657665616C';
wwv_flow_api.g_varchar2_table(2) := '657249636F6E48746D6C3B0D0A0D0A2020202076617220617065784974656D5479706573203D205B2254455854222C0D0A202020202020202022434845434B424F585F47524F5550222C0D0A202020202020202022444953504C41595F53415645535F53';
wwv_flow_api.g_varchar2_table(3) := '54415445222C0D0A202020202020202022444953504C41595F4F4E4C59222C0D0A20202020202020202248494444454E222C0D0A20202020202020202253485554544C45222C0D0A202020202020202022524144494F5F47524F5550222C0D0A20202020';
wwv_flow_api.g_varchar2_table(4) := '202020202253454C454354222C0D0A202020202020202022504F5055505F4B45595F4C4F56222C0D0A202020202020202022504F5055505F4C4F56222C0D0A202020202020202022535749544348222C0D0A202020202020202022544558544152454122';
wwv_flow_api.g_varchar2_table(5) := '2C0D0A202020202020202022434B454449544F5233222C0D0A2020202020202020224155544F5F434F4D504C455445225D3B0D0A0D0A202020202F2F206E6F74202E617065782D6974656D2D67726F75700D0A20202020766172206974656D537472696E';
wwv_flow_api.g_varchar2_table(6) := '67203D2022696E7075743A6E6F7428275B646174612D666F725D2C2E6A732D746162547261702C2E612D47562D726F7753656C65637427292C2022202B0D0A2020202020202020222E73656C6563746C6973742C2022202B0D0A2020202020202020222E';
wwv_flow_api.g_varchar2_table(7) := '74657874617265612C2022202B0D0A2020202020202020222E6C6973746D616E616765723A6E6F74286669656C64736574292C2022202B0D0A2020202020202020222E617065782D6974656D2D726164696F2C2022202B0D0A2020202020202020222E61';
wwv_flow_api.g_varchar2_table(8) := '7065782D6974656D2D636865636B626F782C2022202B0D0A2020202020202020222E617065782D6974656D2D646973706C61792D6F6E6C792C2022202B0D0A2020202020202020222E617065782D6974656D2D67726F75702D2D73687574746C652C2022';
wwv_flow_api.g_varchar2_table(9) := '202B0D0A2020202020202020222E617065782D6974656D2D73687574746C652C2022202B0D0A2020202020202020222E617065782D6974656D2D67726F75702D2D7377697463682C2022202B0D0A2020202020202020222E617065782D6974656D2D6772';
wwv_flow_api.g_varchar2_table(10) := '6F75702D2D6175746F2D636F6D706C6574652C2022202B0D0A2020202020202020222E617065782D6974656D2D7965732D6E6F2C2022202B0D0A20202020202020202274657874617265612C2022202B0D0A2020202020202020222E73687574746C653A';
wwv_flow_api.g_varchar2_table(11) := '6E6F74287461626C65292C2022202B0D0A2020202020202020222E73687574746C655F6C6566742C2022202B0D0A2020202020202020222E73687574746C655F72696768742C2022202B0D0A2020202020202020222E636865636B626F785F67726F7570';
wwv_flow_api.g_varchar2_table(12) := '3A6E6F7428276469762C7461626C6527292C2022202B0D0A2020202020202020222E7965735F6E6F223B0D0A0D0A202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F313931323532320D0A2020202066756E637469';
wwv_flow_api.g_varchar2_table(13) := '6F6E2068746D6C4465636F646528696E70757429207B0D0A20202020202020207661722065203D20646F63756D656E742E637265617465456C656D656E742827746578746172656127293B0D0A2020202020202020652E696E6E657248544D4C203D2069';
wwv_flow_api.g_varchar2_table(14) := '6E7075743B0D0A20202020202020202F2F2068616E646C652063617365206F6620656D70747920696E7075740D0A202020202020202072657475726E20652E6368696C644E6F6465732E6C656E677468203D3D3D2030203F202222203A20652E6368696C';
wwv_flow_api.g_varchar2_table(15) := '644E6F6465735B305D2E6E6F646556616C75653B0D0A202020207D0D0A0D0A20202020766172206672616D65776F726B4172726179203D205B2770466C6F774964272C202770466C6F77537465704964272C202770496E7374616E6365272C2027705061';
wwv_flow_api.g_varchar2_table(16) := '67655375626D697373696F6E4964272C20277052657175657374272C20277052656C6F61644F6E5375626D6974272C20277053616C74272C202770506167654974656D73526F7756657273696F6E272C202770506167654974656D7350726F7465637465';
wwv_flow_api.g_varchar2_table(17) := '64272C2027706465627567272C20276170657843424D44756D6D7953656C656374696F6E272C20277050616765436865636B73756D272C2027705F6D64355F636865636B73756D272C20277050616765466F726D526567696F6E436865636B73756D7327';
wwv_flow_api.g_varchar2_table(18) := '5D3B0D0A0D0A2020202066756E6374696F6E20696E6A65637453637269707428796F7572437573746F6D4A617661536372697074436F64652C207065727369737429207B0D0A202020202020202076617220736372697074203D20646F63756D656E742E';
wwv_flow_api.g_varchar2_table(19) := '637265617465456C656D656E74282773637269707427293B0D0A20202020202020207363726970742E6964203D2027746D70536372697074273B0D0A202020202020202076617220636F6465203D20646F63756D656E742E637265617465546578744E6F';
wwv_flow_api.g_varchar2_table(20) := '646528272866756E6374696F6E2829207B27202B20796F7572437573746F6D4A617661536372697074436F6465202B20277D2928293B27293B0D0A20202020202020207363726970742E617070656E644368696C6428636F6465293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(21) := '2020696620282428646F63756D656E742E626F6479207C7C20646F63756D656E742E68656164292E6C656E677468203E203029207B0D0A20202020202020202020202028646F63756D656E742E626F6479207C7C20646F63756D656E742E68656164292E';
wwv_flow_api.g_varchar2_table(22) := '617070656E644368696C6428736372697074293B0D0A20202020202020207D0D0A202020202020202024282223746D7053637269707422292E72656D6F766528293B0D0A202020207D0D0A0D0A2020202066756E6374696F6E2063726970706C65546162';
wwv_flow_api.g_varchar2_table(23) := '4C6F636B52657665616C65722829207B0D0A20202020202020202F2F2053656C65637420746865206E6F646520746861742077696C6C206265206F6273657276656420666F72206D75746174696F6E730D0A2020202020202020636F6E73742074617267';
wwv_flow_api.g_varchar2_table(24) := '65744E6F6465203D20646F63756D656E742E676574456C656D656E7442794964282761706578446576546F6F6C62617227293B0D0A0D0A20202020202020202F2F204F7074696F6E7320666F7220746865206F6273657276657220287768696368206D75';
wwv_flow_api.g_varchar2_table(25) := '746174696F6E7320746F206F627365727665290D0A2020202020202020636F6E737420636F6E666967203D207B20617474726962757465733A20747275652C206368696C644C6973743A20747275652C20737562747265653A2074727565207D3B0D0A0D';
wwv_flow_api.g_varchar2_table(26) := '0A20202020202020202F2F2043616C6C6261636B2066756E6374696F6E20746F2065786563757465207768656E206D75746174696F6E7320617265206F627365727665640D0A2020202020202020636F6E73742063616C6C6261636B546F6F6C62617220';
wwv_flow_api.g_varchar2_table(27) := '3D2066756E6374696F6E20286D75746174696F6E734C6973742C206F6273657276657229207B0D0A202020202020202020202020696620282428272361706578446576546F6F6C6261725661727327292E6C656E677468203E203029207B0D0A20202020';
wwv_flow_api.g_varchar2_table(28) := '2020202020202020202020202428272361706578446576546F6F6C6261725661727327292E636C6F7365737428276C6927292E7265706C6163655769746828293B0D0A202020202020202020202020202020206F62736572766572546F6F6C6261722E64';
wwv_flow_api.g_varchar2_table(29) := '6973636F6E6E65637428293B0D0A2020202020202020202020207D0D0A20202020202020207D3B0D0A0D0A2020202020202020636F6E73742063616C6C6261636B496672616D65203D2066756E6374696F6E20286D75746174696F6E734C6973742C206F';
wwv_flow_api.g_varchar2_table(30) := '6273657276657229207B0D0A20202020202020202020202069662028242827626F647920696672616D655B69643D227461626C6F636B52657665616C65724672616D65225D27292E6C656E677468203E203029207B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(31) := '202020242827626F647920696672616D655B69643D227461626C6F636B52657665616C65724672616D65225D27292E7265706C6163655769746828293B0D0A202020202020202020202020202020206F62736572766572496672616D652E646973636F6E';
wwv_flow_api.g_varchar2_table(32) := '6E65637428293B0D0A2020202020202020202020207D0D0A20202020202020207D3B0D0A0D0A20202020202020202F2F2043726561746520616E206F6273657276657220696E7374616E6365206C696E6B656420746F207468652063616C6C6261636B20';
wwv_flow_api.g_varchar2_table(33) := '66756E6374696F6E0D0A2020202020202020636F6E7374206F62736572766572546F6F6C626172203D206E6577204D75746174696F6E4F627365727665722863616C6C6261636B546F6F6C626172293B0D0A2020202020202020636F6E7374206F627365';
wwv_flow_api.g_varchar2_table(34) := '72766572496672616D65203D206E6577204D75746174696F6E4F627365727665722863616C6C6261636B496672616D65293B0D0A0D0A20202020202020202F2F205374617274206F6273657276696E672074686520746172676574206E6F646520666F72';
wwv_flow_api.g_varchar2_table(35) := '20636F6E66696775726564206D75746174696F6E730D0A20202020202020206F62736572766572546F6F6C6261722E6F627365727665287461726765744E6F64652C20636F6E666967293B0D0A20202020202020206F62736572766572496672616D652E';
wwv_flow_api.g_varchar2_table(36) := '6F62736572766528242827626F647927295B305D2C20636F6E666967293B0D0A202020207D0D0A0D0A0D0A0D0A2020202066756E6374696F6E20636C6F67287029207B0D0A2020202020202020696620287064742E70726574697573436F6E74656E7452';
wwv_flow_api.g_varchar2_table(37) := '657665616C65722E64656275674D6F646529207B0D0A202020202020202020202020636F6E736F6C652E6C6F672870293B0D0A20202020202020207D0D0A202020207D0D0A2020202066756E6374696F6E2073656E644D6F64616C4D6573736167652829';
wwv_flow_api.g_varchar2_table(38) := '207B0D0A2020202020202020766172206A203D205B5D3B0D0A202020202020202076617220646973636F76657265645061676573203D20273A273B0D0A0D0A202020202020202066756E6374696F6E206164644974656D546F4A736F6E287053656C6563';
wwv_flow_api.g_varchar2_table(39) := '746F722C2070496672616D6553656C6563746F72203D20272729207B0D0A2020202020202020202020207661722061203D207B7D3B0D0A2020202020202020202020207661722069203D20303B0D0A0D0A2020202020202020202020202F2F2047657420';
wwv_flow_api.g_varchar2_table(40) := '50616765206E756D6265720D0A20202020202020202020202076617220796F7572437573746F6D4A617661536372697074436F6465203D2022242827626F647927292E617474722827746D705F78272C2022202B2070496672616D6553656C6563746F72';
wwv_flow_api.g_varchar2_table(41) := '202B2022617065782E6974656D282770466C6F7753746570496427292E67657456616C75652829293B223B0D0A202020202020202020202020696E6A65637453637269707428796F7572437573746F6D4A617661536372697074436F6465293B0D0A2020';
wwv_flow_api.g_varchar2_table(42) := '20202020202020202020766172207870466C6F77537465704964203D20242822626F647922292E617474722822746D705F7822293B0D0A202020202020202020202020242822626F647922292E72656D6F7665417474722822746D705F7822293B0D0A0D';
wwv_flow_api.g_varchar2_table(43) := '0A202020202020202020202020636C6F67287053656C6563746F72293B0D0A0D0A2020202020202020202020207661722074727565506167654964203D207870466C6F775374657049642E73706C697428225F22295B305D3B0D0A0D0A20202020202020';
wwv_flow_api.g_varchar2_table(44) := '2020202020612E50616765203D207870466C6F775374657049643B0D0A202020202020202020202020612E4E616D65203D207053656C6563746F722E69643B0D0A0D0A20202020202020202020202076617220796F7572437573746F6D4A617661536372';
wwv_flow_api.g_varchar2_table(45) := '697074436F6465203D2068746D6C4465636F646528617065782E6C616E672E666F726D6174280D0A20202020202020202020202020202020227661722072657665616C65724974656D203D202530617065782E6974656D2827253127293B2022202B0D0A';
wwv_flow_api.g_varchar2_table(46) := '20202020202020202020202020202020227661722072657665616C657256616C75654974656D203D2072657665616C65724974656D2E67657456616C756528293B2022202B0D0A20202020202020202020202020202020227661722072657665616C6572';
wwv_flow_api.g_varchar2_table(47) := '54797065203D2072657665616C65724974656D2E6974656D5F747970653B2022202B0D0A20202020202020202020202020202020227661722072657665616C657256616C75654974656D537472696E673B2022202B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '20202022696620282072657665616C657256616C75654974656D20696E7374616E63656F66204172726179292022202B0D0A20202020202020202020202020202020227B2022202B0D0A2020202020202020202020202020202022202020207265766561';
wwv_flow_api.g_varchar2_table(49) := '6C657256616C75654974656D537472696E67203D2072657665616C657256616C75654974656D2E6A6F696E28273A27293B2022202B0D0A20202020202020202020202020202020227D2022202B0D0A2020202020202020202020202020202022656C7365';
wwv_flow_api.g_varchar2_table(50) := '2022202B0D0A20202020202020202020202020202020227B2022202B0D0A20202020202020202020202020202020222020202072657665616C657256616C75654974656D537472696E67203D2072657665616C657256616C75654974656D3B2022202B0D';
wwv_flow_api.g_varchar2_table(51) := '0A20202020202020202020202020202020227D2022202B0D0A2020202020202020202020202020202022242827626F647927292E617474722827746D705F7461624C6F636B4361736556616C7565272C2072657665616C657256616C75654974656D5374';
wwv_flow_api.g_varchar2_table(52) := '72696E67293B2022202B0D0A2020202020202020202020202020202022242827626F647927292E617474722827746D705F7461624C6F636B4361736554797065272C202072657665616C657254797065293B20222C0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '20202070496672616D6553656C6563746F722C0D0A20202020202020202020202020202020612E4E616D6529293B0D0A0D0A202020202020202020202020696E6A65637453637269707428796F7572437573746F6D4A617661536372697074436F646529';
wwv_flow_api.g_varchar2_table(54) := '3B0D0A202020202020202020202020612E54797065203D20242822626F647922292E617474722822746D705F7461624C6F636B436173655479706522293B0D0A202020202020202020202020612E56616C7565203D20242822626F647922292E61747472';
wwv_flow_api.g_varchar2_table(55) := '2822746D705F7461624C6F636B4361736556616C756522293B0D0A202020202020202020202020242822626F647922292E72656D6F7665417474722822746D705F7461624C6F636B4361736556616C756522293B0D0A2020202020202020202020202428';
wwv_flow_api.g_varchar2_table(56) := '22626F647922292E72656D6F7665417474722822746D705F7461624C6F636B436173655479706522293B0D0A0D0A2020202020202020202020202F2F204966206E6F2041504558206974656D2C2074727920766961206E6F64650D0A2020202020202020';
wwv_flow_api.g_varchar2_table(57) := '2020202069662028612E56616C7565203D3D20272729207B0D0A20202020202020202020202020202020612E56616C7565203D207053656C6563746F722E76616C75653B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069';
wwv_flow_api.g_varchar2_table(58) := '662028612E5479706529207B0D0A20202020202020202020202020202020612E54797065203D20612E547970652E746F55707065724361736528293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F204966206E6F20';
wwv_flow_api.g_varchar2_table(59) := '6E616D652C2074727920746F206772616220616E20616C7465726E61746976650D0A2020202020202020202020202F2F436F6C6F72207069636B6572206669780D0A20202020202020202020202069662028612E4E616D65203D3D20272729207B0D0A20';
wwv_flow_api.g_varchar2_table(60) := '20202020202020202020202020202076617220646976436C6173734E616D6573203D2024287053656C6563746F72292E636C6F73657374282764697627292E617474722827636C61737327293B0D0A202020202020202020202020202020206966202864';
wwv_flow_api.g_varchar2_table(61) := '6976436C6173734E616D657320262620646976436C6173734E616D65732E737461727473576974682827636F6C6F727069636B6572272929207B0D0A20202020202020202020202020202020202020207661722063704944203D2024287053656C656374';
wwv_flow_api.g_varchar2_table(62) := '6F72292E636C6F7365737428272E636F6C6F727069636B657227292E617474722827696427293B0D0A0D0A2020202020202020202020202020202020202020612E4E616D65203D2063704944202B2027203E2027202B20646976436C6173734E616D6573';
wwv_flow_api.g_varchar2_table(63) := '2E73706C697428272027295B305D2E7265706C6163652827636F6C6F727069636B65725F272C202727293B0D0A2020202020202020202020202020202020202020612E54797065203D2027494E50555420286173736F632E207769746820434F4C4F525F';
wwv_flow_api.g_varchar2_table(64) := '5049434B455229273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020206966202824287053656C6563746F72292E686173436C61737328276F6A2D636F6D706F6E656E742D69';
wwv_flow_api.g_varchar2_table(65) := '6E69746E6F6465272929207B0D0A20202020202020202020202020202020612E54797065202B3D202720286173736F632E2077697468204155544F5F434F4D504C45544529273B0D0A2020202020202020202020207D0D0A0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(66) := '202069662028612E54797065203D3D202746414C53452729207B0D0A202020202020202020202020202020202F2F5365636F6E64206368616E63650D0A0D0A202020202020202020202020202020202F2F20666F722073776974636865730D0A20202020';
wwv_flow_api.g_varchar2_table(67) := '2020202020202020202020206966202824287053656C6563746F72292E686173436C6173732827617065782D6974656D2D67726F75702D2D7377697463682729207C7C0D0A202020202020202020202020202020202020202024287053656C6563746F72';
wwv_flow_api.g_varchar2_table(68) := '292E686173436C6173732827617065782D6974656D2D7965732D6E6F272929207B20612E54797065203D2027535749544348273B207D0D0A202020202020202020202020202020202F2F2054657874204669656C642077697468206175746F20636F6D70';
wwv_flow_api.g_varchar2_table(69) := '6C6574650D0A202020202020202020202020202020206966202824287053656C6563746F72292E686173436C6173732827617065782D6974656D2D67726F75702D2D6175746F2D636F6D706C657465272929207B20612E54797065203D20274155544F5F';
wwv_flow_api.g_varchar2_table(70) := '434F4D504C455445273B207D0D0A0D0A202020202020202020202020202020206966202824287053656C6563746F72292E686173436C6173732827612D427574746F6E2D2D6C6973744D616E61676572272929207B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(71) := '20202020202020612E4E616D65203D20273E2027202B20612E56616C75653B0D0A2020202020202020202020202020202020202020612E54797065203D2027286173736F632E2077697468204C4953545F4D414E4147455229273B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(72) := '2020202020202020207D0D0A202020202020202020202020202020202F2F20546578742061726561206669656C647365740D0A202020202020202020202020202020206966202824287053656C6563746F72292E697328276669656C6473657427292026';
wwv_flow_api.g_varchar2_table(73) := '262024287053656C6563746F72292E6368696C6472656E28272E617065782D6974656D2D74657874617265613A666972737427292E6C656E677468203E203029207B0D0A2020202020202020202020202020202020202020612E54797065203D20272861';
wwv_flow_api.g_varchar2_table(74) := '73736F632E207769746820544558544152454129273B0D0A202020202020202020202020202020207D0D0A202020202020202020202020202020202F2A204150455820352E3020616E6420756E6E616D6564202A2F0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(75) := '20202069662028612E4E616D65203D3D20272729207B0D0A2020202020202020202020202020202020202020612E4E616D65203D2024287053656C6563746F72292E6174747228276E616D6527293B202F2F205265706C616365206E616D652077697468';
wwv_flow_api.g_varchar2_table(76) := '206E616D65206174747269627574650D0A2020202020202020202020202020202020202020766172206F72696754797065203D2024287053656C6563746F72292E6174747228277479706527293B202F2F205265706C6163652046414C53452074797065';
wwv_flow_api.g_varchar2_table(77) := '20776974682074797065206174747269627574650D0A2020202020202020202020202020202020202020696620286F7269675479706529207B0D0A202020202020202020202020202020202020202020202020612E54797065203D206F72696754797065';
wwv_flow_api.g_varchar2_table(78) := '2E746F55707065724361736528293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065';
wwv_flow_api.g_varchar2_table(79) := '203D3D202748494444454E27202626206672616D65776F726B41727261792E696E6465784F6628612E4E616D6529203D3D202D3129207B0D0A202020202020202020202020202020206966202824287053656C6563746F72292E6E65787428292E66696E';
wwv_flow_api.g_varchar2_table(80) := '6428272E617065782D6974656D2D706F7075702D6C6F762C202E706F7075705F6C6F7627292E6C656E677468203E203029207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E207769746820504F';
wwv_flow_api.g_varchar2_table(81) := '5055505F4C4F5629273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028612E54797065203D3D202753454C4543542729207B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(82) := '2020206966202824287053656C6563746F72292E686173436C617373282773687574746C655F6C6566742729207C7C2024287053656C6563746F72292E686173436C617373282773687574746C655F7269676874272929207B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(83) := '2020202020202020202020612E54797065202B3D202720286173736F632E20776974682053485554544C4529273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A20202020202020202020202069662028';
wwv_flow_api.g_varchar2_table(84) := '612E54797065203D3D2027504F5055505F4C4F562729207B0D0A202020202020202020202020202020206966202824287053656C6563746F72292E636C6F7365737428276669656C6473657427292E706172656E7428292E636C6F736573742827666965';
wwv_flow_api.g_varchar2_table(85) := '6C6473657427292E686173436C6173732827617065782D6974656D2D6C6973742D6D616E61676572272929207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E20776974682053454C4543542F4C';
wwv_flow_api.g_varchar2_table(86) := '4953545F4D414E4147455229273B0D0A202020202020202020202020202020207D0D0A202020202020202020202020202020206966202824287053656C6563746F72292E6174747228277469746C652729203D3D202741646420456E747279272026260D';
wwv_flow_api.g_varchar2_table(87) := '0A202020202020202020202020202020202020202024287053656C6563746F72292E69732827696E70757427292026260D0A202020202020202020202020202020202020202024287053656C6563746F72292E697328275B6964243D22414444225D2729';
wwv_flow_api.g_varchar2_table(88) := '29207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E2077697468204C4953545F4D414E4147455229273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D';
wwv_flow_api.g_varchar2_table(89) := '0A0D0A20202020202020202020202069662028612E54797065203D3D2027444953504C41595F4F4E4C592729207B0D0A2020202020202020202020202020202076617220646F5F6964203D2024287053656C6563746F72292E7369626C696E6773282769';
wwv_flow_api.g_varchar2_table(90) := '6E7075745B747970653D2268696464656E225D3A666972737427292E617474722822696422293B0D0A2020202020202020202020202020202069662028646F5F6964202626202428272327202B20646F5F69642E7265706C61636528275F444953504C41';
wwv_flow_api.g_varchar2_table(91) := '59272C202727292929207B0D0A2020202020202020202020202020202020202020612E54797065202B3D202720286173736F632E207769746820444953504C41595F4F4E4C5929273B0D0A202020202020202020202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(92) := '2020202020207D0D0A0D0A2020202020202020202020207661722074797065496E41727279506F73203D20242E696E417272617928612E547970652C20617065784974656D5479706573293B0D0A0D0A202020202020202020202020696620287053656C';
wwv_flow_api.g_varchar2_table(93) := '6563746F722E636C6F7365737428225B636C6173735E3D27612D495252275D222929207B0D0A20202020202020202020202020202020612E43617465676F7279203D20274952273B0D0A2020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(94) := '20656C736520696620287053656C6563746F722E636C6F7365737428225B636C6173735E3D27612D4947275D222929207B0D0A20202020202020202020202020202020612E43617465676F7279203D20274947273B0D0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(95) := '0D0A202020202020202020202020656C736520696620286672616D65776F726B41727261792E696E6465784F6628612E4E616D6529203E3D203029207B0D0A20202020202020202020202020202020612E43617465676F7279203D20274657273B0D0A20';
wwv_flow_api.g_varchar2_table(96) := '20202020202020202020207D0D0A202020202020202020202020656C7365207B0D0A202020202020202020202020202020202F2F2050616765206974656D730D0A2020202020202020202020202020202069662028612E4E616D6520262620612E4E616D';
wwv_flow_api.g_varchar2_table(97) := '652E7374617274735769746828225022202B2074727565506167654964292026262074797065496E41727279506F73203E202D3129207B0D0A2020202020202020202020202020202020202020612E43617465676F7279203D202750492C5058273B0D0A';
wwv_flow_api.g_varchar2_table(98) := '202020202020202020202020202020207D0D0A20202020202020202020202020202020656C73652069662028612E4E616D6520262620612E4E616D652E737461727473576974682822503022292026262074797065496E41727279506F73203E202D3129';
wwv_flow_api.g_varchar2_table(99) := '207B0D0A2020202020202020202020202020202020202020612E43617465676F7279203D202750492C5030273B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020202020656C7365207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(100) := '20202020202020202020612E43617465676F7279203D202750492C504F273B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020206A2E707573682861293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(101) := '207D0D0A0D0A202020202020202076617220796F7572437573746F6D4A617661536372697074436F6465203D2022242827626F647927292E617474722827746D705F78272C20617065782E6974656D282770466C6F7753746570496427292E6765745661';
wwv_flow_api.g_varchar2_table(102) := '6C75652829293B223B0D0A2020202020202020696E6A65637453637269707428796F7572437573746F6D4A617661536372697074436F6465293B0D0A2020202020202020766172207870466C6F77537465704964203D20242822626F647922292E617474';
wwv_flow_api.g_varchar2_table(103) := '722822746D705F7822293B0D0A2020202020202020242822626F647922292E72656D6F7665417474722822746D705F7822293B0D0A0D0A2020202020202020646973636F76657265645061676573203D20646973636F76657265645061676573202B2078';
wwv_flow_api.g_varchar2_table(104) := '70466C6F77537465704964202B20273A273B0D0A0D0A2020202020202020766172206974656D53656C6563746F72203D2024286974656D537472696E67293B0D0A0D0A202020202020202024286974656D53656C6563746F72292E656163682866756E63';
wwv_flow_api.g_varchar2_table(105) := '74696F6E202829207B0D0A20202020202020202020202069662028242874686973292E636C6F736573742827237072657469757352657665616C6572496E6C696E6527292E6C656E677468203D3D203020262620242874686973295B305D2E6861734174';
wwv_flow_api.g_varchar2_table(106) := '7472696275746528226964222929207B0D0A202020202020202020202020202020206164644974656D546F4A736F6E2874686973293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A2020202020202020766172206966';
wwv_flow_api.g_varchar2_table(107) := '72616D65437472203D20303B0D0A202020202020202076617220696672616D6553656C6563746F72537472696E67203D2022696672616D653A6E6F74285B69643D7461626C6F636B52657665616C65724672616D655D29223B0D0A202020202020202024';
wwv_flow_api.g_varchar2_table(108) := '28696672616D6553656C6563746F72537472696E67292E66696C7465722866756E6374696F6E202829207B2072657475726E20242874686973292E706172656E747328272E75692D6469616C6F672D2D6170657827292E6C656E677468203E20303B207D';
wwv_flow_api.g_varchar2_table(109) := '292E656163682866756E6374696F6E202829207B0D0A20202020202020202020202076617220696E6A65637453656C6563746F72537472696E67203D0D0A2020202020202020202020202020202068746D6C4465636F646528617065782E6C616E672E66';
wwv_flow_api.g_varchar2_table(110) := '6F726D6174282720242822253022292E66696C7465722866756E6374696F6E2829207B72657475726E20242874686973292E706172656E747328222E75692D6469616C6F672D2D6170657822292E6C656E677468203E20303B7D295B25315D2E636F6E74';
wwv_flow_api.g_varchar2_table(111) := '656E7457696E646F772E272C0D0A2020202020202020202020202020202020202020696672616D6553656C6563746F72537472696E672C0D0A2020202020202020202020202020202020202020696672616D6543747229293B0D0A0D0A20202020202020';
wwv_flow_api.g_varchar2_table(112) := '2020202020696672616D65437472203D20696672616D65437472202B20313B0D0A20202020202020202020202076617220696672616D6553656C6563746F72203D20746869733B0D0A2020202020202020202020207870466C6F77537465704964203D20';
wwv_flow_api.g_varchar2_table(113) := '746869732E636F6E74656E7457696E646F772E70466C6F775374657049642E76616C7565202B20275F27202B20696672616D654374723B0D0A202020202020202020202020646973636F76657265645061676573203D20646973636F7665726564506167';
wwv_flow_api.g_varchar2_table(114) := '6573202B20746869732E636F6E74656E7457696E646F772E70466C6F775374657049642E76616C7565202B20273A273B0D0A202020202020202020202020242874686973292E636F6E74656E747328292E66696E64286974656D537472696E67290D0A20';
wwv_flow_api.g_varchar2_table(115) := '20202020202020202020202E66696C7465722866756E6374696F6E2820696E6465782029207B0D0A2020202020202020202020202020202072657475726E20242874686973295B305D2E6861734174747269627574652822696422293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(116) := '2020202020202020207D290D0A20202020202020202020202020202E656163682866756E6374696F6E202829207B0D0A202020202020202020202020202020206164644974656D546F4A736F6E28746869732C20696E6A65637453656C6563746F725374';
wwv_flow_api.g_varchar2_table(117) := '72696E67293B0D0A2020202020202020202020207D293B0D0A20202020202020207D293B0D0A0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E706C7567696E';
wwv_flow_api.g_varchar2_table(118) := '287064742E6F70742E616A61784964656E7469666965722C207B0D0A2020202020202020202020207830313A202752455645414C4552272C0D0A2020202020202020202020207830323A20646973636F766572656450616765732C202F2F707265746975';
wwv_flow_api.g_varchar2_table(119) := '7352657665616C65722E7061676544656C696D6574656428292C0D0A202020202020202020202020705F636C6F625F30313A204A534F4E2E737472696E67696679286A290D0A20202020202020207D2C207B0D0A20202020202020202020202073756363';
wwv_flow_api.g_varchar2_table(120) := '6573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020202020202020202020636C6F672864617461293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(121) := '2020202020202020202020737061726B557052657665616C6572287B20646174613A20646174612E6974656D73207D293B0D0A2020202020202020202020207D2C0D0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848';
wwv_flow_api.g_varchar2_table(122) := '522C20746578745374617475732C206572726F725468726F776E29207B0D0A202020202020202020202020202020202F2F2068616E646C65206572726F720D0A202020202020202020202020202020207064742E616A61784572726F7248616E646C6572';
wwv_flow_api.g_varchar2_table(123) := '286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E20737061726B557052657665616C';
wwv_flow_api.g_varchar2_table(124) := '6572286529207B0D0A0D0A2020202020202020766172206D79537472696E674172726179203D207072657469757352657665616C65722E64697374696E6374506167657328652E64617461293B0D0A2020202020202020766172206A7573745061676573';
wwv_flow_api.g_varchar2_table(125) := '203D2027273B0D0A20202020202020207661722061727261794C656E677468203D206D79537472696E6741727261792E6C656E6774683B0D0A2020202020202020666F7220287661722069203D20303B2069203C2061727261794C656E6774683B20692B';
wwv_flow_api.g_varchar2_table(126) := '2B29207B0D0A202020202020202020202020696620286D79537472696E6741727261795B695D20213D20272A2729207B0D0A20202020202020202020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573';
wwv_flow_api.g_varchar2_table(127) := '50616765436F6E74726F6C7327292E617070656E6428273C696E70757420747970653D22726164696F22206E616D653D2270466C6F77537465704964222076616C75653D2227202B206D79537472696E6741727261795B695D202B2027222069643D2270';
wwv_flow_api.g_varchar2_table(128) := '61676546696C74657227202B206D79537472696E6741727261795B695D202B202722202F3E27293B0D0A20202020202020202020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74';
wwv_flow_api.g_varchar2_table(129) := '726F6C7327292E617070656E6428273C6C6162656C20666F723D227061676546696C74657227202B206D79537472696E6741727261795B695D202B2027223E506167652027202B206D79537472696E6741727261795B695D2E73706C697428225F22295B';
wwv_flow_api.g_varchar2_table(130) := '305D202B20273C2F6C6162656C3E27293B0D0A202020202020202020202020202020206A7573745061676573203D206A7573745061676573202B206D79537472696E6741727261795B695D202B20273A273B0D0A2020202020202020202020207D0D0A20';
wwv_flow_api.g_varchar2_table(131) := '202020202020207D0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7327292E6174747228276A7573745061676573272C20273A27202B206A757374506167';
wwv_flow_api.g_varchar2_table(132) := '6573293B0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7327292E617070656E6428273C696E70757420747970653D22726164696F22206E616D653D2270';
wwv_flow_api.g_varchar2_table(133) := '466C6F77537465704964222069643D227061676546696C746572416C6C222076616C75653D22416C6C22202F3E27293B200D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237072657469757350616765436F6E';
wwv_flow_api.g_varchar2_table(134) := '74726F6C7327292E617070656E6428273C6C6162656C20666F723D227061676546696C746572416C6C223E416C6C3C2F6C6162656C3E27293B0D0A0D0A20202020202020202F2F2041646420526573756C74730D0A202020202020202024282723707265';
wwv_flow_api.g_varchar2_table(135) := '7469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E656D70747928293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E61';
wwv_flow_api.g_varchar2_table(136) := '7070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528652E6461746129293B0D0A0D0A20202020202020202F2F2041646420616E7920637573746F6D69736174696F6E730D0A202020202020202070726574697573';
wwv_flow_api.g_varchar2_table(137) := '52657665616C65722E637573746F6D6973655461626C6528293B0D0A0D0A20202020202020202F2F204164642042696E64730D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202372536561726368426F7827292E';
wwv_flow_api.g_varchar2_table(138) := '6B657975702866756E6374696F6E20286529207B207072657469757352657665616C65722E706572666F726D46696C74657228293B207D293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E652023725365617263';
wwv_flow_api.g_varchar2_table(139) := '68426F7827292E6F6E2827736561726368272C2066756E6374696F6E202829207B207072657469757352657665616C65722E706572666F726D46696C74657228293B207D293B0D0A2020202020202020242827237072657469757352657665616C657249';
wwv_flow_api.g_varchar2_table(140) := '6E6C696E65202372436C656172536561726368426F7827292E6F6E2827636C69636B272C2066756E6374696F6E202829207B0D0A202020202020202020202020617065782E6974656D282772536561726368426F7827292E73657456616C756528293B0D';
wwv_flow_api.g_varchar2_table(141) := '0A2020202020202020202020207072657469757352657665616C65722E706572666F726D46696C74657228293B0D0A20202020202020207D293B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6520696E7075';
wwv_flow_api.g_varchar2_table(142) := '745B747970653D726164696F5D22292E636C69636B2866756E6374696F6E202829207B0D0A20202020202020202020202069662028242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D';
wwv_flow_api.g_varchar2_table(143) := '653D7043617465676F72795D3A636865636B656422292E76616C2829203D3D20224465627567506167652229207B0D0A202020202020202020202020202020207072657469757352657665616C65722E676574446562756756696577436F6E74656E7428';
wwv_flow_api.g_varchar2_table(144) := '293B0D0A2020202020202020202020207D20656C7365207B0D0A202020202020202020202020202020207072657469757352657665616C65722E706572666F726D46696C74657228293B0D0A2020202020202020202020207D0D0A20202020202020207D';
wwv_flow_api.g_varchar2_table(145) := '293B0D0A20202020200D0A20202020202020202F2F2044656661756C7420436C69636B730D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F77';
wwv_flow_api.g_varchar2_table(146) := '5374657049645D3A666972737422292E747269676765722822636C69636B22293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72';
wwv_flow_api.g_varchar2_table(147) := '795D3A666972737422292E6E65787428292E6E65787428292E747269676765722822636C69636B22293B0D0A0D0A20202020202020202F2F204C6F6164696E67206F6666202F2066696C74657273206F6E0D0A2020202020202020242827237072657469';
wwv_flow_api.g_varchar2_table(148) := '757352657665616C6572496E6C696E65202E72657665616C65722D6C6F6164696E6727292E616464436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A2020202020202020242827237072657469757352657665616C6572496E';
wwv_flow_api.g_varchar2_table(149) := '6C696E65202E72657665616C65722D68656164657227292E72656D6F7665436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A0D0A20202020202020202F2F466F6375730D0A2020202020202020242827237072657469757352';
wwv_flow_api.g_varchar2_table(150) := '657665616C6572496E6C696E65202372536561726368426F7827292E666F63757328293B0D0A0D0A2020202020202020696620282077696E646F772E6C6F636174696F6E2E686F7374203D3D2027617065782E6F7261636C652E636F6D2720297B200D0A';
wwv_flow_api.g_varchar2_table(151) := '202020202020202020202020242827237072657469757352657665616C6572496E6C696E65206C6162656C5B666F723D22446562756750616765225D27292E616464436C6173732827617065785F64697361626C656427293B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(152) := '202020242827237072657469757352657665616C6572496E6C696E65202344656275675061676527292E706172656E7428292E6174747228277469746C65272C2744697361626C6564206F6E20617065782E6F7261636C652E636F6D2064756520746F20';
wwv_flow_api.g_varchar2_table(153) := '4F52412D303030343027293B0D0A20202020202020207D0D0A0D0A202020207D3B0D0A0D0A2020202066756E6374696F6E2061706578446576546F6F6C62617252657665616C657228704D6F646529207B0D0A0D0A2020202020202020617065782E7468';
wwv_flow_api.g_varchar2_table(154) := '656D652E6F70656E526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E742D4469616C6F67526567696F6E2D626F6479';
wwv_flow_api.g_varchar2_table(155) := '22292E6C6F6164287064742E6F70742E66696C65507265666978202B202272657665616C65722E68746D6C22293B0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427';
wwv_flow_api.g_varchar2_table(156) := '292E656D70747928293B0D0A20202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E75692D6469616C6F672D7469746C6527292E746578742827205072657469757320446576656C6F70657220546F';
wwv_flow_api.g_varchar2_table(157) := '6F6C3A2052657665616C657227293B0D0A202020202020202073656E644D6F64616C4D65737361676528293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E20616464486970737465722829207B0D0A0D0A202020202020202076617220';
wwv_flow_api.g_varchar2_table(158) := '634973546F6F6C62617250726573656E74203D202428222361706578446576546F6F6C62617222292E6C656E677468203E20303B0D0A202020202020202069662028634973546F6F6C62617250726573656E7429207B0D0A0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(159) := '2020696620282428272361706578446576546F6F6C626172517569636B4564697427292E6C656E677468203E2030202626202428272361706578446576546F6F6C62617252657665616C657227292E6C656E677468203D3D203029207B0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(160) := '2020202020202020202020202072657665616C657249636F6E48746D6C203D20273C7370616E20636C6173733D22612D49636F6E2066612066612D686970737465722220617269612D68696464656E3D2274727565223E3C2F7370616E3E270D0A202020';
wwv_flow_api.g_varchar2_table(161) := '20202020202020202020202020766172206B62203D207064742E67657453657474696E67282772657665616C65722E6B6227292E746F4C6F7765724361736528293B0D0A202020202020202020202020202020202428272361706578446576546F6F6C62';
wwv_flow_api.g_varchar2_table(162) := '6172517569636B4564697427292E706172656E7428292E6265666F7265280D0A202020202020202020202020202020202020202068746D6C4465636F646528617065782E6C616E672E666F726D6174280D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(163) := '202020202020273C6C693E3C627574746F6E2069643D2261706578446576546F6F6C62617252657665616C65722220747970653D22627574746F6E2220636C6173733D22612D427574746F6E20612D427574746F6E2D2D646576546F6F6C626172222074';
wwv_flow_api.g_varchar2_table(164) := '69746C653D2256696577205061676520496E666F726D6174696F6E205B6374726C2B616C742B25305D2220617269612D6C6162656C3D22566172732220646174612D6C696E6B3D22223E2027202B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(165) := '202020202725313C7370616E20636C6173733D22612D446576546F6F6C6261722D627574746F6E4C6162656C223E52657665616C65723C2F7370616E3E2027202B0D0A202020202020202020202020202020202020202020202020273C2F627574746F6E';
wwv_flow_api.g_varchar2_table(166) := '3E3C2F6C693E272C0D0A2020202020202020202020202020202020202020202020206B622C0D0A20202020202020202020202020202020202020202020202072657665616C657249636F6E48746D6C0D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(167) := '2029290D0A20202020202020202020202020202020293B0D0A0D0A0D0A202020202020202020202020202020207661722068203D20646F63756D656E742E676574456C656D656E7442794964282261706578446576546F6F6C62617252657665616C6572';
wwv_flow_api.g_varchar2_table(168) := '22293B0D0A20202020202020202020202020202020696620286829207B0D0A2020202020202020202020202020202020202020682E6164644576656E744C697374656E65722822636C69636B222C2066756E6374696F6E20286576656E7429207B0D0A20';
wwv_flow_api.g_varchar2_table(169) := '202020202020202020202020202020202020202020202061706578446576546F6F6C62617252657665616C657228293B0D0A0D0A20202020202020202020202020202020202020207D2C2074727565293B0D0A202020202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(170) := '0D0A0D0A202020202020202020202020202020207064742E666978546F6F6C626172576964746828293B0D0A202020202020202020202020202020202F2F20437573746F6D204150455820352E30207769647468206669780D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(171) := '2020202020202428272361706578446576546F6F6C62617227292E7769647468282428272E612D446576546F6F6C6261722D6C69737427292E77696474682829202B2027707827293B0D0A0D0A2020202020202020202020202020202069662028706474';
wwv_flow_api.g_varchar2_table(172) := '2E67657453657474696E67282772657665616C65722E6B62272920213D20272729207B0D0A0D0A2020202020202020202020202020202020202020696620286B6220213D20222229207B0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(173) := '2F2F2042696E64206B6579626F6172642073686F7274637574730D0A2020202020202020202020202020202020202020202020204D6F757365747261702E62696E64476C6F62616C28276374726C2B616C742B27202B206B622C2066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(174) := '286529207B0D0A20202020202020202020202020202020202020202020202020202020706172656E742E2428273A666F63757327292E626C757228293B0D0A20202020202020202020202020202020202020202020202020202020706172656E742E7064';
wwv_flow_api.g_varchar2_table(175) := '742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F6465203D2066616C73653B0D0A20202020202020202020202020202020202020202020202020202020706172656E742E2428222361706578446576546F6F6C6261725265';
wwv_flow_api.g_varchar2_table(176) := '7665616C657222292E747269676765722827636C69636B27293B0D0A2020202020202020202020202020202020202020202020207D293B0D0A2020202020202020202020202020202020202020202020204D6F757365747261702E62696E64476C6F6261';
wwv_flow_api.g_varchar2_table(177) := '6C28276374726C2B616C742B73686966742B27202B206B622C2066756E6374696F6E20286529207B0D0A2020202020202020202020202020202020202020202020202020202069662028706172656E742E2428222361706578446576546F6F6C62617252';
wwv_flow_api.g_varchar2_table(178) := '657665616C657222292E6C656E677468203E203029207B0D0A2020202020202020202020202020202020202020202020202020202020202020706172656E742E2428273A666F63757327292E626C757228293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(179) := '2020202020202020202020202020202020617065782E6D6573736167652E73686F77506167655375636365737328224F70656E696E672052657665616C657220696E204465627567204D6F646522293B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(180) := '2020202020202020202020202020706172656E742E7064742E70726574697573436F6E74656E7452657665616C65722E64656275674D6F6465203D20747275653B0D0A202020202020202020202020202020202020202020202020202020202020202070';
wwv_flow_api.g_varchar2_table(181) := '6172656E742E2428222361706578446576546F6F6C62617252657665616C657222292E747269676765722827636C69636B27293B0D0A202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(182) := '2020202020202020207D293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D0D0A0D0A0D0A202020202020202020202020202020202F2F2063726970706C65205461626C6F636B205265766561';
wwv_flow_api.g_varchar2_table(183) := '6C65720D0A20202020202020202020202020202020696620287064742E67657453657474696E67282772657665616C65722E7461626C6F636B646561637469766174652729203D3D2027592729207B0D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(184) := '2063726970706C655461624C6F636B52657665616C657228293B3B0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A0D0A0D0A2020202072657475726E207B0D';
wwv_flow_api.g_varchar2_table(185) := '0A2020202020202020616464486970737465723A20616464486970737465722C0D0A2020202020202020696E6A6563745363726970743A20696E6A6563745363726970742C0D0A202020202020202064656275674D6F64653A2064656275674D6F64650D';
wwv_flow_api.g_varchar2_table(186) := '0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135222961215973937)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'contentRevealer.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202A204A5175657279205549204469616C6F6720657874656E6420746F2061646420636F6C6C61707365206361706162696C697479204353532E0A202A0A202A20436F7079726967687420323031332E20204D61726B6F204D617274696E6F7669';
wwv_flow_api.g_varchar2_table(2) := 'C4870A202A20687474703A2F2F7777772E746563687974616C6B2E696E666F0A202A2F0A0A2E75692D6469616C6F67202E75692D6469616C6F672D7469746C656261722D636F6C6C617073652C0A2E75692D6469616C6F67202E75692D6469616C6F672D';
wwv_flow_api.g_varchar2_table(3) := '7469746C656261722D636F6C6C617073652D726573746F7265207B0A09706F736974696F6E3A206162736F6C7574653B0A0972696768743A20302E33656D3B0A09746F703A203530253B0A0977696474683A20323170783B0A096D617267696E3A202D31';
wwv_flow_api.g_varchar2_table(4) := '3070782030203020303B0A0970616464696E673A203170783B0A096865696768743A20323070783B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135223302462973941)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'jquery.ui.dialog-collapse.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0D0A202A20457874656E6473204A5175657279205549204469616C6F6720746F2061646420636F6C6C6170736520627574746F6E20666561747572652E0D0A202A0D0A202A20436F7079726967687420323031332E20204D61726B6F204D61727469';
wwv_flow_api.g_varchar2_table(2) := '6E6F7669C4870D0A202A20687474703A2F2F7777772E746563687974616C6B2E696E666F0D0A202A2F0D0A2866756E6374696F6E282429207B0D0A202020202F2F204164642064656661756C74206F7074696F6E7320616E64206576656E742063616C6C';
wwv_flow_api.g_varchar2_table(3) := '6261636B730D0A20202020242E657874656E6428242E75692E6469616C6F672E70726F746F747970652E6F7074696F6E732C207B0D0A2020202020202020636F6C6C61707365456E61626C65643A206E756C6C2C0D0A20202020202020206265666F7265';
wwv_flow_api.g_varchar2_table(4) := '436F6C6C617073653A206E756C6C2C0D0A2020202020202020636F6C6C617073653A206E756C6C2C0D0A20202020202020206265666F7265436F6C6C61707365526573746F72653A206E756C6C2C0D0A2020202020202020636F6C6C6170736552657374';
wwv_flow_api.g_varchar2_table(5) := '6F72653A206E756C6C0D0A202020207D293B0D0A0D0A202020202F2F204261636B7570206F6C64205F696E69740D0A20202020766172205F696E6974203D20242E75692E6469616C6F672E70726F746F747970652E5F696E69743B0D0A0D0A202020202F';
wwv_flow_api.g_varchar2_table(6) := '2F204E6577205F696E69740D0A20202020242E75692E6469616C6F672E70726F746F747970652E5F696E6974203D2066756E6374696F6E2829207B0D0A20202020202020202F2F204170706C79206F6C64205F696E69740D0A20202020202020205F696E';
wwv_flow_api.g_varchar2_table(7) := '69742E6170706C7928746869732C20617267756D656E7473293B0D0A0D0A20202020202020202F2F20486F6C6473206F726967696E616C20746869732E6F7074696F6E732E726573697A61626C650D0A202020202020202076617220726573697A61626C';
wwv_flow_api.g_varchar2_table(8) := '654F6C64203D206E756C6C3B0D0A2020202020202020696628746869732E6F7074696F6E732E636F6C6C61707365456E61626C656429207B0D0A202020202020202020202020746869732E616464436F6C6C61707365427574746F6E203D2066756E6374';
wwv_flow_api.g_varchar2_table(9) := '696F6E2829207B0D0A202020202020202020202020202020202F2F20486964652074686520726573746F726520627574746F6E206966206974206578697374730D0A20202020202020202020202020202020696628746869732E75694469616C6F675469';
wwv_flow_api.g_varchar2_table(10) := '746C65626172436F6C6C61707365526573746F7265290D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652E6869646528293B0D0A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(11) := '20202020202020202F2F204164642074686520636F6C6C6170736520627574746F6E20696620697420646F65736E2774206578697374730D0A2020202020202020202020202020202069662821746869732E75694469616C6F675469746C65626172436F';
wwv_flow_api.g_varchar2_table(12) := '6C6C6170736529207B0D0A0D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C61707365203D2024280D0A2020202020202020202020202020202020202020273C627574746F6E207479';
wwv_flow_api.g_varchar2_table(13) := '70653D22627574746F6E22207469746C653D22436F6D70726573732220617269612D6C6162656C3D22436F6D70726573732220636C6173733D2270726574697573436F6D707265737342746E20742D427574746F6E20742D427574746F6E2D2D6E6F4C61';
wwv_flow_api.g_varchar2_table(14) := '62656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D22742D49636F6E2066612066612D636F6D7072657373223E3C2F7370616E3E3C2F';
wwv_flow_api.g_varchar2_table(15) := '627574746F6E3E270D0A2020202020202020202020202020202020202020290D0A20202020202020202020202020202020202020202E617070656E64546F2820746869732E75694469616C6F675469746C6562617220290D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(16) := '2020202020202020202E696E736572744265666F726528202428746869732E75694469616C6F675469746C65626172292E66696E642820272E75692D6469616C6F672D7469746C656261722D636C6F736527202920293B0D0A0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(17) := '2020202020202020202020746869732E5F6F6E2820746869732E75694469616C6F675469746C65626172436F6C6C617073652C207B0D0A2020202020202020202020202020202020202020202020202F2F2052756E20746869732E636F6C6C6170736520';
wwv_flow_api.g_varchar2_table(18) := '6F6E20636C69636B0D0A202020202020202020202020202020202020202020202020636C69636B3A2066756E6374696F6E28206576656E742029207B0D0A202020202020202020202020202020202020202020202020202020206576656E742E70726576';
wwv_flow_api.g_varchar2_table(19) := '656E7444656661756C7428293B0D0A20202020202020202020202020202020202020202020202020202020746869732E636F6C6C6170736528206576656E7420293B0D0A2020202020202020202020202020202020202020202020207D0D0A2020202020';
wwv_flow_api.g_varchar2_table(20) := '2020202020202020202020202020207D293B0D0A202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C617073652E73686F77';
wwv_flow_api.g_varchar2_table(21) := '28293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020746869732E616464436F6C6C61707365526573746F7265427574746F6E203D2066756E6374696F6E2829207B0D0A20';
wwv_flow_api.g_varchar2_table(22) := '2020202020202020202020202020202F2F20486964652074686520636F6C6C6170736520627574746F6E206966206974206578697374730D0A20202020202020202020202020202020696628746869732E75694469616C6F675469746C65626172436F6C';
wwv_flow_api.g_varchar2_table(23) := '6C61707365290D0A2020202020202020202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C617073652E6869646528293B0D0A0D0A202020202020202020202020202020202F2F20416464207468652072657374';
wwv_flow_api.g_varchar2_table(24) := '6F726520627574746F6E20696620697420646F65736E2774206578697374730D0A2020202020202020202020202020202069662821746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F7265297B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(25) := '20202020202020202020202020746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F7265203D2024280D0A202020202020202020202020202020202020202020202020273C627574746F6E20747970653D22627574746F';
wwv_flow_api.g_varchar2_table(26) := '6E22207469746C653D22457870616E642220617269612D6C6162656C3D22457870616E642220636C6173733D2270726574697573457870616E6442746E20742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69';
wwv_flow_api.g_varchar2_table(27) := '636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D22742D49636F6E2066612066612D657870616E64223E3C2F7370616E3E3C2F627574746F6E3E270D0A20202020202020';
wwv_flow_api.g_varchar2_table(28) := '2020202020202020202020202020202020290D0A20202020202020202020202020202020202020202E696E736572744265666F726528202428746869732E75694469616C6F675469746C65626172292E66696E642820272E75692D6469616C6F672D7469';
wwv_flow_api.g_varchar2_table(29) := '746C656261722D636C6F736527202920293B0D0A2020202020202020202020202020202020202020746869732E5F6F6E2820746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652C207B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(30) := '2020202020202020202020202020202F2F2052756E20746869732E726573746F7265206F6E20636C69636B0D0A202020202020202020202020202020202020202020202020636C69636B3A2066756E6374696F6E28206576656E742029207B0D0A202020';
wwv_flow_api.g_varchar2_table(31) := '202020202020202020202020202020202020202020202020206576656E742E70726576656E7444656661756C7428293B0D0A20202020202020202020202020202020202020202020202020202020746869732E726573746F726528206576656E7420293B';
wwv_flow_api.g_varchar2_table(32) := '0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '746869732E75694469616C6F675469746C65626172436F6C6C61707365526573746F72652E73686F7728293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020746869732E63';
wwv_flow_api.g_varchar2_table(34) := '6F6C6C61707365203D2066756E6374696F6E286576656E7429207B0D0A202020202020202020202020202020207661722073656C66203D20746869733B0D0A0D0A202020202020202020202020202020202F2F20416C6C6F772070656F706C6520746F20';
wwv_flow_api.g_varchar2_table(35) := '61626F727420636F6C6C61707365206576656E740D0A202020202020202020202020202020206966202866616C7365203D3D3D2073656C662E5F7472696767657228276265666F7265436F6C6C61707365272929207B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(36) := '202020202020202072657475726E3B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F20736C696465557020746865206469616C6F6720656C656D656E740D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(37) := '20746869732E656C656D656E742E736C6964655570282766617374272C2066756E6374696F6E2829207B0D0A20202020202020202020202020202020202020202F2F204465616C20776974682074686520726573697A61626C65206F7074696F6E0D0A20';
wwv_flow_api.g_varchar2_table(38) := '2020202020202020202020202020202020202069662873656C662E6F7074696F6E732E726573697A61626C65297B0D0A2020202020202020202020202020202020202020202020202F2F204261636B7570206F6C6420726573697A61626C65206F707469';
wwv_flow_api.g_varchar2_table(39) := '6F6E0D0A202020202020202020202020202020202020202020202020726573697A61626C654F6C64203D2073656C662E6F7074696F6E732E726573697A61626C653B0D0A0D0A2020202020202020202020202020202020202020202020202F2F20446573';
wwv_flow_api.g_varchar2_table(40) := '74726F792074686520726573697A61626C6520616E6420736574206469616C6F672068656967687420746F206175746F0D0A20202020202020202020202020202020202020202020202073656C662E75694469616C6F672E726573697A61626C65282764';
wwv_flow_api.g_varchar2_table(41) := '657374726F7927292E6373732827686569676874272C20276175746F27293B0D0A0D0A2020202020202020202020202020202020202020202020202F2F204F7665727772697465206F726967696E616C20726573697A61626C65206F7074696F6E20746F';
wwv_flow_api.g_varchar2_table(42) := '2064697361626C6520766572746963616C20726573697A650D0A20202020202020202020202020202020202020202020202073656C662E6F7074696F6E732E726573697A61626C65203D2027652C2077273B0D0A0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '202020202020202020202F2F204D616B6520726573697A61626C65207769746820746865206E657720726573697A61626C65206F7074696F6E0D0A20202020202020202020202020202020202020202020202073656C662E5F6D616B65526573697A6162';
wwv_flow_api.g_varchar2_table(44) := '6C6528293B0D0A20202020202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202F2F205265706C61636520636F6C6C6170736520627574746F6E207769746820726573746F726520627574746F6E0D0A';
wwv_flow_api.g_varchar2_table(45) := '202020202020202020202020202020202020202073656C662E616464436F6C6C61707365526573746F7265427574746F6E28293B0D0A0D0A20202020202020202020202020202020202020202F2F205472696767657220636F6C6C61707365206576656E';
wwv_flow_api.g_varchar2_table(46) := '740D0A202020202020202020202020202020202020202073656C662E5F747269676765722827636F6C6C6170736527293B0D0A202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202072657475726E2073656C';
wwv_flow_api.g_varchar2_table(47) := '663B0D0A2020202020202020202020207D3B0D0A0D0A202020202020202020202020746869732E726573746F7265203D2066756E6374696F6E286576656E7429207B0D0A202020202020202020202020202020207661722073656C66203D20746869733B';
wwv_flow_api.g_varchar2_table(48) := '0D0A0D0A202020202020202020202020202020202F2F20416C6C6F772070656F706C6520746F2061626F727420726573746F7265206576656E740D0A202020202020202020202020202020206966202866616C7365203D3D3D2073656C662E5F74726967';
wwv_flow_api.g_varchar2_table(49) := '67657228276265666F7265436F6C6C61707365526573746F7265272929207B0D0A20202020202020202020202020202020202020202020202072657475726E3B0D0A202020202020202020202020202020207D0D0A0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '2020202F2F20736C696465446F776E20746865206469616C6F6720656C656D656E740D0A20202020202020202020202020202020746869732E656C656D656E742E736C696465446F776E282766617374272C2066756E6374696F6E2829207B0D0A202020';
wwv_flow_api.g_varchar2_table(51) := '20202020202020202020202020202020202F2F204465616C20776974682074686520726573697A61626C65206F7074696F6E0D0A202020202020202020202020202020202020202069662873656C662E6F7074696F6E732E726573697A61626C65297B0D';
wwv_flow_api.g_varchar2_table(52) := '0A2020202020202020202020202020202020202020202020202F2F2044657374726F79206F757220686F72697A6F6E74616C206F6E6C7920726573697A650D0A20202020202020202020202020202020202020202020202073656C662E75694469616C6F';
wwv_flow_api.g_varchar2_table(53) := '672E726573697A61626C65282764657374726F7927293B0D0A0D0A2020202020202020202020202020202020202020202020202F2F20526573746F7265206F726967696E616C20726573697A61626C65206F7074696F6E2066726F6D206261636B75700D';
wwv_flow_api.g_varchar2_table(54) := '0A20202020202020202020202020202020202020202020202073656C662E6F7074696F6E732E726573697A61626C65203D20726573697A61626C654F6C643B0D0A0D0A2020202020202020202020202020202020202020202020202F2F204D616B652072';
wwv_flow_api.g_varchar2_table(55) := '6573697A61626C65207769746820746865206F726967696E616C20726573697A61626C65206F7074696F6E0D0A20202020202020202020202020202020202020202020202073656C662E5F6D616B65526573697A61626C6528293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(56) := '202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202F2F205265706C61636520726573746F726520627574746F6E207769746820636F6C6C6170736520627574746F6E0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(57) := '20202020202073656C662E616464436F6C6C61707365427574746F6E28293B0D0A0D0A20202020202020202020202020202020202020202F2F205472696767657220636F6C6C61707365206576656E740D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(58) := '202073656C662E5F747269676765722827636F6C6C61707365526573746F726527293B0D0A202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202072657475726E2073656C663B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(59) := '20207D3B0D0A0D0A2020202020202020202020202F2F2042792064656661756C742061646420626F746820627574746F6E732C20636F6C6C6170736520627574746F6E2077696C6C206869646520726573746F72650D0A20202020202020202020202074';
wwv_flow_api.g_varchar2_table(60) := '6869732E616464436F6C6C61707365526573746F7265427574746F6E28293B0D0A202020202020202020202020746869732E616464436F6C6C61707365427574746F6E28293B0D0A0D0A2020202020202020202020202F2F204465616C20776974682063';
wwv_flow_api.g_varchar2_table(61) := '6F6C6C6170736520616E6420726573746F726520627574746F6E7320706F736974696F6E20696620636C6F736520627574746F6E2069732076697369626C650D0A202020202020202020202020696628746869732E75694469616C6F675469746C656261';
wwv_flow_api.g_varchar2_table(62) := '72436C6F736520262620746869732E75694469616C6F675469746C65626172436C6F73652E697328273A76697369626C65272929207B0D0A20202020202020202020202020202020766172207269676874203D207061727365466C6F617428746869732E';
wwv_flow_api.g_varchar2_table(63) := '75694469616C6F675469746C65626172436C6F73652E637373282772696768742729293B0D0A0D0A202020202020202020202020202020202428272E75692D6469616C6F672D7469746C656261722D636F6C6C617073652C202E75692D6469616C6F672D';
wwv_flow_api.g_varchar2_table(64) := '7469746C656261722D636F6C6C617073652D726573746F726527290D0A20202020202020202020202020202020202020202E63737328277269676874272C20322A72696768742B746869732E75694469616C6F675469746C65626172436C6F73652E6F75';
wwv_flow_api.g_varchar2_table(65) := '746572576964746828292B27707827293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D3B0D0A7D286A517565727929293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135223734395973942)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'jquery.ui.dialog-collapse.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2866756E6374696F6E2861297B76617220633D7B7D2C643D612E70726F746F747970652E73746F7043616C6C6261636B3B612E70726F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28652C622C612C66297B72657475726E2074';
wwv_flow_api.g_varchar2_table(2) := '6869732E7061757365643F21303A635B615D7C7C635B665D3F21313A642E63616C6C28746869732C652C622C61297D3B612E70726F746F747970652E62696E64476C6F62616C3D66756E6374696F6E28612C622C64297B746869732E62696E6428612C62';
wwv_flow_api.g_varchar2_table(3) := '2C64293B6966286120696E7374616E63656F6620417272617929666F7228623D303B623C612E6C656E6774683B622B2B29635B615B625D5D3D21303B656C736520635B615D3D21307D3B612E696E697428297D29284D6F75736574726170293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135224143622973943)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'mousetrap-global-bind.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A206D6F757365747261702076312E362E312063726169672E69732F6B696C6C696E672F6D696365202A2F0A2866756E6374696F6E28722C762C66297B66756E6374696F6E207728612C622C67297B612E6164644576656E744C697374656E65723F61';
wwv_flow_api.g_varchar2_table(2) := '2E6164644576656E744C697374656E657228622C672C2131293A612E6174746163684576656E7428226F6E222B622C67297D66756E6374696F6E20412861297B696628226B65797072657373223D3D612E74797065297B76617220623D537472696E672E';
wwv_flow_api.g_varchar2_table(3) := '66726F6D43686172436F646528612E7768696368293B612E73686966744B65797C7C28623D622E746F4C6F776572436173652829293B72657475726E20627D72657475726E20705B612E77686963685D3F705B612E77686963685D3A745B612E77686963';
wwv_flow_api.g_varchar2_table(4) := '685D3F745B612E77686963685D3A537472696E672E66726F6D43686172436F646528612E7768696368292E746F4C6F7765724361736528297D66756E6374696F6E20462861297B76617220623D5B5D3B612E73686966744B65792626622E707573682822';
wwv_flow_api.g_varchar2_table(5) := '736869667422293B612E616C744B65792626622E707573682822616C7422293B612E6374726C4B65792626622E7075736828226374726C22293B612E6D6574614B65792626622E7075736828226D65746122293B72657475726E20627D66756E6374696F';
wwv_flow_api.g_varchar2_table(6) := '6E20782861297B72657475726E227368696674223D3D617C7C226374726C223D3D617C7C22616C74223D3D617C7C0A226D657461223D3D617D66756E6374696F6E204228612C62297B76617220672C632C642C663D5B5D3B673D613B222B223D3D3D673F';
wwv_flow_api.g_varchar2_table(7) := '673D5B222B225D3A28673D672E7265706C616365282F5C2B7B327D2F672C222B706C757322292C673D672E73706C697428222B2229293B666F7228643D303B643C672E6C656E6774683B2B2B6429633D675B645D2C435B635D262628633D435B635D292C';
wwv_flow_api.g_varchar2_table(8) := '622626226B6579707265737322213D622626445B635D262628633D445B635D2C662E70757368282273686966742229292C782863292626662E707573682863293B673D633B643D623B6966282164297B696628216E297B6E3D7B7D3B666F722876617220';
wwv_flow_api.g_varchar2_table(9) := '7120696E20702939353C7126263131323E717C7C702E6861734F776E50726F70657274792871292626286E5B705B715D5D3D71297D643D6E5B675D3F226B6579646F776E223A226B65797072657373227D226B65797072657373223D3D642626662E6C65';
wwv_flow_api.g_varchar2_table(10) := '6E677468262628643D226B6579646F776E22293B72657475726E7B6B65793A632C6D6F646966696572733A662C616374696F6E3A647D7D66756E6374696F6E204528612C62297B72657475726E206E756C6C3D3D3D617C7C613D3D3D763F21313A613D3D';
wwv_flow_api.g_varchar2_table(11) := '3D623F21303A4528612E706172656E744E6F64652C62297D66756E6374696F6E20632861297B66756E6374696F6E20622861297B613D0A617C7C7B7D3B76617220623D21312C6C3B666F72286C20696E206E29615B6C5D3F623D21303A6E5B6C5D3D303B';
wwv_flow_api.g_varchar2_table(12) := '627C7C28793D2131297D66756E6374696F6E206728612C622C752C652C632C67297B766172206C2C6D2C6B3D5B5D2C663D752E747970653B69662821682E5F63616C6C6261636B735B615D2972657475726E5B5D3B226B65797570223D3D662626782861';
wwv_flow_api.g_varchar2_table(13) := '29262628623D5B615D293B666F72286C3D303B6C3C682E5F63616C6C6261636B735B615D2E6C656E6774683B2B2B6C296966286D3D682E5F63616C6C6261636B735B615D5B6C5D2C28657C7C216D2E7365717C7C6E5B6D2E7365715D3D3D6D2E6C657665';
wwv_flow_api.g_varchar2_table(14) := '6C292626663D3D6D2E616374696F6E297B76617220643B28643D226B65797072657373223D3D66262621752E6D6574614B6579262621752E6374726C4B6579297C7C28643D6D2E6D6F646966696572732C643D622E736F727428292E6A6F696E28222C22';
wwv_flow_api.g_varchar2_table(15) := '293D3D3D642E736F727428292E6A6F696E28222C2229293B64262628643D6526266D2E7365713D3D6526266D2E6C6576656C3D3D672C28216526266D2E636F6D626F3D3D637C7C64292626682E5F63616C6C6261636B735B615D2E73706C696365286C2C';
wwv_flow_api.g_varchar2_table(16) := '31292C6B2E70757368286D29297D72657475726E206B7D66756E6374696F6E206628612C622C632C65297B682E73746F7043616C6C6261636B28622C0A622E7461726765747C7C622E737263456C656D656E742C632C65297C7C2131213D3D6128622C63';
wwv_flow_api.g_varchar2_table(17) := '297C7C28622E70726576656E7444656661756C743F622E70726576656E7444656661756C7428293A622E72657475726E56616C75653D21312C622E73746F7050726F7061676174696F6E3F622E73746F7050726F7061676174696F6E28293A622E63616E';
wwv_flow_api.g_varchar2_table(18) := '63656C427562626C653D2130297D66756E6374696F6E20642861297B226E756D62657222213D3D747970656F6620612E7768696368262628612E77686963683D612E6B6579436F6465293B76617220623D412861293B62262628226B65797570223D3D61';
wwv_flow_api.g_varchar2_table(19) := '2E7479706526267A3D3D3D623F7A3D21313A682E68616E646C654B657928622C462861292C6129297D66756E6374696F6E207028612C632C752C65297B66756E6374696F6E206C2863297B72657475726E2066756E6374696F6E28297B793D633B2B2B6E';
wwv_flow_api.g_varchar2_table(20) := '5B615D3B636C65617254696D656F75742872293B723D73657454696D656F757428622C314533297D7D66756E6374696F6E20672863297B6628752C632C61293B226B6579757022213D3D652626287A3D41286329293B73657454696D656F757428622C31';
wwv_flow_api.g_varchar2_table(21) := '30297D666F722876617220643D6E5B615D3D303B643C632E6C656E6774683B2B2B64297B766172206D3D642B313D3D3D632E6C656E6774683F673A6C28657C7C0A4228635B642B315D292E616374696F6E293B7128635B645D2C6D2C652C612C64297D7D';
wwv_flow_api.g_varchar2_table(22) := '66756E6374696F6E207128612C622C632C652C64297B682E5F6469726563744D61705B612B223A222B635D3D623B613D612E7265706C616365282F5C732B2F672C222022293B76617220663D612E73706C697428222022293B313C662E6C656E6774683F';
wwv_flow_api.g_varchar2_table(23) := '7028612C662C622C63293A28633D4228612C63292C682E5F63616C6C6261636B735B632E6B65795D3D682E5F63616C6C6261636B735B632E6B65795D7C7C5B5D2C6728632E6B65792C632E6D6F646966696572732C7B747970653A632E616374696F6E7D';
wwv_flow_api.g_varchar2_table(24) := '2C652C612C64292C682E5F63616C6C6261636B735B632E6B65795D5B653F22756E7368696674223A2270757368225D287B63616C6C6261636B3A622C6D6F646966696572733A632E6D6F646966696572732C616374696F6E3A632E616374696F6E2C7365';
wwv_flow_api.g_varchar2_table(25) := '713A652C6C6576656C3A642C636F6D626F3A617D29297D76617220683D746869733B613D617C7C763B69662821286820696E7374616E63656F662063292972657475726E206E657720632861293B682E7461726765743D613B682E5F63616C6C6261636B';
wwv_flow_api.g_varchar2_table(26) := '733D7B7D3B682E5F6469726563744D61703D7B7D3B766172206E3D7B7D2C722C7A3D21312C743D21312C793D21313B682E5F68616E646C654B65793D66756E6374696F6E28612C0A632C64297B76617220653D6728612C632C64292C6B3B633D7B7D3B76';
wwv_flow_api.g_varchar2_table(27) := '617220683D302C6C3D21313B666F72286B3D303B6B3C652E6C656E6774683B2B2B6B29655B6B5D2E736571262628683D4D6174682E6D617828682C655B6B5D2E6C6576656C29293B666F72286B3D303B6B3C652E6C656E6774683B2B2B6B29655B6B5D2E';
wwv_flow_api.g_varchar2_table(28) := '7365713F655B6B5D2E6C6576656C3D3D682626286C3D21302C635B655B6B5D2E7365715D3D312C6628655B6B5D2E63616C6C6261636B2C642C655B6B5D2E636F6D626F2C655B6B5D2E73657129293A6C7C7C6628655B6B5D2E63616C6C6261636B2C642C';
wwv_flow_api.g_varchar2_table(29) := '655B6B5D2E636F6D626F293B653D226B65797072657373223D3D642E747970652626743B642E74797065213D797C7C782861297C7C657C7C622863293B743D6C2626226B6579646F776E223D3D642E747970657D3B682E5F62696E644D756C7469706C65';
wwv_flow_api.g_varchar2_table(30) := '3D66756E6374696F6E28612C622C63297B666F722876617220643D303B643C612E6C656E6774683B2B2B64297128615B645D2C622C63297D3B7728612C226B65797072657373222C64293B7728612C226B6579646F776E222C64293B7728612C226B6579';
wwv_flow_api.g_varchar2_table(31) := '7570222C64297D69662872297B76617220703D7B383A226261636B7370616365222C393A22746162222C31333A22656E746572222C31363A227368696674222C31373A226374726C222C0A31383A22616C74222C32303A22636170736C6F636B222C3237';
wwv_flow_api.g_varchar2_table(32) := '3A22657363222C33323A227370616365222C33333A22706167657570222C33343A2270616765646F776E222C33353A22656E64222C33363A22686F6D65222C33373A226C656674222C33383A227570222C33393A227269676874222C34303A22646F776E';
wwv_flow_api.g_varchar2_table(33) := '222C34353A22696E73222C34363A2264656C222C39313A226D657461222C39333A226D657461222C3232343A226D657461227D2C743D7B3130363A222A222C3130373A222B222C3130393A222D222C3131303A222E222C3131313A222F222C3138363A22';
wwv_flow_api.g_varchar2_table(34) := '3B222C3138373A223D222C3138383A222C222C3138393A222D222C3139303A222E222C3139313A222F222C3139323A2260222C3231393A225B222C3232303A225C5C222C3232313A225D222C3232323A2227227D2C443D7B227E223A2260222C2221223A';
wwv_flow_api.g_varchar2_table(35) := '2231222C2240223A2232222C2223223A2233222C243A2234222C2225223A2235222C225E223A2236222C2226223A2237222C222A223A2238222C2228223A2239222C2229223A2230222C5F3A222D222C222B223A223D222C223A223A223B222C2722273A';
wwv_flow_api.g_varchar2_table(36) := '2227222C223C223A222C222C223E223A222E222C223F223A222F222C227C223A225C5C227D2C433D7B6F7074696F6E3A22616C74222C636F6D6D616E643A226D657461222C2272657475726E223A22656E746572222C0A6573636170653A22657363222C';
wwv_flow_api.g_varchar2_table(37) := '706C75733A222B222C6D6F643A2F4D61637C69506F647C6950686F6E657C695061642F2E74657374286E6176696761746F722E706C6174666F726D293F226D657461223A226374726C227D2C6E3B666F7228663D313B32303E663B2B2B6629705B313131';
wwv_flow_api.g_varchar2_table(38) := '2B665D3D2266222B663B666F7228663D303B393E3D663B2B2B6629705B662B39365D3D662E746F537472696E6728293B632E70726F746F747970652E62696E643D66756E6374696F6E28612C622C63297B613D6120696E7374616E63656F662041727261';
wwv_flow_api.g_varchar2_table(39) := '793F613A5B615D3B746869732E5F62696E644D756C7469706C652E63616C6C28746869732C612C622C63293B72657475726E20746869737D3B632E70726F746F747970652E756E62696E643D66756E6374696F6E28612C62297B72657475726E20746869';
wwv_flow_api.g_varchar2_table(40) := '732E62696E642E63616C6C28746869732C612C66756E6374696F6E28297B7D2C62297D3B632E70726F746F747970652E747269676765723D66756E6374696F6E28612C62297B696628746869732E5F6469726563744D61705B612B223A222B625D297468';
wwv_flow_api.g_varchar2_table(41) := '69732E5F6469726563744D61705B612B223A222B625D287B7D2C61293B72657475726E20746869737D3B632E70726F746F747970652E72657365743D66756E6374696F6E28297B746869732E5F63616C6C6261636B733D7B7D3B0A746869732E5F646972';
wwv_flow_api.g_varchar2_table(42) := '6563744D61703D7B7D3B72657475726E20746869737D3B632E70726F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28612C62297B72657475726E2D313C282220222B622E636C6173734E616D652B222022292E696E6465784F66';
wwv_flow_api.g_varchar2_table(43) := '2822206D6F757365747261702022297C7C4528622C746869732E746172676574293F21313A22494E505554223D3D622E7461674E616D657C7C2253454C454354223D3D622E7461674E616D657C7C225445585441524541223D3D622E7461674E616D657C';
wwv_flow_api.g_varchar2_table(44) := '7C622E6973436F6E74656E744564697461626C657D3B632E70726F746F747970652E68616E646C654B65793D66756E6374696F6E28297B72657475726E20746869732E5F68616E646C654B65792E6170706C7928746869732C617267756D656E7473297D';
wwv_flow_api.g_varchar2_table(45) := '3B632E6164644B6579636F6465733D66756E6374696F6E2861297B666F7228766172206220696E206129612E6861734F776E50726F7065727479286229262628705B625D3D615B625D293B6E3D6E756C6C7D3B632E696E69743D66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(46) := '7B76617220613D632876292C623B666F72286220696E206129225F22213D3D622E636861724174283029262628635B625D3D66756E6374696F6E2862297B72657475726E2066756E6374696F6E28297B72657475726E20615B625D2E6170706C7928612C';
wwv_flow_api.g_varchar2_table(47) := '0A617267756D656E7473297D7D286229297D3B632E696E697428293B722E4D6F757365747261703D633B22756E646566696E656422213D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274732626286D6F64756C652E6578706F72';
wwv_flow_api.g_varchar2_table(48) := '74733D63293B2266756E6374696F6E223D3D3D747970656F6620646566696E652626646566696E652E616D642626646566696E652866756E6374696F6E28297B72657475726E20637D297D7D292822756E646566696E656422213D3D747970656F662077';
wwv_flow_api.g_varchar2_table(49) := '696E646F773F77696E646F773A6E756C6C2C22756E646566696E656422213D3D747970656F662077696E646F773F646F63756D656E743A6E756C6C293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135224529160973944)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'mousetrap.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '3C73637269707420747970653D226170706C69636174696F6E2F6A617661736372697074223E0D0A0D0A20202020617065782E7769646765742E7965734E6F282252305F52455645414C45525F454E41424C45222C20225357495443485F434222293B0D';
wwv_flow_api.g_varchar2_table(2) := '0A20202020617065782E7769646765742E7965734E6F282252305F52455645414C45525F43524950504C455F5441424C4F434B222C20225357495443485F434222293B0D0A20202020617065782E7769646765742E7965734E6F282252305F52454C4F41';
wwv_flow_api.g_varchar2_table(3) := '445F454E41424C45222C20225357495443485F434222293B0D0A20202020617065782E7769646765742E7965734E6F282252305F52454C4F41445F444556454C4F504552535F4F4E4C59222C20225357495443485F434222293B0D0A2020202061706578';
wwv_flow_api.g_varchar2_table(4) := '2E7769646765742E7965734E6F282252305F52454C4F41445F4259504153535F554E4348414E474544222C20225357495443485F434222293B0D0A20202020617065782E7769646765742E7965734E6F282252305F4255494C445F4F5054494F4E5F454E';
wwv_flow_api.g_varchar2_table(5) := '41424C45222C20225357495443485F434222293B0D0A0D0A202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E742D427574746F6E526567696F6E2D636F6C2D2D7269676874202E742D427574746F6E5265';
wwv_flow_api.g_varchar2_table(6) := '67696F6E2D627574746F6E7327292E656D70747928293B0D0A202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E742D427574746F6E526567696F6E2D636F6C2D2D6C656674202E742D427574746F6E5265';
wwv_flow_api.g_varchar2_table(7) := '67696F6E2D627574746F6E7327292E656D70747928293B0D0A20202020242827237072657469757352657665616C6572496E6C696E65202352305F5341564527292E617070656E64546F282428272E742D427574746F6E526567696F6E2D636F6C2D2D72';
wwv_flow_api.g_varchar2_table(8) := '69676874202E742D427574746F6E526567696F6E2D627574746F6E732729293B0D0A20202020242827237072657469757352657665616C6572496E6C696E65202352305F43414E43454C27292E617070656E64546F282428272E742D427574746F6E5265';
wwv_flow_api.g_varchar2_table(9) := '67696F6E2D636F6C2D2D6C656674202E742D427574746F6E526567696F6E2D627574746F6E732729293B0D0A202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F7020237072657469757352657665616C65724275';
wwv_flow_api.g_varchar2_table(10) := '74746F6E526567696F6E27292E73686F7728293B0D0A0D0A20202020766172204A534F4E73657474696E6773203D207064742E4A534F4E73657474696E67733B0D0A0D0A202020206966202821242E6973456D7074794F626A656374284A534F4E736574';
wwv_flow_api.g_varchar2_table(11) := '74696E67732929207B0D0A2020202020202020617065782E6974656D282252305F52455645414C45525F454E41424C4522292E73657456616C7565287064742E67657453657474696E67282772657665616C65722E656E61626C652729293B0D0A202020';
wwv_flow_api.g_varchar2_table(12) := '2020202020617065782E6974656D282252305F52455645414C45525F43524950504C455F5441424C4F434B22292E73657456616C7565287064742E6E766C287064742E67657453657474696E67282772657665616C65722E7461626C6F636B6465616374';
wwv_flow_api.g_varchar2_table(13) := '697661746527292C2027592729293B0D0A2020202020202020617065782E6974656D282252305F52455645414C45525F4B425F53484F525443555422292E73657456616C7565287064742E6E766C287064742E67657453657474696E6728277265766561';
wwv_flow_api.g_varchar2_table(14) := '6C65722E6B6227292C2027512729293B0D0A0D0A2020202020202020617065782E6974656D282252305F52454C4F41445F454E41424C4522292E73657456616C7565287064742E67657453657474696E67282772656C6F61646672616D652E656E61626C';
wwv_flow_api.g_varchar2_table(15) := '652729293B0D0A2020202020202020617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C5922292E73657456616C7565287064742E67657453657474696E67282772656C6F61646672616D652E627970617373776172';
wwv_flow_api.g_varchar2_table(16) := '6E6F6E756E73617665642729293B0D0A2020202020202020617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E47454422292E73657456616C7565287064742E6E766C287064742E67657453657474696E67282772656C';
wwv_flow_api.g_varchar2_table(17) := '6F61646672616D652E6279706173737761726E6F6E756E736176656427292C2027592729293B0D0A2020202020202020617065782E6974656D282252305F52454C4F41445F4B425F53484F525443555422292E73657456616C7565287064742E6E766C28';
wwv_flow_api.g_varchar2_table(18) := '7064742E67657453657474696E67282772656C6F61646672616D652E6B6227292C2027522729293B0D0A0D0A2020202020202020617065782E6974656D282252305F4255494C445F4F5054494F4E5F454E41424C4522292E73657456616C756528207064';
wwv_flow_api.g_varchar2_table(19) := '742E67657453657474696E6728276275696C646F7074696F6E68696768746C696768742E656E61626C652729293B0D0A2020202020202020617065782E6974656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E22292E73657456616C';
wwv_flow_api.g_varchar2_table(20) := '756528207064742E6E766C287064742E67657453657474696E6728276275696C646F7074696F6E68696768746C696768742E6475726174696F6E27292C2027362729293B0D0A20202020202020200D0A202020207D0D0A0D0A2020202024282223707265';
wwv_flow_api.g_varchar2_table(21) := '7469757352657665616C6572496E6C696E65202352305F52455645414C45525F454E41424C4522292E7472696767657228226368616E676522293B0D0A20202020242822237072657469757352657665616C6572496E6C696E65202352305F52454C4F41';
wwv_flow_api.g_varchar2_table(22) := '445F454E41424C4522292E7472696767657228226368616E676522293B0D0A20202020242822237072657469757352657665616C6572496E6C696E65202352305F4255494C445F4F5054494F4E5F454E41424C4522292E7472696767657228226368616E';
wwv_flow_api.g_varchar2_table(23) := '676522293B0D0A0D0A20202020696620287064742E6F70742E636F6E66696775726174696F6E54657374203D3D202266616C73652229207B0D0A20202020202020202428272370726574697573446576656C6F706572546F6F6C5761726E696E6727292E';
wwv_flow_api.g_varchar2_table(24) := '73686F7728293B0D0A202020207D0D0A0D0A3C2F7363726970743E0D0A3C64697620636C6173733D22726F77223E0D0A202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(25) := '3C64697620636C6173733D22742D416C65727420742D416C6572742D2D636F6C6F72424720742D416C6572742D2D686F72697A6F6E74616C20742D416C6572742D2D64656661756C7449636F6E7320742D416C6572742D2D7761726E696E6720742D416C';
wwv_flow_api.g_varchar2_table(26) := '6572742D2D61636365737369626C6548656164696E67220D0A20202020202020202020202069643D2270726574697573446576656C6F706572546F6F6C5761726E696E6722207374796C653D22646973706C61793A6E6F6E65223E0D0A20202020202020';
wwv_flow_api.g_varchar2_table(27) := '20202020203C64697620636C6173733D22742D416C6572742D77726170223E0D0A202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D69636F6E223E0D0A20202020202020202020202020202020202020203C7370';
wwv_flow_api.g_varchar2_table(28) := '616E20636C6173733D22742D49636F6E20223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D636F6E74656E74223E0D0A20';
wwv_flow_api.g_varchar2_table(29) := '202020202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D686561646572223E0D0A2020202020202020202020202020202020202020202020203C683220636C6173733D22742D416C6572742D7469746C65222069';
wwv_flow_api.g_varchar2_table(30) := '643D2270726574697573446576656C6F706572546F6F6C5761726E696E675F68656164696E67223E436F6E66696775726174696F6E2050726F626C656D3C2F68323E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A20202020';
wwv_flow_api.g_varchar2_table(31) := '202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D626F6479223E5072657469757320446576656C6F70657220546F6F6C206973206120706C7567696E2074686174206578706F736573206D616E79204150455820';
wwv_flow_api.g_varchar2_table(32) := '76616C75657320666F72207468650D0A20202020202020202020202020202020202020202020202062656E65666974206F662074686520446576656C6F7065722E3C62723E0D0A2020202020202020202020202020202020202020202020205768696C73';
wwv_flow_api.g_varchar2_table(33) := '742074686520506C7567696E206973206F6E6C792061637469766174656420776869736C742074686520446576656C6F706572204261722069732070726573656E742C207468657265206D617920626520776179730D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '202020202020202020202074686174206120637572696F757320656E642D7573657220636F756C6420656E61626C6520746865204465766C6F70657220546F6F6C2074687573206578706F73696E67206170706C69636174696F6E206C6F6769632E3C62';
wwv_flow_api.g_varchar2_table(35) := '723E0D0A202020202020202020202020202020202020202020202020546F2061747461696E2074686520686967686573742073656375726974792C20697420697320686967686C79207265636F6D6D656E64656420746861743A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(36) := '202020202020202020202020202020203C756C3E0D0A202020202020202020202020202020202020202020202020202020203C6C693E596F752068617665206F6E6520616E64206F6E6C79206F6E65205072657469757320446576656C6F70657220546F';
wwv_flow_api.g_varchar2_table(37) := '6F6C2044796E616D6963205472756520416374696F6E206F6E2050616765205A65726F3C2F6C693E0D0A202020202020202020202020202020202020202020202020202020203C6C693E5468652044796E616D696320416374696F6E206973206173736F';
wwv_flow_api.g_varchar2_table(38) := '63696174656420776974682061203C6120687265663D2268747470733A2F2F7777772E796F75747562652E636F6D2F77617463683F763D584F4C437248535252724D26743D38347322207461726765743D225F626C616E6B223E4275696C64204F707469';
wwv_flow_api.g_varchar2_table(39) := '6F6E20746861742069732073657420746F204578636C756465206F6E204578706F72743C2F613E0D0A202020202020202020202020202020202020202020202020202020203C2F6C693E0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '3C2F756C3E0D0A2020202020202020202020202020202020202020202020205768696C73742074686520506C7567696E2077696C6C207374696C6C20636F6E74696E756520746F2066756E6374696F6E2C2074686973206D6573736167652077696C6C20';
wwv_flow_api.g_varchar2_table(41) := '6E616720796F7520756E74696C20796F752074616B65207468650D0A202020202020202020202020202020202020202020202020616374696F6E206465736372696265642061626F76652E0D0A20202020202020202020202020202020202020203C2F64';
wwv_flow_api.g_varchar2_table(42) := '69763E0D0A202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C64697620636C6173733D22742D416C6572742D627574746F6E73223E3C2F6469763E0D0A2020202020202020202020203C2F6469763E';
wwv_flow_api.g_varchar2_table(43) := '0D0A20202020202020203C2F6469763E0D0A202020203C2F6469763E0D0A3C2F6469763E0D0A3C7020636C6173733D226D617267696E2D626F74746F6D2D736D206F70744F75745465787422207374796C653D22666F6E742D73697A653A20736D616C6C';
wwv_flow_api.g_varchar2_table(44) := '65723B223E446F6E27742077616E7420746F20757365205072657469757320446576656C6F70657220546F6F6C3F203C6120687265663D226A6176617363726970743A766F69642830292220636C6173733D226F70744F75744C696E6B223E4F70742D4F';
wwv_flow_api.g_varchar2_table(45) := '75743C2F613E20686572653C2F703E0D0A3C64697620636C6173733D22726F77223E0D0A202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A20202020202020203C6469762069643D22707265';
wwv_flow_api.g_varchar2_table(46) := '74697573446576656C6F706572546F6F6C4F7074696F6E73223E0D0A2020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A';
wwv_flow_api.g_varchar2_table(47) := '20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567';
wwv_flow_api.g_varchar2_table(48) := '696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67220D0A2020202020202020202020202020202020202020202020202020202069643D2270726574697573446576656C6F706572546F6F6C4F';
wwv_flow_api.g_varchar2_table(49) := '7074696F6E7352657665616C6572223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D686561646572223E0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '2020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D7469746C65223E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '2020202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49636F6E20220D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '20202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C683220636C6173733D22742D526567696F6E';
wwv_flow_api.g_varchar2_table(53) := '2D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E7352657665616C65725F68656164696E67223E52657665616C65720D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '2020203C2F68323E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D52656769';
wwv_flow_api.g_varchar2_table(55) := '6F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D627574746F6E73223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22';
wwv_flow_api.g_varchar2_table(56) := '6A732D6D6178696D697A65427574746F6E436F6E7461696E6572223E3C2F7370616E3E3C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(57) := '202020202020203C64697620636C6173733D22742D526567696F6E2D626F647957726170223E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E73';
wwv_flow_api.g_varchar2_table(58) := '20742D526567696F6E2D627574746F6E732D2D746F70223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F64';
wwv_flow_api.g_varchar2_table(59) := '69763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(60) := '20202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F6479223E0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(61) := '202020202020202020202020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C696E70757420747970653D22';
wwv_flow_api.g_varchar2_table(62) := '68696464656E222069643D2252305F4F50545F4F555422206E616D653D2252305F4F50545F4F5554222076616C75653D224E223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C6469762063';
wwv_flow_api.g_varchar2_table(63) := '6C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A202020';
wwv_flow_api.g_varchar2_table(64) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D777261';
wwv_flow_api.g_varchar2_table(65) := '7070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52455645414C45';
wwv_flow_api.g_varchar2_table(66) := '525F454E41424C455F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F';
wwv_flow_api.g_varchar2_table(67) := '6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52455645414C4552';
wwv_flow_api.g_varchar2_table(68) := '5F454E41424C45222069643D2252305F52455645414C45525F454E41424C455F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(69) := '636C6173733D22742D466F726D2D6C6162656C223E456E61626C653C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020';
wwv_flow_api.g_varchar2_table(70) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020';
wwv_flow_api.g_varchar2_table(71) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D53';
wwv_flow_api.g_varchar2_table(72) := '7769746368223E3C696E7075740D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069';
wwv_flow_api.g_varchar2_table(73) := '643D2252305F52455645414C45525F454E41424C45220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D225230';
wwv_flow_api.g_varchar2_table(74) := '5F52455645414C45525F454E41424C45222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174';
wwv_flow_api.g_varchar2_table(75) := '612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(76) := '20202020646174612D6F66662D6C6162656C3D224F66662220646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '2020202020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(78) := '2020202020202020202020202020202020202020202020202020202020202069643D2252305F52455645414C45525F454E41424C455F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(79) := '20202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F72220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(80) := '20202020202020202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F4554223E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(81) := '202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(82) := '2020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(83) := '20202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C2063';
wwv_flow_api.g_varchar2_table(84) := '6F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461';
wwv_flow_api.g_varchar2_table(85) := '696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(86) := '20202020202020202020202069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E4552223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(87) := '2020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(88) := '2020202020202020202020203C6C6162656C20666F723D2252305F52455645414C45525F43524950504C455F5441424C4F434B220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(89) := '202020202020202020202020202069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B5F4C4142454C220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(90) := '2020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E44656163746976617465203C6120687265663D2268747470733A2F2F6269742E6C792F415045585461624C6F636B22207461726765743D225F626C616E6B223E54';
wwv_flow_api.g_varchar2_table(91) := '61626C6F636B3C2F613E2052657665616C65723C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(92) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(93) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C';
wwv_flow_api.g_varchar2_table(94) := '696E7075740D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F5245';
wwv_flow_api.g_varchar2_table(95) := '5645414C45525F43524950504C455F5441424C4F434B220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252';
wwv_flow_api.g_varchar2_table(96) := '305F52455645414C45525F43524950504C455F5441424C4F434B222076616C75653D2259220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(97) := '20202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(98) := '2020202020202020202020202020646174612D6F66662D6C6162656C3D224F66662220636865636B65643D22636865636B6564220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(99) := '20202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(100) := '2020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(101) := '2020202020202020202020202020202020202020202020202020202069643D2252305F52455645414C45525F43524950504C455F5441424C4F434B5F6572726F725F706C616365686F6C646572220D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(102) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F72220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(103) := '20202020202020202020202020202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F4554223E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(104) := '202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(105) := '2020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(106) := '20202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D';
wwv_flow_api.g_varchar2_table(107) := '22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C';
wwv_flow_api.g_varchar2_table(108) := '64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D746578742D6669656C6420220D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(109) := '2020202020202020202020202020202020202020202069643D2252305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E4552223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(110) := '2020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(111) := '2020202020202020202020202020202020203C6C6162656C20666F723D2252305F52455645414C45525F4B425F53484F5254435554220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(112) := '2020202020202020202020202020202069643D2252305F52455645414C45525F4B425F53484F52544355545F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(113) := '202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E4B6579626F6172642053686F7274637574204374726C2B416C742B2E2E2E3C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(114) := '202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D46';
wwv_flow_api.g_varchar2_table(115) := '6F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22';
wwv_flow_api.g_varchar2_table(116) := '742D466F726D2D6974656D57726170706572223E3C696E70757420747970653D2274657874220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(117) := '2020202069643D2252305F52455645414C45525F4B425F53484F5254435554220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E61';
wwv_flow_api.g_varchar2_table(118) := '6D653D2252305F52455645414C45525F4B425F53484F5254435554220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D';
wwv_flow_api.g_varchar2_table(119) := '22746578745F6669656C6420617065782D6974656D2D74657874222076616C75653D2251222073697A653D2231220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(120) := '2020202020202020202020206D61786C656E6774683D22312220646174612D6E702D636865636B65643D2231223E3C2F6469763E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(121) := '2020202020202020202020202020202020202069643D2252305F52455645414C45525F4B425F53484F52544355545F6572726F725F706C616365686F6C646572220D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(122) := '202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F72220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(123) := '202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F4554223E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(124) := '2020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(125) := '20202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(126) := '2020202020202020203C2F6469763E0D0A0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173';
wwv_flow_api.g_varchar2_table(127) := '733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D5265';
wwv_flow_api.g_varchar2_table(128) := '67696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D7269676874223E3C';
wwv_flow_api.g_varchar2_table(129) := '2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(130) := '202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C212D2D203C2F6469763E0D0A202020202020202020202020202020203C64697620636C61';
wwv_flow_api.g_varchar2_table(131) := '73733D22726F77223E202D2D3E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020203C64';
wwv_flow_api.g_varchar2_table(132) := '697620636C6173733D22742D526567696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67220D0A2020202020202020202020202020202020202020202020202020202069643D22707265746975';
wwv_flow_api.g_varchar2_table(133) := '73446576656C6F706572546F6F6C4F7074696F6E7352656C6F61644672616D65223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D686561646572223E0D0A2020202020';
wwv_flow_api.g_varchar2_table(134) := '2020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D7469746C65223E0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(135) := '2020202020202020202020202020202020202020202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49636F6E20220D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(136) := '20202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C';
wwv_flow_api.g_varchar2_table(137) := '683220636C6173733D22742D526567696F6E2D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E7352656C6F61644672616D655F68656164696E67223E0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(138) := '202020202020202020202020202020202020202052656C6F6164204672616D653C2F68323E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(139) := '20202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D627574746F6E73223E3C7370616E0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(140) := '20202020202020202020202020202020202020202020636C6173733D226A732D6D6178696D697A65427574746F6E436F6E7461696E6572223E3C2F7370616E3E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(141) := '3C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F647957726170223E0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(142) := '203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D746F70223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173';
wwv_flow_api.g_varchar2_table(143) := '733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D72';
wwv_flow_api.g_varchar2_table(144) := '69676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D';
wwv_flow_api.g_varchar2_table(145) := '526567696F6E2D626F6479223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(146) := '202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D31';
wwv_flow_api.g_varchar2_table(147) := '3220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(148) := '2072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(149) := '202020202020202069643D2252305F52454C4F41445F454E41424C455F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6469762063';
wwv_flow_api.g_varchar2_table(150) := '6C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C61';
wwv_flow_api.g_varchar2_table(151) := '62656C20666F723D2252305F52454C4F41445F454E41424C45222069643D2252305F52454C4F41445F454E41424C455F4C4142454C220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(152) := '20202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E456E61626C653C2F6C6162656C3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(153) := '20202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E65722063';
wwv_flow_api.g_varchar2_table(154) := '6F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E';
wwv_flow_api.g_varchar2_table(155) := '3C7370616E20636C6173733D22612D537769746368223E3C696E7075740D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(156) := '7970653D22636865636B626F78222069643D2252305F52454C4F41445F454E41424C45220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(157) := '2020202020206E616D653D2252305F52454C4F41445F454E41424C45222076616C75653D22592220646174612D6F6E2D6C6162656C3D224F6E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(158) := '20202020202020202020202020202020202020202020202020202020646174612D6F66662D76616C75653D224E2220646174612D6F66662D6C6162656C3D224F6666220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(159) := '20202020202020202020202020202020202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(160) := '2020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E3C7370616E0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(161) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F454E41424C455F6572726F725F706C616365686F6C6465722220636C6173733D22612D466F726D2D657272';
wwv_flow_api.g_varchar2_table(162) := '6F72220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F';
wwv_flow_api.g_varchar2_table(163) := '4554223E3C2F7370616E3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(164) := '2020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(165) := '2020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(166) := '20202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(167) := '20202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D79';
wwv_flow_api.g_varchar2_table(168) := '65732D6E6F20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E4552';
wwv_flow_api.g_varchar2_table(169) := '22207374796C653D22646973706C61793A6E6F6E65223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C616265';
wwv_flow_api.g_varchar2_table(170) := '6C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F52454C4F41';
wwv_flow_api.g_varchar2_table(171) := '445F444556454C4F504552535F4F4E4C59220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F444556454C4F';
wwv_flow_api.g_varchar2_table(172) := '504552535F4F4E4C595F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E44';
wwv_flow_api.g_varchar2_table(173) := '6576656C6F70657273204F6E6C793C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(174) := '2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(175) := '2020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E707574';
wwv_flow_api.g_varchar2_table(176) := '0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F52454C4F41445F';
wwv_flow_api.g_varchar2_table(177) := '444556454C4F504552535F4F4E4C59220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252305F52454C4F41';
wwv_flow_api.g_varchar2_table(178) := '445F444556454C4F504552535F4F4E4C59222076616C75653D2259220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206461';
wwv_flow_api.g_varchar2_table(179) := '74612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(180) := '2020202020646174612D6F66662D6C6162656C3D224F66662220636865636B65643D22636865636B6564220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(181) := '20202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(182) := '2020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E3C7370616E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(183) := '2020202020202020202020202020202020202069643D2252305F52454C4F41445F444556454C4F504552535F4F4E4C595F6572726F725F706C616365686F6C646572220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(184) := '2020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F72220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(185) := '2020202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F4554223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(186) := '20202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(187) := '202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(188) := '2020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3132';
wwv_flow_api.g_varchar2_table(189) := '20617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E657220';
wwv_flow_api.g_varchar2_table(190) := '72656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(191) := '2020202020202069643D2252305F52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E4552223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(192) := '2020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(193) := '2020202020203C6C6162656C20666F723D2252305F52454C4F41445F4259504153535F554E4348414E474544220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(194) := '2020202020202069643D2252305F52454C4F41445F4259504153535F554E4348414E4745445F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(195) := '202020202020636C6173733D22742D466F726D2D6C6162656C223E427970617373205761726E206F6E20556E6368616E6765640D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(196) := '202020202020202020202020204368616E6765733C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(197) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(198) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E';
wwv_flow_api.g_varchar2_table(199) := '3C696E7075740D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22636865636B626F78222069643D2252305F52';
wwv_flow_api.g_varchar2_table(200) := '454C4F41445F4259504153535F554E4348414E474544220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206E616D653D2252';
wwv_flow_api.g_varchar2_table(201) := '305F52454C4F41445F4259504153535F554E4348414E474544222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(202) := '202020202020646174612D6F6E2D6C6162656C3D224F6E2220646174612D6F66662D76616C75653D224E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(203) := '20202020202020202020202020646174612D6F66662D6C6162656C3D224F66662220636865636B65643D22636865636B6564220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(204) := '202020202020202020202020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(205) := '20202020202020202020202020202020636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E3C2F6469763E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(206) := '20202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4259504153535F554E4348414E4745445F6572726F725F706C616365686F6C646572220D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(207) := '2020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F72220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(208) := '2020202020202020202020202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F4554223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(209) := '20202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(210) := '202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(211) := '2020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D2263';
wwv_flow_api.g_varchar2_table(212) := '6F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6669656C6443';
wwv_flow_api.g_varchar2_table(213) := '6F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D746578742D6669656C6420220D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(214) := '202020202020202020202020202020202020202069643D2252305F52454C4F41445F4B425F53484F52544355545F434F4E5441494E4552223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(215) := '20202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(216) := '20202020202020202020202020203C6C6162656C20666F723D2252305F52454C4F41445F4B425F53484F5254435554220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(217) := '2020202020202020202069643D2252305F52454C4F41445F4B425F53484F52544355545F4C4142454C220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(218) := '20202020636C6173733D22742D466F726D2D6C6162656C223E4B6579626F6172642053686F7274637574204374726C2B416C742B2E2E2E3C2F6C6162656C3E0D0A2020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(219) := '20202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E7075';
wwv_flow_api.g_varchar2_table(220) := '74436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D69';
wwv_flow_api.g_varchar2_table(221) := '74656D57726170706572223E3C696E70757420747970653D2274657874220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D22';
wwv_flow_api.g_varchar2_table(222) := '52305F52454C4F41445F4B425F53484F525443555422206E616D653D2252305F52454C4F41445F4B425F53484F5254435554220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(223) := '2020202020202020202020202020202020636C6173733D22746578745F6669656C6420617065782D6974656D2D74657874222076616C75653D2252222073697A653D2231220D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(224) := '20202020202020202020202020202020202020202020202020202020202020202020206D61786C656E6774683D22312220646174612D6E702D636865636B65643D2231223E3C2F6469763E3C7370616E0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(225) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F52454C4F41445F4B425F53484F52544355545F6572726F725F706C616365686F6C646572220D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(226) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22612D466F726D2D6572726F72220D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(227) := '202020202020202020202020202020202020202020202020202020202020646174612D74656D706C6174652D69643D22343332303830343937393430343639325F4554223E3C2F7370616E3E0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(228) := '2020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020';
wwv_flow_api.g_varchar2_table(229) := '20202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020';
wwv_flow_api.g_varchar2_table(230) := '2020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(231) := '2020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(232) := '20202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D5265';
wwv_flow_api.g_varchar2_table(233) := '67696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C2F6469';
wwv_flow_api.g_varchar2_table(234) := '763E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F6469763E0D0A0D0A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(235) := '20202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D3620223E0D0A2020202020202020202020202020202020202020202020203C6469';
wwv_flow_api.g_varchar2_table(236) := '7620636C6173733D22742D526567696F6E20742D526567696F6E2D2D7363726F6C6C426F647920742D466F726D2D2D736C696D50616464696E67222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E734275696C644F707469';
wwv_flow_api.g_varchar2_table(237) := '6F6E73486967686C69676874223E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D686561646572223E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(238) := '202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D7469746C65223E0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(239) := '202020202020203C7370616E20636C6173733D22742D526567696F6E2D68656164657249636F6E223E3C7370616E20636C6173733D22742D49636F6E202220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F7370616E3E0D0A2020';
wwv_flow_api.g_varchar2_table(240) := '202020202020202020202020202020202020202020202020202020202020202020203C683220636C6173733D22742D526567696F6E2D7469746C65222069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E734275696C644F7074';
wwv_flow_api.g_varchar2_table(241) := '696F6E73486967686C696768745F68656164696E67223E4275696C64204F7074696F6E20486967686C696768743C2F68323E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(242) := '2020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D6865616465724974656D7320742D526567696F6E2D6865616465724974656D732D2D627574746F6E73223E3C7370616E0D0A2020202020';
wwv_flow_api.g_varchar2_table(243) := '2020202020202020202020202020202020202020202020202020202020202020202020636C6173733D226A732D6D6178696D697A65427574746F6E436F6E7461696E6572223E3C2F7370616E3E3C2F6469763E0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(244) := '202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D626F647957726170223E0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(245) := '20202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D746F70223E0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(246) := '202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D526567';
wwv_flow_api.g_varchar2_table(247) := '696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C';
wwv_flow_api.g_varchar2_table(248) := '64697620636C6173733D22742D526567696F6E2D626F6479223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22636F6E7461696E6572223E0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(249) := '20202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C61';
wwv_flow_api.g_varchar2_table(250) := '73733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D66';
wwv_flow_api.g_varchar2_table(251) := '69656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D7965732D6E6F20220D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(252) := '20202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F454E41424C455F434F4E5441494E4552223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(253) := '202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(254) := '202020202020202020202020202020203C6C6162656C20666F723D2252305F4255494C445F4F5054494F4E5F454E41424C45222069643D2252305F4255494C445F4F5054494F4E5F454E41424C455F4C4142454C220D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(255) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D6C6162656C223E456E61626C653C2F6C6162656C3E0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(256) := '2020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C646976';
wwv_flow_api.g_varchar2_table(257) := '20636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C';
wwv_flow_api.g_varchar2_table(258) := '64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C7370616E20636C6173733D22612D537769746368223E3C696E70757420747970653D22636865636B626F78220D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(259) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F454E41424C4522206E616D653D2252305F4255494C445F4F5054494F4E5F454E4142';
wwv_flow_api.g_varchar2_table(260) := '4C45222076616C75653D2259220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D6F6E2D6C6162656C3D224F6E';
wwv_flow_api.g_varchar2_table(261) := '2220646174612D6F66662D76616C75653D224E2220646174612D6F66662D6C6162656C3D224F6666220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(262) := '2020202020202020202020646174612D6E702D636865636B65643D2231223E3C7370616E20636C6173733D22612D5377697463682D746F67676C65223E3C2F7370616E3E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(263) := '2020202020202020202020202020202020202020202020202020202020202020203C2F6469763E3C7370616E2069643D2252305F4255494C445F4F5054494F4E5F454E41424C455F6572726F725F706C616365686F6C6465722220636C6173733D22612D';
wwv_flow_api.g_varchar2_table(264) := '466F726D2D6572726F72220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D74656D706C6174652D69643D22223E3C2F7370616E3E';
wwv_flow_api.g_varchar2_table(265) := '0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(266) := '202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(267) := '202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22726F77223E0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(268) := '2020202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(269) := '2020202020202020203C64697620636C6173733D22742D466F726D2D6669656C64436F6E7461696E65722072656C2D636F6C20617065782D6974656D2D7772617070657220617065782D6974656D2D777261707065722D2D6E756D6265722D6669656C64';
wwv_flow_api.g_varchar2_table(270) := '20220D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E4552223E0D0A2020';
wwv_flow_api.g_varchar2_table(271) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6C6162656C436F6E7461696E657220636F6C20636F6C2D38223E0D0A202020';
wwv_flow_api.g_varchar2_table(272) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C6C6162656C20666F723D2252305F4255494C445F4F5054494F4E5F4455524154494F4E222069643D2252305F4255';
wwv_flow_api.g_varchar2_table(273) := '494C445F4F5054494F4E5F4455524154494F4E5F4C4142454C220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F72';
wwv_flow_api.g_varchar2_table(274) := '6D2D6C6162656C223E466164652061667465722078205365636F6E64733C2F6C6162656C3E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20';
wwv_flow_api.g_varchar2_table(275) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D696E707574436F6E7461696E657220636F6C20636F6C2D34223E0D0A2020';
wwv_flow_api.g_varchar2_table(276) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E3C696E70757420747970653D2274';
wwv_flow_api.g_varchar2_table(277) := '657874222069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(278) := '6E616D653D2252305F4255494C445F4F5054494F4E5F4455524154494F4E220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269';
wwv_flow_api.g_varchar2_table(279) := '612D64657363726962656462793D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F696E6C696E655F68656C70220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(280) := '202020202020202020202020202020202020636C6173733D226E756D6265725F6669656C6420617065782D6974656D2D74657874222076616C75653D2236222073697A653D223222206D61786C656E6774683D2232220D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(281) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207374796C653D22746578742D616C69676E3A72696768742220646174612D6E702D636865636B65643D2231223E3C2F64';
wwv_flow_api.g_varchar2_table(282) := '69763E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D466F726D2D696E6C696E6548656C70223E3C737061';
wwv_flow_api.g_varchar2_table(283) := '6E2069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F696E6C696E655F68656C70223E300D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(284) := '2020202020202020202020746F206E657665722066616465206F75743C2F7370616E3E3C2F7370616E3E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(285) := '20202020202020202069643D2252305F4255494C445F4F5054494F4E5F4455524154494F4E5F6572726F725F706C616365686F6C6465722220636C6173733D22612D466F726D2D6572726F72220D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(286) := '202020202020202020202020202020202020202020202020202020202020202020202020202020646174612D74656D706C6174652D69643D22223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(287) := '20202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(288) := '202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(289) := '20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020200D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(290) := '2020202020202020202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E7320742D526567696F6E2D627574746F6E732D2D626F74746F6D223E0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(291) := '20202020202020202020203C64697620636C6173733D22742D526567696F6E2D627574746F6E732D6C656674223E3C2F6469763E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C617373';
wwv_flow_api.g_varchar2_table(292) := '3D22742D526567696F6E2D627574746F6E732D7269676874223E3C2F6469763E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F6469763E0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(293) := '20203C2F6469763E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F6469763E0D0A0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(294) := '20202020202020202020202020203C64697620636C6173733D22726F77223E0D0A20202020202020202020202020202020202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E0D0A20202020202020';
wwv_flow_api.g_varchar2_table(295) := '20202020202020202020202020202020203C6469762069643D2270726574697573446576656C6F706572546F6F6C4F7074696F6E73427574746F6E73223E0D0A202020202020202020202020202020202020202020202020202020203C7461626C652072';
wwv_flow_api.g_varchar2_table(296) := '6F6C653D2270726573656E746174696F6E222063656C6C73706163696E673D2230222063656C6C70616464696E673D22302220626F726465723D2230222077696474683D2231303025223E0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(297) := '2020202020202020203C74626F64793E0D0A2020202020202020202020202020202020202020202020202020202020202020202020203C74723E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(298) := '3C746420616C69676E3D226C656674223E3C627574746F6E20636C6173733D22742D427574746F6E207064742D6F7074696F6E2D627574746F6E2220747970653D22627574746F6E222069643D2252305F43414E43454C223E3C7370616E0D0A20202020';
wwv_flow_api.g_varchar2_table(299) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D427574746F6E2D6C6162656C223E43616E63656C3C2F7370616E3E3C2F627574746F6E3E3C2F74643E0D0A';
wwv_flow_api.g_varchar2_table(300) := '202020202020202020202020202020202020202020202020202020202020202020202020202020203C746420616C69676E3D227269676874223E3C627574746F6E0D0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(301) := '202020202020202020202020202020636C6173733D22742D427574746F6E207064742D6F7074696F6E2D627574746F6E20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D69636F6E526967687420742D427574746F6E2D2D686F7420752D';
wwv_flow_api.g_varchar2_table(302) := '70756C6C5269676874220D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020747970653D22627574746F6E222069643D2252305F53415645223E3C7370616E20636C6173733D22';
wwv_flow_api.g_varchar2_table(303) := '742D49636F6E20742D49636F6E2D2D6C6566742066612066612D73617665220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D227472';
wwv_flow_api.g_varchar2_table(304) := '7565223E3C2F7370616E3E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D427574746F6E2D6C6162656C223E536176653C2F73';
wwv_flow_api.g_varchar2_table(305) := '70616E3E3C7370616E0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D49636F6E20742D49636F6E2D2D72696768742066612066612D736176';
wwv_flow_api.g_varchar2_table(306) := '65220D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F627574746F6E3E3C2F74643E0D0A2020';
wwv_flow_api.g_varchar2_table(307) := '202020202020202020202020202020202020202020202020202020202020202020203C2F74723E0D0A20202020202020202020202020202020202020202020202020202020202020203C2F74626F64793E0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(308) := '20202020202020202020203C2F7461626C653E0D0A2020202020202020202020202020202020202020202020203C2F6469763E0D0A20202020202020202020202020202020202020203C2F6469763E0D0A202020202020202020202020202020203C2F64';
wwv_flow_api.g_varchar2_table(309) := '69763E0D0A2020202020202020202020203C2F6469763E0D0A20202020202020203C2F6469763E0D0A202020203C2F6469763E0D0A3C2F6469763E0D0A0D0A0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135224968869973945)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'pretiusDeveloperTool.html'
,p_mime_type=>'text/html'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0D0A2A20506C7567696E3A202020507265746975732052656C6F6164204672616D650D0A2A2056657273696F6E3A2020312E302E300D0A2A0D0A2A204C6963656E73653A20204D4954204C6963656E736520436F7079726967687420323032322050';
wwv_flow_api.g_varchar2_table(2) := '7265746975732053702E207A206F2E6F2E2053702E204B2E0D0A2A20486F6D65706167653A200D0A2A204D61696C3A2020202020617065782D706C7567696E7340707265746975732E636F6D0D0A2A204973737565733A20202068747470733A2F2F6769';
wwv_flow_api.g_varchar2_table(3) := '746875622E636F6D2F507265746975732F72656C6F61642D6672616D652F6973737565730D0A2A0D0A2A20417574686F723A2020204D617474204D756C76616E65790D0A2A204D61696C3A20202020206D6D756C76616E657940707265746975732E636F';
wwv_flow_api.g_varchar2_table(4) := '6D0D0A2A20547769747465723A20204D6174745F4D756C76616E65790D0A2A0D0A2A2F0D0A0D0A76617220706474203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A202020207661722064613B0D0A20';
wwv_flow_api.g_varchar2_table(5) := '202020766172206F70743B0D0A20202020766172204A534F4E73657474696E67733B0D0A20202020766172207061676544656275674C6576656C3B0D0A0D0A2020202066756E6374696F6E206E766C2876616C7565312C2076616C75653229207B0D0A20';
wwv_flow_api.g_varchar2_table(6) := '202020202020206966202876616C756531203D3D206E756C6C207C7C2076616C756531203D3D202222290D0A20202020202020202020202072657475726E2076616C7565323B0D0A202020202020202072657475726E2076616C7565313B0D0A20202020';
wwv_flow_api.g_varchar2_table(7) := '7D3B0D0A0D0A2020202066756E6374696F6E2067657453657474696E6728705061746829207B0D0A20202020202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F34353332323130310D0A202020202020202066756E';
wwv_flow_api.g_varchar2_table(8) := '6374696F6E207265736F6C766528706174682C206F626A29207B0D0A20202020202020202020202072657475726E20706174682E73706C697428272E27292E7265647563652866756E6374696F6E2028707265762C206375727229207B0D0A2020202020';
wwv_flow_api.g_varchar2_table(9) := '202020202020202020202072657475726E2070726576203F20707265765B637572725D203A206E756C6C0D0A2020202020202020202020207D2C206F626A207C7C2073656C66290D0A20202020202020207D0D0A0D0A202020202020202072657475726E';
wwv_flow_api.g_varchar2_table(10) := '207265736F6C7665282773657474696E67732E27202B2070506174682C0D0A2020202020202020202020207064742E4A534F4E73657474696E6773293B0D0A202020207D0D0A0D0A0D0A2020202066756E6374696F6E20666978546F6F6C626172576964';
wwv_flow_api.g_varchar2_table(11) := '74682829207B0D0A0D0A202020202020202066756E6374696F6E2067657457696E646F7757696474682829207B0D0A20202020202020202020202072657475726E20646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E74576964';
wwv_flow_api.g_varchar2_table(12) := '74683B0D0A20202020202020207D0D0A0D0A2020202020202020766172206F2C20746257696474682C2077696E646F7757696474682C0D0A20202020202020202020202064746224203D202428222361706578446576546F6F6C62617222292C0D0A2020';
wwv_flow_api.g_varchar2_table(13) := '20202020202020202020646972656374696F6E203D20647462242E6373732822646972656374696F6E2229203D3D3D202272746C22203F2022726967687422203A20226C656674223B202F2F207768656E20696E2052544C206D6F64652C20746865206C';
wwv_flow_api.g_varchar2_table(14) := '656674204353532070726F70657274790D0A0D0A20202020202020206F203D207B0D0A20202020202020202020202077696474683A2022220D0A20202020202020207D3B0D0A202020202020202069662028647462242E686173436C6173732822612D44';
wwv_flow_api.g_varchar2_table(15) := '6576546F6F6C6261722D2D746F702229207C7C20647462242E686173436C6173732822612D446576546F6F6C6261722D2D626F74746F6D222929207B0D0A20202020202020202020202077696E646F775769647468203D2067657457696E646F77576964';
wwv_flow_api.g_varchar2_table(16) := '746828293B0D0A2020202020202020202020206F2E77686974655370616365203D20226E6F77726170223B20202F2F20636C65617220656C656D656E7420776964746820746F206765742064657369726564207769647468206F6620756C20636F6E7465';
wwv_flow_api.g_varchar2_table(17) := '6E740D0A202020202020202020202020647462242E637373286F293B0D0A2020202020202020202020202F2F207573696E6720776964746820617373756D696E67206E6F206D617267696E206574632E0D0A202020202020202020202020746257696474';
wwv_flow_api.g_varchar2_table(18) := '68203D20647462242E6368696C6472656E2822756C22295B305D2E636C69656E745769647468202B20343B202F2F2049452077616E7473206A7573742061206C6974746C6520657874726120746F206B6565702074686520627574746F6E732066726F6D';
wwv_flow_api.g_varchar2_table(19) := '207772617070696E670D0A2020202020202020202020206966202874625769647468203E2077696E646F77576964746829207B0D0A2020202020202020202020202020202074625769647468203D2077696E646F7757696474683B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(20) := '20202020207D0D0A2020202020202020202020206F2E77686974655370616365203D202277726170223B0D0A2020202020202020202020206F2E7769647468203D20746257696474683B0D0A2020202020202020202020206F5B646972656374696F6E5D';
wwv_flow_api.g_varchar2_table(21) := '203D202877696E646F775769647468202D207462576964746829202F20323B202F2F20706F736974696F6E20746865206F666673657420696E207468652063656E7465722E0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(22) := '206F5B646972656374696F6E5D203D2022223B202F2F20636C65617220746865206F666673657420616E642077696474680D0A20202020202020207D0D0A2020202020202020647462242E637373286F293B0D0A202020207D0D0A0D0A2020202066756E';
wwv_flow_api.g_varchar2_table(23) := '6374696F6E20616464507265746975734F7074696F6E732829207B0D0A0D0A202020202020202076617220634973546F6F6C62617250726573656E74203D202428222361706578446576546F6F6C62617222292E6C656E677468203E20303B0D0A202020';
wwv_flow_api.g_varchar2_table(24) := '202020202069662028634973546F6F6C62617250726573656E7429207B0D0A0D0A202020202020202020202020696620282428272361706578446576546F6F6C6261724F7074696F6E7327292E6C656E677468203E203020262620242827236170657844';
wwv_flow_api.g_varchar2_table(25) := '6576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7327292E6C656E677468203D3D203029207B0D0A0D0A202020202020202020202020202020207661722072657665616C657249636F6E48746D6C203D20273C7370';
wwv_flow_api.g_varchar2_table(26) := '616E20636C6173733D22612D49636F6E2066612066612D66696C7465722066616D2D782066616D2D69732D64616E6765722220617269612D68696464656E3D2274727565223E3C2F7370616E3E270D0A202020202020202020202020202020200D0A2020';
wwv_flow_api.g_varchar2_table(27) := '202020202020202020202020202069662028207064742E6F70742E636F6E66696775726174696F6E54657374203D3D202274727565222029207B0D0A202020202020202020202020202020202020202072657665616C657249636F6E48746D6C203D2072';
wwv_flow_api.g_varchar2_table(28) := '657665616C657249636F6E48746D6C2E7265706C61636528202766616D2D782066616D2D69732D64616E676572272C20272720293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202428272361706578';
wwv_flow_api.g_varchar2_table(29) := '446576546F6F6C6261724F7074696F6E7327292E706172656E7428292E6166746572280D0A2020202020202020202020202020202020202020617065782E6C616E672E666F726D61744E6F457363617065280D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(30) := '2020202020202020273C6C693E3C627574746F6E2069643D2261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E732220747970653D22627574746F6E2220636C6173733D22612D427574746F6E20612D';
wwv_flow_api.g_varchar2_table(31) := '427574746F6E2D2D646576546F6F6C62617222207469746C653D2256696577205061676520496E666F726D6174696F6E205B6374726C2B616C742B25305D2220617269612D6C6162656C3D22566172732220646174612D6C696E6B3D22223E2027202B0D';
wwv_flow_api.g_varchar2_table(32) := '0A2020202020202020202020202020202020202020202020202725313C7370616E20636C6173733D22612D446576546F6F6C6261722D627574746F6E4C6162656C223E3C2F7370616E3E2027202B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '20202020273C2F627574746F6E3E3C2F6C693E272C0D0A202020202020202020202020202020202020202020202020275072657469757320446576656C6F70657220546F6F6C204F7074696F6E73272C0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '20202020202072657665616C657249636F6E48746D6C0D0A2020202020202020202020202020202020202020290D0A20202020202020202020202020202020293B0D0A0D0A202020202020202020202020202020207661722068203D20646F63756D656E';
wwv_flow_api.g_varchar2_table(35) := '742E676574456C656D656E7442794964282261706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F6E7322293B0D0A20202020202020202020202020202020696620286829207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(36) := '20202020202020202020682E6164644576656E744C697374656E65722822636C69636B222C2066756E6374696F6E20286576656E7429207B0D0A20202020202020202020202020202020202020202020202061706578446576546F6F6C62617250726574';
wwv_flow_api.g_varchar2_table(37) := '697573446576656C6F706572546F6F6C4F7074696F6E7328293B0D0A0D0A20202020202020202020202020202020202020207D2C2074727565293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020207472';
wwv_flow_api.g_varchar2_table(38) := '616E73706C616E74496E6C696E654469616C6F6728293B0D0A0D0A20202020202020202020202020202020666978546F6F6C626172576964746828293B0D0A202020202020202020202020202020202F2F20437573746F6D204150455820352E30207769';
wwv_flow_api.g_varchar2_table(39) := '647468206669780D0A202020202020202020202020202020202428272361706578446576546F6F6C62617227292E7769647468282428272E612D446576546F6F6C6261722D6C69737427292E77696474682829202B2027707827293B0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(40) := '20202020202020202020202066756E6374696F6E207064744F7074696F6E73536176652829207B0D0A2020202020202020202020202020202020202020766172204A736F6E53657474696E6773203D207B0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(41) := '202020202020202273657474696E6773223A207B0D0A20202020202020202020202020202020202020202020202020202020226F70746F7574223A207B0D0A20202020202020202020202020202020202020202020202020202020202020202273746174';
wwv_flow_api.g_varchar2_table(42) := '7573223A20617065782E6974656D282252305F4F50545F4F555422292E67657456616C756528290D0A202020202020202020202020202020202020202020202020202020207D2C0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '202272657665616C6572223A207B0D0A202020202020202020202020202020202020202020202020202020202020202022656E61626C65223A20617065782E6974656D282252305F52455645414C45525F454E41424C4522292E67657456616C75652829';
wwv_flow_api.g_varchar2_table(44) := '2C0D0A2020202020202020202020202020202020202020202020202020202020202020227461626C6F636B64656163746976617465223A20617065782E6974656D282252305F52455645414C45525F43524950504C455F5441424C4F434B22292E676574';
wwv_flow_api.g_varchar2_table(45) := '56616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020226B62223A20617065782E6974656D282252305F52455645414C45525F4B425F53484F525443555422292E67657456616C756528290D0A202020';
wwv_flow_api.g_varchar2_table(46) := '202020202020202020202020202020202020202020202020207D2C0D0A202020202020202020202020202020202020202020202020202020202272656C6F61646672616D65223A207B0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(47) := '2020202020202022656E61626C65223A20617065782E6974656D282252305F52454C4F41445F454E41424C4522292E67657456616C756528292C0D0A202020202020202020202020202020202020202020202020202020202020202022646576656C6F70';
wwv_flow_api.g_varchar2_table(48) := '6572736F6E6C79223A20617065782E6974656D282252305F52454C4F41445F444556454C4F504552535F4F4E4C5922292E67657456616C756528292C0D0A2020202020202020202020202020202020202020202020202020202020202020226279706173';
wwv_flow_api.g_varchar2_table(49) := '737761726E6F6E756E7361766564223A20617065782E6974656D282252305F52454C4F41445F4259504153535F554E4348414E47454422292E67657456616C756528292C0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '2020226B62223A20617065782E6974656D282252305F52454C4F41445F4B425F53484F525443555422292E67657456616C756528290D0A202020202020202020202020202020202020202020202020202020207D0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '20202020202020202020202020202C0D0A20202020202020202020202020202020202020202020202020202020226275696C646F7074696F6E68696768746C69676874223A207B0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '202020202022656E61626C65223A20617065782E6974656D282252305F4255494C445F4F5054494F4E5F454E41424C4522292E67657456616C756528292C0D0A202020202020202020202020202020202020202020202020202020202020202022647572';
wwv_flow_api.g_varchar2_table(53) := '6174696F6E223A20617065782E6974656D282252305F4255494C445F4F5054494F4E5F4455524154494F4E22292E67657456616C756528290D0A202020202020202020202020202020202020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '202020202020202020202020207D0D0A20202020202020202020202020202020202020207D3B0D0A0D0A20202020202020202020202020202020202020206C6F63616C53746F726167652E7365744974656D282270726574697573446576656C6F706572';
wwv_flow_api.g_varchar2_table(55) := '546F6F6C222C204A534F4E2E737472696E67696679284A736F6E53657474696E677329293B0D0A20202020202020202020202020202020202020207064742E4A534F4E73657474696E6773203D204A736F6E53657474696E67733B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(56) := '20202020202020202020202020617065782E7468656D652E636C6F7365526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A2020202020202020202020202020202020202020617065782E6D6573736167652E';
wwv_flow_api.g_varchar2_table(57) := '73686F775061676553756363657373282253657474696E67732073617665642E205265667265736820796F75722062726F777365722E22293B2020202020200D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(58) := '2020242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C20222E6F70744F75744C696E6B222C2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020202020617065782E6D6573';
wwv_flow_api.g_varchar2_table(59) := '736167652E636F6E6669726D2820224279204F7074696E672D4F7574206F66205072657469757320446576656C6F70657220546F6F6C2C20796F752077696C6C206E6F206C6F6E6720686176652061636365737320746F2074686520706C75672D696E20';
wwv_flow_api.g_varchar2_table(60) := '6665617475726573206F7220746869732073657474696E677320706167652E5C6E5C6E596F752063616E2072656761696E2061636365737320627920747970696E672074686520666F6C6C6F77696E6720696E20746F207468652042726F777365722043';
wwv_flow_api.g_varchar2_table(61) := '6F6E736F6C65205C6E5C6E7064742E6F7074496E28293B5C6E5C6E596F752063616E2066696E64207468697320636F6D6D616E6420616761696E206F6E206F75722047697448756220506C7567696E20506167655C6E5C6E41726520796F752073757265';
wwv_flow_api.g_varchar2_table(62) := '20796F75207769736820746F20636F6E74696E75653F222C2066756E6374696F6E28206F6B507265737365642029207B0D0A202020202020202020202020202020202020202020202020696628206F6B507265737365642029207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(63) := '202020202020202020202020202020202020202020617065782E6974656D282252305F4F50545F4F555422292E73657456616C756528225922293B0D0A202020202020202020202020202020202020202020202020202020207064744F7074696F6E7353';
wwv_flow_api.g_varchar2_table(64) := '61766528293B0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202024';
wwv_flow_api.g_varchar2_table(65) := '2822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C20222352305F53415645222C2066756E6374696F6E202829207B0D0A20202020202020202020202020202020202020207064744F7074696F6E7353617665';
wwv_flow_api.g_varchar2_table(66) := '28293B0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E2822636C69636B222C20222352305F43414E43454C222C206675';
wwv_flow_api.g_varchar2_table(67) := '6E6374696F6E202829207B0D0A2020202020202020202020202020202020202020617065782E7468656D652E636C6F7365526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(68) := '2020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C20222352305F52455645414C45525F454E41424C45222C2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(69) := '29207B0D0A0D0A202020202020202020202020202020202020202069662028206E766C2820617065782E6974656D282752305F52455645414C45525F454E41424C4527292E67657456616C756528292C20274E272029203D3D20274E2729207B0D0A2020';
wwv_flow_api.g_varchar2_table(70) := '20202020202020202020202020202020202020202020617065782E6974656D282752305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E455227292E64697361626C6528293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(71) := '202020202020202020617065782E6974656D282752305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020207D20656C7365207B0D0A2020';
wwv_flow_api.g_varchar2_table(72) := '20202020202020202020202020202020202020202020617065782E6974656D282752305F52455645414C45525F43524950504C455F5441424C4F434B5F434F4E5441494E455227292E656E61626C6528293B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(73) := '2020202020202020617065782E6974656D282752305F52455645414C45525F4B425F53484F52544355545F434F4E5441494E455227292E656E61626C6528293B0D0A20202020202020202020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(74) := '20202020207D293B0D0A0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E6522292E6F6E28226368616E6765222C20222352305F52454C4F41445F454E41424C45222C2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(75) := '29207B0D0A0D0A202020202020202020202020202020202020202069662028206E766C2820617065782E6974656D282752305F52454C4F41445F454E41424C4527292E67657456616C756528292C20274E272029203D3D20274E2729207B0D0A20202020';
wwv_flow_api.g_varchar2_table(76) := '2020202020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '2020202020617065782E6974656D282752305F52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E455227292E64697361626C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D';
wwv_flow_api.g_varchar2_table(78) := '282752305F52454C4F41445F4B425F53484F52544355545F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(79) := '2020617065782E6974656D282752305F52454C4F41445F444556454C4F504552535F4F4E4C595F434F4E5441494E455227292E656E61626C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F';
wwv_flow_api.g_varchar2_table(80) := '52454C4F41445F4259504153535F554E4348414E4745445F434F4E5441494E455227292E656E61626C6528293B0D0A202020202020202020202020202020202020202020202020617065782E6974656D282752305F52454C4F41445F4B425F53484F5254';
wwv_flow_api.g_varchar2_table(81) := '4355545F434F4E5441494E455227292E656E61626C6528293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D293B0D0A0D0A202020202020202020202020202020202428222370726574697573';
wwv_flow_api.g_varchar2_table(82) := '52657665616C6572496E6C696E6522292E6F6E28226368616E6765222C20222352305F4255494C445F4F5054494F4E5F454E41424C45222C2066756E6374696F6E202829207B0D0A0D0A202020202020202020202020202020202020202069662028206E';
wwv_flow_api.g_varchar2_table(83) := '766C2820617065782E6974656D282752305F4255494C445F4F5054494F4E5F454E41424C4527292E67657456616C756528292C20274E272029203D3D20274E2729207B0D0A20202020202020202020202020202020202020202020202020617065782E69';
wwv_flow_api.g_varchar2_table(84) := '74656D282752305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E455227292E64697361626C6528293B0D0A20202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(85) := '2020202020202020617065782E6974656D282752305F4255494C445F4F5054494F4E5F4455524154494F4E5F434F4E5441494E455227292E656E61626C6528293B0D0A20202020202020202020202020202020202020207D0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(86) := '2020202020207D293B0D0A0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202066756E6374696F6E2061706578446576546F6F6C62617250726574697573446576656C6F706572546F6F6C4F7074696F';
wwv_flow_api.g_varchar2_table(87) := '6E7328704D6F646529207B0D0A0D0A2020202020202020617065782E7468656D652E6F70656E526567696F6E28242827237072657469757352657665616C6572496E6C696E652729293B0D0A202020202020202024282223707265746975735265766561';
wwv_flow_api.g_varchar2_table(88) := '6C6572496E6C696E65202E742D4469616C6F67526567696F6E2D626F647922292E6C6F6164287064742E6F70742E66696C65507265666978202B202270726574697573446576656C6F706572546F6F6C2E68746D6C22293B0D0A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(89) := '242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E656D70747928293B0D0A20202020202020202428272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E75692D';
wwv_flow_api.g_varchar2_table(90) := '6469616C6F672D7469746C6527292E746578742827205072657469757320446576656C6F70657220546F6F6C3A204F7074696F6E7327293B0D0A20202020202020202F2F2073656E644D6F64616C4D65737361676528293B0D0A0D0A202020207D0D0A0D';
wwv_flow_api.g_varchar2_table(91) := '0A2020202066756E6374696F6E207472616E73706C616E74496E6C696E654469616C6F672829207B0D0A0D0A2020202020202020766172207072657469757352657665616C6572466F6F746572203D0D0A202020202020202020202020273C6469762063';
wwv_flow_api.g_varchar2_table(92) := '6C6173733D227072657469757352657665616C6572466F6F746572223E27202B0D0A202020202020202020202020273C6120636C6173733D227072657469757352657665616C65724C696E6B2070726574697573466F6F7465724F7074696F6E73222068';
wwv_flow_api.g_varchar2_table(93) := '7265663D2268747470733A2F2F707265746975732E636F6D2F6D61696E2F22207461726765743D225F626C616E6B223E507265746975733C2F613E27202B0D0A202020202020202020202020273C6120636C6173733D227072657469757352657665616C';
wwv_flow_api.g_varchar2_table(94) := '65724C696E6B2220687265663D2268747470733A2F2F747769747465722E636F6D2F4D6174745F4D756C76616E657922207461726765743D225F626C616E6B223E404D6174745F4D756C76616E6579203C2F613E27202B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(95) := '20273C6120636C6173733D227072657469757352657665616C65724C696E6B2220687265663D2268747470733A2F2F747769747465722E636F6D2F50726574697573536F66747761726522207461726765743D225F626C616E6B223E4050726574697573';
wwv_flow_api.g_varchar2_table(96) := '536F6674776172653C2F613E27202B0D0A202020202020202020202020273C64697620636C6173733D22707265746975735461626C6F636B56657273696F6E223E3C2F6469763E27202B0D0A202020202020202020202020273C2F6469763E273B0D0A0D';
wwv_flow_api.g_varchar2_table(97) := '0A20202020202020202F2F2049662074686520706167652054656D706C61746520446F65736E7420737570706F727420496E6C696E65204469616C6F67732C206C696B65207061676520393939392C20616464206120636865656B79206469760D0A2020';
wwv_flow_api.g_varchar2_table(98) := '202020202020696620282428272E742D426F64792D696E6C696E654469616C6F677327292E6C656E677468203D3D203029207B0D0A2020202020202020202020202428272361706578446576546F6F6C62617227292E70726570656E6428273C64697620';
wwv_flow_api.g_varchar2_table(99) := '636C6173733D22742D426F64792D696E6C696E654469616C6F6773223E3C2F6469763E27293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F204F6E6C7920637265617465206120636F6E7461696E657220696620746865726520617265';
wwv_flow_api.g_varchar2_table(100) := '206E6F206F7468657220696E6C696E65206469616C6F6773206F6E2074686520706167650D0A2020202020202020696620282428272E742D426F64792D696E6C696E654469616C6F6773202E636F6E7461696E657227292E6C656E677468203D3D203029';
wwv_flow_api.g_varchar2_table(101) := '207B0D0A2020202020202020202020202428272E742D426F64792D696E6C696E654469616C6F677327292E617070656E6428273C64697620636C6173733D22636F6E7461696E6572223E3C2F6469763E27293B0D0A20202020202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(102) := '2020202020202F2F20576861636B206120776164206F662048544D4C20696E2074686520636F6E7461696E65720D0A20202020202020202428272E742D426F64792D696E6C696E654469616C6F6773202E636F6E7461696E657227292E617070656E6428';
wwv_flow_api.g_varchar2_table(103) := '0D0A20202020202020202020202027202020203C64697620636C6173733D22726F77223E2027202B0D0A20202020202020202020202027202020203C64697620636C6173733D22636F6C20636F6C2D313220617065782D636F6C2D6175746F223E202720';
wwv_flow_api.g_varchar2_table(104) := '2B0D0A2020202020202020202020202720202020202020203C6469762069643D227072657469757352657665616C6572496E6C696E655F706172656E74223E2027202B0D0A202020202020202020202020272020202020202020202020203C6469762069';
wwv_flow_api.g_varchar2_table(105) := '643D227072657469757352657665616C6572496E6C696E65222027202B0D0A2020202020202020202020202720202020202020202020202020202020636C6173733D22742D4469616C6F67526567696F6E206A732D6D6F64616C206A732D6469616C6F67';
wwv_flow_api.g_varchar2_table(106) := '2D6E6F4F7665726C6179206A732D647261676761626C65206A732D726573697A61626C65206A732D6469616C6F672D6175746F686569676874206A732D6469616C6F672D73697A6536303078343030206A732D726567696F6E4469616C6F67222027202B';
wwv_flow_api.g_varchar2_table(107) := '0D0A20202020202020202020202027202020202020202020202020202020207374796C653D22646973706C61793A6E6F6E6522207469746C653D22205072657469757320446576656C6F70657220546F6F6C3A2052657665616C6572223E2027202B0D0A';
wwv_flow_api.g_varchar2_table(108) := '20202020202020202020202027202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D77726170223E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(109) := '203C64697620636C6173733D22742D4469616C6F67526567696F6E2D626F6479577261707065724F7574223E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020203C64697620636C6173733D2274';
wwv_flow_api.g_varchar2_table(110) := '2D4469616C6F67526567696F6E2D626F647957726170706572496E223E2027202B0D0A20202020202020202020202027202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F6752656769';
wwv_flow_api.g_varchar2_table(111) := '6F6E2D626F6479223E3C2F6469763E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A202020202020202020202020272020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(112) := '2020203C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020203C64697620636C6173733D22742D4469616C6F67526567696F6E2D627574746F6E73223E2027202B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(113) := '2020272020202020202020202020202020202020202020202020203C6469762069643D227072657469757352657665616C6572427574746F6E526567696F6E2220636C6173733D22742D427574746F6E526567696F6E20742D427574746F6E526567696F';
wwv_flow_api.g_varchar2_table(114) := '6E2D2D6469616C6F67526567696F6E22207374796C653D22646973706C61793A6E6F6E65223E2027202B0D0A20202020202020202020202027202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D42';
wwv_flow_api.g_varchar2_table(115) := '7574746F6E526567696F6E2D77726170223E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D636F6C20';
wwv_flow_api.g_varchar2_table(116) := '742D427574746F6E526567696F6E2D636F6C2D2D6C656674223E2027202B0D0A202020202020202020202020272020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F';
wwv_flow_api.g_varchar2_table(117) := '6E526567696F6E2D627574746F6E73223E3C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A2020202020202020202020202720';
wwv_flow_api.g_varchar2_table(118) := '202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D636F6C20742D427574746F6E526567696F6E2D636F6C2D2D7269676874223E2027202B0D0A2020202020';
wwv_flow_api.g_varchar2_table(119) := '20202020202020272020202020202020202020202020202020202020202020202020202020202020202020203C64697620636C6173733D22742D427574746F6E526567696F6E2D627574746F6E73223E3C2F6469763E2027202B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(120) := '202020202720202020202020202020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A20202020202020202020202027202020202020202020202020202020202020202020202020202020203C2F6469763E2027202B';
wwv_flow_api.g_varchar2_table(121) := '0D0A202020202020202020202020272020202020202020202020202020202020202020202020203C2F6469763E2027202B0D0A2020202020202020202020202720202020202020202020202020202020202020203C2F6469763E2027202B0D0A20202020';
wwv_flow_api.g_varchar2_table(122) := '202020202020202027202020202020202020202020202020203C2F6469763E2027202B0D0A202020202020202020202020272020202020202020202020203C2F6469763E2027202B0D0A2020202020202020202020202720202020202020203C2F646976';
wwv_flow_api.g_varchar2_table(123) := '3E2027202B0D0A20202020202020202020202027202020203C2F6469763E2027202B0D0A202020202020202020202020273C2F6469763E20270D0A2020202020202020293B0D0A0D0A20202020202020207661722076696577706F72745769647468203D';
wwv_flow_api.g_varchar2_table(124) := '2077696E646F772E696E6E65725769647468202D2032303B0D0A20202020202020207661722076696577706F7274486569676874203D2077696E646F772E696E6E6572486569676874202D2032303B0D0A20202020202020206966202876696577706F72';
wwv_flow_api.g_varchar2_table(125) := '745769647468203E2031303030292076696577706F72745769647468203D20313030303B0D0A20202020202020206966202876696577706F7274486569676874203E20363530292076696577706F7274486569676874203D203635303B0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(126) := '2020202020242822237072657469757352657665616C6572496E6C696E6522292E656163682866756E6374696F6E202829207B0D0A20202020202020202020202076617220696E737424203D20242874686973292C0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(127) := '2020206973506F707570203D20696E7374242E686173436C61737328226A732D726567696F6E506F70757022292C0D0A2020202020202020202020202020202073697A65203D205B226A732D6469616C6F672D73697A6536303078343030222C20766965';
wwv_flow_api.g_varchar2_table(128) := '77706F727457696474682C2076696577706F72744865696768745D2C0D0A2020202020202020202020202020202072656C506F73203D202F6A732D706F7075702D706F732D285C772B292F2E6578656328746869732E636C6173734E616D65292C0D0A20';
wwv_flow_api.g_varchar2_table(129) := '202020202020202020202020202020706172656E74203D20696E7374242E617474722822646174612D706172656E742D656C656D656E7422292C0D0A202020202020202020202020202020206F7074696F6E73203D207B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(130) := '2020202020202020206175746F4F70656E3A2066616C73652C0D0A2020202020202020202020202020202020202020636F6C6C61707365456E61626C65643A20747275652C0D0A20202020202020202020202020202020202020206E6F4F7665726C6179';
wwv_flow_api.g_varchar2_table(131) := '3A20696E7374242E686173436C61737328226A732D706F7075702D6E6F4F7665726C617922292C0D0A2020202020202020202020202020202020202020636C6F7365546578743A20617065782E6C616E672E6765744D6573736167652822415045582E44';
wwv_flow_api.g_varchar2_table(132) := '49414C4F472E434C4F534522292C0D0A20202020202020202020202020202020202020206D6F64616C3A206973506F707570207C7C20696E7374242E686173436C61737328226A732D6D6F64616C22292C0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(133) := '202020726573697A61626C653A206973506F707570203F2066616C7365203A20696E7374242E686173436C61737328226A732D726573697A61626C6522292C0D0A2020202020202020202020202020202020202020647261676761626C653A206973506F';
wwv_flow_api.g_varchar2_table(134) := '707570203F2066616C7365203A20696E7374242E686173436C61737328226A732D647261676761626C6522292C0D0A20202020202020202020202020202020202020206469616C6F67436C6173733A202775692D6469616C6F672D2D696E6C696E652070';
wwv_flow_api.g_varchar2_table(135) := '72657469757352657665616C6572496E6C696E65546F546865546F70272C0D0A20202020202020202020202020202020202020206F70656E3A2066756E6374696F6E20286429207B0D0A2020202020202020202020202020202020202020202020202428';
wwv_flow_api.g_varchar2_table(136) := '272E7072657469757352657665616C6572496E6C696E65546F546865546F70202E70726574697573436F6D707265737342746E27292E73686F7728293B0D0A2020202020202020202020202020202020202020202020202428272E707265746975735265';
wwv_flow_api.g_varchar2_table(137) := '7665616C6572496E6C696E65546F546865546F70202E70726574697573457870616E6442746E27292E6869646528293B0D0A2020202020202020202020202020202020202020202020202428272E7072657469757352657665616C6572496E6C696E6554';
wwv_flow_api.g_varchar2_table(138) := '6F546865546F7020237072657469757352657665616C6572427574746F6E526567696F6E27292E6869646528293B0D0A0D0A2020202020202020202020202020202020202020202020202F2F204C6F6720616E642072656D6F766520746865206F766572';
wwv_flow_api.g_varchar2_table(139) := '6C617973207A2D696E64657820746F20616C6C6F772074686520646576656C6F7065722062617220746F20656E61626C650D0A202020202020202020202020202020202020202020202020766172206F7665726C61795A696E646578203D202428272E75';
wwv_flow_api.g_varchar2_table(140) := '692D7769646765742D6F7665726C61792E75692D66726F6E7427292E63737328227A2D696E64657822293B0D0A2020202020202020202020202020202020202020202020202428642E746172676574292E6469616C6F6728226F7074696F6E222C20226F';
wwv_flow_api.g_varchar2_table(141) := '7665726C61792D7A2D696E646578222C206F7665726C61795A696E646578293B0D0A2020202020202020202020202020202020202020202020202428272E75692D7769646765742D6F7665726C61792E75692D66726F6E7427292E63737328227A2D696E';
wwv_flow_api.g_varchar2_table(142) := '646578222C202222293B0D0A20202020202020202020202020202020202020207D2C0D0A2020202020202020202020202020202020202020636C6F73653A2066756E6374696F6E20286429207B0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(143) := '2020202F2F20526573746F726520746865206F7665726C617973207A2D696E6465780D0A202020202020202020202020202020202020202020202020766172206F7665726C61795A696E646578203D202428642E746172676574292E6469616C6F672822';
wwv_flow_api.g_varchar2_table(144) := '6F7074696F6E222C20226F7665726C61792D7A2D696E64657822293B0D0A2020202020202020202020202020202020202020202020202428272E75692D7769646765742D6F7665726C61792E75692D66726F6E7427292E63737328227A2D696E64657822';
wwv_flow_api.g_varchar2_table(145) := '2C206F7665726C61795A696E646578293B0D0A20202020202020202020202020202020202020207D2C0D0A20202020202020202020202020202020202020206372656174653A2066756E6374696F6E202829207B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(146) := '202020202020202020202F2F20646F6E2774207363726F6C6C20746865206469616C6F6720776974682074686520706167650D0A202020202020202020202020202020202020202020202020242874686973292E636C6F7365737428222E75692D646961';
wwv_flow_api.g_varchar2_table(147) := '6C6F6722292E6373732822706F736974696F6E222C2022666978656422293B0D0A202020202020202020202020202020202020202020202020242827237072657469757352657665616C6572496E6C696E6527292E706172656E7428292E617070656E64';
wwv_flow_api.g_varchar2_table(148) := '287072657469757352657665616C6572466F6F746572293B0D0A2020202020202020202020202020202020202020202020202428272E7072657469757352657665616C6572466F6F746572202E707265746975735461626C6F636B56657273696F6E2729';
wwv_flow_api.g_varchar2_table(149) := '2E74657874287064742E6F70742E76657273696F6E293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D2C0D0A20202020202020202020202020202020776964676574203D206973506F707570';
wwv_flow_api.g_varchar2_table(150) := '203F2022706F70757022203A20226469616C6F67223B0D0A0D0A2020202020202020202020206966202873697A6529207B0D0A202020202020202020202020202020206F7074696F6E732E7769647468203D2073697A655B315D3B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(151) := '2020202020202020206F7074696F6E732E686569676874203D2073697A655B325D3B0D0A2020202020202020202020207D0D0A20202020202020202020202069662028706172656E74202626206973506F70757029207B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(152) := '20202020206F7074696F6E732E706172656E74456C656D656E74203D20706172656E743B0D0A2020202020202020202020202020202069662028696E7374242E686173436C61737328226A732D706F7075702D63616C6C6F7574222929207B0D0A202020';
wwv_flow_api.g_varchar2_table(153) := '20202020202020202020202020202020206F7074696F6E732E63616C6C6F7574203D20747275653B202F2F20646F6E2774206578706C696369746C792073657420746F2066616C73650D0A202020202020202020202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(154) := '202020202020202020206966202872656C506F7329207B0D0A20202020202020202020202020202020202020206F7074696F6E732E72656C6174697665506F736974696F6E203D2072656C506F735B315D3B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(155) := '7D0D0A2020202020202020202020207D0D0A202020202020202020202020242E65616368285B227769647468222C2022686569676874222C20226D696E5769647468222C20226D696E486569676874222C20226D61785769647468222C20226D61784865';
wwv_flow_api.g_varchar2_table(156) := '69676874225D2C2066756E6374696F6E2028692C2070726F7029207B0D0A20202020202020202020202020202020766172206174747256616C7565203D207061727365496E7428696E7374242E617474722822646174612D22202B2070726F702E746F4C';
wwv_flow_api.g_varchar2_table(157) := '6F776572436173652829292C203130293B0D0A20202020202020202020202020202020696620282169734E614E286174747256616C75652929207B0D0A20202020202020202020202020202020202020206F7074696F6E735B70726F705D203D20617474';
wwv_flow_api.g_varchar2_table(158) := '7256616C75653B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A202020202020202020202020242E65616368285B22617070656E64546F222C20226469616C6F67436C617373225D2C2066756E6374696F';
wwv_flow_api.g_varchar2_table(159) := '6E2028692C2070726F7029207B0D0A20202020202020202020202020202020766172206174747256616C7565203D20696E7374242E617474722822646174612D22202B2070726F702E746F4C6F776572436173652829293B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(160) := '202020202020696620286174747256616C756529207B0D0A20202020202020202020202020202020202020206F7074696F6E735B70726F705D203D206174747256616C75653B0D0A202020202020202020202020202020207D0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(161) := '2020207D293B0D0A202020202020202020202020696620286F7074696F6E732E617070656E64546F202626206F7074696F6E732E617070656E64546F2E737562737472696E6728302C203129203D3D3D202223222026262024286F7074696F6E732E6170';
wwv_flow_api.g_varchar2_table(162) := '70656E64546F292E6C656E677468203D3D3D203029207B0D0A2020202020202020202020202020202024282223777776466C6F77466F726D22292E616674657228273C6469762069643D2227202B207574696C2E65736361706548544D4C286F7074696F';
wwv_flow_api.g_varchar2_table(163) := '6E732E617070656E64546F2E737562737472696E6728312929202B2027223E3C2F6469763E27293B0D0A2020202020202020202020207D0D0A202020202020202020202020696E7374245B7769646765745D286F7074696F6E73290D0A20202020202020';
wwv_flow_api.g_varchar2_table(164) := '2020202020202020202E6F6E28776964676574202B20226F70656E222C2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020202020696620286F7074696F6E732E6D6F64616C29207B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(165) := '2020202020202020202020617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28293B0D0A20202020202020202020202020202020202020207D0D0A2020202020202020202020202020202020202020617065782E776964';
wwv_flow_api.g_varchar2_table(166) := '6765742E7574696C2E7669736962696C6974794368616E676528696E7374245B305D2C2074727565293B0D0A202020202020202020202020202020207D290D0A202020202020202020202020202020202E6F6E28776964676574202B2022726573697A65';
wwv_flow_api.g_varchar2_table(167) := '222C2066756E6374696F6E202829207B0D0A20202020202020202020202020202020202020202F2F20726573697A65207365747320706F736974696F6E20746F206162736F6C75746520736F20666978207768617420726573697A61626C652062726F6B';
wwv_flow_api.g_varchar2_table(168) := '650D0A2020202020202020202020202020202020202020242874686973292E636C6F7365737428222E75692D6469616C6F6722292E6373732822706F736974696F6E222C2022666978656422293B0D0A202020202020202020202020202020207D290D0A';
wwv_flow_api.g_varchar2_table(169) := '202020202020202020202020202020202E6F6E28776964676574202B2022636C6F7365222C2066756E6374696F6E202829207B0D0A2020202020202020202020202020202020202020696620286F7074696F6E732E6D6F64616C29207B0D0A2020202020';
wwv_flow_api.g_varchar2_table(170) := '20202020202020202020202020202020202020617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28293B0D0A20202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020202428';
wwv_flow_api.g_varchar2_table(171) := '22237072657469757352657665616C6572496E6C696E65202E742D4469616C6F67526567696F6E2D626F647922292E656D70747928293B0D0A2020202020202020202020202020202020202020617065782E7769646765742E7574696C2E766973696269';
wwv_flow_api.g_varchar2_table(172) := '6C6974794368616E676528696E7374245B305D2C2066616C7365293B0D0A202020202020202020202020202020207D293B0D0A20202020202020207D293B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E6522';
wwv_flow_api.g_varchar2_table(173) := '292E706172656E7428292E66696E6428222E75692D6469616C6F672D7469746C6522292E616464436C617373282766612066612D6869707374657227293B0D0A202020207D0D0A0D0A202020207661722072656E646572203D2066756E6374696F6E2072';
wwv_flow_api.g_varchar2_table(174) := '656E646572286F7074696F6E7329207B0D0A0D0A20202020202020207064742E6461203D206F7074696F6E732E64613B0D0A20202020202020207064742E6F7074203D206F7074696F6E732E6F70743B0D0A20202020202020207064742E4A534F4E7365';
wwv_flow_api.g_varchar2_table(175) := '7474696E6773203D204A534F4E2E7061727365286C6F63616C53746F726167652E6765744974656D282270726574697573446576656C6F706572546F6F6C2229293B0D0A0D0A2020202020202020617065782E64656275672E6C6F67286F7074696F6E73';
wwv_flow_api.g_varchar2_table(176) := '2E6F70742E6465627567507265666978202B202772656E646572272C206F7074696F6E73293B0D0A0D0A0D0A202020202020202069662028207064742E67657453657474696E6728276F70746F75742E737461747573272920213D2027592729207B0D0A';
wwv_flow_api.g_varchar2_table(177) := '0D0A202020202020202020202020616464507265746975734F7074696F6E7328293B0D0A0D0A2020202020202020202020206966202821242E6973456D7074794F626A656374287064742E4A534F4E73657474696E67732929207B0D0A202020200D0A20';
wwv_flow_api.g_varchar2_table(178) := '2020202020202020202020202020202F2F2052657665616C65720D0A202020202020202020202020202020206966202867657453657474696E67282772657665616C65722E656E61626C652729203D3D2027592729207B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(179) := '2020202020202020207064742E70726574697573436F6E74656E7452657665616C65722E6164644869707374657228293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F2052656C6F6164204672';
wwv_flow_api.g_varchar2_table(180) := '616D650D0A202020202020202020202020202020206966202867657453657474696E67282772656C6F61646672616D652E656E61626C652729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E70726574697573';
wwv_flow_api.g_varchar2_table(181) := '436F6E74656E7452656C6F61644672616D652E616374697661746528293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F204275696C64204F7074696F6E20486967686C696768740D0A20202020';
wwv_flow_api.g_varchar2_table(182) := '2020202020202020202020206966202867657453657474696E6728276275696C646F7074696F6E68696768746C696768742E656E61626C652729203D3D2027592729207B0D0A20202020202020202020202020202020202020207064742E636F6E74656E';
wwv_flow_api.g_varchar2_table(183) := '744275696C644F7074696F6E486967686C696768742E616374697661746528293B0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A202020207D3B0D0A0D0A202020207661';
wwv_flow_api.g_varchar2_table(184) := '7220636C6F616B44656275674C6576656C203D2066756E6374696F6E20636C6F616B44656275674C6576656C2829207B0D0A0D0A20202020202020207064742E7061676544656275674C6576656C203D20617065782E6974656D28277064656275672729';
wwv_flow_api.g_varchar2_table(185) := '2E67657456616C756528293B0D0A2020202020202020617065782E6974656D282770646562756727292E73657456616C756528274C4556454C3227293B0D0A20202020202020200D0A202020207D0D0A0D0A2020202076617220756E436C6F616B446562';
wwv_flow_api.g_varchar2_table(186) := '75674C6576656C203D2066756E6374696F6E20756E436C6F616B44656275674C6576656C2829207B0D0A2020202020202020696620287064742E7061676544656275674C6576656C20213D20756E646566696E65642029207B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(187) := '202020617065782E6974656D282770646562756727292E73657456616C756528207064742E7061676544656275674C6576656C20293B0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202076617220616A61784572726F7248616E646C6572';
wwv_flow_api.g_varchar2_table(188) := '203D2066756E6374696F6E20616A61784572726F7248616E646C6572202870446174612C20704572722C20704572726F724D65737361676529207B0D0A20202020202020200D0A20202020202020207064742E756E436C6F616B44656275674C6576656C';
wwv_flow_api.g_varchar2_table(189) := '28293B0D0A20202020202020200D0A2020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0D0A2020202020202020617065782E6D6573736167652E73686F774572726F7273285B7B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(190) := '747970653A20226572726F72222C0D0A2020202020202020202020206C6F636174696F6E3A205B2270616765225D2C0D0A2020202020202020202020206D6573736167653A20704572726F724D657373616765202B20273C62723E506C65617365206368';
wwv_flow_api.g_varchar2_table(191) := '65636B2062726F7773657220636F6E736F6C652E272C0D0A202020202020202020202020756E736166653A2066616C73650D0A20202020202020207D5D293B0D0A20202020202020200D0A2020202020202020617065782E64656275672E6C6F67287044';
wwv_flow_api.g_varchar2_table(192) := '6174612C20704572722C20704572726F724D657373616765293B0D0A202020207D0D0A0D0A20202020766172206F7074496E203D2066756E6374696F6E206F7074496E2829207B0D0A2020202020202020766172206A203D204A534F4E2E706172736528';
wwv_flow_api.g_varchar2_table(193) := '206C6F63616C53746F726167652E6765744974656D282270726574697573446576656C6F706572546F6F6C222920293B0D0A2020202020202020696620286A20213D206E756C6C29207B0D0A2020202020202020202020206A2E73657474696E67732E6F';
wwv_flow_api.g_varchar2_table(194) := '70746F75742E737461747573203D20274E273B0D0A2020202020202020202020206C6F63616C53746F726167652E7365744974656D282270726574697573446576656C6F706572546F6F6C222C204A534F4E2E737472696E67696679286A29293B0D0A20';
wwv_flow_api.g_varchar2_table(195) := '2020202020202020202020617065782E6D6573736167652E73686F77506167655375636365737328224F7074656420496E20746F205072657469757320446576656C6F70657220546F6F6C2E205265667265736820796F75722062726F777365722E2229';
wwv_flow_api.g_varchar2_table(196) := '3B0D0A20202020202020207D0D0A202020207D0D0A0D0A2020202072657475726E207B0D0A202020202020202072656E6465723A2072656E6465722C0D0A202020202020202064613A2064612C0D0A20202020202020206F70743A206F70742C0D0A2020';
wwv_flow_api.g_varchar2_table(197) := '2020202020204A534F4E73657474696E67733A204A534F4E73657474696E67732C0D0A20202020202020206E766C3A206E766C2C0D0A2020202020202020666978546F6F6C62617257696474683A20666978546F6F6C62617257696474682C0D0A202020';
wwv_flow_api.g_varchar2_table(198) := '202020202067657453657474696E673A2067657453657474696E672C0D0A20202020202020207061676544656275674C6576656C3A207061676544656275674C6576656C2C0D0A2020202020202020636C6F616B44656275674C6576656C3A20636C6F61';
wwv_flow_api.g_varchar2_table(199) := '6B44656275674C6576656C2C0D0A2020202020202020756E436C6F616B44656275674C6576656C3A20756E436C6F616B44656275674C6576656C2C0D0A2020202020202020616A61784572726F7248616E646C65723A20616A61784572726F7248616E64';
wwv_flow_api.g_varchar2_table(200) := '6C65722C0D0A20202020202020206F7074496E3A206F7074496E0D0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135225315810973946)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'pretiusDeveloperTool.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A205374616E64617264202A2F0D0A0D0A2F2A20707265746975732023454231433233202A2F0D0A2F2A20507265746975732023314639304342202A2F0D0A0D0A237072657469757352657665616C6572496E6C696E65207461626C65207B0D0A2020';
wwv_flow_api.g_varchar2_table(2) := '626F726465722D636F6C6C617073653A20636F6C6C617073653B0D0A202077696474683A20313030253B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E652074682C20237072657469757352657665616C6572496E6C696E652074';
wwv_flow_api.g_varchar2_table(3) := '64207B0D0A2020746578742D616C69676E3A206C6566743B0D0A202070616464696E673A203870783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E616C7465726E6174652D726F77732D746C207B0D0A20206261636B67';
wwv_flow_api.g_varchar2_table(4) := '726F756E642D636F6C6F723A20236632663266322021696D706F7274616E740D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65207468207B0D0A20206261636B67726F756E642D636F6C6F723A20233146393043423B0D0A202063';
wwv_flow_api.g_varchar2_table(5) := '6F6C6F723A2077686974653B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65206C6162656C2E736D616C6C4D6167696E4C656674207B0D0A20206D617267696E2D6C6566743A20313070783B0D0A7D0D0A0D0A23707265746975';
wwv_flow_api.g_varchar2_table(6) := '7352657665616C6572496E6C696E65202E72536561726368207B0D0A202070616464696E673A203670783B0D0A2020666C6F61743A2072696768743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E736964652D62792D73';
wwv_flow_api.g_varchar2_table(7) := '696465207B0D0A2020666C6F61743A206C6566743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E652074642E74645461626C6F636B56617273207B0D0A20206D61782D77696474683A2032303070783B0D0A2020776F72642D77';
wwv_flow_api.g_varchar2_table(8) := '7261703A20627265616B2D776F72643B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E707265746975735461624C6162656C207B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A7D0D0A0D0A237072657469';
wwv_flow_api.g_varchar2_table(9) := '757352657665616C6572496E6C696E65202E7072657469757352657665616C6572417474656E74696F6E207B0D0A2020666F6E742D7765696768743A20626F6C643B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E707265';
wwv_flow_api.g_varchar2_table(10) := '7469757352657665616C65724E6F6E52656E6465726564207B0D0A2020746578742D6465636F726174696F6E3A206C696E652D7468726F7567683B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E72657665616C65722D6C';
wwv_flow_api.g_varchar2_table(11) := '6F6164696E67207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203530253B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E72657665616C65722D686561646572207B0D0A2020626163';
wwv_flow_api.g_varchar2_table(12) := '6B67726F756E642D636F6C6F723A20236638663866383B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202077696474683A20313030253B0D0A202070616464696E672D6C6566743A203570783B0D0A2020626F726465722D7261';
wwv_flow_api.g_varchar2_table(13) := '646975733A203570783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074683A66697273742D6368696C64207B0D0A';
wwv_flow_api.g_varchar2_table(14) := '2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074';
wwv_flow_api.g_varchar2_table(15) := '643A66697273742D6368696C64207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E74207461626C652E7461626C';
wwv_flow_api.g_varchar2_table(16) := '655461626C6F636B566172732074722074683A6C6173742D6368696C64207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202370726574697573436F';
wwv_flow_api.g_varchar2_table(17) := '6E74656E74207461626C652E7461626C655461626C6F636B566172732074722074643A6C6173742D6368696C64207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C657249';
wwv_flow_api.g_varchar2_table(18) := '6E6C696E65202E6E6F74696669636174696F6E2D636F756E746572207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A2020746F703A202D3570783B0D0A202072696768743A203170783B0D0A20206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(19) := '723A20626C61636B3B0D0A2020636F6C6F723A20236666663B0D0A2020626F726465722D7261646975733A203370783B0D0A202070616464696E673A20317078203370783B0D0A2020666F6E743A203870782056657264616E613B0D0A7D0D0A0D0A2370';
wwv_flow_api.g_varchar2_table(20) := '72657469757352657665616C6572496E6C696E65202E7377697463682D646973706C61792D6E6F6E65207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E';
wwv_flow_api.g_varchar2_table(21) := '65202E646973706C61792D6E6F6E65207B0D0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A0D0A237072657469757352657665616C6572496E6C696E65206C6162656C2E7377697463682D616C6F6E65207B0D0A';
wwv_flow_api.g_varchar2_table(22) := '2020626F726465722D7261646975733A203470782021696D706F7274616E743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65207370616E2E66612E66612D686970737465722E7461626C6F636B2D72657665616C65722D6963';
wwv_flow_api.g_varchar2_table(23) := '6F6E207B0D0A202070616464696E672D746F703A203470783B0D0A7D0D0A0D0A2F2A205377697463682052656C61746564202A2F0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64207B0D0A2020666F';
wwv_flow_api.g_varchar2_table(24) := '6E742D66616D696C793A20224C7563696461204772616E6465222C205461686F6D612C2056657264616E612C2073616E732D73657269663B0D0A202070616464696E673A203470783B0D0A20206F766572666C6F773A2068696464656E3B0D0A20207061';
wwv_flow_api.g_varchar2_table(25) := '6464696E672D6C6566743A203070780D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D7469746C65207B0D0A20206D617267696E2D626F74746F6D3A203670783B0D0A7D0D0A0D0A23707265746975735265';
wwv_flow_api.g_varchar2_table(26) := '7665616C6572496E6C696E65202E7377697463682D6669656C6420696E707574207B0D0A2020706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B0D0A2020636C69703A207265637428302C20302C20302C2030293B0D0A202068';
wwv_flow_api.g_varchar2_table(27) := '65696768743A203170783B0D0A202077696474683A203170783B0D0A2020626F726465723A20303B0D0A20206F766572666C6F773A2068696464656E3B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D66';
wwv_flow_api.g_varchar2_table(28) := '69656C64206C6162656C207B0D0A2020666C6F61743A206C6566743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C207B0D0A2020646973706C61793A20696E6C696E652D62';
wwv_flow_api.g_varchar2_table(29) := '6C6F636B3B0D0A20202F2A2077696474683A20363070783B202A2F0D0A20206D696E2D77696474683A20343070783B0D0A20206261636B67726F756E642D636F6C6F723A20236534653465343B0D0A2020636F6C6F723A207267626128302C20302C2030';
wwv_flow_api.g_varchar2_table(30) := '2C20302E38293B0D0A2020666F6E742D73697A653A20313470783B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020746578742D616C69676E3A2063656E7465723B0D0A2020746578742D736861646F773A206E6F6E653B0D0A2020';
wwv_flow_api.g_varchar2_table(31) := '70616464696E673A2035707820313470783B0D0A2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E32293B0D0A20202D7765626B69742D626F782D736861646F773A20696E736574203020317078203370782072';
wwv_flow_api.g_varchar2_table(32) := '67626128302C20302C20302C20302E33292C2030203170782072676261283235352C203235352C203235352C20302E31293B0D0A2020626F782D736861646F773A20696E73657420302031707820337078207267626128302C20302C20302C20302E3329';
wwv_flow_api.g_varchar2_table(33) := '2C2030203170782072676261283235352C203235352C203235352C20302E31293B0D0A20202D7765626B69742D7472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F75743B0D0A20202D6D6F7A2D7472616E736974696F6E3A2061';
wwv_flow_api.g_varchar2_table(34) := '6C6C20302E317320656173652D696E2D6F75743B0D0A20202D6D732D7472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F75743B0D0A20202D6F2D7472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F7574';
wwv_flow_api.g_varchar2_table(35) := '3B0D0A20207472616E736974696F6E3A20616C6C20302E317320656173652D696E2D6F75743B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C64206C6162656C3A686F766572207B0D0A202063';
wwv_flow_api.g_varchar2_table(36) := '7572736F723A20706F696E7465723B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E7377697463682D6669656C6420696E7075743A636865636B65642B6C6162656C207B0D0A20206261636B67726F756E642D636F6C6F72';
wwv_flow_api.g_varchar2_table(37) := '3A20233146393043423B0D0A2020636F6C6F723A2077686974653B0D0A20202D7765626B69742D626F782D736861646F773A206E6F6E653B0D0A2020626F782D736861646F773A206E6F6E653B0D0A7D0D0A0D0A237072657469757352657665616C6572';
wwv_flow_api.g_varchar2_table(38) := '496E6C696E65202E7377697463682D6669656C64206C6162656C3A66697273742D6F662D74797065207B0D0A2020626F726465722D7261646975733A2034707820302030203470783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C69';
wwv_flow_api.g_varchar2_table(39) := '6E65202E7377697463682D6669656C64206C6162656C3A6C6173742D6F662D74797065207B0D0A2020626F726465722D7261646975733A2030203470782034707820303B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65207468';
wwv_flow_api.g_varchar2_table(40) := '2E742D5265706F72742D636F6C48656164207B0D0A2020626F726465722D7374796C653A20736F6C69643B0D0A20202F2A20626F726465722D636F6C6F723A20233146393043423B202A2F0D0A2020626F726465722D7261646975733A203670783B0D0A';
wwv_flow_api.g_varchar2_table(41) := '2020626F726465722D77696474683A203270783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572207B0D0A2020636F6C6F723A206F6666696369616C3B0D0A2020646973706C61793A20696E6C';
wwv_flow_api.g_varchar2_table(42) := '696E652D626C6F636B3B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A202077696474683A20363470783B0D0A20206865696768743A20363470783B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C6473';
wwv_flow_api.g_varchar2_table(43) := '2D7370696E6E657220646976207B0D0A20207472616E73666F726D2D6F726967696E3A203332707820333270783B0D0A2020616E696D6174696F6E3A206C64732D7370696E6E657220312E3273206C696E65617220696E66696E6974653B0D0A7D0D0A0D';
wwv_flow_api.g_varchar2_table(44) := '0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6166746572207B0D0A2020636F6E74656E743A202220223B0D0A2020646973706C61793A20626C6F636B3B0D0A2020706F736974696F6E3A206162';
wwv_flow_api.g_varchar2_table(45) := '736F6C7574653B0D0A2020746F703A203370783B0D0A20206C6566743A20323970783B0D0A202077696474683A203570783B0D0A20206865696768743A20313470783B0D0A2020626F726465722D7261646975733A203230253B0D0A20206261636B6772';
wwv_flow_api.g_varchar2_table(46) := '6F756E643A20233146393043423B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283129207B0D0A20207472616E73666F726D3A20726F7461746528306465';
wwv_flow_api.g_varchar2_table(47) := '67293B0D0A2020616E696D6174696F6E2D64656C61793A202D312E31733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283229207B0D0A20207472616E73';
wwv_flow_api.g_varchar2_table(48) := '666F726D3A20726F74617465283330646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D31733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C';
wwv_flow_api.g_varchar2_table(49) := '64283329207B0D0A20207472616E73666F726D3A20726F74617465283630646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E39733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D737069';
wwv_flow_api.g_varchar2_table(50) := '6E6E6572206469763A6E74682D6368696C64283429207B0D0A20207472616E73666F726D3A20726F74617465283930646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E38733B0D0A7D0D0A0D0A237072657469757352657665616C';
wwv_flow_api.g_varchar2_table(51) := '6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283529207B0D0A20207472616E73666F726D3A20726F7461746528313230646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E37733B0D0A7D';
wwv_flow_api.g_varchar2_table(52) := '0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283629207B0D0A20207472616E73666F726D3A20726F7461746528313530646567293B0D0A2020616E696D6174696F';
wwv_flow_api.g_varchar2_table(53) := '6E2D64656C61793A202D302E36733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283729207B0D0A20207472616E73666F726D3A20726F74617465283138';
wwv_flow_api.g_varchar2_table(54) := '30646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E35733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C64283829207B0D0A20207472';
wwv_flow_api.g_varchar2_table(55) := '616E73666F726D3A20726F7461746528323130646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E34733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74';
wwv_flow_api.g_varchar2_table(56) := '682D6368696C64283929207B0D0A20207472616E73666F726D3A20726F7461746528323430646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E33733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E';
wwv_flow_api.g_varchar2_table(57) := '6C64732D7370696E6E6572206469763A6E74682D6368696C6428313029207B0D0A20207472616E73666F726D3A20726F7461746528323730646567293B0D0A2020616E696D6174696F6E2D64656C61793A202D302E32733B0D0A7D0D0A0D0A2370726574';
wwv_flow_api.g_varchar2_table(58) := '69757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C6428313129207B0D0A20207472616E73666F726D3A20726F7461746528333030646567293B0D0A2020616E696D6174696F6E2D64656C61793A';
wwv_flow_api.g_varchar2_table(59) := '202D302E31733B0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C64732D7370696E6E6572206469763A6E74682D6368696C6428313229207B0D0A20207472616E73666F726D3A20726F7461746528333330646567293B0D';
wwv_flow_api.g_varchar2_table(60) := '0A2020616E696D6174696F6E2D64656C61793A2030733B0D0A7D0D0A0D0A406B65796672616D6573206C64732D7370696E6E6572207B0D0A20203025207B0D0A202020206F7061636974793A20313B0D0A20207D0D0A202031303025207B0D0A20202020';
wwv_flow_api.g_varchar2_table(61) := '6F7061636974793A20303B0D0A20207D0D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65206469762370726574697573436F6E74656E74207B0D0A2020666F6E742D66616D696C793A20224C7563696461204772616E6465222C20';
wwv_flow_api.g_varchar2_table(62) := '5461686F6D612C2056657264616E612C2073616E732D73657269663B0D0A2020666F6E742D73697A653A20313370783B0D0A7D0D0A0D0A2E7072657469757352657665616C6572496E6C696E65546F546865546F70207B0D0A20207A2D696E6465783A20';
wwv_flow_api.g_varchar2_table(63) := '393939392021696D706F7274616E740D0A7D0D0A0D0A2E7072657469757352657665616C6572496E6C696E65546F546865546F70202E7072657469757352657665616C6572466F6F746572207B0D0A2020626F726465722D7374796C653A20736F6C6964';
wwv_flow_api.g_varchar2_table(64) := '3B0D0A2020626F726465722D636F6C6F723A206C69676874677265793B0D0A2020626F726465722D77696474683A203170783B0D0A20206261636B67726F756E642D636F6C6F723A20234632463246323B0D0A2020636F6C6F723A20233146393043423B';
wwv_flow_api.g_varchar2_table(65) := '0D0A2020746578742D616C69676E3A2063656E7465723B0D0A202070616464696E672D6C6566743A203570783B0D0A20206D61782D6865696768743A20323270783B0D0A7D0D0A0D0A2E7072657469757352657665616C6572496E6C696E65546F546865';
wwv_flow_api.g_varchar2_table(66) := '546F7020612E7072657469757352657665616C65724C696E6B207B0D0A2020636F6C6F723A20233146393043422021696D706F7274616E743B0D0A2020666F6E742D73697A653A20313270780D0A7D0D0A0D0A2E7072657469757352657665616C657249';
wwv_flow_api.g_varchar2_table(67) := '6E6C696E65546F546865546F70202E707265746975735461626C6F636B56657273696F6E207B0D0A2020666C6F61743A2072696768743B0D0A202070616464696E672D72696768743A203570783B0D0A7D0D0A0D0A2E7072657469757352657665616C65';
wwv_flow_api.g_varchar2_table(68) := '72496E6C696E65546F546865546F70202E70726574697573466F6F7465724F7074696F6E73207B0D0A2020666C6F61743A206C6566743B200D0A7D0D0A0D0A237072657469757352657665616C6572496E6C696E65202E6C696E6B4C696B65207B0D0A20';
wwv_flow_api.g_varchar2_table(69) := '20637572736F723A706F696E7465723B0D0A2020636F6C6F723A233146393043423B200D0A20202F2A20746578742D6465636F726174696F6E3A756E6465726C696E653B202A2F0D0A7D0D0A0D0A2F2A2046697820627567207468617420636F70696573';
wwv_flow_api.g_varchar2_table(70) := '2050445420627574746F6E7320746F20706172656E74207061676520696620697420686173206120627574746F6E7320636F6E7461696E657220726567696F6E202A2F0D0A2E7064742D6F7074696F6E2D627574746F6E3A6E6F74282370726574697573';
wwv_flow_api.g_varchar2_table(71) := '52657665616C6572427574746F6E526567696F6E202E7064742D6F7074696F6E2D627574746F6E29207B0D0A2020646973706C61793A206E6F6E653B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135225757978973948)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'revealer.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '3C64697620636C6173733D2272657665616C65722D6C6F6164696E67223E0D0A20202020202020203C64697620636C6173733D226C64732D7370696E6E6572223E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A20202020';
wwv_flow_api.g_varchar2_table(2) := '2020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C';
wwv_flow_api.g_varchar2_table(3) := '6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A20';
wwv_flow_api.g_varchar2_table(4) := '2020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A202020202020202020202020202020203C6469763E3C2F6469763E0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(5) := '20203C6469763E3C2F6469763E0D0A20202020202020203C2F6469763E0D0A3C2F6469763E0D0A3C64697620636C6173733D2272657665616C65722D686561646572207377697463682D646973706C61792D6E6F6E65223E0D0A20202020202020203C64';
wwv_flow_api.g_varchar2_table(6) := '697620636C6173733D2272536561726368223E0D0A202020202020202020202020202020203C64697620636C6173733D22742D466F726D2D6974656D57726170706572223E0D0A2020202020202020202020202020202020202020202020203C696E7075';
wwv_flow_api.g_varchar2_table(7) := '742069643D2772536561726368426F782720747970653D227365617263682220706C616365686F6C6465723D225365617263682E2E2E2220636C6173733D22746578745F6669656C6420617065782D6974656D2D74657874223E0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(8) := '202020202020202020202020202020203C7370616E20636C6173733D22742D466F726D2D6974656D5465787420742D466F726D2D6974656D546578742D2D706F7374223E0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(9) := '20203C627574746F6E2069643D2772436C656172536561726368426F782720747970653D22627574746F6E22207469746C653D22436C656172205365617263682220617269612D6C6162656C3D22436C65617220536561726368220D0A20202020202020';
wwv_flow_api.g_varchar2_table(10) := '202020202020202020202020202020202020202020202020202020202020202020636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C20742D';
wwv_flow_api.g_varchar2_table(11) := '427574746F6E2D2D6E6F5549223E3C7370616E0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020617269612D68696464656E3D22747275652220636C6173733D22742D49636F';
wwv_flow_api.g_varchar2_table(12) := '6E2066612066612D74696D6573223E3C2F7370616E3E3C2F627574746F6E3E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6469763E0D0A20202020202020203C2F6469763E0D0A20202020202020203C6469762069643D22707265';
wwv_flow_api.g_varchar2_table(13) := '7469757350616765436F6E74726F6C732220636C6173733D227377697463682D6669656C64223E203C2F6469763E0D0A0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C732220636C6173733D2273';
wwv_flow_api.g_varchar2_table(14) := '77697463682D6669656C6420736964652D62792D73696465223E0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22506167654974656D73222076616C75';
wwv_flow_api.g_varchar2_table(15) := '653D22504922202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22506167654974656D732220636C6173733D22707265746975735461624C6162656C223E50616765204974656D730D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(16) := '202020202020202020203C7370616E2069643D225049636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164';
wwv_flow_api.g_varchar2_table(17) := '696F22206E616D653D227043617465676F7279222069643D225061676553656C656374656441626F7665222076616C75653D22505822202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D225061676553656C656374656441';
wwv_flow_api.g_varchar2_table(18) := '626F76652220636C6173733D22707265746975735461624C6162656C223E50580D0A2020202020202020202020202020202020202020202020203C7370616E2069643D225058636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(19) := '202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22506167655A65726F222076616C75653D22503022202F3E0D0A2020';
wwv_flow_api.g_varchar2_table(20) := '20202020202020202020202020203C6C6162656C20666F723D22506167655A65726F2220636C6173733D22707265746975735461624C6162656C223E50300D0A2020202020202020202020202020202020202020202020203C7370616E2069643D225030';
wwv_flow_api.g_varchar2_table(21) := '636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069';
wwv_flow_api.g_varchar2_table(22) := '643D226F74686572506167654974656D73222076616C75653D22504F22202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D226F74686572506167654974656D732220636C6173733D22707265746975735461624C6162656C';
wwv_flow_api.g_varchar2_table(23) := '223E4F74686572730D0A2020202020202020202020202020202020202020202020203C7370616E2069643D22504F636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A20202020202020203C2F';
wwv_flow_api.g_varchar2_table(24) := '6469763E0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C73322220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(25) := '203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22496E7465726163746976655265706F7274222076616C75653D22495222202F3E0D0A202020202020202020202020202020203C6C6162656C2066';
wwv_flow_api.g_varchar2_table(26) := '6F723D22496E7465726163746976655265706F72742220636C6173733D22707265746975735461624C6162656C223E496E742E205265702E0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224952636F756E7465';
wwv_flow_api.g_varchar2_table(27) := '72223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22496E74';
wwv_flow_api.g_varchar2_table(28) := '657261637469766547726964222076616C75653D22494722202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22496E746572616374697665477269642220636C6173733D22707265746975735461624C6162656C223E496E';
wwv_flow_api.g_varchar2_table(29) := '742E20477269640D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224947636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(30) := '202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D224170706C69636174696F6E4974656D73222076616C75653D22414922202F3E0D0A202020202020202020202020202020203C6C61';
wwv_flow_api.g_varchar2_table(31) := '62656C20666F723D224170706C69636174696F6E4974656D732220636C6173733D22707265746975735461624C6162656C223E4170702E204974656D730D0A2020202020202020202020202020202020202020202020203C7370616E2069643D22414963';
wwv_flow_api.g_varchar2_table(32) := '6F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F727922206964';
wwv_flow_api.g_varchar2_table(33) := '3D22537562737469747574696F6E537472696E6773222076616C75653D22534222202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22537562737469747574696F6E537472696E67732220636C6173733D22707265746975';
wwv_flow_api.g_varchar2_table(34) := '735461624C6162656C223E537562732E0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D225342636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A';
wwv_flow_api.g_varchar2_table(35) := '202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D22436F6E74657874222076616C75653D22435822202F3E0D0A202020202020202020202020202020203C6C61';
wwv_flow_api.g_varchar2_table(36) := '62656C20666F723D22436F6E746578742220636C6173733D22707265746975735461624C6162656C223E436C69656E740D0A2020202020202020202020202020202020202020202020203C7370616E2069643D224358636F756E746572223E3C2F737061';
wwv_flow_api.g_varchar2_table(37) := '6E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D224672616D65776F726B4974';
wwv_flow_api.g_varchar2_table(38) := '656D73222076616C75653D22465722202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224672616D65776F726B4974656D732220636C6173733D22707265746975735461624C6162656C223E4672616D65776F726B0D0A20';
wwv_flow_api.g_varchar2_table(39) := '20202020202020202020202020202020202020202020203C7370616E2069643D224657636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A0D0A20';
wwv_flow_api.g_varchar2_table(40) := '202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C73332220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A0D0A202020202020202020202020202020203C696E70';
wwv_flow_api.g_varchar2_table(41) := '757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D224974656D73416C6C222076616C75653D22416C6C22202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224974656D73416C6C22';
wwv_flow_api.g_varchar2_table(42) := '20636C6173733D227377697463682D616C6F6E6520707265746975735461624C6162656C223E416C6C0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D22414C4C636F756E746572223E3C2F7370616E3E0D0A2020';
wwv_flow_api.g_varchar2_table(43) := '20202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A0D0A20202020202020203C6469762069643D227072657469757343617465676F7279436F6E74726F6C73352220636C6173733D22737769746368';
wwv_flow_api.g_varchar2_table(44) := '2D6669656C6420736964652D62792D73696465223E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D22726164696F22206E616D653D227043617465676F7279222069643D224974656D734150222076616C75653D224150';
wwv_flow_api.g_varchar2_table(45) := '22202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D224974656D7341502220636C6173733D227377697463682D616C6F6E6520707265746975735461624C6162656C223E3C7370616E0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(46) := '20202020202020202020202020202020202020636C6173733D2266612066612D696E666F2D7371756172652D6F20752D616C69676E4D6964646C652220617269612D68696464656E3D2274727565223E3C2F7370616E3E0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(47) := '202020202020202020202020203C7370616E2069643D224150636F756E746572223E3C2F7370616E3E0D0A202020202020202020202020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A0D0A20202020202020203C6469';
wwv_flow_api.g_varchar2_table(48) := '762069643D227072657469757343617465676F7279436F6E74726F6C73342220636C6173733D227377697463682D6669656C6420736964652D62792D73696465223E0D0A0D0A202020202020202020202020202020203C696E70757420747970653D2272';
wwv_flow_api.g_varchar2_table(49) := '6164696F22206E616D653D227043617465676F7279222069643D22446562756750616765222076616C75653D2244656275675061676522202F3E0D0A202020202020202020202020202020203C6C6162656C20666F723D22446562756750616765222063';
wwv_flow_api.g_varchar2_table(50) := '6C6173733D227377697463682D616C6F6E6520707265746975735461624C6162656C223E3C7370616E20636C6173733D2266612066612D62756720752D616C69676E4D6964646C65220D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '20202020202020617269612D68696464656E3D2274727565223E3C2F7370616E3E0D0A2020202020202020202020202020202020202020202020203C7370616E2069643D22585858636F756E746572223E3C2F7370616E3E0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '2020202020203C2F6C6162656C3E0D0A0D0A20202020202020203C2F6469763E0D0A3C2F6469763E0D0A0D0A3C6469762069643D2270726574697573436F6E74656E74223E203C2F6469763E0D0A0D0A3C6469762069643D227072657469757344656275';
wwv_flow_api.g_varchar2_table(53) := '67436F6E74656E74223E203C2F6469763E';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135226143494973949)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'revealer.html'
,p_mime_type=>'text/html'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '766172207072657469757352657665616C6572203D202866756E6374696F6E202829207B0D0A202020202275736520737472696374223B0D0A0D0A20202020766172205F7461626C655F203D20646F63756D656E742E637265617465456C656D656E7428';
wwv_flow_api.g_varchar2_table(2) := '277461626C6527292C0D0A20202020202020205F74725F203D20646F63756D656E742E637265617465456C656D656E742827747227292C0D0A20202020202020205F74685F203D20646F63756D656E742E637265617465456C656D656E74282774682729';
wwv_flow_api.g_varchar2_table(3) := '2C0D0A20202020202020205F74645F203D20646F63756D656E742E637265617465456C656D656E742827746427293B0D0A0D0A202020205F7461626C655F2E636C6173734E616D65203D20277461626C655461626C6F636B56617273273B0D0A20202020';
wwv_flow_api.g_varchar2_table(4) := '5F74725F2E636C6173734E616D65203D202764617461526F77273B0D0A202020205F74685F2E636C6173734E616D65203D2027742D5265706F72742D636F6C48656164273B0D0A202020205F74645F2E636C6173734E616D65203D202774645461626C6F';
wwv_flow_api.g_varchar2_table(5) := '636B56617273273B0D0A0D0A202020202F2F204275696C6473207468652048544D4C205461626C65206F7574206F66206D794C697374206A736F6E20646174612E0D0A2020202066756E6374696F6E206275696C6448746D6C5461626C65286172722920';
wwv_flow_api.g_varchar2_table(6) := '7B0D0A2020202020202020766172207461626C65203D205F7461626C655F2E636C6F6E654E6F64652866616C7365292C0D0A202020202020202020202020636F6C756D6E73203D20616464416C6C436F6C756D6E48656164657273286172722C20746162';
wwv_flow_api.g_varchar2_table(7) := '6C65293B0D0A2020202020202020666F7220287661722069203D20302C206D617869203D206172722E6C656E6774683B2069203C206D6178693B202B2B6929207B0D0A202020202020202020202020766172207472203D205F74725F2E636C6F6E654E6F';
wwv_flow_api.g_varchar2_table(8) := '64652866616C7365293B0D0A202020202020202020202020666F722028766172206A203D20302C206D61786A203D20636F6C756D6E732E6C656E6774683B206A203C206D61786A3B202B2B6A29207B0D0A20202020202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(9) := '207464203D205F74645F2E636C6F6E654E6F64652866616C7365293B0D0A202020202020202020202020202020207661722063656C6C56616C7565203D206172725B695D5B636F6C756D6E735B6A5D5D3B0D0A2020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(10) := '642E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F6465286172725B695D5B636F6C756D6E735B6A5D5D207C7C20272729293B0D0A2020202020202020202020202020202074722E617070656E644368696C64287464';
wwv_flow_api.g_varchar2_table(11) := '293B0D0A2020202020202020202020207D0D0A2020202020202020202020207461626C652E617070656E644368696C64287472293B0D0A20202020202020207D0D0A202020202020202072657475726E207461626C653B0D0A202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(12) := '20202F2F204164647320612068656164657220726F7720746F20746865207461626C6520616E642072657475726E732074686520736574206F6620636F6C756D6E732E0D0A202020202F2F204E65656420746F20646F20756E696F6E206F66206B657973';
wwv_flow_api.g_varchar2_table(13) := '2066726F6D20616C6C207265636F72647320617320736F6D65207265636F726473206D6179206E6F7420636F6E7461696E0D0A202020202F2F20616C6C207265636F7264730D0A2020202066756E6374696F6E20616464416C6C436F6C756D6E48656164';
wwv_flow_api.g_varchar2_table(14) := '657273286172722C207461626C6529207B0D0A202020202020202076617220636F6C756D6E536574203D205B5D2C0D0A2020202020202020202020207472203D205F74725F2E636C6F6E654E6F64652866616C7365293B0D0A2020202020202020666F72';
wwv_flow_api.g_varchar2_table(15) := '20287661722069203D20302C206C203D206172722E6C656E6774683B2069203C206C3B20692B2B29207B0D0A202020202020202020202020666F722028766172206B657920696E206172725B695D29207B0D0A2020202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(16) := '6620286172725B695D2E6861734F776E50726F7065727479286B65792920262620636F6C756D6E5365742E696E6465784F66286B657929203D3D3D202D3129207B0D0A2020202020202020202020202020202020202020636F6C756D6E5365742E707573';
wwv_flow_api.g_varchar2_table(17) := '68286B6579293B0D0A2020202020202020202020202020202020202020766172207468203D205F74685F2E636C6F6E654E6F64652866616C7365293B0D0A202020202020202020202020202020202020202074682E617070656E644368696C6428646F63';
wwv_flow_api.g_varchar2_table(18) := '756D656E742E637265617465546578744E6F6465286B657929293B0D0A202020202020202020202020202020202020202074722E617070656E644368696C64287468293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(19) := '207D0D0A20202020202020207D0D0A20202020202020207461626C652E617070656E644368696C64287472293B0D0A202020202020202072657475726E20636F6C756D6E5365743B0D0A202020207D0D0A0D0A2020202066756E6374696F6E2064697374';
wwv_flow_api.g_varchar2_table(20) := '696E637450616765732861727229207B0D0A20202020202020202F2F20476574732044697374696E63742050616765730D0A2020202020202020766172206C6F6F6B7570203D207B7D3B0D0A2020202020202020766172206974656D73203D206172723B';
wwv_flow_api.g_varchar2_table(21) := '0D0A202020202020202076617220726573756C74203D205B5D3B0D0A2020202020202020666F722028766172206974656D2C2069203D20303B206974656D203D206974656D735B692B2B5D3B29207B0D0A202020202020202020202020766172206E616D';
wwv_flow_api.g_varchar2_table(22) := '65203D206974656D2E506167653B0D0A0D0A2020202020202020202020206966202821286E616D6520696E206C6F6F6B75702929207B0D0A202020202020202020202020202020206C6F6F6B75705B6E616D655D203D20313B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(23) := '20202020202020726573756C742E70757368286E616D65293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020202020202072657475726E20726573756C742E7265766572736528293B0D0A202020207D0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(24) := '66756E6374696F6E20637573746F6D6973655461626C652829207B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E652074722E64617461526F7722292E656163682866756E6374696F6E202829207B0D0A0D0A';
wwv_flow_api.g_varchar2_table(25) := '202020202020202020202020766172202474686973203D20242874686973293B0D0A20202020202020202020202076617220634E616D65203D2024746869732E66696E64282274643A6E74682D6368696C6428322922293B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '2020766172206343617465676F7279203D2024746869732E66696E64282274643A6E74682D6368696C6428332922293B0D0A202020202020202020202020766172206343617465676F727948203D2024746869732E66696E64282274643A6E74682D6368';
wwv_flow_api.g_varchar2_table(27) := '696C6428332922292E68746D6C28293B0D0A202020202020202020202020766172206C6173744368696C6448203D2024746869732E66696E64282274643A6C6173742D6368696C6422292E68746D6C28293B0D0A0D0A2020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(28) := '2048696464656E203D20426F6C640D0A202020202020202020202020696620282821634E616D652E686173436C61737328227072657469757352657665616C6572417474656E74696F6E2229292026262028747970656F6620286343617465676F727948';
wwv_flow_api.g_varchar2_table(29) := '2920213D2027756E646566696E656427202626206343617465676F7279482E746F537472696E6728292E73746172747357697468282248494444454E22292929207B0D0A20202020202020202020202020202020634E616D652E616464436C6173732822';
wwv_flow_api.g_varchar2_table(30) := '7072657469757352657665616C6572417474656E74696F6E22293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F204E6F6E2052656E6465726564203D20426F6C640D0A202020202020202020202020696620282821';
wwv_flow_api.g_varchar2_table(31) := '634E616D652E686173436C61737328227072657469757352657665616C65724E6F6E52656E64657265642229292026262028747970656F6620286C6173744368696C64482920213D2027756E646566696E656427202626206C6173744368696C64482E74';
wwv_flow_api.g_varchar2_table(32) := '6F537472696E6728292E696E636C7564657328224E5222292929207B0D0A20202020202020202020202020202020634E616D652E616464436C61737328227072657469757352657665616C65724E6F6E52656E646572656422293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(33) := '202020202020202020634E616D652E6174747228277469746C65272C20274E6F6E2D52656E6465726564204974656D27293B0D0A2020202020202020202020207D0D0A0D0A20202020202020207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E';
wwv_flow_api.g_varchar2_table(34) := '6374696F6E2064697374696E637447726F75707328705061676529207B0D0A202020202020202076617220726573756C74203D205B5D3B0D0A20202020202020207661722063617465676F72794172726179203D205B225058222C20225049222C202250';
wwv_flow_api.g_varchar2_table(35) := '30222C2022504F222C20224952222C20224947222C20224149222C20225342222C20224358222C20224657222C20224150222C2022414C4C225D3B0D0A20202020202020207661722063686B53426F78203D20242827237072657469757352657665616C';
wwv_flow_api.g_varchar2_table(36) := '6572496E6C696E65202372536561726368426F7827292E76616C28292E746F55707065724361736528293B0D0A0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E74';
wwv_flow_api.g_varchar2_table(37) := '657222292E74657874282727293B0D0A2020202020202020242822237072657469757352657665616C6572496E6C696E65202E6E6F74696669636174696F6E2D636F756E74657222292E72656D6F7665436C61737328226E6F74696669636174696F6E2D';
wwv_flow_api.g_varchar2_table(38) := '636F756E74657222293B0D0A0D0A202020202020202066756E6374696F6E20676574436F756E7428704361746529207B0D0A20202020202020202020202076617220746F74616C43617465203D20303B0D0A202020202020202020202020242822237072';
wwv_flow_api.g_varchar2_table(39) := '657469757352657665616C6572496E6C696E652074722E64617461526F7722292E656163682866756E6374696F6E202829207B0D0A0D0A20202020202020202020202020202020766172202474686973203D20242874686973293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(40) := '20202020202020202076617220746450616765203D2024746869732E66696E64282274643A666972737422292E68746D6C28293B0D0A2020202020202020202020202020202076617220746443617465203D2024746869732E66696E64282274643A6C61';
wwv_flow_api.g_varchar2_table(41) := '737422292E68746D6C28293B0D0A202020202020202020202020202020207661722074644E616D6556616C756573203D2024746869732E66696E64282274643A6E74682D6368696C6428322922292E68746D6C2829202B20272027202B0D0A2020202020';
wwv_flow_api.g_varchar2_table(42) := '20202020202020202020202020202024746869732E66696E64282274643A6E74682D6368696C6428332922292E68746D6C2829202B20272027202B0D0A202020202020202020202020202020202020202024746869732E66696E64282274643A6E74682D';
wwv_flow_api.g_varchar2_table(43) := '6368696C6428342922292E68746D6C2829202B20272027202B0D0A202020202020202020202020202020202020202024746869732E66696E64282274643A6E74682D6368696C6428352922292E68746D6C28293B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(44) := '202074644E616D6556616C756573203D2074644E616D6556616C7565732E746F537472696E6728292E746F55707065724361736528293B0D0A0D0A2020202020202020202020202020202069662028285B70506167652C20272A275D2E696E6465784F66';
wwv_flow_api.g_varchar2_table(45) := '2874645061676529203E202D31207C7C207050616765203D3D2027416C6C27292026260D0A2020202020202020202020202020202020202020747970656F6620287464436174652920213D2027756E646566696E6564272026260D0A2020202020202020';
wwv_flow_api.g_varchar2_table(46) := '2020202020202020202020207464436174652E73706C697428222C22292E696E6465784F6628704361746529203E3D20302026260D0A20202020202020202020202020202020202020202874644E616D6556616C7565732E696E6465784F662863686B53';
wwv_flow_api.g_varchar2_table(47) := '426F782920213D3D202D31290D0A2020202020202020202020202020202029207B0D0A2020202020202020202020202020202020202020746F74616C43617465203D20746F74616C43617465202B20313B0D0A202020202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(48) := '0D0A0D0A2020202020202020202020202020202069662028285B70506167652C20272A275D2E696E6465784F662874645061676529203E202D31207C7C207050616765203D3D2027416C6C27290D0A202020202020202020202020202020202020202026';
wwv_flow_api.g_varchar2_table(49) := '26207043617465203D3D2027414C4C272026260D0A2020202020202020202020202020202020202020747970656F6620287464436174652920213D2027756E646566696E6564272026260D0A202020202020202020202020202020202020202074644361';
wwv_flow_api.g_varchar2_table(50) := '746520213D202743617465676F7279272026260D0A20202020202020202020202020202020202020202874644E616D6556616C7565732E696E6465784F662863686B53426F782920213D3D202D31290D0A2020202020202020202020202020202029207B';
wwv_flow_api.g_varchar2_table(51) := '0D0A2020202020202020202020202020202020202020746F74616C43617465203D20746F74616C43617465202B20313B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '72657475726E20746F74616C436174653B0D0A20202020202020207D0D0A0D0A2020202020202020666F7220287661722069203D20303B2069203C2063617465676F727941727261792E6C656E6774683B20692B2B29207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '20207661722063203D2063617465676F727941727261795B695D3B0D0A2020202020202020202020207661722063617465436F756E74203D20676574436F756E742863293B0D0A2020202020202020202020206966202863617465436F756E74203E2030';
wwv_flow_api.g_varchar2_table(54) := '29207B0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E65202322202B2063202B2022636F756E74657222292E616464436C61737328226E6F74696669636174696F6E2D636F756E74657222292E';
wwv_flow_api.g_varchar2_table(55) := '746578742863617465436F756E74293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A202020202020202072657475726E20726573756C743B0D0A202020207D0D0A0D0A2020202066756E6374696F6E207061676544656C69';
wwv_flow_api.g_varchar2_table(56) := '6D657465642829207B0D0A2020202020202020766172207061676544656C696D65746564203D20242822237072657469757352657665616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F775374657049645D';
wwv_flow_api.g_varchar2_table(57) := '3A636865636B656422292E76616C28293B0D0A2020202020202020696620287061676544656C696D65746564203D3D2027416C6C2729207B0D0A2020202020202020202020207061676544656C696D65746564203D202428272370726574697573526576';
wwv_flow_api.g_varchar2_table(58) := '65616C6572496E6C696E6520237072657469757350616765436F6E74726F6C7327292E6174747228276A757374506167657327293B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A202020202020202020202020706167654465';
wwv_flow_api.g_varchar2_table(59) := '6C696D65746564203D20273A27202B207061676544656C696D65746564202B20273A273B0D0A20202020202020207D0D0A202020202020202072657475726E207061676544656C696D657465643B0D0A202020207D0D0A0D0A2020202066756E6374696F';
wwv_flow_api.g_varchar2_table(60) := '6E20676574446562756756696577436F6E74656E742829207B0D0A0D0A20202020202020202F2F2064656163746976617465206465627567207768656E2072657665616C65722067657474696E6720646174610D0A202020202020202024282723707265';
wwv_flow_api.g_varchar2_table(61) := '7469757352657665616C6572496E6C696E65202372536561726368426F7827292E76616C282727293B0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E706C75';
wwv_flow_api.g_varchar2_table(62) := '67696E287064742E6F70742E616A61784964656E7469666965722C207B0D0A2020202020202020202020207830313A202744454255475F56494557272C0D0A2020202020202020202020207830323A207061676544656C696D6574656428290D0A202020';
wwv_flow_api.g_varchar2_table(63) := '20202020207D2C207B0D0A202020202020202020202020737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(64) := '202020202020202020242827237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E7427292E656D70747928293B0D0A2020202020202020202020202020202024282723707265746975735265766561';
wwv_flow_api.g_varchar2_table(65) := '6C6572496E6C696E652023707265746975734465627567436F6E74656E7427292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528646174612E6974656D7329293B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(66) := '2020726F775374726F6B657328293B0D0A0D0A202020202020202020202020202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F363135353332320D0A202020202020202020202020202020202F2F20476574206669';
wwv_flow_api.g_varchar2_table(67) := '72737420636F6C756D6E0D0A20202020202020202020202020202020242822237072657469757352657665616C6572496E6C696E652023707265746975734465627567436F6E74656E74202E74645461626C6F636B566172733A66697273742D6368696C';
wwv_flow_api.g_varchar2_table(68) := '6422292E656163682866756E6374696F6E20286549647829207B0D0A0D0A20202020202020202020202020202020202020207661722061203D20242874686973293B0D0A2020202020202020202020202020202020202020242861292E616464436C6173';
wwv_flow_api.g_varchar2_table(69) := '7328276C696E6B4C696B6527293B0D0A0D0A2020202020202020202020202020202020202020696620286129207B0D0A202020202020202020202020202020202020202020202020612E6F6E2822636C69636B222C2066756E6374696F6E20286576656E';
wwv_flow_api.g_varchar2_table(70) := '7429207B0D0A2020202020202020202020202020202020202020202020202020202067657444656275675669657744657461696C28242861292E746578742829293B0D0A2020202020202020202020202020202020202020202020207D293B0D0A202020';
wwv_flow_api.g_varchar2_table(71) := '20202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020706572666F726D46696C74657228293B0D0A0D0A2020202020202020202020207D2C0D0A202020';
wwv_flow_api.g_varchar2_table(72) := '2020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A202020202020202020202020202020202F2F2068616E646C65206572726F720D0A202020202020';
wwv_flow_api.g_varchar2_table(73) := '202020202020202020207064742E616A61784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A202020207D';
wwv_flow_api.g_varchar2_table(74) := '0D0A0D0A0D0A2020202066756E6374696F6E2067657444656275675669657744657461696C2870566965774964656E74696669657229207B0D0A0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E6520237253656172';
wwv_flow_api.g_varchar2_table(75) := '6368426F7827292E76616C282727293B0D0A20202020202020207064742E636C6F616B44656275674C6576656C28293B0D0A0D0A2020202020202020617065782E7365727665722E706C7567696E287064742E6F70742E616A61784964656E7469666965';
wwv_flow_api.g_varchar2_table(76) := '722C207B0D0A2020202020202020202020207830313A202744454255475F44455441494C272C0D0A2020202020202020202020207830323A2070566965774964656E7469666965720D0A20202020202020207D2C207B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '737563636573733A2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020207064742E756E436C6F616B44656275674C6576656C28293B0D0A202020202020202020202020202020202428272370726574697573526576';
wwv_flow_api.g_varchar2_table(78) := '65616C6572496E6C696E652023707265746975734465627567436F6E74656E7427292E656D70747928293B0D0A20202020202020202020202020202020242827237072657469757352657665616C6572496E6C696E652023707265746975734465627567';
wwv_flow_api.g_varchar2_table(79) := '436F6E74656E7427292E617070656E64287072657469757352657665616C65722E6275696C6448746D6C5461626C6528646174612E6974656D7329293B0D0A20202020202020202020202020202020726F775374726F6B657328293B200D0A2020202020';
wwv_flow_api.g_varchar2_table(80) := '202020202020207D2C0D0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0D0A202020202020202020202020202020202F2F2068616E646C65';
wwv_flow_api.g_varchar2_table(81) := '206572726F720D0A202020202020202020202020202020207064742E616A61784572726F7248616E646C6572286A715848522C20746578745374617475732C206572726F725468726F776E293B0D0A2020202020202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(82) := '20207D293B0D0A0D0A202020207D0D0A0D0A2020202066756E6374696F6E20726F775374726F6B65732829207B0D0A20202020202020202F2F2041646420416C7465726E61746520526F77207374726F6B65730D0A202020202020202024282723707265';
wwv_flow_api.g_varchar2_table(83) := '7469757352657665616C6572496E6C696E65202E616C7465726E6174652D726F77732D746C27292E72656D6F7665436C6173732827616C7465726E6174652D726F77732D746C27293B0D0A2020202020202020242827237072657469757352657665616C';
wwv_flow_api.g_varchar2_table(84) := '6572496E6C696E65202E7461626C655461626C6F636B5661727320747227292E66696C7465722866756E6374696F6E202829207B0D0A20202020202020202020202072657475726E20242874686973292E63737328277669736962696C6974792729203D';
wwv_flow_api.g_varchar2_table(85) := '3D202776697369626C65273B0D0A20202020202020207D292E66696C74657228273A6F646427292E616464436C6173732827616C7465726E6174652D726F77732D746C27293B0D0A202020207D0D0A0D0A2020202066756E6374696F6E20706572666F72';
wwv_flow_api.g_varchar2_table(86) := '6D46696C7465722829207B0D0A0D0A202020202020202076617220686964655061676556616C7565466F72203D205B225342222C20224358222C20224149222C20224150225D3B0D0A2020202020202020766172206869646553657373696F6E56616C75';
wwv_flow_api.g_varchar2_table(87) := '65466F72203D205B224657222C20224952222C20224947225D3B0D0A2020202020202020766172206A71507265666578203D2027273B0D0A0D0A20202020202020207661722063686B50616765203D20242822237072657469757352657665616C657249';
wwv_flow_api.g_varchar2_table(88) := '6E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D70466C6F775374657049645D3A636865636B656422292E76616C28293B0D0A20202020202020207661722063686B43617465203D20242822237072657469757352657665616C65';
wwv_flow_api.g_varchar2_table(89) := '72496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A636865636B656422292E76616C28293B0D0A20202020202020207661722063686B53426F78203D20242827237072657469757352657665616C65';
wwv_flow_api.g_varchar2_table(90) := '72496E6C696E65202372536561726368426F7827292E76616C28292E746F55707065724361736528293B0D0A0D0A2020202020202020766172205061676553656C656374656441626F7665203D202428226C6162656C5B666F723D275061676553656C65';
wwv_flow_api.g_varchar2_table(91) := '6374656441626F7665275D22293B0D0A20202020202020205061676553656C656374656441626F76652E68746D6C28225022202B2063686B506167652E73706C697428225F22295B305D202B20273C7370616E2069643D225058636F756E746572223E3C';
wwv_flow_api.g_varchar2_table(92) := '2F7370616E3E27293B0D0A20202020202020205061676553656C656374656441626F76652E72656D6F7665436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A0D0A202020202020202024282723707265746975735265766561';
wwv_flow_api.g_varchar2_table(93) := '6C6572496E6C696E65207461626C652E7461626C655461626C6F636B5661727320747220746827292E73686F7728293B0D0A2020202020202020242827237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F';
wwv_flow_api.g_varchar2_table(94) := '636B5661727320747220746427292E73686F7728293B0D0A0D0A20202020202020206966202863686B43617465203D3D20274465627567506167652729207B0D0A2020202020202020202020206A71507265666578203D20272370726574697573526576';
wwv_flow_api.g_varchar2_table(95) := '65616C6572496E6C696E652023707265746975734465627567436F6E74656E74273B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573436F6E74656E7427292E6869646528293B0D';
wwv_flow_api.g_varchar2_table(96) := '0A20202020202020202020202024286A71507265666578292E73686F7728293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206A71507265666578203D2027237072657469757352657665616C6572496E6C696E652023';
wwv_flow_api.g_varchar2_table(97) := '70726574697573436F6E74656E74273B0D0A20202020202020202020202024286A71507265666578292E73686F7728293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65202370726574697573446562';
wwv_flow_api.g_varchar2_table(98) := '7567436F6E74656E7427292E6869646528293B0D0A20202020202020207D0D0A0D0A0D0A20202020202020206966202863686B50616765203D3D2027416C6C2729207B0D0A2020202020202020202020205061676553656C656374656441626F76652E61';
wwv_flow_api.g_varchar2_table(99) := '6464436C61737328277377697463682D646973706C61792D6E6F6E6527293B0D0A2020202020202020202020206966202863686B43617465203D3D202750582729207B0D0A20202020202020202020202020202020242822237072657469757352657665';
wwv_flow_api.g_varchar2_table(100) := '616C6572496E6C696E6520696E7075745B747970653D726164696F5D5B6E616D653D7043617465676F72795D3A666972737422292E747269676765722822636C69636B22293B0D0A2020202020202020202020202020202072657475726E3B0D0A202020';
wwv_flow_api.g_varchar2_table(101) := '2020202020202020207D0D0A20202020202020207D0D0A0D0A202020202020202069662028686964655061676556616C7565466F722E696E636C756465732863686B436174652929207B0D0A202020202020202020202020242827237072657469757352';
wwv_flow_api.g_varchar2_table(102) := '657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074683A6E74682D6368696C6428342927292E6869646528293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E';
wwv_flow_api.g_varchar2_table(103) := '6C696E65207461626C652E7461626C655461626C6F636B566172732074722074643A6E74682D6368696C6428342927292E6869646528293B0D0A20202020202020207D0D0A0D0A2020202020202020696620286869646553657373696F6E56616C756546';
wwv_flow_api.g_varchar2_table(104) := '6F722E696E636C756465732863686B436174652929207B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074683A6E74682D6368696C';
wwv_flow_api.g_varchar2_table(105) := '6428352927292E6869646528293B0D0A202020202020202020202020242827237072657469757352657665616C6572496E6C696E65207461626C652E7461626C655461626C6F636B566172732074722074643A6E74682D6368696C6428352927292E6869';
wwv_flow_api.g_varchar2_table(106) := '646528293B0D0A20202020202020207D0D0A0D0A202020202020202024286A71507265666578202B20222074722E64617461526F773A6E6F74283A66697273742922292E63737328227669736962696C697479222C2022636F6C6C6170736522293B0D0A';
wwv_flow_api.g_varchar2_table(107) := '202020202020202024286A71507265666578202B20222074722E64617461526F7722292E656163682866756E6374696F6E202829207B0D0A0D0A202020202020202020202020766172202474686973203D20242874686973293B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(108) := '2020202076617220746450616765203D2024746869732E66696E64282274643A666972737422292E68746D6C28293B0D0A20202020202020202020202076617220746443617465203D2024746869732E66696E64282274643A6C61737422292E68746D6C';
wwv_flow_api.g_varchar2_table(109) := '28293B0D0A0D0A202020202020202020202020766172206669656C6453656C6563746F72203D20277464273B0D0A0D0A2020202020202020202020206966202863686B4361746520213D20274465627567506167652729207B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(110) := '202020202020206669656C6453656C6563746F72203D202774643A6E6F74283A66697273742C203A6C61737429273B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020207661722074644E616D6556616C756573203D20247468';
wwv_flow_api.g_varchar2_table(111) := '69732E66696E64286669656C6453656C6563746F72292E6D61702866756E6374696F6E202829207B0D0A2020202020202020202020202020202072657475726E20242874686973292E7465787428293B0D0A2020202020202020202020207D292E676574';
wwv_flow_api.g_varchar2_table(112) := '28292E6A6F696E28272027292E746F55707065724361736528293B0D0A0D0A2020202020202020202020206966202863686B43617465203D3D20274465627567506167652729207B0D0A20202020202020202020202020202020696620280D0A20202020';
wwv_flow_api.g_varchar2_table(113) := '202020202020202020202020202020202863686B53426F78203D3D202727207C7C2074644E616D6556616C7565732E696E6465784F662863686B53426F782920213D3D202D31290D0A2020202020202020202020202020202029207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(114) := '202020202020202020202020202024746869732E63737328227669736962696C697479222C202276697369626C6522293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D20656C7365207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(115) := '202020202020202069662028285B63686B506167652C20272A275D2E696E6465784F662874645061676529203E202D31207C7C2063686B50616765203D3D2027416C6C27292026260D0A202020202020202020202020202020202020202028747970656F';
wwv_flow_api.g_varchar2_table(116) := '66202874644361746529203D3D2027756E646566696E656427207C7C0D0A2020202020202020202020202020202020202020202020207464436174652E73706C697428222C22292E696E6465784F662863686B4361746529203E3D2030207C7C0D0A2020';
wwv_flow_api.g_varchar2_table(117) := '2020202020202020202020202020202020202020202063686B43617465203D3D2027416C6C27292026260D0A20202020202020202020202020202020202020202874644E616D6556616C7565732E696E6465784F662863686B53426F782920213D3D202D';
wwv_flow_api.g_varchar2_table(118) := '31290D0A2020202020202020202020202020202029207B0D0A202020202020202020202020202020202020202024746869732E63737328227669736962696C697479222C202276697369626C6522293B0D0A202020202020202020202020202020207D0D';
wwv_flow_api.g_varchar2_table(119) := '0A2020202020202020202020207D0D0A0D0A20202020202020207D293B0D0A0D0A20202020202020202F2F2041646420546F74616C730D0A202020202020202064697374696E637447726F7570732863686B50616765293B0D0A2020202020202020726F';
wwv_flow_api.g_varchar2_table(120) := '775374726F6B657328293B0D0A0D0A202020207D0D0A0D0A2020202072657475726E207B0D0A2020202020202020706572666F726D46696C7465723A20706572666F726D46696C7465722C0D0A202020202020202064697374696E637447726F7570733A';
wwv_flow_api.g_varchar2_table(121) := '2064697374696E637447726F7570732C0D0A20202020202020206275696C6448746D6C5461626C653A206275696C6448746D6C5461626C652C0D0A2020202020202020637573746F6D6973655461626C653A20637573746F6D6973655461626C652C0D0A';
wwv_flow_api.g_varchar2_table(122) := '202020202020202064697374696E637450616765733A2064697374696E637450616765732C0D0A2020202020202020676574446562756756696577436F6E74656E743A20676574446562756756696577436F6E74656E742C0D0A20202020202020207061';
wwv_flow_api.g_varchar2_table(123) := '676544656C696D657465643A207061676544656C696D657465640D0A202020207D0D0A0D0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(135226584824973950)
,p_plugin_id=>wwv_flow_api.id(5301589844662579)
,p_file_name=>'revealer.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
