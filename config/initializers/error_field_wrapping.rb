# frozen_string_literal: true

ActionView::Base.field_error_proc = Proc.new do |html_tag|
  html_tag if html_tag.match? /^<label|<input/
end
