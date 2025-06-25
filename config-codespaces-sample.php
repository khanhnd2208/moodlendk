<?php  // Moodle configuration file for GitHub Codespaces

unset($CFG);
global $CFG;
$CFG = new stdClass();

//=========================================================================
// 1. DATABASE SETUP
//=========================================================================
// Codespaces database configuration
$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'localhost';          // MySQL host in Codespaces
$CFG->dbname    = 'moodle';             // Database name
$CFG->dbuser    = 'moodleuser';         // Database user
$CFG->dbpass    = 'CodespacePass123!';  // Database password
$CFG->prefix    = 'mdl_';               // Tables prefix
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

//=========================================================================
// 2. WEB SITE LOCATION
//=========================================================================
// IMPORTANT: Update this with your actual Codespace URL
// You can find this in the Ports tab of your Codespace
// Example: https://username-reponame-12345.githubpreview.dev
$CFG->wwwroot   = 'https://your-codespace-url.githubpreview.dev';

//=========================================================================
// 3. SERVER FILE SYSTEM LOCATION
//=========================================================================
$CFG->dataroot  = '/workspaces/moodledata';
$CFG->admin     = 'admin';

//=========================================================================
// 4. DATA FILES LOCATION
//=========================================================================
// This directory must exist and be writable by the web server user
// Codespaces uses '/workspaces/moodledata' which is created during setup
$CFG->directorypermissions = 0777;

//=========================================================================
// 5. DEVELOPMENT AND DEBUGGING (FOR CODESPACES)
//=========================================================================
// Enable debugging for development in Codespaces
@error_reporting(E_ALL | E_STRICT);
@ini_set('display_errors', '1');
$CFG->debug = (E_ALL | E_STRICT);
$CFG->debugdisplay = 1;

// Development settings
$CFG->cachejs = false;
$CFG->cachetemplates = false;
$CFG->langstringcache = false;

//=========================================================================
// 6. PERFORMANCE SETTINGS
//=========================================================================
// Optimizations for Codespaces environment
$CFG->cachejs = true;
$CFG->cachetemplates = true;
$CFG->yuicomboloading = true;

// Session settings
$CFG->sessiontimeout = 7200; // 2 hours

//=========================================================================
// 7. SECURITY SETTINGS
//=========================================================================
// Force HTTPS in production (disable for local development)
// $CFG->sslproxy = true;

// Cookie settings for Codespaces
$CFG->cookiesecure = true;
$CFG->cookiehttponly = true;

//=========================================================================
// 8. EMAIL SETTINGS (FOR TESTING)
//=========================================================================
// Email configuration for Codespaces development
// Use a service like Mailhog or disable email for development
$CFG->noemailever = true; // Disable all email sending for development

//=========================================================================
// 9. FILE PERMISSIONS
//=========================================================================
$CFG->filelifetime = 86400;
$CFG->chmoddirs = 0777;
$CFG->chmodfiles = 0666;

//=========================================================================
// 10. CODESPACES SPECIFIC SETTINGS
//=========================================================================
// Allow frame embedding for Codespaces preview
$CFG->allowframembedding = true;

// Increase memory limit for development
@ini_set('memory_limit', '512M');

// Time zone setting
$CFG->timezone = 'Asia/Ho_Chi_Minh';

//=========================================================================
// 11. DEVELOPER SETTINGS
//=========================================================================
// Theme designer mode (enable for theme development)
// $CFG->themedesignermode = true;

// CSS and JS optimization
$CFG->cachejs = false;
$CFG->cachetemplates = false;

// Disable upgrade notifications in development
$CFG->disableupdatenotifications = true;
$CFG->disableupdateautodeploy = true;

//=========================================================================
// 12. BACKUP AND RESTORE
//=========================================================================
// Backup settings for development
$CFG->backup_auto_active = false;
$CFG->backup_auto_weekdays = '0000000';

//=========================================================================
// ALL DONE!  To continue installation, visit your main page with a browser
//=========================================================================

require_once(__DIR__ . '/lib/setup.php');

// END OF CONFIG FILE
?>
