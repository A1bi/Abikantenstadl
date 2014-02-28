module SnippetsHelper
  def can_edit?(snippet)
    (@_user.admin? || snippet.user == @_user) && !locked?
  end
end