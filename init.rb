require 'issue_ratio_graphs_hook_listener'

Redmine::Plugin.register :redmine_irg do
  name 'Redmine Issue Ratio Graphs plugin'
  author 'e-Legion'
  description 'A plugin for Redmine that provides useful charts on different issue statuses ratios.'
  version '0.0.1'
  url 'https://github.com/elegion/redmine-irg'
  author_url 'http://e-legion.com/'

  settings partial: "issue_ratio_graphs/settings", default: {
    resolved_ids: [],
    graph_height: 300,
    color_created: "rgba(204, 0, 0, 1)",
    color_resolved: "rgba(52, 101, 164, 1)",
    color_closed: "rgba(115, 210, 22, 1)",
  }
  project_module :issue_ratio_graphs do
    permission :view_graphs, { issue_ratio_graphs: :data }, public: true
  end
end
