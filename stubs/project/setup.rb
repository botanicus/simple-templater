require "simple-templater/hooks/preprocess/full_name"

hook do |generator, context|
  # simple-templater create rango --full-name="Jakub Stastny"
  generator.before Hooks::FullName
end
