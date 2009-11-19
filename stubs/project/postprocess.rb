require "simple-templater/hooks/postprocess/git_repository"

hook do |generator, context|
  # simple-templater create rango --bin
  FileUtils.rm_r "bin" if context[:bin].eql?(false) # so if it just isn't specified, let it be
  # simple-templater create rango --full-name="Jakub Stastny"
  generator.after Hooks::GitRepository
end
