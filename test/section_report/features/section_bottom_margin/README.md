# Section Bottom Margin

The bottom margin of a section is the distance between the bottom position of the section content and the bottom position of the section.

- [Example code](test_feature.rb)
- [Example template file](template.tlf)
- [Example PDF](expect.pdf)

An item whose affect-bottom-margin is disabled does not affect the calculation of the bottom margin.

![](images/bottom-margin-diagram-1.png)

In the example above, item3 does not affect the bottom margin because affect-bottom-margin is disabled.

Since the bottom position of item2 is the bottom position of the section content, the space between the bottoom position of item2 and the bottom position of the section (the gray shaded area) is the bottom margin of this section.

When auto-stretch is enabled, the section will be automatically stretched while keepking the bottom margin of the section. See [Section Auto Stretch](../section_report_section_auto_stretch/README.md) for details.
