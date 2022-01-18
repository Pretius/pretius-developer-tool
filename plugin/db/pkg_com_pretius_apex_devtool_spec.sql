CREATE OR REPLACE PACKAGE pkg_com_pretius_apex_devtool
IS
   /*
    * Plugin:   Pretius Developer Tool
    * Version:  21.2.5
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
  ) RETURN apex_plugin.t_dynamic_action_render_result;

  FUNCTION ajax( p_dynamic_action in apex_plugin.t_dynamic_action,
                 p_plugin         in apex_plugin.t_plugin) 
  RETURN apex_plugin.t_dynamic_action_ajax_result;

END pkg_com_pretius_apex_devtool;
/
