# encoding: UTF-8
#
shared_examples_for "translations_management" do
  scenario "see translations keys specified in main language yaml file" do
    page.should have_content "Date > Formats > Default"
  end

  scenario "see translations provided in language files" do
    visit root_path
    page.should have_content "Hello world!"
    visit root_path(:locale => "pl")
    page.should have_content "Witaj, Świecie"
  end

  scenario "editing translations" do
    visit translations_path + "/?utf8=✓&search=&key=&group=application&translated=&commit=Submit"
    within :css, "#pl-hello-world" do
      fill_in "value", :with => "Elo ziomy"
      click_button "Save"
    end

    within :css, "#en-hello-world" do
      fill_in "value", :with => "Yo hommies"
      click_button "Save"
    end

    visit root_path
    page.should have_content("Yo hommies")
    visit root_path(:locale => "pl")
    page.should have_content("Elo ziomy")
  end

  scenario "see only all translations by default, app ones after selecting from dropdown" do
    page.should have_content("Date > Formats")
    select "Application", from: "group"
    click_button "Submit"
    page.should_not have_content("Date > Formats")
    page.should have_content("World")
  end

  scenario "paginate translations, 50 on every page" do
    page.should have_content("Date > Formats")
    click_link "2"
    page.should_not have_content("Date > Formats")
  end
end
