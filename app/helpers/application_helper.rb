# frozen_string_literal: true

module ApplicationHelper
  def accept_reject_pending(user_id)
    if current_user.find_friendships_pending(user_id).first &&
       current_user.find_friendships_pending(user_id).first.receiver == current_user
      content_tag(:li, link_to('Accept friendship',
                               friendship_path(id: user_id), method: :put)) +
        content_tag(:li, link_to('Reject friendship',
                                 friendship_path(id: user_id, status: 'pending'), method: :delete))
    else
      content_tag(:li, 'request pending')
    end
  end
end
