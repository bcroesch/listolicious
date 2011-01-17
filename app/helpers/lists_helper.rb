module ListsHelper
  def checked(list)
    return list.private ? 'checked="true"' : ''
  end
end
