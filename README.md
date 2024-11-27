# the Comma .bash_profile

This bash profile started from a necessity of working with many and various
remote system. It has easy to distinguish integrated functions aimed at aiding
an intermediate or experienced bash user by avoiding installing small tools
everywhere, and improving workflow with common or custom shell snippets.

The main feature is that `ssh` is an alias to `,ssh` which will automatically
copy .bash_profile to the target host. This ensures you always have the
latest profile on a remote machine.

All scriplets (internal functions) start with a `,` (comma), this makes it
very quick to recognize, or list by using tab complete, what this profile
provides.

## Installation

It is recommended that you perform the setup on your main workstation.

Install this git repo in ~/.local/share/comma_bash_profile:

```
mkdir -p ~/.local/share/ && cd ~/.local/share/
git clone http://github.com/vanscheijen/comma_bash_profile
```

Backup and remove your old .bash_profile and .bashrc. E.g.:

```
mv ~/.bash_profile ~/.bash_profile.backup
mv ~/.bashrc ~/.bashrc.backup
```

Then redirect to the (to be) generated .bash_profile via a symlink:

```
ln -s ~/.local/share/comma_bash_profile/.bash_profile ~/.bash_profile
ln -s ~/.bash_profile ~/.bashrc
```

Generate the .bash_profile for the first time using these steps, once it is up
and running you can use ,make_profile without sourcing first:

```
source ~/.local/share/comma_bash_profile/function/,make_profile.sh
,make_profile
```

All done! You should see the comma bash profile login prompt.

## Usage

Change files in the comma_bash_profile directory as needed, and
run `,make_profile` to automatically check and activate.

Type `,help` to get a list of all the comma functions.

You can use Ctrl-z to both put a job into the background and return it to the
foreground. Some processes capture Ctrl-z, you can use Ctrl-q for those.

By default readline is set to vi-mode, however with some backward compatibility to
commonly used emacs shortcuts. You can see the settings in profile.d/40_readline.sh

Use the `s` command to become root via sudo or doas while retaining the profile.

## Notes

* Internal functions are prefixed with two comma's, e.g. `,,require` and are not for command line usage
* The filenames in function/ and profile.d/ are arbitrary, the .sh suffix is just so vim understands the syntax
* I prefer bash internals over externals, but for compatibility I minimize bash 4+ features

* .bashrc is only used by non-login (sub)shells
* ~/.profile and ~/.bash_login will be ignored (see bash man pages) unless sourced by .bashrc
* I would not symlink .bashrc on remote machines
* Use this profile as root by symlinking .bash_profile to the .bash_profile in the user's home directory
* Then also symlink .bashrc -> .bash_profile for root

## profile.d numbers

All profile.d/9x_ and profile.d/x9_ files are excluded (see .gitignore), they are for your customization.

This is just a guideline, only the order of execution is important:

|Range|Usage|
|---|---|
|00|Sourcing of other scripts|
|10|Functions|
|20|Declarations|
|30|Aliases|
|40|Input configuration (readline)|
|50|Environment|
|60|Reserved|
|70|Prompt|
|80|Login|
|90|Custom|

