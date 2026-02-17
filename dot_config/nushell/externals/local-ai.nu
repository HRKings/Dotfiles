# Import utilities used in this file
source ../modules/utilities.nu

# Inference =========================================================================================================================

def "llamacpp list gguf" [] {
  ^fd -ae gguf . '/mnt/Dev/AI/1-LLM-Models/' | lines
}

def "llamacpp get gguf" [] {
  llamacpp list gguf | sk --format={ path parse | get stem}
}

def "llamacpp get model-template" [] {
  ^fd -ae yaml . '/mnt/Dev/AI/llama.cpp/model-files/' | lines | sk --format={ path parse | get stem} --preview={ open $in }
}

def "llamacpp serve" [
  model: path                      # The model GGUF file to load
  --alias (-a): string             # The model name to present in the API
  --server_binary (-s): path = '/mnt/Dev/AI/llama.cpp/source/build/bin/llama-server' # The binary for the llama.cpp server
  --context-size (-c): int = 8192   # The model context size
  --gpu-layers (-g): int = -1       # The number of GPU layers to use
  --unified-memory (-u)             # If the GPU memory should "spill" to the VRAM instead of crashing CUDA
  --quantize-kv (-q): string        # The quantization for the KV cache, this also enables Flash Attention
  --context-shift (-k): int = 0     # Amount of tokens to reuse for the cache, similar to ContextShift of koboldcpp
  --swa-full                        # Enable full SWA caching (this may disable a bunch of other things)
  --metrics                         # Enable Prometheus metrics endpoint
  --rerank                          # Enable the reranking endpoint (enables embedding and pooling rank)
  --embedding                       # Enable the embedding only mode
  --chat-template: path             # Jinja chat template file location
  --mmproj: path                    # Path to the mmproj file for multimodal capabilities
  --mmproj-cpu                      # Disable mmproj offload
  --port: int = 5000                # The port for the server to listen on
  --override-tensors-device: string # Regex to override to which device the tensors should load
  --use-embedded-template           # Use the embedded chat template on the GGUF (the `--jinja`) option
  --cpu-moe: int = 0                # The amount of MoE experts to keep in the CPU
] {
  $env.LD_LIBRARY_PATH = ( $server_binary | path parse | get parent )

  if ($unified_memory) {
    print ("Using unified memory!" | ansi once yellow_bold)
    $env.GGML_CUDA_ENABLE_UNIFIED_MEMORY = 1
  }

  let quantization = if ( $quantize_kv | str is-blank ) { [] } else { [ "--flash-attn" "on" "-ctk" $quantize_kv "-ctv" $quantize_kv ] }
  let caching = if ($context_shift > 0) { [ "--cache-reuse" $context_shift ] } else { [] }
  let metrics = if ( $metrics ) { [ "--metrics" ] } else { [] }
  let alias = if ( $alias | str is-blank ) { [] } else { [ "--alias" $alias ] }
  let chat_template = if ( $chat_template | str is-blank ) { [] } else { [ "--jinja" "--chat-template-file" $chat_template ] }
  let rerank = if ( $rerank | default false ) { [ "--reranking"] } else { [] }
  let embedding = if ( $embedding | default false ) { [ "--embedding"] } else { [] }
  let swa = if ( $swa_full | default false ) { [ "--swa-full"] } else { [] }
  let mmproj = if ( $mmproj | str is-blank ) { [] } else { [ "--mmproj" $mmproj ] }
  if ( not ($mmproj | is-empty) and ($mmproj_cpu | default false) ) { $mmproj | append "--no-mmproj-offload" }
  let use_embedded_template = if ( $use_embedded_template | default true ) { []  } else { [ "--jinja" ] }

  let override_tensors = if ( $override_tensors_device | str is-blank ) { [] } else { [ "--override-tensor" $override_tensors_device ] }

  (^($server_binary) --log-colors "on"
    --log-prefix --log-timestamps
    -m $model
    --threads ((sys cpu | get name | length) / 2)
    --gpu_layers $gpu_layers
    --ctx_size $context_size
    --port $port
    --mlock # Keep in RAM
    --n-cpu-moe $cpu_moe
    ...$quantization
    ...$caching
    ...$alias
    ...$mmproj
    ...$chat_template
    ...$swa
    ...$metrics
    ...$rerank
    ...$embedding
    ...$override_tensors
    ...$use_embedded_template)
}

def "llamacpp serve template" [
  template_file: path
  --metrics (-m)                      # Override the metrics option of LLamma.cpp
  --unified-memory (-u)               # Override the unified-memory option of LLamma.cpp
  --chat-template-override (-t): path # Override the chat template being used
  --context-size-override (-c): int   # Override the amount of context the model has
  --disable-unified-memory            # Force disable the unified-memory option of LLamma.cpp
  --disable-tensor-override           # Force disable the tensor override option of LLamma.cpp
  --override-swa ? = null              # Override SWA context
  --port: int = 5000                  # The port for the server to listen on
] {
  let template = (open $template_file)

  let can_enable_unified_memory = not $disable_unified_memory
  let enable_unified_memory = $can_enable_unified_memory and ( ( $unified_memory ) or ($template | get -o unified_memory) )

  let chat_template_to_use = if ( $chat_template_override | str is-blank ) { $template | get -o chat_template } else { $chat_template_override }

  let context_size = if ( ($context_size_override | default 0) > 0 ) { $context_size_override } else { $template | get -o context }

  let tensor_override = if $disable_tensor_override { "" } else { ($template | get -o override_tensors_device) }

  let enable_swa = ( $override_swa | default ($template | get -o swa_full | default false) )


  (llamacpp serve $"($template | get model_path)"
    --alias=($template | get -o model_alias)
    --context-size=($context_size)
    --gpu-layers=($template | get -o gpu_layers)
    --quantize-kv=($template | get -o kv_quantization)
    --context-shift=($template | get -o context_shift)
    --rerank=($template | get -o rerank)
    --embedding=($template | get -o embedding)
    --mmproj=($template | get -o mmproj_path)
    --mmproj-cpu=($template | get -o disable_mmproj_offload)
    --chat-template=($chat_template_to_use)
    --unified-memory=($enable_unified_memory)
    --swa-full=($enable_swa)
    --metrics=($metrics)
    --port=($port)
    --override-tensors-device=($tensor_override)
  )
}

# Tools =========================================================================================================================

def "hf download model" [repo: string, ...files] {
  $env.HF_HOME = "/mnt/Dev/AI/1-LLM-Models/.cache/huggingface"
  mkdir $repo
  ^hf download --cache-dir "/mnt/Dev/AI/1-LLM-Models/.cache/huggingface" --local-dir $repo $repo ...$files
}

def "llamacpp generate commit-message" [
  --staged (-s)
] {
  let staged = if ($staged) { ["--staged"] } else { [] }

  let prompt = ($"<|start_header_id|>system<|end_header_id|>
    ```diff
      (^git diff ...$staged | to text)
    ```<|eot_id|>
    <|start_header_id|>user<|end_header_id|>
    Generate a very short commit message that best describes the changes made.
    <|eot_id|>
    <|start_header_id|>assistant<|end_header_id|>
    ")


  let response = http post --content-type application/json http://localhost:5000/completion { prompt: $prompt, n_predit: 1024, stream: false }

  print ($response | get content)
}
