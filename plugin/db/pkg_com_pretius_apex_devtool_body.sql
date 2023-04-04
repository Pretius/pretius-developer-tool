create or replace PACKAGE BODY pkg_com_pretius_apex_devtool
IS
   /*
    * Plugin:   Pretius Developer Tool
    * Version:  22.2.3
    *
    * License:  MIT License Copyright 2022 Pretius Sp. z o.o. Sp. K.
    * Homepage: 
    * Mail:     apex-plugins@pretius.com
    * Issues:   https://github.com/Pretius/pretius-developer-tool/issues
    *
    * Author:   Matt Mulvaney
    * Mail:     mmulvaney@pretius.com
    * Twitter:  Matt_Mulvaney
    *
    */
  FUNCTION render(
    p_dynamic_action IN apex_plugin.t_dynamic_action,
    p_plugin         IN apex_plugin.t_plugin 
  ) RETURN apex_plugin.t_dynamic_action_render_result
  IS
    v_result              apex_plugin.t_dynamic_action_render_result; 
    l_plugs_row           APEX_APPL_PLUGINS%ROWTYPE;
    l_configuration_test  NUMBER DEFAULT 0;
    c_plugin_name         CONSTANT VARCHAR2(24) DEFAULT 'COM.PRETIUS.APEX.DEVTOOL';
    l_application_group   apex_applications.application_group%TYPE DEFAULT NULL;
    c_app_id              CONSTANT apex_applications.application_id%TYPE DEFAULT v('APP_ID');
  BEGIN
    -- Debug
    IF apex_application.g_debug 
    THEN
      apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,
                                            p_dynamic_action => p_dynamic_action);
    END IF;
    SELECT *
      INTO l_plugs_row
      FROM apex_appl_plugins
     WHERE application_id = c_app_id
       AND name = c_plugin_name;

      SELECT application_group
        INTO l_application_group
        FROM apex_applications
       WHERE application_id = c_app_id;

    SELECT count(*)
     INTO l_configuration_test
     from APEX_APPLICATION_PAGE_DA_ACTS a,
          APEX_APPLICATION_PAGE_DA d,
          apex_application_build_options b
    where a.application_id = c_app_id 
      and a.page_id = 0
      and a.action_code = 'PLUGIN_' || c_plugin_name
      and d.dynamic_action_id = a.dynamic_action_id
      and d.build_option_id = b.build_option_id
      and b.status_on_export = 'Exclude';

    IF NVL( l_configuration_test, 0 ) = 0
    THEN
      SELECT count(*)
      INTO l_configuration_test
      from APEX_APPLICATION_PAGE_DA_ACTS a,
            apex_application_build_options b
      where a.application_id = c_app_id 
        and a.page_id = 0
        and a.action_code = 'PLUGIN_' || c_plugin_name
        and a.build_option_id = b.build_option_id
        and b.status_on_export = 'Exclude';
    END IF;

    v_result.javascript_function := 
    apex_string.format(
    q'[function render() {
        pdt.render({
            da: this,
            opt: {
                filePrefix: "%s",
                ajaxIdentifier: "%s",
                version: "%s",
                debugPrefix: "%s",
                configurationTest: "%s",
                dynamicActionId: "%s",
                applicationGroupName: "%s",
                env: {
                    APP_ID: "%s",
                    APP_PAGE_ID: "%s"
                    }
                }
            });
        }]',
    p_plugin.file_prefix,
    apex_plugin.get_ajax_identifier,
    l_plugs_row.version_identifier,
    l_plugs_row.display_name || ': ',
    apex_debug.tochar( l_configuration_test = 1 ),
    p_dynamic_action.id,
    NVL( l_application_group, '- Unassigned -'  ),
    c_app_id,
    v('APP_PAGE_ID')
    );
 
    RETURN v_result;
  
  EXCEPTION
    WHEN OTHERS then
      htp.p( SQLERRM );
      return v_result;
  END render;
  PROCEDURE ajax_build_option_excluded
  IS
    c sys_refcursor;
  BEGIN
    OPEN c for
     WITH ITEMS AS 
     (
      SELECT i.item_name,  
             b.build_option_name,
             'ITEM' page_item_type,
             regexp_replace(i.BUILD_OPTION_ID, '[0-9]' ) || b.status_on_export status
        FROM apex_application_page_items i,
             apex_application_build_options b
       WHERE i.application_id = v('APP_ID')
         AND i.page_id IN ( v('APP_PAGE_ID'), 0 )
         AND LTRIM(i.BUILD_OPTION_ID,'-') = b.build_option_id ),
    REGIONS AS  
 (     SELECT NVL( i.static_id, 'R' || region_id ) item_name,  
             b.build_option_name,
             'REGION' page_item_type,
             regexp_replace(i.BUILD_OPTION_ID, '[0-9]' ) || b.status_on_export status
        FROM apex_application_page_regions i,
             apex_application_build_options b
       WHERE i.application_id = v('APP_ID')
         AND i.page_id IN ( v('APP_PAGE_ID'), 0 )
         AND LTRIM(i.BUILD_OPTION_ID,'-') = b.build_option_id ),
    IG_COLS AS
    (
    SELECT NVL2( i.static_id, i.static_id || '_HDR', 'R' || column_id || '_ig_grid_vc_cur' ) item_name,  
             b.build_option_name,
             'IG_COL' page_item_type,
             regexp_replace(i.BUILD_OPTION_ID, '[0-9]' ) || b.status_on_export status
        FROM APEX_APPL_PAGE_IG_COLUMNS i,
             apex_application_build_options b
       WHERE i.application_id = v('APP_ID')
         AND i.page_id IN ( v('APP_PAGE_ID'), 0 )
         AND LTRIM(i.BUILD_OPTION_ID,'-') = b.build_option_id ),
    IR_COLS AS
 (     SELECT NVL( i.static_id, 'C' || column_id ) item_name,  
             b.build_option_name,
             'IR_COL' page_item_type,
             regexp_replace(i.BUILD_OPTION_ID, '[0-9]' ) || b.status_on_export status
        FROM apex_application_page_ir_col i,
             apex_application_build_options b
       WHERE i.application_id = v('APP_ID')
         AND i.page_id IN ( v('APP_PAGE_ID'), 0 )
         AND LTRIM(i.BUILD_OPTION_ID,'-') = b.build_option_id ),
    BUTTONS AS  
 (     SELECT NVL( button_static_id, 'B' || button_id )  item_name,  
             b.build_option_name,
             'BUTTON' page_item_type,
             REPLACE( RTRIM(REPLACE(  i.build_option, '{Not ' || b.build_option_name, '-'), '}') , b.build_option_name ) || b.status_on_export status
        FROM apex_application_page_buttons i,
             apex_application_build_options b
       WHERE i.application_id = v('APP_ID')
         AND i.page_id IN ( v('APP_PAGE_ID'), 0 )
         AND  i.build_option  IN ( '{Not ' || b.build_option_name || '}',  b.build_option_name  )
          )
    SELECT item_name,
           build_option_name,
           page_item_type,
           CASE status 
             WHEN '-Include'
               THEN 'Exlude'
             WHEN '-Exlude'
               THEN 'Include'
             ELSE 
               status
             END status
        FROM ( 
              SELECT * FROM items 
               UNION ALL
               SELECT * FROM regions 
               UNION ALL
               SELECT * FROM buttons
               UNION ALL
               SELECT * FROM ir_cols 
               UNION ALL
               SELECT * FROM ig_cols
               );
    apex_json.open_object;
    apex_json.write( 'items', c);
    apex_json.close_object;  
  END ajax_build_option_excluded;
  PROCEDURE ajax_debug_detail
  IS
    c sys_refcursor;
  BEGIN
    OPEN c for
        select elapsed_time "Elapsed",
            execution_time "Execution",
            message "Message",
            message_level "Level",
            TO_CHAR( ROUND(RATIO_TO_REPORT(NVL(execution_time, 0)) OVER () * 100, 1 ), '990.00' ) AS "Ratio"
        from APEX_DEBUG_MESSAGES  
        where  page_view_id = apex_application.g_x02 
        order by  message_timestamp, id;
    apex_json.open_object;
    apex_json.write( 'items', c);
    apex_json.close_object; 
  END ajax_debug_detail;
  PROCEDURE ajax_debug_view
  IS
    c sys_refcursor;
  BEGIN
    OPEN c for
       with data as ( select 
            PAGE_VIEW_ID, 
            session_id,
            max(apex_user) apex_user,
            application_id,
            page_id,
            max(MESSAGE_TIMESTAMP) - min(MESSAGE_TIMESTAMP) diff,
            max(MESSAGE_TIMESTAMP) max_timestamp,
            count(id) entries
        from APEX_DEBUG_MESSAGES 
        where INSTR( apex_application.g_x02, ':' || page_id || ':' ) > 0
        and application_id = v('APP_ID')
        group by 
            PAGE_VIEW_ID, 
            session_id, 
            application_id,
            page_id
        ),
        prepared as (
        select  
            d.PAGE_VIEW_ID "View Identifier",
            d.session_id "Session Id",
            d.apex_user "User",
            d.application_id "Application",
            d.page_id "Page",
            CASE a.page_view_type 
            WHEN 'Ajax' THEN 'ajax plugin'
            WHEN 'Rendering' THEN 'show'
            WHEN 'Processing' THEN RTRIM( 'accept ' || a.REQUEST_VALUE )
            ELSE a.page_view_type 
            END "Path Info",
            d.entries "Entries",
            apex_util.get_since(d.max_timestamp) "Timestamp",
            to_char(
                extract( day from d.diff )*24*60*60*1000 +
                extract( hour from d.diff )*60*60*1000 +
                extract( minute from d.diff )*60*1000 +
                extract( second from d.diff ), '0.0000') "Seconds"
        from data d, 
             APEX_WORKSPACE_ACTIVITY_LOG a
      where d.page_view_id = debug_page_view_id
        order by max_timestamp desc )
        SELECT *
          FROM prepared 
        WHERE rownum <= 10;
    apex_json.open_object;
    apex_json.write( 'items', c);
    apex_json.close_object; 
  END ajax_debug_view;
  PROCEDURE ajax_revealer
  IS
    c sys_refcursor;
    l_subs_clob           CLOB DEFAULT NULL;
    l_host_address        VARCHAR2(512) DEFAULT NULL;
    l_host_name           VARCHAR2(512) DEFAULT NULL;
    PROCEDURE p_write( p_name VARCHAR2, p_value VARCHAR2 )
    IS
    BEGIN
        apex_json.open_object;
        apex_json.write('Name', p_name );
        apex_json.write('Value', p_value );
        apex_json.close_object;
    END p_write;
    FUNCTION f_get_host_address
    RETURN VARCHAR2
    IS
    BEGIN
       RETURN UTL_INADDR.get_host_address;
    EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '[Unavailable]';
    END f_get_host_address;
    FUNCTION f_get_host_name
    RETURN VARCHAR2
    IS
    BEGIN
       RETURN UTL_INADDR.GET_HOST_NAME(f_get_host_address);
    EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '[Unavailable]';
    END f_get_host_name;
  BEGIN
    l_host_address        := f_get_host_address;
    l_host_name           := f_get_host_name;
        apex_json.initialize_clob_output( p_preserve => true );
        apex_json.open_array; 
            p_write( 'APEX$ROW_NUM', v('APEX$ROW_NUM') );
            p_write( 'APEX$ROW_SELECTOR', v('APEX$ROW_SELECTOR') );
            p_write( 'APEX$ROW_STATUS', v('APEX$ROW_STATUS') );
            p_write( 'APP_ID', v('APP_ID') );
            p_write( 'APP_ALIAS', v('APP_ALIAS') );
            p_write( 'APP_AJAX_X01', v('APP_AJAX_X01') );
            p_write( 'APP_AJAX_X02', v('APP_AJAX_X02') );
            p_write( 'APP_AJAX_X03', v('APP_AJAX_X03') );
            p_write( 'APP_AJAX_X04', v('APP_AJAX_X04') );
            p_write( 'APP_AJAX_X05', v('APP_AJAX_X05') );
            p_write( 'APP_AJAX_X06', v('APP_AJAX_X06') );
            p_write( 'APP_AJAX_X07', v('APP_AJAX_X07') );
            p_write( 'APP_AJAX_X08', v('APP_AJAX_X08') );
            p_write( 'APP_AJAX_X09', v('APP_AJAX_X09') );
            p_write( 'APP_AJAX_X10', v('APP_AJAX_X10') );
            p_write( 'APP_BUILDER_SESSION', v('APP_BUILDER_SESSION') );
            p_write( 'APP_DATE_TIME_FORMAT', v('APP_DATE_TIME_FORMAT') );
            p_write( 'APP_IMAGES', v('APP_IMAGES') );
            p_write( 'APP_NLS_DATE_FORMAT', v('APP_NLS_DATE_FORMAT') );
            p_write( 'APP_NLS_TIMESTAMP_FORMAT', v('APP_NLS_TIMESTAMP_FORMAT') );
            p_write( 'APP_NLS_TIMESTAMP_TZ_FORMAT', v('APP_NLS_TIMESTAMP_TZ_FORMAT') );
            p_write( 'APP_PAGE_ALIAS', v('APP_PAGE_ALIAS') );
            p_write( 'APP_PAGE_ID', v('APP_PAGE_ID') );
            p_write( 'APP_REQUEST_DATA_HASH', v('APP_REQUEST_DATA_HASH') );
            p_write( 'APP_SESSION', v('APP_SESSION') );
            p_write( 'APP_SESSION_VISIBLE', v('APP_SESSION_VISIBLE') );
            p_write( 'APP_TITLE', v('APP_TITLE') );
            p_write( 'APP_UNIQUE_PAGE_ID', v('APP_UNIQUE_PAGE_ID') );
            p_write( 'APP_USER', v('APP_USER') );
            p_write( 'AUTHENTICATED_URL_PREFIX', v('AUTHENTICATED_URL_PREFIX') );
            p_write( 'BROWSER_LANGUAGE', v('BROWSER_LANGUAGE') );
            p_write( 'CURRENT_PARENT_TAB_TEXT', '&CURRENT_PARENT_TAB_TEXT.' );
            p_write( 'Vars', v('Vars') );
            p_write( 'DEBUG', v('DEBUG') );
            p_write( 'HOME_LINK', v('HOME_LINK') );
            p_write( 'IMAGE_PREFIX', v('IMAGE_PREFIX') );
            p_write( 'JET_BASE_DIRECTORY', '#JET_BASE_DIRECTORY#' );
            p_write( 'JET_CSS_DIRECTORY', '#JET_CSS_DIRECTORY#' );
            p_write( 'JET_JS_DIRECTORY', '#JET_JS_DIRECTORY#' );
            p_write( 'LOGIN_URL', v('LOGIN_URL') );
            p_write( 'LOGOUT_URL', v('LOGOUT_URL') );
            p_write( 'APP_TEXT$Message_Name', v('APP_TEXT$Message_Name') );
            p_write( 'APP_TEXT$Message_Name$Lang', v('APP_TEXT$Message_Name$Lang') );
            p_write( 'PRINTER_FRIENDLY', v('PRINTER_FRIENDLY') );
            p_write( 'PROXY_SERVER', APEX_APPLICATION.G_PROXY_SERVER );
            p_write( 'PUBLIC_URL_PREFIX', v('PUBLIC_URL_PREFIX') );
            p_write( 'REQUEST', v('REQUEST') );
            p_write( 'SCHEMA OWNER', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER );
            p_write( 'SQLERRM', '#SQLERRM#' );
            p_write( 'SYSDATE_YYYYMMDD', v('SYSDATE_YYYYMMDD') );
            p_write( 'THEME_DB_IMAGES', '#THEME_DB_IMAGES#' );
            p_write( 'THEME_IMAGES', '#THEME_IMAGES#' );
            p_write( 'WORKSPACE_IMAGES', v('WORKSPACE_IMAGES') );
            p_write( 'WORKSPACE_ID', v('WORKSPACE_ID') );        
        apex_json.close_array;
        l_subs_clob := apex_json.get_clob_output;
        apex_json.free_output;
    open c 
    for 
    with scrape as (
        select
            "Page",
            "Name",
            "Type",
            "Page Value",
            NVL(v("Name"), ' ' ) "Session Value",
            "Category"
        from xmltable(
            '/json/row'
            passing apex_json.to_xmltype_sql( apex_application.g_clob_01, 
                                            p_strict => 'N' )
            columns
            "Page" VARCHAR2(32) path 'Page/text()',
            "Name" VARCHAR2(128) path 'Name/text()',
            "Type" VARCHAR2(32) path 'Type/text()',
            "Page Value" VARCHAR2(4000) path 'Value/text()',
            "Category" VARCHAR2(32) path 'Category/text()'
        )),
        nonRenderedItems as (
            SELECT TO_CHAR( page_id ) page_id,
                   item_name
              FROM apex_application_page_items
             WHERE INSTR( apex_application.g_x02, ':' || page_id || ':' ) > 0
               AND application_id = v('APP_ID')
              MINUS
            SELECT "Page", 
                   "Name"
              FROM scrape
        ),
        nonRendered as (
             SELECT TO_CHAR(pi.page_id) "Page",
                    pi.item_name "Name",
                    TRIM( REPLACE( UPPER ( display_as ), 'FIELD' ) ) "Type",
                    NULL "Page Value",
                    NVL(v(pi.item_name), ' ' ) "Session Value",
                    'NR,PI,P' || CASE pi.page_id WHEN 0 THEN '0' ELSE 'X' END "Category"
               FROM apex_application_page_items pi,
                    nonRenderedItems nr
              WHERE pi.page_id = nr.page_id
                AND pi.item_name = nr.item_name
                AND pi.application_id = v('APP_ID')
        )
        SELECT * 
        from scrape
        UNION ALL
        SELECT * 
        from nonRendered
        UNION ALL
        SELECT '*',
            item_name,
            'APPLICATION ITEM',
            NULL,
            v(item_name),
            'AI'
        FROM apex_application_items
        WHERE application_id = v('APP_ID')
        UNION ALL
        SELECT '*',
            "Name",
            'APEX SUBSTITUTION',
            NULL,
            "Value",
            'SB'
        from xmltable(
            '/json/row'
            passing apex_json.to_xmltype_sql( l_subs_clob, 
                                            p_strict => 'N' )
            columns
            "Name" VARCHAR2(128) path 'Name/text()',
            "Value" VARCHAR2(4000) path 'Value/text()'
        )
        UNION ALL
        SELECT '*',
            SUBSTITUTION_STRING,
            'APPLICATION SUBSTITUTION',
            NULL,
            SUBSTITUTION_VALUE,
            'SB'
        FROM APEX_APPLICATION_SUBSTITUTIONS
        WHERE application_id = v('APP_ID')
        UNION ALL
        SELECT '*',
            name,
            'APEX',
            NULL,
            val,
            'AP'
        FROM ( SELECT *
                FROM   (SELECT version_no, 
                               api_compatibility, 
                               patch_applied
                          FROM apex_release)
                UNPIVOT (val for name in (version_no, api_compatibility, patch_applied) ) )
        UNION ALL
        SELECT '*',
            name,
            'DATABASE',
            NULL,
            val,
            'AP'
        FROM ( SELECT *
                FROM   (SELECT product, 
                            version,
                            status
                        FROM   product_component_version )
                UNPIVOT  (val for name in (product, version, status)  )
                UNION ALL
                SELECT 'GLOBAL_NAME' name, global_name FROM GLOBAL_NAME
                UNION ALL
                SELECT 'HOST_ADDRESS'name, l_host_address FROM dual
                UNION ALL
                SELECT 'HOST_NAME' name, l_host_name val FROM dual 
                )
        UNION ALL
        SELECT '*',
            name,
            'USERENV CONTEXT',
            NULL,
            val,
            'CX'
        FROM (
                -- https://stackoverflow.com/a/18879366
                select res.*
                from (
                select *
                    from (
                        select
                        sys_context ('userenv','ACTION') ACTION,
                        sys_context ('userenv','AUDITED_CURSORID') AUDITED_CURSORID,
                        sys_context ('userenv','AUTHENTICATED_IDENTITY') AUTHENTICATED_IDENTITY,
                        sys_context ('userenv','AUTHENTICATION_DATA') AUTHENTICATION_DATA,
                        sys_context ('userenv','AUTHENTICATION_METHOD') AUTHENTICATION_METHOD,
                        sys_context ('userenv','BG_JOB_ID') BG_JOB_ID,
                        sys_context ('userenv','CLIENT_IDENTIFIER') CLIENT_IDENTIFIER,
                        sys_context ('userenv','CLIENT_INFO') CLIENT_INFO,
                        sys_context ('userenv','CURRENT_BIND') CURRENT_BIND,
                        sys_context ('userenv','CURRENT_EDITION_ID') CURRENT_EDITION_ID,
                        sys_context ('userenv','CURRENT_EDITION_NAME') CURRENT_EDITION_NAME,
                        sys_context ('userenv','CURRENT_SCHEMA') CURRENT_SCHEMA,
                        sys_context ('userenv','CURRENT_SCHEMAID') CURRENT_SCHEMAID,
                        sys_context ('userenv','CURRENT_SQL') CURRENT_SQL,
                        sys_context ('userenv','CURRENT_SQLn') CURRENT_SQLn,
                        sys_context ('userenv','CURRENT_SQL_LENGTH') CURRENT_SQL_LENGTH,
                        sys_context ('userenv','CURRENT_USER') CURRENT_USER,
                        sys_context ('userenv','CURRENT_USERID') CURRENT_USERID,
                        sys_context ('userenv','DATABASE_ROLE') DATABASE_ROLE,
                        sys_context ('userenv','DB_DOMAIN') DB_DOMAIN,
                        sys_context ('userenv','DB_NAME') DB_NAME,
                        sys_context ('userenv','DB_UNIQUE_NAME') DB_UNIQUE_NAME,
                        sys_context ('userenv','DBLINK_INFO') DBLINK_INFO,
                        sys_context ('userenv','ENTRYID') ENTRYID,
                        sys_context ('userenv','ENTERPRISE_IDENTITY') ENTERPRISE_IDENTITY,
                        sys_context ('userenv','FG_JOB_ID') FG_JOB_ID,
                        sys_context ('userenv','GLOBAL_CONTEXT_MEMORY') GLOBAL_CONTEXT_MEMORY,
                        sys_context ('userenv','GLOBAL_UID') GLOBAL_UID,
                        sys_context ('userenv','HOST') HOST,
                        sys_context ('userenv','IDENTIFICATION_TYPE') IDENTIFICATION_TYPE,
                        sys_context ('userenv','INSTANCE') INSTANCE,
                        sys_context ('userenv','INSTANCE_NAME') INSTANCE_NAME,
                        sys_context ('userenv','IP_ADDRESS') IP_ADDRESS,
                        sys_context ('userenv','ISDBA') ISDBA,
                        sys_context ('userenv','LANG') LANG,
                        sys_context ('userenv','LANGUAGE') LANGUAGE,
                        sys_context ('userenv','MODULE') MODULE,
                        sys_context ('userenv','NETWORK_PROTOCOL') NETWORK_PROTOCOL,
                        sys_context ('userenv','NLS_CALENDAR') NLS_CALENDAR,
                        sys_context ('userenv','NLS_CURRENCY') NLS_CURRENCY,
                        sys_context ('userenv','NLS_DATE_FORMAT') NLS_DATE_FORMAT,
                        sys_context ('userenv','NLS_DATE_LANGUAGE') NLS_DATE_LANGUAGE,
                        sys_context ('userenv','NLS_SORT') NLS_SORT,
                        sys_context ('userenv','NLS_TERRITORY') NLS_TERRITORY,
                        sys_context ('userenv','OS_USER') OS_USER,
                        sys_context ('userenv','POLICY_INVOKER') POLICY_INVOKER,
                        sys_context ('userenv','PROXY_ENTERPRISE_IDENTITY') PROXY_ENTERPRISE_IDENTITY,
                        sys_context ('userenv','PROXY_USER') PROXY_USER,
                        sys_context ('userenv','PROXY_USERID') PROXY_USERID,
                        sys_context ('userenv','SERVER_HOST') SERVER_HOST,
                        sys_context ('userenv','SERVICE_NAME') SERVICE_NAME,
                        sys_context ('userenv','SESSION_EDITION_ID') SESSION_EDITION_ID,
                        sys_context ('userenv','SESSION_EDITION_NAME') SESSION_EDITION_NAME,
                        sys_context ('userenv','SESSION_USER') SESSION_USER,
                        sys_context ('userenv','SESSION_USERID') SESSION_USERID,
                        sys_context ('userenv','SESSIONID') SESSIONID,
                        sys_context ('userenv','SID') SID,
                        sys_context ('userenv','STATEMENTID') STATEMENTID,
                        sys_context ('userenv','TERMINAL') TERMINAL
                        from dual
                    )
                    unpivot include nulls (
                        val for name in (action, audited_cursorid, authenticated_identity, authentication_data, authentication_method, bg_job_id, client_identifier, client_info, current_bind, current_edition_id, current_edition_name, current_schema, current_schemaid, current_sql, current_sqln, current_sql_length, current_user, current_userid, database_role, db_domain, db_name, db_unique_name, dblink_info, entryid, enterprise_identity, fg_job_id, global_context_memory, global_uid, host, identification_type, instance, instance_name, ip_address, isdba, lang, language, module, network_protocol, nls_calendar, nls_currency, nls_date_format, nls_date_language, nls_sort, nls_territory, os_user, policy_invoker, proxy_enterprise_identity, proxy_user, proxy_userid, server_host, service_name, session_edition_id, session_edition_name, session_user, session_userid, sessionid, sid, statementid, terminal)
                )
            ) res
        )
        ; 
        apex_json.open_object;
        apex_json.write( 'items', c);
        apex_json.close_object; 
  END ajax_revealer;
 
  --
  -- Execute Spotlight GET_DATA Request
  PROCEDURE ajax_spotlight_get_data
  IS
      c               sys_refcursor;
      l_row_from_c    CONSTANT PLS_INTEGER DEFAULT apex_application.g_x03;
      l_row_to_c      CONSTANT PLS_INTEGER DEFAULT apex_application.g_x04;
      l_page_group_c  CONSTANT apex_applications.application_group%TYPE DEFAULT apex_application.g_x02;
      l_app_id_c      CONSTANT apex_applications.application_id%TYPE DEFAULT NV('APP_ID');
      l_app_page_id_c CONSTANT apex_application_pages.page_id%TYPE DEFAULT NV('APP_PAGE_ID');
      l_session_c     CONSTANT NUMBER DEFAULT v('SESSION');
      l_debug_c       CONSTANT VARCHAR2(32) DEFAULT v('DEBUG');
      l_app_limit_c   CONSTANT apex_application.g_x05%TYPE DEFAULT NVL( apex_application.g_x05, 'N' );
  BEGIN
     OPEN c FOR
        select * from(select * from(select a.*,row_number() over (order by null) apx$rownum 
        from(select * from (select i.* --, count(*) over () as APEX$TOTAL_ROW_COUNT
        from (select *
        from ((select /*+ qb_name(apex$inner) */d.* from (
        SELECT 'Page ' || aap.page_id || ' : ' || NVL( apex_escape.html( aap.page_title ), 'Global Page' ) ||
               '<span style="display:none"> / "' || aap.application_id || ' ' ||  aap.page_id || '"</span>' AS "n"
              ,'<span class="margin-right-sm pdt-apx-Spotlight-inline-link fa ' || 
                 ( SELECT NVL2( MAX(alp.lock_id), 'u-danger-text fa-lock', 'u-success-text fa-unlock' ) x  
                    FROM apex_application_locked_pages alp
                   WHERE alp.application_id = aap.application_id 
                    AND alp.page_id = aap.page_id ) ||
                '" aria-hidden="true"></span>' ||
                '<span class="u-color-' || TO_CHAR( MOD( aap.application_id, 45) + 1 ) || ' margin-right-sm pdt-apx-Spotlight-desc-lozenge">App ' || aap.application_id || '</span>' ||
                '<span class="u-hot margin-right-sm pdt-apx-Spotlight-desc-lozenge" title="alias: ' || apex_escape.html(lower(aap.page_alias)) || '">' || aap.page_mode || '</span>' ||
                '<span class="u-warning margin-right-sm pdt-apx-Spotlight-desc-lozenge">' ||  apex_util.get_since( aap.last_updated_on ) || '</span>' ||
                '<span class="u-warning margin-right-sm pdt-apx-Spotlight-desc-lozenge">' || nvl(lower(apex_escape.html(aap.last_updated_by)),'?') || '</span>' ||
                '<span class="u-info margin-right-sm pdt-apx-Spotlight-desc-lozenge">' ||  aap.page_function || '</span>' ||
                '<span class="u-success margin-right-sm pdt-apx-Spotlight-desc-lozenge">' ||  nvl(lower(apex_escape.html(aap.PAGE_GROUP)), 'Unassigned') || '</span>'
                as "d"
              , apex_string.format('javascript:pdt.pretiusToolbar.openBuilder( ''%0'', ''%1'', ~WINDOW~ );' 
               , aap.application_id
               , aap.page_id ) AS "u"
              , CASE aap.page_id WHEN 0 THEN 'fa-number-0-o' ELSE CASE aap.page_mode WHEN 'Normal' THEN 'fa-file-o' ELSE 'fa-layout-modal-header' END END 
              AS "i",
              'FALSE'
              AS "s",
              '#479d9d' 
              AS "ic" 
              ,':WS:' ||
               CASE WHEN l_app_id_c = aap.application_id THEN ':APP:' END ||
               CASE WHEN l_page_group_c = NVL( app.application_group, '- Unassigned -' ) THEN ':AG:' END 
               AS "c"
              ,aap.application_id || '.' || aap.page_id "x",
               CASE aap.page_id 
               WHEN 0 
               THEN NULL
               ELSE
                 apex_string.format('<a href="#" pdt-Spotlink-url="%0" class="pdt-apx-Spotlight-inline-link"><span aria-hidden="true" class="fa fa-play-circle-o"></span></a>',
                 'f' || '?p=' || aap.application_id || ':' || aap.page_id || ':' || l_session_c || '::' || l_debug_c || ':::'
                 ) 
               END 
               AS "shortcutlink",
               'redirect'
               AS "t"
        FROM apex_application_pages aap,
             apex_applications app
       WHERE app.application_id = aap.application_id
         AND ( ( l_app_limit_c = 'N' )
                OR 
               ( l_app_limit_c = 'Y' AND
                 app.application_id = l_app_id_c )
             )
      ORDER BY CASE aap.page_id WHEN l_app_page_id_c THEN -1 ELSE aap.page_id + 1 END , 
            CASE aap.application_id WHEN l_app_id_c THEN -1 ELSE aap.application_id END
        ) d
        )) i 
        ) i
        )i 
        )a
        )where apx$rownum <= l_row_to_c -- Range to
        )where apx$rownum >= l_row_from_c -- Range from
        ;

    apex_json.write(c);
  END ajax_spotlight_get_data;

  FUNCTION ajax( p_dynamic_action in apex_plugin.t_dynamic_action,
                 p_plugin         in apex_plugin.t_plugin) 
  RETURN apex_plugin.t_dynamic_action_ajax_result
  IS
    l_result              apex_plugin.t_dynamic_action_ajax_result;
    l_ajax_type           apex_application.g_x01%TYPE DEFAULT apex_application.g_x01;
  BEGIN
    IF l_ajax_type = 'REVEALER'
    THEN
        ajax_revealer;
    ELSIF l_ajax_type = 'DEBUG_VIEW'
    THEN
        ajax_debug_view;
    ELSIF l_ajax_type = 'DEBUG_DETAIL'
    THEN
        ajax_debug_detail;
    ELSIF l_ajax_type = 'BUILD_OPTION_EXCLUDED'
    THEN 
        ajax_build_option_excluded;
    ELSIF l_ajax_type = 'GET_DATA' 
    THEN
       ajax_spotlight_get_data;
    ELSIF l_ajax_type = 'GET_URL' 
    THEN
       apex_json.open_object;
       apex_json.write('url',
                       apex_util.prepare_url(apex_application.g_x02));
       apex_json.close_object;
    END IF;
    RETURN l_result;
  END ajax;
END pkg_com_pretius_apex_devtool;
