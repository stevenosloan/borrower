module FakeStdin

  # Patch STDIN for a block
  def fake_stdin *args
    $stdin = StringIO.new
    $stdin.puts(args.shift) until args.empty?
    $stdin.rewind

    yield
  ensure
    $stdin = STDIN
  end

end