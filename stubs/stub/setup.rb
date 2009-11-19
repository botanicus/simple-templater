# encoding: utf-8

# === Options ===
# --flat | --no-flat
# --full | --no-full
# --setup-hook | --no-setup-hook
# --postprocess-hook | --no-postprocess-hook

hook do |generator, context|
  context[:boolean] = {true => "yes", false => "no"}
  context[:full] = true  unless context.has_key?(:full)
  context[:flat] = false unless context.has_key?(:flat)
  context[:setup_hook] = true unless context.has_key?(:setup_hook)
  context[:postprocess_hook] = true unless context.has_key?(:postprocess_hook)
end
