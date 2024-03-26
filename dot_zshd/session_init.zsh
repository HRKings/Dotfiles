function quote {
    APERTURE_SCIENCE=("I'll be honest, we're throwing science at the wall here to see what sticks. No idea what it'll do. Probably nothing."
                      "Science isn't about WHY. It's about WHY NOT."
                      "For science... We do what we MUST! Because we can."
                      "Who is ready to make some science?"
                      "Bold, persistent experimentation is the hallmark of good science."
                      )
    OTHER_QUOTES=("The master has failed more times than the beginner has even tried."
                  "The art isn't the art. The art is never the art. The art is the thing that happens inside you when you make it."
                  "The society that separates its scholars from its warriors will have its thinking done by cowards and its fighting by fools."
                )

    selected_quote=$(shuf -n 1 -e "$APERTURE_SCIENCE[@]" "$OTHER_QUOTES[@]")

    echo $selected_quote
}

function cool_init {
  quote | pokemonsay -W $(tput cols)
}

# Invoke the cool init
cool_init
