require "simple-templater/hooks/preprocess/name"

hook do |generator, context|
  # simple-templater create rango --bin
  rm_r "bin" unless context[:bin]
  # simple-templater create rango --full-name="Jakub Stastny"
  generator.before Hooks::FullName
end
