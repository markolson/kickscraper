### 0.1.0

* enhancements
  * adding support for Kickstarter categories!
  * basic pagination when searching projects

* optimize
  * huge refactor of tests to DRY them up

* deprecate
  * client.newest_projects (replaced by client.recently_launched_projects)
  * client.can_load_more_projects (replaced by client.more_projects_available?)

* bug fixes
  * a little bit more error handling


### 0.0.3

* enhancements
  * added tests!
  * a little bit of basic error checking

* optimize
  * DRYing up the API calls

* bug fixes
  * updating the search for "newest" projects, which was renamed by Kickstarter
  * handling special characters in searches


### 0.0.2

* enhancements
  * Project searches (popular, recent, ending soon)
  * User biography


### 0.0.1

* Basic working API (getting projects and users)