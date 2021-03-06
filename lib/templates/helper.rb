module Templates::Helper

  def template_part_field(template_part, index, drafts_enabled = false)
    field_html = []
    if drafts_enabled
      live_part_content = @page.part(template_part.name).content rescue ''
      live_field_name = "part[#{index}][content]"
      live_field_id = "part_#{index}_content"      
      part_content = @page.part(template_part.name).draft_content rescue ''
      field_name = "part[#{index}][draft_content]"
      field_id = "part_#{index}_draft_content"
      field_html << hidden_field_tag(live_field_name, h(live_part_content), :id => live_field_id)
    else
      part_content = @page.part(template_part.name).content rescue ''
      field_name = "part[#{index}][content]"
      field_id = "part_#{index}_content"
    end
    
    options = {:class => template_part.part_type.field_class, 
               :style => template_part.part_type.field_styles,
               :id => field_id}.reject{ |k,v| v.blank? }

    case template_part.part_type.field_type
      when "text_area"
        field_html << text_area_tag(field_name, h(part_content), options)

      when "text_field"
        field_html << text_field_tag(field_name, h(part_content), options)

      when "check_box"
        field_html << check_box_tag(field_name, "true", part_content =~ /true/, options)
        field_html << hidden_field_tag(field_name, "false", :id => "part_#{index}_content_hidden")

      when "hidden"
        field_html << hidden_field_tag(field_name, part_content, options)
    end

    field_html.join("\n")
  end

end
