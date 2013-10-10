class IssueRatioGraphsHookListener < Redmine::Hook::ViewListener
  def view_projects_show_left(context = {})
    if context[:project].module_enabled?(:issue_ratio_graphs)
      context[:hook_caller].send(:render, {
        partial: "issue_ratio_graphs/view_project_show_left",
        locals: context
      })
    end
  end
end
