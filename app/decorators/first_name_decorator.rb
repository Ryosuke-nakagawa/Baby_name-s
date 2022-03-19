class FirstNameDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.group.last_name} #{object.name}"
  end
end
