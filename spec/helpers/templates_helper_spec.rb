require File.dirname(__FILE__) + '/../spec_helper'

describe Templates::Helper do
  scenario :pages, :templates

  before :each do
    @page = pages(:home)
  end

  describe "template_part_field" do
    it "should output a text area from a template part with part-type of text_area" do
      should_receive(:text_area_tag).and_return('text_area')
      template_part_field(template_parts(:extended), 0).should == 'text_area'
    end

    it "should output a text field from a template part with part-type of text_field" do
      should_receive(:text_field_tag).and_return('text_field')
      template_part_field(template_parts(:tagline), 0).should == 'text_field'
    end

    it "should output a checkbox field from a template part with part-type of check_box" do
      should_receive(:check_box_tag).and_return('check_box')
      should_receive(:hidden_field_tag).and_return('hidden')
      template_part_field(template_parts(:featured), 0).should == "check_box\nhidden"
    end

    it "should output a hidden field from a template part with part-type hidden" do
      should_receive(:hidden_field_tag).and_return('hidden')
      template_part_field(template_parts(:feature_image), 0).should == 'hidden'
    end

    it "should determine the field name from the given index" do
      should_receive(:hidden_field_tag).with('part[1][content]', '', :class => 'asset', :id => 'part_1_content')
      template_part_field(template_parts(:feature_image), 1)
    end

    it "should put content from the existing part in the field" do
      should_receive(:text_area_tag).with('part[1][content]', 'Just a test.', :class => 'plain', :id => 'part_1_content')
      template_part_field(template_parts(:extended), 1)
    end

    it "should put blank content in the field if the part doesn't already exist" do
      @page.part('Tagline').should be_nil
      should_receive(:text_field_tag).with('part[1][content]', '', :class => 'text', :style => "width: 500px", :id => 'part_1_content')
      template_part_field(template_parts(:tagline), 1)
    end

    if defined?(ConcurrentDraftExtension)
      it "should output the draft content and hidden live content if concurrent_draft is enabled" do
        should_receive(:hidden_field_tag).with('part[1][content]', 'Just a test.', :id => 'part_1_content')
        should_receive(:text_area_tag).with('part[1][draft_content]', '', :class => 'plain', :id => 'part_1_draft_content')
        template_part_field(template_parts(:extended), 1, true)
      end
    end
  end
end