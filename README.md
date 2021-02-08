# tbtools - Tools for working with Fedora Toolbox

A while ago I switched over my laptop to Fedora Silverblue. On Silverblue, the
system is immutable, and while you can install any package from the normal
Fedora repos that is discouraged, since it requires a reboot and makes future
updates slower. The proper way to install packages is to use flatpaks for
graphical apps, and commandline tools such as a C compiler inside of a toolbox.
A toolbox here is an unpriviledged, persistent podman container.

Now that presented me with some problems: I do kernel development, and for that
I need to compile kernel modules. I need to do that inside of my toolbox, but I
can't load them from there because while the kernel is the same, the toolbox
cannot get superuser rights to run `insmod`. So I would have to enter the
toolbox, build my module, exit the toolbox, load it, enter the toolbox again,
etc. etc. This is annoying.

Another issue is my text editor: I use emacs, more specifically, a gccemacs
build that uses proper GTK3 (so it works with Wayland and HiDPI). That build is
not available as a flatpak, and I cannot install it with rpm-ostree (the
Silverblue package manager), because rpm-ostree prefers the unpached emacs from
the Fedora repository. I can install it inside of the toolbox, but I also want
to be able to open files in emacs through the file manager, so it needs to be
accessible from the host.

The third annoyance I had was that I am lazy. I would have to spend the vast
amount of my terminal time inside of the toolbox, but I am too lazy to type
`toolbox enter` every time I open a terminal. I want the terminal to
automatically launch into the toolbox! But then, it would become impossible
to get a shell on the host without going into the settings of the terminal app
or my shell and undoing whatever changes I did.

I implemented a lot of this using shell scripts, but then I came across the V
language which I found interesting. Because I always learn languages by writing
something that I need, I figured, why not write an improved native version. The
result was tbtools.

tbtools is a collection of wrappers and convenience tools around the `toolbox`
command. It has various features, like:
- Entering a toolbox or running a command inside. Toolbox provides the same
  features (duh), the difference is that tbtools will automatically run the
  command in a shell, with a fully functional environment.

- Breaking out from the toolbox and running a command (or a shell) on the host.
  This is basically a fancy wrapper over `ssh localhost`, but again, I am lazy.
  Typing `tb host` is way better than `ssh localhost; cd /wherever/i/was`

- Automatically create wrapper scripts that run commands inside the toolbox or
  on the host. That way I can "import" the command `sudo insmod` into the
  toolbox, and "export" the command `emacs` and `emacsclient` to the host.

- A bunch of convenience stuff around creating toolboxes. tbtools will try to
  make sure that your shell also exists inside of the toolbox, and allow you to
  automatically run a script inside to initialize everything (install your
  packages, etc.). That way, updating to a new fedora version is straightforward:
  Create a new toolbox for the new version, let the script initialize it, change
  the default toolbox to the new one, and remove the old one.

# How to build?
TODO

(maybe also just rewrite in C, lol)
