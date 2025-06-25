<?php  // Moodle configuration file for GitHub Codespaces

unset($CFG);
global $CFG;
$CFG = new stdClass();

// Database configuration for Codespaces
$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'localhost';
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

// Site configuration - will auto-detect Codespace URL
$CFG->wwwroot   = 'https://localhost:8080';
$CFG->dataroot  = '/workspaces/moodledata';
$CFG->admin     = 'admin';

// Development settings
$CFG->directorypermissions = 0777;
$CFG->debug = (E_ALL | E_STRICT);
$CFG->debugdisplay = 1;

// GitHub Codespaces URL auto-detection
if (getenv('CODESPACE_NAME')) {
    $codespace_name = getenv('CODESPACE_NAME');
    $CFG->wwwroot = "https://{$codespace_name}-8080.app.github.dev";
}

// Auto-detect from HTTP_HOST if available
if (isset($_SERVER['HTTP_HOST']) && !getenv('CODESPACE_NAME')) {
    $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
    $CFG->wwwroot = $protocol . $_SERVER['HTTP_HOST'];
}

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
