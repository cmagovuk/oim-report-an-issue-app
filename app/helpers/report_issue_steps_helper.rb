module ReportIssueStepsHelper
  ORG_STEPS = %w[reporting_as org_name postcode org_area org_sector issue issue_areas supporting_documents contact_details summary].freeze
  IND_STEPS = %w[reporting_as postcode issue issue_areas supporting_documents contact_details summary].freeze

  def step_model
    sub_class = begin
      "ReportIssue::#{step.camelcase}".constantize
    rescue StandardError
      ReportIssue
    end
    # @step_model ||= sub_class.find(params[:report_issue_id])
    @step_model ||= sub_class.find(session[:issue_id])
  end

  def step_set
    if step_model.individual_reporting?
      IND_STEPS
    else
      ORG_STEPS
    end
  end

  def step
    @step ||= params[:id].to_s.downcase
  end

  def step_valid?
    step_set.include? step if step.present?
  end

  def next_step
    if completed_steps?
      step_set.last unless step == step_set.last
    else
      current_step_index = step_set.index(step)
      step_set[current_step_index + 1]
    end
  end

  def previous_step
    if completed_steps?
      step_set.last unless step == step_set.last
    else
      current_step_index = step_set.index(step)
      previous_step_index = current_step_index - 1
      previous_step_index.negative? ? nil : step_set[previous_step_index]
    end
  end

  def first_step
    ORG_STEPS.first
  end

  def step_path(step)
    edit_report_issue_step_path(step)
  end

  def first_step_path
    step_path(first_step)
  end

  def previous_step_path
    if previous_step
      step_path(previous_step)
    else
      root_path
    end
  end

  def next_step_path
    if next_step
      step_path(next_step)
    end
  end

  def truncate_text(text)
    truncate(text, separator: " ", length: 260)
  end

  def get_filenames(active_storage_attachments)
    get_filenames = []
    if active_storage_attachments.attached?
      active_storage_attachments.each do |single|
        get_filenames.push(single.filename)
      end
    else
      get_filenames.push(t("report_issue_steps.summary.no_files"))
    end
    get_filenames
  end

  def completed_steps?
    uncompleted_steps.empty?
  end

  def uncompleted_steps
    step_set[0..-2].difference(step_model.completed_steps)
  end

  def missed_step
    uncompleted_steps[0]
  end
end
