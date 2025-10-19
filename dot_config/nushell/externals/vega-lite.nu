source ../modules/utilities.nu

def "vega-lite build" [
  data: list<record>,
  fields: record<x: record<field: string, type: string>, y: record<field: string, type: string>>,
  mark: record = { type: "line", point: true },
] {
  let vega_lite_schema = {
    "$schema": "https://vega.github.io/schema/vega-lite/v6.json",
    "data": {
      "values": $data
    },
    "mark": $mark,
    "encoding": $fields
  }

  $vega_lite_schema | to json
}

def "vega-lite build quick" [
  data?: list<record>,
  --x_type: string = "quantitative",
  --y_type: string = "quantitative",
  --mark:  oneof<record, string> = { type: "line", point: true },
] {
  mut input = $in | default $data

  if (($input | is-empty) or (not ($input | describe | str starts-with 'list'))) {
    error make -u { msg: "No data was provided" }
  }

  let columns = ($input | columns)

  if ($columns | is-empty) {
    error make -u { msg: "Data must be a record and/or have columns" }
  }

  let x = ($columns | first)
  let y = ($columns | skip 1 | first)

  let fields = {
      "x" : {
        "field": $x,
        "type": $x_type
      },
      "y" : {
        "field": $y,
        "type": $y_type
      }
    }

    let mark = if ( ($mark | describe) == "string" ) {
      { "type": $mark }
    } else {
      $mark
    }

  vega-lite build $input $fields $mark
}



def "vega-lite render" [
  vega_lite_json?: string
  --from-path (-p): path
] {
  mut input = $in | default $vega_lite_json

  if ($from_path | is-not-empty) {
    $input = open --raw $from_path
  }

  if ($input | is-empty) {
    error make -u { msg: "No vega-lite json was provided" }
  }

  let hash = ( $input | hash blake3 )
  let svg_path = $"/tmp/vega_lite-($hash).svg"

  if (not ($svg_path | path exists)) {
    let json_path = $"/tmp/vega_lite-($hash).json"
    $input | save -f $json_path

    ^vl2svg $json_path $svg_path
  }

  ^mcat --kitty $svg_path
}
