_.mixin
  isEmail: (string) ->
    return false unless _(string).isString()
    /^[a-z0-9_.%+\-]+@[0-9a-z.\-]+\.[a-z]{2,6}$/i.test(string)

  isUsername: (string) ->
    return false unless _(string).isString()
    /^[\w\d\.-]{1,15}$/i.test(string)

  isName: (string) ->
    return false unless _(string).isString()
    /^[\u00c0-\u01ff'\w\d\s\.\-]{3,}$/i.test(string)

  isObjectID: (string) ->
    /[0-9a-f]{24}/.test(string)

  isSlug: (string) ->
    return false unless _(string).isString()
    /^[a-z0-9-]+$/.test(string)

  isISODate: (string) ->
    return false unless _(string).isString()
    /^(\d{4})(?:-?W(\d+)(?:-?(\d+)D?)?|(?:-(\d+))?-(\d+))(?:[T ](\d+):(\d+)(?::(\d+)(?:\.(\d+))?)?)?(?:Z(-?\d*))?$/.test(string)

  toSlug: (string) ->
    string.trim()
      .toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^a-z0-9-]/g, '')
      .replace(/-+/g, '-')

  formatCurrency: (num) ->
    num     = num.toString()
    dollars = num.slice(0, -2)
    cents   = num.slice(-2)
    dollars = dollars.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    "$#{dollars}.#{cents}"
