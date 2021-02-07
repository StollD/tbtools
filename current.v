module main

import cli

fn cmd_current(cmd cli.Command) {
	c := env('TB_CURRENT') or { '' }
	println(c)
}
