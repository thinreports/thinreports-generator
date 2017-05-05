# frozen_string_literal: true

module Thinreports
  module SchemaHelper
    BASIC_SCHEMA_JSON = <<-EOF
    {
      "version": "%{version}",
      "title": "Report Title",
      "report": {
        "paper-type": "A4",
        "width": 100.0,
        "height": 200.0,
        "orientation": "landscape",
        "margin": [100.0, 200.0, 300.0, 999.9]
      },
      "state": {
        "layout-guides": [
          { "type": "x", "position": 0.1 }
        ]
      },
      "items": [
        { "type": "rect", "id": "rect_with_id", "display": true },
        { "type": "text-block", "id": "text_block", "x": 100.0, "y": 100.0, "value": "", "display": true },
        { "type": "text-block", "id": "text_block_referenced", "x": 100.0, "y": 100.0, "value": "", "display": true, "reference-id": "text_block" },
        { "type": "text-block", "id": "text_block_hidden", "x": 100.0, "y": 100.0, "value": "default value", "display": false },
        { "type": "image-block", "id": "image_block", "x": 200.0, "y": 200.0, "width": 150.0, "height": 150.0, "value": "", "display": true },
        {
          "type": "list",
          "id": "default",
          "x": 1.0,
          "y": 2.0,
          "display": true,
          "width": 200.0,
          "content-height": 300,
          "auto-page-break": true,
          "header": {
            "enabled": true,
            "height": 10.0,
            "items": []
          },
          "detail": {
            "height": 70.0,
            "items": [
              { "type": "text-block", "id": "name", "value": "" }
            ]
          },
          "page-footer": {
            "enabled": true,
            "items": [],
            "height": 30.0
          },
          "footer": {
            "enabled": true,
            "items": [],
            "height": 40.0
          }
        }
      ]
    }
EOF

  LIST_NO_HEADER_SCHEMA_JSON = <<-EOF
  {
    "version": "%{version}",
    "title": "Report Title",
    "report": {
      "paper-type": "A4",
      "width": 100.0,
      "height": 200.0,
      "orientation": "landscape",
      "margin": [100.0, 200.0, 300.0, 999.9]
    },
    "state": {
      "layout-guides": []
    },
    "items": [
      {
        "type": "list",
        "id": "default",
        "x": 1.0,
        "y": 2.0,
        "display": true,
        "header": {
          "enabled": false,
          "height": 10.0,
          "items": []
        },
        "width": 200.0,
        "content-height": 300,
        "auto-page-break": true,
        "detail": {
          "height": 20.0,
          "items": [
            { "type": "text-block", "id": "name", "value": "" }
          ]
        },
        "page-footer": {
          "enabled": true,
          "items": [],
          "height": 30.0
        },
        "footer": {
          "enabled": true,
          "items": [],
          "height": 40.0
        }
      }
    ]
  }
EOF

    def layout_file(options = {})
      schema_version = options[:version] || Thinreports::VERSION
      schema_json = options[:schema] || BASIC_SCHEMA_JSON

      Tempfile.open %w( test-thinreports-layout .tlf ) do |file|
        file.puts (schema_json % { version: schema_version })
        file
      end
    end
  end
end
