# Section Parameter

Some properties in the definition of each section can be changed by parameters.

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

## Display

Headers and footers can be shown or hidden with the display property.

```
header_and_footer: {
  display: Boolean
}
```

## Minimum height

The min_height property can be used to set the minimum height of a section.

```
header_and_footer: {
  min_height: Number
}
```

```
{
  id: :detail,
  min_height: Number
}
```
