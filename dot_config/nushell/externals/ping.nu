def ping [
	ip: string
	--count (-c): int
] {
	let params = []
		| append-if ( $count != null and $count > 0 ) [ -c $count ]
		| append $ip

	^ping ...$params | jc -u --ping-s | lines | each { from json }
}
