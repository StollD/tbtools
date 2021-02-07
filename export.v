module main

import os
import cli

fn cmd_export(cmd cli.Command) ? {
	name := cmd.args[0]

	mut command := name
	if cmd.args.len > 1 {
		command = cmd.args[1..].join(' ')
	}

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

	export(name, command, container) ?
}

fn cmd_export_from(cmd cli.Command) ? {
	container := cmd.args[0]
	name := cmd.args[1]

	mut command := name
	if cmd.args.len > 2 {
		command = cmd.args[2..].join(' ')
	}

	export(name, command, container) ?
}

fn export(name string, command string, container string) ? {
	export := path('exports', name)
	if os.is_executable(export) {
		return error("An export called '$name' already exists!")
	}

	if !os.is_executable(path('instances', container)) {
		return error("No toolbox called '$container' found!")
	}

	exe := executable() ?

	file := '#!$exe run-file $container\n$command'
	os.write_file(export, file) ?
	os.posix_set_permission_bit(export, os.s_ixusr, true)
	os.posix_set_permission_bit(export, os.s_ixgrp, true)
	os.posix_set_permission_bit(export, os.s_ixoth, true)

	msg("Exported '$command' from '$container' as '$name'")
}

fn cmd_unexport(cmd cli.Command) ? {
	name := cmd.args[0]

	export := path('exports', name)
	if !os.is_executable(export) {
		return error("No export called '$name' found!")
	}

	os.rm(export) ?
	msg("Removed export '$name'")
}
