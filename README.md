# Project Name

[One-sentence project description goes here.]

![Project Logo](project_logo.png) (if applicable)

## Table of Contents

- [Project Name](#project-name)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [License](#license)
  - [Authors and Contributors](#authors-and-contributors)
  - [Code of Conduct](#code-of-conduct)
  - [Changelog](#changelog)

## About

[Provide a brief description of the project, what it does, and its main features.]

## Installation

1. Install ruby and rails
2. Clone this repository
3. Run `bundle install`
4. `rails db:migrate`
5. Run `rails console`, create an admin user `User.create(email: "email@am.es", username: "username", password: "1234", password_confirmation: "1234", admin: true)`
6. `exit`
7. Run `rails server` and access the localhost

## Usage

1. Clone this repository
2. Enter the `advent-calendar` folder
3. Run `RAILS_MASTER_KEY=<Insert here content of master.key> docker compose up --build`
4. Execute a shell inside the container and run `bundle exec rails c`
5. Create an admin user by running `User.create!(email: "email@am.es", username: "username", password: "1234", password_confirmation: "1234", admin: true)`

## Contributing

We welcome contributions from the community! If you want to contribute to [Project Name], please follow the guidelines in the [CONTRIBUTING.md](./other/CONTRIBUTING.md) file.

## License

[Project Name] is released under the [License Name](LICENSE). [Include a brief summary of the license terms and a link to the full license file.]

## Authors and Contributors

Check out the [AUTHORS.md](./other/AUTHORS.md) file to see a list of all the wonderful people who have contributed to this project.

## Code of Conduct

We expect all contributors to follow our [Code of Conduct](./other/CODE_OF_CONDUCT.md) to maintain a respectful and inclusive environment for everyone.

## Changelog

For a detailed list of changes and versions, check the [CHANGELOG.md](./other/CHANGELOG.md) file.
