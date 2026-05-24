# Project Analysis: Minithraining

## 1. Project Overview

`Minithraining` is a fork of the original `Mathraining` application. The fork is positioned as a lighter, more focused version of the platform, intended for local use and for revising math topics in a simplified environment. The codebase remains largely inherited from the original Mathraining project and retains significant application structure, business logic, email templates, naming, and configuration references from the parent project.

## 2. Technical Stack

- Ruby 3.2.8
- Rails 7.1.5.2
- Frontend: Bootstrap 5.3, jQuery, Select2, Importmap
- Persistence: SQLite3 for development/test, PostgreSQL for production and CI
- Authentication: Bcrypt for password hashing
- Background/email: Resque + ResqueMailer
- File uploads: Active Storage
- Localization: rails-i18n, default locale set to `fr`
- Testing: RSpec, Capybara, FactoryBot, DatabaseCleaner, SimpleCov, Codecov
- Logging: Lograge configured

## 3. Application Architecture

### 3.1 Core domains

The application contains a rich set of training-oriented features:

- Users and roles: students, administrators, root, correctors, Wépion group
- Exercises and chapters: sections, chapters, theories, questions, items
- Problem submissions: problems, submissions, corrections, external solutions
- Contests: contests, contest problems, contest solutions, contest corrections
- Content and community: subjects, messages, discussions, notifications
- User progression: solved problems, score tracking, section-level progress
- Password recovery and policy/code-of-conduct gating

### 3.2 Controllers and flow

- `ApplicationController` is heavily loaded with cross-cutting concerns:
  - CSRF handling via a custom strategy
  - global variables loaded from DB on every request (`Globalvariable` records)
  - maintenance/temporary closure checks
  - last-connection updates
  - mandatory actions for signed-in users (legal consent, code of conduct, password upgrade)
- There is a strong use of controller-level before_action filters and render/redirect flows, which is typical in older Rails applications.

### 3.3 Routing surface

- The route file defines a large RESTful API for many resources, from sections to contest corrections.
- It includes many custom member/collection actions for workflow-specific operations such as follow/unfollow, publish, reserve/unreserve, and read/unread.

## 4. Findings: Brand and Fork Status

### 4.1 Rebranding is partial

While the fork is named `Minithraining`, the repository still contains many references to `Mathraining`:

- `config/application.rb`: module named `Mathraining`
- `config/initializers/setup_mail.rb`: `domain: mathraining.be`
- `config/initializers/session_store.rb`: commented-out `Mathraining::Application` line
- `app/mailers/user_mailer.rb` and email templates use `Mathraining` in subjects and body copy
- `app/views/static_pages/home.html.erb`, `about.html.erb`, and `users/read_legal.html.erb` still mention Mathraining
- Specs still expect Mathraining branding and URLs
- `README.md` still uses the old repository name and clone instructions refer to `mathraining`
- Many assets and test fixtures still carry `mathraining.png`

### 4.2 Fork purpose clearly documented

The README and static pages explain the difference: advanced features are hidden and branding is gradually removed. That is a clear goal, even though the actual code still retains original references.

## 5. Strengths

- Mature feature set inherited from a complex platform
- Good test infrastructure with RSpec and Capybara already present
- Clean separation of many resources via RESTful routing
- Localization support with French as default
- Active use of modern Rails features alongside legacy support
- CI setup in GitHub Actions with PostgreSQL and coverage reporting

## 6. Risks and Technical Debt

### 6.1 Legacy naming and branding

- The fork is not fully renamed. This creates technical debt and risks leaking original branding in emails, links, and UI copy.

### 6.2 Mixed database configurations

- Development/test use SQLite3, while production and CI use PostgreSQL.
- This mismatch may hide DB-specific bugs until later stages.

### 6.3 Coupled controller logic

- `ApplicationController` and other controllers contain significant business logic and stateful workflows, increasing difficulty of refactor.
- Global variables are loaded on every request from `Globalvariable`, which may affect performance and complexity.

### 6.4 Partial feature hiding may be brittle

- The fork claims to hide advanced features, but many routes, controllers, views, and tests still contain the full feature set.
- This suggests the “minified” version is more of a UI/branding layer than a codebase simplification.

### 6.5 Security / consistency notes

- Custom CSRF handling exists and can be tricky; there is a bespoke invalid CSRF token path.
- Email templates hardcode production hostnames such as `www.mathraining.be`.

### 6.6 Hints of code hacks

- There are explicit `TODO` and `HACK` comments in views and specs.
- The codebase is likely maintained with pragmatic fixes rather than total cleanup.

## 7. Recommended Focus Areas

### 7.1 Finish the rebrand

- Replace `Mathraining` with `Minithraining` consistently in templates, mails, tests, and configuration.
- Rename the Rails module if the fork should be fully independent.
- Update README instructions to match the fork name and current setup.

### 7.2 Standardize DB setup

- Let users create an account, linked to their email adress, but no email verification needed.
- A small hack to protect against too many accounts created.

## 8. Additional Notes

- This project is a good candidate for an incremental modernization effort: start with branding and configuration, then refactor individual concerns.
- The existing test suite is a strong asset; keep it green while refactoring to avoid regressions.
- The fork already includes a clear value proposition: simpler use for a beta/minor audience while retaining training workflows.

---

_Last updated: May 24, 2026_
