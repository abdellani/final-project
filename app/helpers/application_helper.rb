# frozen_string_literal: true

module ApplicationHelper
  def accept_reject_pending(user_id)
    if current_user.find_friendships_pending(user_id).first &&
       current_user.find_friendships_pending(user_id).first.receiver == current_user
      link_to('Accept friendship',
                               friendship_path(id: user_id),class:'btn text-white btn-block btn-sm bg-success mt-3', method: :put) +
        link_to('Reject friendship',
                                 friendship_path(id: user_id, status: 'pending'),class:'btn text-white btn-block btn-sm bg-danger', method: :delete)
    else
      content_tag(:div, 'request pending', class:'btn btn-sm mt-3 btn-block btn-info')
    end
  end
end
