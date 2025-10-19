# Import utilities used in this file
source ../modules/utilities.nu

def "ollama serve" [
  --context-size (-c): int = 4096   # The model context size
  --quantize-kv (-q): string        # The quantization for the KV cache, this also enables Flash Attention
] {
  $env.OLLAMA_MODELS = '/mnt/Dev/AI/0-Ollama_Models'

  $env.OLLAMA_CONTEXT_LENGTH = $context_size

  $env.OLLAMA_FLASH_ATTENTION = if ( $quantize_kv | str is-blank ) { 0 } else { 1 }
  $env.OLLAMA_KV_CACHE_TYPE = if ( $quantize_kv | str is-blank ) { '' } else { $quantize_kv }

  ^ollama serve
}

def "ollama list" [
  --external (-e)
] {
	if ($external) {
    return (^ollama list | from ssv)
  }

  http get 'http://0.0.0.0:11434/api/tags' | get models
}

def "ollama ps"  [
  --external (-e)
] {
  if ($external) {
    return (^ollama ps | from ssv)
  }

	http get 'http://0.0.0.0:11434/api/ps' | get models
}
