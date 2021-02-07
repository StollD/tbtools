module main

import cli
import os

fn cmd_run(cmd cli.Command) ? {
	mut container := os.file_name(os.args[0])
	if !os.is_executable(path('instances', container)) {
		container = env('TB_CURRENT') or { '' }
	}

	if container == '' {
		default := path('', 'default')

		if os.is_file(default) {
			container = os.read_file(default) ?
		}
	}

	run(container, fixargs(cmd.args).join(' ')) ?
}

fn cmd_run_in(cmd cli.Command) ? {
	container := cmd.args[0]

	run(container, fixargs(cmd.args[1..]).join(' ')) ?
}

fn cmd_run_file(cmd cli.Command) ? {
	container := cmd.args[0]
	content := os.read_file(cmd.args[1]) ?

	mut command := content.split('\n')[1]
	if cmd.args.len > 2 {
		command += ' ' + fixargs(cmd.args[2..]).join(' ')
	}

	run(container, command) ?
}

fn run(name string, command string) ? {
	mut current := env('TB_CURRENT') or { '' }

	if !os.is_executable(path('instances', name)) {
		return error("No toolbox called '$name' was found!")
	}

	mut args := []string{}

	// If we are already inside the desired toolbox,
	// dont call toolbox a second time
	if current != name {
		args << 'run'

		if name != '' {
			args << '-c'
			args << name
		}

		args << 'env'
		args << 'TB_CURRENT=$name'

		shell := env('SHELL') ?
		args << shell
	}

	if command != '' {
		args << '-c'
		args << command

		msg("Running '$command' in toolbox '$name'")
	} else {
		msg("Entering toolbox '$name'")
	}

	if current != name {
		toolbox(args) ?
	} else {
		shell(args) ?
	}
}
