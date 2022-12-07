---
editor_options:
  markdown:
    wrap: 72
    canonical: true
---

TODO: New title of R3advancedProject

# AdvancedR3:

TODO: Complete exercise 5.15 of R3advanced

# Brief description of folder and file contents

TODO: As project evolves, add brief description of what is inside the
data, doc and R folders.

The following folders contain:

-   `data/`: formatted data
-   `doc/`: lesson R markdown
-   `R/`: functions

# Installing project R package dependencies

If dependencies have been managed by using
`usethis::use_package("packagename")` through the `DESCRIPTION` file,
installing dependencies is as easy as opening the `AdvancedR3.Rproj`
file and running this command in the console:

    # install.packages("remotes")
    remotes::install_deps()

You'll need to have remotes installed for this to work.

# Resource

For more information on this folder and file workflow and setup, check
out the [prodigenr](https://rostools.github.io/prodigenr) online
documentation.
