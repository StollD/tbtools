module main

import os
import cli

fn main() {
	// Make sure that all directories we need exist
	os.mkdir_all(path('exports', '')) ?
	os.mkdir_all(path('init', '')) ?
	os.mkdir_all(path('imports', '')) ?
	os.mkdir_all(path('instances', '')) ?

	// Manually split the commandline arguments
	// This is needed because launching a programm using a shebang
	// will cram all of the arguments into argv[1] instead of splitting them
	mut args := [os.args[0]]
	for arg in os.args[1..] {
		for split in arg.split(' ') {
			args << split
		}
	}

	create := cli.Command{
		name: 'create'
		execute: cmd_create
		description: 'Creates and initializes new toolbox.'
		usage: '<name> [<template>]'
		required_args: 1
		flags: [
			cli.Flag{
				flag: .string
				name: 'distro'
				abbrev: 'd'
				description: 'Create a toolbox container for a different operating system than the host.'
				global: false
				required: false
			},
			cli.Flag{
				flag: .string
				name: 'image'
				abbrev: 'i'
				description: 'Change the name of the base image used to create the toolbox container.'
				global: false
				required: false
			},
			cli.Flag{
				flag: .string
				name: 'release'
				abbrev: 'r'
				description: 'Create a toolbox container for a different operating system release than the host.'
				global: false
				required: false
			},
			cli.Flag{
				flag: .bool
				name: 'no-init'
				abbrev: 'n'
				description: 'Do not try to run an initialization script after creating the toolbox container.'
				global: false
				required: false
			},
		]
	}

	current := cli.Command{
		name: 'current'
		execute: cmd_current
		description: 'Prints the currently active toolbox.'
		required_args: 0
		disable_flags: true
	}

	delete := cli.Command{
		name: 'delete'
		execute: cmd_delete
		description: 'Removes a toolbox.'
		usage: '<name>'
		required_args: 1
		disable_flags: true
	}

	export := cli.Command{
		name: 'export'
		execute: cmd_export
		description: 'Exports a command from the current or default toolbox.'
		usage: '<name> [<command>]'
		required_args: 1
		disable_flags: true
	}

	export_from := cli.Command{
		name: 'export-from'
		execute: cmd_export_from
		description: 'Exports a command from the given toolbox.'
		usage: '<toolbox> <name> [<command>]'
		required_args: 2
		disable_flags: true
	}

	get_default := cli.Command{
		name: 'get-default'
		execute: cmd_get_default
		description: 'Prints the default toolbox.'
		required_args: 0
		disable_flags: true
	}

	host := cli.Command{
		name: 'host'
		execute: cmd_host
		description: 'Escapes from the toolbox and runs a command or a shell on the host.'
		usage: '[<command>]'
		required_args: 0
		disable_flags: true
	}

	host_file := cli.Command{
		name: 'host-file'
		execute: cmd_host_file
		description: 'Escapes from the toolbox, loads a command from a file and runs it on the host.'
		usage: '<file> [<args>]'
		required_args: 1
		disable_flags: true
	}

	imp := cli.Command{
		name: 'import'
		execute: cmd_import
		description: 'Imports a command from the host.'
		usage: '<name> [<command>]'
		required_args: 1
		disable_flags: true
	}

	list := cli.Command{
		name: 'list'
		execute: cmd_list
		description: 'Lists existing toolboxes.'
		required_args: 0
		disable_flags: true
	}

	run := cli.Command{
		name: 'run'
		execute: cmd_run
		description: 'Enters the default toolbox and runs a command or a shell in it.'
		usage: '[<command>]'
		required_args: 0
		disable_flags: true
	}

	run_in := cli.Command{
		name: 'run-in'
		execute: cmd_run_in
		description: 'Enters the given toolbox and runs a command or a shell in it.'
		usage: '<toolbox> [<command>]'
		required_args: 1
		disable_flags: true
	}

	run_file := cli.Command{
		name: 'run-file'
		execute: cmd_run_file
		description: 'Enters the given toolbox, loads a command from a file and runs it.'
		usage: '<toolbox> <file> [<command>]'
		required_args: 2
		disable_flags: true
	}

	set_default := cli.Command{
		name: 'set-default'
		execute: cmd_set_default
		description: 'Changes the default toolbox.'
		usage: '[<name>]'
		required_args: 0
		disable_flags: true
	}

	shell := cli.Command{
		name: 'shell'
		execute: cmd_shell
		description: 'Runs a shell inside of toolbox, or on the host if TB_SHELL_DISABLE is set.'
		required_args: 0
		disable_flags: true
	}

	unexport := cli.Command{
		name: 'unexport'
		execute: cmd_unexport
		description: 'Removes an exported command.'
		usage: '<name>'
		required_args: 1
		disable_flags: true
	}

	unimport := cli.Command{
		name: 'unimport'
		execute: cmd_unimport
		description: 'Removes an imported command.'
		usage: '<name>'
		required_args: 1
		disable_flags: true
	}

	mut app := cli.Command{
		name: os.args[0]
		description: 'Tools for working with Fedora Toolbox'
		version: '1.0.0'
		commands: [
			create,
			current,
			delete,
			export,
			export_from,
			get_default,
			host,
			host_file,
			imp,
			list,
			run,
			run_in,
			run_file,
			set_default,
			shell,
			unexport,
			unimport,
		]
		disable_flags: true
	}

	app.setup()
	app.parse(args)
}
