# encoding: utf-8

require "simple-templater/hooks/postprocess/git_repository"

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

hook do |generator, context|
  # simple-templater create rango --bin
  FileUtils.rm_r "bin" if context[:bin].eql?(false) # so if it just isn't specified, let it be
  # simple-templater create rango --full-name="Jakub Stastny"
  generator.after Hooks::GitRepository
end
