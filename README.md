# Interpreting Data Sets — SQL Practice Repository

Welcome — this repository is a simple collection of real-world datasets prepared for practicing SQL queries. I created it to practice writing and answering SQL questions against datasets I found, and I’m sharing it so anyone can clone, explore, and learn from the same materials.

---

1 - Repository Description
--------------------------
This repository contains one or more dataset folders. Each dataset folder includes the dataset itself plus a paired set of SQL practice files: `questions.sql` (prompts / exercises) and `answers.sql` (solutions). The goal is to provide a hands-on space for learning and practicing SQL: you can run the questions against the provided data and compare your queries with the example answers.

Key points:
- Intended for SQL practice and learning.
- Datasets are arranged in separate folders for clarity.
- Each dataset folder contains exercise prompts and example answers.

---

2 - Folder and File Structure (what’s inside)
---------------------------------------------
At the top level you will find one or more dataset folders. Each dataset folder follows the same layout:

- `<dataset-folder>/`
  - `questions.sql` — A collection of SQL problems and prompts to solve using the dataset.
  - `answers.sql` — Example solution queries that answer the problems in `questions.sql`.
  - dataset files — The actual dataset files (for example CSV files, SQL dump files, or any other files needed to load the data). These live inside the same dataset folder.

Notes:
- `questions.sql` and `answers.sql` are paired: try solving the questions yourself first, then check `answers.sql`.
- The dataset files are provided alongside the SQL files so you can load them into your local database (PostgreSQL, MySQL, SQLite, etc.) and run the exercises.

2.1 — Example: `questions.sql` and `answers.sql`
- Every dataset folder includes a `questions.sql` file (the exercises) and an `answers.sql` file (one possible set of solutions).
- The dataset itself is stored in the same folder as those SQL files to make importing and running queries straightforward.

---

3 - Direct link to the dataset folder
-------------------------------------
Currently this repository contains the following dataset folders:

- dvdRental
- NorthWind

---

4 - Use and sharing
-------------------
This repository is public and intended for everyone to use. Feel free to:
- Clone or fork the repo,
- Load the datasets into your preferred SQL environment,
- Work through the `questions.sql` exercises, and
- Compare with the `answers.sql` solutions.

If you share improvements (new questions, clearer solutions, or additional datasets), contributions and pull requests are welcome. Use the code, learn, and share knowledge — happy querying!
