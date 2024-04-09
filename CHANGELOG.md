1.3.0 4/9/2024
* Updates Ruby to version 3.3.0
* Updates Rails to version 6.1.7.7
* Bug Fixes
  * Changes notes field to text.
  * Removes old server name.

1.2.0 8/18/2023
* Updates Ruby to version 3.2.2
* Updates Rails to version 6.1.7.4
* Updates Change Management and Upgrade Tab.
* Improves UX responsiveness for Change Request.
* Adds more required fields to ChangeRequest.
* Adds ChangeRequest Model.
* Use puma as a service
* Adds server and certificate fields to SoftwareRecords.
* Updates front and file_uploads controller to solve security vulnerabilities.
* Adds Maintentance Log and Priority list
* add local option to auth type
* Configure Github Actions and Coveralls
* Add Admin Roles to Software Records
* Updates linters and security gems
* Bug Fixes
  * Fixes edit_path on upgrade history.
  * Fixes rubocop errors in delete spec.
  * Fixes role access for manager and owner.
  * Fixes SoftwareRecords typos and test.
  * Fixes grey menu
  * Fixes some accessiblity issues.
  * Fixes password update.
  * Fix Software Graph
  * Update Secret Key call.

1.1.0 6/19/2021
* Cleaned up Status Field
* Removed status field from software records table
* Rubcop corrections
* Import Data script updated
* Dashboard edits
* Improved Coveralls Coverage
* Added Hosting Environment field
* Modified start up scripts for QA and Prod
* Bundle Update
* Setup tabs for software record
* Expanded db seeds
* Added Change Management fields
* Added Server Environment tab and fields
* Created yes/no toggle helper
* Added Authentication type field
* Added new field to import / export script
* Bug Fixes
  * Fixes blind sql injection
  * Updates chartkick gem

1.0.1 10/1/2020
* Prevent overwriting of data on import
* Left justify text on all index and dashboard
* Simplified buttons
* Updated login page description
* Modified http in url labels and fields
* Changed catalog display of url when empty
* Changed labels on product owner
* Fix footer accessibility issue
* Encrypted the sensitive information field
* Updated bottom graph to show total records
* Bug Fixes
  * Fixed support contract check box
  * Fixed problems with multi-valued field
  * Fixed navigation after editing record

1.0.0 7/17/2020
* Configured authentication
* Configured test environment
* Setup Bootstrap CSS
* Configured user abilities
* Dashboard and Catalog interfaces
* Configured User Management
* Menuing and Navigation
* Search
* Visualizations
* Data Export 
* Data Import
* Modelling for Software Records
* Modelling for Software Types
* Modelling for Software Vendors
* Secure Fields
