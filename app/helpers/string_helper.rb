module StringHelper
  def clean_emoji(str='')
    str=str.force_encoding('utf-8').encode
    arr_regex=[/[\u{1f600}-\u{1f64f}]/,/[\u{2702}-\u{27b0}]/,/[\u{1f680}-\u{1f6ff}]/,/[\u{24C2}-\u{1F251}]/,/[\u{1f300}-\u{1f5ff}]/]
    arr_regex.each do |regex|
      str = str.gsub regex, ''
    end
    return str
  end
end
