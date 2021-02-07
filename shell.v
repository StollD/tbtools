module main

import cli

fn cmd_shell(cmd cli.Command) ? {
	disable := env('TB_SHELL_DISABLE') or { '' }
	if disable != '' {
		shell([]string{}) ?
	}

	cmd_run(cmd) ?
}
