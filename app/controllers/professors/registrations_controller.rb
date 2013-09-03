# -*- coding: utf-8 -*-
class Professors::RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/professors/registrations"
  #skip_before_filter :require_no_authentication
  #before_action :authenticate_root!

  def require_no_authentication
    if professor_signed_in? && current_professor.email.to_s == "root@hanyang.ac.kr"
      return true#redirect_to new_professor_session_path, notice: "루트 만이 관리자 계정을 만들 수 있습니다."
    else
      return super
    end
  end

  # def authenticate_root!
  #   unless

  #   else
  #     return false
  #   end
  # end

end
