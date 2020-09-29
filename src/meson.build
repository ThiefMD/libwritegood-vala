if get_option('shared_lib')
  libtype = 'shared_library'
else
  libtype = 'static_library'
endif

libwritegood_sources = [
  'writegood.vala',
]

libultheme = build_target('writegood',
       sources: libwritegood_sources,
  dependencies: libwritegood_deps,
   target_type: libtype,
   vala_header: 'writegood.h',
     vala_vapi: 'writegood.vapi',
   install_dir: [true, true, true],
       install: true,
)

libwritegood_dep = declare_dependency(
  include_directories: include_directories('.'),
            link_with: libwritegood,
)

pkg = import('pkgconfig')
pkg.generate(
    libraries: libwritegood,
      version: meson.project_version(),
         name: 'writegood',
  description: 'Improve your writing by removing weasel words, passive voice, and other checks.',
)
