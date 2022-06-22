-- Convert all links of *.md to *.html, see build-notes
function Link(el)
  el.target = string.gsub(el.target, "%.md", ".html")
  return el
end
