module main

import cli
import os

fn cmd_create(cmd cli.Command) ? {
	name := cmd.args[0]

	mut init := 'default'
	if cmd.args.len > 1 {
		init = cmd.args[1]
	}

	distro := cmd.flags.get_string('distro') ?
	image := cmd.flags.get_string('image') ?
	release := cmd.flags.get_string('release') ?
	no_init := cmd.flags.get_bool('no-init') ?

	script := path('init', init)
	instance := path('instances', name)

	if os.exists(instance) {
		return error("Toolbox '$name' already exists!")
	}

	if !no_init && init != 'default' && !os.is_executable(script) {
		return error("Init script '$init' does not exist!")
	}

	msg('Creating toolbox container')

	mut child := fork() ?
	if child {
		mut args := ['create', '-c', name]

		if distro != '' {
			args << '-d'
			args << distro
		}

		if image != '' {
			args << '-i'
			args << image
		}

		if release != '' {
			args << '-r'
			args << release
		}

		toolbox(args) ?
	}

	exe := executable() ?

	msg('Linking tbtools executable into the toolbox')
	child = fork() ?
	if child {
		toolbox(['run', '-c', name, 'sudo', 'ln', '-s', '/run/host$exe', exe]) ?
	}

	if os.is_executable(script) && !no_init {
		msg("Initializing toolbox container from script '$init'")

		child = fork() ?
		if child {
			toolbox(['run', '-c', name, script]) ?
		}
	}

	shell := env('SHELL') ?

	if os.file_name(shell) != 'bash' {
		msg("Making sure that '$shell' is available in the toolbox")

		child = fork() ?
		if child {
			toolbox(['run', '-c', name, 'sudo', 'dnf', 'install', '-y', shell]) ?
		}
	}

	os.symlink(exe, instance) ?

	default := path('', 'default')
	if !os.is_file(default) {
		os.write_file(default, name) ?
	}

	msg("Successfully created toolbox! Enter with '$name run'")
}
