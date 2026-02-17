def "feh grid" [
  --grid_cols: int = 9
  --grid_rows: int = 9
  --max_width: int = 1280
  --max_height: int = 720
  ...images: list<path>
] {

  let grid_width = $grid_cols * $max_width
  let grid_height = $grid_rows * $max_height

  ^feh -m --thumb-width $max_width --thumb-height $max_height --limit-width $grid_width --limit-height $grid_height ...$images
}
