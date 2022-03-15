context("15-make_index()")


# Errors ------------------------------------------------------------------

test_that(
  "raises error whwen scheme wrong",
  {
    expect_error(
      object = make_index(
        scheme = letters
      ),
      regexp = "no applicable method for 'make_index' applied to an object of class"
    )
  }
)

# Creation Index.md -------------------------------------------------------


fn <- tempfile()
dir.create(fn)

test_that(
  "returns index as expected",
  {
    skip_on_os("windows")
    expect_known_output(
      object = (make_index.dmdSchemeSet(
        scheme = dmdScheme_example(),
        path = fn,
        overwrite = FALSE,
        template = scheme_path_index_template(),
        author = "Peter Tester",
        make = NULL,
        pandoc_bin = "pandoc",
        pandoc_args = "-s"
      )),
      print = TRUE,
      update = TRUE,
      file = "ref-16-make_index.txt"
    )
  }
)

test_that(
  "raises error as output exists",
  {
    skip_on_os("windows")
    expect_error(
      object = make_index.dmdSchemeSet(
        scheme = dmdScheme_example(),
        path = fn,
        overwrite = FALSE,
        template = scheme_path_index_template(),
        author = "Peter Tester",
        make = NULL,
        pandoc_bin = "pandoc",
        pandoc_args = "-s"
      ),
      regexp = "index.md does Exist!"
    )
  }
)

unlink(fn)



