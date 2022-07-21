function aperture_science_quote {
    APERTURE_SCIENCE=("I'll be honest, we're throwing science at the wall here to see what sticks. No idea what it'll do. Probably nothing."
                      "Science isn't about WHY. It's about WHY NOT."
                      "For science... We do what we MUST! Because we can."
                      "Who is ready to make some science?"
                      "Bold, persistent experimentation is the hallmark of good science.")

    selected_quote=$(shuf -n 1 -e "$APERTURE_SCIENCE[@]")

    echo $selected_quote
}

function cool_init {
  aperture_science_quote | pokemonsay -W $(tput cols)
}

# Invoke the cool init
cool_init
