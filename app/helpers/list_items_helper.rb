module ListItemsHelper
  def completed_class(list_item)
    (list_item.completed?)? 'completed-item' : ''
  end
  
  def item_owner_section(list_item, &block)
    if current_user.id == list_item.user_id
      content_tag(:div, :class => 'completed-item-link', &block)
    end
  end

  def toggle_completed_text(list_item)
    (list_item.completed)? 'Mark not Completed' : 'Mark as Completed'
  end
end
