# Pretius Developer Tool

Pretius Developer Tool (PDT) is an Oracle APEX plugin developed by <a href="https://www.twitter.com/Matt_Mulvaney" target="_blank">Matt Mulvaney</a> at <a href="https://www.pretius.com" target="_blank">Pretius</a>. Unlike other APEX plugins, it was made not with users in mind but for the benefit of developers. It provides you with a few useful features:
* Revealer: Displays client and session info that is not immediately available to you as a developer
* Reload Frame: Provides you with a convenient single click for reloading a modal dialog page
* Visual Build Options: Glows page components in blue/red, giving you a visual clue on whether a certain component will be included/excluded on export

Pretius Developer Tool is built all modular so you can expect more features to come in the future.

<img src="https://raw.githubusercontent.com/Pretius/pretius-developer-tool/master/img/preview.gif" width="700px">

<br/>

# Release History
21.2.5 Initial Version

# Plugin Installation Quick-Start
Import the plugin into your application from this location:

`plugin\dynamic_action_plugin_com_pretius_apex_devtool.21.2.5.sql`

After installation, follow these steps:
1. Create a Page Load Dynamic Action on Page 0 Called "Pretius Developer Tool"
2. Assign the Dynamic Action a <a href="https://www.youtube.com/watch?v=XOLCrHSRRrM&t=84s" target="_blank">Build Option</a> that is set to Exclude on Export
3. Select "Pretius Developer Tool" APEX Plugin as the true action

<img src="https://raw.githubusercontent.com/Pretius/pretius-developer-tool/master/img/install.gif" width="700px">

<br/>

# Features
* Revealer
* Modal Reload
* Visual Build Options
* Supports Firefox, Internet Explorer, Edge & Chrome

# Settings
* Use the Settings (Filter icon) in the toolbar to enable/disable features
* Settings are stored at Browser Level, i.e, your settings are preserved for multiple APEX applications (providing you use the same browser)

# Opting Out
* If you no longer wish to use Pretius Development Tool, however, other Developers on your Application wish to continue, you can opt out by following the link at the top of the options page
* If you wish to opt back in, type the following in the Console window of your browser

   <code>pdt.optIn();</code>

# Future developments
Please let me know any of your wishes

# Advanced Installation

## Web Server Installation (Optional)
Place the JavaScript & CSS files from plugin\server on your web server.

Create an Application Substitution (Recommended), Application Item or Global Page Item as:
* Name: <code>APP_PRETIUS_DEVTOOL_PREFIX</code>
* Value: URL e.g., <code>http://127.0.0.1:8889/</code> or <code>#IMAGE_PREFIX#</code>

*Don't forget the final slash (/) on the end of the URL*

## DB Installation (Optional)
Create the pkg_com_pretius_apex_devtool package spec & body from plugin\db

Create an Application Substitution (Recommended), Application Item or Global Page Item as:
* Name: <code>APP_PRETIUS_DEVTOOL_PKG</code>
* Value: <code>pkg_com_pretius_apex_devtool.</code>

*Don't forget the final dot (.) on the end of the value*
