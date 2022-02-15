# GeTogether

E031 DIP Flutter Mobile Application

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

### Cloning:
To start of, will need to clone the remote repository into your local machine:  \
``$ git clone <url>``

### Setting up your git profile
**IMPT:** Need to setup your name and email to track the changes you make. \
```
$ git config --global user.name "John Doe"``
$ git config --global user.email johndoe@example.com
```
### Push & Pull
To update your local repository to match the remote one (GitHub):  \
``$ git pull``

To update the remote repository (GitHub) with the changes that you have made (so that other people can help see and check):  \
``$ git push``

### Branches
To check which branch you are on:  \
``$ git branch``

To switch branches:  \
``$ git checkout <target-branch>``


#### Creating new branches

To create a new branch from another existing branch (e.g. create button1 branch for finance/journal/activity branches):  \
```
$ git checkout -b <button1> finance
$ git checkout -b <button1> journal
$ git checkout -b <button1> activity
```

To upload your new branch to remote repository (in GitHub):  \
``$ git push -u origin <button1>``

To merge the new branch (PLEASE create a pull request first):  \
```
$ git checkout finance
$ git merge <button1>
```
#### Committing changes to a branch

ALL changes that are working, you make should commit them for eg. Creating new files/folders, editing a file, deleting a file

Check which files have changes in them:  \
``$ git status``

To view what specific changes each file has:  \
``git diff <filename>``

After making a particular change or fix to files, will need to stage those changes/fixes:  \
```
// To stage a single file:
$ git add <filename>

// To stage all the files that you have made changes:
$ git add .
```
Check if you have staged the correct files before committing (files that have been staged will be green):  \
``$ git status``

Once all's good, can commit already (message is VERY impt, keep it short and concise abt the change that has been made):  \
``$ git commit -m "Created a new file"``

To check if your commit is successfully recorded:  \
``$ git log``

To push commits to the remote repo:  \
``$ git push``