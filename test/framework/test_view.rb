class TestFrameworkView < Test::Unit::TestCase
  def setup
    ProductView.repository.clear
  end

  def test_repository
    r = ProductView.repository
    assert_instance_of Hash, r
    ProductView.repository = {}
    assert_not_equal r.object_id, ProductView.repository.object_id
  end

  def test_find
    ProductView.repository[:a] = :b
    assert_equal :b, ProductView.find(:a)
  end

  def test_filter
    ProductView.repository[:a] = :b
    assert_equal [:b], ProductView.filter
  end
end