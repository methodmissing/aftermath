String.class_eval do
  def to_underscore!
    (gsub!(/(.)([A-Z])/,'\1_\2') || self).gsub(/\s/,'').downcase!
  end

  def to_underscore
    clone.to_underscore!
  end
end