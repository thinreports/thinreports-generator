require 'bundler'

Bundler.require
require_relative 'lib/thinreports'

params = {
  type: :section,
  layout_file: 'test.tlf',
  params: {
    groups: [
      details: [
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail },
        { id: :detail }
      ]
    ]
  }
}
Thinreports.generate(params, filename: 'test.pdf')
