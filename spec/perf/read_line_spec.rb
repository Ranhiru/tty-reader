# frozen_string_literal: true

require "rspec-benchmark"

RSpec.describe TTY::Reader, "#read_line" do
  include RSpec::Benchmark::Matchers

  let(:output) { StringIO.new }

  it "reads line at most 1700x slower than gets method" do
    input = StringIO.new("abc\n")
    reader = described_class.new(input: input, output: output)

    expect {
      input.rewind
      reader.read_line
    }.to perform_slower_than {
      input.rewind
      input.gets
    }.at_most(1700).times
  end

  it "reads line allocating no more than 420 objects" do
    input = StringIO.new("abc\n")
    reader = described_class.new(input: input, output: output)

    expect {
      reader.read_line
    }.to perform_allocation(420).objects
  end
end