module main

import os
import term

fn path(dir string, name string) string {
	return os.join_path(os.home_dir(), '.local', 'share', 'tbtools', dir, name)
}

fn msg(text string) {
	mut colored := term.bright_yellow('==>')
	colored += ' '
	colored += text

	println(term.bold(colored))
}

fn fork() ?bool {
	pid := os.fork()

	if pid == -1 {
		return error('fork() failed!')
	}

	if pid == 0 {
		return true
	}

	os.wait()
	return false
}

fn env(var string) ?string {
	value := os.getenv(var)
	if value == '' {
		return error('Failed to get $var')
	}

	return value
}

fn toolbox(args []string) ? {
	toolbox := os.find_abs_path_of_executable('toolbox') ?
	os.execvp(toolbox, args) ?
}

fn ssh(args []string) ? {
	ssh := os.find_abs_path_of_executable('ssh') ?
	os.execvp(ssh, args) ?
}

fn shell(args []string) ? {
	shell := env('SHELL') ?
	os.execvp(shell, args) ?
}

fn find_in_path(exe string) ?string {
	path := env('PATH') ?
	for p in path.split(':') {
		test := os.join_path(p, exe)
		if os.is_file(test) && os.is_executable(test) {
			return test
		}
	}

	return ''
}

fn executable() ?string {
	exe := os.file_name(os.executable())
	return find_in_path(exe)
}

fn fixargs(input []string) []string {
	mut out := []string{}
	for arg in input {
		if arg == '' {
			out << '""'
		} else {
			out << arg
		}
	}
	return out
}
