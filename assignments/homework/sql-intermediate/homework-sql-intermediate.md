---
title: "Homework: Intermediate SQL Practice"
author: Signal Data Science
---

Getting started with SQLite
===========================

In this assignment, we will be using [SQLite](https://en.wikipedia.org/wiki/SQLite) to interactively solve some SQL problems.

* Download or install SQLite on your computer following these instructions:

	* On **Windows**, go to the [SQLite download website](http://www.sqlite.org/download.html) and download the file named `sqlite-tools-win32-x86-*.zip`. Unzip the folder and check that it contains a file called `sqlite3.exe`.

	* On **OS X 10.10+**, SQLite comes pre-installed. On **OS X 10.9 or older**, go to the [SQLite download website](http://www.sqlite.org/download.html) and download the file named `sqlite-tools-osx-x86-*.zip`. Unzip the folder and check that it contains a file called `sqlite3`.

	* On **GNU/Linux**, install SQLite directly from your distribution's repository, *e.g.*, `sudo apt-get install sqlite3` on [Debian](https://www.debian.org/) and [Debian derivative](https://wiki.debian.org/Derivatives) or `sudo pacman -S sqlite3` on [Arch Linux](https://www.archlinux.org/).

* Open the terminal ([Command Prompt](https://en.wikipedia.org/wiki/Cmd.exe) on Windows and [Terminal](https://en.wikipedia.org/wiki/Terminal_(OS_X))). If SQLite was pre-installed on your system or if you installed it from a repository, you should be able to run SQLite from any directory. Type `sqlite3 --version` to verify this. If you downloaded a `.zip` file from the SQLite website, navigate in the terminal to the folder where `sqlite3.exe` (Windows) or `sqlite3` (OS X) is located. Type `sqlite3.exe --version` (Windows) or `./sqlite3 --version` (OS X) to verify that your downloaded binary works.

In the following, you'll be calling SQLite from the terminal. Instead of providing the exact syntax required for every operating system, we'll only provide the GNU/Linux syntax, where simply one types `sqlite3 <...>` into the terminal. Following the above instructions, adapt the syntax to your own OS. Note that if you *downloaded* the binary from the SQLite website, your terminal will have to be located in the directory as the SQLite binary to be able to call it directly; you can stay in the same directory where you unzipped the file or move the binary to a different location.

We'll illustrate how SQLite works with a simple example.

* Run `sqlite3`. You should be met with a different command prompt, saying `sqlite>`. Type `CREATE TABLE TableName as SELECT 1 AS X, 2 AS Y, 3 AS Z;` and press `Enter`. Next, type `SELECT * FROM TableName` and press `Enter`. You should receive `1|2|3` as output.

In the following exercises, we'll provide you with data for a couple simple tables. You'll design queries to answer questions about those tables, using the SQLite command line to verify that you're getting the desired output and also to allow you to interactively see how changing the structure of a query affects the output.

