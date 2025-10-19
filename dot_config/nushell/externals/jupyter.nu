def "jupyter kernelspec list" [] {
	^jupyter kernelspec list
		| lines | each { parse '  {kernel} {path}' }
		| flatten | each { str trim }
}
