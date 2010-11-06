class TestFrameworkChannel < Test::Unit::TestCase
  def test_pub_sub
    expected, buffer = [:a, :b], []
    c = Aftermath::Channel.new
    c.subscribe{|m| buffer << m }
    c << :a
    c << :b
    assert_equal expected, buffer
  end
end