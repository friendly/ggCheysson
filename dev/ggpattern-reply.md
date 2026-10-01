Thanks, Trevor - the custom pattern idea was exactly what I needed, and the `hatch` pattern was a
great model (a name looked up in a table of specs is just what a Cheysson swatch is).

I took it one step further: instead of a single `"cheysson"` pattern with the swatch in
`pattern_type`, I register **each swatch as its own pattern**, named `"<palette>:<element>"`
(134 of them, all sharing one drawing function that reads `params$pattern`). The pattern also
paints its own paper background and has built-in line density and spacing, treating
`pattern_density` / `pattern_spacing` only as relative adjustments. So a swatch needs no geom
arguments at all, and only the `pattern` aesthetic:

```r
ggplot(trade, aes(country, exports, pattern = country)) +
  geom_col_pattern() +
  scale_cheysson2("1886_28")   # a scale_pattern_manual() returning swatch names
```

It works the same with `geom_sf_pattern()`, legend keys included:

![](https://raw.githubusercontent.com/friendly/ggCheysson/c4a1939/dev/custom-pattern/poc_simplified_map.png)

Proof of concept (~70 lines):
https://github.com/friendly/ggCheysson/blob/c4a1939/dev/custom-pattern/poc_simplified.R.
With this, I don't think I'll need a `geom_cheysson()`. I plan to build it into the next
version of ggCheysson.

A few things I'd like to check with you before I do:

1. Is registering ~130 names in `options(ggpattern_geometry_funcs = ...)` reasonable, or is there a
   cost or a better way to register a family of related patterns? (I'd append to any patterns the
   user has already registered, in `.onLoad()`.)
2. Can I rely on `params$pattern` being the pattern's name inside a geometry pattern function?
3. Is there a way to tell whether the user actually set `pattern_spacing` / `pattern_density`, as
   opposed to getting ggpattern's defaults? For now I scale relative to the defaults (0.05, 0.2).
