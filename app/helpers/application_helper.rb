module ApplicationHelper
  def pluralise(string, count)
    case count
    when 0 then "aucun #{string}"
    when 1 then "#{count} #{string}"
    else "#{count} #{string}s"
    end
  end
end
