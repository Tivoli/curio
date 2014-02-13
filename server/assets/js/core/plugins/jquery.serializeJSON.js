(function($, window, document) {
  return $.fn.serializeJSON = function() {
    var el, field, form, form_array, json, key, keys, root, true_value, value, _i, _len;
    json = {};
    form = $(this);
    form_array = form.serializeArray();
    for (_i = 0, _len = form_array.length; _i < _len; _i++) {
      field = form_array[_i];
      keys = field.name.match(/\w+/g);
      root = json;
      el = $("[name='" + field.name + "']", form);
      true_value = el.val();
      if (el.is('[type=checkbox]') && !true_value.length) {
        true_value = el.prop('checked');
      }
      if (el.is('[type=radio]')) {
        true_value = el.filter(':checked').val();
      }
      while (key = keys.shift()) {
        value = keys.length ? {} : true_value;
        root = root[key] != null ? root[key] : root[key] = value;
      }
    }
    return json;
  };
})(jQuery, window, document);
