module main

import cli
import os

fn cmd_delete(cmd cli.Command) ? {
	name := cmd.args[0]

	instance := path('instances', name)
	if !os.exists(instance) {
		return error("Toolbox '$name' does not exist!")
	}

	msg("Removing toolbox '$name'")

	os.rm(instance) ?
	toolbox(['rm', '-f', name]) ?
}
