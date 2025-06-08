# 🍸 Bar‑Atlas 「酔いの地図帳」

## 🔍 Overview

**Bar‑Atlas** is a Ruby on Rails application that helps you discover authentic cocktail & whisky bars. The current release (**MVP v0.1**) focuses on publishing bar information so it can be reviewed and iterated quickly; richer search and map features will follow.

---

## 🚀 Features

### 📝 **Implemented Features (v0.1)**

- 🏷 **Bar Management**

  - CRUD operations for bars (name, address, price range, smoking status, description)
  - Each bar can list multiple **specialties** (main liquor categories)

- 🗂 **Seed Data**

  - 10 sample bars & specialties shipped for instant demo

### 🛠 **Planned Features**

The MVP is intentionally small. After the initial review cycle we plan to iterate and add:

- 🔍 Advanced search (keyword, area, filters)
- 👤 User authentication & profiles
- ⭐ Favorite bars
- 🗺 Google Maps integration
- 📱 Responsive UI polish
- 💬 Basic reviews / comments

\-----------|-------|
\| **v0.2** | 🔍 Keyword & area search (Ransack)<br>🎨 Tailwind UI card polish |
\| **v0.3** | 👤 User authentication (Devise)<br>⭐ Favorite bars |
\| **v0.4** | 🗺 Google Maps marker display<br>⚡ N+1 query optimisation |
\| **v1.0** | 📱 Responsive design fine‑tune<br>🔄 CI/CD auto‑deploy to Render<br>💬 Simple review/comments |

---

## 📸 Screenshots _(WIP placeholders)_

| Description | Screenshot      |
| ----------- | --------------- |
| Bar List    | _(coming soon)_ |
| Bar Detail  | _(coming soon)_ |

> Final screenshots will be added after UI polish (v0.2).

---

## 🛠 Technologies Used

- **Ruby 3.3.3**
- **Rails 7.1.5.1**
- **PostgreSQL 14** (dev) / **Render PostgreSQL Free** (prod)
- **Tailwind CSS 3** + Heroicons
- **RSpec** (test) / **GitHub Actions** (CI)

---

## 🔧 Setup

```bash
# clone
$ git clone git@github.com:X0377/Bar-Atlas.git
$ cd Bar-Atlas

# dependencies
$ brew services start postgresql@14   # or any running Postgres ≥14
$ bundle install

# database
$ bin/rails db:prepare   # create + migrate
$ bin/rails db:seed      # load sample bars

# run
$ bin/rails s            # http://localhost:3000
```

---

## 🎠 License

This project is licensed under the MIT License.
