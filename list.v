module main

import cli

fn cmd_list(cmd cli.Command) ? {
	toolbox(['list', '-c']) ?
}
