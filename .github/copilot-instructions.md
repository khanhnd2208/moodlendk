<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Moodle 5.0.1 GitHub Codespaces Project

This is a Moodle 5.0.1 Learning Management System project configured for GitHub Codespaces deployment.

## Project Context
- **Platform**: Moodle 5.0.1 (PHP-based LMS)
- **Environment**: GitHub Codespaces
- **Database**: MySQL 8.0
- **PHP Version**: 8.1
- **Target Deployment**: Oracle Cloud, Railway.app, DigitalOcean

## Development Guidelines

### Code Structure
- Follow Moodle coding standards and conventions
- Use proper PHP namespacing and autoloading
- Maintain database schema compatibility with Moodle requirements
- Keep custom code in appropriate directories (themes, plugins, local)

### Database
- Use MySQL with utf8mb4_unicode_ci collation
- Follow Moodle database API for all database operations
- Prefix all custom tables with 'mdl_'
- Use Moodle's database abstraction layer

### Configuration
- Environment-specific config files for different deployment targets
- Use environment variables for sensitive data
- Maintain separate configs for development, staging, and production

### Performance
- Optimize for ARM processors (Oracle Cloud A1.Flex)
- Consider memory constraints in different hosting environments
- Implement proper caching strategies
- Optimize file uploads and storage

### Security
- Follow Moodle security best practices
- Validate all user inputs
- Use proper authentication and authorization
- Implement HTTPS in production environments

### Deployment Targets
- **GitHub Codespaces**: Development and testing
- **Oracle Cloud Free Tier**: Production deployment (4 CPU, 24GB RAM)
- **Railway.app**: Quick deployment with PostgreSQL
- **DigitalOcean**: VPS deployment with full control

### File Organization
- Keep deployment scripts in `/deployment/` directory
- Store custom themes in `/custom-themes/`
- Place custom plugins in `/custom-plugins/`
- Maintain backup scripts and documentation

### Commands and Scripts
- Use the provided deployment scripts for different platforms
- Maintain database backup and restore procedures
- Implement automated testing where possible
