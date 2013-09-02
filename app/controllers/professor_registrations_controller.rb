# -*- coding: utf-8 -*-
class ProfessorRegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/professors"
  skip_before_filter :require_no_authentication
  before_action :authenticate_root!

  def authenticate_root!
    unless professor_signed_in? && current_professor.name.to_s == "root@hanyang.ac.kr"
      redirect_to new_professor_session_path, notice: "루트 만이 관리자 계정을 만들 수 있습니다."
    end
  end

end
