# PDF
[![Build Status](https://travis-ci.org/andrewtimberlake/elixir-pdf.svg?branch=master)](https://travis-ci.org/andrewtimberlake/elixir-pdf)

The missing PDF library for Elixir.

## Usage

```elixir
PDF.build([size: :a4, compress: true], fn pdf ->
  pdf
  |> PDF.set_info(title: "Demo PDF")
  |> PDF.set_font("Helvetica", 10)
  |> PDF.text_at({200,200}, "Welcome to PDF")
  |> PDF.write_to("test.pdf")
end)
```

## Installation

Add `pdf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:pdf, "~> 0.3"}]
end
```
