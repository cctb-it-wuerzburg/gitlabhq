require 'spec_helper'

feature 'Projects > Members > Sorting', feature: true do
  let(:master)    { create(:user, name: 'John Doe') }
  let(:developer) { create(:user, name: 'Mary Jane', last_sign_in_at: 5.days.ago) }
  let(:project)   { create(:empty_project, namespace: master.namespace, creator: master) }

  background do
    create(:project_member, :developer, user: developer, project: project, created_at: 3.days.ago)

    gitlab_sign_in(master)
  end

  scenario 'sorts alphabetically by default' do
    visit_members_list(sort: nil)

    expect(first_member).to include(master.name)
    expect(second_member).to include(developer.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Name, ascending')
  end

  scenario 'sorts by access level ascending' do
    visit_members_list(sort: :access_level_asc)

    expect(first_member).to include(developer.name)
    expect(second_member).to include(master.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Access level, ascending')
  end

  scenario 'sorts by access level descending' do
    visit_members_list(sort: :access_level_desc)

    expect(first_member).to include(master.name)
    expect(second_member).to include(developer.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Access level, descending')
  end

  scenario 'sorts by last joined' do
    visit_members_list(sort: :last_joined)

    expect(first_member).to include(master.name)
    expect(second_member).to include(developer.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Last joined')
  end

  scenario 'sorts by oldest joined' do
    visit_members_list(sort: :oldest_joined)

    expect(first_member).to include(developer.name)
    expect(second_member).to include(master.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Oldest joined')
  end

  scenario 'sorts by name ascending' do
    visit_members_list(sort: :name_asc)

    expect(first_member).to include(master.name)
    expect(second_member).to include(developer.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Name, ascending')
  end

  scenario 'sorts by name descending' do
    visit_members_list(sort: :name_desc)

    expect(first_member).to include(developer.name)
    expect(second_member).to include(master.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Name, descending')
  end

  scenario 'sorts by recent sign in', :redis do
    visit_members_list(sort: :recent_sign_in)

    expect(first_member).to include(master.name)
    expect(second_member).to include(developer.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Recent sign in')
  end

  scenario 'sorts by oldest sign in', :redis do
    visit_members_list(sort: :oldest_sign_in)

    expect(first_member).to include(developer.name)
    expect(second_member).to include(master.name)
    expect(page).to have_css('.member-sort-dropdown .dropdown-toggle-text', text: 'Oldest sign in')
  end

  def visit_members_list(sort:)
    visit namespace_project_project_members_path(project.namespace.to_param, project, sort: sort)
  end

  def first_member
    page.all('ul.content-list > li').first.text
  end

  def second_member
    page.all('ul.content-list > li').last.text
  end
end
