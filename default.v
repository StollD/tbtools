module main

import os
import cli

fn cmd_get_default(cmd cli.Command) ? {
	default := path('', 'default')
	if !os.is_file(default) {
		return error('No default toolbox set! Did you create one using tbtools?')
	}

	name := os.read_file(default) ?
	println(name)
}

fn cmd_set_default(cmd cli.Command) ? {
	name := cmd.args[0]

	default := path('', 'default')
	instance := path('instances', name)

	if !os.is_file(instance) {
		return error("No toolbox called '$name' was found!")
	}

	os.write_file(default, name) ?
	msg("Changed default toolbox to '$name'")
}
