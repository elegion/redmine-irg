class IssueRatioGraphsController < ApplicationController

  def data
    project = Project.find(params[:project_id])
    series = IssueRatioGraphsData.get_data(project, {
      created:  { key: "Created",  color: Setting.plugin_redmine_irg["color_created"] },
      resolved: { key: "Resolved", color: Setting.plugin_redmine_irg["color_resolved"] },
      closed:   { key: "Closed",   color: Setting.plugin_redmine_irg["color_closed"] },
    })
    render json: series.values
  end

end
