Feature: Check the feature Maxlength
  In order to check the functionality of limiting and validating their maximum length in the edit form.
  As an administrator
  I want to check the maxlength.

  @api
  Scenario: Administrator user can check the sitemap
    Given the module is enabled
      | modules                 |
      | multisite_maxlength     |
    Given I am logged in as a user with the 'administrator' role
    When I run drush "pm-enable bootstrap -y"
    Then I go to "/sitemap.xml"
    And the response should not contain "Page not found"
    And the response should contain "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:xhtml=\"http://www.w3.org/1999/xhtml\">"