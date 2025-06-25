<?php  // Moodle configuration file for Railway.app deployment

unset($CFG);
global $CFG;
$CFG = new stdClass();

// Database configuration for Railway PostgreSQL
$CFG->dbtype    = 'pgsql';
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('PGHOST') ?: 'localhost';
$CFG->dbname    = getenv('PGDATABASE') ?: 'railway';
$CFG->dbuser    = getenv('PGUSER') ?: 'postgres';
$CFG->dbpass    = getenv('PGPASSWORD') ?: '';
$CFG->dbport    = getenv('PGPORT') ?: '5432';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbsocket' => '',
);

// Site configuration - Railway auto-detection
$railway_domain = getenv('RAILWAY_STATIC_URL') ?: getenv('RAILWAY_PUBLIC_DOMAIN');
if ($railway_domain) {
    $CFG->wwwroot = 'https://' . $railway_domain;
} elseif (isset($_SERVER['HTTP_HOST'])) {
    $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
    $CFG->wwwroot = $protocol . $_SERVER['HTTP_HOST'];
} else {
    $CFG->wwwroot = 'https://your-moodle-site.up.railway.app'; // Fallback
}

$CFG->dataroot  = '/tmp/moodledata';
$CFG->admin     = 'admin';

// Production settings for Railway
$CFG->directorypermissions = 0777;
$CFG->debug = 0; // No debug in production
$CFG->debugdisplay = 0;

// Performance optimizations
$CFG->cachejs = true;
$CFG->cachecss = true;
$CFG->enablecompletion = true;
$CFG->enableavailability = true;

// Create moodledata directory if it doesn't exist
if (!file_exists($CFG->dataroot)) {
    mkdir($CFG->dataroot, 0777, true);
}

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
