$.fn.validate = (status_only) ->
  form    = $(this).data('errors', 0)
  nodes   = 'input, select, textarea'
  ignored = '[type=submit], [type=image], [type=button], [type=reset], [type=hidden]'
  fields  = $(nodes, form).not(ignored)
  count   = 0
  $('.error', form).removeClass('error')
  fields.each (idx) ->
    el        = $(this)
    required  = el.attr('required')
    pattern   = if el.attr('pattern')
      new RegExp(el.attr('pattern'), 'i')
    invalid = (required and not el.val().length) or (pattern? and not pattern.test(el.val()))
    count++ if invalid
    el.toggleClass('error', invalid) unless status_only
  form.data('errors', count)
  return this
