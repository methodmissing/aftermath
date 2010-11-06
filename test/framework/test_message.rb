class TestFrameworkMessage < Test::Unit::TestCase
  def test_members
    assert [:product_id, :name].all?{|m| StubMessage.members.include?(m) }
  end

  def test_initialize
    m = StubMessage.new :product_id => 12, :name => 'test'
    assert_equal 12, m.product_id
    assert_equal 'test', m.name
  end

  def test_initialize_blk
    m = StubMessage.new do |sm|
      sm.product_id = 12
      sm.name = 'test'
    end
    assert_equal 12, m.product_id
    assert_equal 'test', m.name
  end

  def test_version
    assert_equal 2, StubMessage.version
  end

  def test_to_hash
    m = StubMessage.new :product_id => 12, :name => 'test'
    h = m.to_hash
    assert_equal 12, h[:product_id]
    assert_equal 'test', h[:name]
    assert_equal 'StubMessage', h[:__name__]
  end

  def test_to_handler
    assert_equal 'stub_message', StubMessage.to_handler
  end

  def test_to_json
    m = StubMessage.new :product_id => 12, :name => 'test'
    j = m.to_json
    assert_match(/product_id/, j)
    assert_match(/name/, j)
  end

  def test_reconstitute
    json = '{"product_id":12,"__name__":"StubMessage","name":"test"}'
    m = StubMessage.reconstitute(json)
    assert_equal 12, m.product_id
    assert_equal 'test', m.name
  end

  def test_inspect
    m = StubMessage.new :product_id => 12, :name => 'test'
    assert_match(/product_id/, m.inspect)
  end
end