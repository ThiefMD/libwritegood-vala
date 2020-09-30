if get_option('shared_lib')
  libtype = 'shared_library'
else
  libtype = 'static_library'
endif

libwritegood_sources = [
  'writegood.vala',
  'language.vala',
  'en_us.vala'
]


confh = configuration_data ()
confh.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('datadir'), 'locale'))
confh.set_quoted('GETTEXT_PACKAGE', 'writegood')
configure_file(output : 'config.h',
  configuration : confh)

inc_libh = include_directories ('.')
inc_libh_dep = declare_dependency (include_directories : inc_libh)

libwritegood = build_target('writegood',
       sources: libwritegood_sources,
  dependencies: libwritegood_deps,
   target_type: libtype,
   vala_header: 'writegood.h',
     vala_vapi: 'writegood.vapi',
        c_args: [ '-include', meson.current_build_dir() + '/config.h', ],
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
