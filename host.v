module main

import cli
import os

fn cmd_host(cmd cli.Command) ? {
	mut args := ['localhost']
	mut shell := env('SHELL') ?
	pwd := os.getwd()

	if cmd.args.len > 0 {
		shellcmd := fixargs(cmd.args).join(' ')
		shell += ' -c "$shellcmd"'
		msg("Running '$shellcmd' on host")
	} else {
		msg('Entering host shell')
	}

	args << '-q'
	args << '-t'
	args << 'cd $pwd; $shell'

	ssh(args) ?
}

fn cmd_host_file(cmd cli.Command) ? {
	mut args := ['localhost']
	mut shell := env('SHELL') ?
	pwd := os.getwd()

	content := os.read_file(cmd.args[0]) ?
	filecmd := content.split('\n')[1]
	shellcmd := fixargs(cmd.args[1..]).join(' ')

	shell += ' -c "$filecmd $shellcmd"'

	mut toprint := filecmd
	if shellcmd != '' {
		toprint += ' $shellcmd'
	}

	msg("Running '$toprint' on host")

	args << '-q'
	args << '-t'
	args << 'cd $pwd; $shell'

	ssh(args) ?
}
