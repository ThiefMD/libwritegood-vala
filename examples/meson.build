if get_option('enable_examples')

  example_deps = libwritegood_deps + [ libwritegood_dep ]+ [ dependency('gtk+-3.0'), dependency('gtksourceview-3.0'), ]

  executable('hello-writegood', 'hello-writegood.vala',
    dependencies: example_deps,
         install: false
  )

endif
