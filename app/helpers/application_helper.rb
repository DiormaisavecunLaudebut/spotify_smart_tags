module ApplicationHelper
  def pluralise(string, count)
    count > 1 ? "#{count} #{string}s" : "aucun #{string}"
  end
end
