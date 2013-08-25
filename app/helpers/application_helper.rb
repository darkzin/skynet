# -*- coding: utf-8 -*-
module ApplicationHelper
  def link_to_add_fields(name, f, parent, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(parent.to_s + "/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-primary", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def time_localize_dateTime(time)
    time.localtime.strftime("%Y년 %-m월 %-d일, %H시 %M분")
  end

  def time_localize_date(time)
    time.localtime.strftime("%Y년 %-m월 %-d일")
  end

  def multiple_file_supported?
    browser.modern? && (not browser.ie9?)
  end

end
