if get_option('enable_examples')

  example_deps = libwritegood_deps + [ libwritegood_dep ]+ [ dependency('gtk4'), dependency('gtksourceview-5'), ]

  executable('hello-writegood', 'hello-writegood.vala',
    dependencies: example_deps,
         install: false
  )

endif
