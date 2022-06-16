project('writegood', ['vala', 'c'],
  default_options: [
    'default_library=shared',
  ],
  version: '0.0.1'
)

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gtk3_dep = dependency('gtk4')

libwritegood_deps = [
  glib_dep,
  gobject_dep,
  gtk3_dep
]

subdir('vapi')
subdir('src')
subdir('examples')
