module main

import os
import cli

fn cmd_import(cmd cli.Command) ? {
	name := cmd.args[0]

	mut command := name
	if cmd.args.len > 1 {
		command = cmd.args[1..].join(' ')
	}

	im := path('imports', name)
	if os.is_executable(im) {
		return error("An import called '$name' already exists!")
	}

	exe := executable() ?

	file := '#!$exe host-file\n$command'
	os.write_file(im, file) ?
	os.posix_set_permission_bit(im, os.s_ixusr, true)
	os.posix_set_permission_bit(im, os.s_ixgrp, true)
	os.posix_set_permission_bit(im, os.s_ixoth, true)

	msg("Imported '$command' from host as '$name'")
}

fn cmd_unimport(cmd cli.Command) ? {
	name := cmd.args[0]

	im := path('imports', name)
	if !os.is_executable(im) {
		return error("No import called '$name' found!")
	}

	os.rm(im) ?
	msg("Removed import '$name'")
}
