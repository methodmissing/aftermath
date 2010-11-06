class TestAftermath < Test::Unit::TestCase
  def test_uuid
    assert_equal 32, Aftermath.uuid.size
  end
end