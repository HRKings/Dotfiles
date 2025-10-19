# A wrapper around jc to convert directly to a nu object
def jcnu [
	parser: string, # The parser name to use
	command: closure # The command passed through the pipeline to jc
] {
	do $command
		| ^jc ...[ '-u', $"--($parser)" ]
		| lines
		| each {
				from json
			}
		| flatten
}

# A wrapper around jc to convert directly to a nu object, using jc's magic syntax
def "jcnu magic" [
  command: string
] {
  ^jc ...[ '-u', $command ]
		| lines
		| each {
				from json
			}
		| flatten
}
