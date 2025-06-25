<?php  // Moodle configuration file for GitHub Codespaces

unset($CFG);
global $CFG;
$CFG = new stdClass();

//=========================================================================
// DATABASE SETUP
//=========================================================================
$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'mysql';               // Docker service name
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodleuser';
$CFG->dbpass    = 'CodespacePass123!';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

//=========================================================================
// WEB SITE LOCATION
//=========================================================================
$CFG->wwwroot   = 'https://your-codespace-url.githubpreview.dev';

//=========================================================================
// SERVER FILE SYSTEM LOCATION
//=========================================================================
$CFG->dataroot  = '/workspace/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 0777;

//=========================================================================
// DEVELOPMENT SETTINGS
//=========================================================================
@error_reporting(E_ALL | E_STRICT);
@ini_set('display_errors', '1');
$CFG->debug = (E_ALL | E_STRICT);
$CFG->debugdisplay = 1;

// Disable caching for development
$CFG->cachejs = false;
$CFG->cachetemplates = false;
$CFG->themedesignermode = true;

//=========================================================================
// SECURITY SETTINGS
//=========================================================================
$CFG->cookiesecure = true;
$CFG->cookiehttponly = true;

require_once(__DIR__ . '/lib/setup.php');
?>
